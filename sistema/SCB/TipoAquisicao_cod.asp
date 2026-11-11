	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 19/02/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Tipo Aquisição
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
	intCodigo		 	= Trim(Request.Form("txtCodigo"))
	strNome 			= Trim(Request.Form("txtNome"))

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Cod_TipoAquisicao) as MaiorCodigo" 
		sql = sql & " FROM SCB_TIPOAQUISICAO"
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
			
		sql = "Insert Into SCB_TIPOAQUISICAO(Cod_TipoAquisicao, cod_empresa, Nome_TipoAquisicao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strNome & "')"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCB_TIPOAQUISICAO Set"
		sql = sql & " Nome_TipoAquisicao = '" & strNome & "'"
		sql = sql & " where Cod_TipoAquisicao = " & intCodigo
		sql = sql & " And cod_empresa = " & session("codEmpresa")
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCB_TIPOAQUISICAO "
		sql = sql & " where Cod_TipoAquisicao = " & intCodigo
		sql = sql & " And cod_empresa = " & session("codEmpresa")
		
	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TipoAquisicao_cad.asp';
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