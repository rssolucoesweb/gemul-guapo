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
    <td width="6%" align="left"><img src="<%=Session("caminhoLogomarcaEmpresa")%>" width="50" height="50"></td>
    <td colspan="2" align="left"><strong><%=session("strNomeGrupo")%></strong></td>
    <td width="40%" align="center"><strong><font size="3"><%=strTituloRelatorio%></font></strong>&nbsp;</td>
  </tr>
  
  <tr> 
    <td colspan="5" align="center"><hr size="1" color="#CCCCCC"></td>
  </tr>
   <tr>
    <td colspan="2" align="left"  class="textoRelatorioMenor9">Data da Impress&atilde;o: <%=FormataDataAp(date)%>&nbsp;<%=time%></td>
    <td colspan="2" align="center"><%response.write "Ano Letivo Atual: <strong>" & strAnoCab & "</strong>"%></td>
    <td width="32%" align="right"><%if intPagina <>"" then%>P&aacute;gina <%=intPagina%><%end if%></td>
  </tr>
</table>

