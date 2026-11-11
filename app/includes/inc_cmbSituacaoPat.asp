<%
' ============================================================
' INC_CMBSITUACAOPAT.ASP
' Combo de Situação do Patrimônio - PAT_SITUACAO
' (NÃO confundir com includes/inc_cmbSituacao.asp, que é o combo
' genérico Ativo/Inativo usado nos cadastros auxiliares)
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
	sqlCmbSituacaoPat = "SELECT codigo, descricao FROM PAT_SITUACAO WHERE situacao = 'A' ORDER BY descricao"
	Set rsCmbSituacaoPat = Server.CreateObject("ADODB.Recordset")
	rsCmbSituacaoPat.open sqlCmbSituacaoPat, cnn
	while not rsCmbSituacaoPat.eof
		strCmbItemSelected = ""
		if CStr(rsCmbSituacaoPat("codigo")) = CStr(strCmbSelecionado) then strCmbItemSelected = "selected"
		%>
		<option value="<%=rsCmbSituacaoPat("codigo")%>" <%=strCmbItemSelected%>><%=rsCmbSituacaoPat("descricao")%></option>
		<%
		rsCmbSituacaoPat.movenext
	wend
	rsCmbSituacaoPat.close
	Set rsCmbSituacaoPat = Nothing
	%>
</select>
