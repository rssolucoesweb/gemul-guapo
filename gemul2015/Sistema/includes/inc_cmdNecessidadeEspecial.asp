<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo nec especial
-->
<%	
	sql = "SELECT Cod_NecEspecial, DESC_NecEspecial"
	sql = sql & " FROM SCA_NECESSIDADEESPECIAL where Cod_NecEspecial<>12 "
	sql = sql & " Order by DESC_NecEspecial"
	RS.OPEN SQL, CNN
%>
<select name="cmbNecessidadeEspecial" id="cmbNecessidadeEspecial" style="width:150pt" class="combo">
	<option value="12">Nenhuma</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodNecessidadeEspecial) = trim(rs("Cod_NecEspecial")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_NecEspecial")& " " & strSelecionado &">"&  rs("DESC_NecEspecial") &"</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>