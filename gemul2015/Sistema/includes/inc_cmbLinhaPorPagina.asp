<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<select name="cmblpp" id="cmblpp"  style="width:70pt" class="combo" >
  <option <%IF strlpp="0" THEN RESPONSE.Write("selected")%> value="0">Selecione...</option>
  	<%
	For i = 1 to 100 
		strLinhaPorPaginas = string(3-len(i),"0") & i
		%>
  		<option value="<%=i%>" <%if TRIM(i)=TRIM(strlpp) then%>selected<%end if%>><%=strLinhaPorPaginas%></option>
  		<%
	Next									
	%>
</select>
