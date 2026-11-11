<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/03/2010
	::	Desenvolvedores...: Roberto Barbosa Silva
	::	Objetivo Pagina...: Consulta Recurso Contabil 
-->
<%
	sql = "SELECT Codigo, DescricaoRecurso, ValorRecurso "
	sql = sql & " FROM SGC_recurso"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbRecurso<%=i%>" id="cmbRecurso<%=i%>" style="width:130pt" class="combo">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodRecurso) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("DescricaoRecurso") & " - " & formatnumber(rs("ValorRecurso"),2) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>