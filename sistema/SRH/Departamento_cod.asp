<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Departamento
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp 			= Session("CodEmpresa")
	intCodGrupo			= Session("CodGrupo")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescDepto"))
	strSigla			= Trim(Request.Form("txtSigla"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "SELECT Max(CODIGO) as MaiorCodigo" 
		sql = sql & " FROM SEG_DEPARTAMENTO"
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

		sql = "Insert Into SEG_DEPARTAMENTO(COD_EMPRESA, COD_GRUPO, CODIGO, DESCRICAO, SIGLA, SITUACAO)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSigla & "',"
		sql = sql & "'" & strSituacao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SEG_DEPARTAMENTO Set"
		sql = sql & " COD_GRUPO = " & intCodGrupo & ","
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " SITUACAO = '" & strSituacao & "',"
		sql = sql & " SIGLA = '" & strSigla & "'"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And CODIGO = " & intCodigo
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SEG_DEPARTAMENTO "
		sql = sql & " Where CODIGO = " & intCodigo
	
	end if
	
	cnn.execute sql
	GravarLog sql
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Departamento_cad.asp';
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