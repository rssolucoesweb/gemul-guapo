	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	intCodSetor 		= Trim(Trim(Request.Form("txtCodigo")))
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	sql = " delete MAT_setores_empresa where codigo_MAT_setores = " & intCodSetor
	cnn.execute sql
	GravarLog sql

	if intCodEmpMarcada <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
		intCont = 0
		
		sql = " insert MAT_setores_empresa "
		sql = sql & " select " & intCodSetor & ", codigo  from seg_empresa where codigo in (" & intCodEmpMarcada & ")"
		cnn.execute sql
		GravarLog sql
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='setores_cad.asp';
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