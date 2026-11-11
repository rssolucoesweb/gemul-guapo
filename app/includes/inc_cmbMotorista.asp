<%	
	if strExecutarSubmitColaborador = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT Codigo, Nome, FoneCelular"
	sql = sql & " FROM SRH_COLABORADOR"
	sql = sql & " WHERE codFuncao in (select Cod_Funcao from srh_funcaocolaborador where desc_funcao like '%motorista%') " 
	sql = sql & " Order by Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbColaborador" id="cmbColaborador" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodColaborador) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " - " & ucase(rs("FoneCelular")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>