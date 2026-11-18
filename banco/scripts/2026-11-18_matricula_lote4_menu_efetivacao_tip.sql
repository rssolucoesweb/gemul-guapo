/* =====================================================================
   GUAPÓ - Matrícula (migração para o layout novo) - Lote 4: menu
   Efetivação (410) -> app/mat_efetivacao.asp  (regra de Guapó no layout novo + efetivação de TIP)
   TIP (901)        -> app/mat_tip.asp         (igual Anápolis, telas do lote 3)
   Relatório de TIP -> item novo no menu Relatórios (mesmo menu e perfis do item 403)
   Data: 18/11/2026

   Rodar no banco de GUAPÓ, DEPOIS do lote 3 (estrutura) e de subir as telas dos lotes 3 e 4.
   Como usar: rode com @Gravar = 0 e confira; depois rode com @Gravar = 1. Pode rodar mais de uma vez.
   Para voltar para as telas antigas:
     UPDATE SEG_ITENS_SISTEMA SET ITEM_INFO_URL_NOVO = NULL WHERE ITEM_CODG IN (410, 901)
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

DECLARE @Gravar BIT = 0;   -- 0 = só mostra | 1 = grava

DECLARE @UrlModelo VARCHAR(500);
DECLARE @Prefixo   VARCHAR(500);

SELECT TOP 1 @UrlModelo = ITEM_INFO_URL_NOVO FROM SEG_ITENS_SISTEMA
WHERE ITEM_INFO_URL_NOVO LIKE '%mat[_]%.asp%' AND ITEM_STAT = 'A'
ORDER BY CASE WHEN ITEM_SIST_SIGL = 'MAT' THEN 0 ELSE 1 END, ITEM_CODG;
SET @Prefixo = LEFT(@UrlModelo, CHARINDEX('mat_', @UrlModelo) - 1);
SELECT @UrlModelo AS url_modelo, @Prefixo AS prefixo_usado;

DECLARE @Itens TABLE (ITEM_CODG DECIMAL(6,0) PRIMARY KEY, TELA VARCHAR(100));
INSERT INTO @Itens VALUES (410, 'mat_efetivacao.asp'), (901, 'mat_tip.asp');

SELECT I.ITEM_CODG, S.ITEM_DESC, S.ITEM_STAT, S.ITEM_SIST_SIGL, S.ITEM_INFO_URL, S.ITEM_INFO_URL_NOVO AS url_novo_atual,
       @Prefixo + I.TELA AS url_novo_que_sera_gravado
FROM @Itens I LEFT JOIN SEG_ITENS_SISTEMA S ON S.ITEM_CODG = I.ITEM_CODG;

SELECT 'perfis do item 403 (vão para o Relatório de TIP)' AS info, P.PITE_PERF_CODG AS perfil, PS.PERF_DESC
FROM SEG_PERFIS_ITENS_SISTEMA P LEFT JOIN SEG_PERFIS_SISTEMA PS ON PS.PERF_CODG = P.PITE_PERF_CODG
WHERE P.PITE_ITEM_CODG = 403 ORDER BY P.PITE_PERF_CODG;

IF @UrlModelo IS NULL
BEGIN
	PRINT 'ATENÇÃO: não achei nenhum item de menu abrindo uma tela app/mat_*.asp para copiar o formato. Nada foi gravado.';
	RETURN;
END

IF (SELECT COUNT(*) FROM SEG_ITENS_SISTEMA S INNER JOIN @Itens I ON I.ITEM_CODG = S.ITEM_CODG WHERE S.ITEM_SIST_SIGL = 'MAT') <> 2
BEGIN
	PRINT 'ATENÇÃO: os itens 410 e 901 não foram encontrados no módulo MAT. Nada foi gravado.';
	RETURN;
END

IF @Gravar = 0
BEGIN
	PRINT 'Somente conferência. Para gravar, execute novamente com @Gravar = 1.';
	RETURN;
END

BEGIN TRANSACTION;

UPDATE S SET S.ITEM_INFO_URL_NOVO = @Prefixo + I.TELA
FROM SEG_ITENS_SISTEMA S INNER JOIN @Itens I ON I.ITEM_CODG = S.ITEM_CODG;
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' item(ns) apontado(s) para a tela nova.';

/* Relatório de TIP: item novo no mesmo menu (Relatórios) do item 403, com os mesmos perfis */
DECLARE @ItemRel DECIMAL(6,0) = 403;
DECLARE @ItemNovo DECIMAL(6,0);
SELECT @ItemNovo = ITEM_CODG FROM SEG_ITENS_SISTEMA
WHERE ITEM_SIST_SIGL = 'MAT' AND ITEM_INFO_URL_NOVO LIKE '%mat_rel_tip.asp%';
IF @ItemNovo IS NULL AND EXISTS (SELECT 1 FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemRel AND ITEM_SIST_SIGL = 'MAT')
BEGIN
	SELECT @ItemNovo = ISNULL(MAX(ITEM_CODG), 0) + 1 FROM SEG_ITENS_SISTEMA WITH (UPDLOCK, HOLDLOCK);
	INSERT INTO SEG_ITENS_SISTEMA
		(ITEM_CODG, ITEM_SIST_SIGL, ITEM_NOME, ITEM_DESC, ITEM_STAT, ITEM_NUMR_POSICAO,
		 ITEM_INFO_PERMISSAO, ITEM_INFO_URL, ITEM_INFO_PARAMETRO, ITEM_MENU_MODU_SIGL,
		 ITEM_MENU_CODG, ITEM_INFO_URL_NOVO, ITEM_INFO_URL_TESTE, ORDEM, ICONE)
	SELECT
		@ItemNovo, ITEM_SIST_SIGL, 'Relatório de TIP', 'Relatório de TIP', 'A', ITEM_NUMR_POSICAO,
		ITEM_INFO_PERMISSAO, @Prefixo + 'mat_rel_tip.asp', NULL, ITEM_MENU_MODU_SIGL,
		ITEM_MENU_CODG, @Prefixo + 'mat_rel_tip.asp', NULL, ORDEM, ICONE
	FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = @ItemRel;
	PRINT 'Item Relatório de TIP criado: ' + CAST(@ItemNovo AS VARCHAR(10));
END
IF @ItemNovo IS NOT NULL
BEGIN
	INSERT INTO SEG_PERFIS_ITENS_SISTEMA (PITE_PERF_CODG, PITE_ITEM_CODG, PITE_INFO_PERMISSAO)
	SELECT P.PITE_PERF_CODG, @ItemNovo, P.PITE_INFO_PERMISSAO
	FROM SEG_PERFIS_ITENS_SISTEMA P
	WHERE P.PITE_ITEM_CODG = @ItemRel
	AND NOT EXISTS (SELECT 1 FROM SEG_PERFIS_ITENS_SISTEMA X WHERE X.PITE_PERF_CODG = P.PITE_PERF_CODG AND X.PITE_ITEM_CODG = @ItemNovo);
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' perfil(is) liberado(s) no Relatório de TIP.';
END

COMMIT TRANSACTION;

SELECT ITEM_CODG, ITEM_DESC, ITEM_INFO_URL, ITEM_INFO_URL_NOVO FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG IN (410, 901) OR (ITEM_SIST_SIGL = 'MAT' AND ITEM_INFO_URL_NOVO LIKE '%mat_rel_tip.asp%');
GO

SET NOEXEC OFF;
GO
