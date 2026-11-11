<%
	if strTextoBotaoRel = "" then strTextoBotaoRel ="Gerar Relatório"
%>

<%if strDesabilitaGerar = "" then%>
	<button onclick="return gerar()"  type="button" class="btn btn-outline-success"><%=strTextoBotaoRel%></button>
<%end if%>
<button onClick="window.location='<%=replace(pagina_atual,"/app/","")%>'"  type="button" class="btn btn-outline-warning">Limpar tela</button>