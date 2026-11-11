<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo sexo
-->

<select name="cmbSexo" class="Combo" id="cmbSexo"  style="width:100pt" >
  <option value="0">Selecione...</option>
  <option value="M" <%if strSexo = "M" then response.Write("selected") %>>Masculino</option>
  <option value="F" <%if strSexo = "F" then response.Write("selected") %>>Feminino</option>
</select>
