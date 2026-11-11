<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2008
	::	Desenvolvedores...: Roberto Barbosa Silva- robertobs7@gmail.com
	::	Objetivo Pagina...: Preenche combo Rota
-->
<%	
	sql = "SELECT Cod_ProjetoSociais, Desc_ProjetoSociais"
	sql = sql & " FROM SCA_PROJETOSOCIAIS"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " Order by Cod_ProjetoSociais"
	RS.OPEN SQL, CNN
%>
<select name="cmbProjetoSociais" id="cmbProjetoSociais" style="width:150pt" class="form-control" OnChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProjetoSociais) = trim(rs("Cod_ProjetoSociais")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_ProjetoSociais")& " " & strSelecionado &">" & rs("Desc_ProjetoSociais") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>