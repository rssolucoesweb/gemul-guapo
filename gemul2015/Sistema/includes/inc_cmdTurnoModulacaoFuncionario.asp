	<%	
	strSiglaTurno = ""
	strTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodFuncao = "" then intCodFuncao = "0"
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = "0"
	
	' Gera o saldo de vagas nos Turno
	sql = " SELECT distinct TU.COD_TURNO, TU.Desc_Turno " 
	sql = sql & "   FROM SRH_DIRETRIZES D " 
	sql = sql & "   INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.cod_funcao = D.CodFuncao " 
	sql = sql & "   LEFT JOIN SRH_TURNO TU ON TU.cod_Turno = D.Cod_turno " 
	sql = sql & "   LEFT JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = D.Cod_Disciplina " 
	sql = sql & "   LEFT JOIN SCA_CURSO CU ON CU.Cod_Curso = D.Cod_Curso " 
	sql = sql & "   INNER JOIN SEG_EMPRESA E ON E.CODIGO = D.Cod_Empresa " 
	sql = sql & "   LEFT JOIN SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO " 
	sql = sql & "   WHERE GR.Codigo = " & Session("CodGrupo")
	sql = sql & " 	AND D.Ano_Letivo = " & strAnoLetivo
	sql = sql & "	AND D.Semestre = " & intSemestre 
	sql = sql & " 	AND D.Cod_Empresa = " & intCodEmpresaGrupo 
	sql = sql & " 	AND D.CodFuncao = " & intCodFuncao 
	sql = sql & "   AND F.Tipo_Funcao = 'FUNCIONARIO' "  
	sql = sql & "   AND F.Modular = 'S' "  
	sql = sql & "   AND"
	sql = sql & "   	("
	sql = sql & "   		("
	sql = sql & "   		SELECT ISNULL(SUM(D1.VagasOferecidas),'0') "
	sql = sql & "   		FROM SRH_DIRETRIZES D1 "
	sql = sql & "   		INNER JOIN SEG_EMPRESA E1 ON E1.CODIGO = D1.Cod_Empresa "
	sql = sql & "   		INNER JOIN SEG_GRUPO GR1 ON GR1.CODIGO = E1.COD_GRUPO "
	sql = sql & "   		WHERE GR1.Codigo = GR.Codigo "
	sql = sql & "   		AND D1.Ano_Letivo = D.Ano_Letivo	"
	sql = sql & "   		AND D1.Semestre = D.Semestre	"
	sql = sql & "   		AND D1.Cod_empresa = D.Cod_Empresa	"
	sql = sql & "   		AND D1.CodFuncao = D.CodFuncao "
	sql = sql & "   		) "
	sql = sql & "   		- "
	sql = sql & "   		( "
	sql = sql & "   		SELECT ISNULL(SUM(M2.Total_Aulas),'0') "
	sql = sql & "   		FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M2 "
	sql = sql & "   		INNER JOIN SEG_EMPRESA E2 ON E2.CODIGO = M2.Cod_Empresa "
	sql = sql & "   		INNER JOIN SEG_GRUPO GR2 ON GR2.CODIGO = E2.COD_GRUPO "
	sql = sql & "   		WHERE GR2.Codigo = GR.Codigo"
	sql = sql & "   		AND M2.Cod_Funcao = D.CodFuncao "
	sql = sql & "   		AND M2.Ano_Letivo = D.Ano_Letivo "
	sql = sql & "   		AND M2.Semestre = D.Semestre"
	sql = sql & "   		AND M2.Cod_empresa = D.Cod_Empresa "
	sql = sql & "   		AND M2.tipoModulacao = 'FUNCIONARIO'"
	sql = sql & "   		AND M2.Status = 'A'"
	sql = sql & "   		)"
	sql = sql & "   	)>0"
	SQL = SQL & " ORDER BY TU.Desc_Turno " 

	RS.OPEN SQL, CNN
	%>
	<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%
        IF RS.EOF = FALSE THEN
            while not rs.eof
                if trim(intCodTurnoColaborador) = trim(rs("COD_TURNO")) then
                    strSelecionado = " selected"
                    strSiglaTurno =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
					strTurno =  UCASE(trim(rs("DESC_TURNO")))
                else
                    strSelecionado = ""
                end if
                response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
                rs.movenext
            wend
        END IF
        rs.close
        %>
	</select>