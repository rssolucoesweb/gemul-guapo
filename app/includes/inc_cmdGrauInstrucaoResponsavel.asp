<!--#include file="inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_GRAUINSTRUCAO"
	
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbGrauInstrucaoResponsavel" id="cmbGrauInstrucaoResponsavel" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGrauInstrucaoResponsavel) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>