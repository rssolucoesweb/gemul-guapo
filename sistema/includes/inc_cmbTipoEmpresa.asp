<%
	if strExecutarSubmitTipoEmpresa = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	SQL = "SELECT Codigo, Descricao "
	SQL = SQL & " FROM SEG_TipoEmpresa"
	SQL = SQL & " WHERE COD_GRUPO=" & Session("CodGrupo")
	SQL = SQL & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoEmpresa" id="cmbTipoEmpresa" style="width:150pt" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoEmpresa) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>