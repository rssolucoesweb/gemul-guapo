
<%
if trim(strAnoCab) = "" then strAnoCab = Session("strAnoLetivo")
%>
<table width="98%" border="0"  cellpadding="0" cellspacing="0" align="center">
  <tr> 
    <td width="3%" rowspan="3" align="left"><img src="/app/img/logomarcas/LogoEmpresa.gif" width="50" height="50"></td>
    <td colspan="3" align="left"><strong><%=session("EmpresaWeb")%></strong></td>
    <td width="35%" colspan="2" rowspan="3" align="center"><strong><font size="2"><%=strTituloRelatorio%></font></strong>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" align="left" class="textoRelatorioMenor8"><%=session("EnderecoEmpresaWeb")%>, <%=session("BairroEmpresaWeb")%></td>
  </tr>
  <tr>
    <td colspan="3" align="left" class="textoRelatorioMenor8"><%=session("CidadeEmpresaWeb")%>-<%=session("ufEmpresaWeb")%>, <%=session("CepEmpresaWeb")%>&nbsp;&nbsp;-&nbsp;&nbsp;<%=session("TelefoneEmpresaWeb")%></td>
  </tr>
  
  <tr> 
    <td colspan="6" align="center"><hr size="1" color="#CCCCCC"></td>
  </tr>
    <%if trim(strOmiteDataImpressao) = "" then %>
  <tr>
    <td colspan="3" align="left"><span class="textoRelatorioMenor8">Data da Impress&atilde;o: <%=FormataDataAp(date)%>&nbsp;<%=time%></span></td>
    <td colspan="3" align="right"><span class="textoRelatorioMenor8">
      	<%if intPagina <>"" then%>
        P&aacute;gina <%=intPagina%>
        <%end if%>
        </span>
    </td>
  </tr>
    <%end if %>
 
</table>

