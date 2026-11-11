<%
'VALIDAÇÃO PERMISSÃO DA PAGINA ACESSADA
'**************************************
set rsAcesso  = Server.CreateObject("adodb.recordset")
strCaminhoPaginaAcessada = Request.ServerVariables("path_info")

strUsuarioAtual 		 = session("strUsuario")

sql="SELECT SEG_usuarios_acesso.cpf_SEG_usuarios "
sql=sql & " FROM SEG_menu INNER JOIN ((SEG_perfil INNER JOIN SEG_usuarios_acesso ON SEG_perfil.codigo = SEG_usuarios_acesso.codigo_SEG_perfil) INNER JOIN SEG_perfil_menu ON SEG_perfil.codigo = SEG_perfil_menu.codigo_SEG_perfil) ON SEG_menu.codigo = SEG_perfil_menu.codigo_SEG_menu "
sql=sql & " WHERE SEG_usuarios_acesso.cpf_SEG_usuarios = " & strUsuarioAtual 
sql=sql & " AND SEG_menu.link LIKE '" & strCaminhoPaginaAcessada & "%'"
rsAcesso.open sql, cnn
if rsAcesso.eof then
	rsAcesso.close
	%>
	<script>
		alert("Usuário não tem permissão para acessar essa página.");
		window.location="http://" + window.location.host + "/"
	</script>
	<%	
	response.End()
else
	rsAcesso.close
end if

%>