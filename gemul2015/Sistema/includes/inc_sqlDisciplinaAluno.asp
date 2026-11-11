<%
'*****Seleciona todas as disciplinas do quadro curricular menos as disciplinas optativas do aluno
function sqlDisciplinaAluno(intCodSerie,intCodTurno,intCodSemestre,strCodAluno)
		
		sql="SELECT APE_qd_curricular_disciplina.codigo_ape_disciplina"
		sql=sql & " FROM APE_qd_curricular_disciplina"
		sql=sql & " WHERE APE_qd_curricular_disciplina.codigo_sia_unid_ensino=" & session("strCodigoSia")
		sql=sql & " AND APE_qd_curricular_disciplina.codigo_ape_serie=" & intCodSerie 
		sql=sql & " AND APE_qd_curricular_disciplina.codigo_sia_turno=" & intCodTurno
		sql=sql & " AND APE_qd_curricular_disciplina.semestre=" & intCodSemestre
		sql=sql & " AND APE_qd_curricular_disciplina.ano_letivo=" & session("strAnoLetivo") 
		sql=sql & " AND APE_qd_curricular_disciplina.codigo_ape_disciplina"
		sql=sql & " Not In ("
		
		sql=sql & " 	SELECT APE_disciplina_optativa.codigo_ape_disciplinas"
		sql=sql & " 	FROM APE_disciplina_optativa"
		sql=sql & " 	WHERE APE_disciplina_optativa.codigo_sia_unid_ensino=" & session("strCodigoSia")
		sql=sql & " 	AND APE_disciplina_optativa.ano_letivo=" & session("strAnoLetivo")
		sql=sql & " 	AND APE_disciplina_optativa.codigo_ape_serie=" & intCodSerie 
		sql=sql & " 	AND APE_disciplina_optativa.semestre=" & intCodSemestre
		sql=sql & " 	AND APE_disciplina_optativa.codigo_ave_aluno_ano_letivo=" & strCodAluno
		
		sql=sql & " )"		
		
		sqlDisciplinaAluno = sql
end function
%>