<%	
if intCodTurnoColaborador="0" or intCodTurnoColaborador="" then
		%>
		<select name="cmbCursoCombo" id="cmbCursoCombo" style="width:250pt" class="combo">
			<option value="0">Selecione...</option>
		</select>
        <%
else
	if strExecutarSubmitCurso = "" then
		strSubmitCurso = ""
	else
		strSubmitCurso = "onchange='submit()'"
	end if
	
	SQL = " select distinct C.Cod_curso, C.Descricao as CURSO "
	SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO TMF " 
	SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' "
	SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = TMF.cod_TurnoFuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
	SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
	SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.Cod_Empresa " 
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao = 'A' "
	SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
	SQL = SQL & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso " 
	SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
	SQL = SQL & " WHERE TRH.Cod_grupo = " & Session("CodGrupo")
	if trim(strTipoModulacao) <> "" then 
		sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
	end if
	if intCodFuncao <> "0" then 
		sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
	end if
	if intCodEmpresaGrupo <> "0" then 
		sql = sql & " AND T.Cod_Empresa = " & intCodEmpresaGrupo 
	end if
	if intCodTurnoColaborador <> "0" then 
		sql = sql & " AND TRH.Cod_Turno  = " & intCodTurnoColaborador 
	end if
	SQL = SQL & " UNION " 
	SQL = SQL & " select distinct C.Cod_curso, C.Descricao as CURSO "
	SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A'  "
	SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular AND T.Situacao = 'A' "
	SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = GCDT.Cod_Turnofuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
	SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao " 
	SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
	SQL = SQL & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso " 
	SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = GC.Cod_Empresa " 
	SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
	SQL = SQL & " WHERE ISNULL(GCDT.COD_FUNCAO,'0')<>'0' " 
	SQL = SQL & " AND FC.Cod_grupo = " & Session("CodGrupo") 
	if trim(strTipoModulacao) <> "" then 
		sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
	end if
	if intCodFuncao <> "0" then 
		sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
	end if
	if intCodEmpresaGrupo <> "0" then 
		sql = sql & " AND T.Cod_Empresa = " & intCodEmpresaGrupo 
	end if
	if intCodTurnoColaborador <> "0" then 
		sql = sql & " AND TRH.Cod_Turno  = " & intCodTurnoColaborador 
	end if
	SQL = SQL & " ORDER BY C.Descricao "
'response.Write(sql)
	RS.OPEN SQL, CNN,3,1
%>
<select name="cmbCursoCombo" id="cmbCursoCombo" style="width:250pt" class="combo"  <%=strSubmitCurso%>>
	<option value="0">Selecione...</option>
<%	strEncontrou = "N"
	IF RS.EOF = FALSE THEN
		qtdeRegistro = RS.recordCount
		while not rs.eof
			if trim(intCodCursoCombo) = trim(rs("Cod_Curso")) then
				strSelecionado = " selected"
				strEncontrou = "S"
			else
				strSelecionado = ""
			end if
			if qtdeRegistro = "1" then
				intCodCursoCombo = rs("Cod_Curso")
				strSelecionado = " selected"
				strEncontrou = "S"
			end if
			response.write "<option value=" & rs("Cod_Curso")& " " & strSelecionado &">" & rs("curso") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
<%
if trim(intCodCursoCombo) <> "0" and trim(intCodCursoCombo)<>"" and strEncontrou = "N" then
	%>
	<option selected="selected" value="<%=intCodCursoCombo%>"><%=strNomeCurso%></option>
	<%
end if	
%>
</select>
<%
end if
%>
