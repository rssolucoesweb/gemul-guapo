<%	
if intCodEmpresaGrupo="0" or intCodEmpresaGrupo="" then
		%>
		<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="form-control">
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

		'SQL = " SELECT "
		'SQL = SQL & "     TU.Cod_Turno,"
		'SQL = SQL & "     TU.Desc_Turno,"
		'SQL = SQL & "     ISNULL(v.total_vagas, 0) AS total_vagas,"
		'SQL = SQL & "     ISNULL(m.total_modulado, 0) AS total_modulado,"
		'SQL = SQL & "     ISNULL(v.total_vagas, 0) - ISNULL(m.total_modulado, 0) AS vagas_disponiveis"
		'SQL = SQL & " FROM "
		'SQL = SQL & "     SRH_TURNO tu"
		'SQL = SQL & " LEFT JOIN ("
		'SQL = SQL & "     SELECT "
		'SQL = SQL & "         Cod_Turno,"
		'SQL = SQL & "         SUM("
		'SQL = SQL & "             CASE "
		'SQL = SQL & "                 WHEN AulasOferecidas > 0 THEN AulasOferecidas"
		'SQL = SQL & "                 WHEN VagasOferecidas > 0 THEN VagasOferecidas"
		'SQL = SQL & "                 ELSE 0"
		'SQL = SQL & "             END"
		'SQL = SQL & "         ) AS total_vagas"
		'SQL = SQL & "     FROM SRH_DIRETRIZES"
		'SQL = SQL & "     WHERE "
		'SQL = SQL & "         Ano_Letivo = " & strAnoLetivo
		'SQL = SQL & "         AND Semestre = " & strSemestre
		'SQL = SQL & "         AND CodFuncao = " & intCodFuncao 
		'SQL = SQL & " 		AND Cod_Empresa = " & intCodEmpresaGrupo
		'SQL = SQL & "     GROUP BY Cod_Turno"
		'SQL = SQL & " ) v ON v.COD_TURNO = TU.Cod_Turno"
		'SQL = SQL & " LEFT JOIN ("
		'SQL = SQL & "     SELECT "
		'SQL = SQL & "         Cod_Turno,"
		'SQL = SQL & "         SUM(Total_Aulas) AS total_modulado"
		'SQL = SQL & "     FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		'SQL = SQL & "     WHERE "
		'SQL = SQL & "         Ano_Letivo = " & strAnoLetivo
		'SQL = SQL & "         AND Semestre = " & strSemestre
		'SQL = SQL & "         AND Status = 'A'"
		'SQL = SQL & "         AND ISNULL(Cod_Modulacao_Substituicao, 0) = 0"
		'SQL = SQL & "         AND Cod_Funcao = " & intCodFuncao 
		'SQL = SQL & "         AND Total_Aulas IS NOT NULL"
		'SQL = SQL & " 		AND Cod_empresa = " & intCodEmpresaGrupo
		'SQL = SQL & "     GROUP BY Cod_Turno"
		'SQL = SQL & " ) m ON m.Cod_Turno = TU.Cod_Turno"
		'SQL = SQL & " WHERE "
		'SQL = SQL & "     ISNULL(v.total_vagas, 0) - ISNULL(m.total_modulado, 0) > 0"
		'SQL = SQL & " ORDER BY TU.Desc_Turno " 
		
		sql = "exec [dbo].[SP_RH_Modulacao_Turnos] " & session("codGrupo") & "," & strAnoLetivo & "," & intSemestre & "," & intCodFuncao & "," & intCodEmpresaGrupo & ",0,5,'T'"
		
		RS.OPEN SQL, CNN,3,1
		%>
		<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="form-control" <%=strFuncao%>>
			<option value="0">Selecione...</option>
			<%
			IF RS.EOF = FALSE THEN
				qtdeRegistro = RS.recordCount
				while not rs.eof
					if trim(intCodTurnoColaborador) = trim(rs("COD_TURNO")) then
						strSelecionado = " selected"
						strSiglaTurno =  UCASE(LEFT(trim(rs("TURNO")),1))
						strTurno =  UCASE(trim(rs("TURNO")))
					else
						strSelecionado = ""
					end if
					if qtdeRegistro = "1" then
						intCodTurnoColaborador = rs("COD_TURNO")
						strSelecionado = " selected"
						strSiglaTurno =  UCASE(LEFT(trim(rs("TURNO")),1))
						strTurno =  UCASE(trim(rs("TURNO")))
					end if						
					
					response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("TURNO") & "</option> "  & vbcrlf
					rs.movenext
				wend
			END IF
			rs.close
			%>
		</select>
<%end if%>        