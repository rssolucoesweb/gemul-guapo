<%	

	if strExcessaoPeriodoModulacao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT codigo, Tipo_Lancamento, Data_Lancamento, Data_Referencia, descricao, ano_letivo, semestre"
	sql = sql & " FROM SRH_EXCESSOES_PERIODOMODULACAO"
	sql = sql & " where Cod_Empresa = " & session("codEmpresa")	
	sql = sql & " and Ano_letivo = " & strAnoLetivo		
	sql = sql & " order by Data_Referencia"
	rs.open sql, cnn
%>
<select name="txtDataLancamento" id="txtDataLancamento" style="width:150pt" class="form-control" <%=strFuncao%>>
<option value="">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strDataLancamento) = trim(formatadataAP(rs("Data_Referencia")))then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & trim(formatadataAP(rs("Data_Referencia")))& " " & strSelecionado &">" & trim(formatadataAP(rs("Data_Referencia"))) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>