<%
	if carregaSubmitFuncao = "" then
		funcaoSubmit = "onChange='submit()'"
	end if
	
	SQL = "SELECT Codigo, Cod_grupo, Descricao  "
	SQL = SQL & " FROM SRH_FUNCAOCATEGORIA"
	SQL = SQL & " WHERE Cod_grupo = " & Session("CodGrupo")
	SQL = SQL & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncaoCategoria" id="cmbFuncaoCategoria" style="width:230pt" class="form-control"  <%=funcaoSubmit%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFuncaoCategoria) = trim(rs("codigo")) then
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
