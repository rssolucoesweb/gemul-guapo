<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/09/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo situacao aluno
-->
<%	
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT codigo, descricao"
	sql = sql & " FROM SCA_VINCULOALUNO_CENSO"
	sql = sql & " Order by descricao"
	
	rs.open sql, cnn
%>
<select name="cmbVinculoAlunoCenso" id="cmbVinculoAlunoCenso" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intVinculoAlunoCenso) = trim(rs("codigo")) then
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