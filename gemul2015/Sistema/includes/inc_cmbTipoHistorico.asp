<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<select name="cmbTipoHistorico" class="combo" id="cmbTipoHistorico"  style="width:200pt" onchange='submit()' >
  <option value="0">Selecione...</option>
  <option value="1" <%if strTipoHistorico = "1" then response.Write("selected") %>>Ensino Fundamental e Médio</option>
  <option value="3" <%if strTipoHistorico = "3" then response.Write("selected") %>>Ensino Superior</option>
</select>
    	
