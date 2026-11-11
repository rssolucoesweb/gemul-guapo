<%
	SQL = "SELECT codigo, descricao "
	SQL = SQL & " FROM SCB_LOCALIZACAOGEOGRAFICA"
	sql = sql & " Where Cod_empresa = " & session("codEmpresa")
	SQL = SQL & " Order by 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbLocalizacaoGeografica" id="cmbLocalizacaoGeografica" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodLocalizacaoGeografica) = trim(rs("codigo")) then
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