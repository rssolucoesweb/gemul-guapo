/* =====================================================================
   GUAPÓ - Matrícula (migração para o layout novo) - Lote 3: estrutura
   Renovação e TIP iguais a Anápolis
   Data: 18/11/2026

   Rodar no banco de GUAPÓ (não no de Anápolis), ANTES de subir as telas do lote 3.
   Junta, na ordem, os scripts e procedures de Anápolis (banco/scripts e banco/procedures):
   tabelas de backup da renovação, de/para da TIP e da renovação, índices e as procedures
   de renovação e TIP. Tudo pode rodar mais de uma vez (cria só o que falta / CREATE-ALTER).
   As tabelas da TIP (backup, ajuste do contador) e as colunas já existem em Guapó.
   Em cada parte, o comentário original de Anápolis foi mantido.
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

/* #####################################################################
   PARTE 1 - Tabelas de backup da renovação (para o Excluir/desfazer)
   (origem: Anápolis banco/scripts/2026-10-28_renovacao_backup_tabelas.sql)
   ##################################################################### */
/*
	Renovação de matrícula - tabelas de backup para o "Excluir" (desfazer a renovação)
	Data: 28/10/2026

	A renovação apaga disciplinas, notas e faltas do aluno e altera vínculos e situação.
	Antes disso, SP_MAT_RenovacaoBackup guarda uma cópia aqui (por COD_RENOVACAO =
	SCA_ALUNO_RENOVACAO.CODIGO). SP_MAT_RenovacaoDesfaz restaura a cópia e apaga o backup.

	As tabelas *_ALUNO_DISCIPLINA, *_NOTAS_FALTAS, *_FALTAS_DIARIA e *_ALUNO_ANO_LETIVO têm
	COD_RENOVACAO + exatamente as colunas da tabela original (sem IDENTITY).
	Se alguma tabela original ganhar coluna nova, rode de novo este script com @Recriar = 1
	(só quando não houver renovações pendentes de exclusão, pois os backups são apagados).

	Depois deste script, rode banco/procedures/SP_MAT_RenovacaoBackup.sql e SP_MAT_RenovacaoDesfaz.sql.
*/
DECLARE @Recriar BIT = 0;

IF @Recriar = 1
BEGIN
	IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA') IS NOT NULL DROP TABLE dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA;
	IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS') IS NOT NULL DROP TABLE dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS;
	IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA') IS NOT NULL DROP TABLE dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA;
	IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO') IS NOT NULL DROP TABLE dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO;
END

/* Se a tabela de backup já existe COM IDENTITY (versão anterior deste script) e está vazia, recria */
DECLARE @t SYSNAME;
DECLARE c CURSOR LOCAL FAST_FORWARD FOR
	SELECT v.nome FROM (VALUES ('MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA'), ('MAT_RENOVACAO_BKP_NOTAS_FALTAS'),
		('MAT_RENOVACAO_BKP_FALTAS_DIARIA'), ('MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO')) v(nome)
	WHERE EXISTS (SELECT 1 FROM sys.identity_columns ic WHERE ic.object_id = OBJECT_ID('dbo.' + v.nome));
OPEN c;
FETCH NEXT FROM c INTO @t;
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @qtde INT, @sql NVARCHAR(400) = N'SELECT @q = COUNT(*) FROM dbo.' + QUOTENAME(@t);
	EXEC sp_executesql @sql, N'@q INT OUTPUT', @q = @qtde OUTPUT;
	IF @qtde = 0
	BEGIN
		SET @sql = N'DROP TABLE dbo.' + QUOTENAME(@t);
		EXEC (@sql);
		PRINT 'Recriando ' + @t + ' (estava com IDENTITY).';
	END
	ELSE
		RAISERROR('A tabela %s tem IDENTITY e já possui dados. Verifique antes de continuar.', 16, 1, @t);
	FETCH NEXT FROM c INTO @t;
END
CLOSE c; DEALLOCATE c;

/* Cópia da estrutura sem IDENTITY: com UNION ALL o SELECT INTO nunca herda o IDENTITY */
IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA') IS NULL
	SELECT CAST(0 AS INT) AS COD_RENOVACAO, T.* INTO dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA
	FROM dbo.SCA_ALUNO_DISCIPLINA T WHERE 1 = 0
	UNION ALL
	SELECT CAST(0 AS INT), T.* FROM dbo.SCA_ALUNO_DISCIPLINA T WHERE 1 = 0;

IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS') IS NULL
	SELECT CAST(0 AS INT) AS COD_RENOVACAO, T.* INTO dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS
	FROM dbo.SCA_NOTAS_FALTAS T WHERE 1 = 0
	UNION ALL
	SELECT CAST(0 AS INT), T.* FROM dbo.SCA_NOTAS_FALTAS T WHERE 1 = 0;

IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA') IS NULL
	SELECT CAST(0 AS INT) AS COD_RENOVACAO, T.* INTO dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA
	FROM dbo.SCA_FALTAS_DIARIA T WHERE 1 = 0
	UNION ALL
	SELECT CAST(0 AS INT), T.* FROM dbo.SCA_FALTAS_DIARIA T WHERE 1 = 0;

IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO') IS NULL
	SELECT CAST(0 AS INT) AS COD_RENOVACAO, T.* INTO dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO
	FROM dbo.SCA_ALUNO_ANO_LETIVO T WHERE 1 = 0
	UNION ALL
	SELECT CAST(0 AS INT), T.* FROM dbo.SCA_ALUNO_ANO_LETIVO T WHERE 1 = 0;

/* Situação dos vínculos (SCA_ALUNO_TURMA) antes da renovação */
IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA') IS NULL
	CREATE TABLE dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA (
		COD_RENOVACAO INT NOT NULL,
		CODIGO INT NOT NULL,
		SITUACAO CHAR(1) NULL,
		DATA_SITUACAO DATETIME NULL
	);

/* Situação do aluno (SCA_ALUNO.COD_SITUACAOALUNO) antes da renovação */
IF OBJECT_ID('dbo.MAT_RENOVACAO_BKP_ALUNO') IS NULL
	CREATE TABLE dbo.MAT_RENOVACAO_BKP_ALUNO (
		COD_RENOVACAO INT NOT NULL,
		COD_ALUNO INT NOT NULL,
		COD_SITUACAOALUNO INT NULL
	);
GO

/* Índices por COD_RENOVACAO */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA')
	CREATE INDEX IX_MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA ON dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA (COD_RENOVACAO);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MAT_RENOVACAO_BKP_NOTAS_FALTAS')
	CREATE INDEX IX_MAT_RENOVACAO_BKP_NOTAS_FALTAS ON dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS (COD_RENOVACAO);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MAT_RENOVACAO_BKP_FALTAS_DIARIA')
	CREATE INDEX IX_MAT_RENOVACAO_BKP_FALTAS_DIARIA ON dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA (COD_RENOVACAO);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO')
	CREATE INDEX IX_MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO ON dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO (COD_RENOVACAO);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MAT_RENOVACAO_BKP_ALUNO_TURMA')
	CREATE INDEX IX_MAT_RENOVACAO_BKP_ALUNO_TURMA ON dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA (COD_RENOVACAO);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MAT_RENOVACAO_BKP_ALUNO')
	CREATE INDEX IX_MAT_RENOVACAO_BKP_ALUNO ON dbo.MAT_RENOVACAO_BKP_ALUNO (COD_RENOVACAO);
GO

/* Conferência: nenhuma linha deve aparecer aqui */
SELECT OBJECT_NAME(object_id) AS tabela_com_identity, name AS coluna
FROM sys.identity_columns WHERE OBJECT_NAME(object_id) LIKE 'MAT_RENOVACAO_BKP%';

PRINT 'Tabelas de backup da renovação prontas.';
GO

/* #####################################################################
   PARTE 2 - De/para da TIP (Guapó: mesmos códigos de curso/período de Anápolis: Agrupamento I a V = 10 a 14, 1º ao 5º = 1 a 5)
   (origem: Anápolis banco/scripts/2026-11-04_MAT_TIP_DE_PARA.sql)
   ##################################################################### */
/*
	TIP - de/para de curso e período (origem -> destino)
	Data: 04/11/2026 (planilha de-para_tip_1.xlsx)

	A tela da TIP (app/mat_tip.asp) mostra no curso e no período de destino SOMENTE o que estiver
	aqui para o período atual do aluno; a gravação (mat_tip_cod.asp) confere a turma de destino.
	Período de origem sem linha (5º ano, 6º a 9º ano) = a rede não tem a série seguinte: TIP bloqueada.
	Para mudar a regra, altere a tabela (SITUACAO = 'I' desativa uma linha). Pode rodar mais de uma vez.
*/
IF OBJECT_ID('dbo.MAT_TIP_DE_PARA') IS NULL
BEGIN
	CREATE TABLE dbo.MAT_TIP_DE_PARA (
		CODIGO				INT IDENTITY(1,1) NOT NULL,
		COD_GRUPO			INT NOT NULL,
		COD_CURSO_ORIGEM	INT NOT NULL,
		COD_PERIODO_ORIGEM	INT NOT NULL,
		COD_CURSO_DESTINO	INT NOT NULL,
		COD_PERIODO_DESTINO	INT NOT NULL,
		SITUACAO			CHAR(1) NOT NULL CONSTRAINT DF_MAT_TIP_DE_PARA_SITUACAO DEFAULT ('A'),	-- A = ativo | I = inativo
		USUARIO_INCL		VARCHAR(50) NULL,
		DATA_HORA_INCL		DATETIME NOT NULL CONSTRAINT DF_MAT_TIP_DE_PARA_DATA DEFAULT (GETDATE()),
		CONSTRAINT PK_MAT_TIP_DE_PARA PRIMARY KEY CLUSTERED (CODIGO),
		CONSTRAINT UQ_MAT_TIP_DE_PARA UNIQUE (COD_GRUPO, COD_PERIODO_ORIGEM)
	);
	PRINT 'Tabela MAT_TIP_DE_PARA criada.';
END
GO

/* Carga: para cada grupo (rede) */
INSERT INTO dbo.MAT_TIP_DE_PARA (COD_GRUPO, COD_CURSO_ORIGEM, COD_PERIODO_ORIGEM, COD_CURSO_DESTINO, COD_PERIODO_DESTINO, USUARIO_INCL)
SELECT G.COD_GRUPO, D.CO, D.PO, D.CD, D.PD, 'carga inicial'
FROM (SELECT DISTINCT COD_GRUPO FROM dbo.SEG_EMPRESA WHERE COD_GRUPO IS NOT NULL) G
CROSS JOIN (VALUES
	(1, 10, 1, 11),		-- EDUCAÇÃO INFANTIL: INFANTIL I   -> INFANTIL II
	(1, 11, 1, 12),		--                    INFANTIL II  -> INFANTIL III
	(1, 12, 1, 13),		--                    INFANTIL III -> INFANTIL IV
	(1, 13, 1, 14),		--                    INFANTIL IV  -> INFANTIL V
	(1, 14, 2, 1),		--                    INFANTIL V   -> ENSINO FUNDAMENTAL 1º ANO
	(2, 1, 2, 2),		-- ENSINO FUNDAMENTAL: 1º ANO -> 2º ANO
	(2, 2, 2, 3),		--                     2º ANO -> 3º ANO
	(2, 3, 2, 4),		--                     3º ANO -> 4º ANO
	(2, 4, 2, 5)		--                     4º ANO -> 5º ANO
	-- 5º ANO e ENSINO FUNDAMENTAL 2ª FASE (6º ao 9º): sem destino -> TIP bloqueada
) D (CO, PO, CD, PD)
WHERE NOT EXISTS (SELECT 1 FROM dbo.MAT_TIP_DE_PARA X WHERE X.COD_GRUPO = G.COD_GRUPO AND X.COD_PERIODO_ORIGEM = D.PO);
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' linha(s) incluída(s).';
GO

/* Conferência */
SELECT DP.COD_GRUPO, CO.Descricao AS CURSO_ORIGEM, PO.Descricao AS PERIODO_ORIGEM, CD.Descricao AS CURSO_DESTINO, PD.Descricao AS PERIODO_DESTINO, DP.SITUACAO
FROM dbo.MAT_TIP_DE_PARA DP
LEFT JOIN dbo.SCA_CURSO CO ON CO.Cod_curso = DP.COD_CURSO_ORIGEM
LEFT JOIN dbo.SCA_PERIODO PO ON PO.Cod_Periodo = DP.COD_PERIODO_ORIGEM
LEFT JOIN dbo.SCA_CURSO CD ON CD.Cod_curso = DP.COD_CURSO_DESTINO
LEFT JOIN dbo.SCA_PERIODO PD ON PD.Cod_Periodo = DP.COD_PERIODO_DESTINO
ORDER BY DP.COD_GRUPO, DP.COD_CURSO_ORIGEM, DP.COD_PERIODO_ORIGEM;
GO

/* #####################################################################
   PARTE 3 - De/para próprio da renovação (5º ANO -> 6º ANO pela descrição)
   (origem: Anápolis banco/scripts/2026-11-06_MAT_RENOVACAO_DE_PARA.sql)
   Guapó: as buscas pela descrição ignoram os períodos da EJA ("5º ANO EJA" etc.)
   ##################################################################### */
/* =====================================================================
   Renovação - de/para próprio (além do de/para da TIP)
   A renovação usa primeiro esta tabela; se o período não estiver aqui, usa MAT_TIP_DE_PARA;
   sem nenhum dos dois, mesmo curso e período + 1.
   Serve para as passagens que a TIP não permite, como 5º ANO -> 6º ANO (anos finais).

   Carga: 5º ANO -> 6º ANO, achados pela DESCRIÇÃO do período (confira a conferência no fim).
   Se a descrição for outra na sua base, inclua a linha à mão:
     INSERT INTO MAT_RENOVACAO_DE_PARA (COD_GRUPO, COD_CURSO_ORIGEM, COD_PERIODO_ORIGEM, COD_CURSO_DESTINO, COD_PERIODO_DESTINO, USUARIO_INCL)
     VALUES (<grupo>, <curso 5º>, <período 5º>, <curso 6º>, <período 6º>, 'manual');
   Pode rodar mais de uma vez.
   ===================================================================== */
IF OBJECT_ID('dbo.MAT_RENOVACAO_DE_PARA') IS NULL
BEGIN
	CREATE TABLE dbo.MAT_RENOVACAO_DE_PARA (
		CODIGO				INT IDENTITY(1,1) NOT NULL,
		COD_GRUPO			INT NOT NULL,
		COD_CURSO_ORIGEM	INT NOT NULL,
		COD_PERIODO_ORIGEM	INT NOT NULL,
		COD_CURSO_DESTINO	INT NOT NULL,
		COD_PERIODO_DESTINO	INT NOT NULL,
		SITUACAO			CHAR(1) NOT NULL CONSTRAINT DF_MAT_RENOVACAO_DE_PARA_SITUACAO DEFAULT ('A'),	-- A = ativo | I = inativo
		USUARIO_INCL		VARCHAR(50) NULL,
		DATA_HORA_INCL		DATETIME NOT NULL CONSTRAINT DF_MAT_RENOVACAO_DE_PARA_DATA DEFAULT (GETDATE()),
		CONSTRAINT PK_MAT_RENOVACAO_DE_PARA PRIMARY KEY CLUSTERED (CODIGO),
		CONSTRAINT UQ_MAT_RENOVACAO_DE_PARA UNIQUE (COD_GRUPO, COD_PERIODO_ORIGEM)
	);
	PRINT 'Tabela MAT_RENOVACAO_DE_PARA criada.';
END
GO

/* Períodos encontrados pela descrição (conferência antes da carga) */
SELECT P.Cod_Periodo, P.Cod_Curso, C.Descricao AS CURSO, P.Descricao AS PERIODO
FROM dbo.SCA_PERIODO P LEFT JOIN dbo.SCA_CURSO C ON C.Cod_curso = P.Cod_Curso
WHERE (LTRIM(P.Descricao) LIKE '5%ANO%' OR LTRIM(P.Descricao) LIKE '6%ANO%') AND LTRIM(P.Descricao) NOT LIKE '%EJA%'
ORDER BY P.Descricao, P.Cod_Curso;
GO

/* Carga 5º ANO -> 6º ANO, para cada grupo (só se houver exatamente um 5º e um 6º ano) */
DECLARE @CO INT, @PO INT, @CD INT, @PD INT;
IF (SELECT COUNT(*) FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE '5%ANO%' AND LTRIM(Descricao) NOT LIKE '%EJA%') = 1
AND (SELECT COUNT(*) FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE '6%ANO%' AND LTRIM(Descricao) NOT LIKE '%EJA%') = 1
BEGIN
	SELECT @CO = Cod_Curso, @PO = Cod_Periodo FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE '5%ANO%' AND LTRIM(Descricao) NOT LIKE '%EJA%';
	SELECT @CD = Cod_Curso, @PD = Cod_Periodo FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE '6%ANO%' AND LTRIM(Descricao) NOT LIKE '%EJA%';
	INSERT INTO dbo.MAT_RENOVACAO_DE_PARA (COD_GRUPO, COD_CURSO_ORIGEM, COD_PERIODO_ORIGEM, COD_CURSO_DESTINO, COD_PERIODO_DESTINO, USUARIO_INCL)
	SELECT G.COD_GRUPO, @CO, @PO, @CD, @PD, 'carga inicial'
	FROM (SELECT DISTINCT COD_GRUPO FROM dbo.SEG_EMPRESA WHERE COD_GRUPO IS NOT NULL) G
	WHERE NOT EXISTS (SELECT 1 FROM dbo.MAT_RENOVACAO_DE_PARA X WHERE X.COD_GRUPO = G.COD_GRUPO AND X.COD_PERIODO_ORIGEM = @PO);
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' linha(s) incluída(s).';
END
ELSE
	PRINT 'ATENÇÃO: não achei um único 5º ANO e um único 6º ANO pela descrição. Veja a lista acima e inclua a linha à mão (exemplo no topo do script).';
GO

/* Carga 2: copia todas as linhas da TIP (Infantil I -> ... -> 5º ANO), para a renovação ter a sequência completa */
INSERT INTO dbo.MAT_RENOVACAO_DE_PARA (COD_GRUPO, COD_CURSO_ORIGEM, COD_PERIODO_ORIGEM, COD_CURSO_DESTINO, COD_PERIODO_DESTINO, USUARIO_INCL)
SELECT T.COD_GRUPO, T.COD_CURSO_ORIGEM, T.COD_PERIODO_ORIGEM, T.COD_CURSO_DESTINO, T.COD_PERIODO_DESTINO, 'copia MAT_TIP_DE_PARA'
FROM dbo.MAT_TIP_DE_PARA T
WHERE T.SITUACAO = 'A'
AND NOT EXISTS (SELECT 1 FROM dbo.MAT_RENOVACAO_DE_PARA X WHERE X.COD_GRUPO = T.COD_GRUPO AND X.COD_PERIODO_ORIGEM = T.COD_PERIODO_ORIGEM);
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' linha(s) copiada(s) da TIP.';
GO

/* Carga 3: anos finais 6º -> 7º -> 8º -> 9º, achados pela descrição (só se cada um for único) */
DECLARE @PAR TABLE (DE VARCHAR(10), PARA VARCHAR(10));
INSERT INTO @PAR VALUES ('6%ANO%', '7%ANO%'), ('7%ANO%', '8%ANO%'), ('8%ANO%', '9%ANO%');
DECLARE @DE VARCHAR(10), @PARA VARCHAR(10), @CO INT, @PO INT, @CD INT, @PD INT;
DECLARE cPar CURSOR LOCAL FAST_FORWARD FOR SELECT DE, PARA FROM @PAR;
OPEN cPar;
FETCH NEXT FROM cPar INTO @DE, @PARA;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF (SELECT COUNT(*) FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE @DE AND LTRIM(Descricao) NOT LIKE '%EJA%') = 1
	AND (SELECT COUNT(*) FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE @PARA AND LTRIM(Descricao) NOT LIKE '%EJA%') = 1
	BEGIN
		SELECT @CO = Cod_Curso, @PO = Cod_Periodo FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE @DE AND LTRIM(Descricao) NOT LIKE '%EJA%';
		SELECT @CD = Cod_Curso, @PD = Cod_Periodo FROM dbo.SCA_PERIODO WHERE LTRIM(Descricao) LIKE @PARA AND LTRIM(Descricao) NOT LIKE '%EJA%';
		INSERT INTO dbo.MAT_RENOVACAO_DE_PARA (COD_GRUPO, COD_CURSO_ORIGEM, COD_PERIODO_ORIGEM, COD_CURSO_DESTINO, COD_PERIODO_DESTINO, USUARIO_INCL)
		SELECT G.COD_GRUPO, @CO, @PO, @CD, @PD, 'carga inicial'
		FROM (SELECT DISTINCT COD_GRUPO FROM dbo.SEG_EMPRESA WHERE COD_GRUPO IS NOT NULL) G
		WHERE NOT EXISTS (SELECT 1 FROM dbo.MAT_RENOVACAO_DE_PARA X WHERE X.COD_GRUPO = G.COD_GRUPO AND X.COD_PERIODO_ORIGEM = @PO);
	END
	ELSE
		PRINT 'ATENÇÃO: período não encontrado (ou repetido) para ' + @DE + ' -> ' + @PARA + '. Inclua à mão.';
	FETCH NEXT FROM cPar INTO @DE, @PARA;
END
CLOSE cPar;
DEALLOCATE cPar;
GO

/* Conferência */
SELECT DP.COD_GRUPO, DP.COD_PERIODO_ORIGEM, DP.COD_PERIODO_DESTINO, CO.Descricao AS CURSO_ORIGEM, PO.Descricao AS PERIODO_ORIGEM, CD.Descricao AS CURSO_DESTINO, PD.Descricao AS PERIODO_DESTINO, DP.SITUACAO
FROM dbo.MAT_RENOVACAO_DE_PARA DP
LEFT JOIN dbo.SCA_CURSO CO ON CO.Cod_curso = DP.COD_CURSO_ORIGEM
LEFT JOIN dbo.SCA_PERIODO PO ON PO.Cod_Periodo = DP.COD_PERIODO_ORIGEM
LEFT JOIN dbo.SCA_CURSO CD ON CD.Cod_curso = DP.COD_CURSO_DESTINO
LEFT JOIN dbo.SCA_PERIODO PD ON PD.Cod_Periodo = DP.COD_PERIODO_DESTINO
ORDER BY DP.COD_GRUPO, DP.COD_CURSO_ORIGEM, DP.COD_PERIODO_ORIGEM;
GO

/* #####################################################################
   PARTE 4 - Índices da renovação
   (origem: Anápolis banco/scripts/2026-11-06_mat_renovacao_indices.sql)
   ##################################################################### */
/* =====================================================================
   Matrícula > Renovação: índices para a lista da turma de origem
   (renovações da turma, TIP do aluno no ano, TIP da turma).
   Só cria se a tabela ainda NÃO tiver índice começando pela mesma coluna. Pode rodar mais de uma vez.
   Rode fora do horário de pico.
   ===================================================================== */
-- conferência: índices existentes
SELECT OBJECT_NAME(i.object_id) AS tabela, i.name AS indice,
       STUFF((SELECT ', ' + c.name FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
              WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.key_ordinal > 0 ORDER BY ic.key_ordinal FOR XML PATH('')), 1, 2, '') AS colunas
FROM sys.indexes i
WHERE i.object_id IN (OBJECT_ID('dbo.SCA_ALUNO_RENOVACAO'), OBJECT_ID('dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO'), OBJECT_ID('dbo.SCA_ALUNO_TURMA'))
AND i.index_id > 0
ORDER BY 1, 2;
GO

-- 1) Renovações da turma de origem
IF NOT EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
               WHERE ic.object_id = OBJECT_ID('dbo.SCA_ALUNO_RENOVACAO') AND ic.key_ordinal = 1 AND c.name = 'COD_TURMA')
BEGIN
	CREATE INDEX IX_SCA_ALUNO_RENOVACAO_TURMA ON dbo.SCA_ALUNO_RENOVACAO (COD_TURMA) INCLUDE (COD_ALUNO, COD_TURMA_RENOVACAO, ANO_LETIVO_RENOVACAO);
	PRINT 'Criado IX_SCA_ALUNO_RENOVACAO_TURMA';
END
ELSE PRINT 'SCA_ALUNO_RENOVACAO já tem índice por COD_TURMA';
GO

-- 2) Renovação do aluno (conferência "já renovado")
IF NOT EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
               WHERE ic.object_id = OBJECT_ID('dbo.SCA_ALUNO_RENOVACAO') AND ic.key_ordinal = 1 AND c.name = 'COD_ALUNO')
BEGIN
	CREATE INDEX IX_SCA_ALUNO_RENOVACAO_ALUNO ON dbo.SCA_ALUNO_RENOVACAO (COD_ALUNO, ANO_LETIVO_RENOVACAO);
	PRINT 'Criado IX_SCA_ALUNO_RENOVACAO_ALUNO';
END
ELSE PRINT 'SCA_ALUNO_RENOVACAO já tem índice por COD_ALUNO';
GO

-- 3) TIP do aluno no ano (coluna "tem TIP" de cada aluno da lista)
IF NOT EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
               WHERE ic.object_id = OBJECT_ID('dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO') AND ic.key_ordinal = 1 AND c.name = 'COD_ALUNO')
BEGIN
	CREATE INDEX IX_SCA_TIP_ALUNO_ANO ON dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO (COD_ALUNO, ANO_LETIVO) INCLUDE (SITUACAO);
	PRINT 'Criado IX_SCA_TIP_ALUNO_ANO';
END
ELSE PRINT 'SCA_TRANSFERENCIA_INTERESSE_PROPRIO já tem índice por COD_ALUNO';
GO

-- 4) TIP da turma
IF NOT EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
               WHERE ic.object_id = OBJECT_ID('dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO') AND ic.key_ordinal = 1 AND c.name = 'COD_TURMA')
BEGIN
	CREATE INDEX IX_SCA_TIP_TURMA_ANO ON dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO (COD_TURMA, ANO_LETIVO) INCLUDE (COD_ALUNO, COD_EMPRESA, SITUACAO);
	PRINT 'Criado IX_SCA_TIP_TURMA_ANO';
END
ELSE PRINT 'SCA_TRANSFERENCIA_INTERESSE_PROPRIO já tem índice por COD_TURMA';
GO

-- 5) Alunos da turma (mesmo índice do script do transporte; não cria de novo se já existir)
IF NOT EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
               WHERE ic.object_id = OBJECT_ID('dbo.SCA_ALUNO_TURMA') AND ic.key_ordinal = 1 AND c.name = 'COD_TURMA')
BEGIN
	CREATE INDEX IX_SCA_ALUNO_TURMA_TURMA ON dbo.SCA_ALUNO_TURMA (COD_TURMA, SITUACAO) INCLUDE (COD_ALUNO, COD_EMPRESA, ANO_LETIVO);
	PRINT 'Criado IX_SCA_ALUNO_TURMA_TURMA';
END
ELSE PRINT 'SCA_ALUNO_TURMA já tem índice por COD_TURMA';
GO

/* #####################################################################
   PARTE 5 - Índices contra bloqueio (a parte 2 do original, READ COMMITTED SNAPSHOT, fica comentada)
   (origem: Anápolis banco/scripts/2026-11-09_renovacao_bloqueios.sql)
   ##################################################################### */
/* =====================================================================
   Renovação: menos bloqueio/deadlock quando várias escolas renovam ao mesmo tempo

   A renovação (dentro de uma transação) faz, para cada aluno, o backup das notas/faltas
   (SP_MAT_RenovacaoBackup) e gera a planilha de notas. Sem índice, cada um desses passos lê a
   tabela INTEIRA (ex.: DELETE ... WHERE COD_RENOVACAO = x nas tabelas de backup), e duas escolas
   renovando juntas ficam esperando uma pela outra (LCK_M_S) até dar timeout ou deadlock.

   PARTE 1 (pode rodar com o sistema no ar): índices por aluno / por renovação.
   Cada índice só é criado se a tabela ainda não tiver índice começando pela mesma coluna.
   ===================================================================== */
SET NOCOUNT ON;
DECLARE @IDX TABLE (TABELA SYSNAME, COLUNA SYSNAME, NOME SYSNAME, COLUNAS NVARCHAR(400));
INSERT INTO @IDX VALUES
 ('MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA', 'COD_RENOVACAO', 'IX_BKP_AD_RENOVACAO', 'COD_RENOVACAO'),
 ('MAT_RENOVACAO_BKP_NOTAS_FALTAS',     'COD_RENOVACAO', 'IX_BKP_NF_RENOVACAO', 'COD_RENOVACAO'),
 ('MAT_RENOVACAO_BKP_FALTAS_DIARIA',    'COD_RENOVACAO', 'IX_BKP_FD_RENOVACAO', 'COD_RENOVACAO'),
 ('MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO', 'COD_RENOVACAO', 'IX_BKP_AAL_RENOVACAO', 'COD_RENOVACAO'),
 ('MAT_RENOVACAO_BKP_ALUNO_TURMA',      'COD_RENOVACAO', 'IX_BKP_AT_RENOVACAO', 'COD_RENOVACAO'),
 ('MAT_RENOVACAO_BKP_ALUNO',            'COD_RENOVACAO', 'IX_BKP_A_RENOVACAO',  'COD_RENOVACAO'),
 ('SCA_ALUNO_DISCIPLINA',               'COD_ALUNO',     'IX_SCA_ALUNO_DISCIPLINA_ALUNO', 'COD_ALUNO, COD_TURMA'),
 ('SCA_NOTAS_FALTAS',                   'cod_aluno',     'IX_SCA_NOTAS_FALTAS_ALUNO', 'cod_aluno, ano_letivo'),
 ('SCA_NOTAS_PLANILHA',                 'cod_aluno',     'IX_SCA_NOTAS_PLANILHA_ALUNO', 'cod_aluno, ano_letivo'),
 ('SCA_FALTAS_DIARIA',                  'cod_aluno',     'IX_SCA_FALTAS_DIARIA_ALUNO', 'cod_aluno'),
 ('SCA_ALUNO_ANO_LETIVO',               'COD_ALUNO',     'IX_SCA_ALUNO_ANO_LETIVO_ALUNO', 'COD_ALUNO, ANO_LETIVO'),
 ('SCA_ALUNO_TURMA',                    'COD_ALUNO',     'IX_SCA_ALUNO_TURMA_ALUNO', 'COD_ALUNO, ANO_LETIVO'),
 ('SCA_CONTROLE_SITUACAO_ALUNO',        'COD_ALUNO',     'IX_SCA_CONTROLE_SITUACAO_ALUNO_ALUNO_ANO', 'COD_ALUNO, ANO_LETIVO, CODIGO'),
 ('SCA_ALUNO_RENOVACAO',                'COD_ALUNO',     'IX_SCA_ALUNO_RENOVACAO_ALUNO', 'COD_ALUNO, ANO_LETIVO_RENOVACAO');

DECLARE @T SYSNAME, @C SYSNAME, @N SYSNAME, @COLS NVARCHAR(400), @SQL NVARCHAR(MAX);
DECLARE cI CURSOR LOCAL FAST_FORWARD FOR SELECT TABELA, COLUNA, NOME, COLUNAS FROM @IDX;
OPEN cI;
FETCH NEXT FROM cI INTO @T, @C, @N, @COLS;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF OBJECT_ID('dbo.' + @T) IS NULL
		PRINT @T + ': tabela não existe (ignorado)';
	ELSE IF EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
	                WHERE ic.object_id = OBJECT_ID('dbo.' + @T) AND ic.key_ordinal = 1 AND c.name = @C)
		PRINT @T + ': já tem índice por ' + @C;
	ELSE
	BEGIN
		SET @SQL = N'CREATE INDEX ' + QUOTENAME(@N) + N' ON dbo.' + QUOTENAME(@T) + N' (' + @COLS + N')';
		BEGIN TRY
			EXEC sp_executesql @SQL;
			PRINT @T + ': criado ' + @N;
		END TRY
		BEGIN CATCH
			PRINT @T + ': ERRO ao criar ' + @N + ' - ' + ERROR_MESSAGE();
		END CATCH
	END
	FETCH NEXT FROM cI INTO @T, @C, @N, @COLS;
END
CLOSE cI; DEALLOCATE cI;
GO

/* =====================================================================
   PARTE 2 (RECOMENDADA, rodar em horário sem uso - leva segundos):
   READ COMMITTED SNAPSHOT. Com ela, quem só LÊ (listas, relatórios, conferências) não espera
   quem está gravando, e vice-versa: some a maior parte das esperas LCK_M_S e dos deadlocks.
   É o padrão em bancos novos do SQL Server e no Azure SQL. Usa um pouco mais do tempdb.
   O "WITH ROLLBACK IMMEDIATE" derruba as conexões abertas no momento (o site/GEMUL reconecta sozinho).

   Para ativar, tire o comentário das linhas abaixo e execute:

ALTER DATABASE [<banco de Guapó>] SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;
SELECT name, is_read_committed_snapshot_on FROM sys.databases WHERE name = '<banco de Guapó>';

   Para desfazer: ALTER DATABASE [<banco de Guapó>] SET READ_COMMITTED_SNAPSHOT OFF WITH ROLLBACK IMMEDIATE;
   ===================================================================== */
GO

/* #####################################################################
   PARTE 6 - SP_MAT_RenovacaoBackup (nova)
   (origem: Anápolis banco/procedures/SP_MAT_RenovacaoBackup.sql)
   ##################################################################### */
/*
	SP_MAT_RenovacaoBackup
	Guarda uma cópia de tudo o que a renovação de matrícula vai apagar ou alterar,
	para que SP_MAT_RenovacaoDesfaz consiga voltar o aluno ao estado anterior.

	Chamada por app/mat_renovacao_cod.asp (acao I), logo depois de gravar SCA_ALUNO_RENOVACAO
	e ANTES de qualquer outra alteração. Não abre transação: usa a da tela.
	Requer banco/scripts/2026-10-28_renovacao_backup_tabelas.sql
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.SP_MAT_RenovacaoBackup') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_RenovacaoBackup AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_RenovacaoBackup
(
	@COD_RENOVACAO INT,
	@COD_ALUNO INT,
	@COD_EMPRESA INT,
	@ANO_DESTINO INT
)
AS
BEGIN
	SET NOCOUNT ON;

	-- limpa backup anterior com o mesmo código (segurança)
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO WHERE COD_RENOVACAO = @COD_RENOVACAO;

	-- a renovação apaga TODAS as disciplinas, notas e faltas do aluno
	INSERT INTO dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA
	SELECT @COD_RENOVACAO, T.* FROM dbo.SCA_ALUNO_DISCIPLINA T WHERE T.COD_ALUNO = @COD_ALUNO;

	INSERT INTO dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS
	SELECT @COD_RENOVACAO, T.* FROM dbo.SCA_NOTAS_FALTAS T WHERE T.cod_aluno = @COD_ALUNO;

	INSERT INTO dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA
	SELECT @COD_RENOVACAO, T.* FROM dbo.SCA_FALTAS_DIARIA T WHERE T.cod_aluno = @COD_ALUNO;

	-- a renovação apaga e regrava o ano letivo de destino
	INSERT INTO dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO
	SELECT @COD_RENOVACAO, T.* FROM dbo.SCA_ALUNO_ANO_LETIVO T
	WHERE T.COD_ALUNO = @COD_ALUNO AND T.COD_EMPRESA = @COD_EMPRESA AND T.ANO_LETIVO = @ANO_DESTINO;

	-- a renovação passa para 'R' todos os vínculos ativos do aluno
	INSERT INTO dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA (COD_RENOVACAO, CODIGO, SITUACAO, DATA_SITUACAO)
	SELECT @COD_RENOVACAO, AT.CODIGO, AT.SITUACAO, AT.DATA_SITUACAO
	FROM dbo.SCA_ALUNO_TURMA AT
	WHERE AT.COD_EMPRESA = @COD_EMPRESA AND AT.COD_ALUNO = @COD_ALUNO AND AT.SITUACAO = 'A';

	-- a renovação grava COD_SITUACAOALUNO = 1
	INSERT INTO dbo.MAT_RENOVACAO_BKP_ALUNO (COD_RENOVACAO, COD_ALUNO, COD_SITUACAOALUNO)
	SELECT @COD_RENOVACAO, A.CODIGO, A.COD_SITUACAOALUNO FROM dbo.SCA_ALUNO A WHERE A.CODIGO = @COD_ALUNO;
END
GO

/* #####################################################################
   PARTE 7 - SP_MAT_RenovacaoDesfaz (versão de Anápolis)
   (origem: Anápolis banco/procedures/SP_MAT_RenovacaoDesfaz.sql)
   ##################################################################### */
/*
	SP_MAT_RenovacaoDesfaz
	Desfaz uma renovação de matrícula (botão Excluir da tela app/mat_renovacao.asp):
	apaga tudo o que a renovação gravou e restaura o backup feito por SP_MAT_RenovacaoBackup
	(disciplinas, notas e faltas com os mesmos códigos, ano letivo, situação dos vínculos e do aluno).

	BLOQUEIA (erro) se o aluno já tiver nota, falta ou avaliação lançada no ano da renovação,
	ou se não estiver mais ativo na turma da renovação.

	Renovações feitas antes do backup existir (sem cópia): desfaz o que foi inserido e reativa
	os vínculos, mas não há como recuperar disciplinas/notas/faltas antigas.

	Não abre transação: usa a da tela (qualquer erro desfaz tudo).
	WITH EXECUTE AS OWNER: necessário para restaurar os códigos originais (IDENTITY_INSERT).
	Requer banco/scripts/2026-10-28_renovacao_backup_tabelas.sql
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.SP_MAT_RenovacaoDesfaz') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_RenovacaoDesfaz AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_RenovacaoDesfaz
(
	@COD_RENOVACAO INT,
	@SOMENTE_VERIFICAR BIT = 0	-- 1 = não altera nada: devolve MOTIVO ('' = pode excluir), usado pela tela para desabilitar o botão
)
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @COD_EMPRESA INT, @COD_ALUNO INT, @TURMA_ORIGEM INT, @TURMA_DESTINO INT, @TURMA_RENOV INT,
	        @TURMA_ATUAL INT, @SIT_ATUAL VARCHAR(5),
	        @ANO_DESTINO INT, @DATA_RENOVACAO DATETIME, @NOME VARCHAR(200), @MSG NVARCHAR(1000)

	SELECT @COD_EMPRESA = R.COD_EMPRESA, @COD_ALUNO = R.COD_ALUNO, @TURMA_ORIGEM = R.COD_TURMA,
	       @TURMA_DESTINO = R.COD_TURMA_RENOVACAO, @ANO_DESTINO = R.ANO_LETIVO_RENOVACAO,
	       @DATA_RENOVACAO = R.DATA_HORA_INCL, @NOME = A.NOMEALUNO
	FROM dbo.SCA_ALUNO_RENOVACAO R
	INNER JOIN dbo.SCA_ALUNO A ON A.CODIGO = R.COD_ALUNO
	WHERE R.CODIGO = @COD_RENOVACAO;

	IF @COD_ALUNO IS NULL
	BEGIN
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT N'Renovação não encontrada.' AS MOTIVO; RETURN; END
		RAISERROR('Renovação não encontrada. Atualize a tela e tente novamente.', 16, 1);
		RETURN;
	END

	-- Aluno TROCADO DE TURMA no ano da renovação, dentro da mesma unidade, depois da renovação
	-- (ex.: renovado para a turma A e depois alocado na turma C): vale a turma ATUAL dele.
	-- @TURMA_RENOV guarda a turma original da renovação, para limpar o que tiver ficado nela.
	SET @TURMA_RENOV = @TURMA_DESTINO;
	SELECT TOP 1 @TURMA_ATUAL = AT.COD_TURMA, @SIT_ATUAL = AT.SITUACAO FROM dbo.SCA_ALUNO_TURMA AT
	WHERE AT.COD_EMPRESA = @COD_EMPRESA AND AT.COD_ALUNO = @COD_ALUNO AND AT.ANO_LETIVO = @ANO_DESTINO
	ORDER BY AT.CODIGO DESC;
	IF @SIT_ATUAL = 'A' AND @TURMA_ATUAL IS NOT NULL AND @TURMA_ATUAL <> @TURMA_DESTINO
		SET @TURMA_DESTINO = @TURMA_ATUAL;

	------------------------------------------------------------------
	-- 1) Continua ativo na turma da renovação
	------------------------------------------------------------------
	IF NOT EXISTS (
		SELECT 1 FROM (
			SELECT TOP 1 AT.COD_TURMA, AT.SITUACAO FROM dbo.SCA_ALUNO_TURMA AT
			WHERE AT.COD_EMPRESA = @COD_EMPRESA AND AT.COD_ALUNO = @COD_ALUNO AND AT.ANO_LETIVO = @ANO_DESTINO
			ORDER BY AT.CODIGO DESC
		) X WHERE X.COD_TURMA = @TURMA_DESTINO AND X.SITUACAO = 'A'
	)
	BEGIN
		SET @MSG = N'O aluno ' + @NOME + N' não está mais ativo na turma da renovação. A renovação não pode ser excluída.';
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT @MSG AS MOTIVO; RETURN; END
		RAISERROR(@MSG, 16, 1);
		RETURN;
	END

	------------------------------------------------------------------
	-- 2) Bloqueio: nota, falta ou avaliação já lançada no ano da renovação
	------------------------------------------------------------------
	DECLARE @MOTIVO NVARCHAR(500) = N'';

	-- Disciplinas do aluno na turma da renovação: notas/faltas penduradas nelas contam com o ano da renovação
	-- (ou sem ano). Registros do ANO ANTERIOR nelas NÃO bloqueiam: são a matriz que as telas de lançamento
	-- criavam com o ano da sessão (ex.: 2026) para todas as disciplinas do aluno, inclusive as da turma
	-- renovada; o acumulado de faltas diárias (por aluno/disciplina/ano) copiava o valor de 2026 para ela.
	-- Esses registros são apagados junto no desfazer (DELETE pelas disciplinas da turma da renovação).
	DECLARE @AD TABLE (CODIGO INT PRIMARY KEY);
	INSERT INTO @AD (CODIGO)
	SELECT CODIGO FROM dbo.SCA_ALUNO_DISCIPLINA WHERE COD_ALUNO = @COD_ALUNO AND COD_TURMA IN (@TURMA_DESTINO, @TURMA_RENOV);

	IF EXISTS (SELECT 1 FROM dbo.SCA_NOTAS_FALTAS
		WHERE ((cod_aluno = @COD_ALUNO AND ano_letivo = @ANO_DESTINO) OR (cod_aluno_disciplina IN (SELECT CODIGO FROM @AD) AND ISNULL(ano_letivo, @ANO_DESTINO) >= @ANO_DESTINO))
		AND COALESCE(nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05,
		             nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10,
		             nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, media) IS NOT NULL)
		SET @MOTIVO = @MOTIVO + N' notas/faltas;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_FALTAS_DIARIA WHERE cod_aluno = @COD_ALUNO AND (ano_letivo = @ANO_DESTINO OR (data >= DATEFROMPARTS(@ANO_DESTINO, 1, 1) AND data < DATEFROMPARTS(@ANO_DESTINO + 1, 1, 1))))
		SET @MOTIVO = @MOTIVO + N' faltas diárias;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_FALTAS_INTERDISCIPLINAR
		WHERE cod_aluno = @COD_ALUNO AND ano_letivo = @ANO_DESTINO
		AND COALESCE(falta01, falta02, falta03, falta04, falta05, falta06, falta07, falta08, falta09, falta10) IS NOT NULL)
		SET @MOTIVO = @MOTIVO + N' faltas interdisciplinares;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_NOTA_PARCIAL_MANUAL NP
		INNER JOIN dbo.SCA_ALUNO_DISCIPLINA AD ON AD.CODIGO = NP.COD_ALUNO_DISCIPLINA
		WHERE AD.COD_ALUNO = @COD_ALUNO AND AD.COD_TURMA = @TURMA_DESTINO AND NP.NOTA_PARCIAL IS NOT NULL)
		SET @MOTIVO = @MOTIVO + N' notas parciais;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA
		WHERE Cod_aluno = @COD_ALUNO AND Cod_Turma = @TURMA_DESTINO)
		SET @MOTIVO = @MOTIVO + N' ficha descritiva;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_ALUNO_JUSTIFICATIVA_FALTAS WHERE cod_aluno = @COD_ALUNO AND ano_letivo = @ANO_DESTINO)
		SET @MOTIVO = @MOTIVO + N' justificativas de faltas;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_OBSERVACAO_NOTAS_FALTAS WHERE COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_DESTINO)
		SET @MOTIVO = @MOTIVO + N' observações de notas/faltas;';

	-- SCA_NOTAS_PLANILHA: qualquer coluna nota.. preenchida (lista montada pelas colunas da tabela)
	DECLARE @COLS NVARCHAR(MAX), @SQL NVARCHAR(MAX), @QTD INT = 0;
	SELECT @COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
		WHERE c.object_id = OBJECT_ID('dbo.SCA_NOTAS_PLANILHA') AND c.name LIKE 'nota%'
		ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
	IF @COLS IS NOT NULL
	BEGIN
		IF CHARINDEX(',', @COLS) = 0 SET @COLS = @COLS + ', NULL';
		SET @SQL = N'SELECT @QTD = COUNT(*) FROM dbo.SCA_NOTAS_PLANILHA WHERE ((cod_aluno = @ALUNO AND ano_letivo = @ANO)'
			+ N' OR (ISNULL(ano_letivo, @ANO) >= @ANO AND cod_aluno_disciplina IN (SELECT CODIGO FROM dbo.SCA_ALUNO_DISCIPLINA WHERE COD_ALUNO = @ALUNO AND COD_TURMA = @TURMA)))'
			+ N' AND COALESCE(' + @COLS + N') IS NOT NULL';
		EXEC sp_executesql @SQL, N'@QTD INT OUTPUT, @ALUNO INT, @ANO INT, @TURMA INT', @QTD OUTPUT, @COD_ALUNO, @ANO_DESTINO, @TURMA_DESTINO;
		IF @QTD > 0 SET @MOTIVO = @MOTIVO + N' notas da planilha;';
	END

	IF @MOTIVO <> N''
	BEGIN
		SET @MSG = N'O aluno ' + @NOME + N' já tem lançamentos em ' + CAST(@ANO_DESTINO AS NVARCHAR(4)) + N' (' + LTRIM(@MOTIVO) + N'). A renovação não pode ser excluída.';
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT @MSG AS MOTIVO; RETURN; END
		RAISERROR(@MSG, 16, 1);
		RETURN;
	END

	IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT N'' AS MOTIVO; RETURN; END

	------------------------------------------------------------------
	-- 3) Apaga tudo o que a renovação inseriu
	------------------------------------------------------------------
	DELETE dbo.SCA_ALUNO_ANO_LETIVO WHERE COD_EMPRESA = @COD_EMPRESA AND COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_DESTINO;
	DELETE dbo.SCA_CONTROLE_SITUACAO_ALUNO WHERE COD_EMPRESA = @COD_EMPRESA AND COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_DESTINO;
	DELETE dbo.SCA_NOTAS_FALTAS WHERE cod_aluno = @COD_ALUNO AND ano_letivo = @ANO_DESTINO;
	DELETE NF FROM dbo.SCA_NOTAS_FALTAS NF INNER JOIN @AD D ON D.CODIGO = NF.cod_aluno_disciplina;
	DELETE dbo.SCA_NOTAS_PLANILHA WHERE cod_aluno = @COD_ALUNO AND ano_letivo = @ANO_DESTINO;
	DELETE P FROM dbo.SCA_NOTAS_PLANILHA P INNER JOIN @AD D ON D.CODIGO = P.cod_aluno_disciplina;
	-- registros vazios ligados às disciplinas (já conferido acima que não há nota parcial)
	DELETE NP FROM dbo.SCA_NOTA_PARCIAL_MANUAL NP INNER JOIN @AD D ON D.CODIGO = NP.COD_ALUNO_DISCIPLINA;
	DELETE dbo.SCA_ALUNO_DISCIPLINA WHERE COD_ALUNO = @COD_ALUNO AND COD_TURMA IN (@TURMA_DESTINO, @TURMA_RENOV);
	DELETE dbo.SCA_OCORRENCIA WHERE COD_EMPRESA = @COD_EMPRESA AND COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_DESTINO AND OCORRENCIA = 'Renovação de matrícula';
	DELETE dbo.SCA_SITUACAO_ACADEMICA_ALUNO WHERE COD_EMPRESA = @COD_EMPRESA AND COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_DESTINO AND COD_TURMA IN (@TURMA_DESTINO, @TURMA_RENOV);
	-- situações do vínculo (FK_SCA_ALUNO_TURMA_SITUACAO_SCA_ALUNO_TURMA): apagar antes do vínculo
	DELETE ATS FROM dbo.SCA_ALUNO_TURMA_SITUACAO ATS
	INNER JOIN dbo.SCA_ALUNO_TURMA AT ON AT.CODIGO = ATS.COD_ALUNO_TURMA
	WHERE AT.COD_EMPRESA = @COD_EMPRESA AND AT.COD_ALUNO = @COD_ALUNO AND AT.COD_TURMA IN (@TURMA_DESTINO, @TURMA_RENOV) AND AT.ANO_LETIVO = @ANO_DESTINO;
	DELETE dbo.SCA_ALUNO_TURMA WHERE COD_EMPRESA = @COD_EMPRESA AND COD_ALUNO = @COD_ALUNO AND COD_TURMA IN (@TURMA_DESTINO, @TURMA_RENOV) AND ANO_LETIVO = @ANO_DESTINO;
	UPDATE dbo.SCA_TURMA
	SET VagasMatriculasUtilizadas = CASE WHEN ISNULL(VagasMatriculasUtilizadas, 0) > 0 THEN VagasMatriculasUtilizadas - 1 ELSE 0 END
	WHERE Cod_Turma = @TURMA_DESTINO;

	------------------------------------------------------------------
	-- 4) Restaura o backup (mesmos códigos)
	------------------------------------------------------------------
	IF EXISTS (SELECT 1 FROM dbo.MAT_RENOVACAO_BKP_ALUNO WHERE COD_RENOVACAO = @COD_RENOVACAO)
	BEGIN
		-- vínculos: situação e data anteriores
		UPDATE AT SET AT.SITUACAO = B.SITUACAO, AT.DATA_SITUACAO = B.DATA_SITUACAO
		FROM dbo.SCA_ALUNO_TURMA AT
		INNER JOIN dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA B ON B.CODIGO = AT.CODIGO
		WHERE B.COD_RENOVACAO = @COD_RENOVACAO;

		-- situação do aluno
		UPDATE A SET A.COD_SITUACAOALUNO = B.COD_SITUACAOALUNO
		FROM dbo.SCA_ALUNO A
		INNER JOIN dbo.MAT_RENOVACAO_BKP_ALUNO B ON B.COD_ALUNO = A.CODIGO
		WHERE B.COD_RENOVACAO = @COD_RENOVACAO;

		-- disciplinas, notas, faltas e ano letivo (nesta ordem, por causa das chaves)
		DECLARE @TAB TABLE (ORDEM INT, ORIGEM SYSNAME, BKP SYSNAME);
		INSERT INTO @TAB VALUES
			(1, 'SCA_ALUNO_DISCIPLINA', 'MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA'),
			(2, 'SCA_NOTAS_FALTAS', 'MAT_RENOVACAO_BKP_NOTAS_FALTAS'),
			(3, 'SCA_FALTAS_DIARIA', 'MAT_RENOVACAO_BKP_FALTAS_DIARIA'),
			(4, 'SCA_ALUNO_ANO_LETIVO', 'MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO');

		DECLARE @ORIGEM SYSNAME, @BKP SYSNAME, @IDENT SYSNAME;
		DECLARE curT CURSOR LOCAL FAST_FORWARD FOR SELECT ORIGEM, BKP FROM @TAB ORDER BY ORDEM;
		OPEN curT;
		FETCH NEXT FROM curT INTO @ORIGEM, @BKP;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
				WHERE c.object_id = OBJECT_ID('dbo.' + @ORIGEM) AND c.is_computed = 0
				AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion')
				AND EXISTS (SELECT 1 FROM sys.columns b WHERE b.object_id = OBJECT_ID('dbo.' + @BKP) AND b.name = c.name)
				ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

			SELECT @IDENT = c.name FROM sys.columns c WHERE c.object_id = OBJECT_ID('dbo.' + @ORIGEM) AND c.is_identity = 1;

			SET @SQL = N'';
			IF @IDENT IS NOT NULL SET @SQL = N'SET IDENTITY_INSERT dbo.' + QUOTENAME(@ORIGEM) + N' ON; ';
			SET @SQL = @SQL + N'INSERT INTO dbo.' + QUOTENAME(@ORIGEM) + N' (' + @COLS + N') SELECT ' + @COLS
				+ N' FROM dbo.' + QUOTENAME(@BKP) + N' B WHERE B.COD_RENOVACAO = @ID';
			IF @IDENT IS NOT NULL
				SET @SQL = @SQL + N' AND NOT EXISTS (SELECT 1 FROM dbo.' + QUOTENAME(@ORIGEM) + N' X WHERE X.' + QUOTENAME(@IDENT) + N' = B.' + QUOTENAME(@IDENT) + N')'
					+ N'; SET IDENTITY_INSERT dbo.' + QUOTENAME(@ORIGEM) + N' OFF;';

			EXEC sp_executesql @SQL, N'@ID INT', @COD_RENOVACAO;
			SET @IDENT = NULL;
			FETCH NEXT FROM curT INTO @ORIGEM, @BKP;
		END
		CLOSE curT;
		DEALLOCATE curT;
	END
	ELSE
	BEGIN
		-- renovação antiga, sem backup: reativa o vínculo da origem e os que foram para 'R' no momento da renovação
		UPDATE dbo.SCA_ALUNO_TURMA SET SITUACAO = 'A', DATA_SITUACAO = GETDATE()
		WHERE COD_EMPRESA = @COD_EMPRESA AND COD_ALUNO = @COD_ALUNO AND SITUACAO = 'R'
		AND (CODIGO = (SELECT TOP 1 X.CODIGO FROM dbo.SCA_ALUNO_TURMA X
		               WHERE X.COD_EMPRESA = @COD_EMPRESA AND X.COD_ALUNO = @COD_ALUNO AND X.COD_TURMA = @TURMA_ORIGEM
		               ORDER BY X.CODIGO DESC)
		     OR (ANO_LETIVO < @ANO_DESTINO AND DATA_SITUACAO BETWEEN DATEADD(MINUTE, -5, @DATA_RENOVACAO) AND DATEADD(MINUTE, 5, @DATA_RENOVACAO)));
	END

	------------------------------------------------------------------
	-- 5) Remove a renovação e o backup
	------------------------------------------------------------------
	DELETE dbo.SCA_ALUNO_RENOVACAO WHERE CODIGO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO_DISCIPLINA WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_NOTAS_FALTAS WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_FALTAS_DIARIA WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO_ANO_LETIVO WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO_TURMA WHERE COD_RENOVACAO = @COD_RENOVACAO;
	DELETE dbo.MAT_RENOVACAO_BKP_ALUNO WHERE COD_RENOVACAO = @COD_RENOVACAO;
END
GO

/* #####################################################################
   PARTE 8 - SP_MAT_TipBackup (versão de Anápolis)
   (origem: Anápolis banco/procedures/SP_MAT_TipBackup.sql)
   ##################################################################### */
/*
	SP_MAT_TipBackup
	Guarda o que a TIP (transferência por interesse próprio) vai alterar, para que
	SP_MAT_TipDesfaz consiga voltar o aluno ao estado anterior.

	Chamada por app/mat_tip_cod.asp (acao I), logo depois de gravar
	SCA_TRANSFERENCIA_INTERESSE_PROPRIO e ANTES de qualquer outra alteração.
	Não abre transação: usa a da tela.
	Requer banco/scripts/2026-10-29_tip_backup_tabelas.sql
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.SP_MAT_TipBackup') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_TipBackup AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_TipBackup
(
	@COD_TIP INT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @COD_ALUNO INT, @EMP_ORIGEM INT, @EMP_DESTINO INT, @ANO INT, @ANO_D INT;

	SELECT @COD_ALUNO = COD_ALUNO, @EMP_ORIGEM = COD_EMPRESA, @EMP_DESTINO = COD_EMPRESA_DESTINO, @ANO = ANO_LETIVO, @ANO_D = ISNULL(ANO_LETIVO_DESTINO, ANO_LETIVO)
	FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE CODIGO = @COD_TIP;

	IF @COD_ALUNO IS NULL
	BEGIN
		RAISERROR('TIP não encontrada para o backup.', 16, 1);
		RETURN;
	END

	DELETE dbo.MAT_TIP_BKP_ALUNO_TURMA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_ALUNO WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_ANO_LETIVO WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_CONTROLE WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_INSERIDOS WHERE COD_TIP = @COD_TIP;

	-- vínculos ativos na unidade de origem (passam a 'T')
	INSERT INTO dbo.MAT_TIP_BKP_ALUNO_TURMA (COD_TIP, CODIGO, SITUACAO, DATA_SITUACAO)
	SELECT @COD_TIP, AT.CODIGO, AT.SITUACAO, AT.DATA_SITUACAO
	FROM dbo.SCA_ALUNO_TURMA AT
	WHERE AT.COD_EMPRESA = @EMP_ORIGEM AND AT.COD_ALUNO = @COD_ALUNO AND AT.ANO_LETIVO = @ANO AND AT.SITUACAO = 'A';

	-- situação do aluno (a unidade fica em SCA_ALUNO_ANO_LETIVO, guardado abaixo)
	INSERT INTO dbo.MAT_TIP_BKP_ALUNO (COD_TIP, COD_ALUNO, COD_SITUACAOALUNO)
	SELECT @COD_TIP, A.CODIGO, A.COD_SITUACAOALUNO FROM dbo.SCA_ALUNO A WHERE A.CODIGO = @COD_ALUNO;

	-- ano letivo da origem e do destino (o do destino só existe se o aluno já passou por lá no ano)
	INSERT INTO dbo.MAT_TIP_BKP_ANO_LETIVO (COD_TIP, COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SITUACAO, COD_SITUACAOALUNO, DATA_SITUACAO, DATAFASTAMENTO, DATAMATRICULA)
	SELECT @COD_TIP, AL.COD_EMPRESA, AL.COD_ALUNO, AL.ANO_LETIVO, AL.SITUACAO, AL.COD_SITUACAOALUNO, AL.DATA_SITUACAO, AL.DATAFASTAMENTO, AL.DATAMATRICULA
	FROM dbo.SCA_ALUNO_ANO_LETIVO AL
	WHERE AL.COD_ALUNO = @COD_ALUNO
	AND ((AL.COD_EMPRESA = @EMP_ORIGEM AND AL.ANO_LETIVO = @ANO) OR (AL.COD_EMPRESA = @EMP_DESTINO AND AL.ANO_LETIVO = @ANO_D));
END
GO

/* #####################################################################
   PARTE 9 - SP_MAT_TipCopiaHistorico (versão de Anápolis)
   (origem: Anápolis banco/procedures/SP_MAT_TipCopiaHistorico.sql)
   ##################################################################### */
/*
	SP_MAT_TipCopiaHistorico
	TIP: leva o histórico do aluno da unidade de ORIGEM para a unidade de DESTINO,
	como o recebimento por transferência (sca_aluno_cod.asp), sem alterar nada da origem:
		1) SCA_HISTORICO_ESCOLAR (+ SCA_HISTORICO_ESCOLAR_DISCIPLINA)
		2) SCA_HISTORICO_OBSERVACOES
		3) SCA_OCORRENCIA lançadas por usuário (TIPO_OCORRENCIA A/D, INCLUSAO = 'USUARIO')
	Só copia o que ainda não existe no destino. Tudo o que inclui fica em MAT_TIP_BKP_INSERIDOS,
	para o SP_MAT_TipDesfaz apagar no Excluir.

	As colunas são lidas do banco (sys.columns): se as tabelas ganharem colunas, continuam sendo copiadas.
	Chamada por app/mat_tip_cod.asp (acao I), dentro da transação da tela.
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.SP_MAT_TipCopiaHistorico') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_TipCopiaHistorico AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_TipCopiaHistorico
(
	@COD_TIP INT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ALUNO INT, @EMP_O INT, @EMP_D INT;
	SELECT @ALUNO = COD_ALUNO, @EMP_O = COD_EMPRESA, @EMP_D = COD_EMPRESA_DESTINO
	FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE CODIGO = @COD_TIP;

	IF @ALUNO IS NULL
	BEGIN
		RAISERROR('TIP não encontrada para copiar o histórico.', 16, 1);
		RETURN;
	END

	DECLARE @SQL NVARCHAR(MAX), @COLS NVARCHAR(MAX), @VALS NVARCHAR(MAX), @IDENT SYSNAME, @IDENT2 SYSNAME;

	IF OBJECT_ID('tempdb..#MAPH') IS NOT NULL DROP TABLE #MAPH;
	CREATE TABLE #MAPH (VELHO INT NOT NULL, NOVO INT NOT NULL);
	IF OBJECT_ID('tempdb..#NOVOS') IS NOT NULL DROP TABLE #NOVOS;
	CREATE TABLE #NOVOS (CODIGO INT NOT NULL);

	------------------------------------------------------------------
	-- 1) SCA_HISTORICO_ESCOLAR: anos que o destino ainda não tem
	------------------------------------------------------------------
	SELECT @IDENT = name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_HISTORICO_ESCOLAR') AND is_identity = 1;

	IF @IDENT IS NOT NULL
	BEGIN
		SELECT
			@COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
				WHERE c.object_id = OBJECT_ID('dbo.SCA_HISTORICO_ESCOLAR') AND c.is_identity = 0 AND c.is_computed = 0
				AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion')
				ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''),
			@VALS = STUFF((SELECT ',' + CASE LOWER(c.name) WHEN 'cod_empresa' THEN '@EMP_D' ELSE 'S.' + QUOTENAME(c.name) END
				FROM sys.columns c
				WHERE c.object_id = OBJECT_ID('dbo.SCA_HISTORICO_ESCOLAR') AND c.is_identity = 0 AND c.is_computed = 0
				AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion')
				ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

		SET @SQL = N'
		MERGE INTO dbo.SCA_HISTORICO_ESCOLAR AS T
		USING (
			SELECT H.* FROM dbo.SCA_HISTORICO_ESCOLAR H
			WHERE H.cod_aluno = @ALUNO AND H.cod_empresa = @EMP_O
			AND NOT EXISTS (SELECT 1 FROM dbo.SCA_HISTORICO_ESCOLAR X
				WHERE X.cod_aluno = H.cod_aluno AND X.cod_empresa = @EMP_D
				AND X.ano_letivo = H.ano_letivo
				AND ISNULL(X.semestre, 0) = ISNULL(H.semestre, 0)
				AND ISNULL(X.Cod_Curso, 0) = ISNULL(H.Cod_Curso, 0)
				AND ISNULL(X.Cod_Periodo, 0) = ISNULL(H.Cod_Periodo, 0))
		) AS S
		ON 1 = 0
		WHEN NOT MATCHED THEN INSERT (' + @COLS + N') VALUES (' + @VALS + N')
		OUTPUT S.' + QUOTENAME(@IDENT) + N', inserted.' + QUOTENAME(@IDENT) + N' INTO #MAPH (VELHO, NOVO);';
		EXEC sp_executesql @SQL, N'@ALUNO INT, @EMP_O INT, @EMP_D INT', @ALUNO, @EMP_O, @EMP_D;

		INSERT INTO dbo.MAT_TIP_BKP_INSERIDOS (COD_TIP, TABELA, CODIGO)
		SELECT @COD_TIP, 'SCA_HISTORICO_ESCOLAR', NOVO FROM #MAPH;

		-- disciplinas do histórico (apagadas no Excluir junto com o histórico, pelo cod_historico_escolar)
		IF EXISTS (SELECT 1 FROM #MAPH)
		BEGIN
			SELECT
				@COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
					WHERE c.object_id = OBJECT_ID('dbo.SCA_HISTORICO_ESCOLAR_DISCIPLINA') AND c.is_identity = 0 AND c.is_computed = 0
					AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion')
					ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''),
				@VALS = STUFF((SELECT ',' + CASE LOWER(c.name) WHEN 'cod_historico_escolar' THEN 'M.NOVO' ELSE 'D.' + QUOTENAME(c.name) END
					FROM sys.columns c
					WHERE c.object_id = OBJECT_ID('dbo.SCA_HISTORICO_ESCOLAR_DISCIPLINA') AND c.is_identity = 0 AND c.is_computed = 0
					AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion')
					ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

			SET @SQL = N'
			INSERT INTO dbo.SCA_HISTORICO_ESCOLAR_DISCIPLINA (' + @COLS + N')
			SELECT ' + @VALS + N'
			FROM dbo.SCA_HISTORICO_ESCOLAR_DISCIPLINA D
			INNER JOIN #MAPH M ON M.VELHO = D.cod_historico_escolar;';
			EXEC sp_executesql @SQL;
		END
	END

	------------------------------------------------------------------
	-- 2) SCA_HISTORICO_OBSERVACOES da origem que o destino ainda não tem
	------------------------------------------------------------------
	IF OBJECT_ID('dbo.SCA_HISTORICO_OBSERVACOES') IS NOT NULL
	BEGIN
		SET @IDENT2 = NULL;
		SELECT @IDENT2 = name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_HISTORICO_OBSERVACOES') AND is_identity = 1;
		TRUNCATE TABLE #NOVOS;

		SET @SQL = N'
		INSERT INTO dbo.SCA_HISTORICO_OBSERVACOES (Cod_empresa, ano, semestre, cod_curso, cod_turma, cod_aluno, observacoes)'
		+ CASE WHEN @IDENT2 IS NOT NULL THEN N' OUTPUT inserted.' + QUOTENAME(@IDENT2) + N' INTO #NOVOS (CODIGO)' ELSE N'' END + N'
		SELECT @EMP_D, O.ano, O.semestre, O.cod_curso, O.cod_turma, O.cod_aluno, O.observacoes
		FROM dbo.SCA_HISTORICO_OBSERVACOES O
		WHERE O.cod_aluno = @ALUNO AND O.Cod_empresa = @EMP_O
		AND NOT EXISTS (SELECT 1 FROM dbo.SCA_HISTORICO_OBSERVACOES X
			WHERE X.cod_aluno = O.cod_aluno AND X.Cod_empresa = @EMP_D
			AND ISNULL(X.ano, 0) = ISNULL(O.ano, 0) AND ISNULL(X.semestre, 0) = ISNULL(O.semestre, 0)
			AND ISNULL(X.cod_curso, 0) = ISNULL(O.cod_curso, 0) AND ISNULL(X.cod_turma, 0) = ISNULL(O.cod_turma, 0));';
		EXEC sp_executesql @SQL, N'@ALUNO INT, @EMP_O INT, @EMP_D INT', @ALUNO, @EMP_O, @EMP_D;

		IF @IDENT2 IS NOT NULL
			INSERT INTO dbo.MAT_TIP_BKP_INSERIDOS (COD_TIP, TABELA, CODIGO)
			SELECT @COD_TIP, 'SCA_HISTORICO_OBSERVACOES', CODIGO FROM #NOVOS;
		ELSE
			-- sem IDENTITY: marca que copiou (o Excluir apaga no destino as que vieram da origem)
			IF EXISTS (SELECT 1 FROM dbo.SCA_HISTORICO_OBSERVACOES WHERE cod_aluno = @ALUNO AND Cod_empresa = @EMP_O)
				INSERT INTO dbo.MAT_TIP_BKP_INSERIDOS (COD_TIP, TABELA, CODIGO) VALUES (@COD_TIP, 'SCA_HISTORICO_OBSERVACOES_SEM_CODIGO', 0);
	END

	------------------------------------------------------------------
	-- 3) Ocorrências lançadas por usuário (A/D) da origem
	------------------------------------------------------------------
	SET @IDENT2 = NULL;
	SELECT @IDENT2 = name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_OCORRENCIA') AND is_identity = 1;
	TRUNCATE TABLE #NOVOS;

	SET @SQL = N'
	INSERT INTO dbo.SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL, TIPO_OCORRENCIA, INCLUSAO)'
	+ CASE WHEN @IDENT2 IS NOT NULL THEN N' OUTPUT inserted.' + QUOTENAME(@IDENT2) + N' INTO #NOVOS (CODIGO)' ELSE N'' END + N'
	SELECT @EMP_D, O.COD_ALUNO, O.ANO_LETIVO, O.SEMESTRE, O.DATAOCORRENCIA, O.OCORRENCIA, O.USUARIO_INCL, O.TIPO_OCORRENCIA, O.INCLUSAO
	FROM dbo.SCA_OCORRENCIA O
	WHERE O.COD_ALUNO = @ALUNO AND O.COD_EMPRESA = @EMP_O
	AND O.TIPO_OCORRENCIA IN (''A'', ''D'') AND O.INCLUSAO = ''USUARIO''
	AND NOT EXISTS (SELECT 1 FROM dbo.SCA_OCORRENCIA X
		WHERE X.COD_ALUNO = O.COD_ALUNO AND X.COD_EMPRESA = @EMP_D
		AND X.DATAOCORRENCIA = O.DATAOCORRENCIA AND ISNULL(X.TIPO_OCORRENCIA, '''') = ISNULL(O.TIPO_OCORRENCIA, ''''));';
	EXEC sp_executesql @SQL, N'@ALUNO INT, @EMP_O INT, @EMP_D INT', @ALUNO, @EMP_O, @EMP_D;

	IF @IDENT2 IS NOT NULL
		INSERT INTO dbo.MAT_TIP_BKP_INSERIDOS (COD_TIP, TABELA, CODIGO)
		SELECT @COD_TIP, 'SCA_OCORRENCIA', CODIGO FROM #NOVOS;
	ELSE
		-- sem IDENTITY: marca que copiou (o Excluir apaga no destino as A/D de usuário que vieram da origem)
		INSERT INTO dbo.MAT_TIP_BKP_INSERIDOS (COD_TIP, TABELA, CODIGO) VALUES (@COD_TIP, 'SCA_OCORRENCIA_SEM_CODIGO', 0);
END
GO

/* #####################################################################
   PARTE 10 - SP_MAT_TipFotoDestino (versão de Anápolis)
   (origem: Anápolis banco/procedures/SP_MAT_TipFotoDestino.sql)
   ##################################################################### */
/*
	SP_MAT_TipFotoDestino
	TIP: guarda uma "foto" das notas, avaliações, faltas diárias e justificativas que o
	aproveitamento (SP_SCA_aproveitamento_notas_por_transferencia) levou para a turma de DESTINO.

	O Excluir (SP_MAT_TipDesfaz) compara a situação atual com esta foto:
	- igual       -> nada foi lançado no destino depois da TIP: pode desfazer
	- diferente   -> alguém lançou ou alterou nota/falta/avaliação no destino: bloqueia

	Chamada por app/mat_tip_cod.asp (acao I) DEPOIS do aproveitamento, dentro da transação da tela.
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.SP_MAT_TipFotoDestino') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_TipFotoDestino AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_TipFotoDestino
(
	@COD_TIP INT
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ALUNO INT, @EMP_D INT, @TURMA_D INT, @ANO INT;
	SELECT @ALUNO = COD_ALUNO, @EMP_D = COD_EMPRESA_DESTINO, @TURMA_D = COD_TURMA_DESTINO, @ANO = ISNULL(ANO_LETIVO_DESTINO, ANO_LETIVO)
	FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE CODIGO = @COD_TIP;

	IF @ALUNO IS NULL
	BEGIN
		RAISERROR('TIP não encontrada para a foto do destino.', 16, 1);
		RETURN;
	END

	DELETE dbo.MAT_TIP_BKP_DEST_NOTAS_FALTAS WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_NOTAS_PLANILHA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_FALTAS_DIARIA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_JUSTIFICATIVA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_JUSTIFICATIVA_DIARIA WHERE COD_TIP = @COD_TIP;

	-- mesmos filtros usados no SP_MAT_TipDesfaz
	DECLARE @F_AD NVARCHAR(400) = N'cod_aluno_disciplina IN (SELECT AD.CODIGO FROM dbo.SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = @ALUNO AND AD.COD_TURMA = @TURMA)';
	DECLARE @F_FD NVARCHAR(400) = N'cod_aluno = @ALUNO AND cod_empresa = @EMP AND ano_letivo = @ANO';
	DECLARE @F_JU NVARCHAR(400) = N'cod_aluno = @ALUNO AND cod_empresa = @EMP AND cod_turma = @TURMA AND ano_letivo = @ANO';
	DECLARE @F_JD NVARCHAR(400) = N'cod_aluno_justificativa_faltas IN (SELECT J.codigo FROM dbo.SCA_ALUNO_JUSTIFICATIVA_FALTAS J WHERE J.cod_aluno = @ALUNO AND J.cod_empresa = @EMP AND J.cod_turma = @TURMA AND J.ano_letivo = @ANO)';

	DECLARE @TAB TABLE (ORDEM INT, ORIGEM SYSNAME, BKP SYSNAME, FILTRO NVARCHAR(400));
	INSERT INTO @TAB VALUES
		(1, 'SCA_NOTAS_FALTAS', 'MAT_TIP_BKP_DEST_NOTAS_FALTAS', @F_AD),
		(2, 'SCA_NOTAS_PLANILHA', 'MAT_TIP_BKP_DEST_NOTAS_PLANILHA', @F_AD),
		(3, 'SCA_FALTAS_DIARIA', 'MAT_TIP_BKP_DEST_FALTAS_DIARIA', @F_FD),
		(4, 'SCA_ALUNO_JUSTIFICATIVA_FALTAS', 'MAT_TIP_BKP_DEST_JUSTIFICATIVA', @F_JU),
		(5, 'SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA', 'MAT_TIP_BKP_DEST_JUSTIFICATIVA_DIARIA', @F_JD);

	DECLARE @ORIGEM SYSNAME, @BKP SYSNAME, @FILTRO NVARCHAR(400), @COLS NVARCHAR(MAX), @SQL NVARCHAR(MAX);
	DECLARE curT CURSOR LOCAL FAST_FORWARD FOR SELECT ORIGEM, BKP, FILTRO FROM @TAB ORDER BY ORDEM;
	OPEN curT;
	FETCH NEXT FROM curT INTO @ORIGEM, @BKP, @FILTRO;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
			WHERE c.object_id = OBJECT_ID('dbo.' + @ORIGEM) AND c.is_computed = 0
			AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion')
			AND EXISTS (SELECT 1 FROM sys.columns b WHERE b.object_id = OBJECT_ID('dbo.' + @BKP) AND b.name = c.name)
			ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

		SET @SQL = N'INSERT INTO dbo.' + QUOTENAME(@BKP) + N' (COD_TIP, ' + @COLS + N') SELECT @ID, ' + @COLS
			+ N' FROM dbo.' + QUOTENAME(@ORIGEM) + N' WHERE ' + @FILTRO;
		EXEC sp_executesql @SQL, N'@ID INT, @ALUNO INT, @EMP INT, @TURMA INT, @ANO INT', @COD_TIP, @ALUNO, @EMP_D, @TURMA_D, @ANO;

		FETCH NEXT FROM curT INTO @ORIGEM, @BKP, @FILTRO;
	END
	CLOSE curT;
	DEALLOCATE curT;
END
GO

/* #####################################################################
   PARTE 11 - SP_MAT_TipDesfaz (versão de Anápolis)
   (origem: Anápolis banco/procedures/SP_MAT_TipDesfaz.sql)
   ##################################################################### */
/*
	SP_MAT_TipDesfaz
	Desfaz a TIP (transferência por interesse próprio): apaga tudo o que a TIP gravou na
	unidade de destino e devolve o aluno para a turma/unidade de origem, usando o backup
	feito por SP_MAT_TipBackup.

	Bloqueada se, depois da TIP, alguém lançou/alterou nota, falta ou avaliação na TURMA DE DESTINO
	(compara com a foto feita por SP_MAT_TipFotoDestino logo após o aproveitamento),
	ou se o aluno não estiver mais ativo nela.
	Apaga também o histórico levado para o destino (aproveitamento de notas, histórico escolar,
	observações e ocorrências copiadas). A origem nunca é alterada pela TIP.

	@SOMENTE_VERIFICAR = 1: não altera nada, só devolve MOTIVO ('' = pode excluir).
	Usado pela tela para mostrar o cadeado no lugar do botão Excluir.

	Só para TIP EFETIVADA (SITUACAO 'E'): a pendente não alterou nada e é excluída pela tela.
	A data de referência é a da efetivação (DATA_HORA_EFETIVACAO), quando a transferência foi feita.

	Chamada por app/mat_tip_cod.asp (acao D, unidade de destino na tela de efetivação), dentro da transação da tela.
	Requer banco/scripts/2026-10-29_tip_backup_tabelas.sql
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.SP_MAT_TipDesfaz') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_TipDesfaz AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_TipDesfaz
(
	@COD_TIP INT,
	@SOMENTE_VERIFICAR BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @COD_ALUNO INT, @EMP_ORIGEM INT, @EMP_DESTINO INT, @TURMA_ORIGEM INT, @TURMA_DESTINO INT, @ANO INT, @ANO_D INT,
	        @DATA_TIP DATETIME, @NOME VARCHAR(200), @MSG NVARCHAR(1000), @SITUACAO CHAR(1);

	SELECT @COD_ALUNO = T.COD_ALUNO, @EMP_ORIGEM = T.COD_EMPRESA, @EMP_DESTINO = T.COD_EMPRESA_DESTINO,
	       @TURMA_ORIGEM = T.COD_TURMA, @TURMA_DESTINO = T.COD_TURMA_DESTINO, @ANO = T.ANO_LETIVO, @ANO_D = ISNULL(T.ANO_LETIVO_DESTINO, T.ANO_LETIVO), @DATA_TIP = ISNULL(T.DATA_HORA_EFETIVACAO, T.DATA_HORA_INCL), @NOME = A.NOMEALUNO,
	       @SITUACAO = ISNULL(T.SITUACAO, 'E')
	FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO T
	INNER JOIN dbo.SCA_ALUNO A ON A.CODIGO = T.COD_ALUNO
	WHERE T.CODIGO = @COD_TIP;

	IF @COD_ALUNO IS NULL
	BEGIN
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT N'TIP não encontrada.' AS MOTIVO; RETURN; END
		RAISERROR('TIP não encontrada. Atualize a tela e tente novamente.', 16, 1);
		RETURN;
	END

	IF @SITUACAO <> 'E'
	BEGIN
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT N'A TIP ainda não foi efetivada: não há transferência para desfazer.' AS MOTIVO; RETURN; END
		RAISERROR('A TIP ainda não foi efetivada: não há transferência para desfazer.', 16, 1);
		RETURN;
	END

	------------------------------------------------------------------
	-- 1) Continua ativo na turma de destino
	------------------------------------------------------------------
	IF NOT EXISTS (
		SELECT 1 FROM (
			SELECT TOP 1 AT.COD_TURMA, AT.SITUACAO FROM dbo.SCA_ALUNO_TURMA AT
			WHERE AT.COD_EMPRESA = @EMP_DESTINO AND AT.COD_ALUNO = @COD_ALUNO AND AT.ANO_LETIVO = @ANO_D
			ORDER BY AT.CODIGO DESC
		) X WHERE X.COD_TURMA = @TURMA_DESTINO AND X.SITUACAO = 'A'
	)
	BEGIN
		SET @MSG = N'O aluno ' + @NOME + N' não está mais ativo na turma de destino. A TIP não pode ser excluída.';
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT @MSG AS MOTIVO; RETURN; END
		RAISERROR(@MSG, 16, 1);
		RETURN;
	END

	------------------------------------------------------------------
	-- 2) Bloqueio: nota, falta ou avaliação lançada/alterada na TURMA DE DESTINO depois da TIP
	--    (linha criada pela tela de lançamento só com as chaves, valores NULL, não conta)
	--    O que o aproveitamento levou da origem está na "foto" (SP_MAT_TipFotoDestino):
	--    se o destino continua igual à foto, nada foi lançado lá e pode desfazer.
	------------------------------------------------------------------
	DECLARE @AD TABLE (CODIGO INT PRIMARY KEY);
	INSERT INTO @AD (CODIGO)
	SELECT AD.CODIGO FROM dbo.SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = @COD_ALUNO AND AD.COD_TURMA = @TURMA_DESTINO;

	DECLARE @MOTIVO NVARCHAR(500) = N'';
	DECLARE @COLS NVARCHAR(MAX), @SQL NVARCHAR(MAX), @QTD INT = 0, @VALS NVARCHAR(MAX);

	-- mesmos filtros da foto
	DECLARE @F_AD NVARCHAR(400) = N'cod_aluno_disciplina IN (SELECT AD.CODIGO FROM dbo.SCA_ALUNO_DISCIPLINA AD WHERE AD.COD_ALUNO = @ALUNO AND AD.COD_TURMA = @TURMA)';
	DECLARE @F_FD NVARCHAR(400) = N'cod_aluno = @ALUNO AND cod_empresa = @EMP AND ano_letivo = @ANO_D';
	DECLARE @F_JU NVARCHAR(400) = N'cod_aluno = @ALUNO AND cod_empresa = @EMP AND cod_turma = @TURMA AND ano_letivo = @ANO_D';
	DECLARE @F_JD NVARCHAR(400) = N'cod_aluno_justificativa_faltas IN (SELECT J.codigo FROM dbo.SCA_ALUNO_JUSTIFICATIVA_FALTAS J WHERE J.cod_aluno = @ALUNO AND J.cod_empresa = @EMP AND J.cod_turma = @TURMA AND J.ano_letivo = @ANO_D)';

	DECLARE @CMP TABLE (ORDEM INT, ORIGEM SYSNAME, BKP SYSNAME, FILTRO NVARCHAR(400), TEXTO NVARCHAR(60));
	INSERT INTO @CMP VALUES
		(1, 'SCA_NOTAS_FALTAS', 'MAT_TIP_BKP_DEST_NOTAS_FALTAS', @F_AD, N' notas/faltas;'),
		(2, 'SCA_NOTAS_PLANILHA', 'MAT_TIP_BKP_DEST_NOTAS_PLANILHA', @F_AD, N' notas da planilha;'),
		(3, 'SCA_FALTAS_DIARIA', 'MAT_TIP_BKP_DEST_FALTAS_DIARIA', @F_FD, N' faltas diárias;'),
		(4, 'SCA_ALUNO_JUSTIFICATIVA_FALTAS', 'MAT_TIP_BKP_DEST_JUSTIFICATIVA', @F_JU, N' justificativas de faltas;'),
		(5, 'SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA', 'MAT_TIP_BKP_DEST_JUSTIFICATIVA_DIARIA', @F_JD, N' justificativas de faltas;');

	DECLARE @ORIGEM SYSNAME, @BKP SYSNAME, @FILTRO NVARCHAR(400), @TEXTO NVARCHAR(60);
	DECLARE curC CURSOR LOCAL FAST_FORWARD FOR SELECT ORIGEM, BKP, FILTRO, TEXTO FROM @CMP ORDER BY ORDEM;
	OPEN curC;
	FETCH NEXT FROM curC INTO @ORIGEM, @BKP, @FILTRO, @TEXTO;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- colunas comparáveis (sem text/ntext/image/xml/timestamp), presentes nas duas tabelas
		SET @COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
			WHERE c.object_id = OBJECT_ID('dbo.' + @ORIGEM) AND c.is_computed = 0
			AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion', 'text', 'ntext', 'image', 'xml')
			AND EXISTS (SELECT 1 FROM sys.columns b WHERE b.object_id = OBJECT_ID('dbo.' + @BKP) AND b.name = c.name)
			ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

		-- colunas de VALOR (notas, faltas, conceitos...): ignora identidade, chaves (cod_*, codigo), ano,
		-- semestre, situação e auditoria. A tela de lançamento cria a linha do aluno só com as chaves
		-- (valores NULL) ao ser aberta: essa linha vazia não é lançamento e não bloqueia.
		SET @VALS = STUFF((SELECT ' OR ' + QUOTENAME(c.name) + ' IS NOT NULL' FROM sys.columns c
			WHERE c.object_id = OBJECT_ID('dbo.' + @ORIGEM) AND c.is_computed = 0 AND c.is_identity = 0
			AND TYPE_NAME(c.user_type_id) NOT IN ('timestamp', 'rowversion', 'text', 'ntext', 'image', 'xml')
			AND c.name NOT LIKE 'cod[_]%' AND c.name NOT LIKE 'cod%[_]%' AND c.name <> 'codigo'
			AND c.name NOT LIKE 'ano%' AND c.name NOT LIKE 'semestre%' AND c.name NOT LIKE 'situacao%'
			AND c.name NOT LIKE 'usuario%' AND c.name NOT LIKE 'data%' AND c.name NOT LIKE 'dt[_]%'
			AND c.name NOT LIKE '%[_]incl' AND c.name NOT LIKE '%[_]altr' AND c.name <> 'tela'
			ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 4, '');
		IF @VALS IS NULL SET @VALS = N'1 = 1';

		SET @QTD = 0;
		SET @SQL = N'SELECT @QTD = COUNT(*) FROM ('
			+ N'(SELECT ' + @COLS + N' FROM dbo.' + QUOTENAME(@ORIGEM) + N' WHERE ' + @FILTRO + N' AND (' + @VALS + N')'
			+ N' EXCEPT SELECT ' + @COLS + N' FROM dbo.' + QUOTENAME(@BKP) + N' WHERE COD_TIP = @ID)'
			+ N' UNION ALL '
			+ N'(SELECT ' + @COLS + N' FROM dbo.' + QUOTENAME(@BKP) + N' WHERE COD_TIP = @ID'
			+ N' EXCEPT SELECT ' + @COLS + N' FROM dbo.' + QUOTENAME(@ORIGEM) + N' WHERE ' + @FILTRO + N')) X';
		EXEC sp_executesql @SQL, N'@QTD INT OUTPUT, @ID INT, @ALUNO INT, @EMP INT, @TURMA INT, @ANO_D INT',
			@QTD OUTPUT, @COD_TIP, @COD_ALUNO, @EMP_DESTINO, @TURMA_DESTINO, @ANO_D;
		IF @QTD > 0 AND CHARINDEX(@TEXTO, @MOTIVO) = 0 SET @MOTIVO = @MOTIVO + @TEXTO;

		FETCH NEXT FROM curC INTO @ORIGEM, @BKP, @FILTRO, @TEXTO;
	END
	CLOSE curC;
	DEALLOCATE curC;

	-- lançamentos que o aproveitamento não leva: qualquer registro no destino bloqueia
	IF EXISTS (SELECT 1 FROM dbo.SCA_NOTA_PARCIAL_MANUAL NP INNER JOIN @AD D ON D.CODIGO = NP.COD_ALUNO_DISCIPLINA
		WHERE NP.NOTA_PARCIAL IS NOT NULL)
		SET @MOTIVO = @MOTIVO + N' notas parciais;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA WHERE Cod_aluno = @COD_ALUNO AND Cod_Turma = @TURMA_DESTINO)
		SET @MOTIVO = @MOTIVO + N' ficha descritiva;';

	IF EXISTS (SELECT 1 FROM dbo.SCA_OBSERVACAO_NOTAS_FALTAS
		WHERE COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_D AND COD_EMPRESA = @EMP_DESTINO AND DATA_HORA_INCL >= @DATA_TIP)
		SET @MOTIVO = @MOTIVO + N' observações de notas/faltas;';

	-- SCA_FALTAS_INTERDISCIPLINAR: qualquer falta.. preenchida na turma de destino
	IF COL_LENGTH('dbo.SCA_FALTAS_INTERDISCIPLINAR', 'cod_turma') IS NOT NULL
	BEGIN
		SET @COLS = NULL;
		SELECT @COLS = STUFF((SELECT ',' + QUOTENAME(c.name) FROM sys.columns c
			WHERE c.object_id = OBJECT_ID('dbo.SCA_FALTAS_INTERDISCIPLINAR') AND c.name LIKE 'falta[0-9]%'
			ORDER BY c.column_id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
		IF @COLS IS NOT NULL
		BEGIN
			IF CHARINDEX(',', @COLS) = 0 SET @COLS = @COLS + ', NULL';
			SET @QTD = 0;
			SET @SQL = N'SELECT @QTD = COUNT(*) FROM dbo.SCA_FALTAS_INTERDISCIPLINAR WHERE cod_aluno = @ALUNO AND cod_turma = @TURMA AND COALESCE(' + @COLS + N') IS NOT NULL';
			EXEC sp_executesql @SQL, N'@QTD INT OUTPUT, @ALUNO INT, @TURMA INT', @QTD OUTPUT, @COD_ALUNO, @TURMA_DESTINO;
			IF @QTD > 0 SET @MOTIVO = @MOTIVO + N' faltas interdisciplinares;';
		END
	END

	IF @MOTIVO <> N''
	BEGIN
		SET @MSG = N'O aluno ' + @NOME + N' já tem lançamentos na turma de destino depois da TIP (' + LTRIM(@MOTIVO) + N'). A TIP não pode ser excluída.';
		IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT @MSG AS MOTIVO; RETURN; END
		RAISERROR(@MSG, 16, 1);
		RETURN;
	END

	IF @SOMENTE_VERIFICAR = 1 BEGIN SELECT N'' AS MOTIVO; RETURN; END

	------------------------------------------------------------------
	-- 3) Apaga tudo o que a TIP gravou no DESTINO
	------------------------------------------------------------------
	-- notas, avaliações, faltas e justificativas levadas pelo aproveitamento (a origem não foi alterada)
	DELETE JD FROM dbo.SCA_ALUNO_JUSTIFICATIVA_FALTAS_DIARIA JD
	WHERE JD.cod_aluno_justificativa_faltas IN (SELECT J.codigo FROM dbo.SCA_ALUNO_JUSTIFICATIVA_FALTAS J
		WHERE J.cod_aluno = @COD_ALUNO AND J.cod_empresa = @EMP_DESTINO AND J.cod_turma = @TURMA_DESTINO AND J.ano_letivo = @ANO_D);
	DELETE dbo.SCA_ALUNO_JUSTIFICATIVA_FALTAS
	WHERE cod_aluno = @COD_ALUNO AND cod_empresa = @EMP_DESTINO AND cod_turma = @TURMA_DESTINO AND ano_letivo = @ANO_D;
	DELETE F FROM dbo.SCA_FALTAS_DIARIA F INNER JOIN @AD D ON D.CODIGO = F.cod_aluno_disciplina;
	DELETE NF FROM dbo.SCA_NOTAS_FALTAS NF INNER JOIN @AD D ON D.CODIGO = NF.cod_aluno_disciplina;
	DELETE P FROM dbo.SCA_NOTAS_PLANILHA P INNER JOIN @AD D ON D.CODIGO = P.cod_aluno_disciplina;
	DELETE AD FROM dbo.SCA_ALUNO_DISCIPLINA AD INNER JOIN @AD D ON D.CODIGO = AD.CODIGO;

	-- histórico escolar, observações e ocorrências copiados da origem
	DECLARE @IDENT SYSNAME;
	DELETE HD FROM dbo.SCA_HISTORICO_ESCOLAR_DISCIPLINA HD
	INNER JOIN dbo.MAT_TIP_BKP_INSERIDOS I ON I.CODIGO = HD.cod_historico_escolar AND I.TABELA = 'SCA_HISTORICO_ESCOLAR'
	WHERE I.COD_TIP = @COD_TIP;

	SET @IDENT = NULL;
	SELECT @IDENT = name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_HISTORICO_ESCOLAR') AND is_identity = 1;
	IF @IDENT IS NOT NULL
	BEGIN
		SET @SQL = N'DELETE H FROM dbo.SCA_HISTORICO_ESCOLAR H INNER JOIN dbo.MAT_TIP_BKP_INSERIDOS I ON I.CODIGO = H.' + QUOTENAME(@IDENT)
			+ N' AND I.TABELA = ''SCA_HISTORICO_ESCOLAR'' WHERE I.COD_TIP = @ID';
		EXEC sp_executesql @SQL, N'@ID INT', @COD_TIP;
	END

	IF OBJECT_ID('dbo.SCA_HISTORICO_OBSERVACOES') IS NOT NULL
	BEGIN
		SET @IDENT = NULL;
		SELECT @IDENT = name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_HISTORICO_OBSERVACOES') AND is_identity = 1;
		IF @IDENT IS NOT NULL
		BEGIN
			SET @SQL = N'DELETE O FROM dbo.SCA_HISTORICO_OBSERVACOES O INNER JOIN dbo.MAT_TIP_BKP_INSERIDOS I ON I.CODIGO = O.' + QUOTENAME(@IDENT)
				+ N' AND I.TABELA = ''SCA_HISTORICO_OBSERVACOES'' WHERE I.COD_TIP = @ID';
			EXEC sp_executesql @SQL, N'@ID INT', @COD_TIP;
		END
		ELSE IF EXISTS (SELECT 1 FROM dbo.MAT_TIP_BKP_INSERIDOS WHERE COD_TIP = @COD_TIP AND TABELA = 'SCA_HISTORICO_OBSERVACOES_SEM_CODIGO')
			DELETE D FROM dbo.SCA_HISTORICO_OBSERVACOES D
			WHERE D.cod_aluno = @COD_ALUNO AND D.Cod_empresa = @EMP_DESTINO
			AND EXISTS (SELECT 1 FROM dbo.SCA_HISTORICO_OBSERVACOES O
				WHERE O.cod_aluno = D.cod_aluno AND O.Cod_empresa = @EMP_ORIGEM
				AND ISNULL(O.ano, 0) = ISNULL(D.ano, 0) AND ISNULL(O.semestre, 0) = ISNULL(D.semestre, 0)
				AND ISNULL(O.cod_curso, 0) = ISNULL(D.cod_curso, 0) AND ISNULL(O.cod_turma, 0) = ISNULL(D.cod_turma, 0));
	END

	SET @IDENT = NULL;
	SELECT @IDENT = name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SCA_OCORRENCIA') AND is_identity = 1;
	IF @IDENT IS NOT NULL
	BEGIN
		SET @SQL = N'DELETE O FROM dbo.SCA_OCORRENCIA O INNER JOIN dbo.MAT_TIP_BKP_INSERIDOS I ON I.CODIGO = O.' + QUOTENAME(@IDENT)
			+ N' AND I.TABELA = ''SCA_OCORRENCIA'' WHERE I.COD_TIP = @ID';
		EXEC sp_executesql @SQL, N'@ID INT', @COD_TIP;
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.MAT_TIP_BKP_INSERIDOS WHERE COD_TIP = @COD_TIP AND TABELA = 'SCA_OCORRENCIA_SEM_CODIGO')
		DELETE D FROM dbo.SCA_OCORRENCIA D
		WHERE D.COD_ALUNO = @COD_ALUNO AND D.COD_EMPRESA = @EMP_DESTINO
		AND D.TIPO_OCORRENCIA IN ('A', 'D') AND D.INCLUSAO = 'USUARIO'
		AND EXISTS (SELECT 1 FROM dbo.SCA_OCORRENCIA O
			WHERE O.COD_ALUNO = D.COD_ALUNO AND O.COD_EMPRESA = @EMP_ORIGEM
			AND O.DATAOCORRENCIA = D.DATAOCORRENCIA AND ISNULL(O.TIPO_OCORRENCIA, '') = ISNULL(D.TIPO_OCORRENCIA, ''));

	-- controle de situação gravado pela TIP (origem = 5 Transferido, destino = 1 Ativo):
	-- pelos códigos guardados e, por segurança, os gravados nas duas unidades a partir da TIP
	DELETE C FROM dbo.SCA_CONTROLE_SITUACAO_ALUNO C
	INNER JOIN dbo.MAT_TIP_BKP_CONTROLE B ON B.CODIGO = C.CODIGO
	WHERE B.COD_TIP = @COD_TIP;

	DELETE dbo.SCA_CONTROLE_SITUACAO_ALUNO
	WHERE COD_ALUNO = @COD_ALUNO
	AND ((COD_EMPRESA = @EMP_ORIGEM AND ANO_LETIVO = @ANO AND COD_SITUACAOALUNO = 5)
	  OR (COD_EMPRESA = @EMP_DESTINO AND ANO_LETIVO = @ANO_D AND COD_SITUACAOALUNO = 1))
	AND DATA_SITUACAO >= DATEADD(SECOND, -5, @DATA_TIP);

	-- a ocorrência da TIP NÃO é apagada: fica no histórico, junto com a ocorrência da exclusão (gravada pela tela)

	DELETE dbo.SCA_SITUACAO_ACADEMICA_ALUNO
	WHERE COD_EMPRESA = @EMP_DESTINO AND COD_ALUNO = @COD_ALUNO AND ANO_LETIVO = @ANO_D AND COD_TURMA = @TURMA_DESTINO;

	DELETE dbo.SCA_ALUNO_TURMA
	WHERE COD_EMPRESA = @EMP_DESTINO AND COD_ALUNO = @COD_ALUNO AND COD_TURMA = @TURMA_DESTINO AND ANO_LETIVO = @ANO_D;

	-- vagas: devolve a do destino
	UPDATE dbo.SCA_TURMA SET VagasMatriculasUtilizadas = CASE WHEN ISNULL(VagasMatriculasUtilizadas, 0) > 0 THEN VagasMatriculasUtilizadas - 1 ELSE 0 END
	WHERE Cod_Turma = @TURMA_DESTINO;
	-- TIP do mesmo ano (versão anterior) liberava a vaga da origem: devolve só nesse caso
	IF @ANO_D = @ANO
		UPDATE dbo.SCA_TURMA SET VagasMatriculasUtilizadas = ISNULL(VagasMatriculasUtilizadas, 0) + 1
		WHERE Cod_Turma = @TURMA_ORIGEM;

	-- ano letivo do destino: volta como estava (se já existia) ou é apagado (se foi criado pela TIP)
	UPDATE AL SET AL.SITUACAO = B.SITUACAO, AL.COD_SITUACAOALUNO = B.COD_SITUACAOALUNO,
		AL.DATA_SITUACAO = B.DATA_SITUACAO, AL.DATAFASTAMENTO = B.DATAFASTAMENTO, AL.DATAMATRICULA = B.DATAMATRICULA
	FROM dbo.SCA_ALUNO_ANO_LETIVO AL
	INNER JOIN dbo.MAT_TIP_BKP_ANO_LETIVO B ON B.COD_EMPRESA = AL.COD_EMPRESA AND B.COD_ALUNO = AL.COD_ALUNO AND B.ANO_LETIVO = AL.ANO_LETIVO
	WHERE B.COD_TIP = @COD_TIP AND AL.COD_EMPRESA IN (@EMP_ORIGEM, @EMP_DESTINO);

	DELETE AL FROM dbo.SCA_ALUNO_ANO_LETIVO AL
	WHERE AL.COD_EMPRESA = @EMP_DESTINO AND AL.COD_ALUNO = @COD_ALUNO AND AL.ANO_LETIVO = @ANO_D
	AND NOT EXISTS (SELECT 1 FROM dbo.MAT_TIP_BKP_ANO_LETIVO B
	                WHERE B.COD_TIP = @COD_TIP AND B.COD_EMPRESA = @EMP_DESTINO);

	------------------------------------------------------------------
	-- 4) Devolve o aluno para a origem
	------------------------------------------------------------------
	UPDATE AT SET AT.SITUACAO = B.SITUACAO, AT.DATA_SITUACAO = B.DATA_SITUACAO
	FROM dbo.SCA_ALUNO_TURMA AT
	INNER JOIN dbo.MAT_TIP_BKP_ALUNO_TURMA B ON B.CODIGO = AT.CODIGO
	WHERE B.COD_TIP = @COD_TIP;

	UPDATE A SET A.COD_SITUACAOALUNO = B.COD_SITUACAOALUNO
	FROM dbo.SCA_ALUNO A
	INNER JOIN dbo.MAT_TIP_BKP_ALUNO B ON B.COD_ALUNO = A.CODIGO
	WHERE B.COD_TIP = @COD_TIP;

	------------------------------------------------------------------
	-- 5) Apaga a TIP e o backup
	------------------------------------------------------------------
	DELETE dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE CODIGO = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_ALUNO_TURMA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_ALUNO WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_ANO_LETIVO WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_CONTROLE WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_INSERIDOS WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_NOTAS_FALTAS WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_NOTAS_PLANILHA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_FALTAS_DIARIA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_JUSTIFICATIVA WHERE COD_TIP = @COD_TIP;
	DELETE dbo.MAT_TIP_BKP_DEST_JUSTIFICATIVA_DIARIA WHERE COD_TIP = @COD_TIP;
END
GO

/* #####################################################################
   PARTE 12 - FN_MAT_TipPrazoConfirmacao e SP_MAT_TipCancelaVencidas (versão de Anápolis)
   (origem: Anápolis banco/procedures/SP_MAT_TipCancelaVencidas.sql)
   ##################################################################### */
/*
	FN_MAT_TipPrazoConfirmacao + SP_MAT_TipCancelaVencidas
	Data: 04/11/2026

	Prazo: 02 dias úteis a contar da emissão do comprovante (1ª impressão; sem impressão,
	a data de inclusão da TIP). Dia útil = segunda a sexta, menos os feriados do calendário
	da unidade de DESTINO (SCA_CALENDARIO_DIA_UE, evento 24 = FERIADO).
	A TIP pendente vence quando a data de hoje passa do prazo (o último dia do prazo ainda vale).

	SP_MAT_TipCancelaVencidas:
		@SOMENTE_LISTAR = 1 -> só mostra as TIP vencidas, não altera nada (conferência)
		@SOMENTE_LISTAR = 0 -> cancela: SITUACAO = 'C', libera a vaga e grava ocorrência na origem
	Rodada pelo job diário (banco/scripts/2026-11-04_tip_cancelamento.sql, parte 2).
	Requer banco/scripts/2026-11-04_tip_cancelamento.sql (parte 1).
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.FN_MAT_TipPrazoConfirmacao') IS NULL
	EXEC('CREATE FUNCTION dbo.FN_MAT_TipPrazoConfirmacao (@COD_TIP INT) RETURNS DATE AS BEGIN RETURN NULL END');
GO
ALTER FUNCTION dbo.FN_MAT_TipPrazoConfirmacao (@COD_TIP INT)
RETURNS DATE
AS
BEGIN
	DECLARE @DIA DATE, @EMP INT, @UTEIS INT = 0, @DOW INT, @GIRO INT = 0;

	SELECT @DIA = CAST(ISNULL(DATA_EMISSAO_COMPROVANTE, DATA_HORA_INCL) AS DATE), @EMP = COD_EMPRESA_DESTINO
	FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO WHERE CODIGO = @COD_TIP;

	IF @DIA IS NULL RETURN NULL;

	WHILE @UTEIS < 2 AND @GIRO < 60
	BEGIN
		SET @DIA = DATEADD(DAY, 1, @DIA);
		SET @GIRO = @GIRO + 1;
		SET @DOW = DATEDIFF(DAY, '19000101', @DIA) % 7;		-- 0 = segunda ... 5 = sábado, 6 = domingo (independe do DATEFIRST)
		IF @DOW < 5 AND NOT EXISTS (
			SELECT 1 FROM dbo.SCA_CALENDARIO_DIA_UE D
			INNER JOIN dbo.SCA_CALENDARIO_UE C ON C.COD_CALENDARIO_UE = D.COD_CALENDARIO_UE
			WHERE C.COD_EMPRESA = @EMP AND D.COD_CALENDARIO_EVENTO = 24
			AND D.ANO = YEAR(@DIA) AND D.MES = MONTH(@DIA) AND D.DIA_MES = DAY(@DIA))
			SET @UTEIS = @UTEIS + 1;
	END

	RETURN @DIA;
END
GO

IF OBJECT_ID('dbo.SP_MAT_TipCancelaVencidas') IS NULL
	EXEC('CREATE PROCEDURE dbo.SP_MAT_TipCancelaVencidas AS RETURN 0');
GO
ALTER PROCEDURE dbo.SP_MAT_TipCancelaVencidas
(
	@SOMENTE_LISTAR BIT = 0,
	@USUARIO VARCHAR(50) = 'cancelamento automático'
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @HOJE DATE = CAST(GETDATE() AS DATE);

	DECLARE @VENCIDAS TABLE (COD_TIP INT PRIMARY KEY, COD_ALUNO INT, COD_EMPRESA INT, COD_EMPRESA_DESTINO INT,
		ANO_LETIVO INT, SEMESTRE INT, COD_TURMA_DESTINO INT, PRAZO DATE, UNIDADE_DESTINO VARCHAR(200));

	INSERT INTO @VENCIDAS
	SELECT T.CODIGO, T.COD_ALUNO, T.COD_EMPRESA, T.COD_EMPRESA_DESTINO, T.ANO_LETIVO, ISNULL(T.SEMESTRE, 3), T.COD_TURMA_DESTINO,
		dbo.FN_MAT_TipPrazoConfirmacao(T.CODIGO), E.RAZAOSOCIAL
	FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO T
	LEFT JOIN dbo.SEG_EMPRESA E ON E.CODIGO = T.COD_EMPRESA_DESTINO
	WHERE T.SITUACAO = 'P'
	AND dbo.FN_MAT_TipPrazoConfirmacao(T.CODIGO) < @HOJE;

	IF @SOMENTE_LISTAR = 1
	BEGIN
		SELECT V.COD_TIP, A.MATRICULA, A.NOMEALUNO, V.UNIDADE_DESTINO, V.PRAZO
		FROM @VENCIDAS V INNER JOIN dbo.SCA_ALUNO A ON A.CODIGO = V.COD_ALUNO
		ORDER BY V.PRAZO, A.NOMEALUNO;
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM @VENCIDAS)
	BEGIN
		PRINT 'Nenhuma TIP vencida.';
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION;

		UPDATE T SET T.SITUACAO = 'C', T.DATA_HORA_CANCELAMENTO = GETDATE(), T.USUARIO_CANCELAMENTO = @USUARIO,
			T.MOTIVO_CANCELAMENTO = 'Matrícula não confirmada na unidade de destino no prazo de 02 dias úteis (até ' + CONVERT(VARCHAR(10), V.PRAZO, 103) + ')'
		FROM dbo.SCA_TRANSFERENCIA_INTERESSE_PROPRIO T
		INNER JOIN @VENCIDAS V ON V.COD_TIP = T.CODIGO
		WHERE T.SITUACAO = 'P';

		-- a vaga é liberada pela própria mudança para 'C': TIP pendente não soma no contador da turma
		-- (VagasMatriculasUtilizadas só muda na efetivação)

		-- ocorrência na origem (o aluno continua lá)
		INSERT INTO dbo.SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL)
		SELECT V.COD_EMPRESA, V.COD_ALUNO, V.ANO_LETIVO, V.SEMESTRE, GETDATE(), NULL,
			'TIP cancelada (transferência por interesse próprio para ' + ISNULL(V.UNIDADE_DESTINO, '') + '): matrícula não confirmada na unidade de destino no prazo de 02 dias úteis (até ' + CONVERT(VARCHAR(10), V.PRAZO, 103) + '). O aluno continua nesta unidade.',
			@USUARIO
		FROM @VENCIDAS V;

		COMMIT TRANSACTION;
		DECLARE @QTD_CANC INT;
		SELECT @QTD_CANC = COUNT(*) FROM @VENCIDAS;
		PRINT CAST(@QTD_CANC AS VARCHAR(10)) + ' TIP(s) cancelada(s).';
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		DECLARE @MSG NVARCHAR(2000) = ERROR_MESSAGE();
		RAISERROR(@MSG, 16, 1);
	END CATCH
END
GO

SET NOEXEC OFF;
GO
PRINT 'Lote 3 (estrutura) concluído.';
GO
