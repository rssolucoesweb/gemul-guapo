<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/03/2010
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de perfil
-->
<%	
	
	if intCodGrupo = "" or intCodGrupo = "0"  then intCodGrupo = session("CodGrupo") 
	
	sql = "select s.PERF_SIST_SIGL, s.PERF_CODG as codigo, s.PERF_DESC as perfil"
	sql = sql & " from seg_perfil_grupo pg"
	sql = sql & " inner join seg_grupo g on g.codigo = pg.cod_grupo"
	sql = sql & " inner join seg_perfis_sistema s on s.PERF_CODG = pg.cod_perfis_sistema where 1=1"	
	if intCodGrupo <> "0" then
		sql = sql & " and pg.cod_grupo = " & intCodGrupo
	end if
	sql = sql & " ORDER BY 	1"
	RS.OPEN SQL, CNN

	IF RS.EOF = FALSE THEN
		while not rs.eof
			
			strSelecionado = ""
			if intCodigo <>"" then
				sql = " select CODIGO"
				sql = sql & " from SEG_CONFIGURAR_MENSAGEM_PERFIL"
				sql = sql & " where COD_CONFIGURAR_MENSAGEM = " & intCodigo
				sql = sql & " and COD_PERFIL = " & rs("codigo")
				RSAUX.OPEN SQL, CNN
				IF RSAUX.EOF = FALSE THEN
					strSelecionado = " checked "
				END IF
				RSAUX.CLOSE
			end if
			
			%>
			<input <%=strSelecionado%> name="cmbPerfilGrupoMensagem" id="cmbPerfilGrupoMensagem" type="checkbox" value="<%=rs("codigo")%>" /><%=rs("PERF_SIST_SIGL")%>(<%=rs("perfil")%>)&nbsp;&nbsp;<BR>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
