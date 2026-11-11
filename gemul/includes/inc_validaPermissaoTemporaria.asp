<%
'VALIDAÇÃO PERMISSÃO DA PAGINA ACESSADA
'**************************************
'verifica se a unidade escolar foi selecionada anteriormente
if trim(session("strUsuarioTemporario")) = "" then
	%>
	<script>
		alert("ATENÇÃO: Sua sessão expirou, favor acessar o sistema novamente para seu perfil ser validado!");
		window.location="http://" + window.location.host + "/sige/login.asp"
	</script>
	<%
end if
%>