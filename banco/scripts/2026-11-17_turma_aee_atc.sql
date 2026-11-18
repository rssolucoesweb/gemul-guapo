/* =====================================================================
   GUAPÓ - Turmas de AEE e ATC (igual a Anápolis)
   Data: 17/11/2026

   Rodar no banco de GUAPÓ (não no de Anápolis).

   Em Anápolis: curso 4 = AEE (período 15) e curso 5 = ATC (período 16).
   Em Guapó o curso 4 e os períodos 15 a 19 já são da EJA, então aqui os
   códigos são novos. As telas de Guapó acham AEE/ATC pela SIGLA do curso
   ('AE' e 'AT'), nunca pelo número.

   Cria (só se ainda não existir):
   1) SCA_CURSO   : ATENDIMENTO EDUCACIONAL ESPECIALIZADO (sigla AE)
                    ATIVIDADE COMPLEMENTAR (sigla AT)
   2) SCA_PERIODO : ATENDIMENTO ESPECIALIZADO / ATIVIDADE COMPLEMENTAR
                    (próximos códigos livres; tipo I, sem matrícula, idade limite 5)
   3) SCA_DISCIPLINA: ATENDIMENTO ESPECIALIZADO / ATIVIDADE COMPLEMENTAR
                    (usa a que já existir com esse nome ou com COD_DISCIPLINA_ANAPOLIS 50/717)
   4) SCA_GRADECURRICULAR (anual) para 2026 e 2027 de cada período, com a disciplina:
                    AEE CH 200 | ATC CH 1 (igual Anápolis)

   Como usar:
   1) Rode com @Gravar = 0: mostra o que já existe e o que seria criado.
   2) Rode com @Gravar = 1.
   Pode rodar mais de uma vez: não duplica nada.
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

DECLARE @Gravar BIT = 0;   -- 0 = só mostra | 1 = grava

/* ---------- Conferência ---------- */
SELECT 'CURSOS com sigla AE/AT (se aparecer outro curso aqui, pare e me avise)' AS info, Cod_curso, Descricao, Sigla, Situacao
FROM SCA_CURSO WHERE Sigla IN ('AE','AT');

SELECT 'PERÍODOS de AEE/ATC já existentes' AS info, p.Cod_Periodo, p.Cod_Curso, p.Descricao
FROM SCA_PERIODO p INNER JOIN SCA_CURSO c ON c.Cod_curso = p.Cod_Curso
WHERE c.Sigla IN ('AE','AT');

SELECT 'DISCIPLINAS candidatas' AS info, Cod_Disciplina, Desc_Disciplina, COD_DISCIPLINA_ANAPOLIS, situacao
FROM SCA_DISCIPLINA
WHERE Desc_Disciplina IN ('ATENDIMENTO ESPECIALIZADO','ATIVIDADE COMPLEMENTAR')
   OR COD_DISCIPLINA_ANAPOLIS IN (50,717);

SELECT 'PRÓXIMO código de período livre' AS info, ISNULL(MAX(Cod_Periodo),0) + 1 AS proximo FROM SCA_PERIODO;

IF @Gravar = 0
BEGIN
	PRINT 'Somente conferência. Para gravar, execute novamente com @Gravar = 1.';
	RETURN;
END

/* ---------- Gravação ---------- */
SET XACT_ABORT ON;
BEGIN TRANSACTION;

DECLARE @CursoAEE INT, @CursoATC INT, @PerAEE INT, @PerATC INT, @DiscAEE INT, @DiscATC INT;

/* 1) cursos (Cod_curso é IDENTITY em Guapó) */
SELECT @CursoAEE = Cod_curso FROM SCA_CURSO WHERE Sigla = 'AE';
IF @CursoAEE IS NULL
BEGIN
	INSERT INTO SCA_CURSO (Descricao, Desc_Abreviada, Desc_Historico, Sigla, Cod_Grau, Modalidade, Situacao)
	VALUES ('ATENDIMENTO EDUCACIONAL ESPECIALIZADO', 'AEE', 'AEE', 'AE', 261, 'P', 'A');
	SET @CursoAEE = SCOPE_IDENTITY();
	PRINT 'Curso AEE criado: ' + CAST(@CursoAEE AS VARCHAR(10));
END

SELECT @CursoATC = Cod_curso FROM SCA_CURSO WHERE Sigla = 'AT';
IF @CursoATC IS NULL
BEGIN
	INSERT INTO SCA_CURSO (Descricao, Desc_Abreviada, Desc_Historico, Sigla, Cod_Grau, Modalidade, Situacao)
	VALUES ('ATIVIDADE COMPLEMENTAR', 'ATC', 'ATC', 'AT', 261, 'P', 'A');
	SET @CursoATC = SCOPE_IDENTITY();
	PRINT 'Curso ATC criado: ' + CAST(@CursoATC AS VARCHAR(10));
END

/* 2) períodos (Cod_Periodo NÃO é identity: próximo livre; Sequencia = código) */
SELECT TOP 1 @PerAEE = Cod_Periodo FROM SCA_PERIODO WHERE Cod_Curso = @CursoAEE ORDER BY Cod_Periodo;
IF @PerAEE IS NULL
BEGIN
	SELECT @PerAEE = ISNULL(MAX(Cod_Periodo),0) + 1 FROM SCA_PERIODO WITH (UPDLOCK, HOLDLOCK);
	INSERT INTO SCA_PERIODO (Cod_Periodo, Cod_Curso, Descricao, Sequencia, Tipo, Matricula, idade_limite, situacao)
	VALUES (@PerAEE, @CursoAEE, 'ATENDIMENTO ESPECIALIZADO', @PerAEE, 'I', 'N', 5, 'A');
	PRINT 'Período AEE criado: ' + CAST(@PerAEE AS VARCHAR(10));
END

SELECT TOP 1 @PerATC = Cod_Periodo FROM SCA_PERIODO WHERE Cod_Curso = @CursoATC ORDER BY Cod_Periodo;
IF @PerATC IS NULL
BEGIN
	SELECT @PerATC = ISNULL(MAX(Cod_Periodo),0) + 1 FROM SCA_PERIODO WITH (UPDLOCK, HOLDLOCK);
	INSERT INTO SCA_PERIODO (Cod_Periodo, Cod_Curso, Descricao, Sequencia, Tipo, Matricula, idade_limite, situacao)
	VALUES (@PerATC, @CursoATC, 'ATIVIDADE COMPLEMENTAR', @PerATC, 'I', 'N', 5, 'A');
	PRINT 'Período ATC criado: ' + CAST(@PerATC AS VARCHAR(10));
END

/* 3) disciplinas */
SELECT TOP 1 @DiscAEE = Cod_Disciplina FROM SCA_DISCIPLINA
WHERE Desc_Disciplina = 'ATENDIMENTO ESPECIALIZADO' OR COD_DISCIPLINA_ANAPOLIS = 50
ORDER BY CASE WHEN Desc_Disciplina = 'ATENDIMENTO ESPECIALIZADO' THEN 0 ELSE 1 END, Cod_Disciplina;
IF @DiscAEE IS NULL
BEGIN
	INSERT INTO SCA_DISCIPLINA (Desc_Disciplina, Desc_Abreviada, Desc_Historico, situacao, COD_DISCIPLINA_ANAPOLIS, uso_historico)
	VALUES ('ATENDIMENTO ESPECIALIZADO', 'AEE', 'ATENDIMENTO ESPECIALIZADO', 'A', 50, 'N');
	SET @DiscAEE = SCOPE_IDENTITY();
	PRINT 'Disciplina AEE criada: ' + CAST(@DiscAEE AS VARCHAR(10));
END

SELECT TOP 1 @DiscATC = Cod_Disciplina FROM SCA_DISCIPLINA
WHERE Desc_Disciplina = 'ATIVIDADE COMPLEMENTAR' OR COD_DISCIPLINA_ANAPOLIS = 717
ORDER BY CASE WHEN Desc_Disciplina = 'ATIVIDADE COMPLEMENTAR' THEN 0 ELSE 1 END, Cod_Disciplina;
IF @DiscATC IS NULL
BEGIN
	INSERT INTO SCA_DISCIPLINA (Desc_Disciplina, Desc_Abreviada, Desc_Historico, situacao, COD_DISCIPLINA_ANAPOLIS, uso_historico)
	VALUES ('ATIVIDADE COMPLEMENTAR', 'ATC', 'ATIVIDADE COMPLEMENTAR', 'A', 717, 'N');
	SET @DiscATC = SCOPE_IDENTITY();
	PRINT 'Disciplina ATC criada: ' + CAST(@DiscATC AS VARCHAR(10));
END

/* 4) matrizes anuais 2026 e 2027 com a disciplina */
DECLARE @Ano INT, @Grade INT;
DECLARE @Anos TABLE (ano INT);
INSERT INTO @Anos VALUES (2026), (2027);

DECLARE cAnos CURSOR LOCAL FAST_FORWARD FOR SELECT ano FROM @Anos;
OPEN cAnos;
FETCH NEXT FROM cAnos INTO @Ano;
WHILE @@FETCH_STATUS = 0
BEGIN
	/* AEE */
	SET @Grade = NULL;
	SELECT TOP 1 @Grade = Cod_GradeCurricular FROM SCA_GRADECURRICULAR
	WHERE Cod_Periodo = @PerAEE AND AnoReferencia = @Ano AND SemestreReferencia = 3;
	IF @Grade IS NULL
	BEGIN
		INSERT INTO SCA_GRADECURRICULAR (Cod_Periodo, AnoReferencia, SemestreReferencia, Situacao, diferenciada)
		VALUES (@PerAEE, @Ano, 3, 'A', 'N');
		SET @Grade = SCOPE_IDENTITY();
		PRINT 'Matriz AEE ' + CAST(@Ano AS VARCHAR(4)) + ' criada: ' + CAST(@Grade AS VARCHAR(10));
	END
	IF NOT EXISTS (SELECT 1 FROM SCA_GRADECURRICULARDISCIPLINA WHERE Cod_GradeCurricular = @Grade AND Cod_Disciplina = @DiscAEE)
		INSERT INTO SCA_GRADECURRICULARDISCIPLINA (Cod_GradeCurricular, Cod_Disciplina, Ch_Anual, Omitir_Criterio)
		VALUES (@Grade, @DiscAEE, 200, 'N');

	/* ATC */
	SET @Grade = NULL;
	SELECT TOP 1 @Grade = Cod_GradeCurricular FROM SCA_GRADECURRICULAR
	WHERE Cod_Periodo = @PerATC AND AnoReferencia = @Ano AND SemestreReferencia = 3;
	IF @Grade IS NULL
	BEGIN
		INSERT INTO SCA_GRADECURRICULAR (Cod_Periodo, AnoReferencia, SemestreReferencia, Situacao, diferenciada)
		VALUES (@PerATC, @Ano, 3, 'A', 'N');
		SET @Grade = SCOPE_IDENTITY();
		PRINT 'Matriz ATC ' + CAST(@Ano AS VARCHAR(4)) + ' criada: ' + CAST(@Grade AS VARCHAR(10));
	END
	IF NOT EXISTS (SELECT 1 FROM SCA_GRADECURRICULARDISCIPLINA WHERE Cod_GradeCurricular = @Grade AND Cod_Disciplina = @DiscATC)
		INSERT INTO SCA_GRADECURRICULARDISCIPLINA (Cod_GradeCurricular, Cod_Disciplina, Ch_Anual, Omitir_Criterio)
		VALUES (@Grade, @DiscATC, 1, 'N');

	FETCH NEXT FROM cAnos INTO @Ano;
END
CLOSE cAnos; DEALLOCATE cAnos;

COMMIT TRANSACTION;

/* Resultado */
SELECT c.Cod_curso, c.Descricao AS curso, c.Sigla, p.Cod_Periodo, p.Descricao AS periodo,
       g.Cod_GradeCurricular, g.AnoReferencia, d.Desc_Disciplina, gd.Ch_Anual
FROM SCA_CURSO c
INNER JOIN SCA_PERIODO p ON p.Cod_Curso = c.Cod_curso
LEFT JOIN SCA_GRADECURRICULAR g ON g.Cod_Periodo = p.Cod_Periodo
LEFT JOIN SCA_GRADECURRICULARDISCIPLINA gd ON gd.Cod_GradeCurricular = g.Cod_GradeCurricular
LEFT JOIN SCA_DISCIPLINA d ON d.Cod_Disciplina = gd.Cod_Disciplina
WHERE c.Sigla IN ('AE','AT')
ORDER BY c.Cod_curso, g.AnoReferencia;
GO

SET NOEXEC OFF;
GO
