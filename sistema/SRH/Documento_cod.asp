<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Disciplina
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodDocumento			= Trim(Request.Form("txtCodigo"))
	strTitulo	 			= Trim(Request.Form("txtTitulo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strCampos	 			= Trim(Request.Form("campos"))
	strSituacao				= Trim(Request.Form("Situacao"))
	intCodDepartamento		= Trim(Request.Form("cmbDepartamento"))
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SRH_DOCUMENTO(Cod_Empresa, Titulo, Documento, cod_Departamento, situacao, Campos)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strTitulo & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strCampos & "')"
		cnn.execute sql
		GravarLog left(sql,5000)

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SRH_DOCUMENTO Set"
		sql = sql & " Titulo = '" & strTitulo & "',"
		sql = sql & " Documento = '" & strDescricao & "',"
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " cod_Departamento = " & intCodDepartamento & ","
		sql = sql & " Campos = '" & strCampos & "'"
		sql = sql & " where codigo = " & intCodDocumento
		cnn.execute sql
		GravarLog left(sql,5000)
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_DOCUMENTO "
		sql = sql & " where codigo = " & intCodDocumento
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Documento_cad.asp';
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