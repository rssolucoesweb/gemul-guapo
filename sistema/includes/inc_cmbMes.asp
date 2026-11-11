<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Mes
-->
<%
	if strExecutarSubmitMes = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
%>

<select <%=strDesabilitaEnvio%>  name="cmbMes" id="cmbMes"  style="width:150pt" class="form-control" <%=strFuncao%>>
  <option  value="0">Selecione...</option>
  	<%
	For i = 1 to 12
	%>
  		<option value="<%=i%>" <%if cstr(i)=cstr(strMes) then%>selected<%end if%>><%=ucase(monthname(i))%></option>
  	<%
	Next	
	%>
</select>
