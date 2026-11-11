<%	
	sql = "SELECT cod_funcao, desc_funcao"
	sql = sql & " FROM SRH_FUNCAOCOLABORADOR"
	sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by desc_funcao"
	RSAux1.OPEN SQL, CNN
%>
<select name="cmbFuncaoProcessoLicenca_<%=controleInicio%>" id="cmbFuncaoProcessoLicenca_<%=controleInicio%>" class="form-control" style="width:200px">
	<option value="0">Selecione...</option>
<%
	IF RSAux1.EOF = FALSE THEN
		while not RSAux1.eof
			if trim(intCodFuncaoProcessoLicenca) = trim(RSAux1("cod_funcao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux1("cod_funcao")& " " & strSelecionado &">" & RSAux1("desc_funcao") & "</option> "  & vbcrlf
			RSAux1.movenext
		wend
	END IF
	RSAux1.close
%>
</select>