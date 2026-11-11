<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/02/2010
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: tipo vinculo
-->
<select name="cmbTipoVinculo" class="form-control" id="cmbTipoVinculo"  style="width:130pt" >
  <option value="A" <%if strTipoVinculo = "A" then response.Write("selected") %>>Administrativo</option>
  <option value="D" <%if strTipoVinculo = "D" then response.Write("selected") %>>Docente</option>
</select>
