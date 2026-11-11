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

	sql = " SELECT Cod_Rota, Cod_Grupo, Descricao, Distancia_percorrida, CodColaborador, Veiculo, Placa, Cor, Data, Observacao"
	sql = sql & " FROM SCA_ROTA"
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo") 

	RS.OPEN SQL, CNN
%>
<select name="cmbRota" id="cmbRota" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRota) = trim(rs("Cod_Rota")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Rota")& " " & strSelecionado &">" & rs("Cod_Rota") & " - " & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>