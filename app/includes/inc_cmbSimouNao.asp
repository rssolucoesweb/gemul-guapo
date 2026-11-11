<%
    if strSimouNao_submit = "S" then
		strFuncaoSimOuNao = "onchange='submit()'"
	else
		strFuncaoSimOuNao = ""
	end if
%>
<select <%=bloqueiaComboAlteracao%> name="cmbSimouNao" class="form-control" id="cmbSimouNao" <%=strFuncaoSimOuNao%>>
  <option value="0">Selecione...</option>
  <option value="S" <%if strSimouNao = "S" then response.Write("selected") %>>SIM</option>
  <option value="N" <%if strSimouNao = "N" then response.Write("selected") %>>NAO</option>
</select>
    	
