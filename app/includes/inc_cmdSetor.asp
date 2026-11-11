<%	
	if strExecutarSubmitSetor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT codigo, descricao from MAT_setores order by Descricao"
	rsAux1.OPEN SQL, CNN
%>
<select name="cmbSetor" id="cmbSetor" class="form-control"  style="width: 200px" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF rsAux1.EOF = FALSE THEN
		while not rsAux1.eof
			if trim(intCodSetor) = trim(rsAux1("codigo")) then
				strSelecionado = " selected"
				strSerie = rsAux1("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rsAux1("codigo")& " " & strSelecionado &">" & rsAux1("Descricao") & "</option> "  & vbcrlf
			rsAux1.movenext
		wend
	END IF
	rsAux1.close
%>
</select>