<%
if trim(session("usuarioWeb")) = "" then
	%>
	<script>
		alert("Aviso: Seu acesso Expirou.\nSenhor(a), favor efetuar novamente o acesso ao sistema!");
		window.location.href = '/default.asp'
	</script>	
	<%
	response.End()
end if

%>