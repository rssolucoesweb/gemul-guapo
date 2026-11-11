<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 30/06/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Tipo Aquisicao
-->
<%	
	sql = "SELECT Cod_TipoAquisicao, Nome_TipoAquisicao"
	sql = sql & " FROM SCB_TIPOAQUISICAO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Cod_TipoAquisicao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoAquisicao" id="cmbTipoAquisicao" style="width:250pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoAquisicao) = trim(RS("Cod_TipoAquisicao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RS("Cod_TipoAquisicao")& " " & strSelecionado &">" & RS("Nome_TipoAquisicao") & "</option> "  & vbcrlf
			RS.movenext
		wend
	END IF
	RS.close
%>
</select>