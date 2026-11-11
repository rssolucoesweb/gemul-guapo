<%
	SQL = "SELECT Codigo, Cod_grupo, Descricao  "
	SQL = SQL & " FROM SRH_CARGOCATEGORIA"
	SQL = SQL & " WHERE Cod_grupo = " & Session("CodGrupo")
	SQL = SQL & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCargoCategoria" id="cmbCargoCategoria" style="width:68pt" class="Combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCargoCategoria) = trim(rs("codigo")) then
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
