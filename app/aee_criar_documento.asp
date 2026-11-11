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
            GEMUL - Documento
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<link rel="stylesheet" media="screen, print" href="css/formplugins/summernote/summernote.css">
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<script src="js/js_funcoes_gerais.js"></script>
		<%
		pagina_inicial_do_modulo = "atendimento.asp"
		pagina_atual = "/app/aee_criar_documento.asp"
		menu_principal = "Inicial"
		sistema = "GEMUL"
		sistema_sigla = "AEE"
		modulo = "AEE"
		pagina = "Criação de Documentos"
		descricao_pagina = "Cadastro documentos padrões para ser usado posteriormente, opções de inclusão, alteração, exclusão e consulta."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=aee_criar_documento_cad.asp-->
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
		<script src="js_app/aee_criar_documento.js"></script>
		<script src="js/formplugins/summernote/summernote.js"></script>
		<script>
			function dadosAluno(){
				if (mostraDadosAluno.style.display=="none"){
					mostraDadosAluno.style.display="table-row"
					frm.imgDadosAluno.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosAluno.style.display="none"
					frm.imgDadosAluno.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}
			function dadosEscolares(){
				if (mostraDadosEscolares.style.display=="none"){
					mostraDadosEscolares.style.display="table-row"
					frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosEscolares.style.display="none"
					frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}
			function dadosDataAtual(){
				if (mostraDadosDataAtual.style.display=="none"){
					mostraDadosDataAtual.style.display="table-row"
					frm.imgDadosDataAtual.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosDataAtual.style.display="none"
					frm.imgDadosDataAtual.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}
			function dadosRepresentantes(){
				if (mostraDadosRepresentantes.style.display=="none"){
					mostraDadosRepresentantes.style.display="table-row"
					frm.imgDadosRepresentantes.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosRepresentantes.style.display="none"
					frm.imgDadosRepresentantes.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}		
			function dadosAutorizacao(){
				if (mostraDadosAutorizacao.style.display=="none"){
					mostraDadosAutorizacao.style.display="table-row"
					frm.imgDadosAutorizacao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosAutorizacao.style.display="none"
					frm.imgDadosAutorizacao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}
			function dadosValidacao(){
				if (mostraDadosValidacao.style.display=="none"){
					mostraDadosValidacao.style.display="table-row"
					frm.imgDadosValidacao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosValidacao.style.display="none"
					frm.imgDadosValidacao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}
			function dadosUnidadeEscolar(){
				if (mostraDadosUnidadeEscolar.style.display=="none"){
					mostraDadosUnidadeEscolar.style.display="table-row"
					frm.imgDadosUnidadeEscolar.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				}
				else{
					mostraDadosUnidadeEscolar.style.display="none"
					frm.imgDadosUnidadeEscolar.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
				}
			}
			function mostraCampoInserir(linhacampo,marcou){
				if (marcou) {
					document.getElementById(linhacampo).style.display="table-row";
				} else {
					document.getElementById(linhacampo).style.display="none";
				}
			}

		</script>
        <script>
            /*var autoSave = $('#autoSave');
            var interval;
            var timer = function()
            {
                interval = setInterval(function()
                {
                    //start slide...
                    if (autoSave.prop('checked'))
                        saveToLocal();

                    clearInterval(interval);
                }, 3000);
            };

            //save
            var saveToLocal = function()
            {
                localStorage.setItem('summernoteData', $('#saveToLocal').summernote("code"));
                console.log("saved");
            }

            //delete 
            var removeFromLocal = function()
            {
                localStorage.removeItem("summernoteData");
                $('#saveToLocal').summernote('reset');
            }
			*/
            $(document).ready(function()
            {
			
				$('#txtTexto').summernote();
				/*
                //init default
                $('.js-summernote').summernote(
                {
                    height: 300,
                    tabsize: 2,
                    placeholder: "Digite aqui...",
                    dialogsFade: true,
                    toolbar: [
                        ['style', ['style']],
                        ['font', ['strikethrough', 'superscript', 'subscript']],
                        ['font', ['bold', 'italic', 'underline', 'clear']],
                        ['fontsize', ['fontsize']],
                        ['fontname', ['fontname']],
                        ['color', ['color']],
                        ['para', ['ul', 'ol', 'paragraph']],
                        ['height', ['height']]
                        ['table', ['table']],
                        ['insert', ['link', 'picture', 'video']],
                        ['view', ['fullscreen', 'codeview', 'help']]
                    ],
                    callbacks:
                    {
                        //restore from localStorage
                        onInit: function(e)
                        {
                           // $('.js-summernote').summernote("code", localStorage.getItem("summernoteData"));
						   //$('#htmlGerado').html('<%=strDescricao%>');
                        },
                        onChange: function(contents, $editable)
                        {
                            //clearInterval(interval);
                            //timer();
                        }
                    }
                });

                */

                //init mentions example
                $(".js-hint2mention").summernote(
                {
                    height: 100,
                    toolbar: false,
                    placeholder: "type starting with @",
                    hint:
                    {
                        mentions: ['jayden', 'sam', 'alvin', 'david'],
                        match: /\B@(\w*)$/,
                        search: function(keyword, callback)
                        {
                            callback($.grep(this.mentions, function(item)
                            {
                                return item.indexOf(keyword) == 0;
                            }));
                        },
                        content: function(item)
                        {
                            return '@' + item;
                        }
                    }
                });

            });

        </script>
		
    </body>
</html>
