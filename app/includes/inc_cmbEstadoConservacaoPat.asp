<%
' ============================================================
' INC_CMBESTADOCONSERVACAOPAT.ASP
' Combo de Estado de Conservação - PAT_ESTADO_CONSERVACAO
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
	sqlCmbEstadoConserv = "SELECT codigo, descricao FROM PAT_ESTADO_CONSERVACAO WHERE situacao = 'A' ORDER BY ordem_exibicao, descricao"
	Set rsCmbEstadoConserv = Server.CreateObject("ADODB.Recordset")
	rsCmbEstadoConserv.open sqlCmbEstadoConserv, cnn
	while not rsCmbEstadoConserv.eof
		strCmbItemSelected = ""
		if CStr(rsCmbEstadoConserv("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
		%>
		<option value="<%=rsCmbEstadoConserv("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbEstadoConserv("descricao")%></option>
		<%
		rsCmbEstadoConserv.movenext
	wend
	rsCmbEstadoConserv.close
	Set rsCmbEstadoConserv = Nothing
	%>
</select>
