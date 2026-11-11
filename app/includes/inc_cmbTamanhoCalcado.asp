<%
	sql = "SELECT CODIGO, DESCRICAO, resumo"
	sql = sql & " FROM SCA_TAMANHO_CALCADO"
	SQL = SQL & " order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTamanhoCalcado" id="cmbTamanhoCalcado" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTamanhoCalcado) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & " (" & rs("resumo") & ")</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>