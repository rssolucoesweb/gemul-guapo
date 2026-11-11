<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de sequencia aula
-->
<%
	if strExecutarSubmitSequenciaAula = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbSequenciaAula" id="cmbSequenciaAula" style="width:150pt" class="combo" <%=strFuncao%>>
  <option value="0">Selecione...</option>
  <% for i=1 to 10%>
  <option value="<%=i%>" <%if trim(intCodSequenciaAula) = trim(i) then response.Write("selected") %>><%=i%>ª Aula</option>
  <% next%>
</select>