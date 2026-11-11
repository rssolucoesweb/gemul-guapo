<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo cargo
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "select left(cep,4) as subsetor, count(*) as qtde from mat_reserva where 1=1"
	if CepSetor = "749" then
		sql = sql & " and left(cep,3) = '749'"
	end if
	if CepSetor = "999" then
		sql = sql & " and left(cep,3) <> '749'"
	end if
	sql = sql & " group by left(cep,4) order by 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbCepSubsetor" id="cmbCepSubsetor" style="width:250pt" class="combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCepSubsetor) = trim(rs("subsetor")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			subsetor = rs("subsetor")
			if rs("subsetor") = "" then subsetor = "74"
			response.write "<option value=" & rs("subsetor")& " " & strSelecionado &">" & subsetor & " (Quant. reservas: " & rs("qtde") & ")</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>