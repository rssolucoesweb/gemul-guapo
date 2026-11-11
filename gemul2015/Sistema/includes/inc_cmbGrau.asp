<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grau 
-->
<%
	sql = "SELECT COD_Grau, DESC_Grau"
	sql = sql & " FROM SCA_GRAU"
	sql = sql & " Order by DESC_Grau"
	RS.OPEN SQL, CNN
%>
<select name="cmbGrau" id="cmbGrau" style="width:150pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGrau) = trim(rs("COD_Grau")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Grau")& " " & strSelecionado &">" & rs("DESC_Grau") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>