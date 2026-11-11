<%
' ============================================================
' INC_CMBTIPOBEMPAT.ASP
' Combo de Tipo de Bem - PAT_TIPO_BEM (filtrado por categoria)
' Variáveis esperadas antes do include:
'   strCmbId          - id do <select>            (obrigatório)
'   strCmbName         - name do <select>          (obrigatório)
'   strCmbSelecionado   - código atualmente selecionado (pode ser "")
'   strCmbFiltroCategoria - cod_categoria para filtrar (se vazio, combo fica só com "Selecione...")
'   strCmbAtributos      - atributos extras (opcional)
' ============================================================
%>
<select id="<%=strCmbId%>" name="<%=strCmbName%>" class="form-control" <%=strCmbAtributos%>>
	<option value="">Selecione...</option>
	<%
	if strCmbFiltroCategoria <> "" then
		sqlCmbTipoBem = "SELECT codigo, descricao FROM PAT_TIPO_BEM WHERE situacao = 'A' AND cod_categoria = " & strCmbFiltroCategoria & " ORDER BY descricao"
		Set rsCmbTipoBem = Server.CreateObject("ADODB.Recordset")
		rsCmbTipoBem.open sqlCmbTipoBem, cnn
		while not rsCmbTipoBem.eof
			strCmbItemSelected = ""
			if CStr(rsCmbTipoBem("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
			%>
			<option value="<%=rsCmbTipoBem("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbTipoBem("descricao")%></option>
			<%
			rsCmbTipoBem.movenext
		wend
		rsCmbTipoBem.close
		Set rsCmbTipoBem = Nothing
	end if
	%>
</select>
