<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Disciplina 
-->
<%	

	if strExecutarSubmitUsuarioCaixa = "" then
    	strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
    
	if strDataAP = "" then
	   strDataUsuario = formatadataAP(date)
	else   
	   strDataUsuario = strDataAP
	end if
	
	sql = " select distinct Usua_Codg from SCF_DEBITOALUNO "
	sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and cod_situacao_pagamento = 2 "
	sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataUsuario & "'"
	sql = sql & " and CaixaFechamento is null "
	sql = sql & " UNION "
	sql = sql & " select distinct Usua_Codg from SCA_VESTIBULAR_DADOS "
	sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " and cod_situacao_pagamento = 2 "
	sql = sql & " and convert(varchar, dataPagamento, 103) = '" & strDataUsuario & "'"
	sql = sql & " and CaixaFechamento is null "
	sql = sql & " order by Usua_Codg "
	RS.OPEN SQL, CNN
%>
<select name="cmbUsuarioCaixa" id="cmbUsuarioCaixa" style="width:170pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strUsuarioCaixa) = trim(rs("Usua_Codg")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Usua_Codg")& " " & strSelecionado &">" & rs("Usua_Codg") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>