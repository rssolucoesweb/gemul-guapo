<%	if strExecutarSubmitBimestre = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	sql = "SELECT CODIGO, DESCRICAO, data_inicio, data_fim"
	sql = sql & " FROM SCA_BIMESTRE"
	SQL = SQL & " WHERE Ano_Letivo = " & strAnoLetivo
	SQL = SQL & " AND 	semestre in (" & intSemestre & ")"
	sql = sql & " Order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbBimestre" id="cmbBimestre" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodBimestre) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strDescricaoBimestre = rs("DESCRICAO")
				strDataInicioBimestre = rs("data_inicio")
				strDataFimBimestre = rs("data_fim")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>