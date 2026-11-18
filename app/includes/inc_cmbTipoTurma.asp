<%
if strTipoTurma = "" or strTipoTurma = "0" then strTipoTurma = "ESC"
%>

<select name="cmbTipoTurma" id="cmbTipoTurma" class="form-control" onchange="submit()">
	<option <%if strTipoTurma = "ESC" then response.write "selected"%> value="ESC">Escolarização</option>
	<option <%if strTipoTurma = "AEE" then response.write "selected"%> value="AEE">AEE - Atendimento Especializado</option>
	<option <%if strTipoTurma = "ATC" then response.write "selected"%> value="ATC">ATC - Atividade Complementar</option>
</select>