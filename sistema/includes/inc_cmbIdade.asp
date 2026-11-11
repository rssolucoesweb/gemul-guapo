<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<%
	if strExecutarFuncaoIdade = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
%>
<select name="cmbIdade" id="cmbIdade"  style="width:35pt" class="form-control" <%=strFuncao%>>
  <option  value="0">Selecione...</option>
  	<%
	For i = 1 to 100
		%>
  		<option value="<%=i%>" <%if cInt(i)=cInt(strIdade) then%> selected<%end if%>><%=i%></option>
 		<%
	Next									
	%>
</select>
