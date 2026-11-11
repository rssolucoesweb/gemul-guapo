<%
' ============================================================
' INC_CMBTIPOLOCALPAT.ASP
' Combo de Tipo de Local - PAT_TIPO_LOCAL
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
	sqlCmbTipoLocal = "SELECT codigo, descricao FROM PAT_TIPO_LOCAL WHERE situacao = 'A' ORDER BY descricao"
	Set rsCmbTipoLocal = Server.CreateObject("ADODB.Recordset")
	rsCmbTipoLocal.open sqlCmbTipoLocal, cnn
	while not rsCmbTipoLocal.eof
		strCmbItemSelected = ""
		if CStr(rsCmbTipoLocal("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
		%>
		<option value="<%=rsCmbTipoLocal("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbTipoLocal("descricao")%></option>
		<%
		rsCmbTipoLocal.movenext
	wend
	rsCmbTipoLocal.close
	Set rsCmbTipoLocal = Nothing
	%>
</select>
