<%	
if intCodTurnoColaborador="0" or intCodTurnoColaborador="" then
		%>
		<select name="cmbCursoCombo" id="cmbCursoCombo" style="width:250pt" class="form-control">
			<option value="0">Selecione...</option>
		</select>
        <%
else
	if strExecutarSubmitCurso = "" then
		strSubmitCurso = ""
	else
		strSubmitCurso = "onchange='submit()'"
	end if
	if intCodTurnoColaborador = "" then intCodTurnoColaborador = "0"
	if isnull(intCodTurnoColaborador) then intCodTurnoColaborador = "0"
	SQL = " select distinct c.Cod_curso, c.Descricao as curso "
	SQL = SQL & " from SRH_DIRETRIZES d"
	SQL = SQL & " inner join SCA_CURSO c on c.Cod_curso = d.Cod_Curso"
	SQL = SQL & " where d.Ano_Letivo = " & strAnoLetivo
	SQL = SQL & " and d.Semestre = " & strSemestre
	SQL = SQL & " and d.CodFuncao = " & intCodFuncao 
	SQL = SQL & " and d.Cod_Empresa = " & intCodEmpresaGrupo
	SQL = SQL & " and d.Cod_Turno = " & intCodTurnoColaborador
	SQL = SQL & " ORDER BY C.Descricao "
'response.Write(sql)
	RS.OPEN SQL, CNN,3,1
%>
<select name="cmbCursoCombo" id="cmbCursoCombo" style="width:250pt" class="form-control"  <%=strSubmitCurso%>>
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
