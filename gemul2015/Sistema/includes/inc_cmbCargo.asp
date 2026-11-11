<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo cargo
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "SELECT cod_Cargo, desc_Cargo"
	sql = sql & " FROM SRH_CargoCOLABORADOR"
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if   
	sql = sql & " Order by desc_Cargo"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbCargo" id="cmbCargo" style="width:150pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCargo) = trim(rs("cod_Cargo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_Cargo")& " " & strSelecionado &">" & rs("desc_Cargo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>