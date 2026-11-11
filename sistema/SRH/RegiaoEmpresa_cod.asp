    <!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 15/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Vincula Usuário a Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	intCodRegiao 		= Trim(Trim(Request.Form("cmbRegiao")))
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	sql = " update SEG_EMPRESA set cod_regiao = null"
	sql = sql & " Where cod_regiao = " & intCodRegiao
	cnn.execute sql
	GravarLog sql

	if intCodEmpMarcada <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
		intCont = 0
		
		sql = " update SEG_EMPRESA set cod_regiao = " & intCodRegiao
		sql = sql & " where codigo in (" & intCodEmpMarcada & ")"

		cnn.execute sql
		GravarLog sql
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='RegiaoEmpresa_cad.asp?cmbRegiao=<%=intCodRegiao%>';
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