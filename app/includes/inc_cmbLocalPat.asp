<%
' ============================================================
' INC_CMBLOCALPAT.ASP
' Combo de Local Patrimonial - PAT_LOCAL (filtrado por unidade)
' Variáveis esperadas antes do include:
'   strCmbId          - id do <select>            (obrigatório)
'   strCmbName         - name do <select>          (obrigatório)
'   strCmbSelecionado   - código atualmente selecionado (pode ser "")
'   strCmbFiltroEmpresa  - cod_empresa para filtrar (se vazio, combo fica só com "Selecione...")
'   strCmbAtributos      - atributos extras (opcional)
'   strCmbOpcaoVazia      - texto da opção em branco (opcional, default "Selecione...")
' ============================================================
	if strCmbOpcaoVazia = "" then strCmbOpcaoVazia = "Selecione..."
%>
<select id="<%=strCmbId%>" name="<%=strCmbName%>" class="form-control" <%=strCmbAtributos%>>
	<option value=""><%=strCmbOpcaoVazia%></option>
	<%
	if strCmbFiltroEmpresa <> "" then
		sqlCmbLocal = "SELECT codigo, descricao FROM PAT_LOCAL WHERE situacao = 'A' AND cod_empresa = " & strCmbFiltroEmpresa & " ORDER BY descricao"
		Set rsCmbLocal = Server.CreateObject("ADODB.Recordset")
		rsCmbLocal.open sqlCmbLocal, cnn
		while not rsCmbLocal.eof
			strCmbItemSelected = ""
			if CStr(rsCmbLocal("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
			%>
			<option value="<%=rsCmbLocal("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbLocal("descricao")%></option>
			<%
			rsCmbLocal.movenext
		wend
		rsCmbLocal.close
		Set rsCmbLocal = Nothing
	end if
	%>
</select>
