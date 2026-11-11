<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 18/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Tipo Parcelas
-->
<%	
	if strExecutarFuncao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT COD_Tipo, DESC_Tipo"
	sql = sql & " FROM SCF_TIPOPARCELA"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	SQL = SQL & " and tipo <> 'D'"
	sql = sql & " Order by COD_Tipo"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoParcela" id="cmbTipoParcela" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoParcela) = trim(rs("COD_Tipo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_Tipo")& " " & strSelecionado &">" & rs("DESC_Tipo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>