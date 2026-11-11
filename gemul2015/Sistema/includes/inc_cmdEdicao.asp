<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/10/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Edicao
-->
<select name="cmbEdicao" id="cmbEdicao" style="width:100pt" class="combo" <%=strDisabilitaCombo%>>
  <option value="0">Selecione...</option>
  <% for i=1 to 350%>
  <option value="<%=i%>" <%if intCodEdicao = i then response.Write("selected") %>><%=i%>ª Edição</option>
  <% next%>
</select>