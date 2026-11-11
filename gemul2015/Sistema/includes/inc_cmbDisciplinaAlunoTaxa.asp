<!--
	::	SIGE
	::	Data de Criação...: 17/08/2004
	::	Desenvolvedores...: Aislan Santos Manzi
	::	Objetivo Pagina...: Selecionar as disciplinas e incluí-las em um combobox
	::	Data Atualizacao..:
	::	Motivo Atualizacao:
-->
<%
if strReload = "" then 'Verifica se é para dar o reload na página
	strFuncao = ""
else
	strFuncao = "onChange='return reload()'"
end if

if intCodAluno = "" then intCodAluno = "0"

SQL = " SELECT SCA_Disciplina.Cod_Disciplina, SCA_ALUNO_DISCIPLINA.codigo, SCA_Disciplina.Desc_Disciplina"
SQL = SQL & " FROM SCA_ALUNO_DISCIPLINA INNER JOIN SCA_Disciplina " 
SQL = SQL & " ON SCA_Disciplina.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.Cod_Disciplina "
SQL = SQL & " Where SCA_ALUNO_DISCIPLINA.Cod_Aluno = " & intCodAluno
RS.OPEN SQL, CNN
%>
<select name="cmbDisciplinaAluno" id="cmbDisciplinaAluno" class="combo"  style="width:300pt" <%=strDesabilitaDisciplinaQuadro%> <%=" " & strFuncao%>>
	<option value="0">Selecione...</option>
<%
strCodGradeCurricularDisciplina = ""
IF RS.EOF = FALSE THEN
    while not rs.eof
		if cstr(intCodDisciplinaAluno) = cstr(rs("codigo")) then
			strSelecionado = "selected"
		else
			strSelecionado = ""
		end if
		response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("Desc_Disciplina") & "</option>" & vbcrlf
		rs.movenext
	wend
END IF

rs.close
%>
</select>
<input type="hidden" value="<%=strCodGradeCurricularDisciplina%>" name="txtCodGradeCurricularDisciplina" />
