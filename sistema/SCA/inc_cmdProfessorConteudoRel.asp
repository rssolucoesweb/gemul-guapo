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

	 
	' Consulta a Categoria	
	sql = "select codigo, CodCategoria "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	SQL = SQL & " And codLotacao = " & session("CodEmpresa")
	rs.open sql, cnn
	if rs.EOF = false then	
		if trim(rs("CodCategoria")) = 1 then 
			strVerificaCategoria 		= "Professor"
			intCodColaboradorProfessor 	= rs("codigo")
			intCodProfessor 	      	= rs("codigo")
		else
			strVerificaCategoria 		= ""
		end if
	else
		strVerificaCategoria = ""
	end if
	rs.close
	
	if intCodProfessor = "" then intCodProfessor = "0"
	
	sql = " select DISTINCT  CO.codigo, CO.Nome, codFuncional from SCA_CONTEUDO CON "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = CON.COD_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
	sql = sql & " INNER JOIN SRH_COLABORADOR CO ON CO.codigo = CON.Cod_Colaborador "
	sql = sql & " WHERE CON.Cod_Empresa = " & Session("CodEmpresa")
	if strAnoLetivo <> "" then
		sql = sql & " AND CON.AnoLetivo = " & strAnoLetivo
	end if
	sql = sql & " AND CON.Semestre = " & intSemestre
	if strVerificaCategoria = "Professor"  then
		SQL = SQL & " AND CO.Codigo = " & trim(intCodProfessor) & ""
	end if
	sql = sql & " and CON.Fechamento = 'S' "
	sql = sql & " order by CO.Nome "	
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessor" id="cmbProfessor" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
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