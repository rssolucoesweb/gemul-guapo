<%	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_TIPO_AVALIACAO_AGRUPAMENTO"
'	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoAvaliacaoAgrupamento" id="cmbTipoAvaliacaoAgrupamento" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAvaliacaoAgrupamento) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>