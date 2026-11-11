<!--
	::	Empresa...........: Asced
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Controle de Acesso
	::	Data Criação......: 26/01/2015
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	strUsuarioPortal 	= UCASE(Trim(Trim(Request.Form("txtUsuarioPortal"))))
	intCodPerfil		= Trim(Request("cmbPerfil"))
	strInfoRepasse 		= "N"

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso"
	
		sql = "Insert Into Seg_Acessos_Usuario(Aces_Usua_Codg, Aces_Perf_Codg, Aces_Info_Repasse)"
		sql = sql & " Values ("
		sql = sql & "'" & strUsuarioPortal & "',"
		sql = sql & "" & intCodPerfil & ","
		sql = sql & "'" & strInfoRepasse & "')"

	elseif acao="A" then
				
		strMensagem = "Registro Alterado com sucesso!"
		
	elseif acao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
				
		sql = "Delete From Seg_Acessos_Usuario"
		sql = sql & " Where Aces_Usua_Codg = '" & strUsuarioPortal & "'"
		sql = sql & " And  Aces_Perf_Codg = " & intCodPerfil
	
	end if

	cnn.execute sql
	GravarLog sql
	
	if err.number = -2147217900 then
		cnn.committrans
		%>
		<script>
			alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
			 window.location = 'Controle_Acesso_cad.asp?txtUsuarioPortal=<%=strUsuarioPortal%>';
		</script>
		<%
		response.end
	end  if 
	
	if err.number = 0 then
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'Controle_Acesso_cad.asp?txtUsuarioPortal=<%=strUsuarioPortal%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description & "&strPaginaErro='Configurar_Perfil_cad.asp'"
		cnn.rollbacktrans
	end if
%>