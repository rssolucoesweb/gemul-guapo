<%
' ============================================================
' INC_CMBCATEGORIAPAT.ASP
' Combo de Categoria de Bem - PAT_CATEGORIA
' Variáveis esperadas antes do include:
'   strCmbId          - id do <select>            (obrigatório)
'   strCmbName         - name do <select>          (obrigatório)
'   strCmbSelecionado   - código atualmente selecionado (pode ser "")
'   strCmbAtributos      - atributos extras (opcional)
' ============================================================
%>
<select id="<%=strCmbId%>" name="<%=strCmbName%>" class="form-control" <%=strCmbAtributos%>>
	<option value="">Selecione...</option>
	<%
	sqlCmbCategoria = "SELECT codigo, descricao FROM PAT_CATEGORIA WHERE situacao = 'A' ORDER BY descricao"
	Set rsCmbCategoria = Server.CreateObject("ADODB.Recordset")
	rsCmbCategoria.open sqlCmbCategoria, cnn
	while not rsCmbCategoria.eof
		strCmbItemSelected = ""
		if CStr(rsCmbCategoria("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
		%>
		<option value="<%=rsCmbCategoria("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbCategoria("descricao")%></option>
		<%
		rsCmbCategoria.movenext
	wend
	rsCmbCategoria.close
	Set rsCmbCategoria = Nothing
	%>
</select>
