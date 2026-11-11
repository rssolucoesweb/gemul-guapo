<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/06/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo situacao promocao
-->
<%	
	if strExecutarSubmitSituacaoPromocaoSemCriterio = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if


	sql = "SELECT CODIGO, DESCRICAO, DESC_ABREVIADA"
	sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
	SQL = SQL & " WHERE criterio='SC' "
	sql = sql & " Order by DESCRICAO"
	RSAux.OPEN SQL, CNN
%>
<select name="cmbSituacaoPromocao" id="cmbSituacaoPromocao" style="width:120pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(strSituacaoPromocao) = trim(RSAux("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux("CODIGO") & " " & strSelecionado &">" & RSAux("descricao") & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>