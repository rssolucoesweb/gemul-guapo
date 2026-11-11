<%
	if submitTipoAndamento = "S" then
		submitTipoAndamento = "onchange='submit()'"
	end if

	SQL = "SELECT Codigo, DESCRICAO  "
	SQL = SQL & " FROM SOS_TIPO_ANDAMENTO"
	SQL = SQL & " WHERE Cod_grupo = " & Session("CodGrupo")
	'if strPerfilMaster = "S" then
	'	SQL = SQL & " and 1=1"
	'end if
	'if strPerfilGestorArea = "S" then
	'	SQL = SQL & " and codigo in (7,6,5,3)"
	'end if
	'if strPerfilExecutor = "S" then
	'	SQL = SQL & " and codigo in (7,6,5)"
	'end if
	'if strPerfilExecutor = "N" and strPerfilGestorArea = "N" and strPerfilMaster = "N" then
	'	SQL = SQL & " and 1=2"
	'end if
	'SQL = SQL & " and codigo in (3)"
	SQL = SQL & " Order by codigo"
	RS.OPEN SQL, CNN
	if intCodTipoAndamento = "" then intCodTipoAndamento = "3"
%>
<select name="cmbTipoAndamento" id="cmbTipoAndamento" style="width:180pt" class="form-control" <%=submitTipoAndamento%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoAndamento) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			%>
			<option value="<%=rs("codigo")%>" <%=strSelecionado%>><%=rs("Descricao")%></option>
			<%
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
