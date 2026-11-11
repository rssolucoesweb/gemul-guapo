<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2008
	::	Desenvolvedores...: Roberto Barbosa Silva- robertobs7@gmail.com
	::	Objetivo Pagina...: Preenche combo Rota
-->
<%	

	if strExecutarSubmitRotaTransporteescolar = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = " SELECT CodRota, CodEmpresa, HoraSaida, HoraChegada , R.Descricao"
	sql = sql & " FROM SCA_ROTA_VICULA_EMPRESA RV"
	sql = sql & " INNER JOIN SCA_ROTA R ON R.Cod_Rota = RV.CodRota"
	sql = sql & " Where RV.CodEmpresa = " & Session("CodEmpresa")	
	sql = sql & " Order by R.Descricao"	
	RS.OPEN SQL, CNN
%>
<select name="cmbRota" id="cmbRota" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRota) = trim(rs("CodRota")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CodRota")& " " & strSelecionado &">" & rs("CodRota") & " - " & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>