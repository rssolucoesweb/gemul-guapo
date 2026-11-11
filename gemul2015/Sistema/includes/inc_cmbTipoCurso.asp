<%
	SQL = "SELECT cod_curso as codigo, descricao "
	SQL = SQL & " FROM sca_curso"
	SQL = SQL & " Order by 2"
	RS.OPEN SQL, CNN
%>

<select name="cmbTipoCurso" id="cmbTipoCurso" class="combo"  style="width:150pt">
	<option value="0">Selecione...</option>
    <%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intTipoCurso) = trim(rs("codigo")) then
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