<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso Segunda Opcao
-->
<%
	if strExecutarSubmitCursoSegundaOpcao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
	sql = sql & " FROM SCA_CURSO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
 	SQL = SQL & " and Situacao = 'A' "
	sql = sql & " and processo_seletivo = 'S'"
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbCursoSegundaOpcao" id="cmbCursoSegundaOpcao" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCursoSegundaOpcao) = trim(rs("Cod_curso")) then
				strSelecionado = " selected"
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