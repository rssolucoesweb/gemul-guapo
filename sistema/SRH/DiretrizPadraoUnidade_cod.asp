<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Diretriz Padrao - Unidade
-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	intDiretrizPadraoUnidade 	= Trim(Request("cmbDiretrizPadraoUnidade"))
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Incluido com sucesso!"
	
	sql = " Delete from SRH_DIRETRIZES_PADRAO_UNIDADE "
	sql = sql & " WHERE CodDiretrizPadrao = " & intDiretrizPadraoUnidade
	cnn.execute sql
	GravarLog sql

	if intCodEmpMarcada <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
		vetEmp 				= split(intCodEmpMarcada,",")	
		intCont = 0
		
		for i = 0 to ubound(vetEmp)
			
			intCont = intCont + 1	
			intCodEmpresa 		= TRIM(vetEmp(i))
							
			sql = " Insert into SRH_DIRETRIZES_PADRAO_UNIDADE (CodDiretrizPadrao, COD_EMPRESA)"
			sql = sql & " VALUES ("
			sql = sql & "" & intDiretrizPadraoUnidade & ","
			sql = sql & "" & intCodEmpresa & ")"

			cnn.execute sql
			GravarLog sql
			intCont = intCont + 1
			
		next
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DiretrizPadraoUnidade_cad.asp?txtUsuarioPortal=<%=strUsuarioPortal%>';
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