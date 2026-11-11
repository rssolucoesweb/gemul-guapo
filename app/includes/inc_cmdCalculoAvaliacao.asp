<%	
	if strExecutarSubmitCalculoAvaliacao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if intCodCurso="" then intCodCurso = 0

	sql = "select DISTINCT C.CODIGO, C.descricao "
	sql = sql & " from SCA_CRITERIO_AVALIACAO CA"
	sql = sql & " INNER JOIN SCA_CALCULO_AVALIACAO A ON A.COD_CRITERIO_AVALIACAO = CA.CODIGO"
	sql = sql & " INNER JOIN SCA_CALCULO C ON C.CODIGO = A.COD_CALCULO"
	sql = sql & " where CA.ANO_LETIVO = " & strAnoLetivo
	sql = sql & " and CA.cod_curso = " & intCodCurso
	sql = sql & " order by c.descricao"	
	RS.OPEN SQL, CNN
%>
<select name="cmbCalculoAvaliacao" id="cmbCalculoAvaliacao" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCalculo) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" &  rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>