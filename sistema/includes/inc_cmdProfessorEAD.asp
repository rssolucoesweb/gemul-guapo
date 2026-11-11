<%	
		if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if


		'if ucase(session("usuarioweb")) = "MARIAHELENA.SANTOS" then 
		'			response.write "codCategoria: " & Session("Seg_CodCategoria")
		'			response.write "Seg_CodColaborador: " & Session("Seg_CodColaborador")
		'end if

	if Session("Seg_CodCategoria") <> "" then
		if Session("Seg_CodCategoria") = "1" then
		   	strVerificaCategoria		= "Professor"
			intCodColaboradorProfessor 	= Session("Seg_CodColaborador")
			intCodProfessor 	      	= Session("Seg_CodColaborador")
		else
		   strVerificaCategoria	= ""
		end if 
	else	 
		' Consulta a Categoria	
		sql = "select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " and (CodCategoria = 1 or CodCategoria = 8)"'professor  
		sql = sql & " and Situacao = 'A'" 'Ativo
		'if ucase(session("usuarioweb")) = "MARIAHELENA.SANTOS" then 
		'			response.write SQL
		'end if
		rs.open sql, cnn
		if rs.EOF = false then	
			strVerificaCategoria 		= "Professor"
			intCodColaboradorProfessor 	= rs("codigo")
			intCodProfessor 	      	= rs("codigo")
		else
			strVerificaCategoria = ""
		end if
		rs.close
	end if	

	sql = "select DISTINCT C.codigo, C.Nome, codFuncional, C.CodCategoria "
	sql = sql & " from SEG_USUARIOS_EMPRESA UE "
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo_SEG_USUARIOS_SISTEMA = UE.CODIGO_SEG_USUARIOS_SISTEMA "
	SQL = SQL & " WHERE 1=1 "
	sql = sql & " and C.Situacao = 'A'" 'Ativo
	if strVerificaCategoria = "Professor"  then
		SQL = SQL & " AND C.Codigo = " & trim(intCodProfessor) & ""
	else
		SQL = SQL & " and  UE.COD_EMPRESA = " & Session("CodEmpresa")	
		SQL = SQL & " AND (C.CodCategoria = 1 or C.CodCategoria = 8)"'professor
	end if
	sql = sql & " Order by C.Nome"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessor" id="cmbProfessor" class="form-control"  style="width: 100%" <%=strFuncao%> >
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