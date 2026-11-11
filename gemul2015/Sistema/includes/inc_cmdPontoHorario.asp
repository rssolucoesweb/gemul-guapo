<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Convênios - Modulação - Folha de Pagamento
-->
<%	

	sql = " SELECT Codigo, Hora, Minuto, Segundo, Tipo "
	sql = sql & " FROM SRH_PONTOHORARIO "
	sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and Situacao = 'A' "
	sql = sql & " Order By Hora, Minuto, Segundo, Tipo "
	RS.OPEN SQL, CNN
%>
<select name="cmbPontoHorario" id="cmbPontoHorario" style="width:100pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodHorario) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Hora") & ":" & rs("Minuto") & ":" & rs("Segundo") & " - " & rs("Tipo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>