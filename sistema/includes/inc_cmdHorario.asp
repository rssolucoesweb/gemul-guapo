<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo horario
-->
<%	
	if strExecutarSubmitHorario = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT CODIGO, horario, SEQUENCIA_AULAS"
	sql = sql & " FROM SCA_horario"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " and ANOletivo = " & strAnoLetivo		
	sql = sql & " and semestre in (" & intSemestre & ")"
	sql = sql & " Order by ANOletivo, semestre, horario"
	RS.OPEN SQL, CNN
%>
<select name="cmbHorario" id="cmbHorario" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodHorario) = trim(rs("codigo")) then
				strSelecionado          = " selected"
			    intCodSequenciaAulas	= Trim(rs("SEQUENCIA_AULAS"))
				intCodSequenciaAula     = Trim(rs("SEQUENCIA_AULAS"))
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("horario") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>