<%
response.Buffer = true
SESSION.Timeout = 1200
%>
<html>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<head>
<link type="text/css" rel="stylesheet" href="Estilo/Estilo.css">
</head>
<body>
<!--#include file="carregaMenuPortal.asp"-->
<%
	Session("strMontraMenuImob") = ""
	'on error resume next
	strDestinoModulo 		= request.QueryString("d")
	intCodigoEmpresa 		= Session("CodEmpresa")

	if request.QueryString("semp") <> "" then intCodigoEmpresa 		= request.QueryString("semp")
	strUsuario 	 			= Session("strUsuario")
	intCodPerfil 			= Session("codPerfil")

	if request.QueryString("sperf") <> "" then intCodPerfil 		= request.QueryString("sperf")
	intCodModulo 			= request.QueryString("m")

	dim intCodigomenu
	intCodigomenu 			= request.QueryString("mn")
	strLogin 				= "S" 'Variável utilizada na include inc_cnn.asp

	if session("UsuarioMaster") = "" then
		if strDestinoModulo = "" or intCodigoEmpresa = "" or strUsuario = "" or intCodPerfil = "" or intCodModulo = "" then
			%>
			<script>
				alert("Acesso inválido.");
				window.history.back();
			</script>
			<%
			response.end
		end if
	end if

	%>
	<!--#include file="../includes/inc_cnn.asp"-->
	<%
	if session("UsuarioMaster") = "" then
		sql = "select descricao from seg_modulo where codigo = " & intCodModulo
		rsAux.open sql, cnn
		if not rsAux.eof then
			Session("nomeModulo") = rsAux("descricao")
			rsAux.close
		else
			rsAux.close
			Session("nomeModulo") = ""
			%>
			<script>
				alert("Módulo inválido.");
				window.location = "../../../default.asp"
			</script>
			<%
			response.end
		end if
	else
		sql = "select descricao from seg_modulo where codigo = " & intCodModulo
		rsAux.open sql, cnn
		if not rsAux.eof then
			Session("nomeModulo") = rsAux("descricao")
			rsAux.close
		else
			rsAux.close
			Session("nomeModulo") = "Segurança"
		end if
	end if
	
	strMenuAdm							= "N" 'flag para montar o menu Administrativo
	flag = "N"	
	Session("strMontraMenuPortal") = "<ul class='sf-menu'>" & vbcrlf
	menuPortal intCodigomenu, strUsuario, intCodigoEmpresa, intCodPerfil, year(date), strMenuAdm, intCodModulo
	response.Redirect(strDestinoModulo)
	%>
</body>
</html>