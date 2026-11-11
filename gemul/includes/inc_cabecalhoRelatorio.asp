<!--
	::	SIGE
	::	Data de Criação...: 07/03/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cabeçalhos do relatório
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%
if trim(strAnoCab) = "" then strAnoCab = Session("strAnoLetivo")
%>
<table width="98%" border="0"  cellpadding="0" cellspacing="0" align="center">
  <tr> 
    
	<%
		 if trim(request.ServerVariables("SERVER_NAME")) = "www.gemul-canedo.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul-canedo.com.br" then
		 %>
            <td width="21%"><img src="../../../images/Grupo/<%=session("codGrupo")%>/Empresa/<%=session("codEmpresa")%>/canedo.png" width="180" height="78" /></td>
		<%else%>
            <td width="15%" align="left"><img src="../../../images/Grupo/<%=session("codGrupo")%>/Empresa/<%=session("codEmpresa")%>/logoprefeitura.png" width="179" height="49"></td>
		<%end if%>
	
    
	
	<td width="70%"  align="center"><strong><font size="3"><%=strTituloRelatorio%></font></strong>&nbsp;<br />
    </strong></td>

		<%
		 if trim(request.ServerVariables("SERVER_NAME")) = "www.gemul-canedo.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul-canedo.com.br" then
		 %>
            <td width="21%"></td>
		<%else%>
	<td align="center"><img src="../../../images/Grupo/<%=session("codGrupo")%>/Empresa/<%=session("codEmpresa")%>/rel.png"  width="180" height="78" /></td>
		<%end if%>
    

	
  </tr>
  <tr> 
    <td colspan="3"  align="center"><hr size="1" color="#CCCCCC"></td>
  </tr>
   <tr>
    <td colspan="2"  align="left"  class="textoRelatorioMenor9">Data da Impress&atilde;o: <%=FormataDataAp(date)%>&nbsp;<%=time%></td>
    <td width="15%" align="right"><%if intPagina <>"" then%>P&aacute;gina <%=intPagina%><%end if%></td>
  </tr>
</table>

