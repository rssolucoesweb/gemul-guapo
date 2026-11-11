<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de grupo
-->
<%	

	if strExecutarSubmitEmpresaChamado = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	SQL = " select SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.codigo AS CodGrupo,"
	SQL = SQL & " SEG_GRUPO.DESCRICAO AS GRUPO "
	SQL = SQL & " FROM SEG_USUARIOS_EMPRESA"
	SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	SQL = SQL & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
	SQL = SQL & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
	SQL = SQL & " AND SEG_GRUPO.codigo = " & Session("CodGrupo")
	SQL = SQL & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RSAux.OPEN SQL, CNN
%>
<select name="cmdEmpresaChamado" id="cmdEmpresaChamado" style="width:330pt" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodEmpresaChamado) = trim(RSAux("COD_EMPRESA")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			strGrupo = "SEM GRUPO"
			if not isnull(RSAux("GRUPO")) then strGrupo = RSAux("GRUPO")
			
			response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & strGrupo & " - " & RSAux("RAZAOSOCIAL") & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>