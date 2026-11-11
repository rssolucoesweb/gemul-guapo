<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/03/2013
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo cmbAgrupamento
-->
<%	
	sql = "select * from [dbo].[MAT_periodo_curso]"
	RS.OPEN SQL, CNN
%>
<select name="cmbAgrupamento" id="cmbAgrupamento" style="width:150pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			response.write "<option value=" & rs("codigo")& " >" & rs("Curso") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>