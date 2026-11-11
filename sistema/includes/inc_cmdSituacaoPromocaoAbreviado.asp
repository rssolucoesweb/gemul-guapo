<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/06/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo situacao promocao
-->
<%	
	sql = "SELECT CODIGO, DESC_ABREVIADA"
	sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by DESCRICAO"
	RSAUX.OPEN SQL, CNN
%>
<select name="cmbSituacaoPromocaoAbreviado" id="cmbSituacaoPromocaoAbreviado" style="width:40pt" class="combo">
	<option value="0">...</option>
<%
	IF RSAUX.EOF = FALSE THEN
		while not RSAUX.eof
			if trim(intCodSituacaoPromocaoAbreviado) = trim(RSAUX("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAUX("codigo")& " " & strSelecionado &">" & RSAUX("DESC_ABREVIADA") & "</option> "  & vbcrlf
			RSAUX.movenext
		wend
	END IF
	RSAUX.close
%>
</select>