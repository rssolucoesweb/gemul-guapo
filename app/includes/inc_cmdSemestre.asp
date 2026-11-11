<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de semestre 
-->
<%	
	if strExecutarSubmitSemestre = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
if intSemestre = "0" or intSemestre = "" then intSemestre = "3"
	' o padrão aqui e strSemestre, foi alterado para atender o cadastramento da Fanap
	sql = "SELECT CODIGO, SIGLA, DESCRICAO "
	sql = sql & " FROM SCA_SEMESTRE"
	sql = sql & " where codigo in (" & Session("strTodosSemestre") & ")"    
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbSemestre" id="cmbSemestre" class="form-control"  <%=strFuncao%>>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intSemestre) = trim(rs("Codigo")) then
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