<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de grupo
-->
<%	
	if strExecutarSubmitGrupo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, DESCRICAO, SITUACAO"
	sql = sql & " FROM SEG_GRUPO"
	SQL = SQL & " WHERE SITUACAO = 'A'"
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmdGrupo" id="cmdGrupo" style="width:300pt" class="combo" <%=strFuncao%> value=  >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGrupo) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
	
%>
</select>