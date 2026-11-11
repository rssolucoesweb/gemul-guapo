 <!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo Lotacao
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "SELECT cod_Lotacao, desc_Lotacao"
	sql = sql & " FROM SRH_LotacaoCOLABORADOR"
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if   
	sql = sql & " Order by desc_Lotacao"
	RS.OPEN SQL, CNN
%>
<select name="cmbRemocao" id="cmbRemocao" style="width:220pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRemocao) = trim(rs("cod_Lotacao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_Lotacao")& " " & strSelecionado &">" & rs("desc_Lotacao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>