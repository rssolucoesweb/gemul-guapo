<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo sexo
-->

<select name="cmbTipoNacionalidade" class="Combo" id="cmbTipoNacionalidade"  style="width:160pt" >
  <option value="0">Selecione...</option>
  <option value="1" <%if strTipoNacionalidade = "1" then response.Write("selected") %>>Nascido no Brasil</option>
  <option value="2" <%if strTipoNacionalidade = "2" then response.Write("selected") %>>Nascido no Ext. ou Naturalizado</option>
  <option value="3" <%if strTipoNacionalidade = "3" then response.Write("selected") %>>Estrangeira</option>
</select>
