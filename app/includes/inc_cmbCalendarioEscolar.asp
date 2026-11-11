<%	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	sql = "select cod_calendario_ue, nome_calendario from SCA_CALENDARIO_UE"
	sql = sql & " WHERE ano_letivo=" & strAnoLetivo
	sql = sql & " and situacao = 'A' and cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by nome_calendario"

	RS.OPEN SQL, CNN
%>
<select name="cmbCalendarioEscolar" id="cmbCalendarioEscolar" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCalendarioEscolar) = trim(rs("cod_calendario_ue")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_calendario_ue")& " " & strSelecionado &">" & rs("nome_calendario") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>