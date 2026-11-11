	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 09/02/2015
	::	Desenvolvedores...: Asced.
	::	Objetivo Pagina...: Cadastro de Situação Exemplar
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")	
	intCodSituacao 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SCB_SITUACAOEXEMPLAR"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodSituacao = intCodNovo
			else
				intCodSituacao = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SCB_SITUACAOEXEMPLAR(Codigo, Cod_Empresa,  Descricao, Situacao )"
		sql = sql & " Values ("
		sql = sql & "" & intCodSituacao & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSituacao & "')"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCB_SITUACAOEXEMPLAR Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " where Cod_Empresa = " & intCodEmp
		sql = sql & " and Codigo = " & intCodSituacao
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCB_SITUACAOEXEMPLAR "
		sql = sql & " where Cod_Empresa = " & intCodEmp
		sql = sql & " and Codigo = " & intCodSituacao
		
	end if

	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='SituacaoExemplar_cad.asp';
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