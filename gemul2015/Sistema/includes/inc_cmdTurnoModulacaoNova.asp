<%	
if intCodEmpresaGrupo="0" or intCodEmpresaGrupo="" then
		%>
		<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="combo">
			<option value="0">Selecione...</option>
		</select>
        <%
else
		strSiglaTurno = ""
		strTurno = ""
		if strExecutarSubmitTurno = "" then
			strFuncao = ""
		else
			strFuncao = "onchange='submit()'"
		end if
	
		SQL = " select distinct TRH.COD_TURNO, TRH.Desc_Turno "
		SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO TMF " 
		SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' "
		SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = TMF.cod_TurnoFuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
		SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
		SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.Cod_Empresa " 
		SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
		SQL = SQL & " WHERE FC.Cod_grupo = " & Session("CodGrupo")
		sql = sql & " AND T.AnoLetivo = " & strAnoLetivo
		sql = sql & " AND T.Cod_Semestre = " & strSemestre
		if session("NivelPermissao") = "A" then
		else
			if Situacao_Disciplinar = "I" and PorPeriodo<>"S" then 
				sql = sql & " AND TRH.COD_TURNO = " & cod_turno
			end if
		end if
		if trim(strTipoModulacao) <> "" then 
			sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
		end if
		if intCodFuncao <> "0" then 
			sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
		end if
		if intCodEmpresaGrupo <> "0" then 
			sql = sql & " AND T.Cod_Empresa = " & intCodEmpresaGrupo 
		end if
		SQL = SQL & " UNION "
		SQL = SQL & " select distinct TRH.Cod_Turno, TRH.Desc_Turno "
		SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A'  "
		SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular AND T.Situacao = 'A' "
		SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = GCDT.Cod_Turnofuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
		SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao " 
		SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = GC.Cod_Empresa " 
		SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
		SQL = SQL & " WHERE ISNULL(GCDT.COD_FUNCAO,'0')<>'0' " 
		SQL = SQL & " AND FC.Cod_grupo = " & Session("CodGrupo") 
		sql = sql & " AND T.AnoLetivo = " & strAnoLetivo
		sql = sql & " AND T.Cod_Semestre = " & strSemestre

		if session("NivelPermissao") = "A" then
		else
			if Situacao_Disciplinar = "I" and PorPeriodo<>"S" then 
				sql = sql & " AND TRH.COD_TURNO = " & cod_turno
			end if
		end if
		if trim(strTipoModulacao) <> "" then 
			sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
		end if
		if intCodFuncao <> "0" then 
			sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
		end if
		if intCodEmpresaGrupo <> "0" then 
			sql = sql & " AND GC.Cod_Empresa = " & intCodEmpresaGrupo 
		end if
		SQL = SQL & " ORDER BY TRH.Desc_Turno " 
		'response.Write(sql)
		RS.OPEN SQL, CNN,3,1
		%>
		<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="combo" <%=strFuncao%>>
			<option value="0">Selecione...</option>
			<%
			IF RS.EOF = FALSE THEN
				qtdeRegistro = RS.recordCount
				while not rs.eof
					if trim(intCodTurnoColaborador) = trim(rs("COD_TURNO")) then
						strSelecionado = " selected"
						strSiglaTurno =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
						strTurno =  UCASE(trim(rs("DESC_TURNO")))
					else
						strSelecionado = ""
					end if
					if qtdeRegistro = "1" then
						intCodTurnoColaborador = rs("COD_TURNO")
						strSelecionado = " selected"
						strSiglaTurno =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
						strTurno =  UCASE(trim(rs("DESC_TURNO")))
					end if						
					
					response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
					rs.movenext
				wend
			END IF
			rs.close
			%>
		</select>
<%end if%>        