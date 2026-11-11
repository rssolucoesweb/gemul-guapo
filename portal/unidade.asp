<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul Portal do Aluno - Ficha do aluno 
        </title>
        <meta name="description" content="Basic Tables">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no, minimal-ui">
        <!-- Call App Mode on ios devices -->
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <!-- Remove Tap Highlight on Windows Phone IE -->
        <meta name="msapplication-tap-highlight" content="no">
        <!-- base css -->
        <link rel="stylesheet" media="screen, print" href="css/vendors.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/app.bundle.css">
        <!-- Place favicon.ico in the root directory -->
        <link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
        <link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg" color="#5bbad5">
		<link id="myskin" rel="stylesheet" media="screen, print" href="css/themes/cust-theme-4.css">
    </head>
    <body class="mod-bg-1 ">
        <!-- DOC: script to save and load page settings -->
        <script>
            /**
             *	This script should be placed right after the body tag for fast execution 
             *	Note: the script is written in pure javascript and does not depend on thirdparty library
             **/
            'use strict';

            var classHolder = document.getElementsByTagName("BODY")[0],
                /** 
                 * Load from localstorage
                 **/
                themeSettings = (localStorage.getItem('themeSettings')) ? JSON.parse(localStorage.getItem('themeSettings')) :
                {},
                themeURL = themeSettings.themeURL || '',
                themeOptions = themeSettings.themeOptions || '';
            /** 
             * Load theme options
             **/
            if (themeSettings.themeOptions)
            {
                classHolder.className = themeSettings.themeOptions;
                console.log("%c? Theme settings loaded", "color: #148f32");
            }
            else
            {
                console.log("Heads up! Theme settings is empty or does not exist, loading default settings...");
            }
            if (themeSettings.themeURL && !document.getElementById('mytheme'))
            {
                var cssfile = document.createElement('link');
                cssfile.id = 'mytheme';
                cssfile.rel = 'stylesheet';
                cssfile.href = themeURL;
                document.getElementsByTagName('head')[0].appendChild(cssfile);
            }
            /** 
             * Save to localstorage 
             **/
            var saveSettings = function()
            {
                themeSettings.themeOptions = String(classHolder.className).split(/[^\w-]+/).filter(function(item)
                {
                    return /^(nav|header|mod|display)-/i.test(item);
                }).join(' ');
                if (document.getElementById('mytheme'))
                {
                    themeSettings.themeURL = document.getElementById('mytheme').getAttribute("href");
                };
                localStorage.setItem('themeSettings', JSON.stringify(themeSettings));
            }
            /** 
             * Reset settings
             **/
            var resetSettings = function()
            {
                localStorage.setItem("themeSettings", "");
            }

        </script>
        <!-- BEGIN Page Wrapper -->
        <div class="page-wrapper">
            <div class="page-inner">
			<%item_ativo_unidade		= " class='active' "%>
			
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
				
					<!--#include file="inc_cabecalho_pagina.asp"-->
				
                    
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL</a></li>
                            <li class="breadcrumb-item">Unidade</li>
                            <li class="breadcrumb-item active">Escolar</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon ni ni-bag'></i> Dados da Unidade Escolar
                                <small>
                                    Unidade do aluno
                                </small>
                            </h1>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
<%


	strCod_empresa = Session("CodEmpresaAluno_GemulEad")
	
	sql = " select CODIGO_CENSO, razaosocial, diretor, secretaria,ENDERECO, bairro, MUNICIPIO, uf, cep, TELEFONE, EMAIL_DIRETORIA, Email_Secretario from SEG_EMPRESA where codigo =" & strCod_empresa
	rs.open sql, cnn
	if rs.eof = false then
		CODIGO_CENSO	= TRIM(rs("CODIGO_CENSO"))
		EMPRESA			= UCASE(TRIM(rs("razaosocial")))
		DIRETOR 		= UCASE(TRIM(rs("diretor")))
		SECRETARIO 		= UCASE(TRIM(rs("secretaria")))
		ENDERECO 		= UCASE(TRIM(rs("ENDERECO")))
		BAIRRO	 		= UCASE(TRIM(rs("bairro")))
		MUNICIPIO 		= UCASE(TRIM(rs("MUNICIPIO")))
		UF		 		= UCASE(TRIM(rs("UF")))
		CEP 			= TRIM(rs("CEP"))
		TELEFONE 		= TRIM(rs("TELEFONE"))
		EMAIL_DIRETORIA = TRIM(rs("EMAIL_DIRETORIA"))
		Email_Secretario = TRIM(rs("Email_Secretario"))
				%>
				
				<!--Table hover-->
                                <div id="panel-5" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Dados da Unidade de Ensino
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <div class="frame-wrap">
											
											<div class="table-responsive-lg">
				
				
				
					<table class="table table-bordered table-hover m-0">
					  <tr valign="top">
						<td colspan="2" align="center">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS PESSOAIS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td >&nbsp;Código do MEC: </td>
									<td><strong><%=CODIGO_CENSO%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Nome da Unidade: </td>
									<td><strong><%=EMPRESA%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Telefone: </td>
									<td><strong><%=TELEFONE%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Endereço: </td>
									<td><strong><%=ENDERECO%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Bairro: </td>
									<td><strong><%=BAIRRO%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Município: </td>
									<td><strong><%=MUNICIPIO%>-<%=UF%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;CEP: </td>
									<td><strong><%=CEP%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Telefone: </td>
									<td><strong><%=TELEFONE%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Diretor(a): </td>
									<td><strong><%=DIRETOR%></strong></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Secretario(a): </td>
									<td><strong><%=Secretario%></strong></td>
								  </tr>
								  
								</table>
								</td>
						  </tr>
						  
						</table>
											
			<%
			end if
			rs.close
			%>								
											<br>
											<br>
											<br>
											<br>
											<br>
											</div>
                                            
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </main>
                    <!-- this overlay is activated only when mobile menu is triggered -->
                    <div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div> <!-- END Page Content -->
                    
					<!--#include file="inc_rodape.asp"-->
					
					<!--#include file="inc_acesso_top.asp"-->
                </div>
            </div>
        </div>
        <!-- END Page Wrapper -->
        
		<!--#include file="inc_menu_impressao.asp"-->
		
        <!-- base vendor bundle: 
			 DOC: if you remove pace.js from core please note on Internet Explorer some CSS animations may execute before a page is fully loaded, resulting 'jump' animations 
						+ pace.js (recommended)
						+ jquery.js (core)
						+ jquery-ui-cust.js (core)
						+ popper.js (core)
						+ bootstrap.js (core)
						+ slimscroll.js (extension)
						+ app.navigation.js (core)
						+ ba-throttle-debounce.js (core)
						+ waves.js (extension)
						+ smartpanels.js (extension)
						+ src/../jquery-snippets.js (core) -->
        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
    </body>
</html>
