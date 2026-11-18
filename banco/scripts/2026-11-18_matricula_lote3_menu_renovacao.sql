/* =====================================================================
   GUAPÓ - Matrícula (migração para o layout novo) - Lote 3: menu
   Renovação de Matrícula (798) passa a abrir app/mat_renovacao.asp (igual Anápolis).
   Data: 18/11/2026

   Rodar no banco de GUAPÓ, DEPOIS de 2026-11-18_matricula_lote3_estrutura.sql e de subir as telas.
   A TIP (901) e o Relatório de TIP entram no menu no lote 4, junto com a Efetivação
   (a TIP nova fica pendente até a escola de destino efetivar).

   Como usar: rode com @Gravar = 0 e confira; depois rode com @Gravar = 1.
   Para voltar para a tela antiga:
     UPDATE SEG_ITENS_SISTEMA SET ITEM_INFO_URL_NOVO = NULL WHERE ITEM_CODG = 798
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

/* ===================== Menu ===================== */
DECLARE @Gravar BIT = 0;   -- 0 = só mostra | 1 = grava

DECLARE @UrlModelo VARCHAR(500);
DECLARE @Prefixo   VARCHAR(500);

SELECT TOP 1 @UrlModelo = ITEM_INFO_URL_NOVO FROM SEG_ITENS_SISTEMA
WHERE ITEM_INFO_URL_NOVO LIKE '%mat[_]%.asp%' AND ITEM_STAT = 'A'
ORDER BY CASE WHEN ITEM_SIST_SIGL = 'MAT' THEN 0 ELSE 1 END, ITEM_CODG;
SET @Prefixo = LEFT(@UrlModelo, CHARINDEX('mat_', @UrlModelo) - 1);
SELECT @UrlModelo AS url_modelo, @Prefixo AS prefixo_usado;

DECLARE @Itens TABLE (ITEM_CODG DECIMAL(6,0) PRIMARY KEY, TELA VARCHAR(100));
INSERT INTO @Itens VALUES (798, 'mat_renovacao.asp');

SELECT I.ITEM_CODG, S.ITEM_DESC, S.ITEM_STAT, S.ITEM_SIST_SIGL, S.ITEM_INFO_URL, S.ITEM_INFO_URL_NOVO AS url_novo_atual,
       @Prefixo + I.TELA AS url_novo_que_sera_gravado
FROM @Itens I LEFT JOIN SEG_ITENS_SISTEMA S ON S.ITEM_CODG = I.ITEM_CODG;

IF @UrlModelo IS NULL
BEGIN
	PRINT 'ATENÇÃO: não achei nenhum item de menu abrindo uma tela app/mat_*.asp para copiar o formato. Nada foi gravado.';
	RETURN;
END

IF (SELECT COUNT(*) FROM SEG_ITENS_SISTEMA S INNER JOIN @Itens I ON I.ITEM_CODG = S.ITEM_CODG WHERE S.ITEM_SIST_SIGL = 'MAT') <> 1
BEGIN
	PRINT 'ATENÇÃO: o item 798 não foi encontrado no módulo MAT. Nada foi gravado.';
	RETURN;
END

IF @Gravar = 0
BEGIN
	PRINT 'Somente conferência. Para gravar, execute novamente com @Gravar = 1.';
	RETURN;
END

UPDATE S SET S.ITEM_INFO_URL_NOVO = @Prefixo + I.TELA
FROM SEG_ITENS_SISTEMA S INNER JOIN @Itens I ON I.ITEM_CODG = S.ITEM_CODG;
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' item(ns) apontado(s) para a tela nova.';

SELECT ITEM_CODG, ITEM_DESC, ITEM_INFO_URL, ITEM_INFO_URL_NOVO FROM SEG_ITENS_SISTEMA WHERE ITEM_CODG = 798;
GO

SET NOEXEC OFF;
GO
