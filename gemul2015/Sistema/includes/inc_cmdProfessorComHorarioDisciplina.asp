<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->
<%	
	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodDisciplina = "" then intCodDisciplina = 0
	if intCodTurma = "" then intCodTurma = 0
	
	IF DISCIPLINA_ATUAL = "PLANEJAMENTO" THEN
		sql = " SELECT distinct HA.Cod_Colaborador as codProfessor, C.NOME, H.CODTURNO"
		sql = sql & " FROM SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador"
		sql = sql & " INNER JOIN SCA_TURMA T		 ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = H.CodTurno"
		
		sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")	
		sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
		sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
		sql = sql & " And HA.Cod_turma = " & intCodTurma
		sql = sql & " AND TU.Cod_Turno = " & intCodTurno
		
		sql = sql & " Order by C.NOME"
	ELSE
		sql = " SELECT distinct HA.Cod_Colaborador as codProfessor, C.NOME, H.CODTURNO"
		sql = sql & " FROM SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador"
		sql = sql & " INNER JOIN SCA_TURMA T		 ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = H.CodTurno"
		
		sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")	
		sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
		sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
		sql = sql & " And HA.Cod_turma = " & intCodTurma
		sql = sql & " AND HA.Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND TU.Cod_Turno = " & intCodTurno
		
		sql = sql & " UNION "
		sql = sql & " SELECT distinct 0 as codProfessor, 'Deficit' as NOME, H.CODTURNO"
		sql = sql & " FROM SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO"
		sql = sql & " INNER JOIN SCA_TURMA T		 ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = H.CodTurno"
		sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")	
		sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
		sql = sql & " AND HA.SEMESTRE  in (" & intSemestre & ")"
		sql = sql & " And HA.Cod_turma = " & intCodTurma
		sql = sql & " AND HA.Cod_Disciplina = " & intCodDisciplina
		sql = sql & " and ha.Cod_Colaborador = 0"
		sql = sql & " AND TU.Cod_Turno = " & intCodTurno
		sql = sql & " Order by C.NOME"
	END IF
	RS.OPEN SQL, CNN, 3, 1
%>
<select name="cmbProfessor" id="cmbProfessor" style="width:250pt" class="combo" <%=strFuncao%> >
<%
	IF RS.EOF = FALSE THEN
		IF RS.RECORDCOUNT = 1 THEN 
			intCodColaboradorProfessor = rs("codProfessor")
			intCodProfessor = rs("codProfessor")
		END IF 
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("codProfessor")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codProfessor")& " " & strSelecionado &">" & ucase(rs("nome")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
