<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<%
    if strFormaIngressoVinculoInep_submit = "S" then
		strSubmitFormaIngressoVinculoInep = "onchange='submit()'"
	else
		strSubmitFormaIngressoVinculoInep = ""
	end if
%>
<select name="cmbFormaIngressoVinculoInep" class="combo" id="cmbFormaIngressoVinculoInep"  style="width:250pt" <%=strSubmitFormaIngressoVinculoInep%>>
  <option value="0">Selecione...</option>
  <option value="8" <%if strFormaIngressoVinculoInep = "8" then response.Write("selected") %>>Forma de Ingresso/Vestibular</option>
  <option value="9" <%if strFormaIngressoVinculoInep = "9" then response.Write("selected") %>>Forma de Ingresso/Enem</option>
  <option value="10" <%if strFormaIngressoVinculoInep = "10" then response.Write("selected") %>>Forma de Ingresso/Outras Seleções</option>
  <option value="11" <%if strFormaIngressoVinculoInep = "11" then response.Write("selected") %>>Forma de Ingresso/PEC-G</option>
  <option value="12" <%if strFormaIngressoVinculoInep = "12" then response.Write("selected") %>>Forma de Ingresso/Outras formas de Ingresso</option>
</select>
    	
