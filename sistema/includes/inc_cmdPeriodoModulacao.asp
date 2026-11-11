<%	
if intCodTurnoColaborador="0" or intCodTurnoColaborador="" then
		%>
		<select name="cmbPeriodo" id="cmbPeriodo" class="form-control"  style="width:250pt">
			<option value="0">Selecione...</option>
		</select>
        <%
else	
	if strExecutarSubmitPeriodo = "" then
		strPeriodo = ""
	else
		strPeriodo = "onchange='submit()'"
	end if

	SQL = " select distinct p.Cod_periodo, p.Descricao as periodo "
	SQL = SQL & " from SRH_DIRETRIZES d"
	SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = d.Cod_Periodo "
	SQL = SQL & " where d.Ano_Letivo = " & strAnoLetivo
	SQL = SQL & " and d.Semestre = " & strSemestre
	SQL = SQL & " and d.CodFuncao = " & intCodFuncao 
	SQL = SQL & " and d.Cod_Empresa = " & intCodEmpresaGrupo
	SQL = SQL & " and d.Cod_Turno = " & intCodTurnoColaborador
	if intCodCursoCombo <> "0" and intCodCursoCombo <> "" then  
		sql = sql & " AND p.Cod_curso = " & intCodCursoCombo 
	end if
	
	SQL = SQL & " ORDER BY P.Descricao "
	'response.write sql
	RS.OPEN SQL, CNN,3,1
%>
<select name="cmbPeriodo" id="cmbPeriodo" class="form-control" <%=strPeriodo%>  style="width:250pt">
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
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("periodo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
<%
end if
%>