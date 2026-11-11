<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!DOCTYPE html>
<html lang="pt">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul EAD - Ler Mensagem
        </title>
        <meta name="description" content="SweetAlert2">
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
        <link rel="stylesheet" media="screen, print" href="css/	/sweetalert2/sweetalert2.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/theme-demo.css">
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
                console.log("%c✔ Theme settings loaded", "color: #148f32");
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
                <%item_ativo_mensagem 		= " class='active' "%>
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
                    
					<form method="post" name="frm" id="frm">
					<input type="hidden" name="acao" id="acao" value="<%=acao%>">
					<input type="hidden" name="id" id="id" value="<%=id%>">
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">EAD Gemul</a></li>
                            <li class="breadcrumb-item">Painel</li>
                            <li class="breadcrumb-item active">Inicial</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-bullhorn'></i> Ler Mensagem 
                                <small>
                                    Ler mensagem enviada para você
                                </small>
                            </h1>
                        </div>
                        
						<%

					ID_EMPRESA 			= Session("CodEmpresaAluno_GemulEad")
					cod_colaborador		= REQUEST("c")
					cod_mensagem		= REQUEST("id")
					
					SQL = "select m.ASSUNTO, m.DESCRICAO, c.nome, m.cod_mensagem as cod_mensagem_pai,"
					SQL = SQL & " case "
					SQL = SQL & "		when m.usuario_incl_colaborador = '0' then 'SEDUC'"
					SQL = SQL & "		when c.nome is not null then SUBSTRING(C.NOME, 0, CHARINDEX(' ', C.NOME)) + ' ' +  REVERSE(SUBSTRING(REVERSE(C.NOME), 0, CHARINDEX(' ', REVERSE(C.NOME))))"
					SQL = SQL & "		else a.nomealuno "
					SQL = SQL & "		end as enviado, "
					SQL = SQL & "		m.data_hora_incl 	"				
					SQL = SQL & " from EAD_MENSAGEM m "
					SQL = SQL & " left join srh_colaborador c on c.codigo = m.usuario_incl_colaborador "
					SQL = SQL & " left join sca_aluno a on a.codigo = m.usuario_incl_aluno "
					SQL = SQL & " WHERE m.cod_aluno=" & Session("CodAluno_GemulEad")
					SQL = SQL & " and m.cod_mensagem = " & cod_mensagem
					SQL = SQL & " ORDER BY DESCRICAO"
					RS.OPEN SQL, CNN
					IF RS.EOF = FALSE THEN
						enviado 	= rs("enviado")
						assunto 	= rs("ASSUNTO")
						mensagem 	= rs("DESCRICAO")
						data_hora_incl = rs("data_hora_incl")
						cod_mensagem_pai = rs("cod_mensagem_pai")
					END IF
					RS.CLOSE
					
					SQL = "update EAD_MENSAGEM set situacao = 'L', data_situacao = getdate() "
					SQL = SQL & " WHERE cod_mensagem = " & cod_mensagem
					cnn.execute SQL
					
					%>
					
                        <div class="row">
                            <div class="col-xl-10">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            <%=enviado%> - <%=assunto%> <span class="fw-300"><i><%=data_hora_incl%></i></span>
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
											<br>
											<%=mensagem%>
											<br>
											<br>
											<div align="center"><a href="#" onClick="editarMensagem('<%=cod_mensagem_pai%>')" class="btn btn-outline-success">Responder</a></div>
											<BR>
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
				</form>
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
		<script src="js/mensagem.js"></script>
        <!-- Include a polyfill for ES6 Promises (optional) for IE11, UC Browser and Android browser support -->
        <script>
            $(document).ready(function()
            {

              

            });
			function editarMensagem(id){
				var frm = document.getElementById("frm");
				frm.id.value=id;
				frm.action="mensagem.asp";
				frm.submit();
			}
        </script>
    </body>
</html>
