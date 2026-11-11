<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul AVAP - Atividades
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
        <link rel="stylesheet" media="screen, print" href="css/notifications/sweetalert2/sweetalert2.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/theme-demo.css">
		<style>
			.corRespostaAzul{
				color: blue	
			}
			.corRespostaVermelho{
				color: red
			}
		</style>
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
                console.log("%c✔ Theme settings loaded", "color: #2196F3");
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
                <%
					item_ativo_turma 		= " class='active' "
					menu_ativo 				= " class='active open' "
				%>
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
                    
					<%
					if trim(Session("CodTurma_GemulEad")) = "" then
						%>
						<script>
							alert("ATENÇÃO: Você está sem turma, favor entrar em contato com a secretaria de sua unidade!");
							window.location='painel.asp';
						</script>	
						<%
						response.End()
					end if
					
					
					cod_disciplina = request("cd")
					if cod_disciplina = "" then cod_disciplina = "0"
					
					sql = " SELECT cod_disciplina, desc_disciplina" 
					sql = sql & " FROM sca_disciplina " 
					sql = sql & " Where cod_disciplina = " & cod_disciplina
					sql = sql & " And cod_empresa = " & Session("CodEmpresaAluno_GemulEad")
					RsAux.Open SQL, cnn
					if not  RsAux.EOF then
						desc_disciplina = RsAux("desc_disciplina")
					else
						desc_disciplina = "Interdisciplinar"
					end if
					RsAux.close
					
					%>
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
					<main id="js-page-content" role="main" class="page-content">
                    <form id="frm" method="post" action="questionario_cad.asp"  class="sky-form panel-body0">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">Avap Gemul</a></li>
                            <li class="breadcrumb-item">Meus Cursos</li>
                            <li class="breadcrumb-item active">Curso</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-list-ol'></i> Atividades <sup class='badge badge-primary fw-500'><%=Session("Curso_GemulEad")%> - <%=Session("Periodo_GemulEad")%></sup>
                                <small>
                                    Conteúdo com aulas, materiais de estudos e video
                                </small>
                            </h1>
                        </div>
                        
                        <div class="row">
                            <div class="col-xl-12">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            <%=desc_disciplina%> 
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <%
											SQL = "SELECT distinct TA.descricao as atividade, Convert(varchar(10),A.data_atividade,103) as data_atividade, A.titulo, A.descricao, A.link,A.link2,A.link3,A.link4,A.link5, A.data_hora_incl, A.cod_atividade_pai"
											SQL = SQL & " FROM EAD_Atividade_pai A"
											SQL = SQL & " INNER JOIN EAD_Atividade TIV ON TIV.cod_atividade_pai = A.cod_atividade_pai"
											SQL = SQL & " INNER JOIN EAD_Tipo_Atividade TA ON TA.cod_tipo_atividade = A.cod_tipo_atividade"
											SQL = SQL & " LEFT JOIN EAD_Tipo_Link TL ON TL.cod_tipo_link = A.cod_tipo_link"
											SQL = SQL & " WHERE TIV.cod_turma = " & Session("CodTurma_GemulEad")
											SQL = SQL & " AND a.situacao = 'A'"
											if cod_disciplina <> "0" then
												SQL = SQL & " AND TIV.cod_disciplina = " & cod_disciplina
											end if
											SQL = SQL & " ORDER BY data_atividade, TA.descricao, A.cod_atividade_pai"
											RS.OPEN SQL, CNN
											CONT = 0
											CONT_DEFAULT = 0
											ATV = 0
											%>
											<div class="accordion accordion-hover" id="js_demo_accordion-5">
											<%
											IF NOT RS.EOF THEN
											
												expandir = "collapse show"
												expanded = "true"
												collapsed = "card-title"
												expandir_default = "collapse"
												expanded_default = "false"
												collapsed_default = "card-title collapsed"
												atividade = ""
												WHILE NOT RS.EOF 
													CONT = CONT + 1
													CONT_DEFAULT = CONT_DEFAULT + 1
													ATV = ATV + 1
													if data_atividade <> ucase(RS("data_atividade")) then
														if cont > 1 then
														%>	
																				
																		</div>	
																</div>
															</div>
														</div>
														<%
															ATV = 1
														end if
														%>					
												
													<div class="card">
														<div class="card-header">
															<a href="javascript:void(0);" class="<%=collapsed%>" data-toggle="collapse" data-target="#js_demo_accordion-5_<%=CONT%>" aria-expanded="<%=expanded%>">
																<%IF ucase(RS("atividade")) = "ATIVIDADE" THEN%>
																	<i class="fal fa-clipboard-list width-2 fs-xl"></i>
																<%ELSEIF ucase(RS("atividade")) = "AULA" THEN%>
																	<i class="fal fa-file-video width-2 fs-xl"></i>
																<%ELSE%>
																	<i class="fal fa-book width-2 fs-xl"></i>
																<%END IF%>
																<%=RS("data_atividade")%> 
																<span class="ml-auto">
																	<span class="collapsed-reveal">
																		<i class="fal fa-chevron-up fs-xl"></i>
																	</span>
																	<span class="collapsed-hidden">
																		<i class="fal fa-chevron-down fs-xl"></i>
																	</span>
																</span>
															</a>
														</div>
														
														<div id="js_demo_accordion-5_<%=CONT%>" class="<%=expandir%>" data-parent="#js_demo_accordion-5">
															<div class="card-body">
																
																		<div class="accordion" id="js_demo_accordion-2">
																			
														<%
														end if
														%>
																			
																			
																			<div class="card">
																				<div class="card-header">
																					<a href="javascript:void(0);" class="<%=collapsed_default%>" data-toggle="collapse" data-target="#js_demo_accordion-2_<%=CONT_DEFAULT%>" aria-expanded="<%=expanded_default%>">
																						<span class="d-inline-flex border border-success text-success width-1 height-1 rounded-circle fw-500 mr-2 align-items-center justify-content-center"><%=ATV%></span><%=ucase(RS("atividade"))%> - <%=RS("TITULO")%> 
																					</a>
																				</div>
																				<div id="js_demo_accordion-2_<%=CONT_DEFAULT%>" class="<%=expandir_default%>" data-parent="#js_demo_accordion-2">
																					<div class="card-body">
																						<%=RS("descricao")%>
																						<br><br><span class="fw-300"><i>Postado em <%=RS("data_hora_incl")%></i></span>
																					</div>
																					<div align="center">
																					
																						<%if not isnull(RS("LINK")) and RS("LINK") <>"" then%>
																							<a href="<%=RS("LINK")%>" target="_blank" class="btn btn-outline-primary"><i class="fal fa-link width-2 fs-xl"></i>Acessar 1º link</a>&nbsp;
																						<%end if%>
																						<%if not isnull(RS("LINK2")) and RS("LINK2") <>"" then%>
																							<a href="<%=RS("LINK2")%>" target="_blank" class="btn btn-outline-primary"><i class="fal fa-link width-2 fs-xl"></i>Acessar 2º link</a>&nbsp;
																						<%end if%>
																						<%if not isnull(RS("LINK3")) and RS("LINK3") <>"" then%>
																							<a href="<%=RS("LINK3")%>" target="_blank" class="btn btn-outline-primary"><i class="fal fa-link width-2 fs-xl"></i>Acessar 3º link</a>&nbsp;
																						<%end if%>
																						<%if not isnull(RS("LINK4")) and RS("LINK4") <>"" then%>
																							<a href="<%=RS("LINK4")%>" target="_blank" class="btn btn-outline-primary"><i class="fal fa-link width-2 fs-xl"></i>Acessar 4º link</a>&nbsp;
																						<%end if%>
																						<%if not isnull(RS("LINK5")) and RS("LINK5") <>"" then%>
																							<a href="<%=RS("LINK5")%>" target="_blank" class="btn btn-outline-primary"><i class="fal fa-link width-2 fs-xl"></i>Acessar 5º link</a>&nbsp;
																						<%end if%>
																						
																						<%IF ucase(RS("atividade")) = "ATIVIDADE" THEN%>
																						<br><br>
																						<a href="enviar_foto.asp?cd=<%=cod_disciplina%>&id_atv=<%=rs("cod_atividade_pai")%>" class="btn btn-outline-success"><i class="fal fa-upload width-2 fs-xl"></i>Enviar Arquivo</a>
																						<br><br>
																						<a href="respostas.asp?cd=<%=cod_disciplina%>&id_atv=<%=rs("cod_atividade_pai")%>" class="btn btn-outline-info"><i class="fal fa-clipboard-list width-2 fs-xl"></i>Ver respostas</a>
																						<%end if%>
																					</div>
																					<br>
																					<br>
																				</div>
																			</div>
																			
																			
																			
														<%
													cod_atividade_pai = rs("cod_atividade_pai")
													if data_atividade <> ucase(RS("data_atividade")) then
														GravarLogEaD "Acesso a atividade: " & ucase(RS("atividade")),cod_atividade_pai,0,0,0
													end if
													data_atividade = ucase(RS("data_atividade"))
													
													RS.MOVENEXT
														
													expandir = "collapse"
													expanded = "false"
													collapsed = "card-title collapsed"
													
													expandir_default = "collapse"
													expanded_default = "false"
													collapsed_default = "card-title collapsed"
													
												WEND
												%>						
																		
																	
															</div>
														</div>
													</div>
												</div>
												<%
												
											ELSE
												CONT = CONT + 1
												CONT_DEFAULT = CONT_DEFAULT + 1
												ATV = ATV + 1
												expandir = "collapse show"
												expanded = "true"
												collapsed = "card-title"
												expandir_default = "collapse"
												expanded_default = "false"
												collapsed_default = "card-title collapsed"
												atividade = ""
											END IF
											RS.CLOSE
											%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
						<input type="hidden" name="cd" id="cd" value="<%=cod_disciplina%>">
					</form>
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
        <!-- Include a polyfill for ES6 Promises (optional) for IE11, UC Browser and Android browser support -->
        <script>
            $(document).ready(function()
            {

              

            });

        </script>
		
		
    </body>
</html>
