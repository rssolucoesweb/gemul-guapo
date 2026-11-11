<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta Ficha Descritiva
-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%

	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodFichaDescritivaPergunta = "" then intCodFichaDescritivaPergunta = "0"

	sql = "SELECT Codigo, Descricao "
	sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA"
	sql = sql & " Where cod_ficha_descritiva = " & intCodFichaDescritiva
	sql = sql & " Order by Descricao"
	rs.open sql, cnn
%>
<select name="cmbFichaDescritivaPergunta" id="cmbFichaDescritivaPergunta" style="width:380pt" class="combo"  <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPergunta) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>