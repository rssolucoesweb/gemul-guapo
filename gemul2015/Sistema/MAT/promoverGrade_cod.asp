<%  
response.Charset = "ISO-8859-1" 
response.ContentType = "text/html" 

response.Expires = 60
response.Expiresabsolute = Now() - 1
response.AddHeader "pragma","no-cache"
response.AddHeader "cache-control","private"
response.CacheControl = "no-cache"

Server.ScriptTimeOut = 5000
%> 
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
acao					= Trim(Request("acao"))
strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
strSemestre				= Trim(Request.Form("cmbSemestre"))
strAnoLetivoReplicacao	= Trim(Request.Form("txtAnoLetivoReplicacao"))


sql = "exec SP_SCA_PromoveGrade " & session("codGrupo") & "," & strAnoLetivo & "," & strAnoLetivoReplicacao & ",'" & session("usuarioWeb") & "'"
response.write sql
CNN.EXECUTE sql
%>
<script>
	alert("Processamento finalizado com sucesso!");
	window.location='promoverGrade_cad.asp';
</script>
