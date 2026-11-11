<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche Sigla do nvel de ensino
-->

<select name="cmbNivelEnsinoSigla" class="Combo" id="cmbNivelEnsinoSigla"  style="width:160pt" >
  <option value="EB" <%if strNivelEnsinoSigla = "EB" then response.Write("selected") %>>Educação Básica</option>
  <option value="ES" <%if strNivelEnsinoSigla = "ES" then response.Write("selected") %>>Educação Superior</option>
  <option value="PG" <%if strNivelEnsinoSigla = "PG" then response.Write("selected") %>>Pós/Especialização</option>
  <option value="ME" <%if strNivelEnsinoSigla = "ME" then response.Write("selected") %>>Mestrado</option>
  <option value="DR" <%if strNivelEnsinoSigla = "DR" then response.Write("selected") %>>Doutorado</option>
  <option value="TE" <%if strNivelEnsinoSigla = "TE" then response.Write("selected") %>>Técnico</option>
  <option value="TN" <%if strNivelEnsinoSigla = "TN" then response.Write("selected") %>>Tecnólogo</option>
</select>
