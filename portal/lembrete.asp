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
            Gemul Portal do Aluno - Lembrete
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
                <%item_ativo_lembrete 		= " class='active' "%>
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL</a></li>
                            <li class="breadcrumb-item">Painel</li>
                            <li class="breadcrumb-item active">Lembrete</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-tag'></i> Lembrete <sup class='badge badge-primary fw-500'>Interno</sup>
                                <small>
                                    Escreva seu lembrete e será mostrado no painel inicial
                                </small>
                            </h1>
                        </div>
                        
						<%

					ID_EMPRESA 			= Session("CodEmpresaAluno_GemulEad")
					DESCRICAO 			= REPLACE(REQUEST.FORM("DESCRICAO"),"'","")
					ASSUNTO 			= REPLACE(REQUEST.FORM("ASSUNTO"),"'","")
					acao				= Trim(Request.Form("acao"))
					'*****************
					'INCLUIR	
					'*****************
					if acao="I" then
						on error resume next
						sql = "INSERT INTO EAD_LEMBRETE (cod_empresa, cod_aluno, assunto, descricao, situacao, usuario_incl, data_hora_incl) VALUES ("
						sql = sql & "" & ID_EMPRESA & ","
						sql = sql & "" & Session("CodAluno_GemulEad") & ","
						sql = sql & "'" & ASSUNTO & "',"
						sql = sql & "'" & DESCRICAO & "',"
						sql = sql & "'V',"
						sql = sql & "'" & Session("NomeAluno_GemulEad") & "',GetDate())"
						cnn.execute sql
						if err.number = 0 then
							%>
							<div class="alert alert-success alert-dismissable">
								<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
								Registro cadastrado com sucesso!
							</div>
							<%
						else
							%>
							<div class="alert alert-danger alert-dismissable">
								<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
								Registro não pode ser cadastrado!
							</div>
							<%
							tratamentoErro
							err.clear
						end if
						acao = ""
						ASSUNTO = ""
						DESCRICAO = ""
					end if
					
					%>
					
                        <div class="row">
                            <div class="col-xl-10">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Lembrete
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            
                                            <form method="post" name="frm" id="frm">
											<input type="hidden" name="acao" id="acao" value="<%=acao%>">
                                                <div class="form-group">
                                                    <label class="form-label" for="simpleinput">Assunto</label>
                                                    <input type="text" id="assunto" name="assunto" class="form-control">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="example-textarea">Descrição</label>
                                                    <textarea class="form-control" id="descricao" name="descricao"  rows="5"></textarea>
                                                </div>
                                                
												<div class="d-flex flex-row">
												<%if acao = "" then acao="I"%>
                                                <a href="#" onClick="salvar('<%=acao%>')" class="btn btn-outline-primary">Salvar</a>
												</div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
						<div class="row">
                            <div class="col-xl-10">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Lembretes cadastrados
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
											<div class="table-responsive-lg">
												<table class="table m-0">
													<thead class="thead-themed">
													<tr>
														<th></th>
														<th>Assunto</th>
														<th>Situação</th>
														<th>Data/hora</th>
													</tr>
													</thead>
													<tbody>
													<%
													cont = 0
													SQL = "select ASSUNTO, DESCRICAO, case when SITUACAO = 'V' then 'Visível' else 'Oculto' end as situacao, data_hora_incl"
													SQL = SQL & " from EAD_LEMBRETE m "
													SQL = SQL & " WHERE cod_aluno=" & Session("CodAluno_GemulEad")
													SQL = SQL & " ORDER BY DATA_HORA_INCL DESC"
													RS.OPEN SQL, CNN
													IF RS.EOF = FALSE THEN
														while not rs.eof
															cont = cont + 1
															
															
															%>
															<tr> 
																<td><%=imagem%></td>
																<td><%=rs("ASSUNTO")%></td>
																<td><%=rs("situacao")%></td>
																<td><%=rs("data_hora_incl")%></td>
															</tr>
															<%

															rs.movenext
														wend
													END IF
													rs.close
													%>
													<tr>
													  <td colspan="4" >Lembretes cadastrados: <%=cont%></td>
													</tr>
													</tbody>
												</table>	
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
		<script src="js/lembrete.js"></script>
        <!-- Include a polyfill for ES6 Promises (optional) for IE11, UC Browser and Android browser support -->
        <script>
            $(document).ready(function()
            {

              

            });

        </script>
    </body>
</html>
