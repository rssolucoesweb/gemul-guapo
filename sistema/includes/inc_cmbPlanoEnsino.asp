<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/04/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo Visualizacao
-->
<%
    if strPlanoEnsino_submit = "S" then
		strFuncaoPlanoEnsino = "onchange='submit()'"
	else
		strFuncaoPlanoEnsino = ""
	end if
%>
<select name="cmbPlanoEnsino" class="form-control" id="cmbPlanoEnsino"  style="width:140pt" <%=strFuncaoPlanoEnsino%>>
  <option value="0">Selecione...</option>
  <option value="OBJ" <%if strPlanoEnsino = "OBJ" then response.Write("selected") %>>Objetivos</option>
  <option value="EME" <%if strPlanoEnsino = "EME" then response.Write("selected") %>>Ementa</option>
  <option value="CON" <%if strPlanoEnsino = "CON" then response.Write("selected") %>>Conteúdo Programático</option>
  <option value="MET" <%if strPlanoEnsino = "MET" then response.Write("selected") %>>Metodologia</option>
  <option value="BIB" <%if strPlanoEnsino = "BIB" then response.Write("selected") %>>Bibliografia Básica</option>
  <option value="BIC" <%if strPlanoEnsino = "BIC" then response.Write("selected") %>>Bibliografia Complementar</option>
  <option value="CRI" <%if strPlanoEnsino = "CRI" then response.Write("selected") %>>Critério de Avaliação</option>
</select>
    	
