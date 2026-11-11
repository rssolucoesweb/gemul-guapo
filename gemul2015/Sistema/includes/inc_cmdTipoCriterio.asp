<%	
	if strExecutarSubmitTipoCriterio = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT codigo, descricao, TIPO"
	sql = sql & " FROM SCA_TIPO_CRITERIO"
	SQL = SQL & " WHERE cod_grupo=" & Session("CodGrupo")
	if retiraCriterio <> "" then
		SQL = SQL & " and codigo <> " & retiraCriterio
	end if
	if verificaCurso <> "" then
		IF intCodComp = "" THEN intCodComp = "0"
		SQL = SQL & " and codigo in (select cod_tipo_criterio FROM SCA_TIPO_AVALIACAO WHERE cod_curso=" & intCodComp & ")"
	end if
	sql = sql & " Order by TIPO"
	'response.write sql
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoCriterio" id="cmbTipoCriterio" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoCriterio) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
