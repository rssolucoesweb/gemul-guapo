<%
	if pagina_atual <>"" then 
		if pagina_atual <> "/app/academico.asp" then
			usuarioTemAcesso = "N"
			
			'VERIFICA SE O USUARIO TEM PERMISSÃO PARA ACESSA A PAGINA ATUAL'
			sql = "SELECT ISS.ITEM_CODG "
			sql = sql & " FROM SEG_ACESSOS_USUARIO AC"
			sql = sql & " INNER JOIN SEG_PERFIS_ITENS_SISTEMA PP ON PP.PITE_PERF_CODG = AC.ACES_PERF_CODG"
			sql = sql & " INNER JOIN SEG_ITENS_SISTEMA ISS ON ISS.ITEM_CODG = PP.PITE_ITEM_CODG"
			sql = sql & " WHERE AC.ACES_USUA_CODG='" & session("usuarioWeb")& "'"
			sql = sql & " AND ISS.ITEM_INFO_URL_NOVO = '" & pagina_atual & "'"
			sql = sql & " AND ISS.ITEM_STAT='A'"
			rs.open sql, cnn
			if not rs.eof then
				usuarioTemAcesso = "S"
			end if
			rs.close
					
			if usuarioTemAcesso = "N" then
				%>
				<script>
					alert("Atenção: Você não tem acesso a essa funcionalidade!");
					window.history.back()
				</script>	
				<%
				response.End()
			end if
		end if
	end if
%>