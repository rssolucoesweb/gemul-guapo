<%	
	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodTurmaProfessor = "" then intCodTurmaProfessor = 0
	
	if cod_colaborador="" then
		' Consulta a Categoria	
		sql = "select distinct codigo, cpf "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
			strCpfTurmaProfessor = rs("cpf")
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	else
		' Consulta a Categoria
		sql = "select distinct codigo, cpf "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo = " & cod_colaborador
		sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaTurmaProfessor	= "Professor"
			strCpfTurmaProfessor = rs("cpf")
		else
			strVerificaTurmaProfessor = ""
		end if
		rs.close
	end if
	
	
	sql = "SELECT distinct"
	sql = sql & " HA.Cod_Colaborador as codigo,"
	sql = sql & " C.NOME"
	sql = sql & " FROM SCA_HORARIO_AULA HA"
	if 	strVerificaTurmaProfessor	= "Professor" then
		sql = sql & " inner JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador"
	else
		sql = sql & " left JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador"
	end if
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
	sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
	'if intCodTurmaProfessor<>"0" then
	'	sql = sql & " AND HA.cod_turma = " & intCodTurmaProfessor
	'end if
	if 	strVerificaTurmaProfessor = "Professor" then
		sql = sql & " and ha.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
	end if
	if 	Session("cpfColaborador") <>"" then
		sql = sql & " and ha.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & Session("cpfColaborador") &"')" 
		strVerificaTurmaProfessor = "Professor"
	end if
	sql = sql & " Order by C.NOME"
	
	'if session("usuarioWeb")="BEATRIZ.JESUS" then 
	'	response.write cod_colaborador & "<hr>"
	'	response.write Session("cpfColaborador") & "<hr>"
	'	response.write sql
	'end if
	
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessor" id="cmbProfessor" class="form-control" <%=strFuncao%> >
<%if 	strVerificaTurmaProfessor	<> "Professor" then%>
	<option value="0">Selecione...</option>
<%end if%>
<%
	mostrouDefict = "N"
	IF RS.EOF = FALSE THEN
		if 	strVerificaTurmaProfessor = "Professor" then
			intCodProfessor = trim(rs("Codigo"))
		end if
		while not rs.eof
			
			
			if trim(intCodProfessor) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			
			NOME = RS("NOME")
			
			IF ISNULL(RS("NOME")) THEN 
				NOME = "DEFICT"
			END IF
			
			if mostrouDefict = "N" then
				response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(NOME) & "</option> "  & vbcrlf
			else
				if NOME <> "DEFICT" then
					response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(NOME) & "</option> "  & vbcrlf
				end if
			end if
			IF ISNULL(RS("NOME")) THEN 
				mostrouDefict = "S"
			END IF
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>