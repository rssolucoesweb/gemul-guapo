<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo situacao aluno
-->
<%	
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT COD_SITUACAOALUNO, DESC_SITUACAOALUNO"
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND STATUS = 'A' "
	sql = sql & " AND DESC_SITUACAOALUNO in ('PRÉ-MATRÍCULA')"
	sql = sql & " Order by DESC_SITUACAOALUNO"
	
	rs.open sql, cnn
%>
<select name="cmbSituacaoAluno" id="cmbSituacaoAluno" style="width:100pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodSituacaoAluno) = trim(rs("COD_SITUACAOALUNO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_SITUACAOALUNO")& " " & strSelecionado &">" & rs("DESC_SITUACAOALUNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>