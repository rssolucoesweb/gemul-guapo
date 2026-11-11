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
	sql = " SELECT C.codigo, C.nome "
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " left join SRH_NIVEL N ON N.Codigo = C.Cod_nivel "
	sql = sql & " WHERE c.codlotacao = " & intCodEmpresaGrupoUsuario
	sql = sql & " AND (C.CodCategoria = 1 or C.CodCategoria = 8) "
	sql = sql & " union "
	sql = sql & " select C.codigo, C.nome "
	sql = sql & " from SRH_COLABORADOR_SUBSTITUTO CS "
	sql = sql & " inner join SRH_COLABORADOR C ON C.codigo=CS.CodColaboradorSubstituto and CS.Situacao='A' "
	sql = sql & " left join SRH_NIVEL N ON N.Codigo = C.Cod_nivel "
	'sql = sql & " WHERE cs.CodEmpresaSubstituido=" & intCodEmpresaGrupoUsuario
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