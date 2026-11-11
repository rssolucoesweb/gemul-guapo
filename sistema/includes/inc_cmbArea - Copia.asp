<%
	if submitTipoLink= "S" then
		submitTipoLink = "onchange='submit()'"
	end if

	SQL = "SELECT cod_tipo_link, DESCRICAO  "
	SQL = SQL & " FROM EAD_TIPO_LINK"
	SQL = SQL & " Order by cod_tipo_link"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoLink" id="cmbTipoLink" style="width:180pt" class="form-control" <%=submitTipoLink%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_tipo_link) = trim(rs("cod_tipo_link")) then
				strSelecionado = " selected"
				strMnsExecutor = " - " & rs("Descricao")
			else
				strSelecionado = ""
				strMnsExecutor = ""
			end if
			%>
			<option value="<%=rs("cod_tipo_link")%>" <%=strSelecionado%>><%=rs("Descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
