<%	
	if tipo = "" then
		tipo = "CANDIDATO"
	end if
	
	if strExecutarSubmitCandidato = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, NOME"
	sql = sql & " FROM PES_tipo_resposta WHERE TIPO = '"& tipo &"' and SITUACAO='A' and (cod_cidade is null or cod_cidade = " & cod_cidade & ")"
	sql = sql & " Order by NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoResposta" id="cmbTipoResposta" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_tipo_resposta) = trim(rs("codigo")) then
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