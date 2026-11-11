<%strNomeDaPaginaPortal = "Menu Principal"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="365" bgcolor="#FFFFFF" valign="top"><br>
<br>

    <%	if isnull(Session("CodSecao")) then %>
		<script>
			alert("Seção do usuário não foi selecionada, acesse o modulo portal de segurança no cadastro do usuário e seleciona a sua seção.\nApós a alteração da seção, acesse novamente o sistema com usuário e senha.");
			window.location='../../validaModulo.asp';
        </script>
    <%		
			response.End()
		end if%>
    <!-- estoque minino -->
	<!--#include file="mostraEstoqueMinimo.asp"-->
    
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>