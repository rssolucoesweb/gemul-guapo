<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina da grade
-->
<%	

	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = " select distinct d.Cod_Disciplina, d.Desc_Disciplina as disciplina"
	sql = sql & " from SRH_DIRETRIZES dd"
	sql = sql & " inner join SCA_DISCIPLINA d on d.Cod_Disciplina = dd.Cod_Disciplina "
	sql = sql & " where 1=1 "
	sql = sql & " and dd.ano_letivo = " & strAnoLetivo
	sql = sql & " and dd.Semestre = " & intSemestre
	sql = sql & " and dd.codFuncao = " & intCodFuncao
	sql = sql & " and dd.cod_turno = " & intCodTurnoColaborador	
	sql = sql & " order by 2"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbDisciplina" id="cmbDisciplina" style="width:150pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("COD_Disciplina")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Disciplina")& " " & strSelecionado &">" & rs("Disciplina") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>