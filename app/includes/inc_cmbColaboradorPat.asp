<%
' ============================================================
' INC_CMBCOLABORADORPAT.ASP
' Combo de Colaborador - SRH_COLABORADOR (filtrado por codLotacao = unidade)
' Variáveis esperadas antes do include:
'   strCmbId          - id do <select>            (obrigatório)
'   strCmbName         - name do <select>          (obrigatório)
'   strCmbSelecionado   - código atualmente selecionado (pode ser "")
'   strCmbFiltroEmpresa  - codLotacao (cod_empresa) para filtrar (se vazio, combo fica só com "Selecione...")
'   strCmbAtributos      - atributos extras (opcional)
' ============================================================
%>
<select id="<%=strCmbId%>" name="<%=strCmbName%>" class="form-control" <%=strCmbAtributos%>>
	<option value="">Selecione...</option>
	<%
	if strCmbFiltroEmpresa <> "" then
		sqlCmbColaborador = "SELECT codigo, nome FROM SRH_COLABORADOR WHERE codLotacao = " & strCmbFiltroEmpresa & " ORDER BY nome"
		Set rsCmbColaborador = Server.CreateObject("ADODB.Recordset")
		rsCmbColaborador.open sqlCmbColaborador, cnn
		while not rsCmbColaborador.eof
			strCmbItemSelected = ""
			if CStr(rsCmbColaborador("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
			%>
			<option value="<%=rsCmbColaborador("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbColaborador("nome")%></option>
			<%
			rsCmbColaborador.movenext
		wend
		rsCmbColaborador.close
		Set rsCmbColaborador = Nothing
	end if
	%>
</select>
