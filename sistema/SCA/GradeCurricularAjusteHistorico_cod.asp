<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	intCodigo			= Trim(Request("idnt"))
	strValor			= Replace(Replace(Trim(Request("ValorCampo")),".",""),",",".")

	sql = "Update SCA_GradeCurricularDisciplinaHistorico Set "
	if strValor = "" then
		sql = sql & "Cod_disciplina_hsitorico = null"
	else
		sql = sql & "Cod_disciplina_hsitorico = " & strValor & ""
	end if
	sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodigo
	cnn.execute sql
	GravarLog sql
		

%>