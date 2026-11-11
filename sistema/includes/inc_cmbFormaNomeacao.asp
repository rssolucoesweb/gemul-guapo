<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%	
	sql = "SELECT cod_formanomeacao, desc_formanomeacao"
	sql = sql & " FROM SRH_FORMANOMEACAOCOLABORADOR"
	sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by desc_formanomeacao"
	RS.OPEN SQL, CNN
%>
<select name="cmbFormaNomeacao" id="cmbFormaNomeacao" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodformanomeacao) = trim(rs("cod_formanomeacao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_formanomeacao")& " " & strSelecionado &">" & rs("desc_formanomeacao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>