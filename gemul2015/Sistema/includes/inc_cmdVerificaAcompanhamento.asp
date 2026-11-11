<%	
   	strAcompanhamento  = Trim(Request("cmbAcompanhamento"))

   	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
   	if strAnoLetivo = "" then strAnoLetivo = "0"
   	if intSemestre = "" then intSemestre = "0"

	' Checando choque de disciplina
	strExisteAcompanhamento = ""
	sql = "select codigo from SCA_HORARIO_AULA"
	sql = sql & " WHERE	COD_EMPRESA		= " & Session("CodEmpresa")	
	sql = sql & " AND	ANOLETIVO		= " & strAnoLetivo
	sql = sql & " AND	SEMESTRE		= " & intSemestre
	sql = sql & " AND	COD_COLABORADOR	= " & intCodColaboradorProfessor
	sql = sql & " and   (Tipo_Disciplina = 'DE' or Tipo_Disciplina = 'AD') "
	rs1.open sql, cnn
	if not rs1.eof then
	   strExisteAcompanhamento = "ok"
	end if
	rs1.close	
    if strExisteAcompanhamento = "ok" then
		%>
		<select name="cmbAcompanhamento" id="cmbAcompanhamento" style="width:100pt" class="combo" onchange='submit()'>
		  <option value="0">Selecione...</option>
		  <option value="CR" <%if strAcompanhamento = "CR" then response.Write("selected") %>>Curricular</option>
		  <option value="DE" <%if strAcompanhamento = "DE" then response.Write("selected") %>>Dependência</option>
		  <option value="AD" <%if strAcompanhamento = "AD" then response.Write("selected") %>>Adaptação</option>
		</select>
		<%
	else
	   %>
       <input name="cmbAcompanhamento" value="CR" type="hidden">
       <%
	     response.Write("Curricular")
	end if %>	