<%
if trim(session("usuarioWeb")) = "" then
	%>
	<script>
		alert("Aviso: Seu acesso ao sistema expirou.\nSenhor(a), favor efetuar novamente um novo acesso ao sistema!");
		window.location.href = '/default.asp'
	</script>	
	<%
	response.End()
end if
%>