<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul EAR - Grades
        </title>
        <meta name="description" content="Contacts">
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
        <link rel="stylesheet" media="screen, print" href="css/fa-solid.css">
        <link rel="stylesheet" media="screen, print" href="css/fa-brands.css">
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
                <%
					item_ativo_turma 		= " class='active' "
					menu_ativo = " class='active open' "
					
					%>
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
                    
                    <!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">EAR Gemul</a></li>
                            <li class="breadcrumb-item">Curso</li>
							<%if Session("TipoInterDisciplinarOuDisciplinar")="D" then%>
                                <li class="breadcrumb-item active">Disciplina</li>
							<%else%>
                                <li class="breadcrumb-item active">Interdisciplinar</li>
							<%end if%>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
								<%if Session("TipoInterDisciplinarOuDisciplinar")="D" then%>
                                <i class='subheader-icon ni ni-docs'></i> Disciplinas do horário <sup class='badge badge-primary fw-500'><%=Session("Curso_GemulEad")%> - <%=Session("Periodo_GemulEad")%></sup>
								<%else%>
                                <i class='subheader-icon ni ni-docs'></i> Interdisciplinar <sup class='badge badge-primary fw-500'><%=Session("Curso_GemulEad")%> - <%=Session("Periodo_GemulEad")%></sup>
								<%end if%>
                                <small>
                                    Acesso as Atividades e Questionários
                                </small>
                            </h1>
                        </div>
						<%
						ID_EMPRESA 			= Session("CodEmpresaAluno_GemulEad")
						cod_colaborador		= REQUEST.FORM("cmbProfessor")
						DESCRICAO 			= REPLACE(REQUEST.FORM("DESCRICAO"),"'","")
						ASSUNTO 			= REPLACE(REQUEST.FORM("ASSUNTO"),"'","")
						if cod_colaborador="" then cod_colaborador="0"
						acao				= Trim(Request.Form("acao"))
						funcao_professor_submit	= "N"
						
						'*****************
						'INCLUIR	
						'*****************
						if acao="I" then
							on error resume next
							sql = "INSERT INTO EAD_MENSAGEM (cod_empresa, cod_colaborador, cod_aluno, assunto, descricao, situacao, usuario_incl_aluno, usuario_logado, data_hora_incl) VALUES ("
							sql = sql & "" & ID_EMPRESA & ","
							sql = sql & "" & cod_colaborador & ","
							sql = sql & "" & Session("CodAluno_GemulEad") & ","
							sql = sql & "'" & ASSUNTO & "',"
							sql = sql & "'" & DESCRICAO & "',"
							sql = sql & "'E',"
							sql = sql & "" & Session("CodAluno_GemulEad") & ","
							sql = sql & "'" & Session("NomeAluno_GemulEad") & "',GetDate())"
							cnn.execute sql
							if err.number = 0 then
								%>
								<div class="alert alert-success alert-dismissable">
									<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
									Mensagem enviada com sucesso!
								</div>
								<%
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
							acao = ""
							ASSUNTO = ""
							DESCRICAO = ""
						end if
						%>
                        <div class="row">
                            <div class="col-xl-12">
                                <div class="border-faded bg-faded p-3 mb-g d-flex">
                                    <input type="text" id="js-filter-contacts" name="filter-contacts" class="form-control shadow-inset-2 form-control-lg" placeholder="Filtrar">
                                    <div class="btn-group btn-group-lg btn-group-toggle hidden-lg-down ml-3" data-toggle="buttons">
                                        <label class="btn btn-default active">
                                            <input type="radio" name="contactview" id="grid" checked="" value="grid"><i class="fas fa-table"></i>
                                        </label>
                                        <label class="btn btn-default">
                                            <input type="radio" name="contactview" id="table" value="table"><i class="fas fa-th-list"></i>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
						
						
                        <div class="row" id="js-contacts">
						<%
						if Session("TipoInterDisciplinarOuDisciplinar")="D" then
							sql = "Select distinct c.nome as professor, ha.cod_colaborador, isnull(c.FoneCelular,'') as FoneCelular, c.email, ad.cod_disciplina, d.desc_disciplina, t.cod_semestre, t.AnoLetivo, t.nometurma, t.turmaaluno"
							sql = sql & " From sca_aluno_disciplina ad" 
							sql = sql & " left join sca_disciplina d on d.cod_disciplina = ad.cod_disciplina" 
							sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO" 
							sql = sql & " left join sca_gradecurricular gc on gc.Cod_GradeCurricular = gcd.Cod_GradeCurricular" 
							sql = sql & " left join sca_disciplina dr on dr.cod_disciplina = gcd.Cod_Disciplina" 
							sql = sql & " left join sca_turma t on t.cod_turma = ad.cod_turma" 
							sql = sql & " left join sca_turma tr on tr.cod_turma = ad.COD_TURMA_REMANEJAMENTO" 
							sql = sql & " left join SCA_PERIODO p ON p.Cod_Periodo = gc.Cod_Periodo" 
							sql = sql & " left join SCA_SITUACAO_PROMOCAO sp ON sp.CODIGO = ad.COD_SITUACAO_ACADEMICA" 
							sql = sql & " left join SCA_HORARIO_AULA ha on ha.Cod_Disciplina = d.Cod_Disciplina and ha.Cod_Empresa = ad.COD_EMPRESA and ha.Cod_turma = t.cod_turma" 
							sql = sql & " left join SRH_COLABORADOR c on c.codigo = ha.cod_colaborador"
							sql = sql & " where	ad.cod_aluno = " & Session("CodAluno_GemulEad") 
							sql = sql & " and t.cod_turma = " & Session("CodTurma_GemulEad")
							sql = sql & " order by d.desc_disciplina"
						else
							sql = "Select distinct "
							sql = sql & " case"
							sql = sql & " 	when d.desc_disciplina = 'EDUCAÇÃO FÍSICA' then d.desc_disciplina"
							sql = sql & " 	else 'INTERDISCIPLINAR'"
							sql = sql & " end as desc_disciplina,"
							sql = sql & " case"
							sql = sql & " 	when d.desc_disciplina = 'EDUCAÇÃO FÍSICA' then d.cod_disciplina"
							sql = sql & " 	else '0'"
							sql = sql & " end as cod_disciplina,"
							sql = sql & " c.nome as professor, ha.cod_colaborador, isnull(c.FoneCelular,'') as FoneCelular, c.email, "
							sql = sql & " t.cod_semestre, t.AnoLetivo, t.nometurma, t.turmaaluno "
							sql = sql & " From sca_aluno_disciplina ad left join sca_disciplina d on d.cod_disciplina = ad.cod_disciplina left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO left join sca_gradecurricular gc on gc.Cod_GradeCurricular = gcd.Cod_GradeCurricular "
							sql = sql & " left join sca_disciplina dr on dr.cod_disciplina = gcd.Cod_Disciplina "
							sql = sql & " left join sca_turma t on t.cod_turma = ad.cod_turma "
							sql = sql & " left join sca_turma tr on tr.cod_turma = ad.COD_TURMA_REMANEJAMENTO "
							sql = sql & " left join SCA_PERIODO p ON p.Cod_Periodo = gc.Cod_Periodo "
							sql = sql & " left join SCA_SITUACAO_PROMOCAO sp ON sp.CODIGO = ad.COD_SITUACAO_ACADEMICA "
							sql = sql & " left join SCA_HORARIO_AULA ha on ha.Cod_Disciplina = d.Cod_Disciplina and ha.Cod_Empresa = ad.COD_EMPRESA and ha.Cod_turma = t.cod_turma "
							sql = sql & " left join SRH_COLABORADOR c on c.codigo = ha.cod_colaborador "
							sql = sql & " where	ad.cod_aluno = " & Session("CodAluno_GemulEad") 
							sql = sql & " and t.cod_turma = " & Session("CodTurma_GemulEad")
							sql = sql & " order by 1"
						end if
						rs.open sql, cnn
						cont = 0							
						if not rs.eof then
							while not rs.eof
								disciplina = UCase(rs("desc_disciplina"))
								disciplina_minuscula = LCase(rs("desc_disciplina"))
								professor = UCase(rs("professor"))
								cod_professor = rs("cod_colaborador")
								celular_professor = rs("FoneCelular")
								email_professor = rs("email")
								cont = cont + 1
							%>
                            <div class="col-xl-4">
                                <div id="c_<%=cont%>" class="card border shadow-0 mb-g shadow-sm-hover" data-filter-tags="<%=disciplina_minuscula%>">
                                    <div class="card-body border-faded border-top-0 border-left-0 border-right-0 rounded-top">
                                        <div class="d-flex flex-row align-items-center">
                                            <span class="status status-warning mr-3">
                                                <span class="rounded-circle profile-image d-block " style="background-image:url('img/icone_disciplinas.png'); background-size: cover;"></span>
                                            </span>
                                            <div class="info-card-text flex-1">
                                                    <%=disciplina%>
                                            </div>
                                            <button class="js-expand-btn btn btn-sm btn-default d-none" data-toggle="collapse" data-target="#c_<%=cont%> > .card-body + .card-body" aria-expanded="false">
                                                <span class="collapsed-hidden">+</span>
                                                <span class="collapsed-reveal">-</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body p-0 collapse show">
                                        <div class="p-3">
                                                <i class="fas fa-graduation-cap text-muted mr-2"></i><%=professor%><br>
												
                                                <i class="fas fa-envelope text-muted mr-2"></i> Clique <button type="button" class="btn btn-xs btn-outline-secondary" data-toggle="modal" data-target="#default-example-modal" onClick="setaProfessor('<%=cod_professor%>')">aqui</button> e envie mensagem ao professor(a)
                                            <address class="fs-sm fw-400 mt-4 text-muted">
                                            <div class="d-flex flex-row">
                                                <a href="atividades.asp?cd=<%=rs("cod_disciplina")%>" class="btn btn-outline-primary">Acessar atividades</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<%
								rs.movenext
							wend
						end if
						rs.close
						
						sql = "select q.codigo, q.nome, q.descricao"
						sql = sql & " from ead_questionario q"
						sql = sql & " inner join ead_questionario_turma qt on qt.cod_questionario = q.Codigo"
						sql = sql & " where qt.cod_turma = " & Session("CodTurma_GemulEad")
						SQL = SQL & " and q.situacao = 'P'"
						SQL = SQL & " and ("
						SQL = SQL & " 	(getdate() between q.data_inicial and q.data_final) "
						SQL = SQL & " 	or q.data_final is null"
						SQL = SQL & " 	)"
						sql = sql & " order by q.codigo desc"
						rs.open sql, cnn
						if not rs.eof then
							while not rs.eof
								questionario = "QUESTIONÁRIO - " & UCase(rs("nome"))
								desc_questionario = LCase(rs("descricao"))
								cont = cont + 1
							%>
                            <div class="col-xl-4">
                                <div id="c_<%=cont%>" class="card border shadow-0 mb-g shadow-sm-hover" data-filter-tags="<%=disciplina_minuscula%>">
                                    <div class="card-body border-faded border-top-0 border-left-0 border-right-0 rounded-top">
                                        <div class="d-flex flex-row align-items-center">
                                            <span class="status status-warning mr-3">
                                                <span class="rounded-circle profile-image d-block " style="background-image:url('img/icone_disciplinas.png'); background-size: cover;"></span>
                                            </span>
                                            <div class="info-card-text flex-1">
                                                    <%=questionario%>
                                            </div>
                                            <button class="js-expand-btn btn btn-sm btn-default d-none" data-toggle="collapse" data-target="#c_<%=cont%> > .card-body + .card-body" aria-expanded="false">
                                                <span class="collapsed-hidden">+</span>
                                                <span class="collapsed-reveal">-</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body p-0 collapse show">
                                        <div class="p-3">
                                                <i class="fas fa-th-list text-muted mr-2"></i><%=desc_questionario%>
												<address class="fs-sm fw-400 mt-4 text-muted">
                                            <div class="d-flex flex-row">
                                                <a href="questionario.asp?cod_questionario=<%=rs("codigo")%>" class="btn btn-outline-primary">Acessar questionário</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<%
								rs.movenext
							wend
						end if
						rs.close
						%>
							
							
                        </div>
                    </main>
                    <!-- this overlay is activated only when mobile menu is triggered -->
                    <div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div> <!-- END Page Content -->
                    
					<!-- Modal -->
					<div class="modal fade" id="default-example-modal" tabindex="-1" role="dialog" aria-hidden="true">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<h4 class="modal-title">
										Recado
										<small class="m-0 text-muted">
											Enviei recado diretamente ao professor(a)
										</small>
									</h4>
									<button type="button" class="close" data-dismiss="modal" aria-label="Close">
										<span aria-hidden="true"><i class="fal fa-times"></i></span>
									</button>
								</div>
								<div class="modal-body">
									<div class="row">
										<div class="col-xl-10">
											
														
											<form method="post" name="frm" id="frm">
											<input type="hidden" name="acao" id="acao" value="<%=acao%>">
												<div class="form-group">
													<label class="form-label" for="example-select">Professor(a)</label>
													<!--#include file="includes/inc_cmbProfessor.asp"-->
												</div>
												<div class="form-group">
													<label class="form-label" for="simpleinput">Assunto</label>
													<input type="text" id="assunto" name="assunto" class="form-control">
												</div>
												<div class="form-group">
													<label class="form-label" for="example-textarea">Texto</label>
													<textarea class="form-control" id="descricao" name="descricao"  rows="5"></textarea>
												</div>
												
											</form>
													
										</div>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
									<button type="button" class="btn btn-primary" onClick="salvar('I')">Enviar</button>
								</div>
							</div>
						</div>
					</div>
					
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
		<script src="js/grades.js"></script>
        <script>
            $(document).ready(function()
            {

                $('input[type=radio][name=contactview]').change(function()
                {
                    if (this.value == 'grid')
                    {
                        $('#js-contacts .card').removeClassPrefix('mb-').addClass('mb-g');
                        $('#js-contacts .col-xl-12').removeClassPrefix('col-xl-').addClass('col-xl-4');
                        $('#js-contacts .js-expand-btn').addClass('d-none');
                        $('#js-contacts .card-body + .card-body').addClass('show');

                    }
                    else if (this.value == 'table')
                    {
                        $('#js-contacts .card').removeClassPrefix('mb-').addClass('mb-1');
                        $('#js-contacts .col-xl-4').removeClassPrefix('col-xl-').addClass('col-xl-12');
                        $('#js-contacts .js-expand-btn').removeClass('d-none');
                        $('#js-contacts .card-body + .card-body').removeClass('show');
                    }

                });

                //initialize filter
                initApp.listFilter($('#js-contacts'), $('#js-filter-contacts'));
				
				
            });


        </script>
    </body>
</html>
