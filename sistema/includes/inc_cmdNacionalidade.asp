<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Disciplina 
-->
<%	

	if strExecutarSubmitNacionalidade = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
		
	end if
	
	sql = "SELECT CODIGO, NOME, NACIONALIDADE"
	sql = sql & " FROM CENSO_PAIS"
	sql = sql & " WHERE ISNULL(NACIONALIDADE,'0')<> '0'"
	sql = sql & " Order by NACIONALIDADE"
	RS.OPEN SQL, CNN
%>
<select name="cmbNacionalidade" id="cmbNacionalidade" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(ucase(strNacionalidade)) = trim(ucase(rs("NACIONALIDADE"))) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & ucase(rs("NACIONALIDADE"))& " " & strSelecionado &">" & ucase(rs("NACIONALIDADE")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>