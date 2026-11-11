<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td colspan="3" align="left">&nbsp;<%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</td>
  </tr>
  <tr>
    <td width="50%">&nbsp;</td>
    <td width="50%">&nbsp;</td>
	<td width="50%">&nbsp;</td>
	</tr>
  <tr>
    <td align="center">________________________________________</td>
    <td align="center">________________________________________</td>
	<td align="center">________________________________________</td>
  </tr>
  <tr>
    <td align="center"><strong><%=session("NomeSecretariaEmpresaWeb")%></strong></td>
    <td align="center"><strong><%=Session("NomeUsuarioWeb")%></strong></td>
	<td align="center"><strong><%=session("NomeDiretorEmpresaWeb")%></strong></td>
  </tr>
  <tr>
    <td align="center"><p>Secretaria Geral</p>
      <p><br />
    ____/____/________</p></td>
    <td align="center"><p>Funcion&aacute;rio(a)</p>
      <p><br />
    ____/____/________</p></td>
	<td align="center"><p>Diretor Geral</p>
	  <p><br />
    ____/____/________</p></td>
  </tr>
</table>
