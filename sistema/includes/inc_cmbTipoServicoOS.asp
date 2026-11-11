<%
	if intCodArea = "" then intCodArea = 0
	SQL = "select codigo, descricao, item "
	SQL = SQL & " from sos_tipo_servico "
	SQL = SQL & " where cod_area = " & intCodArea
	SQL = SQL & " order by item, descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoServicoOS" id="cmbTipoServicoOS"  style="width:380pt"  class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoServicoOS) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			%>
			<option value="<%=rs("codigo")%>" <%=strSelecionado%>><%=rs("item")%>. <%=rs("Descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
