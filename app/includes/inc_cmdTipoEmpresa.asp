<%	
	if strExecutarSubmitTipoEmpresa = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SEG_TipoEmpresa"
	SQL = SQL & " WHERE cod_grupo=" & Session("CodGrupo")
	if trim(strExecutarFiltroTipoEmpresa)<>"" then
		SQL = SQL & " and codigo in (" & strExecutarFiltroTipoEmpresa & ")"
	end if
	sql = sql & " Order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoEmpresa" id="cmbTipoEmpresa" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoEmpresa) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>