<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Grau 
-->
<%
	if strExecutarSubmitEvento = "" then
		strFuncaoEvento = ""
	else
		strFuncaoEvento = "onchange='submit()'"
	end if
	sql = "SELECT cod_calendario_evento, nome, situacao"
	sql = sql & " FROM SCA_CALENDARIO_EVENTO"
	SQL = SQL & " WHERE situacao = 'A' and cod_grupo=" & Session("CodGrupo")
	sql = sql & " Order by nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbEvento" id="cmbEvento" style="width:250pt" class="form-control" <%=strFuncaoEvento%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEvento) = trim(rs("cod_calendario_evento")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_calendario_evento")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>