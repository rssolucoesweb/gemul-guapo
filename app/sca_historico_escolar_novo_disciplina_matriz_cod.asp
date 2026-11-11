<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="includes/inc_cnn.asp"-->

<%
dim id_historico
id_historico = Request("id_historico")

sql = sql & " INSERT INTO SCA_HISTORICO_ESCOLAR_DISCIPLINA ( "
sql = sql & "     cod_historico_escolar, "
sql = sql & "     ano_letivo, "
sql = sql & "     cod_curso, "
sql = sql & "     cod_periodo, "
sql = sql & "     semestre, "
sql = sql & "     cod_disciplina, "
sql = sql & "     cod_turma, "
sql = sql & "     cod_gradecurriculardisciplina, "
sql = sql & "     data_inclusao "
sql = sql & " ) "

sql = sql & " SELECT DISTINCT "
sql = sql & "     h.codigo AS cod_historico_escolar, "
sql = sql & "     h.ano_letivo, "
sql = sql & "     p.cod_curso, "
sql = sql & "     p.cod_periodo, "
sql = sql & "     h.semestre, "
sql = sql & "     gd.Cod_Disciplina, "
sql = sql & "     at.COD_TURMA, "
sql = sql & "     gd.Cod_GradeCurricularDisciplina, "
sql = sql & "     GETDATE() AS data_inclusao "

sql = sql & " FROM SCA_HISTORICO_ESCOLAR h "

sql = sql & " INNER JOIN SCA_GRADECURRICULAR g "
sql = sql & "     ON g.Cod_Periodo = h.Cod_Periodo "
sql = sql & "     AND g.AnoReferencia = h.ano_letivo "
sql = sql & "     AND g.diferenciada = 'N' "

sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA gd "
sql = sql & "     ON gd.Cod_GradeCurricular = g.Cod_GradeCurricular "

sql = sql & " INNER JOIN SCA_PERIODO p "
sql = sql & "     ON p.cod_periodo = g.cod_periodo "

sql = sql & " OUTER APPLY ( "
sql = sql & "     SELECT TOP 1 "
sql = sql & "         at.COD_TURMA "
sql = sql & "     FROM SCA_ALUNO_TURMA at "
sql = sql & "     WHERE at.cod_aluno = h.cod_aluno "
sql = sql & "       AND at.cod_empresa = h.cod_empresa "
sql = sql & "       AND at.ano_letivo = h.ano_letivo "
sql = sql & "     ORDER BY at.COD_TURMA DESC "
sql = sql & " ) at "

sql = sql & " WHERE h.codigo = " & id_historico
sql = sql & " AND NOT EXISTS ( " 
sql = sql & " SELECT 1 " 
sql = sql & " FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA hed " 
sql = sql & " WHERE hed.cod_historico_escolar = h.codigo " 
sql = sql & " AND hed.cod_disciplina = gd.Cod_Disciplina " 
sql = sql & " AND hed.cod_gradecurriculardisciplina = gd.Cod_GradeCurricularDisciplina " 
sql = sql & " ) "
cnn.Execute sql

if err.number = 0 then
	%>
	<script>
		alert("Matriz atualizada com sucesso.");
		window.location='sca_historico_escolar_novo_disciplina.asp?codhistoricoEscolar=<%=id_historico%>';
	</script>
	<%
end if	
%>