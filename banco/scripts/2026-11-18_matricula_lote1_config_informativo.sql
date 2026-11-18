/* =====================================================================
   GUAPÓ - Matrícula (migração para o layout novo) - Lote 1
   Configurações (períodos) e Informativo - igual a Anápolis
   Data: 18/11/2026

   Rodar no banco de GUAPÓ (não no de Anápolis).

   Parte 1 - Tabela MAT_CONFIGURACAO_PERIODO (igual Anápolis), carga com as datas em
             branco = sem restrição. Nada muda até preencher as datas na tela.
   Parte 2 - Menu:
     - Item 413 "Informativo - Matrícula": passa a abrir app/mat_informativo.asp
       (ITEM_INFO_URL_NOVO). O endereço antigo fica guardado em ITEM_INFO_URL.
     - Item novo "Configurações" no mesmo menu (Cadastro) do item 413, com os mesmos
       perfis do item 413.

   Como usar: rode com @Gravar = 0 e confira; depois rode com @Gravar = 1.
   Pode rodar mais de uma vez.
   Para voltar o Informativo para a tela antiga:
     UPDATE SEG_ITENS_SISTEMA SET ITEM_INFO_URL_NOVO = NULL WHERE ITEM_CODG = 413
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

/* ===================== Parte 1: tabela e carga inicial ===================== */
IF OBJECT_ID('dbo.MAT_CONFIGURACAO_PERIODO') IS NULL
BEGIN
	CREATE TABLE dbo.MAT_CONFIGURACAO_PERIODO (
		CODIGO			INT IDENTITY(1,1) NOT NULL,
		COD_GRUPO		INT NOT NULL,
		FUNCIONALIDADE	VARCHAR(30) NOT NULL,
		DESCRICAO		VARCHAR(100) NOT NULL,
		DATA_INICIO		DATETIME NULL,
		DATA_FIM		DATETIME NULL,
		USUARIO_ALTR	VARCHAR(50) NULL,
		DATA_HORA_ALTR	DATETIME NOT NULL CONSTRAINT DF_MAT_CONFIGURACAO_PERIODO_DATA DEFAULT (GETDATE()),
		CONSTRAINT PK_MAT_CONFIGURACAO_PERIODO PRIMARY KEY CLUSTERED (CODIGO),
		CONSTRAINT UQ_MAT_CONFIGURACAO_PERIODO UNIQUE (COD_GRUPO, FUNCIONALIDADE)
	);
	PRINT 'Tabela MAT_CONFIGURACAO_PERIODO criada.';
END
GO

IF COL_LENGTH('dbo.MAT_CONFIGURACAO_PERIODO', 'PERFIS_LIBERADOS') IS NULL
	ALTER TABLE dbo.MAT_CONFIGURACAO_PERIODO ADD PERFIS_LIBERADOS VARCHAR(200) NULL;
GO

INSERT INTO dbo.MAT_CONFIGURACAO_PERIODO (COD_GRUPO, FUNCIONALIDADE, DESCRICAO, USUARIO_ALTR)
SELECT G.COD_GRUPO, F.FUNCIONALIDADE, F.DESCRICAO, 'carga inicial'
FROM (SELECT DISTINCT COD_GRUPO FROM dbo.SEG_EMPRESA WHERE COD_GRUPO IS NOT NULL) G
CROSS JOIN (VALUES
	('SITE_MATRICULA',	'Site da matrícula (inscrições)'),
	('EFETIVACAO',		'Efetivação'),
	('RENOVACAO',		'Renovação'),
	('TIP',				'TIP - Transferência por interesse próprio'),
	('REMANEJAMENTO',	'Remanejamento'),
	('AJUSTE_ALOCACAO',	'Ajuste de alocação'),
	('TRANSFERENCIA',	'Transferência')
) F (FUNCIONALIDADE, DESCRICAO)
WHERE NOT EXISTS (SELECT 1 FROM dbo.MAT_CONFIGURACAO_PERIODO X WHERE X.COD_GRUPO = G.COD_GRUPO AND X.FUNCIONALIDADE = F.FUNCIONALIDADE);
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' configuração(ões) incluída(s).';
GO

/* ===================== Parte 2: menu ===================== */
DECLARE @Gravar BIT = 0;   -- 0 = só mostra | 1 = grava

DECLARE @ItemInformativo DECIMAL(6,0) = 413;
DECLARE @ItemNovo        DECIMAL(6,0);
DECLARE @UrlModelo       VARCHAR(500);
DECLARE @Prefixo         VARCHAR(500);

/* formato do endereço das telas novas: copia de um item MAT que já abre uma tela app/mat_*.asp
   (ex.: Receber transferência / Efetivação) */
SELECT TOP 1 @UrlModelo = ITEM_INFO_URL_NOVO FROM SEG_ITENS_SISTEMA
WHERE ITEM_INFO_URL_NOVO LIKE '%mat[_]%.asp%' AND ITEM_STAT = 'A'
ORDER BY CASE WHEN ITEM_SIST_SIGL = 'MAT' THEN 0 ELSE 1 END, ITEM_CODG;
SET @Prefixo = LEFT(@UrlModelo, CHARINDEX('mat_', @UrlModelo) - 1);
SELECT @UrlModelo AS url_modelo, @Prefixo AS prefixo_usado;

SELECT @ItemNovo = ITEM_CODG FROM SEG_ITENS_SISTEMA
WHERE ITEM_SIST_SIGL = 'MAT' AND ITEM_INFO_URL_NOVO LIKE '%mat_configuracao.asp%';

SELECT 'Informativo (413)' AS item, ITEM_CODG, ITEM_DESC, ITEM_STAT, ITEM_SIST_SIGL, ITEM_MENU_MODU_SIGL, ITEM_MENU_CODG, ITEM_INFO_URL, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemInformativo
UNION ALL
SELECT 'Configurações (já existe)', ITEM_CODG, ITEM_DESC, ITEM_STAT, ITEM_SIST_SIGL, ITEM_MENU_MODU_SIGL, ITEM_MENU_CODG, ITEM_INFO_URL, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemNovo;

SELECT P.PITE_PERF_CODG AS perfil, PS.PERF_DESC, P.PITE_INFO_PERMISSAO
FROM SEG_PERFIS_ITENS_SISTEMA P
LEFT JOIN SEG_PERFIS_SISTEMA PS ON PS.PERF_CODG = P.PITE_PERF_CODG
WHERE P.PITE_ITEM_CODG = @ItemInformativo
ORDER BY P.PITE_PERF_CODG;

IF NOT EXISTS (SELECT 1 FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemInformativo AND ITEM_SIST_SIGL = 'MAT')
BEGIN
	PRINT 'ATENÇÃO: item 413 (Informativo - Matrícula) não encontrado no módulo MAT. Nada foi gravado.';
	RETURN;
END

IF @UrlModelo IS NULL
BEGIN
	PRINT 'ATENÇÃO: não achei nenhum item de menu abrindo uma tela app/mat_*.asp para copiar o formato. Nada foi gravado.';
	RETURN;
END

IF @Gravar = 0
BEGIN
	PRINT 'Somente conferência. Para gravar, execute novamente com @Gravar = 1.';
	RETURN;
END

BEGIN TRANSACTION;

/* Informativo: tela nova */
UPDATE SEG_ITENS_SISTEMA
SET ITEM_INFO_URL_NOVO = @Prefixo + 'mat_informativo.asp'
WHERE ITEM_CODG = @ItemInformativo;
PRINT 'Informativo (413) apontado para app/mat_informativo.asp';

/* Configurações: item novo copiando o 413 */
IF @ItemNovo IS NULL
BEGIN
	SELECT @ItemNovo = ISNULL(MAX(ITEM_CODG), 0) + 1 FROM SEG_ITENS_SISTEMA WITH (UPDLOCK, HOLDLOCK);

	INSERT INTO SEG_ITENS_SISTEMA
		(ITEM_CODG, ITEM_SIST_SIGL, ITEM_NOME, ITEM_DESC, ITEM_STAT, ITEM_NUMR_POSICAO,
		 ITEM_INFO_PERMISSAO, ITEM_INFO_URL, ITEM_INFO_PARAMETRO, ITEM_MENU_MODU_SIGL,
		 ITEM_MENU_CODG, ITEM_INFO_URL_NOVO, ITEM_INFO_URL_TESTE, ORDEM, ICONE)
	SELECT
		@ItemNovo, ITEM_SIST_SIGL, 'Configurações', 'Configurações', 'A', ITEM_NUMR_POSICAO,
		ITEM_INFO_PERMISSAO, @Prefixo + 'mat_configuracao.asp', NULL, ITEM_MENU_MODU_SIGL,
		ITEM_MENU_CODG, @Prefixo + 'mat_configuracao.asp', NULL, ORDEM, ICONE
	FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemInformativo;
	PRINT 'Item Configurações criado: ' + CAST(@ItemNovo AS VARCHAR(10));
END

INSERT INTO SEG_PERFIS_ITENS_SISTEMA (PITE_PERF_CODG, PITE_ITEM_CODG, PITE_INFO_PERMISSAO)
SELECT P.PITE_PERF_CODG, @ItemNovo, P.PITE_INFO_PERMISSAO
FROM SEG_PERFIS_ITENS_SISTEMA P
WHERE P.PITE_ITEM_CODG = @ItemInformativo
AND NOT EXISTS (SELECT 1 FROM SEG_PERFIS_ITENS_SISTEMA X WHERE X.PITE_PERF_CODG = P.PITE_PERF_CODG AND X.PITE_ITEM_CODG = @ItemNovo);
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' perfil(is) liberado(s) em Configurações.';

COMMIT TRANSACTION;

SELECT ITEM_CODG, ITEM_DESC, ITEM_STAT, ITEM_MENU_CODG, ITEM_INFO_URL, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG IN (@ItemInformativo, @ItemNovo);
GO

SET NOEXEC OFF;
GO
