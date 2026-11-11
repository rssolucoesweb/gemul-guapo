<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Evento Dossie Colaborador
-->
<%	
	sql = "SELECT Codigo, Desc_EventoDossie"
	sql = sql & " FROM SRH_COLABORADOR_EVENTO_DOSSIE"
	
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if   
	
	sql = sql & " Order by Codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbColaboradorEventoDossie" id="cmbColaboradorEventoDossie" style="width:150pt" class="form-control" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodColaboradorEventoDossie) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Desc_EventoDossie") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>