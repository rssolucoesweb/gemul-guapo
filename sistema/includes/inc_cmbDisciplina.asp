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

SQL = "SELECT  SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina"
SQL = SQL & " FROM         SCA_DISCIPLINA "
SQL = SQL & " ORDER BY SCA_DISCIPLINA.Desc_Disciplina "

RS.OPEN SQL, CNN
%>
<select name="cmbDisciplina" id="cmbDisciplina" class="combo"  style="width:180pt" <%=strOnChangeDisciplinaQuadro%>>
	<option value="0">Selecione...</option>
<%
IF RS.EOF = FALSE THEN
    while not rs.eof
		if cstr(intCodDisciplina) = cstr(rs("Cod_Disciplina")) then
			strSelecionado = "selected"
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
