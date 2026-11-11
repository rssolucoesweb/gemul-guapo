<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
-->
<%
		if strEmpresaGrupo_submit = "" then
			strFuncao = ""
		else
			strFuncao = "onchange='submit()'"
		end if
		' Gera o saldo de vagas nas unidades
		sql = " SET ANSI_NULLS OFF  "	
		sql = sql & " SET NOCOUNT ON " 
		sql = sql & " SELECT "
		sql = sql & " EMP0.CODIGO, "
		sql = sql & " ((select " 
		sql = sql & " isnull(sum(TMF1.Total_Vaga_Funcao),'0') "  	
		sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO TMF1 "  
		sql = sql & " INNER JOIN SCA_TURMA T1 ON T1.Cod_Turma = TMF1.Cod_Turma AND T1.Situacao = 'A' "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC1 ON GC1.Cod_GradeCurricular = T1.Cod_GradeCurricular AND GC1.Situacao = 'A'  " 
		sql = sql & " INNER JOIN SCA_PERIODO P1 ON P1.Cod_Periodo = GC1.Cod_Periodo "  
		sql = sql & " INNER JOIN SCA_CURSO C1 ON C1.Cod_curso = P1.Cod_Curso " 
		sql = sql & " INNER JOIN SCA_TURNO TU1 ON TU1.Cod_Turno = T1.Cod_Turno " 
		sql = sql & " INNER JOIN SEG_EMPRESA EMP1 ON EMP1.CODIGO = T1.Cod_Empresa " 
		sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC1 ON FC1.Cod_Funcao = TMF1.Cod_Funcao "  
		sql = sql & " WHERE T1.COD_EMPRESA = EMP0.CODIGO "
		sql = sql & " AND T1.AnoLetivo = " & strAnoLetivo   
		sql = sql & " and TMF1.Total_Vaga_Funcao is not null " 
		sql = sql & " AND T1.Cod_Semestre = " & intSemestre
		if trim(strTipoModulacao) <> "" then   
			sql = sql & " AND FC1.Tipo_Funcao = '" & trim(strTipoModulacao) & "'" 
		end if
		if intCodFuncao <> "0" then 
			sql = sql & " AND FC1.Cod_Funcao = " & intCodFuncao 
		end if
		sql = sql & " ) "
		sql = sql & " + "
		sql = sql & " (SELECT "  
		sql = sql & " isnull(sum(isnull(GCD2.Total_Vaga_Funcao,'0')),'0') "   
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD2 "   
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC2 ON GC2.Cod_GradeCurricular = GCD2.Cod_GradeCurricular AND GC2.Situacao = 'A' "    
		sql = sql & " INNER JOIN SCA_TURMA T2 ON GC2.Cod_GradeCurricular = T2.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P2 ON P2.Cod_Periodo = GC2.Cod_Periodo "  
		sql = sql & " INNER JOIN SCA_CURSO C2 ON C2.Cod_curso = P2.Cod_Curso "  
		sql = sql & " INNER JOIN SCA_TURNO TU2 ON TU2.Cod_Turno = T2.Cod_Turno "  
		sql = sql & " INNER JOIN SEG_EMPRESA EMP2 ON EMP2.CODIGO = T2.Cod_Empresa "  
		sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC2 ON FC2.Cod_Funcao = GCD2.Cod_Funcao "   
		sql = sql & " WHERE ISNULL(GCD2.COD_FUNCAO,'0')<>'0' "  
		sql = sql & " and GCD2.Total_Vaga_Funcao is not null " 
		sql = sql & " AND T2.COD_EMPRESA = EMP0.CODIGO "
		sql = sql & " AND T2.AnoLetivo = " & strAnoLetivo
		sql = sql & " AND T2.Cod_Semestre = " & intSemestre
		if trim(strTipoModulacao) <> "" then   
			sql = sql & " AND FC2.Tipo_Funcao = '" & trim(strTipoModulacao) & "'" 
		end if 
		if intCodFuncao <> "0" then 
			sql = sql & " AND FC2.Cod_Funcao = " & intCodFuncao
		end if 
		sql = sql & " ) "
		sql = sql & " -  "
		sql = sql & " (select isnull(SUM(MD3.Total_Aulas),'0') "  
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD3 "  
		sql = sql & " INNER JOIN SRH_TURNO TRH3 ON TRH3.Cod_Turno = MD3.Cod_Turno "  
		'sql = sql & " INNER JOIN SCA_TURNO TAC3 ON SUBSTRING(TAC3.Desc_Turno,1,3) = SUBSTRING(TRH3.Desc_Turno,1,3) AND MD3.Cod_empresa = TAC3.Cod_Empresa "  
		sql = sql & " WHERE MD3.Cod_Empresa = EMP0.CODIGO " 
		sql = sql & " and MD3.Total_Aulas is not null "
		sql = sql & " and MD3.ano_letivo = " & strAnoLetivo
		sql = sql & " and MD3.semestre = " & intSemestre
		sql = sql & " and MD3.status = 'A' "
		sql = sql & " and isnull(Cod_Substituicao,'0') = 0 " 
		sql = sql & " AND MD3.Cod_Funcao = " & intCodFuncao 
		sql = sql & " )) as VagasDisponiveis "
		sql = sql & " INTO #TEMP "
		sql = sql & " FROM SEG_EMPRESA EMP0 "
		sql = sql & " WHERE COD_GRUPO = " & Session("CodGrupo")
		
		SQL = SQL & " select distinct T.Cod_Empresa, E.RAZAOSOCIAL, GR.codigo AS CodGrupo "
		SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO TMF " 
		SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' " 
		SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
		SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.Cod_Empresa " 
		SQL = SQL & " INNER JOIN #TEMP TMP ON TMP.CODIGO = E.CODIGO AND VagasDisponiveis > 0 " 
		SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
		SQL = SQL & " WHERE FC.Cod_grupo = " & Session("CodGrupo")
		if session("NivelPermissao") = "A" then
		else
			sql = sql & " and T.Cod_Empresa = " & session("codEmpresa")
		end if
		if trim(strTipoModulacao) <> "" then 
			sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
		end if
		if intCodFuncao <> "0" then 
			sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
		end if
		SQL = SQL & " UNION " 
		SQL = SQL & " select distinct GC.Cod_Empresa, E.RAZAOSOCIAL, GR.codigo AS CodGrupo "
		SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A' " 
		SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCD.Cod_Funcao " 
		SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = GC.Cod_Empresa " 
		SQL = SQL & " INNER JOIN #TEMP TMP ON TMP.CODIGO = E.CODIGO AND VagasDisponiveis > 0 " 
		SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
		SQL = SQL & " WHERE ISNULL(GCD.COD_FUNCAO,'0')<>'0' " 
		SQL = SQL & " AND FC.Cod_grupo = " & Session("CodGrupo")
		if session("NivelPermissao") = "A" then
		else
			sql = sql & " and E.CODIGO = " & session("codEmpresa")
		end if
		if trim(strTipoModulacao) <> "" then 
			sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
		end if
		if intCodFuncao <> "0" then 
			sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
		end if
		SQL = SQL & " ORDER BY E.RAZAOSOCIAL "
'response.write sql
		Set rsAux = cnn.Execute(sql)

		%>
		<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" style="width:350pt" class="form-control" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%	
		'rs1.open sql, cnn

		if rsAux.eof = false then
			while not rsAux.eof
				if trim(intCodEmpresaGrupo) = trim(rsAux("COD_EMPRESA")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				if ucase(Session("UsuarioWeb")) = "USUARIO.TESTE" then
					response.write "<option value=" & rsAux("COD_EMPRESA")& " " & strSelecionado &">" & session("EmpresaWeb") & "</option> "  & vbcrlf
				else
					response.write "<option value=" & rsAux("COD_EMPRESA")& " " & strSelecionado &">" & rsAux("RAZAOSOCIAL") & "</option> "  & vbcrlf
				end if
				rsAux.movenext
			wend
		END IF
		rsAux.close
%>
</select>