<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<select <%=strDesabilitaEnvio%>  name="cmbMes" id="cmbMes"  style="width:80pt" class="combo" >
  <option  value="0">..LIBERADO..</option>
  	<%
	For i = 1 to 12
	%>
  		<option value="<%=i%>" <%if cstr(i)=cstr(strMes) then%>selected<%end if%>><%=ucase(monthname(i))%></option>
  	<%
	Next	
	%>
</select>
