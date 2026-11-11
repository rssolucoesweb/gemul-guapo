<!--
	::	IMOB
	::	Data de Criação...: 16/02/2009
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir os tipo de acesso existentes em um combobox 
	::	Data Atualizacao..: 
-->
<select name="cmbGrupoProduto" id="cmbGrupoProduto" class="combo"  style="width:200pt" onchange="carregaGrupo()" >
	<option value="0">Selecione...</option>
	<%
	if intSecaoProduto = "" then intSecaoProduto = "0"
	sql = "SELECT codigo, descricao "
	sql = sql & " from EST_GRUPO_PRODUTO"
	sql = sql & " where cod_Empresa = " & session("CodEmpresa")
	sql = sql & " and COD_SECAO = "& intSecaoProduto
	sql = sql & " order by descricao "	
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			if trim(intCodGrupoProduto) = trim(rs("codigo")) then
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