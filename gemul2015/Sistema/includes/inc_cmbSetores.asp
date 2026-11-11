<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo setores
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "SELECT codigo, descricao"
	sql = sql & " FROM MAT_setores "
	sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbSetores" id="cmbSetores" style="width:200pt" class="combo" >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodSetores) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>