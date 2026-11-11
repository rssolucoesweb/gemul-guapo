<%
	if submitTipoAtividade= "S" then
		submitTipoAtividade = "onchange='submit()'"
	end if

	SQL = "SELECT cod_tipo_Atividade, DESCRICAO  "
	SQL = SQL & " FROM EAD_TIPO_Atividade"
	SQL = SQL & " Order by cod_tipo_Atividade"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoAtividade" id="cmbTipoAtividade" style="width:180pt" class="form-control" <%=submitTipoAtividade%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_tipo_Atividade) = trim(rs("cod_tipo_Atividade")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			%>
			<option value="<%=rs("cod_tipo_Atividade")%>" <%=strSelecionado%>><%=rs("Descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
