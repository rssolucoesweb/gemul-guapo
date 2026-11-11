<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<!DOCTYPE html>
<html lang="pt">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul Portal do Aluno - Ficha descritiva
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
		<!-- Global site tag (gtag.js) - Google Analytics -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=G-FXQXP36BMP"></script>
		<script>
		  window.dataLayer = window.dataLayer || [];
		  function gtag(){dataLayer.push(arguments);}
		  gtag('js', new Date());

		  gtag('config', 'G-FXQXP36BMP');
		</script>
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
                <%item_ativo_ficha_descritiva 		= " class='active' "%>
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
                    
					
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL</a></li>
                            <li class="breadcrumb-item">Ficha</li>
                            <li class="breadcrumb-item active">Descritiva</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-envelope'></i> Ficha Descritiva <sup class='badge badge-primary fw-500'><%=Session("Periodo_GemulEad")%></sup>
                                <small>
                                    Consulte a ficha descritiva do aluno
                                </small>
                            </h1>
                        </div>
                        
						<%

					ID_EMPRESA 					= Session("CodEmpresaAluno_GemulEad")
					intCodFichaDescritiva		= REQUEST.FORM("cmbFichaDescritiva")
					intCodTurno					= REQUEST.FORM("cmbTurnoFichaDescritiva")
					intCodTurnoRH				= REQUEST.FORM("cmbTurnoFichaDescritiva")
					ficha_descricao				= ""
					
					if intCodFichaDescritiva <>"" and intCodFichaDescritiva<>"0" then
						sql = "SELECT Codigo, Descricao"
						sql = sql & " FROM SCA_FICHA_DESCRITIVA"
						sql = sql & " WHERE codigo = " & intCodFichaDescritiva
						rs.open sql, cnn
						if not rs.eof then
							ficha_descricao = rs("descricao")
						end if
						rs.close
					end if
					%>
					
                        <div class="row">
                            <div class="col-xl-12">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Ficha Descritiva
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
												
												<% if Session("Turno_GemulEad") = "INTEGRAL" then %>
												<div class="form-group">
                                                    <label class="form-label" for="example-select">Turno</label>
                                                    <!--#include file="includes/inc_cmbTurnoFichaDescritiva.asp"-->
                                                </div>
												<% else %>
													<input name="cmbTurnoFichaDescritiva" value="<%=intCodTurno%>" type="hidden">
												<% end if %>
												<div class="form-group">
                                                    <label class="form-label" for="example-select">Ficha</label>
                                                    <!--#include file="includes/inc_cmbFichaDescritiva.asp"-->
                                                </div>
												<div class="d-flex flex-row">
                                                <a href="#" onClick="consultar()" class="btn btn-outline-primary">Consultar</a>
												</div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
						
						<%
						if intCodFichaDescritiva <>"" and intCodFichaDescritiva<>"0" then
						%>
						<div class="row">
                            <div class="col-lg-12 col-xl-12">
								
								<!--Table hover-->
                                <div id="panel-5" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Relatório da Ficha descritiva - <%=ficha_descricao%>
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <div class="table-responsive-lg">
											
							
											<%
											Legenda = "Legenda: "
											sql = " select Sigla, Descricao from SCA_FICHA_DESCRITIVA_CONCEITO "
											sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva
											sql = sql & " UNION "
											sql = sql & " select Sigla, Descricao from SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
											sql = sql & " WHERE cod_ficha_descritiva = " & intCodFichaDescritiva 
											rs.open sql, cnn
											if rs.eof = false then
												while not rs.eof
													Legenda = Legenda + "   ( " & rs("Sigla") & " ) - " & rs("Descricao") 
													rs.movenext
												wend
											else
												%>
												<script>
													alert("ATENÇÃO: Legenda não Cadastrada. Verifique!");
													window.close();
												</script>
												<%
												response.end
											end if 
											rs.close
											
											sql = " SELECT descricao, codigo"
											sql = sql & " FROM SCA_bimestre"
											sql = sql & " where Ano_Letivo = " & year(date) 
											sql = sql & " order by descricao "
											rs.open sql, cnn
											if rs.eof = false then
												vetBimestre = rs.getRows
											else
												%>
												<script>
													alert("ATENÇÃO: Bimestre não cadastrado. Verifique!");
													window.close();
												</script>
												<%
												response.end
											end if 
											rs.close
											
											cont = 0
												
											' Busca Tipo da Avalição
											if trim(intCodFichaDescritiva) <> "0" then 
												
												sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, CodTipoEmpresa, "
												sql = sql & " Observacoes, rodape"
												sql = sql & " FROM SCA_FICHA_DESCRITIVA"
												sql = sql & " Where Codigo = " & intCodFichaDescritiva
												rs.open sql, cnn
												if rs.eof = false then
													intCodAvaliacao			= rs("Codigo")
													strNomeAvaliacao		= rs("Descricao")
													strAnoLetivo			= rs("Ano_Letivo")
													strSemestre				= rs("Semestre")
													strObservacoes			= rs("Observacoes")
													strRodape				= rs("rodape")
													intCodTipoEmpresa 		= trim(rs("CodTipoEmpresa"))
												end if 
												rs.close
												
												if Session("CodEmpresaGrupo_GemulEad") <> "" then 
	
													sql = "SELECT codigo, descricao, Cidade"
													sql = sql & " FROM seg_grupo"
													sql = sql & " Where Codigo = " & Session("CodEmpresaGrupo_GemulEad")
													rs.open sql, cnn
													
													if rs.eof = false then
														CidadeGrupo = rs("Cidade")
													end if 
													rs.close
												
												end if
												
												sql = " SELECT CODIGO "
												sql = sql & " FROM SCA_FICHA_DESCRITIVA_CONCEITO "
												sql = sql & " WHERE cod_grupo = " & Session("CodEmpresaGrupo_GemulEad")
												sql = sql & " And cod_ficha_descritiva = " & intCodFichaDescritiva
												rs.open sql, cnn
												if rs.eof then
													%>
													<script>
														alert("ATENÇÃO: Não existe CONCEITO definido para essa Ficha Descritiva. Verifique!");
														window.close();
													</script>
													<%
													response.end
												end if
												rs.close

											end if
											
											if intCodTipoEmpresa = "" then intCodTipoEmpresa = 0
												
											if intCodTipoEmpresa = 1 then
												
												strAssinatura = ""
											else
												strAssinatura = "____________________________________<br>"
												strAssinatura = strAssinatura & "  Assinatura do(a)  Coordenador(a) Geral "
											end if
											
											if trim(Session("CodAluno_GemulEad")) <> "" then
											
												sql = "SELECT MATRICULA, NOMEALUNO from sca_aluno "
												sql = sql & " Where codigo = " & Session("CodAluno_GemulEad")				
												rs.open sql, cnn
												if rs.eof = false then
												  strMatricula				= rs("MATRICULA")
												  strNomealuno				= rs("NOMEALUNO")
											   end if
											   rs.close	  
											end if   
											
											%>
											<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabela">
											<tr>
											  <td  class="celula">&nbsp;
											  
												  <%
											if intCodDisciplina = "" then intCodDisciplina = "0"
											if intCodDisciplina <> "0" then 
												sql = " SELECT SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
											else	
												sql = " SELECT top 1 SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
											end if	
											sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
											sql = sql & " SCA_TURMA.Cod_Turma, SCA_TURMA.NomeTurma, SCA_TURMA.Turmaaluno "
											sql = sql & " FROM  SCA_TURMA "
											sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
											sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
											sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
											sql = sql & " WHERE 1=1"
											sql = sql & " AND SCA_TURMA.Cod_Empresa= " & Session("CodEmpresaAluno_GemulEad")	
											sql = sql & " AND SCA_TURMA.Cod_Turma = " & Session("CodTurma_GemulEad")
											if intCodDisciplina <> "0" then 
												sql = sql & " AND SCA_DISCIPLINA.Cod_Disciplina = " & intCodDisciplina
											end if
											sql = sql & " ORDER BY Desc_Disciplina"
											
											rs.open sql, cnn
											if not rs.eof then 
													
												While not rs.eof 
													
													strCodTurma			= rs("Cod_Turma") 
													strTurma			= rs("Turmaaluno") & " " & rs("NomeTurma")
													if intCodDisciplina <> "0" then 
													   intCodDisciplina 	= rs("Cod_Disciplina")
													   strDisciplina 		= rs("DISCIPLINA")
													else   
													   intCodDisciplina 	= "0"
													   strDisciplina 		= "** InterDisciplinar **"
													end if
													sql = " SELECT DISTINCT C.CODIGO, C.NOME FROM SCA_HORARIO_AULA HA"
													sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = HA.Cod_Colaborador"
													sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresaAluno_GemulEad")
													sql = sql & " AND HA.ANOLETIVO = " & year(date) 
													sql = sql & " AND HA.cod_Turma = " & Session("CodTurma_GemulEad")
													sql = sql & " and HA.Cod_Disciplina = " & intCodDisciplina
													rsAux.open sql, cnn
													if not rsAux.eof then 
														strNome 			= rsAux("NOME")	
													else
														strNome 			= ""
													end if 	
													rsAux.close

													' Consulta as perguntas Descritivas
													sql = " SELECT " 
													sql = sql & " FDP.Codigo, " 
													sql = sql & " FDP.cod_ficha_descritiva, " 
													sql = sql & " FDP.Descricao, " 
													sql = sql & " FDP.Subtitulo, "
													for j=0 to ubound(vetBimestre,2)
														sql = sql & " ISNULL(FDPN" & j & ".Conceito,'') as Conceito" & j & " , " 
														sql = sql & " FDPN" & j & ".Resposta as Resposta" & j & ", " 
														sql = sql & " ISNULL(CP" & j & ".Sigla,'') AS SIGLA_PERGUNTA" & j & ", " 
														sql = sql & " ISNULL(C" & j & ".SIGLA,'') AS SIGLA" & j & ", " 
														sql = sql & " ISNULL(TU" & j & ".Desc_Turno,'') AS Turno" & j & ", " 
													next
													sql = sql & " '' as CampoTeste " 
													sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA FDP " 
													for j=0 to ubound(vetBimestre,2)
														intCodBimestre = vetBimestre(1,j) 
														sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN" & j & " ON FDPN" & j & ".Cod_aluno = " & Session("CodAluno_GemulEad") & " and FDPN" & j & ".Cod_Ficha_Descritiva_Pergunta = FDP.Codigo AND FDPN" & j & ".Cod_Bimestre = " & intCodBimestre & " AND FDPN" & j & ".Cod_Disciplina = " & intCodDisciplina
														sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_CONCEITO C" & j & " ON C" & j & ".CODIGO = FDPN" & j & ".CONCEITO "
														sql = sql & " LEFT JOIN SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA CP" & j & " ON CP" & j & ".CODIGO = FDPN" & j & ".Conceito AND CP" & j & ".Cod_Pergunta = FDPN" & j & ".Cod_Ficha_Descritiva_Pergunta "
														sql = sql & " LEFT JOIN SRH_TURNO TU" & j & " ON TU" & j & ".Cod_Turno = FDPN" & j & ".Cod_Turno_Rh " 
													next
													
													sql = sql & " WHERE FDP.cod_ficha_descritiva = " & intCodFichaDescritiva
													sql = sql & " ORDER BY 9, FDP.Codigo "
													rsAux.open sql, cnn
													if not rsAux.eof then
														%>
												<table width = "100%" border="1" align="center" cellpadding="2" cellspacing="2" bordercolor="#CCCCCC" class="tabela">
												  <tr>
													<td width="10%" rowspan="3" align="center" class="celula"><img src="<%=session("strFotoAluno")%>" alt="<%=Session("NomeAluno_GemulEad")%>"></td>
													<td height="25" colspan="8" align="center" class="celula"><strong><%=strNomeAvaliacao%></strong></td>
												  </tr>
												  <tr>
													<td height="21" class="celula">&nbsp;<strong>MATR&Iacute;CULA:</strong></td>
																<td height="21" class="celula">&nbsp;<%=strMatricula%></td>
																<td height="21" class="celula">&nbsp;<strong>NOME:</strong></td>
																<td height="21" colspan="5" class="celula">&nbsp;<%=strNomealuno%></td>
												  </tr>
												  <tr>
													<td width="12%" height="21" class="celula">&nbsp;<strong>TURMA: </strong></td>
															  <td width="24%" height="21" class="celula">&nbsp;<%=strTurma%></td>
															  <td width="11%" height="21" class="celula">&nbsp;</td>
															  <td height="21" colspan="5" class="celula">&nbsp;</td>
												  </tr>
												  <tr>
													<td height="21" colspan="5" class="celula"><strong><%=trim(Legenda)%></strong></td>
													<td colspan="5" align="center" class="celula">&nbsp;</td>
												  </tr>
												  <tr>
													<td height="21" colspan="5" class="celula">&nbsp;</td>
														  <td width="19%" colspan="4" align="center" class="celula"><strong>Conceito</strong></td>
												  </tr>
												  
												  <tr>
													<td height="23" colspan="5" class="celula">&nbsp;&nbsp;</td>
														  <% for j=0 to ubound(vetBimestre,2)
															intCodBimestre = vetBimestre(1,j) 
															strCodBimestre = vetBimestre(0,j) 
														   %>
													<td class="celula" align="center"><strong><%=strCodBimestre%></strong></td>
															 <%
														Next
														%> 
												  </tr>
												  <%
														cont = 0
														while not rsAux.eof

															intCod_Ficha_Descritiva_Pergunta = rsAux("codigo")
															intCodItemAvaliacao = rsAux("codigo")
															strDescricao		= trim(rsAux("Descricao"))
															
																	
															if trim(rsAux("Subtitulo")) <> "" then
																  %>
																  <tr>
																	<td height="21" colspan="9" class="celula"><strong><%=trim(rsAux("Subtitulo"))%> <%if intCodTurnoRH = "0" then response.write " - ( " & rsAux("Turno0") & " )"%></strong></td>
																  </tr>
																  <%
															end if
																		%>
															  <tr>
																<td height="21" colspan="5" class="celula"><%=trim(rsAux("Descricao"))%>&nbsp;</td>
															  <%	
															  
															for j=0 to ubound(vetBimestre,2)

																strResposta = rsAux("Resposta"&j)	
																
																if rsAux("SIGLA_PERGUNTA"&j) = "" then	
																	strConceito = rsAux("SIGLA"&j)
																else
																	strConceito = rsAux("SIGLA_PERGUNTA"&j)
																end if		
																
																if isnull(strConceito) or strConceito = "" then strConceito = "---"
																if isnull(strResposta) or strResposta = "" then strResposta = ""

																%>	
																	<td height="30" class="celula" align="center"><%=trim(strConceito)%>&nbsp;</td>
																<%
															next	
															
															
															%>	
												  </tr>
												  <% 		cont = cont + 1 
															rsAux.movenext
														wend

														rsAux.close
													else
														rsAux.close 	
													end if
													rs.movenext
													%>
												</table>
											   <br>
												 <%
												wend
											end if

												%>  
											   </td>
												</tr>
												<tr>
												  <td  class="celula"><%=strRodape%></td>
												</tr>
											</table>

												   <table width = "100%" border="1" align="center" cellpadding="2" cellspacing="2" bordercolor="#CCCCCC" class="tabela">
													<tr>
													<td height="18" colspan="3" class="celula"><strong>INFORMA&Ccedil;&Otilde;ES GERAIS</strong></td>
													</tr>  
													
													 <%
													 
													
													 
													sql = " SELECT FN.Codigo, FN.Cod_Turma, FP.descricao as pergunta, FN.Cod_Ficha_Descritiva_Pergunta, FN.Cod_aluno, FN.Conceito, FN.Resposta, FN.Cod_Bimestre, ISNULL(TU.Desc_Turno,'') AS Turno, "
													sql = sql & " SCA_BIMESTRE.Descricao"
													sql = sql & " FROM SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA  FN"
													sql = sql & " inner join SCA_FICHA_DESCRITIVA_PERGUNTA FP ON FP.CODIGO = FN.Cod_Ficha_Descritiva_Pergunta "
													sql = sql & " inner join SCA_BIMESTRE on SCA_BIMESTRE.Codigo = FN.Cod_Bimestre "
													sql = sql & " LEFT JOIN SRH_TURNO TU ON TU.Cod_Turno = FN.Cod_Turno_Rh " 
													sql = sql & " WHERE FN.Cod_aluno = " & Session("CodAluno_GemulEad")
													sql = sql & " and FN.Cod_Turma = " & Session("CodTurma_GemulEad")
													sql = sql & " and SCA_BIMESTRE.Ano_letivo = " & year(date)
													if intCodTurnoRH <> "0" and intCodTurnoRH<>"" then
														sql = sql & " And FN.Cod_Turno_Rh = " & intCodTurnoRH
													end if
													sql = sql & " And FP.cod_ficha_descritiva = " & intCodFichaDescritiva
													sql = sql & " and FN.Resposta <> '' "
													sql = sql & " order by SCA_BIMESTRE.Codigo"
													'response.write sql
													rs1.open sql, cnn
													
													if not rs1.eof then 
														While not rs1.eof 
														
														intCodBimestre = trim(rs1("Cod_Bimestre"))
														strBimestre = trim(rs1("Descricao"))
														strResposta = trim(rs1("Resposta"))
														if isnull(rs1("Resposta")) then strResposta = ""
														strPergunta = trim(rs1("pergunta"))
														if isnull(rs1("pergunta")) then strPergunta = ""
														
														if strResposta <> "" then 
														
														if trim(strBimestreAnt) <> trim(strBimestre) then
															strBimestreAnt = strBimestre
															%>			 
														<tr> 
															<td height="21" colspan="3" align="left" class="celula"><strong><%=strBimestre%></strong></td>
														</tr>
														<%end if%>
														<tr>
															<td height="21" colspan="3" align="left" class="celula"><strong><%=strPergunta%>:</strong> <%=strResposta%><%if intCodTurnoRH = "0" then response.write " - ( " & rs1("Turno") & " )"%></td>
														</tr>
														<%
														end if
															rs1.movenext
															wend
													end if 	
													rs1.close%>
													 <tr>
													  <td height="67" colspan="3" align="left" class="celula"><strong><%=CidadeGrupo%>,&nbsp;<%=day(date)%> de <%=ucase(monthname(month(date)))%> de <%=year(date)%></strong></td>
													 </tr>
													</table>
											<br>
							
							
							
											</div>
                                        </div>
                                    </div>
                                </div>
							</div>
							
                        </div>
						<%
						end if
						%>
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

			function consultar(){
				var frm = document.getElementById("frm");
				frm.action="fichas.asp";
				frm.submit();
				return true;
			}
        </script>
    </body>
</html>
