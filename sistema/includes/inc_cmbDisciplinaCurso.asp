<!--
	::	SIGE
	::	Data de Criação...: 17/08/2004
	::	Desenvolvedores...: Aislan Santos Manzi
	::	Objetivo Pagina...: Selecionar as disciplinas e incluí-las em um combobox
	::	Data Atualizacao..:
	::	Motivo Atualizacao:
-->
<%
if strReloadDisciplinaQuadro = "N" then 'Verifica se é para dar o reload na página
	strOnChangeDisciplinaQuadro = ""
else
	strOnChangeDisciplinaQuadro = "onChange='return reload()'"
end if

if intCodCurso = "" then intCodCurso = "0"

SQL = "SELECT  distinct   SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
SQL = SQL & " FROM         SCA_TURMA "
SQL = SQL & " INNER JOIN   SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
SQL = SQL & " INNER JOIN   SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
SQL = SQL & " INNER JOIN   SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo  "
SQL = SQL & " INNER JOIN   SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina "
SQL = SQL & " WHERE SCA_PERIODO.COD_CURSO = " & intCodCurso
RS.OPEN SQL, CNN
%>
<select name="cmbDisciplinaCurso" id="cmbDisciplinaCurso" class="form-control"  style="width:180pt" <%=strDesabilitaDisciplinaQuadro%> <%=" " & strOnChangeDisciplinaQuadro%>>
	<option value="0">Selecione...</option>
<%
strCodGradeCurricularDisciplina = ""
IF RS.EOF = FALSE THEN
    while not rs.eof
		if cstr(intCodDisciplinaCurso) = cstr(rs("Cod_Disciplina")) then
			strSelecionado = "selected"
			strCodGradeCurricularDisciplina = RS("Cod_GradeCurricularDisciplina")
			
		else
			strSelecionado = ""
		end if
		response.write "<option value=" & rs("Cod_Disciplina") & " " & strSelecionado & ">" & rs("Desc_Disciplina") & "</option>" & vbcrlf
		rs.movenext
	wend
END IF

rs.close
%>
</select>
<input type="hidden" value="<%=strCodGradeCurricularDisciplina%>" name="txtCodGradeCurricularDisciplina" />
