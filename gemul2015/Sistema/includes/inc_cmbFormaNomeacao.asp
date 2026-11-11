<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo FormaNomeacao
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "SELECT cod_formanomeacao, desc_formanomeacao"
	sql = sql & " FROM SRH_FORMANOMEACAOCOLABORADOR"
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if   
	sql = sql & " Order by desc_formanomeacao"
	RS.OPEN SQL, CNN
%>
<select name="cmbFormaNomeacao" id="cmbFormaNomeacao" style="width:150pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodformanomeacao) = trim(rs("cod_formanomeacao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_formanomeacao")& " " & strSelecionado &">" & rs("desc_formanomeacao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>