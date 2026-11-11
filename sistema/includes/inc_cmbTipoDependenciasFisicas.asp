<%	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SRH_TIPO_DEPENDENCIAS_FISICAS"
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoDependenciasFisicas" id="cmbTipoDependenciasFisicas" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoDependencia) = trim(rs("CODIGO")) then
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