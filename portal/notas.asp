<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<!DOCTYPE html>
<%
function ZeroLeft(valor,tam) 

	cZero = "" 
	if Len(Trim(cStr(valor))) < tam then 
		For n = 1 to tam - Len(Trim(cStr(valor))) 
			cZero = cZero & "0" 
		Next 
	end if 
	ZeroLeft = cZero & Trim(cStr(valor)) 

end function 
%>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul Portal do Aluno - Notas 
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
			<%item_ativo_nota 		= " class='active' "%>
			
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
				
					<!--#include file="inc_cabecalho_pagina.asp"-->
				
                    
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">EAD Gemul</a></li>
                            <li class="breadcrumb-item">Resultados</li>
                            <li class="breadcrumb-item active">Notas</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon ni ni-bag'></i> Notas e faltas <sup class='badge badge-primary fw-500'><%=Session("Periodo_GemulEad")%></sup>
                                <small>
                                    Resultados de notas e faltas
                                </small>
                            </h1>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-xl-12">

	<%
	sql = " SELECT SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.cod_Semestre, "
	sql = sql & " SCA_TURMA.cod_turma, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, "
	sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO, SCA_TURMA.AnoLetivo "
	sql = sql & " FROM SCA_ALUNO_DISCIPLINA  "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.Cod_Turma  "
	sql = sql & " AND SCA_TURMA.Cod_Empresa = SCA_ALUNO_DISCIPLINA.Cod_Empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = SCA_PERIODO.COD_CURSO "
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresaAluno_GemulEad")
	sql = sql & " AND SCA_ALUNO_DISCIPLINA.Cod_aluno = " & Session("CodAluno_GemulEad") 
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		strAnoLetivo 			= rs("AnoLetivo")
		intSemestre				= rs("cod_Semestre")
		intCodCurso 			= rs("cod_curso")
		intCodTurma 			= rs("cod_turma")
		strDescricaoPeriodo  	= rs("PERIODO")
		strDescricaoCurso 	 	= rs("CURSO")
	else
		strAnoLetivo 			= 0
		intSemestre				= 0
		intCodCurso 			= 0
		intCodTurma 			= 0
		strDescricaoPeriodo  	= 0
		strDescricaoCurso 	 	= 0
	end if
	rs.close
	
	GravarLogEaD "Acesso a notas e faltas ",0,0,0,0
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strCC				= "6CC"
	strCodBimestre		= ""

	'carrega campos
	sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " order by c.posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		strTipoCalculo 				= rs("TIPO_CALCULO")
		media_aprovacao 			= rs("media_aprovacao")
		media_aprovacao_final		= rs("media_aprovacao_final")
		intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
		intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		frequencia_minima_percentual= rs("frequencia_minima_percentual")
		
		vetCampo = rs.getRows
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.history.back();
		</script>
		<%
		response.end
	end if
	rs.close
	
	strCodAluno			= trim(Session("CodAluno_GemulEad"))
	strCod_empresa		= Session("CodEmpresaAluno_GemulEad")
	
	emitirNormal = "N"
	sql = "select codigo as cod_aluno, codigo from SCA_ALUNO"
	sql = sql & " where codigo in (" & strCodAluno & ")"
	sql = sql & " and codigo not in ("
	sql = sql & " 				select cod_aluno from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO"
	sql = sql & " 				where cod_aluno in (" & strCodAluno & ")"
	sql = sql & " 				and ano_letivo = " & strAnoLetivo
	sql = sql & ")"
	sql = sql & " order by NOMEALUNO"
	vetAluno = null
	rs.open sql, cnn
	if not rs.eof then
		vetAluno = rs.getRows
		emitirNormal = "S"
	end if
	rs.close
	
	if emitirNormal = "S" then
		contQuebra = 0
		for j=0 to ubound(vetAluno,2)
		
			intCodAluno  = vetAluno(0,j)		
			intPagina = 1

			sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, "
			sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.NOMETURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_NOTAS_FALTAS.MEDIA, "
			for i=0 to ubound(vetCampo,2)
				strPos = vetCampo(0,i)
				if cInt(strPos)<10 then strPos = "0" & strPos
				sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
				sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
			next
			sql = sql & " SCA_DISCIPLINA.DESC_DISCIPLINA, SCA_TURNO.DESC_TURNO, SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,SCA_SITUACAOALUNO.DESC_SITUACAOALUNO,"
			sql = sql & " SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA,sca_turma.DesvincularCriterioAvaliacao,"
			sql = sql & " SCA_NOTAS_FALTAS.situacao, SCA_PERIODO.Descricao AS PERIODO, SCA_CURSO.Descricao AS CURSO, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual"
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.SITUACAO = 'A'"
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_TURMA.Cod_periodo"
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso"
			sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
			sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = SCA_ALUNO.COD_SITUACAOALUNO "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
			sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
			sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
			sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
			sql = sql & " AND SCA_ALUNO.CODIGO = " &  intCodAluno
			sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO, SCA_DISCIPLINA.DESC_DISCIPLINA"
			rs.open sql, cnn
			if rs.eof = false then
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strDescricaoTurno= rs("DESC_TURNO")
				strDescricaoCurso= rs("CURSO")
				strDescricaoPeriodo= rs("PERIODO")
				strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")
				strSituacaoaluno = rs("DESC_SITUACAOALUNO")
				%>


                                <!--Table hover-->
                                <div id="panel-5" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Extrato de Notas
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
											
											<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
											  <tr>
												<td width="8%">Aluno(a):</td>
												<td width="63%">&nbsp;<strong><%=strNomeAluno%></strong></td>
											  </tr>
											  <tr>
												<td width="14%">Matr&iacute;cula:</td>
												<td width="15%">&nbsp;<strong><%=strMatricula%></strong></td>
											  </tr>
											  <tr>
												<td>Curso:</td>
												<td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
											  </tr>
											  <tr>
												<td>Turno:</td>
												<td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
											  </tr>
											  <tr>
												<td>Per&iacute;odo:</td>
												<td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
											  </tr>
											</table>
											<br>
											<table class="table table-bordered table-hover m-0">
                                                    <thead class="thead-themed">
                                                        <tr>
                                                            <th>Disciplinas</th>

																<%
																for i=0 to ubound(vetCampo,2)
																%>
																	<th><div align="center"><strong><%=vetCampo(1,i)%></strong></div></th>
																	<% if left(vetCampo(1,i),1) = "1" or left(vetCampo(1,i),1) = "2" or left(vetCampo(1,i),1) = "3" or left(vetCampo(1,i),1) = "4" then%>
																	<th><div align="center"><strong>Falta</strong></div></th>
																	<% end if%>
																<%
																next
																%>
																<%if mostra_ch = "S" then%>
																<th><div align="center"><strong>Carga Horária</strong></div></th>
																<%end if%>
																<%if mostra_percentual_falta = "S" then%>
																<th><div align="center"><strong>% Faltas</strong></div></th>
																<%end if%>
																<%if mostra_resultado = "S" then%>
																<th><div align="center"><strong>Resultado</strong></div></th>
																<%end if%>
															  </tr>
														</thead>
																<%
																strQtdeDiscRep = 0
																strTotalFaltas = 0
																while not rs.eof	
																	strDisciplina 	= rs("DESC_DISCIPLINA")
																	strCHDisciplina	= rs("Ch_Anual")
																	strOmitir_Criterio	= rs("Omitir_Criterio")
																	strMedia		= "---"
																	strResultadoFinal 		= ""
																	
																	if strOmitir_Criterio = "S" then
																		strResultadoFinal = "<font color='#0000FF'>AP</font>"
																	else
																		if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
																			strMedia = FORMATNUMBER(rs("MEDIA"),1)
																			
																			if rs("situacao")="AP" then
																				strResultadoFinal = "<font color='#0000FF'>" & rs("situacao") & "</font>"
																			elseif rs("situacao")="RN" then
																				strResultadoFinal = "<font color='#FF0000'>" & rs("situacao") & "</font>"
																			else
																				strResultadoFinal = "---"
																			end if

																			if cCur(strMedia) < cCur(media_aprovacao_final) then
																				strQtdeDiscRep = strQtdeDiscRep + 1
																			end if
																		end if
																	end if
																		%>
																		<td width="16%" align="left">&nbsp;<%=strDisciplina%></td>
																		<%					
																		for i=0 to ubound(vetCampo,2)
																			strPos = vetCampo(0,i)
																			if cInt(strPos)<10 then strPos = "0" & strPos
																			
																			strNota = "---"
																			
																			if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
																				strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
																			end if
																			strFalta = ""
																			if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
																				strFalta = rs("FALTA" & strPos)
																				strTotalFaltas = strTotalFaltas + strFalta
																			end if
																			%>
																			<td width="5%" align="center">&nbsp;<%=strNota%>&nbsp;</td>
																			<% if left(vetCampo(1,i),1) = "1" or left(vetCampo(1,i),1) = "2" or left(vetCampo(1,i),1) = "3" or left(vetCampo(1,i),1) = "4" then%>
																			<td width="5%" align="center">&nbsp;<%=strFalta%>&nbsp;</td>
																			<% end if%>
																			
																			<%
																		next
																		
																		if isnull(strCHDisciplina) then
																			strPercFaltas = 0
																		else
																			if strTotalFaltas <> "" then
																				strPercFaltas = FORMATNUMBER((strTotalFaltas * 100)/strCHDisciplina,1)
																				if cCur(strPercFaltas) > cCur(frequencia_minima_percentual) then
																					strResultadoFinal = "<font color='#FF0000'>RF</font>"
																				end if
																			end if
																		end if
																		
																		%>
																		<%if mostra_ch = "S" then%>
																		<td width="5%" align="center">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
																		<%end if%>
																		<%if mostra_percentual_falta = "S" then%>
																		<td width="5%" align="center">&nbsp;<%=strPercFaltas%>&nbsp;</td>
																		<%end if%>
																		<%if mostra_resultado = "S" then%>
																		<td width="5%" align="center">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
																		<%end if%>
																	</tr>
																	<%
																	strTotalFaltas = 0
																	rs.movenext
																	
																wend
																%>
																</table>
																<%
															end if
															rs.close
														next
													end if%>
	
	
	
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
