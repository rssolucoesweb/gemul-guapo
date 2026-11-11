<%
	if submitPrioridade = "S" then
		submitPrioridade = "onchange='submit()'"
	end if

	SQL = "SELECT Codigo, Cod_grupo, DESCRICAO  "
	SQL = SQL & " FROM SOS_PRIORIDADE"
	SQL = SQL & " WHERE Cod_grupo = " & Session("CodGrupo")
	SQL = SQL & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbPrioridade" id="cmbPrioridade" style="width:180pt" class="form-control" <%=submitPrioridade%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPrioridade) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			%>
			<option value="<%=rs("codigo")%>" <%=strSelecionado%>><%=rs("Descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
