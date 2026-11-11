<%
	if intTipoAvaliacao = "" then intTipoAvaliacao = 0
%>
	<select name="cmbTipoConsultaAvaliacao" id="cmbTipoConsultaAvaliacao" style="width:100pt" class="combo">
	 
	 <option value="0">Selecione...</option>
	 
	 <%if intTipoAvaliacao = "1" then %>
			<option value="1" <%if intTipoConsulta = "1" then response.Write("selected") %>>1 - Aluno</option>
	 <%end if %>
	
	 <%if intTipoAvaliacao = "2" then %>
			<option value="1" <%if intTipoConsulta = "1" then response.Write("selected") %>>1 - Aluno</option>
			<option value="2" <%if intTipoConsulta = "2" then response.Write("selected") %>>2 - Colaborador</option>
	 <%end if %>
 
</select>
