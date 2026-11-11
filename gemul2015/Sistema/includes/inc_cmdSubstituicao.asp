<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Professor Substituicao
-->
<%	
	if strSubmitSubstituicao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	strDataAP = formataDataAP(date)
	
	if Session("CodGrupo") = "" then Session("CodGrupo") = 0
		
	sql = " Select distinct C.codigo, C.nome, C.codigo_SEG_USUARIOS_SISTEMA, C.codFuncional, CS.Situacao"
	sql = sql & " From SRH_COLABORADOR C"
	sql = sql & " inner join SRH_COLABORADOR_SUBSTITUTO CS on C.codigo = CS.CodColaboradorSubstituido "
	sql = sql & " Where CS.Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " And C.codigo in( " & trim(Session("CodColaboradorSubstituicao")) & ")"
	'sql = sql & " AND CONVERT(VARCHAR, CS.DataFinal, 103) >= '" & strDataAP & "'"
	sql = sql & " AND CS.Situacao = 'A'"
	RS.OPEN SQL, CNN
%>
<select name="cmbSubstituicao" id="cmbSubstituicao" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>

	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof

			if trim(intCodSubstituicao) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("codFuncional")) & " - " & ucase(rs("nome")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>