<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo horario
-->
<%	
	if strExecutarSubmitHorarioProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT HA.CODIGO, T.NOMETURMA, D.DESC_DISCIPLINA, HA.DIASEMANA, HA.SEQUENCIA, HA.TEMPO, H.HORARIO"
	sql = sql & " FROM SCA_HORARIO_AULA HA "
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.codigo = HA.Cod_Colaborador "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO "
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO AND H.ANOLETIVO = HA.ANOLETIVO AND H.SEMESTRE = HA.SEMESTRE"
	sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo		
	sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ") "
	sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor
	sql = sql & " Order by T.NOMETURMA, D.DESC_DISCIPLINA, HA.DIASEMANA, HA.SEQUENCIA, HA.TEMPO, H.HORARIO"
	RS.OPEN SQL, CNN
%>
<select name="cmbHorarioProfessor" id="cmbHorarioProfessor" style="width:600pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodHorarioAula) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			
			strDescHorarioCompleto = rs("NOMETURMA") & " | " & rs("DESC_DISCIPLINA") & " | " & ucase(WeekDayName(rs("DIASEMANA"))) & " | "
			strDescHorarioCompleto = strDescHorarioCompleto & rs("SEQUENCIA") & "ª Aula | " & rs("TEMPO") & "º tempo | " 
			strDescHorarioCompleto = strDescHorarioCompleto & rs("HORARIO") 			

			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & strDescHorarioCompleto & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>