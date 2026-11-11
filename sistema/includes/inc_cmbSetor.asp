<%	
	if strExecutarSubmitSetor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, NOME"
	sql = sql & " FROM PES_SETOR"
	if cod_pesquisa<>"0" then
		sql = sql & " where cod_cidade in (select distinct cod_cidade from pes_pesquisa where codigo = " & cod_pesquisa & ")"
	end if
	sql = sql & " Order by NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbSetor" id="cmbSetor" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_setor) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>