<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../includes/inc_verificaLoginAluno.asp"-->
<!--#include file="topo.asp"-->
<!--#include file="../../includes/inc_cnnGedu.asp"-->
<!--#include file="../includes/inc_cmdVerificaAvaliacao.asp"-->

<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if(frm.txtEmail.value == ""){
			alert("O E-mail deve ser informado!");
			frm.txtEmail.focus();
			return false		
		}
			
		frm.action= "Aluno_Cod.asp?acao="+acao;
		frm.submit();
		return true;
	}
</script>
<%
	principal			= "principal.asp"
	strLogin 			= Trim(Request("txtLogin"))
	strEmail		 	= Trim(Request("txtEmail"))
		
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
%>
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
  <tr valign="top">
    <td width="746" align="center">
	<form method="post" id="frm">
	  <table width="96%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal">Dados do Aluno</td>
        </tr>
        <tr valign="top">
          <td align="left" ><!-- inicio tabela de cadastro de funcionario -->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="6" class="TextoForm">&nbsp;</td>
                </tr>
                <tr>
                  <td width="16%" height="23" class="TextoForm">Matricula:</td>
                  <td width="25" colspan="4" class="TextoForm"><input name="txtLogin" readonly ="false" type="text" class="text" id="txtLogin" size="10" maxlength="12"  value="<%=Session("Matricula")%>" ></td>
                  <td width="17%" class="TextoForm">&nbsp;</td>
                </tr>
                <tr>
                  <td height="24" class="TextoForm">E-mail: </td>
                  <td colspan="4" class="TextoForm"><input name="txtEmail" type="text"  class="text" id="txtEmail" size="50" maxlength="70" value="<%=Session("email")%>"></td>
                  <td class="TextoForm">&nbsp;</td>
                </tr>
              </table>
            <!-- fim tabela de cadastro de funcionario -->
          </td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><!--#include file="../../includes/inc_botoes_cadastro.asp"-->
            &nbsp;</td>
        </tr>
      </table>
	</form>
	</td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>