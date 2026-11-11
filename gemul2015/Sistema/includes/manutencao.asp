<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Filtra Ativos e todas as situações
-->
<%
		if trim(session("usuarioWeb")) <> "CLEOVIS" and trim(session("usuarioWeb")) <> "FERNANDO.DOMINGOS" then 
			%>
      		<script>
				alert("Aplicação em Desenvolvimento/Manutencão.");
				window.history.back();
			</script>
            <%
	    else		
			%>
      		<script>
				alert("Aplicação com AVISO Desenvolvimento/Manutencão.");
			</script>
            <%
			
		end if   
%>