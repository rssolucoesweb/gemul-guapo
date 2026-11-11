<%
	if strExecutarSubmitSituacaoTransporte = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbSituacaoEncaminhamento" id="cmbSituacaoEncaminhamento" class="form-control" style="width: 200px" <%=strFuncao%>>
<%if retiraTodas="" then%>
  <option value="0">Todas...</option>
<%end if%>
  <%if mostraS = "" then%> 
  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Análise</option>
  <option value="S" <%if strSituacao = "S" then response.Write("selected") %>>Solicitação</option>
  <option value="R" <%if strSituacao = "R" then response.Write("selected") %>>Cadastro de Reserva</option>
  <%end if%> 
  <option value="D" <%if strSituacao = "D" then response.Write("selected") %>>Deferido</option>
  <%if mostraE = "" then%> 
  <option value="E" <%if strSituacao = "E" then response.Write("selected") %>>Encaminhado ao DDA</option>
  <%end if%>   
  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Indeferido</option>
</select>
