<%
sql = " select distinct SEG_usuarios.cpf, SEG_usuarios.nome"
sql = sql & " from SEG_usuarios_acesso"
sql = sql & " inner join SEG_usuarios on SEG_usuarios.cpf = SEG_usuarios_acesso.cpf_SEG_usuarios"
sql = sql & " inner join SEG_empresa on SEG_empresa.codigo = SEG_usuarios_acesso.codEmpresa"
sql = sql & " inner join SEG_grupo on SEG_grupo.codigo = SEG_empresa.codigo_SEG_grupo"
sql = sql & " where  1=1"
sql = sql & " and SEG_empresa.codigo_SEG_grupo = " & intCodGrupo
if intCodEmpresa<>"0" then
	sql = sql & " and SEG_usuarios_acesso.codEmpresa = " & intCodEmpresa
end if
sql = sql & " and (SEG_usuarios.situacao = 'A') order by SEG_usuarios.nome"

	RS.OPEN SQL, CNN
%>
<select name="cmbUsuario" id="cmbUsuario" style="width:250pt" class="combo">
	<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodUsuario) = trim(rs("cpf")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cpf")& " " & strSelecionado &">" & ucase(rs("nome")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>