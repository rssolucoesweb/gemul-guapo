<%	
if intCepSubsetor ="" or intCepSubsetor="0" then
%>
<select name="cmbBairroCepSubsetor" id="cmbBairroCepSubsetor" style="width:250pt" class="combo" >
	<option value="0">Selecione...</option>
</select>
<%
else
	sql = "select distinct bairro from mat_reserva where left(cep,4) = '"&intCepSubsetor&"' order by 1"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbBairroCepSubsetor" id="cmbBairroCepSubsetor" style="width:250pt" class="combo" >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(bairroCepSubsetor) = trim(rs("bairro")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("bairro")& " " & strSelecionado &">" & rs("bairro") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
<%end if%>