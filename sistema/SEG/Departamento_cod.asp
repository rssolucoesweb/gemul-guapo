	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Departamento
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
 	<%
	
	paginaRetorno		= "Departamento_cad.asp"
	
	strAcao 			= Trim(Request.QueryString("acao"))
	intCodEmp 			= Session("CodEmpresa")
	intCodGrupo			= Session("CodGrupo")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao  		= ReplaceRequest(Trim(Request.Form("txtDescricao")))
	strSigla			= Trim(Request.Form("txtSigla"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))

	'on error resume next
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Departamento Salvo com sucesso..."
	
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
	
		
	elseif strAcao = "A"then
	
		strMensagem = "Departamento Alterado com sucesso..."
		
		sql = "Update SEG_DEPARTAMENTO Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " SITUACAO = '" & strSituacao & "',"
		sql = sql & " SIGLA = '" & strSigla & "'"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And CODIGO = " & intCodigo
		
			
	elseif strAcao = "E"then 
			
		strMensagem = "Departamento Excluido com sucesso"
		
		sql = "Delete from SEG_DEPARTAMENTO "
		sql = sql & " Where CODIGO = " & intCodigo
	
	end if

	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=paginaRetorno%>';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>