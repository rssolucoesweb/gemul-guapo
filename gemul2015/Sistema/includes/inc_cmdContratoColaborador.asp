<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Contrato Colaboradro
-->
<%	
	if strSubmitContratoColaborador = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = " select codigo, codFuncional, nome "
	sql = sql & " From SRH_COLABORADOR "
	sql = sql & " Where SRH_COLABORADOR.cpf = '" & Session("CFP") &  "'"
	RS.OPEN SQL, CNN
%>
<select name="cmbContratoColaborador" id="cmbContratoColaborador" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intContratoColaborador) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("codFuncional")) & "-" & ucase(rs("nome")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>