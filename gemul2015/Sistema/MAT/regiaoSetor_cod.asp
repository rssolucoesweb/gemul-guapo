	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	intCodRegiao 		= Trim(Trim(Request.Form("txtCodigo")))
	intCodMarcada 	= Trim(Request.Form("chkEmp"))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	sql = " delete MAT_regiao_setores where cod_regiao = " & intCodRegiao
	cnn.execute sql
	GravarLog sql

	if intCodMarcada <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
		intCont = 0
		
		sql = " insert MAT_regiao_setores "
		sql = sql & " select " & intCodRegiao & ", codigo  from mat_setores where codigo in (" & intCodMarcada & ")"
		cnn.execute sql
		GravarLog sql
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='regiao_cad.asp';
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