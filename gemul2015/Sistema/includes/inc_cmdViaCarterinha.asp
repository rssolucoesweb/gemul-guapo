<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 17/12/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Consulta de irmao
-->
<select name="cmbViaCarterinha" id="cmbViaCarterinha" style="width:65pt" class="combo" <%=strDisabilitaCombo%>>
  <option value="0">Selecione...</option>
  <% for i=1 to 5%>
  <option value="<%=i%>" <%if TRIM(intViaCarterinha) = TRIM(i) then response.Write("selected") %>><%=i%></option>
  <% next%>
</select>