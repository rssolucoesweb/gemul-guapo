<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha Descritiva - Conceito 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strSigla	 			= Trim(Request.Form("txtSigla"))
	intCodFichaDescritiva	= Trim(Request.form("cmbFichaDescritiva"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strValorInicial 		= replace(replace(trim(request.form("txtValorInicial")),".",""),",",".")
	strValorFinal 			= replace(replace(trim(request.form("txtValorFinal")),".",""),",",".") 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_FICHA_DESCRITIVA_CONCEITO(Cod_empresa, Cod_Grupo, Sigla, Cod_Ficha_Descritiva, Descricao, ValorInicial, ValorFinal)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strSigla & "',"
		sql = sql & "" & intCodFichaDescritiva & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strValorInicial & ","
		sql = sql & "" & strValorFinal & ")"

		cnn.execute sql
		GravarLog sql

	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_FICHA_DESCRITIVA_CONCEITO Set"
		sql = sql & " Sigla = '" & strSigla & "',"
		sql = sql & " Cod_Ficha_Descritiva = " & intCodFichaDescritiva & ","
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " ValorInicial = " & strValorInicial & ","
		sql = sql & " ValorFinal = " & strValorFinal & ""
		sql = sql & " where Codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_FICHA_DESCRITIVA_CONCEITO "
		sql = sql & " where Codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FichaDescritivaConceito_cad.asp';
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