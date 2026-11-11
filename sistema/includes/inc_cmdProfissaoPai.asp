<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo profissão
-->
<%	
	sql = "SELECT COD_PROFISSAO, DESC_PROFISSAO"
	sql = sql & " FROM SCA_PROFISSAO"
	sql = sql & " Order by DESC_PROFISSAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbProfissaoPai" id="cmbProfissaoPai" style="width:250pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfissaoPai) = trim(rs("COD_PROFISSAO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_PROFISSAO")& " " & strSelecionado &">"&  rs("DESC_PROFISSAO") &"</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>