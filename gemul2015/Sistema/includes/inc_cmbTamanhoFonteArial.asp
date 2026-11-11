<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<select name="cmbTamanhoFonteArial" class="combo" id="cmbTamanhoFonteArial"  style="width:80pt" >
  <option value="celulaarial10" <%if strclasse = "celulaarial10" then response.Write("selected") %>>Fonte Arial 10</option>
  <option value="celulaarial7" <%if strclasse = "celulaarial7" then response.Write("selected") %>>Fonte Arial 7</option>
  <option value="celulaarial8" <%if strclasse = "celulaarial8" then response.Write("selected") %>>Fonte Arial 8</option>
  <option value="celulaarial9" <%if strclasse = "celulaarial9" then response.Write("selected") %>>Fonte Arial 9</option>
  <option value="celulaarial11" <%if strclasse = "celulaarial11" then response.Write("selected") %>>Fonte Arial 11</option>
</select>
    	
