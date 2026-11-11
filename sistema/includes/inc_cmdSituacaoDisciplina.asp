<%	
	if strExecutarSubmitSitDisciplina = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbSituacaoDisciplina" id="cmbSituacaoDisciplina" style="width:100pt" class="form-control" <%=strFuncao%> >
  <option value="0">Selecione...</option>
  <option value="CR" <%if strSituacaoDisciplina = "CR" then response.Write("selected") %>>Curricular</option>
  <option value="DE" <%if strSituacaoDisciplina = "DE" then response.Write("selected") %>>Dependência</option>
  <option value="DI" <%if strSituacaoDisciplina = "DI" then response.Write("selected") %>>Dispensa</option>
</select>
