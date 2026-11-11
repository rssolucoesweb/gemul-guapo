<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo funcao
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	sql = "SELECT cod_funcao, desc_funcao"
	sql = sql & " FROM SRH_FUNCAOCOLABORADOR "
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if
	if strVerificaTipoFuncao = "PROFESSOR" then
		sql = sql & " and TIPO_FUNCAO = '" & strVerificaTipoFuncao & "'"
	end if   
	sql = sql & " Order by desc_funcao"
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncao" id="cmbFuncao" style="width:200pt" class="combo" <%=strSubmitFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFuncao) = trim(rs("cod_funcao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_funcao")& " " & strSelecionado &">" & rs("desc_funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>