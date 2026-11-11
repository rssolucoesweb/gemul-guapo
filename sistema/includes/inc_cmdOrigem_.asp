<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo origem
-->
<%	
	sql = "SELECT COD_ORIGEM, DESC_ORIGEM"
	sql = sql & " FROM SCA_ORIGEM"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by DESC_ORIGEM"
	RS.OPEN SQL, CNN
%>
<select name="cmbOrigem" id="cmbOrigem" style="width:100pt" class="combo"  <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodOrigem) = trim(rs("COD_ORIGEM")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_ORIGEM")& " " & strSelecionado &">" & rs("DESC_ORIGEM") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>