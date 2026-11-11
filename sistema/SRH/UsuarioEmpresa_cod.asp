    <!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 15/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Vincula Usuário a Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	strUsuarioPortal 	= UCASE(Trim(Trim(Request.Form("txtUsuarioPortal"))))
	intCodEmpMarcada 	= Trim(Request.Form("chkEmp"))
	
	'on error resume next
	cnn.begintrans
	
	strMensagem = "Registro Alterado com sucesso!"
	
	sql = " Delete from SEG_USUARIOS_EMPRESA "
	sql = sql & " Where CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
	cnn.execute sql
	GravarLog sql

	if trim(ucase(strUsuarioPortal)) = trim(ucase(Session("UsuarioWeb"))) then
		Session("QtdeUsuarioEmpresaAcessa") = 0
	end if

	if intCodEmpMarcada <> "" then 
		strMensagem 		= "Registro alterado com sucesso!"
		vetEmp 				= split(intCodEmpMarcada,",")	
		intCont = 0
		
		for i = 0 to ubound(vetEmp)
			
			intCont = intCont + 1	
			intCodEmpresa 		= TRIM(vetEmp(i))
			strNivelPermissao 	= Trim(Request.Form("chkNivelPermissao_" & intCodEmpresa))
							
			sql = " Insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA, NIVEL_PERMISSAO)"
			sql = sql & " VALUES ("
			sql = sql & "'" & strUsuarioPortal & "',"
			sql = sql & "" & intCodEmpresa & ","
			
			if strNivelPermissao <> "" then
				sql = sql & "'" & strNivelPermissao & "')"
			else
				sql = sql & "null )"
			end if 
		
			cnn.execute sql
			GravarLog sql
			intCont = intCont + 1
			
		next
		if trim(ucase(strUsuarioPortal)) = trim(ucase(Session("UsuarioWeb"))) then
			Session("QtdeUsuarioEmpresaAcessa") = intCont
		end if
	end if 
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='usuarioEmpresa_cad.asp?txtUsuarioPortal=<%=strUsuarioPortal%>';
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