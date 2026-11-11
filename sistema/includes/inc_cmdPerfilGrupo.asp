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
	'if Session("UsuarioMaster") = "S" then
		sql = sql & " and pg.cod_perfis_sistema not in (11,75,91,83)"'professores
	'else
	'	sql = sql & " and pg.cod_perfis_sistema not in (11,62,63,44,64)"'professores
	'end if
	if intCodGrupo <> "0" then
		sql = sql & " and pg.cod_grupo = " & intCodGrupo
	end if
	sql = sql & " ORDER BY 	1"
	RS.OPEN SQL, CNN
	IF RS.EOF = FALSE THEN
		while not rs.eof
			codPerfilGrupo = rs("codigo")
			strSelecionado = ""
			if strUsuarioPortal <>"" then
				sql = " select ACES_USUA_CODG"
				sql = sql & " from SEG_ACESSOS_USUARIO"
				sql = sql & " where ACES_USUA_CODG = '" & strUsuarioPortal & "'"
				sql = sql & " and ACES_PERF_CODG = " & rs("codigo")
				if intCodigo<>"" then
					sql = sql & " and cod_colaborador = " & intCodigo
				end if
				RSAUX.OPEN SQL, CNN
				IF RSAUX.EOF = FALSE THEN
					strSelecionado = " checked "
				END IF
				RSAUX.CLOSE
			end if
			bloq = " "
			perfil = "(" & rs("perfil") & ")"
			if rs("codigo") = "62" or rs("codigo") = "63" or rs("codigo") = "44" or rs("codigo") = "72" or rs("codigo") = "67" or rs("codigo") = "64" then
				perfil = "<strong>(" & rs("perfil") & ")</strong>"
				if trim(Session("UsuarioMaster")) = "S" then
					bloq = " "
				else
					bloq = " disabled='disabled'  "
				end if
			end if
			%>
			<input <%=strSelecionado%> name="cmbPerfilGrupo" id="cmbPerfilGrupo" type="checkbox" <%=bloq%> value="<%=codPerfilGrupo%>" /><%=rs("PERF_SIST_SIGL")%><%=perfil%>&nbsp;&nbsp;<BR>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
