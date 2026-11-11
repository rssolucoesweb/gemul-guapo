<!--
	::	Data de Criação...: 21/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com 
	::	Motivo............: Tipo Pagamentos
-->
<%
	SQL = "SELECT Codigo, Descricao "
	SQL = SQL & " FROM scf_TipoPagamento "
	SQL = SQL & " where Situacao = 'A' "
	if strFiltroTipoPagamento <> "" then 
	   SQL = SQL & "and codigo in (" & strFiltroTipoPagamento & ")"
	end if   
	SQL = SQL & " Order by Descricao"
	
	if strSubmitTipoPagamento = "" then
		strSubmitTipoPagamento = "onchange='tipoPG(this.value)'"
	end if
	
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoPagamento" id="cmbTipoPagamento" style="width:150pt" class="combo" <%=strSubmitTipoPagamento%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoPagamento) = trim(rs("Codigo")) then
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