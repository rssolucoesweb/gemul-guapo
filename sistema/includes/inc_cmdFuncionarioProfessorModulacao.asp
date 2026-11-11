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

	if strOptTipoColaborador = "1" then
		sql = "select DISTINCT codigo, nome"
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codLotacao = " & Session("CodEmpresa")
		sql = sql & " and CodCategoria in (1,8)"
		sql = sql & " and situacao = 'A'"
		sql = sql & " UNION"
		sql = sql & " select DISTINCT C.codigo, C.nome"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR"
		sql = sql & " where M.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and C.CodCategoria in (1,8)"
		sql = sql & " and C.situacao = 'A'"
		sql = sql & " ORDER BY 2"
	elseif strOptTipoColaborador = "0" then
		sql = "select DISTINCT codigo, nome"
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codLotacao = " & Session("CodEmpresa")
		sql = sql & " and CodCategoria in (2,8)"
		sql = sql & " and situacao = 'A'"
		sql = sql & " UNION"
		sql = sql & " select DISTINCT C.codigo, C.nome"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR"
		sql = sql & " where M.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and C.CodCategoria in (2,8)"
		sql = sql & " and C.situacao = 'A'"
		sql = sql & " ORDER BY 2"
	end if
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