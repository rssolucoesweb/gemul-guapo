<%
function sqlAlunoTurma(turma, alunos)		
	'**** SELECIONA OS ALUNOS REGULARES
	if intCodSituacaoAluno = "" then intCodSituacaoAluno = 0
	if buscaHistorico = "" then buscaHistorico = "N"

	sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, "
	sql = sql & " SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, "
	sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_TURMA.Cod_FichaDescritiva "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO"
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & turma & ""	
	if buscaHistorico = "N" then
		sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
	end if	
	if alunos <> "" then
		sql = sql & " AND   SCA_ALUNO.CODIGO in (" & alunos & ")"
	end if
	if intCodSituacaoAluno <> "0" then
		sql = sql & " And   SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	end if
	sql = sql & " order by SCA_ALUNO.NOMEALUNO"

	sqlAlunoTurma = sql

end function
%>
