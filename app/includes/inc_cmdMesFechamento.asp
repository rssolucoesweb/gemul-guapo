<%	
	sql = "select distinct mes from [dbo].[SCA_FECHAMENTO_MENSAL_ALUNO] where ano_letivo = " & strAnoLetivo & " order by 1"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbMes" id="cmbMes" class="form-control" >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			strMesTexto = ucase(monthName(rs("mes")))
			if trim(strMes) = trim(rs("mes")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("mes")& " " & strSelecionado &">" & strMesTexto & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>