<%	
if strAno = "" then strAno = year(date)
sql = " select * from sca_curso"
sql = sql & " order by descricao"

RS.OPEN SQL, CNN
%><select name="cmbCurso" id="cmbCurso" class="form-control">
	<option value="0" >Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			selecionado = "  "
			if trim(intCodCurso) = trim(rs("cod_curso")) or trim(rs("descricao")) = strCurso then
				selecionado = " selected "
			end if
			response.write "<option " & selecionado & " value=" & rs("cod_curso")& " >" & trim(rs("descricao")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>