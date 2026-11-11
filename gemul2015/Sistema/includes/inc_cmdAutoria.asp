<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/10/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Autoria
-->
<%
	sql = "SELECT Cod_Autoria, Nome_Autoria"
	sql = sql & " FROM SCB_AUTORIA"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Nome_Autoria"
	RS.OPEN SQL, CNN
%>
<select name="cmbAutoria" id="cmbAutoria" style="width:250pt" class="combo" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAutoria) = trim(rs("Cod_Autoria")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Autoria")& " " & strSelecionado &">" & rs("Nome_Autoria") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>