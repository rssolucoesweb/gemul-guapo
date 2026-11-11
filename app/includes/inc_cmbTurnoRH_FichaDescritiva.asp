<%	

	if strExecutarSubmitTurnoRH = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	
	 
	if verificaCategoriaCombo = "PROFESSOR" then
		SQL = " select COD_TURNO, DESC_TURNO from SRH_TURNO " 
		SQL = SQL & " where Cod_Grupo = " & Session("CodGrupo")
		SQL = SQL & " and SUBSTRING(Desc_Turno,1,3) in (select DISTINCT SUBSTRING(TRH.Desc_Turno,1,3) from SRH_MODULACAO_DISCIPLINAR_DOCENTE MDD "
		SQL = SQL & " 								INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = mdd.Cod_Turno and TRH.Cod_Grupo = " & Session("CodGrupo")
		SQL = SQL & " where MDD.cod_colaborador = " & intCodColaboradorProfessor
		SQL = SQL & " AND MDD.COD_EMPRESA = " & SESSION("CodEmpresa")
		SQL = SQL & " and MDD.Status = 'A' and tipoModulacao = '" & verificaCategoriaCombo & "') "
		SQL = SQL & "  ORDER BY DESC_TURNO" 
	else
		SQL = " select DISTINCT T.COD_TURNOFUNCAO AS COD_TURNO, TUR.DESC_TURNO "
		SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO T"
		SQL = SQL & " INNER JOIN SCA_TURNO TUR ON TUR.COD_TURNO = T.COD_TURNOFUNCAO "
		SQL = SQL & " where T.Cod_Turma = "& intCodTurmaProfessor
		SQL = SQL & " UNION"
		SQL = SQL & " select DISTINCT DT.COD_TURNOFUNCAO AS COD_TURNO, TUR.DESC_TURNO "
		SQL = SQL & " from SCA_TURMA T "
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA D ON D.Cod_GradeCurricular = G.Cod_GradeCurricular "
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO DT ON D.Cod_GradeCurricularDisciplina = DT.Cod_GradeCurricularDisciplina "
		SQL = SQL & " INNER JOIN SCA_TURNO TUR ON TUR.COD_TURNO = DT.COD_TURNOFUNCAO "
		SQL = SQL & "  where T.Cod_Turma = " & intCodTurmaProfessor
		SQL = SQL & "  ORDER BY TUR.DESC_TURNO" 
	end if
	'response.write sql
	
	RS.OPEN SQL, CNN, 3, 1
%>
<select name="cmbTurnoRH" id="cmbTurnoRH" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	 IF RS.EOF = FALSE THEN
		qtdeRegistro = RS.recordCount		
	
		while not rs.eof
			if trim(intCodTurnoRH) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			if qtdeRegistro = "1" then
				intCodTurnoRH = rs("cod_turno")
				strSelecionado = " selected"
			end if			
			
			response.write "<option value=" & rs("cod_turno")& " " & strSelecionado &">" & rs("desc_turno") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
	
%>
</select>