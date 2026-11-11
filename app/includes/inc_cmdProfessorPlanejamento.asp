<%	
	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	
	sql = " SELECT distinct HA.Cod_Colaborador as codProfessor, C.NOME, H.CODTURNO, c.codFuncional"
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
	IF intCodTurno="" THEN intCodTurno = "0"
	if intCodTurno<>"0" then 
		sql = sql & " AND TU.Cod_Turno = " & intCodTurno
	end if
	'sql = sql & " UNION "
	'sql = sql & " SELECT distinct 0 as codProfessor, 'Deficit' as NOME, H.CODTURNO"
	'sql = sql & " FROM SCA_HORARIO_AULA HA"
	'sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO"
	'sql = sql & " INNER JOIN SCA_TURMA T		 ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
	'sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	'sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
	'sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = H.CodTurno"
	'sql = sql & " INNER JOIN SRH_TURNO trh on trh.desc_turno = tU.desc_turno and trh.Cod_Grupo = " & SESSION("codGrupo")
	'sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")	
	'sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
	'sql = sql & " AND HA.SEMESTRE  in (" & intSemestre & ")"
	'sql = sql & " and ha.Cod_Colaborador = 0"
	'sql = sql & " AND TRH.Cod_Turno = " & intCodTurno
	sql = sql & " Order by C.NOME"
	'if ucase(trim(session("usuarioweb"))) = "SERGIO" then 
	'	response.write sql
	'end if
	RS.OPEN SQL, CNN, 3, 1
%>
<select name="cmbProfessor" id="cmbProfessor" class="form-control" <%=strFuncao%> >
<%
	IF RS.EOF = FALSE THEN
		IF RS.RECORDCOUNT = 1 THEN 
			intCodProfessor = rs("codProfessor")
		else
			%>
			<option value="0">Selecione...</option>
			<%
		END IF 
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("codProfessor")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codProfessor")& " " & strSelecionado &">" & ucase(rs("nome")) & " (" & rs("codFuncional")& ")</option> "  & vbcrlf
			rs.movenext
		wend
	else
	%>
			<option value="0">Selecione...</option>
	<%
	END IF
	rs.close
%>
</select>