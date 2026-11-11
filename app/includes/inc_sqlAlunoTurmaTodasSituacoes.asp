<%
function sqlAlunoTurma(turma, alunos)		
	'**** SELECIONA OS ALUNOS DE UMA DETERMINADA TURMA INCLUINDO TODAS AS SITUAÇÕES CADASTRAIS
	if intCodSituacaoAluno = "" then intCodSituacaoAluno = 0
	
	if TRIM(strAnoLetivo) <> TRIM(session("strAnoLetivo")) and Session("strBloqueiaFechamento") = "S" then 
		'--ano anterior
		sql = "SELECT f.CODIGO AS CODALUNOTURMA, "
		sql = sql & " SCA_ALUNO.CODIGO, "
		sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, "
		sql = sql & " SCA_ALUNO.NOMEALUNO, "
		sql = sql & " 0 as SEQUENCIA, "
		sql = sql & " f.COD_TURMA, "
		sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, "
		sql = sql & " SCA_TURMA.NomeTurma,"
		sql = sql & " SCA_TURMA.TURMAALUNO, "
		sql = sql & " SCA_SITUACAOALUNO.Desc_SituacaoAluno as Desc_SituacaoAluno,"
		sql = sql & " SCA_SITUACAOALUNO.Cod_SituacaoAluno AS COD_SITUACAOALUNOATUAL,"
		sql = sql & " SCA_TURMA.Cod_FichaDescritiva, "
		sql = sql & "("	
		sql = sql & "		SELECT codigo"
		sql = sql & "		FROM SCA_ALUNO"
		sql = sql & "		WHERE CODIGO = f.COD_ALUNO"
		sql = sql & "		AND ("
		sql = sql & "			   NOMEALUNO IS NULL"
		sql = sql & "			OR DATANASCIMENTO IS NULL"
		sql = sql & "			OR DATAMATRICULA IS NULL"
		sql = sql & "			OR SEXOALUNO IS NULL"
		sql = sql & "			OR NACIONALIDADE IS NULL"
		sql = sql & "			OR COD_TIPONACIONALIDADE IS NULL"
		sql = sql & "			OR COD_PROFISSAO IS NULL"
		sql = sql & "			OR COD_ETNIA IS NULL"
		sql = sql & "			OR MAE IS NULL"
		' -- REGRA CONDICIONAL estrangeiro
		sql = sql & "			OR ("
		sql = sql & "				COD_TIPONACIONALIDADE <> 3"
		sql = sql & "				AND ("
		sql = sql & "					CIDADENASCIMENTO IS NULL"
		sql = sql & "					OR UFNASCIMENTO IS NULL"
		sql = sql & "					)"
		sql = sql & "				)"
		sql = sql & "		)"
		sql = sql & ") as pendencias,"
		
		'sql = sql & " 	(	select codigo from SCA_ALUNO where CODIGO=f.COD_ALUNO "
		'sql = sql & " 		and ( NOMEALUNO is null or DATANASCIMENTO is null or DATAMATRICULA is null or SEXOALUNO is null or CIDADENASCIMENTO is null or UFNASCIMENTO is null or NACIONALIDADE is null "
		'sql = sql & " 		or COD_TIPONACIONALIDADE is null or COD_PROFISSAO is null or COD_ETNIA is null or MAE is null ) "
		'sql = sql & " 	) as pendencias
		
		sql = sql & " TC.DESCRICAO AS TIPO_CRITERIO, C.DESCRICAO AS CURSO, P.Cod_Curso, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.DesvincularCriterioAvaliacao "
		sql = sql & " FROM SCA_ALUNO "
		sql = sql & " INNER JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO F on f.COD_ALUNO = SCA_ALUNO.CODIGO"
		sql = sql & " LEFT JOIN SCA_TURMA ON f.COD_TURMA = SCA_TURMA.Cod_Turma AND f.ANO_LETIVO = SCA_TURMA.AnoLetivo AND f.SEMESTRE = SCA_TURMA.Cod_Semestre AND f.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = f.COD_SITUACAOALUNO_ATUAL"
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON SCA_TURMA.Cod_GradeCurricular = G.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
		sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
		sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = F.COD_ALUNO AND TAI.ANO_LETIVO = SCA_TURMA.ANOLETIVO"
		sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_CALCULO"
		sql = sql & " where f.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " and f.COD_TURMA = " & turma  
		sql = sql & " and f.ANO_LETIVO = " & strAnoLetivo
		if alunos <> "" then
			sql = sql & " AND   SCA_ALUNO.CODIGO in (" & alunos & ")"
		end if
		if intCodSituacaoAluno <> "0" then
			sql = sql & " And   f.COD_SITUACAOALUNO_ATUAL = " & intCodSituacaoAluno
		end if
		
		sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	
	else
		'--ano atual
		sql = " SELECT distinct "
		sql = sql & " SCA_ALUNO.CODIGO, "
		sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, "
		sql = sql & " SCA_ALUNO.NOMEALUNO, "
		sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, "
		sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, "
		sql = sql & " SCA_TURMA.NomeTurma,"
		sql = sql & " SCA_TURMA.TURMAALUNO, "
		sql = sql & " isnull(("
		sql = sql & " select top 1 ss.Desc_SituacaoAluno"
		sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
		sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
		sql = sql & " where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA "
		sql = sql & " and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO"
		sql = sql & " and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO"
		sql = sql & " order by cs.codigo desc"
		sql = sql & " ),'ATIVO') as Desc_SituacaoAluno,"
		sql = sql & " isnull(("
		sql = sql & " select top 1 ss.COD_SituacaoAluno"
		sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
		sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
		sql = sql & " where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA "
		sql = sql & " and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO "
		sql = sql & " and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO"
		sql = sql & " order by cs.codigo desc"
		sql = sql & " ),'1') as COD_SITUACAOALUNOATUAL,"
		sql = sql & " SCA_TURMA.Cod_FichaDescritiva, "
		sql = sql & "("	
		sql = sql & "		SELECT codigo"
		sql = sql & "		FROM SCA_ALUNO"
		sql = sql & "		WHERE CODIGO = SCA_ALUNO_TURMA.COD_ALUNO"
		sql = sql & "		AND ("
		sql = sql & "			   NOMEALUNO IS NULL"
		sql = sql & "			OR DATANASCIMENTO IS NULL"
		sql = sql & "			OR DATAMATRICULA IS NULL"
		sql = sql & "			OR SEXOALUNO IS NULL"
		sql = sql & "			OR NACIONALIDADE IS NULL"
		sql = sql & "			OR COD_TIPONACIONALIDADE IS NULL"
		sql = sql & "			OR COD_PROFISSAO IS NULL"
		sql = sql & "			OR COD_ETNIA IS NULL"
		sql = sql & "			OR MAE IS NULL"
		' -- REGRA CONDICIONAL estrangeiro
		sql = sql & "			OR ("
		sql = sql & "				COD_TIPONACIONALIDADE <> 3"
		sql = sql & "				AND ("
		sql = sql & "					CIDADENASCIMENTO IS NULL"
		sql = sql & "					OR UFNASCIMENTO IS NULL"
		sql = sql & "				)"
		sql = sql & "				)"
		sql = sql & "		)"
		sql = sql & ") as pendencias,"		
		'sql = sql & " 	(	select codigo from SCA_ALUNO where CODIGO=SCA_ALUNO_TURMA.COD_ALUNO "
		'sql = sql & " 		and ( NOMEALUNO is null or DATANASCIMENTO is null or DATAMATRICULA is null or SEXOALUNO is null or CIDADENASCIMENTO is null or UFNASCIMENTO is null or NACIONALIDADE is null "
		'sql = sql & " 		or COD_TIPONACIONALIDADE is null or COD_PROFISSAO is null or COD_ETNIA is null or MAE is null )"
		'sql = sql & " 	) as pendencias,TC.DESCRICAO AS TIPO_CRITERIO, C.DESCRICAO AS CURSO, P.Cod_Curso, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.DesvincularCriterioAvaliacao "
		sql = sql & " TC.DESCRICAO AS TIPO_CRITERIO, C.DESCRICAO AS CURSO, P.Cod_Curso, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.DesvincularCriterioAvaliacao "
		sql = sql & " FROM SCA_ALUNO "
		sql = sql & " INNER JOIN SCA_ALUNO_TURMA ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
		sql = sql & " LEFT JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON SCA_TURMA.Cod_GradeCurricular = G.Cod_GradeCurricular "
		sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
		sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
		sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO AND TAI.ANO_LETIVO = SCA_TURMA.ANOLETIVO"
		sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_CALCULO"
		sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & turma  
		sql = sql & " and SCA_ALUNO_TURMA.ANO_LETIVO = " & strAnoLetivo
		sql = sql & " and SCA_ALUNO_TURMA.SITUACAO in ('A','T','D','C')"
		sql = sql & " and SCA_TURMA.situacao = 'A' "

		if alunos <> "" then
			sql = sql & " AND   SCA_ALUNO.CODIGO in (" & alunos & ")"
		end if
		if intCodSituacaoAluno <> "0" then

			sql = sql & " AND ("
			sql = sql & " select top 1 ss.Cod_SituacaoAluno"
			sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
			sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
			sql = sql & " where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA "
			sql = sql & " and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO "
			sql = sql & " and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO"
			sql = sql & " order by cs.codigo desc"
			sql = sql & " ) = " & intCodSituacaoAluno
			
		end if

		sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	'response.write sql
	end if
	
	'sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, "
	'sql = sql & " SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, "
	'sql = sql & " SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno,  SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, "
	'sql = sql & " SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva,"
	'sql = sql & " ("
	'sql = sql & " select "
	'sql = sql & " 	codigo"
	'sql = sql & " from SCA_ALUNO"
	'sql = sql & " where CODIGO=SCA_ALUNO_TURMA.COD_ALUNO"
	'sql = sql & " and ( NOMEALUNO is null or DATANASCIMENTO is null"
	'sql = sql & " or DATAMATRICULA is null"
	'sql = sql & " or SEXOALUNO is null"
	'sql = sql & " or CIDADENASCIMENTO is null"
	'sql = sql & " or UFNASCIMENTO is null"
	'sql = sql & " or NACIONALIDADE is null"
	'sql = sql & " or COD_TIPONACIONALIDADE is null"
	'sql = sql & " or COD_PROFISSAO is null"
	'sql = sql & " or COD_ETNIA is null"
	'sql = sql & " or MAE is null )) as pendencias, SCA_ALUNO.COD_SITUACAOALUNO AS COD_SITUACAOALUNOATUAL "
    'sql = sql & " FROM SCA_ALUNO "
    'sql = sql & " INNER JOIN SCA_ALUNO_TURMA ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
    'sql = sql & " INNER JOIN sca_situacaoaluno ATC ON ATC.COD_ALUNO_TURMA = SCA_ALUNO_TURMA.CODIGO "
    'sql = sql & " LEFT JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	'sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	'sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = ATC.COD_SITUACAOALUNO"
    'sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON SCA_TURMA.Cod_GradeCurricular = G.Cod_GradeCurricular"
    'sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
    'sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
    'sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SITUACAOALUNO = ATC.COD_SITUACAOALUNO"
    'sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.Cod_NecEspecial = SCA_ALUNO.COD_NECESPECIAL"
    'sql = sql & " LEFT JOIN SEG_EMPRESA EM ON EM.CODIGO = SCA_ALUNO_TURMA.COD_EMPRESA"
 	'sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")			
	'sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & turma & ""	
	'sql = sql & " and SCA_TURMA.situacao = 'A'"
	'if alunos <> "" then
	'	sql = sql & " AND   SCA_ALUNO.CODIGO in (" & alunos & ")"
	'end if
	'if intCodSituacaoAluno <> "0" then
	'	sql = sql & " And   ATC.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	'end if
	'sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	sqlAlunoTurma = sql
	
	if ucase(session("usuarioWeb")) = "SERGIO" then
		'response.write sql
	end if
	
end function
%>
