<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Autores
-->
<%
	sql = "SELECT Cod_Autor, Nome_Autor"
	sql = sql & " FROM SCB_AUTORES"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Nome_Autor"
	RS.OPEN SQL, CNN
%>
<select name="cmbAutor" id="cmbAutor" style="width:150pt" class="combo" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAutor) = trim(rs("Cod_Autor")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Autor")& " " & strSelecionado &">" & rs("Nome_Autor") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>