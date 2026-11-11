<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 25/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Estagio
-->
<%	
	sql = "SELECT Codigo, Cod_empresa, Ano, Semestre, Descricao, Cod_Colaborador"
	sql = sql & " FROM SCA_ESTAGIO"
	SQL = SQL & " WHERE Cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbEstagio" id="cmbEstagio" style="width:230pt" class="form-control" OnChange="submit()" >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEstagio) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("Descricao")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>