<!--
	::	Data de Criação...: 19/02/2014
	::	Desenvolvedores...: Roberto Barbosa Silva
	::	Objetivo Pagina...: Consulta de Turno RH
-->
<%	strSiglaTurno = ""
	if strExecutarSubmitTurno = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE Cod_Grupo=" & Session("CodGrupo")
	sql = sql & " Order by Cod_Turno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurno" id="cmbTurno" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurno) = trim(rs("COD_TURNO")) then
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