<%	
	if strExecutarSubmitTipoCalculo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodCriterio = "" then intCodCriterio = 0
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_TIPO_CALCULO"
	sql = sql & " where cod_criterio = "& intCodCriterio
	sql = sql & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoCalculo" id="cmbTipoCalculo" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoCalculo) = trim(rs("CODIGO")) then
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