<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/geral.css" rel="stylesheet" />
    <title>Matrícula 2018 - Aparecida</title>
    
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-70820196-3"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    
      gtag('config', 'UA-70820196-3');
    </script>    

   <script>
	function salvar(acao){
		var frm = document.getElementById("frm");
		if (frm.txtLogin.value == ""){
			alert("O usuário deve ser informado");
			frm.txtLogin.focus();
			return false;
		}
		
		if (frm.txtSenha.value == ""){
			alert("A Senha deve ser informada");
			frm.txtSenha.focus();
			return false;
		}
		if (frm.txtSenha.value != frm.txtSenhaRepetir.value){
			alert("A nova senha informada não confere.");
			frm.txtSenha.value="";
			frm.txtSenhaRepetir.value="";
			frm.txtSenha.focus();
			return false;
		}
		
		if (frm.txtSenha.value != "") {
			if (frm.txtSenha.value.length < 6 ) {
				alert("A senha deve ter pelo menos 6 dígitos!");
				frm.txtSenha.value = "";
				frm.txtSenhaRepetir.value = "";
				frm.txtSenha.focus();
				return false;
			}
		} 
		
		frm.action = "usuarioMatAlterarSenhaTemporaria_cod.asp";
		frm.submit();
	}
</script> 
</head>
<body>

    <%
	if Session("senha_temporaria") <> "S" then 
		response.Redirect("index.html")
		response.end
	end if
	
	strLogin = Session("UsuarioWebMatriculaTemporario")
	%>
    
    
    <div class="container-fluid topo">
            <div class="row">
                    <img id="logoMatricula" src="img/topo.png" alt="Matrícula" vspace="15"  width="100%" height="100%" style="margin:auto" />
            </div>
    </div>
<form action="" name="frm" id="frm" method="post">
    <div class="container box-msg">
        <div class="row">
            <div class="col-md-12">
                <div class="alert alert-info alert-dismissible fade in" role="alert">
                     <table width="85%" border="0" cellspacing="0" cellpadding="0">
                       <tr>
                         <td colspan="2" class="texto5"><font color="#666666"><strong>ALTERA&Ccedil;&Atilde;O DE SENHA TEMPOR&Aacute;RIA</strong></font></td>
                       </tr>
                       <tr>
                         <td colspan="2" class="texto5">&nbsp;</td>
                       </tr>
                       <tr>
                         <td width="26%" height="35" class="texto5">Usu&aacute;rio:</td>
                         <td width="74%" class="texto5"><input readonly="readonly" name="txtLogin" type="text" class="text" id="txtLogin" value="<%=strLogin%>" size="20"></td>
                       </tr>
                       <tr>
                         <td height="35" class="texto5">NOVA Senha:</td>
                         <td class="texto5"><input name="txtSenha" type="password" class="text" id="txtSenha" size="20" /></td>
                       </tr>
                       <tr>
                         <td height="35" class="texto5">Repetir Senha:</td>
                         <td class="texto5"><input name="txtSenhaRepetir" type="password" class="text" id="txtSenhaRepetir" size="20" /></td>
                       </tr>
                       <tr>
                         <td height="35" colspan="2" class="texto5">&nbsp;</td>
                       </tr>
                     </table>
                                          <input type="button" class="btn btn-lg btn-success" name="btnInscricao" id="btnSalvar" value="Salvar" onClick="return salvar('<%=strAcao%>')" />

                 </div>
            </div>
        </div>
    </div>
</form>
    <!--div class="container alterar-btn marginb20px">
        <h4> Em caso de dúvidas, ligue para o telefone <strong> xxx xxxx xx   </strong>  </h4>
    </div -->

    <script src="js/jquery-2.1.3.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/index.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            index.inicialize();
        });
    </script>
</body>
</html>