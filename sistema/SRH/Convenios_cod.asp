<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Convênios
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodGrupo			= Session("CodGrupo")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SRH_CONVENIO"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SRH_CONVENIO(Codigo, Cod_grupo, Descricao, Situacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSituacao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_CONVENIO Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_CONVENIO "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo

	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Convenios_cad.asp';
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