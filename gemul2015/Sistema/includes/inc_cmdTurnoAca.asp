<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Turno
-->
<%	strSiglaTurno = ""
	if strExecutarSubmitTurnoAca = "" then
		strFuncaoAca = ""
	else
		strFuncaoAca = "onchange='submit()'"
	end if
	SQL = "SELECT COD_TURNO, DESC_TURNO"
	SQL = SQL & " FROM SCA_TURNO"
	SQL = SQL & " Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurnoAca" id="cmbTurnoAca" style="width:150pt" class="combo" <%=strFuncaoAca%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoAca) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				strSiglaTurno =  UCASE(LEFT(trim(rs("DESC_TURNO")),1))
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