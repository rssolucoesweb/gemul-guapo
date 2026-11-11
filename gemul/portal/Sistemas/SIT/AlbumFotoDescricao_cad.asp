<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<script>
		function salvar(acao){
		
			if (frm.txtDescricao.value == "") {
				alert("A Descrição da Foto deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
		
			frm.action="AlbumFotoDescricao_cod.asp?acao=" + acao;
			frm.submit();
			return true;
 	}
</script>
<%	
	intCodId 				= Trim(Request.QueryString("CodFoto"))
	strDescricao			= Trim(Request.QueryString("Descricao"))
	
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

%>
<table width="98%" height="195" border="0" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="428" height="193" align="center">
	<form method="post" id="frm">
	  <table width="436" height="20" border="0" cellpadding="0" cellspacing="0">
        <tr valign="top">
          <td width="436" align="center" class="tituloPrincipal style2">Altera Descri&ccedil;&atilde;o da Foto </td>
        </tr>
      </table>
	  <table width="100%" border="0">
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><input name="txtCodId" type="hidden" id="txtCodId" class="text" size="10" value="<%=intCodId%>" maxlength="10" />          </td>
        </tr>
        <tr>
          <td class="TextoForm">Descri&ccedil;&atilde;o Foto: </td>
          <td><span class="texto">
            <input  class="text" type="text" name="txtDescricao" size="50" value="<%=strDescricao%>" maxlength="50">
          </span></td>
        </tr>
        <tr>
          <td  width="25%" class="TextoForm">&nbsp;</td>
          <td width="75%">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastroPopap.asp"--></td>
        </tr>
      </table>
	</form>
	</td>
  </tr>
</table>
</body>
</html>