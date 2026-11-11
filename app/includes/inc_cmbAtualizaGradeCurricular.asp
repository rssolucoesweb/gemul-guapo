<%
    if strAtualizaGrade_submit = "S" then
		strFuncaoAtualizaGrade = "onchange='submit()'"
	else
		strFuncaoAtualizaGrade = ""
	end if
%>
<select name="cmbAtualizaGrade" class="form-control" id="cmbAtualizaGrade" <%=strFuncaoAtualizaGrade%>>
  <option value="0">Selecione...</option>
  <option value="A" <%if strAtualizaGrade = "A" then response.Write("selected") %>>Atualização</option>
  <option value="D" <%if strAtualizaGrade = "D" then response.Write("selected") %>>Exclusão</option>
</select>
    	
