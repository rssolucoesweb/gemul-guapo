<%SESSION.Timeout = 1200%>
<%
'Configuração regional do Brasil
session.LCID=1046

'on error resume next

strUsuario 						= replace(replace(replace(Trim(Request.Form("txtLogin")),">",""),"/",""),"-","")
strSenha     					= Trim(Request.Form("txtSenha"))

response.Cookies("usuarioMatriculaAparecida") = strUsuario
response.Cookies("usuarioMatriculaAparecida").Expires = date + 60

Session("UsuarioWebMatriculaGrafico")	= ""
Session("UsuarioWebPerfil") 			= ""
Session("senha_temporaria") 			= ""
Session("UsuarioWebMatriculaTemporario")=""
if trim(strUsuario) = "" then
	'Sem senha digitada
	%>
	<script>
		alert("O usuario deve ser informado, verifique!");
		window.location = 'index.html';
	</script>
	<%
	response.end()
end if
%>
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
'destino = "matricula2015_cad.asp"

'controlePagina = right(replace(formatadataAP(date),"/",""),4) & mid(replace(formatadataAP(date),"/",""),3,2) & left(replace(formatadataAP(date),"/",""),2)
'if clng(controlePagina) >= 20150105 then 'inicio da matrícula
	
'end if

'VERIFICA SE O USUARIO ESTA CADASTRADO
sql = "Select usuario, senha, perfil, senha_temporaria"
sql = sql & " from MAT_usuario_matricula"
sql = sql & " where usuario = '" & strUsuario & "'"
sql = sql & " and senha = '" & strSenha & "'"
sql = sql & " and perfil = 'ADM'"
Rs.Open SQL, cnn
if Rs.EOF then
	Rs.close
	%>
	<script>
		alert("Usuário ou senha inválida, verifique!");
		window.location = 'index.html';
	</script>
	<%
	response.end
else
	strPerfil = rs("perfil")
	if trim(rs("senha_temporaria")) = "S" then
		Session("senha_temporaria") 	= "S"
		Session("UsuarioWebMatriculaTemporario") 	= strUsuario
		%>
		<script>
			alert("Usuário esta com senha temporária e deverá ser alterada, clique em OK para continuar.");
			window.location = "usuarioMatAlterarSenhaTemporaria_cad.asp";
		</script>
		<%
	else
		Session("UsuarioWebMatriculaGrafico") 	= strUsuario
		Session("UsuarioWebPerfil") 	= strPerfil
		%>
		<script>
			window.location = "principal.asp";
		</script>
		<%
	end if
end if
%>