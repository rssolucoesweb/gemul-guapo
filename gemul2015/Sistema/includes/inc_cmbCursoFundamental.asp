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
	IF intCodEmpresaGrupo = "" THEN intCodEmpresaGrupo = Session("CodEmpresa")

	sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
	sql = sql & " FROM SCA_CURSO"
	SQL = SQL & " WHERE descricao LIKE '%ENSINO FUNDAMENTAL%' and cod_empresa=" & intCodEmpresaGrupo
 	SQL = SQL & " and Situacao = 'A' "
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCurso" id="cmbCurso" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCurso) = trim(rs("Cod_curso")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_curso")& " " & strSelecionado &">" & rs("Sigla") & "-" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>