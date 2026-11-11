<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
             Portal do Aluno 
        </title>
        <meta name="description" content="Login">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no, minimal-ui">
        <!-- Call App Mode on ios devices -->
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <!-- Remove Tap Highlight on Windows Phone IE -->
        <meta name="msapplication-tap-highlight" content="no">
        <!-- base css -->
        <link rel="stylesheet" media="screen, print" href="css/vendors.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/app.bundle.css">
		<link id="myskin" rel="stylesheet" media="screen, print" href="css/themes/cust-theme-4.css">
        <!-- Place favicon.ico in the root directory -->
        <link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
        <link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg" color="#5bbad5">
        <!-- Optional: page related CSS-->
        <link rel="stylesheet" media="screen, print" href="css/page-login.css">
    </head>
	<%
	'Apaga todas as sessions
	session.Contents.removeAll()
	%>
	<body>
        <div class="blankpage-form-field">
            <div class="page-logo m-0 w-100 align-items-center justify-content-center rounded border-bottom-left-radius-0 border-bottom-right-radius-0 px-4">
                <a href="javascript:void(0)" class="page-logo-link press-scale-down d-flex align-items-center">
                    <img src="img/logo.png" alt="SmartAdmin WebApp" aria-roledescription="logo">
                    <span class="page-logo-text mr-1">GEMUL - Portal do Aluno</span>
                    <i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>
                </a>
            </div>
            <div class="card p-4 border-top-left-radius-0 border-top-right-radius-0">
                <form name="frm"  id="frm"  action="valida_acesso.asp" method="post" >
                    <div class="form-group">
                        <label class="form-label" for="username">Usuário</label>
                        <input type="text" id="txtLogin" name="txtLogin" class="form-control" placeholder="Usuário" value="<%=request.cookies("usuarioLoginGemulEAD")%>">
                        <span class="help-block">
                            matrícula do aluno                         </span>
                    </div>
					<div class="form-group">
                        <label class="form-label" for="username">Código</label>
                        <input type="text" id="txtCodSeguranca" name="txtCodSeguranca" class="form-control" placeholder="Código de segurança" value="<%=request.cookies("CodSegurancaLoginGemulEAD")%>">
                        <span class="help-block">
                            Código de segurança
                        </span>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="password">Senha</label>
                        <input type="password" name="txtSenha" id="txtSenha" class="form-control" placeholder="senha" value="">
                        <span class="help-block">
                            Sua senha
                        </span>
                    </div>
                    <button type="submit" class="btn btn-default float-right">Acessar</button>
                </form>
            </div>
        </div>
        
    </body>
</html>
