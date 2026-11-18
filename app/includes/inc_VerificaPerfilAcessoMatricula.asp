<%
	' Guapó: quem pode alterar capacidade/vagas reservadas na tela de Turmas Vagas.
	' Tela antiga de Guapó não tinha restrição além do menu; aqui vale quem tem o item
	' "Turmas Vagas Matricula" (412) no menu. Em Anápolis são os perfis 62 e 42 (gerente de matrícula e adm).
	perfilAlteracao = ""
	strTemAcessoFuncionalidade = "N"
	SQL = "SELECT TOP 1 A.ACES_PERF_CODG"
	SQL = SQL & " FROM SEG_ACESSOS_USUARIO A"
	SQL = SQL & " INNER JOIN SEG_PERFIS_ITENS_SISTEMA P ON P.PITE_PERF_CODG = A.ACES_PERF_CODG"
	SQL = SQL & " WHERE A.ACES_USUA_CODG = '" & replace(session("usuarioWeb") & "", "'", "''") & "'"
	SQL = SQL & " AND P.PITE_ITEM_CODG = 412"
	rs.open sql, cnn
	if not rs.EOF then	
		perfilAlteracao = "S"
	end if
	rs.close
%>
