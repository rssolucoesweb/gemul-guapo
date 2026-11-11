<%strNomeDaPaginaPortal = "Nome do Cadastro"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>

<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function nomeFuncao(){
		var frm = document.getElementById("frm");
		/*
		if (frm.CodExemplo.value==""){
			....	
		}
		*/
		
	}
</script>


<%  
'codigo fonte em ASP

		
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">
    
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
		<table width="96%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal">Resultado Enquete </td>
        </tr>
        <tr valign="top">
          <td align="left" >
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="100%" height="23" class="TextoForm"></tr>
			  <tr>
			    <td height="23" class="TextoForm">&nbsp;</tr>
			</table>
		  </td>

        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
      </table>

   	<!-- fim do formulario da pagina-->
    </form>
    
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>
