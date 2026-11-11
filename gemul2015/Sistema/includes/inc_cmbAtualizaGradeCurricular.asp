<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<%
    if strAtualizaGrade_submit = "S" then
		strFuncaoAtualizaGrade = "onchange='submit()'"
	else
		strFuncaoAtualizaGrade = ""
	end if
%>
<select name="cmbAtualizaGrade" class="combo" id="cmbAtualizaGrade"  style="width:100pt" <%=strFuncaoAtualizaGrade%>>
  <option value="0">Selecione...</option>
  <option value="A" <%if strAtualizaGrade = "A" then response.Write("selected") %>>Atualização</option>
  <option value="D" <%if strAtualizaGrade = "D" then response.Write("selected") %>>Exclusão</option>
</select>
    	
