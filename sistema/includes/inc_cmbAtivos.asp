<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Filtra Ativos e todas as situações
-->

<select name="cmbativos" class="form-control" id="cmbativos"  style="width:130pt"  onchange='submit()'>
  <option value="A" <%if strAtivos = "A" then response.Write("selected") %>>Somente Ativos</option>
  <option value="T" <%if strAtivos = "T" then response.Write("selected") %>>Todas as Situações</option>
</select>
