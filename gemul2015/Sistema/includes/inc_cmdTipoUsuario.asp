<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Tipo Usuario
-->
<%	
	sql = "SELECT Cod_TipoUsuario, Nome, QtdeDias, Valor"
	sql = sql & " FROM SCB_TIPOUSUARIO"
	sql = sql & " Order by Cod_TipoUsuario"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoUsuario" id="cmbTipoUsuario" style="width:150pt" class="combo" onChange="mostraTipoUsuario()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoUsuario) = trim(rs("Cod_TipoUsuario")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_TipoUsuario")& " " & strSelecionado &">" & rs("Nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>