<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Sergio - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de vestibular
-->
<%	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if strExecutarSubmitVestibular = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = "SELECT CODIGO, DESCRICAO, VALOR_VESTIBULAR, DATAVENCIMENTO"
	sql = sql & " FROM SCA_VESTIBULAR"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	'sql = sql & " And ano_letivo = " & strAnoLetivo
	'sql = sql & " And semestre in ( " & intSemestre & ")"
	sql = sql & " And situacao ='A' "
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbVestibular" id="cmbVestibular" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%	intValorVestibular = ""
	strDataVencimento = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodVestibular) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strDescricao =  trim(rs("descricao"))
				intValorVestibular = trim(rs("VALOR_VESTIBULAR"))
				strDataVencimento = trim(rs("DATAVENCIMENTO"))
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>