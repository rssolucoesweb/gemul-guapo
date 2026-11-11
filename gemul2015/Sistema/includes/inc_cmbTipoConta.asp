<%
	SQL = "SELECT codigo, descricao "
	SQL = SQL & " FROM SCC_TipoConta"
	SQL = SQL & " Order by 2"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoConta" id="cmbTipoConta" style="width:180pt" class="Combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoConta) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
		%>
			<option value="<%=rs("codigo")%>" <%=strSelecionado%>><%=rs("descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>