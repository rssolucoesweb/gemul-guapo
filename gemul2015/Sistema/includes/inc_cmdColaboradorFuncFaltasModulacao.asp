<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->
<%	
	if strExecutarSubmitColaboradorFrequencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = " select DISTINCT C.codigo, C.nome, C.codFuncional "
	sql = sql & " from SRH_COLABORADOR C "
	'sql = sql & " inner join SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.codFuncao "
	sql = sql & " where C.codLotacao = " & Session("CodEmpresa")
	sql = sql & " and C.situacao = 'A' " 
	'sql = sql & " and F.Modular = 'S' " 
	sql = sql & " and (C.CodCategoria = 2 or C.CodCategoria = 8) "  
	sql = sql & " ORDER BY 2"
	RS.OPEN SQL, CNN
%>
<select name="cmbColaboradorFrequencia" id="cmbColaboradorFrequencia" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " - " & ucase(rs("codFuncional")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>