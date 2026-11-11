<%
if trim(session("LoginAluno_GemulEad")) = "" then
	%>
	<script>
		alert("ATENÇÃO: Sua sessão expirou, favor efetuar novamente um novo acesso!");
		window.location='login.asp';
	</script>	
	<%
	response.End()
end if
%>