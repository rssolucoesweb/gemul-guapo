<%
if trim(strAnoCab) = "" then strAnoCab = Session("strAnoLetivo")
%>
<table width="98%" height="38" border="0" align="center"  cellpadding="0" cellspacing="0">
  
  <tr>
    <td height="19" colspan="2" align="left"><div align="center"><strong><font size="2"><%=strTituloRelatorio%></font></strong>&nbsp;</div></td>
  </tr>
  
  <tr>
    <td height="19" align="center">&nbsp;</td>
    <td width="13%" height="19" align="center"><%if intPagina <>"" then%>
      P&aacute;gina <%=intPagina%>
    <%end if%></td>
  </tr>
</table>

