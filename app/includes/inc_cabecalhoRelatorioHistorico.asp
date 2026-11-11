<%
if trim(strAnoCab) = "S" then strAnoCab = Session("strAnoLetivo")
%>
<table width="98%" border="0"  cellpadding="0" cellspacing="0" align="center">
<% if strMostraMantenedora = "" then %>
    <tr> 
      <td width="6%" rowspan="3" align="left"><img src="<%=Session("caminhoLogomarcaEmpresa")%>" width="50" height="50"></td>
      <td colspan="3" align="left"><strong><%=session("EmpresaWeb")%></strong></td>
      <td colspan="2" rowspan="3" align="center"><strong><font size="2"><%=strTituloRelatorio%></font></strong>&nbsp;</td>
    </tr>
<% else %>
    <tr>
      <td width="6%" rowspan="4" align="left"><img src="<%=Session("caminhoLogomarcaEmpresa")%>" width="50" height="50"></td>
      <td colspan="3" align="left"><strong><%=session("MantenedoraWeb")%>&nbsp;</strong></td>
      <td colspan="2" rowspan="4" align="center"><strong><font size="2"><%=strTituloRelatorio%></font></strong>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" align="left"><strong><%=session("EmpresaWeb")%></strong></td>
    </tr>
<% end if %>    
  <tr>
    <td colspan="3" align="left" class="textoRelatorioMenor8"><%=session("EnderecoEmpresaWeb")%>, <%=session("BairroEmpresaWeb")%></td>
  </tr>
  <tr>
    <td colspan="3" align="left" class="textoRelatorioMenor8"><%=session("CidadeEmpresaWeb")%>-<%=session("ufEmpresaWeb")%>, <%=session("CepEmpresaWeb")%>&nbsp;&nbsp;-&nbsp;&nbsp;<%=session("TelefoneEmpresaWeb")%></td>
  </tr>
  <tr> 
    <td colspan="6" align="center"><hr size="1" color="#CCCCCC"></td>
  </tr>
   <tr>
    <td colspan="2" align="left"  class="textoRelatorioMenor9">&nbsp;</td>
    <td width="16%" align="left">&nbsp;</td>
    <td colspan="2" align="left">&nbsp;</td>
    <td width="32%" align="right"><%if intPagina <>"" then%>P&aacute;gina <%=intPagina%><%end if%></td>
  </tr>
</table>

