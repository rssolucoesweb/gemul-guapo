<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 12/06/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Tipo Falta Colaborador
-->
<%	
	sql = "SELECT CODIGO, DESCRICAO "
	sql = sql & " FROM SRH_TIPOFALTA"
	sql = sql & " where 1=1"    
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoFalta" id="cmbTipoFalta" style="width:150pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoFalta) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>