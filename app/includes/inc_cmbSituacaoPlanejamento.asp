<%	
	if strExecutarSubmitSituacaoPlanejamento = "" then
		strExecutarSubmitSituacaoPlanejamento = ""
	else
		strExecutarSubmitSituacaoPlanejamento = "onchange='submit()'"
	end if

	sql = "SELECT cod_situacao_planejamento_anual as codigo, "
	if mostraDescEscola = "S" then
		sql = sql & " descricao_escola as descricao "
	else
		sql = sql & " descricao "
	end if
	sql = sql & " FROM SCA_SITUACAO_PLANEJAMENTO"
	if filtroSituacaoPlanejamento <>"" then
		SQL = SQL & " WHERE cod_situacao_planejamento_anual in (" & filtroSituacaoPlanejamento & ")"
	end if
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbSituacaoPlanejamento" id="cmbSituacaoPlanejamento" class="form-control" <%=strExecutarSubmitSituacaoPlanejamento%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodSituacaoPlanejamento) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>