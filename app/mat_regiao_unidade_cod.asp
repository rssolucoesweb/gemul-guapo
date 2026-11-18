<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8"
%>
	<!--#include file="includes/inc_verificaSessionApp.asp"-->
	<!--#include file="includes/inc_cnn.asp"-->
	<!--#include file="includes/inc_replaceRequest.asp"-->
	<!--#include file="includes/inc_log.asp"-->
	<%
	intCodRegiao 		= Trim(Trim(Request.Form("txtCodigo")))
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	sql = " delete MAT_regiao_empresa where cod_regiao = " & intCodRegiao
	cnn.execute sql
	GravarLog sql

	if intCodEmpMarcada <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
		intCont = 0
		
		sql = " insert MAT_regiao_empresa "
		sql = sql & " select " & intCodRegiao & ", codigo  from seg_empresa where codigo in (" & intCodEmpMarcada & ")"
		cnn.execute sql
		GravarLog sql
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='mat_regiao.asp';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>