<script language="JavaScript">
	function verificaTecla(){
		if (window.event.keyCode==13)
			return validaCampo()
	}

	function validaCampo(){
		if (document.getElementById("txtLogin").value==""){
			alert("O CPF deve ser informado!");
			document.getElementById("txtLogin").focus();
			return false;
		}
		
		frm.action = "portal/validaPermissao.asp"
		frm.submit();
		return true;
	}
</script>
<table  width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <th height="36" scope="col" background="images/BarraTopo.png">&nbsp;</th>
  </tr>
  <tr valign="top">
    <th height="165" scope="col">
    
    <table width="900" align="center" border="0" cellpadding="0" cellspacing="0">
      <tr valign="top">
        <td height="165" background="images/FundoTopo.png">
        
        <table width="94%" align="center" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="43%" align="center"><img src="images/grupo/grupo.gif" alt="" /></td>
            <td  valign="top">
            
                  

            
            </td>
          </tr>
          <tr>
            <td align="center">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">&nbsp;</td>
            <td align="right" class="tituloPrincipal"><%=strTituloPagina%></td>
          </tr>
        </table></td>
      </tr>
    </table></th>
  </tr>
</table>
