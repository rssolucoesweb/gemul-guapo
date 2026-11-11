<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Convênios - Modulação - Folha de Pagamento
-->
<%	
	sql = "SELECT Codigo, Cod_grupo, Descricao, Situacao"
	sql = sql & " FROM SRH_CONVENIO"
	sql = sql & " where Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbConvenios" id="cmbConvenios" style="width:150pt" class="combo" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodConvenio) = trim(rs("Codigo")) then
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