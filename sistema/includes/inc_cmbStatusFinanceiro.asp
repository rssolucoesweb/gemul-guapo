<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<select name="cmbStatusFinanceiro" class="form-control" id="cmbStatusFinanceiro"  style="width:70pt" onchange='submit()' >
  <option value="0">Selecione...</option>
  <option value="1" <%if strStatusFinanceiro = "1" then response.Write("selected") %>>DEVE</option>
  <option value="2" <%if strStatusFinanceiro = "2" then response.Write("selected") %>>PAGO</option>
  <option value="3" <%if strStatusFinanceiro = "3" then response.Write("selected") %>>ABONO</option>
  <option value="4" <%if strStatusFinanceiro = "4" then response.Write("selected") %>>100%</option>
  <option value="5" <%if strStatusFinanceiro = "5" then response.Write("selected") %>>ADVOGADO</option>
  <option value="6" <%if strStatusFinanceiro = "6" then response.Write("selected") %>>PROTESTO</option>
</select>
