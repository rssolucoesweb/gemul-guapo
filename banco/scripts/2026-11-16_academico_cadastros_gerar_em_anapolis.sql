/* =====================================================================
   GERADOR - rodar no banco de ANÁPOLIS (anapolis). NÃO grava nada.
   Data: 16/11/2026

   Monta o script com o cadastro de Atividade Complementar (área, subárea e atividade - tabela do Censo,
   igual para todas as redes) para carregar no banco de GUAPÓ, mantendo os mesmos IDs.

   Como usar:
   1) No SSMS, banco anapolis, menu Consulta > Resultados em Texto (Ctrl+T)
      e em Ferramentas > Opções > Resultados em Texto, "Número máximo de caracteres" = 8192.
   2) Rode este arquivo.
   3) Copie todo o texto do resultado, cole numa nova consulta no banco de GUAPÓ e rode.
      (o script gerado confere antes: pode rodar mais de uma vez)
   ===================================================================== */
SET NOCOUNT ON;
IF DB_NAME() <> 'anapolis'
BEGIN
	RAISERROR('Este gerador roda no banco de ANÁPOLIS.', 16, 1);
	RETURN;
END

SELECT LINHA FROM (
	SELECT 0 AS ORDEM, 0 AS ID, '/* Cadastro de Atividade Complementar - gerado em ' + CONVERT(VARCHAR(16), GETDATE(), 120) + ' a partir de Anápolis. Rodar no banco de GUAPÓ. */' AS LINHA
	UNION ALL SELECT 1, 0, 'IF DB_NAME() = ''anapolis'' BEGIN RAISERROR(''Rodar no banco de GUAPÓ.'', 16, 1); SET NOEXEC ON; END'
	UNION ALL SELECT 1, 1, 'GO'
	-- áreas
	UNION ALL SELECT 2, 0, 'SET IDENTITY_INSERT dbo.SCA_atividade_complementar_area ON;'
	UNION ALL SELECT 3, id, 'IF NOT EXISTS (SELECT 1 FROM dbo.SCA_atividade_complementar_area WHERE id = ' + CAST(id AS VARCHAR) + ') INSERT INTO dbo.SCA_atividade_complementar_area (id, codigo, descricao, ativo, data_cadastro) VALUES ('
		+ CAST(id AS VARCHAR) + ', ' + CAST(codigo AS VARCHAR) + ', N''' + REPLACE(descricao, '''', '''''') + ''', ' + CAST(CAST(ativo AS INT) AS VARCHAR) + ', GETDATE());'
		FROM dbo.SCA_atividade_complementar_area
	UNION ALL SELECT 4, 0, 'SET IDENTITY_INSERT dbo.SCA_atividade_complementar_area OFF;'
	UNION ALL SELECT 4, 1, 'GO'
	-- subáreas
	UNION ALL SELECT 5, 0, 'SET IDENTITY_INSERT dbo.SCA_atividade_complementar_subarea ON;'
	UNION ALL SELECT 6, id, 'IF NOT EXISTS (SELECT 1 FROM dbo.SCA_atividade_complementar_subarea WHERE id = ' + CAST(id AS VARCHAR) + ') INSERT INTO dbo.SCA_atividade_complementar_subarea (id, area_id, codigo, descricao, ativo, data_cadastro) VALUES ('
		+ CAST(id AS VARCHAR) + ', ' + CAST(area_id AS VARCHAR) + ', ' + CAST(codigo AS VARCHAR) + ', N''' + REPLACE(descricao, '''', '''''') + ''', ' + CAST(CAST(ativo AS INT) AS VARCHAR) + ', GETDATE());'
		FROM dbo.SCA_atividade_complementar_subarea
	UNION ALL SELECT 7, 0, 'SET IDENTITY_INSERT dbo.SCA_atividade_complementar_subarea OFF;'
	UNION ALL SELECT 7, 1, 'GO'
	-- atividades
	UNION ALL SELECT 8, 0, 'SET IDENTITY_INSERT dbo.SCA_atividade_complementar ON;'
	UNION ALL SELECT 9, id, 'IF NOT EXISTS (SELECT 1 FROM dbo.SCA_atividade_complementar WHERE id = ' + CAST(id AS VARCHAR) + ') INSERT INTO dbo.SCA_atividade_complementar (id, subarea_id, codigo, descricao, ativo, data_cadastro) VALUES ('
		+ CAST(id AS VARCHAR) + ', ' + CAST(subarea_id AS VARCHAR) + ', ' + CAST(codigo AS VARCHAR) + ', N''' + REPLACE(descricao, '''', '''''') + ''', ' + CAST(CAST(ativo AS INT) AS VARCHAR) + ', GETDATE());'
		FROM dbo.SCA_atividade_complementar
	UNION ALL SELECT 10, 0, 'SET IDENTITY_INSERT dbo.SCA_atividade_complementar OFF;'
	UNION ALL SELECT 10, 1, 'GO'
	UNION ALL SELECT 11, 0, 'SET NOEXEC OFF;'
	UNION ALL SELECT 11, 1, 'SELECT (SELECT COUNT(*) FROM dbo.SCA_atividade_complementar_area) AS AREAS, (SELECT COUNT(*) FROM dbo.SCA_atividade_complementar_subarea) AS SUBAREAS, (SELECT COUNT(*) FROM dbo.SCA_atividade_complementar) AS ATIVIDADES;'
) X
ORDER BY ORDEM, ID;
