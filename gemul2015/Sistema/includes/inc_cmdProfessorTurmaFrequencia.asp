<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->
<%	
	if intSemestre = "" then intSemestre 			= session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo 			= session("strAnoLetivo")
	if intCodTurma = "" then intCodTurma = "0"

	if strExecutarSubmitProfessorTurma = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT DISTINCT C.codigo, C.Nome"
	sql = sql & " FROM SRH_COLABORADOR C"
	sql = sql & " INNER JOIN SEG_USUARIOS_EMPRESA UE ON UE.CODIGO_SEG_USUARIOS_SISTEMA = C.CODIGO_SEG_USUARIOS_SISTEMA "
	SQL = SQL & " WHERE UE.COD_EMPRESA =" & Session("CodEmpresa")
	if strVerificaCategoria = "Professor" then
	   SQL = SQL & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA = '" & trim(session("UsuarioWeb")) & "'"
	end if
	SQL = SQL & " AND (C.CodCategoria = 1 or C.CodCategoria = 8)"'professor
	sql = sql & " Order by Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessorTurma" id="cmbProfessorTurma" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>