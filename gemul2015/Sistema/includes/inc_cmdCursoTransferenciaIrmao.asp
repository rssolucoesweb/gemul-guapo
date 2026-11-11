<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

%>
<select name="cmbCursoIrmao<%=i%>" id="cmbCursoIrmao<%=i%>" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
	<option <%if replace(trim(strCursoAlunoIrmao)," ","_") = "EDUCAÇÃO_INFANTIL" then response.write "selected"%> value="EDUCAÇÃO_INFANTIL">EDUCAÇÃO INFANTIL</option>
	<option <%if replace(trim(strCursoAlunoIrmao)," ","_") = "ANOS_INICIAIS_FUNDAMENTAL" then response.write "selected"%> value="ANOS_INICIAIS_FUNDAMENTAL">ANOS INICIAIS FUNDAMENTAL</option>
	<option <%if replace(trim(strCursoAlunoIrmao)," ","_") = "ANOS_FINAIS_FUNDAMENTAL" then response.write "selected"%> value="ANOS_FINAIS_FUNDAMENTAL">ANOS FINAIS FUNDAMENTAL</option>
</select>



	<!--option <%'if replace(trim(strCursoAlunoIrmao)," ","_") = "EDUCAÇÃO_INFANTIL" 			then response.write "selected"%> value="EDUCAÇÃO_INFANTIL">EDUCAÇÃO INFANTIL</option-->
	<!--option <%'if replace(trim(strCursoAlunoIrmao)," ","_") = "ENSINO_FUNDAMENTAL" 			then response.write "selected"%> value="ENSINO_FUNDAMENTAL">ENSINO FUNDAMENTAL</option-->
	<!--option <%'if replace(trim(strCursoAlunoIrmao)," ","_") = "ENSINO_FUNDAMENTAL_2ª_FASE" 	then response.write "selected"%> value="ENSINO_FUNDAMENTAL_2ª_FASE">ENSINO FUNDAMENTAL 2ª FASE</option-->
