<%
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbTipoAvaliacaoDescritiva" id="cmbTipoAvaliacaoDescritiva" style="width:150pt" class="combo" <%=strFuncao%>>
  <option value="0">Selecione...</option>
  <option value="1" <%if intTipoAvaliacaoDescritiva = "1" then response.Write("selected") %>>1 - Descritiva e Conceitual</option>
  <option value="2" <%if intTipoAvaliacaoDescritiva = "2" then response.Write("selected") %>>2 - Descritiva</option>
</select>
