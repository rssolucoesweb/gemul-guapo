<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Turno
-->
<%	 
	if strExecutarSubmitTurnoFaltas = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SCA_TURNO"
	SQL = SQL & " WHERE Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoFaltas" id="cmbTurnoFaltas" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoFaltas) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>