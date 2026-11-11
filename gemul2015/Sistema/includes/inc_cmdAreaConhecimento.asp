<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Area do Conhecimento 
-->
<%
	sql = "SELECT Cod_Conhecimento, Nome_Conhecimento"
	sql = sql & " FROM SCB_AreaConhecimento"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Nome_Conhecimento"
	RS.OPEN SQL, CNN
%>
<select name="cmbAreaConhecimento" id="cmbAreaConhecimento" style="width:150pt" class="combo" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAreaConhecimento) = trim(rs("Cod_Conhecimento")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Conhecimento")& " " & strSelecionado &">" & rs("Nome_Conhecimento") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>