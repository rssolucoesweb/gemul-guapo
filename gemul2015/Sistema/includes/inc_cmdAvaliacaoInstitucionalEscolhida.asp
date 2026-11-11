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
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " And codigo = " & intCodAvaliacaoInstitucional
	sql = sql & " Order by codigo desc"
	RS.OPEN SQL, CNN
%>
<select name="cmbAvaliacaoInstitucional" id="cmbAvaliacaoInstitucional" style="width:400pt" class="combo"  <%=strFuncao%>>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAvaliacaoInstitucional) = trim(rs("Codigo")) then
				strSelecionado = " selected "
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