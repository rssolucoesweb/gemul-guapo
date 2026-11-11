<%
	if submitArea = "S" then
		submitArea = "onchange='submit()'"
	end if

	SQL = "SELECT Codigo, Cod_grupo, DESCRICAO  "
	SQL = SQL & " FROM SOS_AREA"
	SQL = SQL & " WHERE Cod_grupo = " & Session("CodGrupo")
	SQL = SQL & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbArea" id="cmbArea" style="width:180pt" class="form-control" <%=submitArea%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodArea) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strMnsExecutor = " - " & rs("Descricao")
			else
				strSelecionado = ""
				strMnsExecutor = ""
			end if
			%>
			<option value="<%=rs("codigo")%>" <%=strSelecionado%>><%=rs("codigo")%>. <%=rs("Descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
