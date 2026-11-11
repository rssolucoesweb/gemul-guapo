<%
if intCodCursoCombo="0" or intCodCursoCombo="" then
	%>
	<select name="cmbDisciplina" id="cmbDisciplina" style="width:250pt" class="form-control" >
	<option value="0">Selecione...</option>
	</select>
	<%
else
	SQL = " select distinct di.Cod_Disciplina, di.Desc_Disciplina,  iif(AulasOferecidas<>0,'A','D') as tipo, isnull(gd.Ch_Semanal,0) as Ch_Semanal"
	SQL = SQL & " from SRH_DIRETRIZES d"
	SQL = SQL & " INNER JOIN SCA_DISCIPLINA di ON di.Cod_Disciplina = d.Cod_Disciplina "
	SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA gd on gd.Cod_Disciplina = d.Cod_Disciplina"
	SQL = SQL & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = gd.Cod_GradeCurricular and g.AnoReferencia = d.Ano_Letivo"
	SQL = SQL & " where d.Ano_Letivo = " & strAnoLetivo
	SQL = SQL & " and d.Semestre = " & strSemestre
	SQL = SQL & " and d.CodFuncao = " & intCodFuncao 
	SQL = SQL & " and d.Cod_Empresa = " & intCodEmpresaGrupo
	SQL = SQL & " and d.Cod_Turno = " & intCodTurnoColaborador
	if intCodCursoCombo <> "0" and intCodCursoCombo <> "" then  
		sql = sql & " AND d.Cod_curso = " & intCodCursoCombo 
	end if
	if intCodPeriodo <> "0" and intCodPeriodo <> "" then  
		sql = sql & " AND d.Cod_Periodo  = " & intCodPeriodo 
	end if
	SQL = SQL & " ORDER BY Di.Desc_Disciplina "
'	response.write sql
			if Session("UsuarioWeb") = "SERGIO" then
				'response.write sql
				'response.end
			end if

	RS.OPEN SQL, CNN,3,1
	%>
	<select name="cmbDisciplina" id="cmbDisciplina"  style="width:250pt" class="form-control" onchange="submit()">
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
				tipo = rs("tipo")
				Ch_Semanal = rs("Ch_Semanal")
			else
				strSelecionado = ""
			end if
			if qtdeRegistro = "1" then
				intCodDisciplina = rs("COD_Disciplina")
				tipo = rs("tipo")
				Ch_Semanal = rs("Ch_Semanal")
				strSelecionado = " selected"
				strEncontrou = "S"
			end if						
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("Desc_Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
	%>
	</select>
	<%
end if
%>