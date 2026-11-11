<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 30/06/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta Genero
-->
<%	
	sql = "SELECT Cod_Genero, Nome_Genero"
	sql = sql & " FROM SCB_GENERO"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Cod_Genero"
	RS.OPEN SQL, CNN
%>
<select name="cmbGenero" id="cmbGenero" style="width:250pt" class="form-control" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodGenero) = trim(RS("Cod_Genero")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RS("Cod_Genero")& " " & strSelecionado &">" & RS("Nome_Genero") & "</option> "  & vbcrlf
			RS.movenext
		wend
	END IF
	RS.close
%>
</select>