<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/03/2010
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de perfil
-->
<%	
	if strExecutarSubmitPerfil = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	
	sql = "select s.PERF_SIST_SIGL, s.PERF_CODG as codigo, s.PERF_DESC as perfil"
	sql = sql & " from seg_perfil_grupo pg"
	sql = sql & " inner join seg_grupo g on g.codigo = pg.cod_grupo"
	sql = sql & " inner join seg_perfis_sistema s on s.PERF_CODG = pg.cod_perfis_sistema where 1=1"	
	sql = sql & " and pg.cod_perfis_sistema=11"'professores
	if intCodGrupo <> "0" then
		sql = sql & " and pg.cod_grupo = " & intCodGrupo
	end if
	sql = sql & " ORDER BY 	2"
	RS.OPEN SQL, CNN

	IF RS.EOF = FALSE THEN
		while not rs.eof
			
			strSelecionado = ""
			if strUsuarioPortal <>"" then
				sql = " select ACES_USUA_CODG"
				sql = sql & " from SEG_ACESSOS_USUARIO"
				sql = sql & " where ACES_USUA_CODG = '" & strUsuarioPortal & "'"
				sql = sql & " and ACES_PERF_CODG = " & rs("codigo")
				RSAUX.OPEN SQL, CNN
				IF RSAUX.EOF = FALSE THEN
					strSelecionado = " checked "
				END IF
				RSAUX.CLOSE
			end if
			%>
			<input <%=strSelecionado%> name="cmbPerfilGrupo" id="cmbPerfilGrupo" type="checkbox" value="<%=rs("codigo")%>" /><%=rs("PERF_SIST_SIGL")%>(<%=rs("perfil")%>)&nbsp;&nbsp;
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
