<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador 
-->
<%	
	if strExecutarSubmitColaborador = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT Codigo, Nome"
	sql = sql & " FROM SRH_COLABORADOR"
	SQL = SQL & " WHERE CodLotacao = " & intCodEmpresaGrupo
	SQL = SQL & " AND situacao = 'A'"
	sql = sql & " Order by Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbColaboradorModulacao" id="cmbColaboradorModulacao" style="width:240pt" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodColaboradorModulacao) = trim(rs("Codigo")) then
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