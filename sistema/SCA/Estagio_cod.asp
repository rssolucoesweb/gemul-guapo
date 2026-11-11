<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 25/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Estágio 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodEstagio 		= Trim(Request.Form("txtCodigo"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	intCodProfessor     = Trim(Request("cmbProfessor"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_ESTAGIO(Cod_empresa, Ano, Semestre, Descricao, Cod_colaborador)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & intCodProfessor & "')"
		cnn.execute sql
		GravarLog sql

	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_ESTAGIO Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Cod_colaborador = '" & intCodProfessor & "',"
		sql = sql & " Semestre = " & intSemestre & ","
		sql = sql & " Ano = " & strAnoLetivo & ""
		sql = sql & " where Codigo = " & intCodEstagio
		sql = sql & " AND Cod_empresa = " & intCodEmp
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_ESTAGIO "
		sql = sql & " where Codigo = " & intCodEstagio
		sql = sql & " AND Cod_empresa = " & intCodEmp
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Estagio_cad.asp';
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