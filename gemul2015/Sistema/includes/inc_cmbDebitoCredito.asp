<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2010
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo credito debito
-->
<select name="cmbDebitoCredito" class="combo" id="cmbDebitoCredito"  style="width:100pt" >
  <option value="0">Selecione...</option>
  <option value="C" <%if strDebitoCredito = "C" then response.Write("selected") %>>Crédito</option>
  <option value="D" <%if strDebitoCredito = "D" then response.Write("selected") %>>Débito</option>
</select>
    	
