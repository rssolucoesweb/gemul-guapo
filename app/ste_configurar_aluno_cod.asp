<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	opcao				= Trim(Request.Form("cmbOpcao"))
	strAnoLetivo 		= Trim(Request("txtAnoLetivo"))
	strMensagem = "Configuração alterada com sucesso..."
	
	sql = " update STE_configura_alunos set listar_Alunos = '" & opcao & "', ano_letivo = " & strAnoLetivo
	cnn.execute sql
	GravarLog sql
	
	'Log
	sql = "insert STE_configura_alunos_log"
	sql = sql & " select *, case when (select top 1 isnull(codigo_log,0)+1 from STE_configura_alunos_log order by codigo_log desc) is null then 1 else	(select  top 1 isnull(codigo_log,0)+1 from STE_configura_alunos_log order by codigo_log desc) end , '"&session("usuarioWeb")&"', getdate() "
	sql = sql & " from STE_configura_alunos"
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ste_configurar_aluno.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>
