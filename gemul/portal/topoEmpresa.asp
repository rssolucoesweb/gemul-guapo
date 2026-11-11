<!--#include file="topoLogado.asp"-->
<table  width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <th height="149" scope="col">
    
    <table width="900" align="center" border="0" cellpadding="0" cellspacing="0">
      <tr valign="top">
        <td height="149" background="../images/FundoTopo.png">
        <table width="94%" align="center" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="10"></td>
            <td colspan="2" align="right" class="tituloPrincipal"></td>
          </tr>
          <tr valign="top">
            	  <%
		  if trim(request.ServerVariables("SERVER_NAME")) = "www.gemul-canedo.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul-canedo.com.br" then
		  %>
            <td width="24%" rowspan="4" valign="middle"><img src="../images/Grupo/canedo.png" alt=""width="180" height="78" /></td>
			<%else%>
            <td width="24%" rowspan="4" valign="middle"><img src="../images/Grupo/<%=session("codGrupo")%>/<%=session("codGrupo")%>.png" alt=""width="180" height="78" /></td>
		<%end if%>
			
			
            <td width="51%" align="right" class="tituloPrincipal">&nbsp;</td>
            <td width="25%" rowspan="2" align="right" class="tituloPrincipal"><img src="../images/logo.png" alt="" height="51" /></td>
          </tr>
          <tr valign="top">
            <td rowspan="2" align="left" valign="middle" class="tituloPrincipalGrupo"></td>
          </tr>
          <tr>
            <td height="19" align="left" class="tituloPrincipal">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" align="right" class="tituloPrincipal">Acesso as Unidades</td>
          </tr>
        </table></td>
      </tr>
    </table></th>
  </tr>
</table>
