<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	

	SQL = " select distinct GCD.Cod_Disciplina, D.Desc_Disciplina, P.Descricao, TU.Desc_Turno "
	SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A' " 
	SQL = SQL & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = GCD.Cod_Disciplina "
	SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular "
	SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
	SQL = SQL & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso " 
	SQL = SQL & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno " 
	SQL = SQL & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "
	SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCD.Cod_Funcao " 
	SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = GC.Cod_Empresa " 
	SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
	SQL = SQL & " WHERE ISNULL(GCD.COD_FUNCAO,'0')<>'0' " 
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
	if intCodCursoCombo <> "0" and intCodCursoCombo <> "" then  
		sql = sql & " AND C.Cod_curso = " & intCodCursoCombo 
	end if
	if intCodPeriodo <> "0" and intCodPeriodo <> "" then  
		sql = sql & " AND P.Cod_Periodo  = " & intCodPeriodo 
	end if
	SQL = SQL & " ORDER BY D.Desc_Disciplina "
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplina" id="cmbDisciplina" class="form-control" onchange="submit()">
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("Desc_Disciplina") & " " & rs("Descricao") & " - " & rs("Desc_Turno") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>