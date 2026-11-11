<!--
	::	SIGE
	::	Data de Criação...: 17/08/2004
	::	Desenvolvedores...: Aislan Santos Manzi
	::	Objetivo Pagina...: Selecionar as disciplinas e incluí-las em um combobox
	::	Data Atualizacao..:
	::	Motivo Atualizacao:
-->
<%
if strReloadDisciplinaOutras = "N" then 'Verifica se é para dar o reload na página
	strOnChangeDisciplinaOutras = ""
else
	strOnChangeDisciplinaOutras = "onChange='return reload()'"
end if

SQL = "SELECT  Cod_Disciplina, Desc_Disciplina"
SQL = SQL & " FROM         SCA_DISCIPLINAOUTRASINSTITUICOES "
SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
SQL = SQL & " UNION "
SQL = SQL & " SELECT  Cod_Disciplina, Desc_Disciplina"
SQL = SQL & " FROM         SCA_DISCIPLINA "
SQL = SQL & " ORDER BY 2 "
RS.OPEN SQL, CNN
%>
<select name="cmbDisciplinaOutras" id="cmbDisciplinaOutras" class="combo"  style="width:250pt" <%=strOnChangeDisciplinaOutras%>>
	<option value="0">Selecione...</option>
    <option <%if intCodDisciplinaOutras = "-1" then response.Write("selected")%> value="-1">->> Inserir Nova Disciplina</option>
<%
IF RS.EOF = FALSE THEN
    while not rs.eof
		if cstr(intCodDisciplinaOutras) = cstr(rs("Cod_Disciplina")) then
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


