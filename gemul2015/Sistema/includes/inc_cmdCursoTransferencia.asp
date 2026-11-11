<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

%>
<select name="cmbCurso" id="cmbCurso" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
	<option <%if replace(trim(strCursoAluno)," ","_") = "EDUCAÇÃO_INFANTIL" then response.write "selected"%> value="EDUCAÇÃO_INFANTIL">EDUCAÇÃO INFANTIL</option>
	<option <%if replace(trim(strCursoAluno)," ","_") = "ENSINO_FUNDAMENTAL" then response.write "selected"%> value="ENSINO_FUNDAMENTAL">ENSINO FUNDAMENTAL</option>
	<option <%if replace(trim(strCursoAluno)," ","_") = "ENSINO_FUNDAMENTAL_2ª_FASE" then response.write "selected"%> value="ENSINO_FUNDAMENTAL_2ª_FASE">ENSINO FUNDAMENTAL 2ª FASE</option>
</select> <span class="texto1"><strong><i>curso que o aluno ir&aacute; cursar</i></strong></span>