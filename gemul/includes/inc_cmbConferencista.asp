<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 20/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Tipo Acesso 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%
IF StrReloadConferencista = "" then 'Verifica se é para dar o reload na página
	strOnChangeConferencista = ""
else
	strOnChangeConferencista="onChange='return reload()'"
end if
%>
<select name="cmbConferencista" id="cmbConferencista" class="combo"  style="width:150pt" <%=strOnChangeConferencista%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, nome "
	sql = sql & " from EST_Conferencista "
	sql = sql & " where cod_empresa = " & session("CodEmpresa")
	sql = sql & " order by nome "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodConferencista) = cstr(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("nome") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>