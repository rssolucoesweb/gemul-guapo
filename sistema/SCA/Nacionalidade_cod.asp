<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de FormaIngresso 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodNacionalidade		 	= Trim(Request.Form("txtCodigo"))
	strDescricao 				= ucase(Trim(Request.Form("txtDescricao")))
			
	if acao="I" then
	
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update CENSO_PAIS Set"
		sql = sql & " nacionalidade = '" & strDescricao & "'"
		sql = sql & " where CODIGO = '" & intCodNacionalidade & "'"
	else
	

	end if
	
	cnn.execute sql
GravarLog sql
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Nacionalidade_cad.asp'
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location = 'Nacionalidade_cad.asp'
		</script>
		<%
	end if
%>