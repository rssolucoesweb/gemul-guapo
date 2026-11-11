<%	
	if strExecutarSubmitCalculo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodTipoCalculo="" then intCodTipoCalculo = 0
	sql = "select codigo, descricao "
	sql = sql & " from SCA_CALCULO "
	sql = sql & " where cod_tipo_calculo = " & intCodTipoCalculo
	sql = sql & " and cod_tipo_lancamento in (1,2,3,4) "
	sql = sql & " order by descricao"	
	RS.OPEN SQL, CNN
%>
<select name="cmbCalculo" id="cmbCalculo" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCalculo) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" &  rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>