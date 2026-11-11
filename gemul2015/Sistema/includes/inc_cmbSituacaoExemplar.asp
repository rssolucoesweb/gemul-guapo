<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/04/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Situacao Exemplar   
-->
<%	
	sql = "SELECT Codigo, Cod_empresa, Descricao, Situacao"
	sql = sql & " FROM SCB_SITUACAOEXEMPLAR"
	sql = sql & " where Cod_empresa = " & Session("CodEmpresa")	
	rsAux.OPEN SQL, CNN
%>
<select name="cmbSituacaoExemplar" id="cmbSituacaoExemplar" style="width:150pt" class="combo">
	<option value="0">Selecione...</option>
	<%
	IF rsAux.EOF = FALSE THEN
		while not rsAux.eof
			
			if trim(rsAux("Situacao")) = "A" then
				strSituacao = "Ativo"
			else
				strSituacao = "Inativo"
			end if		
					
			if trim(intCodSituacaoExemplar) = trim(rsAux("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rsAux("Codigo")& " " & strSelecionado &">" & rsAux("Descricao") & " - " & strSituacao & "</option> "  & vbcrlf
			rsAux.movenext
		wend
		
	END IF
	rsAux.close
%>
</select>