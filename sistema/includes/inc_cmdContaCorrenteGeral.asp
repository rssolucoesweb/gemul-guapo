<%
	sql = " select CODIGO, COD_BANCO, COD_AGENCIA, NUMERO, CARTEIRA from SCF_CONTA_CORRENTE"
	sql = sql & " WHERE Cod_EMPRESA = " & session("CodEmpresa")
	sql = sql & " AND Situacao = 'A'"
	sql = sql & " Order by COD_BANCO, COD_AGENCIA, NUMERO"
	RSaux.OPEN SQL, CNN
%>
<select name="cmbContaCorrente" id="cmbContaCorrente" style="width:250pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RSaux.EOF = FALSE THEN
		while not RSaux.eof
			if trim(intCodContaCorrente) = trim(RSaux("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSaux("CODIGO")& " " & strSelecionado &">" & RSaux("COD_BANCO")& " - " & RSaux("COD_AGENCIA")& " / " & RSaux("NUMERO") & "</option> "  & vbcrlf
			RSaux.movenext
		wend
	END IF
	RSaux.close
%>
</select>