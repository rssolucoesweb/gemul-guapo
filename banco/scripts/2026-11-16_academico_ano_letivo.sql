/* =====================================================================
   GUAPÓ - anos letivos do cabeçalho (SEG_ANO_LETIVO) - rodar no banco de GUAPÓ
   Data: 16/11/2026

   A tabela é nova em Guapó (fase 1). Carrega os anos a partir das turmas que já existem,
   para cada grupo de escolas (SEG_EMPRESA.COD_GRUPO). Ano padrão (PADRAO = 'S') = ano atual.
   Não traz nada de Anápolis. Pode rodar mais de uma vez.
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

INSERT INTO dbo.SEG_ANO_LETIVO (COD_GRUPO, ANO_LETIVO, SITUACAO, PADRAO, USUARIO_INCL, DATA_HORA_INCL)
SELECT DISTINCT E.COD_GRUPO, T.AnoLetivo, 'A',
	CASE WHEN T.AnoLetivo = YEAR(GETDATE()) THEN 'S' ELSE 'N' END,
	'SCRIPT_FASE1', GETDATE()
FROM dbo.SCA_TURMA T
INNER JOIN dbo.SEG_EMPRESA E ON E.CODIGO = T.Cod_Empresa
WHERE E.COD_GRUPO IS NOT NULL
  AND T.AnoLetivo BETWEEN 2000 AND YEAR(GETDATE()) + 1
  AND NOT EXISTS (SELECT 1 FROM dbo.SEG_ANO_LETIVO A WHERE A.COD_GRUPO = E.COD_GRUPO AND A.ANO_LETIVO = T.AnoLetivo);

SELECT COD_GRUPO, ANO_LETIVO, SITUACAO, PADRAO FROM dbo.SEG_ANO_LETIVO ORDER BY COD_GRUPO, ANO_LETIVO DESC;
GO
SET NOEXEC OFF;
GO
