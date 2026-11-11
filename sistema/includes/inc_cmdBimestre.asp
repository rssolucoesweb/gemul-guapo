<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sergio Borges
	::	Objetivo Pagina...: Consulta de Bimestre
-->
<%	if strExecutarSubmitBimestre = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SCA_BIMESTRE"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " AND 	Ano_Letivo = " & strAnoLetivo
	SQL = SQL & " AND 	semestre in (" & intSemestre & ")"
	sql = sql & " Order by descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbBimestre" id="cmbBimestre" style="width:150pt" class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodBimestre) = trim(rs("codigo")) then
				strSelecionado = " selected"
				strDescricaoBimestre = rs("DESCRICAO")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("CODIGO") & "-" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>