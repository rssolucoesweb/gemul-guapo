<%	
	strProjetoSociais = ""
	sql = "SELECT Cod_ProjetoSociais, Desc_ProjetoSociais"
	sql = sql & " FROM SCA_PROJETOSOCIAIS"
	sql = sql & " Order by Cod_ProjetoSociais"
	RS.OPEN SQL, CNN
%>
<select name="cmbProjetoSociais" id="cmbProjetoSociais" class="form-control" OnChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProjetoSociais) = trim(rs("Cod_ProjetoSociais")) then
				strSelecionado = " selected"
				strProjetoSociais = rs("Desc_ProjetoSociais")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_ProjetoSociais")& " " & strSelecionado &">" & rs("Desc_ProjetoSociais") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>