/* =====================================================================
   GUAPÓ - Menu: tela nova de Lançamento de Faltas (app/sca_faltaCon.asp)
   Data: 17/11/2026

   Rodar no banco de GUAPÓ (não no de Anápolis).

   - Cria o item "Lançamento de Faltas" em SEG_ITENS_SISTEMA copiando sistema,
     módulo, menu, posição e o formato do endereço da tela de faltas disciplinar
     (sca_falta_disciplinarCon.asp), que já existe no menu de Guapó.
   - Libera para os mesmos perfis que já acessam a tela de faltas disciplinar.
   - As telas antigas (disciplinar e interdisciplinar) continuam no menu.
     @DesativarAntigas = 1 desativa as duas (ITEM_STAT = 'I'), sem apagar permissões.

   Como usar:
   1) Rode com @Gravar = 0 e confira o modelo e os perfis.
   2) Rode com @Gravar = 1.
   Pode rodar mais de uma vez: não duplica o item nem as permissões.
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

DECLARE @Gravar           BIT = 0;   -- 0 = só mostra | 1 = grava
DECLARE @DesativarAntigas BIT = 0;   -- 1 = desativa faltas disciplinar e interdisciplinar

DECLARE @ItemModelo DECIMAL(6,0);   -- sca_falta_disciplinarCon.asp (formato, menu e perfis)
DECLARE @ItemInter  DECIMAL(6,0);   -- sca_falta_interdisciplinarCon.asp
DECLARE @ItemNovo   DECIMAL(6,0);

SELECT TOP 1 @ItemModelo = ITEM_CODG
FROM SEG_ITENS_SISTEMA
WHERE ITEM_INFO_URL_NOVO LIKE '%sca_falta_disciplinarCon.asp%'
   OR ITEM_INFO_URL LIKE '%sca_falta_disciplinarCon.asp%'
ORDER BY CASE WHEN ITEM_STAT = 'A' THEN 0 ELSE 1 END, ITEM_CODG;

SELECT TOP 1 @ItemInter = ITEM_CODG
FROM SEG_ITENS_SISTEMA
WHERE ITEM_INFO_URL_NOVO LIKE '%sca_falta_interdisciplinarCon.asp%'
   OR ITEM_INFO_URL LIKE '%sca_falta_interdisciplinarCon.asp%'
ORDER BY CASE WHEN ITEM_STAT = 'A' THEN 0 ELSE 1 END, ITEM_CODG;

SELECT @ItemNovo = ITEM_CODG
FROM SEG_ITENS_SISTEMA
WHERE ITEM_INFO_URL_NOVO LIKE '%sca_faltaCon.asp%'
   OR ITEM_INFO_URL LIKE '%sca_faltaCon.asp%';

/* ---------- Conferência ---------- */
SELECT 'MODELO (faltas disciplinar)' AS item, ITEM_CODG, ITEM_DESC, ITEM_SIST_SIGL, ITEM_MENU_MODU_SIGL, ITEM_MENU_CODG, ITEM_STAT, ITEM_INFO_URL, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemModelo
UNION ALL
SELECT 'faltas interdisciplinar', ITEM_CODG, ITEM_DESC, ITEM_SIST_SIGL, ITEM_MENU_MODU_SIGL, ITEM_MENU_CODG, ITEM_STAT, ITEM_INFO_URL, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemInter
UNION ALL
SELECT 'NOVO (já existe)', ITEM_CODG, ITEM_DESC, ITEM_SIST_SIGL, ITEM_MENU_MODU_SIGL, ITEM_MENU_CODG, ITEM_STAT, ITEM_INFO_URL, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemNovo;

SELECT P.PITE_PERF_CODG AS perfil, P.PITE_INFO_PERMISSAO AS permissao
FROM SEG_PERFIS_ITENS_SISTEMA P
WHERE P.PITE_ITEM_CODG = @ItemModelo
ORDER BY P.PITE_PERF_CODG;

IF @ItemModelo IS NULL
BEGIN
	PRINT 'ATENÇÃO: não encontrei a tela de faltas disciplinar (sca_falta_disciplinarCon.asp) no menu. Nada foi gravado.';
	RETURN;
END

IF @Gravar = 0
BEGIN
	PRINT 'Somente conferência. Para gravar, execute novamente com @Gravar = 1.';
	RETURN;
END

/* ---------- Gravação ---------- */
BEGIN TRANSACTION;

IF @ItemNovo IS NULL
BEGIN
	/* ITEM_CODG não é automático: usa o próximo número livre */
	SELECT @ItemNovo = ISNULL(MAX(ITEM_CODG), 0) + 1 FROM SEG_ITENS_SISTEMA WITH (UPDLOCK, HOLDLOCK);

	INSERT INTO SEG_ITENS_SISTEMA
		(ITEM_CODG, ITEM_SIST_SIGL, ITEM_NOME, ITEM_DESC, ITEM_STAT, ITEM_NUMR_POSICAO,
		 ITEM_INFO_PERMISSAO, ITEM_INFO_URL, ITEM_INFO_PARAMETRO, ITEM_MENU_MODU_SIGL,
		 ITEM_MENU_CODG, ITEM_INFO_URL_NOVO, ITEM_INFO_URL_TESTE, ORDEM, ICONE)
	SELECT
		@ItemNovo, ITEM_SIST_SIGL, 'Lançamento de Faltas', 'Lançamento de Faltas', 'A', ITEM_NUMR_POSICAO,
		ITEM_INFO_PERMISSAO,
		REPLACE(ISNULL(ITEM_INFO_URL_NOVO, ITEM_INFO_URL), 'sca_falta_disciplinarCon.asp', 'sca_faltaCon.asp'),
		NULL, ITEM_MENU_MODU_SIGL,
		ITEM_MENU_CODG,
		REPLACE(ISNULL(ITEM_INFO_URL_NOVO, ITEM_INFO_URL), 'sca_falta_disciplinarCon.asp', 'sca_faltaCon.asp'),
		NULL, ORDEM, ICONE
	FROM SEG_ITENS_SISTEMA
	WHERE ITEM_CODG = @ItemModelo;

	PRINT 'Item de menu criado: ' + CAST(@ItemNovo AS VARCHAR(10));
END
ELSE
	PRINT 'Item de menu já existia: ' + CAST(@ItemNovo AS VARCHAR(10));

INSERT INTO SEG_PERFIS_ITENS_SISTEMA (PITE_PERF_CODG, PITE_ITEM_CODG, PITE_INFO_PERMISSAO)
SELECT P.PITE_PERF_CODG, @ItemNovo, P.PITE_INFO_PERMISSAO
FROM SEG_PERFIS_ITENS_SISTEMA P
WHERE P.PITE_ITEM_CODG = @ItemModelo
AND NOT EXISTS (
	SELECT 1 FROM SEG_PERFIS_ITENS_SISTEMA X
	WHERE X.PITE_PERF_CODG = P.PITE_PERF_CODG AND X.PITE_ITEM_CODG = @ItemNovo
);
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' perfil(is) liberado(s).';

IF @DesativarAntigas = 1
BEGIN
	UPDATE SEG_ITENS_SISTEMA SET ITEM_STAT = 'I' WHERE ITEM_CODG IN (@ItemModelo, @ItemInter);
	PRINT 'Telas antigas de faltas desativadas no menu.';
END

COMMIT TRANSACTION;

SELECT ITEM_CODG, ITEM_DESC, ITEM_STAT, ITEM_SIST_SIGL, ITEM_MENU_MODU_SIGL, ITEM_MENU_CODG, ITEM_INFO_URL_NOVO
FROM SEG_ITENS_SISTEMA
WHERE ITEM_CODG IN (@ItemNovo, @ItemModelo, @ItemInter);
GO

SET NOEXEC OFF;
GO
