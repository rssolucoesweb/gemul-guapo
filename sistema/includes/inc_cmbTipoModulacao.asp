<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/02/2010
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: tipo modulação
-->

<select name="cmbTipoModulacao" class="form-control" id="cmbTipoModulacao"  style="width:130pt" >
  <option value="A" <%if strTipoModulacao = "A" then response.Write("selected") %>>Aulas</option>
  <option value="H" <%if strTipoModulacao = "H" then response.Write("selected") %>>Horas</option>
</select>
