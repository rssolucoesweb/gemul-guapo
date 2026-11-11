<%
	sql = "SELECT Codigo, Descricao"
	sql = sql & " FROM SCF_Plano"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " and isnull(status,'A') <> 'I'"
	sql = sql & " Order by Descricao"
	RSaux.OPEN SQL, CNN
%>
<select name="cmbPlano" id="cmbPlano" style="width:280pt" class="combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RSaux.EOF = FALSE THEN
		while not RSaux.eof
			if trim(intCodPlano) = trim(RSaux("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSaux("Codigo")& " " & strSelecionado &">" & RSaux("Descricao") & "</option> "  & vbcrlf
			RSaux.movenext
		wend
	END IF
	RSaux.close
%>
</select>