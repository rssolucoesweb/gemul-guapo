<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de grupo
-->
<%	
	if intCodEmpresaGrupoUsuario = "" or intCodEmpresaGrupoUsuario = "0" then intCodEmpresaGrupoUsuario = Session("CodEmpresa")

	sql = "select SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO AS GRUPO"
	sql = sql & " FROM SEG_USUARIOS_EMPRESA"
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	sql = sql & " LEFT 	JOIN SEG_GRUPO 	 ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
	sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "'" 
	sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA in (" & Session("CodTodasEmpresaGrupo") & ")"
	sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RSAux.OPEN SQL, CNN
%>
<select name="cmdEmpresaGrupoUsuario" id="cmdEmpresaGrupoUsuario" style="width:390pt" class="combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%

	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodEmpresaGrupoUsuario) = trim(RSAux("COD_EMPRESA")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			strGrupo = "SEM GRUPO"
			if not isnull(RSAux("GRUPO")) then strGrupo = RSAux("GRUPO")
			
			response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & strGrupo & " - " & RSAux("RAZAOSOCIAL") & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>