<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/03/2013
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo cmbAgrupamento
-->
<%	
	sql = "select distinct replace(PERIODO,' ','_') as periodo from MAT_RESERVA ORDER BY 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbAgrupamento" id="cmbAgrupamento" style="width:150pt" class="combo">
	<option value="0" >Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			selecionado = "  "
			if trim(strPeriodo) = trim(rs("PERIODO")) then
				selecionado = " selected "
			end if
			response.write "<option " & selecionado & " value=" & rs("periodo")& " >" & replace(rs("periodo"),"_"," ") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>