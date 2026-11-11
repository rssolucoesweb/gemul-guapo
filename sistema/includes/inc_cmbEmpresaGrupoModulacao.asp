<%	
if intCodFuncao="0" or intCodFuncao="" then
		%>
		<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" style="width:250pt" class="form-control" >
		<option value="0">Selecione...</option>
		</select>
        <%
else
		if strEmpresaGrupo_submit = "" then
			strFuncao = ""
		else
			strFuncao = "onchange='submit()'"
		end if
		

		'sql = " SELECT "
		'sql = sql & "     e.CODIGO AS cod_empresa,"
		'sql = sql & "     e.RAZAOSOCIAL AS unidade,"
		'sql = sql & "     ISNULL(v.total_vagas, 0) AS total_vagas,"
		'sql = sql & "     ISNULL(m.total_modulado, 0) AS total_modulado,"
		'sql = sql & "     ISNULL(v.total_vagas, 0) - ISNULL(m.total_modulado, 0) AS vagas_disponiveis"
		'sql = sql & " FROM "
		'sql = sql & "     SEG_EMPRESA e"
		'sql = sql & " LEFT JOIN ("
		'sql = sql & "     SELECT "
		'sql = sql & "         COD_EMPRESA,"
		'sql = sql & "         SUM("
		'sql = sql & "             CASE "
		'sql = sql & "                 WHEN AulasOferecidas > 0 THEN AulasOferecidas"
		'sql = sql & "                 WHEN VagasOferecidas > 0 THEN VagasOferecidas"
		'sql = sql & "                 ELSE 0"
		'sql = sql & "             END"
		'sql = sql & "         ) AS total_vagas"
		'sql = sql & "     FROM SRH_DIRETRIZES"
		'sql = sql & "     WHERE "
		'sql = sql & "         Ano_Letivo = " & strAnoLetivo 
		'sql = sql & "         AND Semestre = " & intSemestre
		'if intCodFuncao <> "0" then 
		'	sql = sql & "         AND CodFuncao = " & intCodFuncao
		'end if
		'sql = sql & "     GROUP BY COD_EMPRESA"
		'sql = sql & " ) v ON v.COD_EMPRESA = e.CODIGO"
		'sql = sql & " LEFT JOIN ("
		'sql = sql & "     SELECT "
		'sql = sql & "         COD_EMPRESA,"
		'sql = sql & "         SUM(Total_Aulas) AS total_modulado"
		'sql = sql & "     FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		'sql = sql & "     WHERE "
		'sql = sql & "         Ano_Letivo = " & strAnoLetivo 
		'sql = sql & "         AND Semestre = " & intSemestre
		'sql = sql & "         AND Status = 'A'"
		'sql = sql & "         AND ISNULL(Cod_Modulacao_Substituicao, 0) = 0"
		'if intCodFuncao <> "0" then 
		'	sql = sql & "         AND Cod_Funcao = " & intCodFuncao
		'end if
		'sql = sql & "         AND Total_Aulas IS NOT NULL"
		'sql = sql & "     GROUP BY COD_EMPRESA"
		'sql = sql & " ) m ON m.COD_EMPRESA = e.CODIGO"
		'sql = sql & " WHERE "
		'sql = sql & "     e.COD_GRUPO = " & session("codGrupo")
		'if Session("CodPerfilAcessoRH") <> "72" then
		'	sql = sql & " AND e.codigo = " & session("CodEmpresa")
		'end if
		'sql = sql & "     AND ISNULL(v.total_vagas, 0) - ISNULL(m.total_modulado, 0) > 0"
		'
		'if session("usuarioWeb") = "SERGIO" THEN
		'	RESPONSE.WRITE SQL & "<hr>"
		'end if
		
		sql = "exec [dbo].[SP_RH_Modulacao_Unidades] " & session("codGrupo") & "," & strAnoLetivo & "," & intSemestre & "," & intCodFuncao & ",0,0,5,'T'"
		
		'if session("usuarioWeb") = "SERGIO" THEN
		'	RESPONSE.WRITE SQL & "<hr>"
		'end if
		rsAux.open sql, cnn
		%>
		<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" style="width:250pt" class="form-control" <%=strFuncao%>>
		<option value="0">Selecione...</option>
<%
		'rs1.open sql, cnn
		strEncontrou = "N"
		if rsAux.eof = false then
			while not rsAux.eof
				if trim(intCodEmpresaGrupo) = trim(rsAux("COD_EMPRESA")) then
					strSelecionado = " selected"
					strEncontrou = "S"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rsAux("COD_EMPRESA")& " " & strSelecionado &">" & rsAux("unidade") & "</option> "  & vbcrlf
				rsAux.movenext
			wend
		END IF
		rsAux.close
%>
        <%
		if intCodEmpresaGrupo <> "0" and intCodEmpresaGrupo<>"" and strEncontrou = "N" and strEmpresaGrupo<>"" then
			%>
			<option selected="selected" value="<%=intCodEmpresaGrupo%>"><%=strEmpresaGrupo%></option>
			<%
		end if	
		%>
</select>
<%end if%> 