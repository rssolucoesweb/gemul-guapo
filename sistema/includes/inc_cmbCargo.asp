<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%	
	sql = "SELECT cod_Cargo, desc_Cargo"
	sql = sql & " FROM SRH_CargoCOLABORADOR"
	sql = sql & " Order by desc_Cargo"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbCargo" id="cmbCargo" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCargo) = trim(rs("cod_Cargo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_Cargo")& " " & strSelecionado &">" & rs("desc_Cargo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>