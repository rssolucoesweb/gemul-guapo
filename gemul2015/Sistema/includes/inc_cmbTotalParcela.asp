<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<%
	if strExecutarFuncaoTotalParcela = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbTotalParcela" id="cmbTotalParcela"  style="width:70pt" class="combo" <%=strFuncao%>>
  <option  value="0">Selecione...</option>
  	<%
	For i = 1 to 24
		%>
  		<option value="<%=i%>" <%if cInt(i)=cInt(strCodTotalParcela) then%>selected<%end if%>><%=string(2-len(i),"0") & i%></option>
  		<%
	Next									
	%>
</select>
