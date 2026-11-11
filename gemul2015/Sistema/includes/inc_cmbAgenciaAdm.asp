<%
	SQL = "SELECT cod_Banco, Codigo "
	SQL = SQL & " FROM scc_Agencia"
	SQL = SQL & " WHERE cod_empresa=" & session("CodEmpresa")
	if intCodBanco <> "0" then
		SQL = SQL & " and cod_Banco='" & intCodBanco & "'"
	end if
	SQL = SQL & " Order by 2"
	RS.OPEN SQL, CNN
%>
<select name="cmbAgencia" id="cmbAgencia" style="width:68pt" class="Combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAgencia) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			%>
			<option value="<%=rs("codigo")%>" <%=strSelecionado%>><%=rs("codigo")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
