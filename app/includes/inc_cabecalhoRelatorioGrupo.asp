<%
if trim(strAnoCab) = "" then strAnoCab = Session("strAnoLetivo")
%>
<table width="98%" border="0"  cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td width="6%" align="left"><img src="<%=Session("caminhoLogomarcaEmpresa")%>" width="50" height="50" /></td>
    <td colspan="2" align="left"><strong><%=session("strNomeGrupo")%></strong></td>
    <td colspan="2" width="37%" align="center"><strong><font size="3"><%=strTituloRelatorio%></font></strong>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="5" align="center"><hr size="1" color="#CCCCCC" /></td>
  </tr>
  <tr>
    <td colspan="2" align="left"  class="textoRelatorioMenor9">Data da Impress&atilde;o: <%=FormataDataAp(date)%>&nbsp;<%=time%></td>
    <td colspan="2" align="center"><%response.write "Ano Letivo: <strong>" & strAnoCab & "</strong>"%></td>
    <td width="19%" align="right"><%if intPagina <>"" then%>
      P&aacute;gina <%=intPagina%>
      <%end if%></td>
  </tr>
</table>
