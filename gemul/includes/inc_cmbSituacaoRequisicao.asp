<!--
	::	IMOB
	::	Data de Criação...: 16/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir os tipo de acesso existentes em um combobox 
	::	Data Atualizacao..: 
-->
<%
IF StrReloadSistema = "" then 'Verifica se é para dar o reload na página
	strOnChangeSistema = ""
else
	strOnChangeSistema="onChange='submit()'"
end if
%>
<select name="cmbSituacaoRequisicao" id="cmbSituacaoRequisicao" class="combo"  style="width:200pt" <%=strOnChangeSistema%> >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, descricao "
	sql = sql & " from EST_situacao "
	sql = sql & " order by codigo "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if cstr(intCodSituacaoRequisicao) = cstr(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("descricao") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>