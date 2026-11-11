<%
if trim(Session("strUsuario")) = "" then
	%>
	<script>
		alert("Aviso: Seu Login de Acesso Expirou.\nSenhor(a) usuário(a) por medida de segurança você deverá acessar novamente o sistema!");
		window.location="/";
	</script>	
	<%
	response.End()
end if
%>