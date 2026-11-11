<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td colspan="3" align="center"><%=session("CidadeEmpresaWeb")%>, <%=day(date)%> DE <%=UCASE(monthname(month(date)))%> DE <%=year(date)%>.</td>
	</tr>
  <tr>
	<td width="33%">&nbsp;</td>
	<td width="33%">&nbsp;</td>
	<td width="34%">&nbsp;</td>
	</tr>
  <tr>
    <% if session("NomeSecretariaEmpresaWeb") <> "" then %>
		<td align="center">________________________________________</td>
	<% else %>
	    <td align="center">&nbsp;</td>
    <% end if %>
	<td align="center">________________________________________</td>
	<td align="center">________________________________________</td>
  </tr>
  <tr>
    <% if session("NomeSecretariaEmpresaWeb") <> "" then %>
	   <td align="center"><strong><%=session("NomeSecretariaEmpresaWeb")%></strong></td>
	<% else %>
	    <td align="center">&nbsp;</td>
    <% end if %>
	<td align="center"><strong><%=session("NomeDiretorEmpresaWeb")%></strong></td>
	<td align="center"><strong>Responsável</strong></td>
  </tr>
  <tr>
    <% if session("NomeSecretariaEmpresaWeb") <> "" then %>
		<td align="center">Secret&aacute;rio(a)</td>
	<% else %>
	    <td align="center">&nbsp;</td>
    <% end if %>
	<td align="center">Diretor(a)</td>
	<td align="center"></td>
  </tr>
</table>
