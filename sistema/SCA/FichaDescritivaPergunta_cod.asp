<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha Descritiva - Pergunta
-->

<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmp                       = Session("CodEmpresa")	
	intCodGrupo						= Session("CodGrupo")
	acao 							= Trim(Request.QueryString("acao"))
	intCodFichaDescritiva			= Trim(Request.Form("cmbFichaDescritiva"))
	strSubtitulo 					= Trim(Request.Form("txtSubtitulo"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	
	if Trim(Request.Form("txtCodigo")) <> "" then 
		intCodigo		= Trim(Request.Form("txtCodigo"))
	else
		intCodigo	= Trim(Request.Form("chkPergunta"))
	end if


	if intCodFichaDescritiva = "" then intCodFichaDescritiva = "0"
			
	if acao="I" then
	
		strMensagem = "Questão Salva com sucesso..."
		

		sql = "Insert Into SCA_FICHA_DESCRITIVA_PERGUNTA(Cod_Empresa, Cod_Grupo, cod_ficha_descritiva, Subtitulo, Descricao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & intCodFichaDescritiva & "',"
		sql = sql & "'" & strSubtitulo & "',"
		sql = sql & "'" & strDescricao & "')"
		cnn.execute sql
	
		GravarLog sql

	elseif acao="A" then
		
		strMensagem = "Questão Alterada com sucesso..."
		
		sql = "Update SCA_FICHA_DESCRITIVA_PERGUNTA Set"
		sql = sql & " Subtitulo = '" & strSubtitulo & "',"
		sql = sql & " Descricao = '" & strDescricao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		
		GravarLog sql
		
	else
	
		strMensagem = "Questão Excluida com sucesso..."
		
		sql = "Delete from SCA_FICHA_DESCRITIVA_PERGUNTA "
		sql = sql & " Where Codigo in (" & intCodigo & ")"
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FichaDescritivaPergunta_cad.asp?CodFichaDescritivao=<%=intCodFichaDescritiva%>';
		</script>
		<%
		response.end
		
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>