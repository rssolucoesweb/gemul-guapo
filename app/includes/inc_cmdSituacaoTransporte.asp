<select name="cmbSituacao" id="cmbSituacao" class="form-control" style="width: 200px" onchange="submit()">
<%if retiraTodas="" then%>
  <option value="0">Todas...</option>
<%end if%>
  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Análise</option>
  <option value="R" <%if strSituacao = "R" then response.Write("selected") %>>Cadastro de Reserva</option>
  <option value="S" <%if strSituacao = "S" then response.Write("selected") %>>Solicitação</option>
  <option value="D" <%if strSituacao = "D" then response.Write("selected") %>>Deferido</option>
  <option value="E" <%if strSituacao = "E" then response.Write("selected") %>>Encaminhado ao DDA</option>
  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Indeferido</option>
</select>
