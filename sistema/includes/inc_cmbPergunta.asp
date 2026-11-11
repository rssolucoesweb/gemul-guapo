<%	
	if strExecutarSubmitPergunta = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, NOME"
	sql = sql & " FROM PES_Pergunta "
	if cod_pesquisa <>"0" then
		sql = sql & " where cod_pesquisa = " & cod_pesquisa
		if filtro_tipo_pergunta = "S" then
			sql = sql & " and codigo not in (select distinct p.codigo"
			sql = sql & " from PES_resultado_respostas_texto rt "
			sql = sql & " inner join PES_resultado_respostas rr on rr.Codigo = rt.cod_resultado_respostas"
			sql = sql & " inner join PES_pergunta p on p.codigo = rr.cod_pergunta"
			sql = sql & " where p.cod_pesquisa = " & cod_pesquisa
			sql = sql & " )"
		end if
	end if
	sql = sql & " Order by NOME"
	RS.OPEN SQL, CNN
%>
<select name="cmbPergunta" id="cmbPergunta" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_pergunta) = trim(rs("codigo")) then
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