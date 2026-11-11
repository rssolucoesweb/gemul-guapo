<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Departamento
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->


<%
	if strExecutarSubmitDepto = "" then
		strFuncaoDepto = ""
	else
		strFuncaoDepto = "onchange='submit()'"
	end if
	
	sql = "SELECT CODIGO, DESCRICAO"
	sql = sql & " FROM SEG_DEPARTAMENTO"
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if   
	sql = sql & " Order by DESCRICAO"
	RS.OPEN SQL, CNN
%>
<select name="cmbDepartamento" id="cmbDepartamento" style="width:150pt" class="combo" <%=strFuncaoDepto%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDepartamento) = trim(rs("CODIGO")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CODIGO")& " " & strSelecionado &">" & rs("DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>