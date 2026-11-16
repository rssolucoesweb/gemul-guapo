/* =====================================================================
   GUAPÓ - rodar no banco de GUAPÓ (mesmo script usado em Anápolis em 10/11/2026)
   Notas/faltas do ANO ANTERIOR penduradas em disciplinas de turma do ANO SEGUINTE
   (ex.: registro com ano_letivo 2026 numa disciplina da turma 2027 da renovação).

   Origem: as telas de lançamento (notas, faltas disciplinares, ajuste de faltas) criavam a
   "matriz" com o ano da sessão para TODAS as disciplinas do aluno, inclusive as da turma
   renovada; o acumulado das faltas diárias (por aluno/disciplina/ano) copiava o valor de 2026
   para elas. O registro verdadeiro de 2026 continua na disciplina da turma de 2026.
   Esses registros bloqueavam a exclusão da renovação ("já tem lançamentos em 2027").

   @Gravar = 0 só lista | 1 = copia para tabelas de backup e apaga. Pode rodar mais de uma vez.
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO
DECLARE @Gravar BIT = 0;   -- 0 = só mostra | 1 = apaga (com backup)

IF OBJECT_ID('tempdb..#NF') IS NOT NULL DROP TABLE #NF;
IF OBJECT_ID('tempdb..#NP') IS NOT NULL DROP TABLE #NP;

SELECT NF.codigo INTO #NF
FROM SCA_NOTAS_FALTAS NF
INNER JOIN SCA_ALUNO_DISCIPLINA AD ON AD.CODIGO = NF.cod_aluno_disciplina
INNER JOIN SCA_TURMA T ON T.Cod_Turma = AD.COD_TURMA
WHERE NF.ano_letivo < T.AnoLetivo;

SELECT NP.codigo INTO #NP
FROM SCA_NOTAS_PLANILHA NP
INNER JOIN SCA_ALUNO_DISCIPLINA AD ON AD.CODIGO = NP.cod_aluno_disciplina
INNER JOIN SCA_TURMA T ON T.Cod_Turma = AD.COD_TURMA
WHERE NP.ano_letivo < T.AnoLetivo;

-- Conferência: quantos e por ano
SELECT 'SCA_NOTAS_FALTAS' AS tabela, NF.ano_letivo, T.AnoLetivo AS ano_turma, COUNT(*) AS qtde,
       COUNT(DISTINCT NF.cod_aluno) AS alunos
FROM SCA_NOTAS_FALTAS NF
INNER JOIN #NF X ON X.codigo = NF.codigo
INNER JOIN SCA_ALUNO_DISCIPLINA AD ON AD.CODIGO = NF.cod_aluno_disciplina
INNER JOIN SCA_TURMA T ON T.Cod_Turma = AD.COD_TURMA
GROUP BY NF.ano_letivo, T.AnoLetivo
UNION ALL
SELECT 'SCA_NOTAS_PLANILHA', NP.ano_letivo, T.AnoLetivo, COUNT(*), COUNT(DISTINCT NP.cod_aluno)
FROM SCA_NOTAS_PLANILHA NP
INNER JOIN #NP X ON X.codigo = NP.codigo
INNER JOIN SCA_ALUNO_DISCIPLINA AD ON AD.CODIGO = NP.cod_aluno_disciplina
INNER JOIN SCA_TURMA T ON T.Cod_Turma = AD.COD_TURMA
GROUP BY NP.ano_letivo, T.AnoLetivo;

IF @Gravar = 0
BEGIN
	PRINT 'Somente conferência. Para apagar, execute novamente com @Gravar = 1.';
	RETURN;
END

BEGIN TRY
	BEGIN TRANSACTION;

	IF OBJECT_ID('dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ') IS NULL
		SELECT TOP 0 * INTO dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ FROM dbo.SCA_NOTAS_FALTAS;
	IF OBJECT_ID('dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ') IS NULL
		SELECT TOP 0 * INTO dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ FROM dbo.SCA_NOTAS_PLANILHA;

	-- backup (colunas IDENTITY copiadas como valor)
	DECLARE @SQL NVARCHAR(MAX), @COLS NVARCHAR(MAX);
	SELECT @COLS = STUFF((SELECT ',' + QUOTENAME(name) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_NOTAS_FALTAS') AND is_computed = 0 ORDER BY column_id FOR XML PATH('')), 1, 1, '');
	SET @SQL = N'SET IDENTITY_INSERT dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ ON; INSERT INTO dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ (' + @COLS + N') SELECT ' + @COLS + N' FROM dbo.SCA_NOTAS_FALTAS WHERE codigo IN (SELECT codigo FROM #NF); SET IDENTITY_INSERT dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ OFF;';
	IF OBJECTPROPERTY(OBJECT_ID('dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ'), 'TableHasIdentity') = 0
		SET @SQL = N'INSERT INTO dbo.BKP_20261116_NOTAS_FALTAS_MATRIZ (' + @COLS + N') SELECT ' + @COLS + N' FROM dbo.SCA_NOTAS_FALTAS WHERE codigo IN (SELECT codigo FROM #NF);';
	EXEC sp_executesql @SQL;

	SELECT @COLS = STUFF((SELECT ',' + QUOTENAME(name) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_NOTAS_PLANILHA') AND is_computed = 0 ORDER BY column_id FOR XML PATH('')), 1, 1, '');
	SET @SQL = N'SET IDENTITY_INSERT dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ ON; INSERT INTO dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ (' + @COLS + N') SELECT ' + @COLS + N' FROM dbo.SCA_NOTAS_PLANILHA WHERE codigo IN (SELECT codigo FROM #NP); SET IDENTITY_INSERT dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ OFF;';
	IF OBJECTPROPERTY(OBJECT_ID('dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ'), 'TableHasIdentity') = 0
		SET @SQL = N'INSERT INTO dbo.BKP_20261116_NOTAS_PLANILHA_MATRIZ (' + @COLS + N') SELECT ' + @COLS + N' FROM dbo.SCA_NOTAS_PLANILHA WHERE codigo IN (SELECT codigo FROM #NP);';
	EXEC sp_executesql @SQL;

	DELETE FROM dbo.SCA_NOTAS_FALTAS WHERE codigo IN (SELECT codigo FROM #NF);
	PRINT 'SCA_NOTAS_FALTAS apagados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
	DELETE FROM dbo.SCA_NOTAS_PLANILHA WHERE codigo IN (SELECT codigo FROM #NP);
	PRINT 'SCA_NOTAS_PLANILHA apagados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	PRINT 'ERRO - nada foi apagado: ' + ERROR_MESSAGE();
END CATCH
GO
SET NOEXEC OFF;
GO
