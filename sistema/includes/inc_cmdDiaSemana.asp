<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de dia semana
-->
<select name="cmbDiaSemana" id="cmbDiaSemana" style="width:150pt" class="form-control">
  <option value="0">Selecione...</option>
  <% for i=1 to 7%>
  <option value="<%=i%>" <%if trim(intCodDiaSemana) = trim(i) then response.Write("selected") %>><%=WeekDayName(i)%></option>
  <% next%>
</select>