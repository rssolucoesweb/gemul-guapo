<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta Ficha Descritiva
-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%

	if strExecutarSubmit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT Codigo, Descricao, Ano_Letivo, Semestre"
	sql = sql & " FROM SCA_FICHA_DESCRITIVA"
	if strCompartilharDados = "S" then
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	else   
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
	end if   
	sql = sql & " And Situacao = 'A'"
	sql = sql & " And Utilizacao = 'AC'" 'Somente aparecerá no acadêmico
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbFichaDescritiva" id="cmbFichaDescritiva" style="width:230pt" class="form-control"  <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFichaDescritiva) = trim(rs("Codigo")) then
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