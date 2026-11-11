<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Avaliação Institucional
-->
<%
	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT Codigo, Descricao, Ano_Letivo, Semestre"
	sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
	sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " And Publicar = 'S'"
	sql = sql & " And Situacao = 'A'"
	if intAnoLetivo <> "" and intAnoLetivo <> "0" then
	   sql = sql & " And Ano_Letivo = " & intAnoLetivo
	end if   
	if intSemestre <> "" and intSemestre <> "0" then
	   sql = sql & " And Semestre = " & intSemestre
	end if   
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbAvaliacaoInstitucional" id="cmbAvaliacaoInstitucional" style="width:500pt" class="combo"  <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAvaliacaoInstitucional) = trim(rs("Codigo")) then
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