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
		'if ucase(session("usuarioweb")) = "MARIAHELENA.SANTOS" then 
		'			response.write SQL
		'end if


	'sql = "SELECT DISTINCT C.codigo, C.Nome, codFuncional "
	'sql = sql & " FROM SRH_COLABORADOR C"
	'SQL = SQL & " WHERE 1=1 "
	'sql = sql & " and C.Situacao = 'A'" 'Ativo
	'if strVerificaCategoria = "Professor"  then
	'	SQL = SQL & " AND C.Codigo = " & trim(intCodProfessor) & ""
	'else
	'	SQL = SQL & " and c.codLotacao =" & Session("CodEmpresa")	
	'	SQL = SQL & " AND (C.CodCategoria = 1 or C.CodCategoria = 8)"'professor
	'end if
	'sql = sql & " Order by Nome"
	
	
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessor" id="cmbProfessor" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("Codigo")) then
				strSelecionado = " selected"
				CodCategoriaCombo = rs("CodCategoria")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) &" - "& rs("codFuncional") &"</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
<%
if CodCategoriaCombo = "1" or CodCategoriaCombo = "8" then
	verificaCategoriaCombo = "PROFESSOR"
else
	verificaCategoriaCombo = "FUNCIONARIO"
end if



%>