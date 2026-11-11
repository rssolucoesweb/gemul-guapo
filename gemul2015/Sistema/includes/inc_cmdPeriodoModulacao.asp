<%	
if intCodTurnoColaborador="0" or intCodTurnoColaborador="" then
		%>
		<select name="cmbPeriodo" id="cmbPeriodo" class="combo"  style="width:250pt">
			<option value="0">Selecione...</option>
		</select>
        <%
else	
	if strExecutarSubmitPeriodo = "" then
		strPeriodo = ""
	else
		strPeriodo = "onchange='submit()'"
	end if

	SQL = " select distinct P.Cod_Periodo, P.Descricao, E.RAZAOSOCIAL, TRH.Desc_Turno "
	SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO TMF " 
	SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' "
	SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = TMF.cod_TurnoFuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
	SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
	SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.Cod_Empresa " 
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao = 'A' "
	SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
	SQL = SQL & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso " 
	SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
	SQL = SQL & " WHERE FC.Cod_grupo = " & Session("CodGrupo")
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
	if intCodCursoCombo <> "0" and intCodCursoCombo <> "" then  
		sql = sql & " AND C.Cod_curso = " & intCodCursoCombo 
	end if
	SQL = SQL & " UNION " 
	SQL = SQL & " select distinct P.Cod_Periodo, P.Descricao, E.RAZAOSOCIAL, TRH.Desc_Turno "
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
	if intCodCursoCombo <> "0" AND intCodCursoCombo <> "" then 
		sql = sql & " AND C.Cod_curso = " & intCodCursoCombo 
	end if
	SQL = SQL & " ORDER BY P.Descricao "
	'response.write sql
	RS.OPEN SQL, CNN,3,1
%>
<select name="cmbPeriodo" id="cmbPeriodo" class="combo" <%=strPeriodo%>  style="width:250pt">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		intCodCurso = ""
		qtdeRegistro = RS.recordCount		
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			if qtdeRegistro = "1" then
				intCodPeriodo = rs("Cod_Periodo")
				strSelecionado = " selected"
				strEncontrou = "S"
			end if			
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("Descricao") & " " & rs("Desc_Turno") & " - " & rs("RAZAOSOCIAL") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
<%
end if
%>