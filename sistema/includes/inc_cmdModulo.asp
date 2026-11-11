<!--
	::	Desenvolvido por..: Supera webX - www.superawebx.com.br"
	::	Data de Criação...: 05/03/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Consulta Modulo
-->
<%	
	if strExecutarSubmitGrupo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	SQL = "SELECT MOD_COD, MOD_DESCRICAO "
	SQL = SQL & " FROM SEG_MODULO"
	SQL = SQL & " order by MOD_COD"
	RS.OPEN SQL, CNN
%>
<select name="cmbModulo" id="cmbModulo" style="width:350pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodModulo) = trim(rs("MOD_COD")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("MOD_COD")& " " & strSelecionado &">" & rs("MOD_DESCRICAO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>