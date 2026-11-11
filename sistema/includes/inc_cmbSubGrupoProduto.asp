<!--
	::	IMOB
	::	Data de Criação...: 16/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir os tipo de acesso existentes em um combobox 
	::	Data Atualizacao..: 
-->
<select name="cmbSubGrupoProduto" id="cmbSubGrupoProduto" class="form-control"  style="width:200pt" >
	<option value="0">Selecione...</option>
	<%
	if intCodGrupoProduto= "" then intCodGrupoProduto ="0"
	sql = "SELECT codigo, descricao "
	sql = sql & " from EST_SUBGRUPO_PRODUTO"
	sql = sql & " where cod_Grupo_Produto = " & intCodGrupoProduto
	sql = sql & " order by descricao "	
	rs.open sql, cnnAlmox
	if rs.eof = false then
		while not rs.eof
			if trim(intCodSubGrupoProduto) = trim(rs("codigo")) then
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