<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!DOCTYPE html>
<!-- 
GEMUL 
Version: 20.1.0
Desenvolvedor: Sérgio Borges
Website: http://gemul.com.br
Contato: sergio@rssolucoesweb.com.br
-->
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            GEMUL - Justificativa de faltas
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/sca_justificativa_faltas.asp"
		menu_principal = "Manutenção"
		sistema = "GEMUL"
		sistema_sigla = "SCA"
		modulo = "SCA"
		
		pagina = "Justificativa Faltas"
		descricao_pagina = "Cadastro de justificativa faltas, opções de inclusão, alteração, exclusão e consulta."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=sca_justificativa_faltas_cad.asp-->
					<!-- FIM conteudo -->
					
					<!--#include file=inc_rodape.asp-->
					
					<!--#include file=inc_modal_atalho.asp-->
					
                </div>
            </div>
        </div>
        <!-- FIm pagina -->
		
		<!--#include file=inc_menu_rapido.asp-->
        
		<!--#include file=inc_mensagem.asp-->
        
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
		<script src="js/js_funcoes_gerais.js"></script>
		<script src="js_app/sca_justificativa_faltas.js"></script>
		
		<link href="index.css" rel="stylesheet">
		<script src="bootstrap-wysiwyg.js"></script>
        <script type="text/javascript">
		$(function(){
				function initToolbarBootstrapBindings() {
				  var fonts = ['Serif', 'Sans', 'Arial', 'Arial Black', 'Courier', 
						'Courier New', 'Comic Sans MS', 'Helvetica', 'Impact', 'Lucida Grande', 'Lucida Sans', 'Tahoma', 'Times',
						'Times New Roman', 'Verdana'],
						fontTarget = $('[title=Font]').siblings('.dropdown-menu');
				  $.each(fonts, function (idx, fontName) {
					  fontTarget.append($('<li><a data-edit="fontName ' + fontName +'" style="font-family:\''+ fontName +'\'">'+fontName + '</a></li>'));
				  });
				  $('a[title]').tooltip({container:'body'});
					$('.dropdown-menu input').click(function() {return false;})
						.change(function () {$(this).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle');})
					.keydown('esc', function () {this.value='';$(this).change();});

				  $('[data-role=magic-overlay]').each(function () { 
					var overlay = $(this), target = $(overlay.data('target')); 
					overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());
				  });
				  if ("onwebkitspeechchange"  in document.createElement("input")) {
					var editorOffset = $('#editor').offset();
					$('#voiceBtn').css('position','absolute').offset({top: editorOffset.top, left: editorOffset.left+$('#editor').innerWidth()-35});
				  } else {
					$('#voiceBtn').hide();
				  }
				};
				function showErrorAlert (reason, detail) {
					var msg='';
					if (reason==='unsupported-file-type') { msg = "Unsupported format " +detail; }
					else {
						console.log("error uploading file", reason, detail);
					}
					$('<div class="alert"> <button type="button" class="close" data-dismiss="alert">&times;</button>'+ 
					 '<strong>File upload error</strong> '+msg+' </div>').prependTo('#alerts');
				};
				initToolbarBootstrapBindings();  
				$('#editor').wysiwyg({ fileUploadError: showErrorAlert} );
				window.prettyPrint && prettyPrint();
			  });
        </script>
    </body>
</html>
