<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td colspan="2" align="center"><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</td>
	</tr>
  <tr>
	<td width="50%">&nbsp;</td>
	<td width="50%">&nbsp;</td>
	</tr>
  <tr>
    <% if session("NomeSecretariaEmpresaWeb") <> "" then %>
		<td align="center">________________________________________</td>
	<% else %>
	    <td align="center">&nbsp;</td>
    <% end if %>
	<td align="center">________________________________________</td>
  </tr>
  <tr>
    <% if session("NomeSecretariaEmpresaWeb") <> "" then %>
	   <td align="center"><strong><%=session("NomeSecretariaEmpresaWeb")%></strong></td>
	<% else %>
	    <td align="center">&nbsp;</td>
    <% end if %>
	<td align="center"><strong><%=session("NomeDiretorEmpresaWeb")%></strong></td>
  </tr>
  <tr>
    <% if session("NomeSecretariaEmpresaWeb") <> "" then %>
		<td align="center">Secret&aacute;rio(a)</td>
	<% else %>
	    <td align="center">&nbsp;</td>
    <% end if %>
	<td align="center">Diretor(a)</td>
  </tr>
</table>
