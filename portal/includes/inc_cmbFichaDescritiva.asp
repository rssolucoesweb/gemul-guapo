<%
funcao_ficha = ""
if funcao_cmbFichaDescritiva = "" then
	funcao_ficha = " onchange='submit()' "
end if

sql = "SELECT Codigo, Descricao"
sql = sql & " FROM SCA_FICHA_DESCRITIVA"
sql = sql & " WHERE cod_grupo=" & Session("CodEmpresaGrupo_GemulEad")
sql = sql & " And Situacao = 'A' and publicar = 'S'"
sql = sql & " And Utilizacao = 'AC'" 'Somente aparecerá no acadêmico
sql = sql & " and cod_periodo = " & Session("cod_periodo_GemulEad")
sql = sql & " Order by Descricao"
rs.open sql, cnn
%>
<select class="form-control" name="cmbFichaDescritiva" id="cmbFichaDescritiva" <%=funcao_ficha%>>
	<option>Selecione...</option>
<% 	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFichaDescritiva) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>			
</select>