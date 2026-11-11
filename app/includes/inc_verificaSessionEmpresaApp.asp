<%
if trim(session("CodEmpresa")) = "" then
	%>
	<script>
		alert("Aviso: Seu acesso a unidade expirou.\nSenhor(a) será redirecionado!");
		window.location.href = '/sistema/default.asp'
	</script>	
	<%
	response.End()
end if
%>