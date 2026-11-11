<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/03/2010
	::	Desenvolvedores...: Roberto Barbosa Silva
	::	Objetivo Pagina...: Consulta Recurso Contabil 
-->
<%
	sql = "SELECT Codigo, DescricaoConta, valorConta "
	sql = sql & " FROM SGC_plano_conta"
	SQL = SQL & " WHERE cod_empresa =  " & Session("CodEmpresa")
	sql = sql & " Order by codigo"
	RS.OPEN SQL, CNN
%>
<select name="cmbPlanoConta<%=i%>" id="cmbPlanoConta<%=i%>" style="width:130pt" class="combo">
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPlanoConta) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("DescricaoConta") & " - " & formatnumber(rs("valorConta"),2) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>