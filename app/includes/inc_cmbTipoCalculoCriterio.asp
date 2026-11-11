<%
	if strExecutarSubmitTipoCalculo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodCriterio = "" then intCodCriterio = "0"
	SQL = "select tc.codigo, tcc.descricao as criterio, tc.cod_criterio, tc.descricao as tipo_calculo"
	SQL = SQL & " from SCA_TIPO_CALCULO tc "
	SQL = SQL & " inner join SCA_CRITERIO tcc on tcc.codigo = tc.cod_criterio"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoCalculoCriterio" id="cmbTipoCalculoCriterio" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoCalculoCriterio) = trim(rs("Codigo")) then
				strSelecionado = " selected"
				intCodCriterio = trim(rs("cod_criterio"))
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("criterio") & " | " & rs("tipo_calculo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>