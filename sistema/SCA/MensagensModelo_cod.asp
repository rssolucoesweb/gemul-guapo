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
	acao 				= Trim(Request.QueryString("acao"))

	intCodEmp			= Session("CodEmpresa")
	intCodMensagem		= Trim(Request("txtCodigo"))
	strTitulo	 		= Trim(Request.Form("txtTitulo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	intCodDepartamento	= Trim(Request.Form("cmbDepartamento"))
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_MENSAGENSMODELO(Cod_Empresa, titulo, cod_departamento, mensagem)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strTitulo & "',"
		sql = sql & "" & intCodDepartamento & ","
		sql = sql & "'" & strDescricao & "')"
		cnn.execute sql
		GravarLog left(sql,5000)

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_MENSAGENSMODELO Set"
		sql = sql & " Titulo = '" & strTitulo & "',"
		sql = sql & " mensagem = '" & strDescricao & "',"
		sql = sql & " cod_Departamento = " & intCodDepartamento
		sql = sql & " where codigo = " & intCodMensagem
		sql = sql & " and cod_empresa = " & intCodEmp

		cnn.execute sql
		GravarLog left(sql,5000)
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_MENSAGENSMODELO "
		sql = sql & " where codigo = " & intCodMensagem
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='MensagensModelo_cad.asp';
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