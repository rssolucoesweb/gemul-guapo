<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Tipo Publicacao
-->
<%	
	sql = "SELECT Cod_TipoPublicacao, Nome_TipoPublicacao"
	sql = sql & " FROM SCB_TIPOPUBLICACAO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Cod_TipoPublicacao"
	RS.OPEN SQL, CNN
%>
<select name="cmbTipoPublicacao" id="cmbTipoPublicacao" style="width:250pt" class="form-control" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTipoPublicacao) = trim(RS("Cod_TipoPublicacao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RS("Cod_TipoPublicacao")& " " & strSelecionado &">" & RS("Nome_TipoPublicacao") & "</option> "  & vbcrlf
			RS.movenext
		wend
	END IF
	RS.close
%>
</select>