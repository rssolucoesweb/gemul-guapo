<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<select name="cmblpp" id="cmblpp"  style="width:70pt" class="form-control" >
  <option  value="0">Selecione...</option>
  	<%
	For i = 10 to  50 
		strlpp = string(2-len(i),"0") & i
		%>
  		<option value="<%=i%>" <%if cstr(i)=cstr(strlpp) then%>selected<%end if%>><%=strlpp%></option>
  		<%
	Next									
	%>
</select>
