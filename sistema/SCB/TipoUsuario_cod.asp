	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 09/02/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Area do Conhecimento
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
	intQtdeExemplar 	= Trim(Request.Form("txtQtdeExemplar"))
	strValor	 		= replace(Trim(Request.Form("txtValor")),",",".")

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Cod_TipoUsuario) as MaiorCodigo" 
		sql = sql & " FROM SCB_TIPOUSUARIO"
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
			
		sql = "Insert Into SCB_TIPOUSUARIO(Cod_Empresa, Cod_TipoUsuario, Nome, QtdeExemplar, Valor)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strNome & "',"
		sql = sql & "" & intQtdeExemplar & ","
		sql = sql & "" & strValor & ")"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCB_TIPOUSUARIO Set"
		sql = sql & " Nome = '" & strNome & "',"
		sql = sql & " QtdeExemplar = " & intQtdeExemplar & ","
		sql = sql & " Valor = " & strValor & ""
		sql = sql & " where Cod_TipoUsuario = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCB_TIPOUSUARIO "
		sql = sql & " where Cod_TipoUsuario = " & intCodigo
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TipoUsuario_cad.asp';
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