<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/03/2010
	::	Desenvolvedores...: sergio - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de periodo 
-->
<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT DISTINCT SCA_PERIODO.Descricao "
	sql = sql & " FROM SCA_PERIODO "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_PERIODO.COD_CURSO  "
	sql = sql & " where SCA_CURSO.Descricao = '" & replace(intCodCurso,"_"," ") & "'"
	sql = sql & " Order by SCA_PERIODO.Descricao"
	Rs.OPEN SQL, CNN
	%>
	<select name="cmbPeriodo" id="cmbPeriodo" style="width:250pt" class="combo" <%=strFuncao%> >
		<option value="0">Selecione...</option>
		<%
		IF Rs.EOF = FALSE THEN
			while not Rs.eof
				if trim(intCodPeriodo) = trim(REPLACE(rs("Descricao")," ","_")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & REPLACE(Rs("Descricao")," ","_") & " " & strSelecionado &">" & Rs("Descricao") & "</option> "  & vbcrlf
				Rs.movenext
			wend
		END IF
		Rs.close
		%>
</select>