<%	
	if strFuncaoSitPromocao = "" then
		mostraFuncaoSitPromocao = ""
	else
		mostraFuncaoSitPromocao = "onBlur='validaMedia(" & strMediaAprovacao & ")'"
	end if


	sql = "SELECT CODIGO, DESCRICAO, DESC_ABREVIADA, CRITERIO"
	sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
	sql = sql & " Order by DESCRICAO"
	RSAux.OPEN SQL, CNN
%>
<select name="cmbSituacaoPromocao" id="cmbSituacaoPromocao" class="form-control" <%=strSituacaoPromocao_Disabled%> <%=mostraFuncaoSitPromocao%>>
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(strSituacaoPromocao) = trim(RSAux("CRITERIO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux("CRITERIO") & " " & strSelecionado &">" & RSAux("descricao") & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>