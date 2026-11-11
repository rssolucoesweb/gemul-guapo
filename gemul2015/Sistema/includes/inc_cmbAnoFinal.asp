<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Ano
-->
<%
	if strExecutarFuncaoAnoFinal = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbAnoFinal" id="cmbAnoFinal" class="combo" <%=strFuncao%>>
  <option  value="0">Selecione...</option>
  	<%
	For i = year(date) - 15 to year(date) + 5
  	%>
  		<option value="<%=i%>" <%if cstr(i) = cstr(strAnoFinal) then response.Write("selected")%>><%=i%></option>
  	<%
	Next									
	%>
</select>
</strong>