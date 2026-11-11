<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Resolucao Curso
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo				= Request.Form("txtCodigo")
	intCodEmp				= Session("CodEmpresa")
	intCodCurso				= Trim(Request.Form("txtCodCurso"))
	strhabilitacao			= Request.Form("txthabilitacao")
	strReconhecimento		= Request.Form("txtreconhecimento")
	strAutorizacao			= Request.Form("txtautorizacao")
	strDataReconhecimento	= formatadataBD(Request.Form("txtDataReconhecimento"))
	strDataAutorizacao		= formatadataBD(Request.Form("txtDataAutorizacao"))
	strCHExigida			= Request.Form("txtCHExigida")

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_CURSO_RESOLUCAO(Cod_Empresa, Cod_curso, habilitacao, reconhecimento, autorizacao, "
		sql = sql & " dataReconhecimento, DataAutorizacao, CH_Exigida)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "'" & strhabilitacao & "',"
		sql = sql & "'" & strReconhecimento & "',"
		sql = sql & "'" & strAutorizacao & "',"
		sql = sql & "'" & strDataReconhecimento & "',"
		sql = sql & "'" & strDataAutorizacao & "',"
		sql = sql & "'" & strCHExigida & "')"

		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_CURSO_RESOLUCAO Set"
		sql = sql & " habilitacao = '" & strhabilitacao & "',"
		sql = sql & " reconhecimento = '" & strReconhecimento & "',"
		sql = sql & " autorizacao = '" & strAutorizacao & "',"
		sql = sql & " dataReconhecimento = '" & strDataReconhecimento & "',"
		sql = sql & " DataAutorizacao = '" & strDataAutorizacao & "',"
		sql = sql & " CH_Exigida = '" & strCHExigida & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_CURSO_RESOLUCAO "
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
	
	end if
	
	cnn.execute sql
	GravarLog sql

if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('CursoResolucao_cad.asp?CodCurso=<%=intCodCurso%>');
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