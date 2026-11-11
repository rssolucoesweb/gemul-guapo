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
           Gemul Portal do Aluno - Mensagem
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
                    
					
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">EAD Gemul</a></li>
                            <li class="breadcrumb-item">Painel</li>
                            <li class="breadcrumb-item active">Mensagem</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-envelope'></i> Mensagem <sup class='badge badge-primary fw-500'>Interno</sup>
                                <small>
                                    Envie mensagem diretamente para seu professor(a)
                                </small>
                            </h1>
                        </div>
                        
						<%

					ID_EMPRESA 			= Session("CodEmpresaAluno_GemulEad")
					id					= REQUEST.FORM("id")
					cod_colaborador		= REQUEST.FORM("cmbProfessor")
					DESCRICAO 			= REPLACE(REQUEST.FORM("DESCRICAO"),"'","")
					ASSUNTO 			= REPLACE(REQUEST.FORM("ASSUNTO"),"'","")
					if cod_colaborador="" then cod_colaborador="0"
					acao				= Trim(Request("acao"))
					bloq				= ""
					if id<>"" then
						sql = "select cod_empresa, cod_mensagem_pai, cod_colaborador, cod_aluno, assunto from EAD_MENSAGEM"
						sql = sql & " where cod_mensagem=" & id
						rs.open sql, cnn
						if not rs.eof then
							ID_EMPRESA = rs("cod_empresa")
							cod_colaborador = rs("cod_colaborador")
							ASSUNTO = rs("assunto")
							bloq = "readonly"
						end if
						rs.close
					end if
					
					'*****************
					'INCLUIR	
					'*****************
					if acao="I" then
						inserir = ""
						sql = "select cod_mensagem from EAD_MENSAGEM"
						sql = sql & " where tipo='R' and cod_colaborador = " & cod_colaborador
						sql = sql & " and cod_aluno = " & Session("CodAluno_GemulEad")
						sql = sql & " and assunto = '" & assunto & "'"
						sql = sql & " and descricao = '" & descricao & "'"
						if id<> "" then
							sql = sql & " and cod_mensagem_pai = " & id
						end if
						rs.open sql, cnn
						if rs.eof then
							inserir = "S"
						end if
						rs.close
						
						if inserir = "S" then
							'on error resume next
							sql = "SET NoCount ON INSERT INTO EAD_MENSAGEM (cod_empresa, cod_mensagem_pai, cod_colaborador, cod_aluno, assunto, descricao, situacao, tipo, usuario_incl_aluno, usuario_logado, data_hora_incl) VALUES ("
							sql = sql & "" & ID_EMPRESA & ","
							if id = "" then
								sql = sql & "null,"
							else
								sql = sql & "" & id & ","
							end if
							sql = sql & "" & cod_colaborador & ","
							sql = sql & "" & Session("CodAluno_GemulEad") & ","
							sql = sql & "'" & ASSUNTO & "',"
							sql = sql & "'" & DESCRICAO & "',"
							sql = sql & "'E','R',"
							sql = sql & "" & Session("CodAluno_GemulEad") & ","
							sql = sql & "'" & Session("NomeAluno_GemulEad") & "',GetDate()); SELECT @@IDENTITY"
		
							Set rs = cnn.Execute(sql)
							id = rs(0)
							rs.close
							if err.number = 0 then
								%>
								<div class="alert alert-success alert-dismissable">
									<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
									Mensagem enviado com sucesso!
								</div>
								<%
								'GravarLogEaD "Recado enviado",0,id,0,cod_colaborador
							else
								%>
								<div class="alert alert-danger alert-dismissable">
									<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
									Mensagem não pode ser enviada!
								</div>
								<%
								tratamentoErro
								err.clear
							end if
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
                                            Mensagem
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
											<input type="hidden" name="id" id="id" value="<%=id%>">
												<div class="form-group">
                                                    <label class="form-label" for="example-select">Professor(a)</label>
                                                    <!--#include file="includes/inc_cmbProfessor.asp"-->
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="simpleinput">Assunto</label>
                                                    <input <%=bloq%> type="text" id="assunto" name="assunto" class="form-control" value="<%=assunto%>">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="example-textarea">Texto</label>
                                                    <textarea class="form-control" id="descricao" name="descricao"  rows="5"></textarea>
                                                </div>
                                                
												<div class="d-flex flex-row">
                                                <a href="#" onClick="salvar('I')" class="btn btn-outline-primary">Enviar</a>
												</div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
						<div class="row">
                            <div class="col-xl-10">
							
                                <div id="panel-4" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Mensagem enviadas
                                        </h2>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            
                                            <div class="frame-wrap w-100">
                                                <div class="accordion accordion-hover" id="js_demo_accordion-5">
													<%
													CONT = 0
													expandir = "collapse show"
													expanded = "true"
													collapsed = "card-title"
													controle = 0
													sql = "SELECT cod_mensagem, assunto, descricao,"
													sql = sql & " case"
													sql = sql & " 	when m.usuario_incl_aluno is NOT NULL then '<i class=""fal fa-user""></i>&nbsp;' + a.NOMEALUNO"
													sql = sql & "  	when m.usuario_incl_colaborador = '0' then '<i class=""fal fa-graduation-cap""></i>&nbsp;SEDUC'"
													sql = sql & " 	when m.usuario_incl_colaborador <> '0' and m.usuario_incl_colaborador is not null then '<i class=""fal fa-graduation-cap""></i>&nbsp;' + C.nome"
													sql = sql & " 	else '<i class=""fal fa-graduation-cap""></i>&nbsp;' + u.USUA_NOME_COMPLETO"
													sql = sql & " end as enviado_por"
													sql = sql & " FROM EAD_Mensagem m"
													sql = sql & " left join SRH_COLABORADOR c on c.codigo = m.usuario_incl_colaborador"
													sql = sql & " left join SCA_ALUNO a on a.codigo = m.usuario_incl_aluno"
													sql = sql & " left join SEG_USUARIOS_SISTEMA u on u.USUA_CODG = m.usuario_logado"
													sql = sql & " WHERE (m.cod_mensagem_pai = 0 or m.cod_mensagem_pai is null)"
													SQL = SQL & " and m.cod_aluno=" & Session("CodAluno_GemulEad")
													SQL = SQL & " order by m.cod_mensagem desc"
													RS.OPEN SQL, CNN
													IF RS.EOF = FALSE THEN
														while not rs.eof
															CONT = CONT + 1
															
															cod_mensagem_pai = rs("cod_mensagem")
															%>
															<div class="card">
																<div class="card-header">
																	<a href="javascript:void(0);" class="<%=collapsed%>" data-toggle="collapse" data-target="#js_demo_accordion-5_<%=CONT%>" aria-expanded="<%=expanded%>">
																		<%=RS("enviado_por")%>:&nbsp;&nbsp;<%=RS("ASSUNTO")%> - <%=RS("descricao")%>
																		<span class="ml-auto">
																			<span class="collapsed-reveal">
																				<i class="fal fa-minus-circle text-danger fs-xl"></i>
																			</span>
																			<span class="collapsed-hidden">
																				<i class="fal fa-plus-circle text-success fs-xl"></i>
																			</span>
																		</span>
																	</a>
																</div>
																<%
																sql = " WITH Niveis AS ("
																sql = sql & "                 SELECT cod_mensagem, cod_mensagem_pai, assunto, descricao, usuario_incl_aluno, usuario_incl_colaborador,"
																sql = sql & "                 0 AS Nivel"
																sql = sql & "                 FROM EAD_Mensagem"
																sql = sql & "                 WHERE cod_mensagem_pai =" & cod_mensagem_pai
																sql = sql & "                 UNION ALL"
																sql = sql & "                 SELECT T1.cod_mensagem, T1.cod_mensagem_pai, T1.assunto, T1.descricao,T1.usuario_incl_aluno,t1.usuario_incl_colaborador,"
																sql = sql & "                 Nivel+1"
																sql = sql & "                 FROM EAD_Mensagem T1"
																sql = sql & "                 INNER JOIN Niveis ON T1.cod_mensagem_pai = Niveis.cod_mensagem"
																sql = sql & "                 )"
																sql = sql & " SELECT cod_mensagem, cod_mensagem_pai, REPLICATE('     ' , Nivel) + assunto + ' - ' + descricao AS mensagem, usuario_incl_aluno, usuario_incl_colaborador"
																sql = sql & " FROM Niveis"
																sql = sql & " ORDER BY cod_mensagem, cod_mensagem_pai"
																RSAUX.OPEN SQL, CNN
																IF RSAUX.EOF = FALSE THEN
																
																	%>
																	<div id="js_demo_accordion-5_<%=CONT%>" class="<%=expandir%>" data-parent="#js_demo_accordion-5">
																		<%
																		WHILE not RSAUX.eof
																			if NOT ISNULL(RSAUX("usuario_incl_aluno")) THEN 
																				CLASS_I = "fal fa-user"
																			else
																				CLASS_I = "fal fa-graduation-cap"
																			end if
																			%>
																			<div class="card-body">
																				<i class="<%=CLASS_I%>"></i>&nbsp;<%=RSAUX("MENSAGEM")%>
																			</div>
																			<%
																			cod_mensagem_pai = RSAUX("cod_mensagem")
																			RSAUX.MOVENEXT
																		WEND
																		%>
																		<BR>
																		<div align="center"><a href="#" onClick="editar('<%=cod_mensagem_pai%>')" class="btn btn-outline-success">Responder</a></div>
																		<BR>
																	</div>
																	<%
																ELSE
																	%>
																	<div id="js_demo_accordion-5_<%=CONT%>" class="<%=expandir%>" data-parent="#js_demo_accordion-5">
																		<BR>
																		<div align="center"><a href="#" onClick="editar('<%=cod_mensagem_pai%>')" class="btn btn-outline-success">Responder</a></div>
																		<BR>
																	</div>
																	<%
																END IF
																RSAUX.CLOSE
																
																expandir = "collapse"
																expanded = "false"
																collapsed = "card-title collapsed"
																
																%>
															</div>
															<%
															RS.MOVENEXT
														wend
														
													END IF
													RS.CLOSE
													%>
                                                    
                                                </div>
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
		<script src="js/mensagem.js"></script>
        <!-- Include a polyfill for ES6 Promises (optional) for IE11, UC Browser and Android browser support -->
        <script>
            $(document).ready(function()
            {

              

            });

        </script>
    </body>
</html>
