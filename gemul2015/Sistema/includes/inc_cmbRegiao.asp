<%
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM MAT_REGIAO"
	SQL = SQL & " WHERE cod_grupo =" & Session("CodGrupo")
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbRegiao" id="cmbRegiao" style="width:130pt" class="combo" onchange="submit()">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRegiao) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>