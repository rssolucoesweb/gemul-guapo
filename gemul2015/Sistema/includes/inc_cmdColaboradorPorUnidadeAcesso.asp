<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->
<%	
	if strExecutarSubmitColaboradorFrequencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodEmpresaGrupoUsuario = "" or intCodEmpresaGrupoUsuario = "0" then intCodEmpresaGrupoUsuario = Session("CodEmpresa")

    strPermitedobras = ""
	sql = " SELECT distinct C.codigo, C.nome "
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " inner join  SEG_USUARIOS_EMPRESA ue on ue.CODIGO_SEG_USUARIOS_SISTEMA = C.CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " WHERE c.codlotacao in (select codigo from SEG_EMPRESA where cod_grupo = " & Session("CodGrupo") & ")"
	sql = sql & " and ue.cod_empresa = " & Session("CodEmpresa")
	if strOptTipoColaborador = "1" then
		SQL = SQL & " AND situacao = 'A'"
		SQL = SQL & " AND (c.CodCategoria = 1 or c.CodCategoria = 8)"'professor
	elseif strOptTipoColaborador = "0" then
		SQL = SQL & " AND situacao = 'A'"
		SQL = SQL & " AND (c.CodCategoria = 2 or c.CodCategoria = 8)"'professor
	end if
	sql = sql & " order by c.nome "
	RS.OPEN SQL, CNN
%>
<select name="cmbColaboradorFrequencia" id="cmbColaboradorFrequencia" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>