	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	strUsuarioPortal 	= UCASE(Trim(Trim(Request.Form("txtUsuarioPortal"))))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	sql = " Delete from SEG_USUARIOS_INCLUI_CADASTRO "
	sql = sql & " Where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
	cnn.execute sql
	GravarLog sql

	if strUsuarioPortal <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
							
			sql = " Insert into SEG_USUARIOS_INCLUI_CADASTRO (CODIGO_SEG_USUARIOS_SISTEMA, SEG_ITENS_SISTEMA_ITEM_CODG, DATA_HORA_INCL)"
			sql = sql & " VALUES ("
			sql = sql & "'" & strUsuarioPortal & "',"
			sql = sql & "26,"
			sql = sql & "GETDATE() )"
		
			cnn.execute sql
			GravarLog sql
			intCont = intCont + 1
			
		next
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='UsuarioLiberaCadastro_cad.asp.asp';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>