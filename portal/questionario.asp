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
            GEMUL - AVAP - Questionário
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
					
					cod_questionario = request("cod_questionario")
					
					%>
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
					<main id="js-page-content" role="main" class="page-content">
                    <form id="frm" method="post" action="questionario_cad.asp"  class="sky-form panel-body0">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL - AVAP</a></li>
                            <li class="breadcrumb-item">Meus Cursos</li>
                            <li class="breadcrumb-item active">Curso</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-list-ol'></i> Questionários <sup class='badge badge-primary fw-500'><%=Session("Curso_GemulEad")%> - <%=Session("Periodo_GemulEad")%></sup>
                                <small>
                                    Questionários
                                </small>
                            </h1>
                        </div>
                        
                        <div class="row">
                            <div class="col-xl-12">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
										Questionários da <%=Session("Turma_GemulEad")%> - <%=Session("Periodo_GemulEad")%> - <%=Session("Curso_GemulEad")%>
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <%
											
											if cod_questionario = "" then cod_questionario = 0
											SQL = "select	q.codigo as cod_questionario, q.nome as questionario, q.descricao as instrucoes,"
											SQL = SQL & " 		p.codigo as cod_pergunta, p.nome as pergunta,"
											SQL = SQL & " 		r.codigo as cod_resposta, r.nome as resposta,"
											SQL = SQL & " 		r.cod_tipo_resposta, q.data_hora_incl, r.correta,"
											SQL = SQL & "                (select re.cod_aluno"
											SQL = SQL & "                from EAD_resposta resp"
											SQL = SQL & "                inner join EAD_resultado_respostas rr on resp.codigo = rr.cod_resposta"
											SQL = SQL & "                inner join EAD_resultado re on re.codigo = rr.cod_resultado "
											SQL = SQL & "                WHERE resp.cod_pergunta=r.cod_pergunta and resp.codigo = r.codigo"
											SQL = SQL & "                and re.cod_aluno = " & Session("CodAluno_GemulEad")
											SQL = SQL & "                ) as resposta_aluno"
											SQL = SQL & " from ead_questionario q"
											SQL = SQL & " inner join ead_questionario_turma qt on qt.cod_questionario = q.codigo"
											SQL = SQL & " inner join EAD_pergunta p on p.cod_questionario = q.codigo"
											SQL = SQL & " inner join EAD_resposta r on r.cod_pergunta = p.codigo"
											SQL = SQL & " "
											SQL = SQL & " where q.cod_empresa = " & Session("CodEmpresaAluno_GemulEad")
											SQL = SQL & " and qt.cod_turma = " & Session("CodTurma_GemulEad")
											SQL = SQL & " and q.codigo = " & cod_questionario
											SQL = SQL & " order by q.codigo, p.ordem, r.ordem"
											RS.OPEN SQL, CNN
											CONT = 0
											CONT_DEFAULT = 0
											ATV = 0
											%>
											<div class="accordion accordion-hover" id="js_demo_accordion-5">
											<%
											cod_questionario_log = cod_questionario
											cod_questionario = ""
											'----	QUESTIONARIO ------
											cod_pergunta = 0
											controle_questionario = "S"
											IF NOT RS.EOF THEN
												
												GravarLogEaD "Acesso ao questionário" & rs("questionario"),0,0,cod_questionario_log,0
												
												
												expandir = "collapse show"
												expanded = "true"
												collapsed = "card-title"
												expandir_default = "collapse"
												expanded_default = "false"
												collapsed_default = "card-title collapsed"
												atividade = ""
												WHILE NOT RS.EOF 
													CONT = CONT + 1
													
													
													if trim(cod_questionario) <> trim(RS("cod_questionario")) then
														cod_resultado = 0
														bloqueio = ""
														'verifica se o questionario já foi respondido
														SQL = "select codigo as cod_resultado from EAD_resultado"
														SQL = SQL & " where cod_questionario = " & RS("cod_questionario")
														SQL = SQL & " and cod_aluno = " & Session("CodAluno_GemulEad")
														RSAUX.OPEN SQL, CNN
														IF NOT RSAUX.EOF THEN
															cod_resultado = RSAUX("cod_resultado")
															bloqueio = " disabled "
														END IF
														RSAUX.CLOSE
														
														if cont > 1 and controle_questionario = "N" then
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
																	<i class="fal fa-clipboard-list width-2 fs-xl"></i>
																<%=ucase(RS("questionario"))%>
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
																
																		<div class="accordion" id="js_demo_accordion-3">
																			
														<%
														end if
														%>
																			
														<%if trim(cod_pergunta) <> trim(rs("cod_pergunta")) then
														ATV = ATV + 1
														CONT_DEFAULT = CONT_DEFAULT + 1
														%>

																			<div class="card">
																				<div class="card-header">
																					<a href="javascript:void(0);" class="<%=collapsed_default%>" data-toggle="collapse" data-target="#js_demo_accordion-3_<%=CONT_DEFAULT%>" aria-expanded="<%=expanded_default%>">
																						<span class="d-inline-flex border border-success text-success width-1 height-1 rounded-circle fw-500 mr-2 align-items-center justify-content-center"><%=ATV%></span> <%=RS("pergunta")%> 
																					</a>
																				</div>
																				<div id="js_demo_accordion-3_<%=CONT_DEFAULT%>" class="<%=expandir_default%>" data-parent="#js_demo_accordion-3">
																					<div class="card-body">
																						<%=RS("instrucoes")%>
																						<br>																				
																						<br>
														<%end if%>
														
														<%if trim(rs("cod_tipo_resposta"))<>"1" then%>
															<%
															corResposta = ""
															respostaAtual = ""
															if not isnull(rs("resposta_aluno")) and rs("correta")="S" then corResposta = "corRespostaAzul"
															if not isnull(rs("resposta_aluno")) and rs("correta")="N" then corResposta = "corRespostaVermelho"
															if not isnull(rs("resposta_aluno")) then respostaAtual = "checked"
															if rs("correta")="S" then corResposta = "corRespostaAzul"
															if bloqueio = "" then corResposta = ""
															%>
															  <span class="<%=corResposta%>"><input <%=respostaAtual%> type="radio" <%=bloqueio%> name="pergunta_<%=rs("cod_pergunta")%>" value="<%=rs("cod_resposta")%>"> <strong><%=rs("resposta")%></strong></span>
															  <br>
														<%else
															resposta_texto=""
															sql = "select t.resposta "
															sql = sql & " from EAD_resultado_respostas_texto t"
															sql = sql & " inner join EAD_resultado_respostas r on r.Codigo = t.cod_resultado_respostas"
															sql = sql & " inner join ead_resultado re on re.codigo = r.cod_resultado"
															sql = sql & " where re.cod_aluno = " & Session("CodAluno_GemulEad")
															sql = sql & " and r.cod_pergunta=" & rs("cod_pergunta")
															sql = sql & " and re.cod_questionario = " & rs("cod_questionario")
															RSAUX.OPEN SQL, CNN
															IF NOT RSAUX.EOF THEN
																resposta_texto = RSAUX("resposta")
															END IF
															RSAUX.CLOSE												
														%>
															<div class="row">
																<section class="col col-12">
																	<label class="input">
																		<input type="hidden" name="pergunta_<%=rs("cod_pergunta")%>" value="<%=rs("cod_resposta")%>">
																		<textarea <%=bloqueio%> name="resposta_pergunta_<%=rs("cod_pergunta")%>" class="form-control"  cols="144" rows="3"><%=resposta_texto%></textarea>
																	</label>
																 </section>
															</div>
														<%end if%>
																					
														<%
													cod_questionario = RS("cod_questionario")
													cod_pergunta = RS("cod_pergunta")
													controle_questionario = "N"
													
													
													RS.MOVENEXT
													if not rs.eof then
														if trim(cod_pergunta) <> trim(rs("cod_pergunta")) then							
															%>						
																		</div>
																	</div>
																</div>
															<%				
														end if
													else
														%>						
																</div>
															</div>
														<%
														IF cod_resultado = "0" THEN
															%>
															<br>
															<div align="center"><a href="#" onClick="salvarQuestionario(<%=cod_questionario%>)" class="btn btn-outline-success">Salvar e enviar questionário </a></div>
															<br>
															<%
														END IF
													end if
														
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
		
		<script>
            function salvarQuestionario(id) {
				var frm = document.getElementById("frm");
				
				if (confirm("Deseja realmente salvar e enviar o questionário, após o envio ele não poderá ser mais alterado?")) {
					frm.action="questionario_cod.asp?id=" + id;
					frm.submit();
					return true;
				}
				
				
			
			}
        </script>
    </body>
</html>
