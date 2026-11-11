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
            <td width="43%" align="center"><img src="images/logo.png" alt="" /></td>
            <td  valign="top">
            
                  <form method="post" name="frm" id="frm">
                    <table width="419" align="center" >
                    <tr>
                      <td width="86" align="right"><span class="TextoForm"><strong>Usu&aacute;rio : </strong></span></td>
                      <td width="123"><input name="txtLogin" type="text" class="text" id="txtLogin" value="<%=request.cookies("usuarioLoginPortal")%>" onBlur="validaCPF(this)" onKeyPress="return formataCampo(this, 5, 14)" size="15" maxlength="14"></td>
                      <td width="58"><span class="TextoForm"><strong>Senha : </strong></span></td>
                      <td width="66"><input name="txtSenha" type="password" class="text" id="txtSenha" size="10"  onKeyPress="return verificaTecla()"/></td>
                      <td width="62"><input name="cmdOK" type="button" class="botao" id="cmdOK" value="  OK  "  onClick="return validaCampo()" /></td>
                    </tr>
                  </table>
                  </form>

            
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
