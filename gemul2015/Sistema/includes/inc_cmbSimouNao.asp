<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<%
    if strSimouNao_submit = "S" then
		strFuncaoSimOuNao = "onchange='submit()'"
	else
		strFuncaoSimOuNao = ""
	end if
%>
<select <%=bloqueiaComboAlteracao%> name="cmbSimouNao" class="combo" id="cmbSimouNao"  style="width:70pt" <%=strFuncaoSimOuNao%>>
  <option value="0">Selecione...</option>
  <option value="S" <%if strSimouNao = "S" then response.Write("selected") %>>SIM</option>
  <option value="N" <%if strSimouNao = "N" then response.Write("selected") %>>NAO</option>
</select>
    	
