<!--
	::	SIGE
	::	Data de Criação...: 17/08/2004
	::	Desenvolvedores...: Sérgio Dias BOrges
	::	Objetivo Pagina...: Inncluir as taxas existentes em um combobox 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%	
	if strExecutarSubmitTaxa = "" then
		strFuncaoTx = ""
	else
		strFuncaoTx = "onchange='submit()'"
	end if
	sql = "select cod_taxa, descricao, valor, protocolo, Cod_Tipo_Taxa"
	sql = sql & " from scf_taxa"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")
	if intCodDepartamento <> "0" and  intCodDepartamento <> ""  then
		sql = sql & " and cod_departamento = " & intCodDepartamento
	end if
	if strTaxaZerada = "S" then
		sql = sql & " and valor = 0"
	end if
	if strMostraTaxaProtocolo = "S" then
		sql = sql & " and protocolo = 'S'"
	end if
	sql = sql & " and status = 'A'"
	sql = sql & " order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTaxa" id="cmbTaxa" style="width:200pt" class="combo" <%=strFuncaoTx%>>
	<option value="0">Selecione...</option>
<%
	intCodTipoTaxa = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTaxa) = trim(rs("cod_taxa")) then
				strSelecionado = " selected"
				intCodTipoTaxa = rs("Cod_Tipo_Taxa")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_taxa")& " " & strSelecionado &">" & rs("descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>