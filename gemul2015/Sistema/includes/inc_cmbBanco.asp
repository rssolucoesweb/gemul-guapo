<%
	SQL = "SELECT codigo as codBanco, nome_completo as Banco "
	SQL = SQL & " FROM scf_Banco"
	SQL = SQL & " WHERE cod_empresa=" & session("CodEmpresa")
	SQL = SQL & " and status='A'"
	SQL = SQL & " Order by 2"
	RS.OPEN SQL, CNN
%>
<select name="cmbBanco" id="cmbBanco" style="width:180pt" class="Combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodBanco) = trim(rs("codBanco")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			descricao = trim(rs("codBanco")) & " | " & trim(rs("banco")) 
			%>
			<option value="<%=rs("codBanco")%>" <%=strSelecionado%>><%=descricao%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
