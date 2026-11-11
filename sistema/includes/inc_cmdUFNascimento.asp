<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 17/12/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Consulta de UF
-->
<%	
	strFuncao = ""

	sql = "SELECT CODIGO, SIGLA"
	sql = sql & " FROM SCF_UF"
	sql = sql & " Order by SIGLA"
	RS.OPEN SQL, CNN
%>
<select name="cmbUfnascimento" id="cmbUfnascimento" style="width:60pt" class="form-control" <%=strFuncao%>>
	<option value="0">...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strUfnascimento) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("SIGLA") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>