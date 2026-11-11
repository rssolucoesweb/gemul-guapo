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
            Gemul EAR - Atividades
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
					
					cod_atividade_pai = REQUEST("id_atv")
					if cod_atividade_pai = "" then cod_atividade_pai = 0
					
					cod_disciplina = request("cd")
					if cod_disciplina = "" then cod_disciplina = "0"
					
					SQL = "SELECT TA.descricao as atividade, A.titulo, A.descricao, A.link, A.data_hora_incl, A.cod_atividade_pai"
					SQL = SQL & " FROM EAD_Atividade_pai A"
					SQL = SQL & " INNER JOIN EAD_Atividade TIV ON TIV.cod_atividade_pai = A.cod_atividade_pai"
					SQL = SQL & " INNER JOIN EAD_Tipo_Atividade TA ON TA.cod_tipo_atividade = A.cod_tipo_atividade"
					SQL = SQL & " LEFT JOIN EAD_Tipo_Link TL ON TL.cod_tipo_link = A.cod_tipo_link"
					SQL = SQL & " WHERE TIV.cod_atividade_pai = " & cod_atividade_pai
					RS.OPEN SQL, CNN
					IF NOT RS.EOF THEN
						titulo = UCASE(RS("titulo"))
					END IF
					RS.CLOSE
					
					%>
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
					<main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">AVAP Gemul</a></li>
                            <li class="breadcrumb-item">Upload</li>
                            <li class="breadcrumb-item active">Foto</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-list-ol'></i> Foto das atividades <sup class='badge badge-primary fw-500'><%=Session("Curso_GemulEad")%> - <%=Session("Periodo_GemulEad")%></sup>
                                <small>
                                    Upload das atividades respondidas
                                </small>
                            </h1>
                        </div>
                        
                        <div class="row">
                            <div class="col-xl-12">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Upload da foto da atividade <%=titulo%>
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
									
                                    <div class="panel-container">
                                        
										<form method="post" id="frm" name="frm">
											
											<div class="jumbotron">

												<h4><strong>Anexar imagem.</strong></h4>

												<p>
												<input id="txtDocumento" type="file" onChange="convertToBase64(this, document.getElementById('arquivoBase64'));" accept=".jpg" />
													<input id="arquivoBase64" name="arquivoBase64" type="hidden" />
												</p> 

												<p>
													<label  class="control-label">Nome da imagem</label>
													<input class="form-control" name="nome_imagem" id="nome_imagem" type="text" size="40" maxlength="50">
												</p>

												<div>
													<a href="#"  onClick="salvarAnexo('<%=cod_atividade_pai%>')" class="btn btn-outline-success">Enviar foto da atividade</a>
													<a href="#"  onClick="window.location='atividades.asp?cd=<%=cod_disciplina%>'" class="btn btn-outline-secondary">Voltar a atividade</a>
												</div>

											</div>
											
											<input name="cod_atividade_pai" type="hidden" id="cod_atividade_pai" value="<%=cod_atividade_pai%>">
											<input name="cod_atividade_aluno" type="hidden" id="cod_atividade_aluno" >
										</form>		
										
										<p>
										<a id='dwnldLnk' download='.jpg' style="display:none;"></a> 
										<%
										
										sql = "select cod_atividade_aluno, nome_imagem, imagem "
										sql = sql & " from EAD_Atividade_aluno"
										sql = sql & " where cod_atividade_pai = " & cod_atividade_pai
										sql = sql & " and cod_aluno = " & Session("CodAluno_GemulEad")
										rs.open sql, cnn, 3, 3
										if not rs.eof then
											%>
											<div class="table-responsive">
												<table class="table table-striped">
													<tr>
														<td colspan="2"><strong>Lista de imagens enviadas</strong></td>
													</tr>
													<tr>
														<td><strong>Imagem</strong></td>
														<td><strong>Ação</strong></td>
													</tr>
												<%
												cont = 0
												while not rs.eof
													%>
													<tr>
														<td class="alinhar"><i class="fal fa-image fa-2x"></i>&nbsp;<%=rs("nome_imagem")%></td>
														<td>
															<input name="string64_<%=rs("cod_atividade_aluno")%>" id="string64_<%=rs("cod_atividade_aluno")%>" type="hidden" value="<%=rs("imagem")%>">
															<a href="#" onClick="visualizarAnexo('<%=rs("cod_atividade_aluno")%>','string64_<%=rs("cod_atividade_aluno")%>')" class="btn btn-outline-success">Baixar</a>
															<a href="#" onClick="removerDocumento('<%=rs("cod_atividade_aluno")%>')" class="btn btn-outline-danger">Remover</a>
														</td>
													</tr>
													<%
													
													cont = cont + 1
													rs.movenext
												wend
												%>
												<% 
													obs_professor = ""
													sql = " select a.obs, Convert(varchar(10),a.data_hora_incl,103) as data_hora_incl, LEFT(CAST(a.data_hora_incl AS Time),8) AS hora , SUBSTRING(u.USUA_NOME_COMPLETO, 0, CHARINDEX(' ', u.USUA_NOME_COMPLETO)) + ' ' +  REVERSE(SUBSTRING(REVERSE(u.USUA_NOME_COMPLETO), 0, CHARINDEX(' ', REVERSE(u.USUA_NOME_COMPLETO)))) as professor"
													sql = sql & "  from EAD_Atividade_aluno_obs a left join seg_usuarios_sistema u on u.USUA_CODG = a.usuario_incl "
													sql = sql & "  where cod_atividade_pai = " & cod_atividade_pai
													sql = sql & "  and cod_aluno = " & Session("CodAluno_GemulEad")
													RSAUX1.OPEN SQL, CNN
													IF RSAUX1.EOF = FALSE THEN
														obs_professor = RSAUX1("obs")
														professor = RSAUX1("professor")
														data_hora_incl = RSAUX1("data_hora_incl")
														hora = RSAUX1("hora")
														%>
														<tr>
															<td class="alinhar"><i class="fal fa-graduation-cap fa-2x"></i>&nbsp;<%=obs_professor%></td>
															<td class="alinhar"><i class="fal fa-graduation-cap"></i>&nbsp;<%=professor%>&nbsp;<%=data_hora_incl%>&nbsp;<%=hora%></td>
														
														</tr>
														<% 
													END IF
													RSAUX1.CLOSE
												%>
												</table>
											</div>
											<%
										end if    
										rs.close
										%>
										</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
					
                    <!-- this overlay is activated only when mobile menu is triggered -->
                    <div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div> 
					<!-- END Page Content -->
                    
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
		  
			function salvarAnexo(acao) {
			 var frm = document.getElementById("frm");
				if (frm.arquivoBase64.value == "") {
					alert("A imagem deve ser anexada!");
					return false;
				}
				
				if (frm.nome_imagem.value == "") {
					alert("O nome da imagem deve ser informada!");
					return false;
				}
				
				var str = frm.arquivoBase64.value;
				var res = str.substring(0, 15);	
				
				/*if (res != "data:image/jpeg") {
					alert("A imagem deve ser no formato JPG!");
					return false;
				}*/

				frm.action  = "enviar_foto_upload.asp?acao=I";
				frm.submit();
			}
			
			function convertToBase64(inputFile, inputOut) {
				//Read File
				var selectedFile = inputFile.files;
				//Check File is not Empty
				if (selectedFile.length > 0) {
					// Select the very first file from list
					var fileToLoad = selectedFile[0];
					// FileReader function for read the file.
					var fileReader = new FileReader();
					var base64;
					// Onload of file read the file content
					fileReader.onload = function (fileLoadedEvent) {
						base64 = fileLoadedEvent.target.result;
						// Print data in console
						// console.log(base64);
						inputOut.value = base64;
					};
					// Convert data to base64
					fileReader.readAsDataURL(fileToLoad);
				}
			}
			
			function removerDocumento(cod_atividade_aluno) {
				var r = confirm("Deseja remover essa imagem?");
				if (r == true) {
					document.getElementById("frm").cod_atividade_aluno.value = cod_atividade_aluno;
					document.getElementById("frm").action  = "enviar_foto_remover.asp?cod_atividade_aluno="+cod_atividade_aluno;
					document.getElementById("frm").submit();
				} 
			}

			function visualizarAnexo(cod_atividade_aluno, string64){
				var jpg = encodeURI(document.getElementById(string64).value);

				if (window.navigator.msSaveOrOpenBlob) {
					// Para os navegadores IE and Edge
					window.navigator.msSaveBlob(dataURItoBlob(jpg), this.id);
				} else {
					var dlnk = document.getElementById('dwnldLnk');
					dlnk.href = jpg;
					dlnk.download = cod_atividade_aluno + ".jpg"
					dlnk.click();
				}
			}


			function dataURItoBlob(dataURI) {
				// convert base64 to raw binary data held in a string
				// doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
				var byteString = atob(dataURI.split(',')[1]);

				// separate out the mime component
				var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

				// write the bytes of the string to an ArrayBuffer
				var ab = new ArrayBuffer(byteString.length);
				var ia = new Uint8Array(ab);
				for (var i = 0; i < byteString.length; i++) {
					ia[i] = byteString.charCodeAt(i);
				}

				// write the ArrayBuffer to a blob, and you're done
				var blob = new Blob([ab], {
					type: mimeString
				});
				return blob;

				// Old code
				// var bb = new BlobBuilder();
				// bb.append(ab);
				// return bb.getBlob(mimeString);
			}
		</script>   
    </body>
</html>
