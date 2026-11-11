<%	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SEG_REGIAO"
	sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by DESCRICAO"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbRegiao"  id="cmbRegiao" style="width:550pt; height:450pt" class="form-control" multiple="multiple">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRegiao) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>