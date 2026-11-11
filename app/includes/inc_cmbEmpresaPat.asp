<%
' ============================================================
' INC_CMBEMPRESAPAT.ASP
' Combo de Unidade (Sede/Escola) - SEG_EMPRESA
' Variáveis esperadas antes do include:
'   strCmbId          - id do <select>            (obrigatório)
'   strCmbName         - name do <select>          (obrigatório)
'   strCmbSelecionado   - código atualmente selecionado (pode ser "")
'   strCmbAtributos      - atributos extras, ex: onchange="this.form.submit()" ou "disabled" (opcional)
' ============================================================
%>
<select id="<%=strCmbId%>" name="<%=strCmbName%>" class="form-control" <%=strCmbAtributos%>>
	<option value="">Selecione...</option>
	<%
	sqlCmbEmpresa = "SELECT CODIGO, RAZAOSOCIAL FROM SEG_EMPRESA ORDER BY RAZAOSOCIAL"
	Set rsCmbEmpresa = Server.CreateObject("ADODB.Recordset")
	rsCmbEmpresa.open sqlCmbEmpresa, cnn
	while not rsCmbEmpresa.eof
		strCmbItemSelected = ""
		if CStr(rsCmbEmpresa("CODIGO")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
		%>
		<option value="<%=rsCmbEmpresa("CODIGO")%>" <%=strCmbItemSelected%>><%=rsCmbEmpresa("RAZAOSOCIAL")%></option>
		<%
		rsCmbEmpresa.movenext
	wend
	rsCmbEmpresa.close
	Set rsCmbEmpresa = Nothing
	%>
</select>
