<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 20/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Tipo Documento 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<select name="cmbBeneficiario" id="cmbBeneficiario" class="combo"  style="width:250pt" >
	<option value="0">Selecione...</option>
	<%
	sql = "SELECT codigo, razaosocialNome "
	sql = sql & " from SCC_beneficiario "
	sql = sql & " where codEmpresa = " & session("codEmpresa")
	sql = sql & " order by codigo "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodBeneficiario) = trim(rs("codigo")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("razaosocialNome") & "</option>" & vbcrlf
			rs.movenext
		wend
	end if
	rs.close
	%>
</select>