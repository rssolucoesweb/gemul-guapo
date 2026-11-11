<%
	sql = "SELECT Codigo, Descricao"
	sql = sql & " FROM SCF_Plano"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Descricao"
	RSaux.OPEN SQL, CNN
%>
<select name="cmbPlanoTurma_<%=rs("Cod_Turma")%>" id="cmbPlanoTurma_<%=rs("Cod_Turma")%>" style="width:250pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RSaux.EOF = FALSE THEN
		while not RSaux.eof
			if trim(intCodPlanoTurma) = trim(RSaux("Codigo")) then
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