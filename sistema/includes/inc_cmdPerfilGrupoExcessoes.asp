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
	
	if intCodGrupo = "" or intCodGrupo = "0"  then intCodGrupo = session("CodGrupo") 
	
	sql = "select s.PERF_SIST_SIGL, s.PERF_CODG as codigo, s.PERF_DESC as perfil"
	sql = sql & " from seg_perfil_grupo pg"
	sql = sql & " inner join seg_grupo g on g.codigo = pg.cod_grupo"
	sql = sql & " inner join seg_perfis_sistema s on s.PERF_CODG = pg.cod_perfis_sistema where 1=1"	
	sql = sql & " and pg.cod_grupo = " & intCodGrupo
	sql = sql & " ORDER BY 	1"
	RS.OPEN SQL, CNN

	IF RS.EOF = FALSE THEN
		while not rs.eof
			
			strSelecionado = ""
			if strUsuarioPortal <>"" then
				sql = " select ACES_USUA_CODG"
				sql = sql & " from Seg_Acessos_Usuario_Excessoes"
				sql = sql & " where ACES_USUA_CODG = '" & strUsuarioPortal & "'"
				sql = sql & " and ACES_PERF_CODG = " & rs("codigo")
				sql = sql & " AND Cod_Empresa = " & intCodEmpresaUsuario
				RSAUX.OPEN SQL, CNN
				IF RSAUX.EOF = FALSE THEN
					strSelecionado = " checked "
				END IF
				RSAUX.CLOSE
			end if
			%>
			<input <%=strSelecionado%> name="cmbPerfilGrupo" id="cmbPerfilGrupo" type="checkbox" value="<%=rs("codigo")%>" /><%=rs("PERF_SIST_SIGL")%>(<%=rs("perfil")%>)&nbsp;&nbsp;<BR>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
