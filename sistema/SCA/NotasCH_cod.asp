<%response.Buffer=false%>
<html>
<body leftmargin="0" topmargin="0">
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../includes/inc_FuncaoInsereNotaFalta.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
'atualiza a carga horaria da turma

intTipoNota		 			= trim(ucase(request.QueryString("intTipoNota")))
intCodDisciplina 			= request.QueryString("intDisciplina")
intTurma  					= Trim(Request.QueryString("intTurma"))
intCh 						= Trim(Request.QueryString("intCh")) 'carga_horária
intTipoLancamento 			= request.QueryString("intTipoLancamento")


sql="SELECT carga_horaria"
sql=sql & " FROM SCA_CARGA_HORARIA"
sql=sql & " WHERE cod_empresa = " & session("CodEmpresa")
'sql=sql & " AND ano_letivo=" & session("strAnoLetivo")
sql=sql & " AND cod_turma = " & intTurma 
sql=sql & " AND cod_tipo_avaliacao = " & intTipoNota
if intTipoLancamento <> 2 then '
	sql=sql & " AND cod_disciplina = " & intCodDisciplina
else
	sql=sql & " AND cod_disciplina is null"
end if
rs.open sql, cnn

if rs.eof then
	if intCh <>"" then
		insereCargaHoraria intTurma, intCodDisciplina, intTipoNota, intCh,intTipoLancamento
	end if
else
	alteraCargaHoraria intTurma, intCodDisciplina, intTipoNota, intCh,intTipoLancamento
end if
rs.close				
%>
</body>
</html>
<script>
	window.close();
</script>