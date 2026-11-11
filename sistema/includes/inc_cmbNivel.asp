<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Convênios - Modulação - Folha de Pagamento
-->
<%	


    if strFuncao = "" then
		strSubmit = "onchange='submit()'"
	else
		strSubmit = ""
	end if

    if strSubmitNivel = "" then
		strSubmit = "onchange='submit()'"
	else
		strSubmit = ""
	end if

	sql = "SELECT Codigo, Cod_grupo, Descricao, Situacao"
	sql = sql & " FROM SRH_NIVEL"
	sql = sql & " Where Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " And Situacao = 'A'"
	if session("NivelPermissao") = "A" then
	else
		if intCodNivel <> "" then
			sql = sql & " and Codigo = " & intCodNivel
		end if
	end if
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbNivel" id="cmbNivel" style="width:200pt" class="form-control" <%=strDisabilitaCombo%> <%=strSubmit%>>
<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodNivel) = trim(rs("Codigo")) then
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