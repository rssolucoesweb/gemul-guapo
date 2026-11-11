	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	strNotificacao1		= Trim(Request.Form("txtNotificacao1"))
	strNotificacao2		= Trim(Request.Form("txtNotificacao2"))

	'on error resume next
	cnn.begintrans
	
	if intCodEmpMarcada <> "" then 
		
		strMensagem = "Notificação Salva com sucesso!"
		
		vetEmp 				= split(intCodEmpMarcada,",")	
		
		for i = 0 to ubound(vetEmp)
			intCodEmpresa 		= TRIM(vetEmp(i))
			sql = "Update SEG_ENCERRAMENTOATIVIDADES Set"
			sql = sql & " Notificacao1 = '" & strNotificacao1 & "',"
			sql = sql & " Notificacao2 = '" & strNotificacao2 & "'"
			sql = sql & " where cod_empresa = " & intCodEmpresa
		    cnn.execute sql
		next
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='AvisosEmpresa_cad.asp';
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