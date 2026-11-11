<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/10/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Periodicidade
-->
<%
	sql = "SELECT Cod_Periodicidade, Nome_Periodicidade"
	sql = sql & " FROM SCB_PERIODICIDADE"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Nome_Periodicidade"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodicidade" id="cmbPeriodicidade" style="width:250pt" class="form-control" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPeriodicidade) = trim(rs("Cod_Periodicidade")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Periodicidade")& " " & strSelecionado &">" & rs("Nome_Periodicidade") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>