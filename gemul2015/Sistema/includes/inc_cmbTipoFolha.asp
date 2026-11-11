<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Sergio borges
	::	Objetivo Pagina...: Consulta tipofolha 
-->
<%
	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SRH_TIPOFOLHA"
	SQL = SQL & " WHERE cod_grupo=" & Session("Codgrupo") & " and situacao = 'A'"
	sql = sql & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoFolha" id="cmbTipoFolha" style="width:130pt" class="combo">
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoFolha) = trim(rs("codigo")) then
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