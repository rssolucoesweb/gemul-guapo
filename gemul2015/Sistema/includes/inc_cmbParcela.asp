<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<select name="cmbParcela" id="cmbParcela"  style="width:70pt" class="combo" >
  <option  value="0">Selecione...</option>
  	<%
	For i = 1 to 12
		strCodParcela = string(2-len(i),"0") & i
		%>
  		<option value="<%=i%>" <%if cstr(i)=cstr(strParcela) then%>selected<%end if%>><%=strCodParcela%></option>
  		<%
	Next									
	%>
</select>
