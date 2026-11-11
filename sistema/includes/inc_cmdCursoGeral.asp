<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT DISTINCT Descricao"
	sql = sql & " FROM SCA_CURSO"
	sql = sql & " where situacao = 'A' and cod_empresa in (" & Session("CodTodasEmpresaGrupo") & ")"			
	sql = sql & " Order by Descricao"

	RS.OPEN SQL, CNN
%>
<select name="cmbCurso" id="cmbCurso" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCurso) = trim(REPLACE(rs("Descricao")," ","_")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & REPLACE(rs("Descricao")," ","_") & " " & strSelecionado &">" &rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>