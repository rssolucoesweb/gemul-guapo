<%	
	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SRH_PROCESSO_LICENCA"
	sql = sql & " Order by descricao"
	RSAux1.OPEN SQL, CNN
%>
<select name="cmbTipoProcessoLicenca_<%=controleInicio%>" id="cmbTipoProcessoLicenca_<%=controleInicio%>" class="form-control" style="width:200px">
	<option value="0">Selecione...</option>
<%
	IF RSAux1.EOF = FALSE THEN
		while not RSAux1.eof
			if trim(intCodTipoProcessoLicenca) = trim(RSAux1("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux1("codigo")& " " & strSelecionado &">" & RSAux1("descricao") & "</option> "  & vbcrlf
			RSAux1.movenext
		wend
	END IF
	RSAux1.close
%>
</select>