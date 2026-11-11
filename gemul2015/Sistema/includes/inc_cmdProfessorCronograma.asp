<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->
<%	

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if session("CodCategoriaExcessoes") <> "" then
		if session("CodCategoriaExcessoes") = "1" then
		   strVerificaCategoria	= "Professor"
			' Consulta a Categoria	
			sql = "select codigo "
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
			rs.open sql, cnn
			if rs.EOF = false then	
				intCodColaboradorProfessor 	= rs("codigo")
				intCodProfessor 	      	= rs("codigo")
			else
				strVerificaCategoria = ""
			end if
			rs.close
		else
		   strVerificaCategoria	= ""
		end if 
	else	 
		' Consulta a Categoria	
		sql = "select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " and CodCategoria = 1 "'professor
		sql = sql & " and Situacao = 'A'" 'Ativo
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
	if Session("CodColaboradorContrato") <> "" and Session("CodColaboradorContrato") <> "0" then
		intCodColaboradorProfessor 	= Session("CodColaboradorContrato")
		intCodProfessor 	      	= Session("CodColaboradorContrato")
	end if	

	sql = "SELECT DISTINCT C.codigo, C.Nome, codFuncional "
	sql = sql & " FROM SRH_COLABORADOR C"
	'sql = sql & " INNER JOIN SEG_USUARIOS_EMPRESA UE ON UE.CODIGO_SEG_USUARIOS_SISTEMA = C.CODIGO_SEG_USUARIOS_SISTEMA "
	if strCompartilharDados = "S" then 
		SQL = SQL & " WHERE CodLotacao in (select cod_empresa from SEG_EMPRESA where Cod_grupo = " & Session("CodGrupo") & ")"
	else	
		SQL = SQL & " WHERE cod_empresa in (select cod_empresa from SEG_EMPRESA where Cod_grupo = " & Session("CodGrupo") & ")"
	end if	
	sql = sql & " and C.Situacao = 'A'" 'Ativo
	if strVerificaCategoria = "Professor"  then
		SQL = SQL & " AND C.Codigo = " & trim(intCodProfessor) & ""
	else	
		SQL = SQL & " AND (C.CodCategoria = 1 or C.CodCategoria = 8)"'professor
	end if
	sql = sql & " Order by Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessor" id="cmbProfessor" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">...Indefinido...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("Codigo")) then
				strSelecionado = " selected"
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