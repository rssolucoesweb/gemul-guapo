<!--
	::	MataBem
	::	Data de Criação...: 11/12/2006
	::	Desenvolvedores...: Sergio Borges
	::	Motivo............: Usuarios do Sistema
-->
<%
	sql = " Select Codigo, RazaoSocial as Descricao "
	sql = sql & " FROM SEG_empresa"
	SQL = SQL & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCliente" id="cmbCliente" style="width:250pt" class="combo" onchange="submit()">
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCliente) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("Descricao")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>