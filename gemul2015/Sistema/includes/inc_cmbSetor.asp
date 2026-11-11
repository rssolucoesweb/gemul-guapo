<%
	sql = "SELECT s.CODIGO, s.DESCRICAO"
	sql = sql & " FROM MAT_setores s left join MAT_regiao_setores rs on rs.cod_setores = s.codigo "
	SQL = SQL & " WHERE cod_grupo =" & Session("CodGrupo")
	if intCodRegiao <> "" and intCodRegiao <> "0" then
		sql = sql & " and rs.cod_regiao = "& intCodRegiao
	end if
	sql = sql & " Order by s.DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbSetor" id="cmbSetor" style="width:130pt" class="combo">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodSetor) = trim(rs("CODIGO")) then
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