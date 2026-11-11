<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Perido 
-->
<%	
	if strExecutarSubmitPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"
	if isnull(intCodCurso) then intCodCurso = "0"
	
	sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia"
	sql = sql & " FROM SCA_PERIODO"
	sql = sql & " where cod_curso = " & intCodCurso
	sql = sql & " Order by Sequencia"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" style="width:250pt" class="combo"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
				strSelecionado = " selected"
				strSerie = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>