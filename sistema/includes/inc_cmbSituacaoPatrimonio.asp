
<%
    if strSituacao_submit = "S" then
		strFuncaoSimOuNao = "onchange='submit()'"
	else
		strFuncaoSimOuNao = ""
	end if
%>
<select name="cmbSituacao" class="combo" id="cmbSituacao"  style="width:70pt" <%=strFuncaoSimOuNao%>>
  <option value="0">Selecione...</option>
  <option value="1" <%if strSituacao = "1" then response.Write("selected") %>>Ativo</option>
  <option value="2" <%if strSituacao = "2" then response.Write("selected") %>>Inativo</option>
  <option value="3" <%if strSituacao = "3" then response.Write("selected") %>>Transfêrido</option>
</select>
    	
