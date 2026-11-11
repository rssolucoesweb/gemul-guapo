<!--
	::	MataBem
	::	Data de Criação...: 06/12/2006
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com 
	::	Motivo............: Tipo de Servicos	
-->
<%
	SQL = "SELECT Codigo, Nome "
	SQL = SQL & " FROM SCC_TipoServico "
	
	if strFiltroTipoServico = "S" then
		SQL = SQL & " 	where codigo in (" & intCodTipoServico & ")" 
	end if
	SQL = SQL & " Order by Codigo"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoServico<%=i%>" id="cmbTipoServico<%=i%>" style="width:150pt" class="Combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodServico) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>