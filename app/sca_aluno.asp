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
            GEMUL - Aluno
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file="includes/inc_replaceRequest.asp"-->
		<!--#include file="includes/inc_formataCPF.asp"-->		
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<script src="js/js_funcoes_gerais.js?v=2"></script>
		<!-- inicio funções para cep e mascara telefone -->
		<script src="js/jquery-2.1.3.min.js"></script>
		<script src="js/jquery.mask.min.js"></script>
		<style>
			.checkbox-group label {
				display: block;
				margin-bottom: 6px;
				font-weight: normal;
			}
			.checkbox-group input[type="checkbox"] {
				margin-left: -15px;
			}
			.checkbox-title {
				font-weight: bold;
				color: #000;
				margin: 6px -15px 4px;
			}
		</style>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/sca_aluno.asp"
		menu_principal = "Cadastro de Alunos"
		sistema = "GEMUL"
		sistema_sigla = "SCA"
		modulo = "SCA"
		pagina = "Ficha Cadastral"
		descricao_pagina = "Cadastro do aluno, opções de inclusão, alteração, exclusão e consulta."
		mensagem_alerta_pagina = "Observações:<br>"
		mensagem_alerta_pagina = mensagem_alerta_pagina  & "* O número da <code>Matrícula</code> o sistema se encarregará de gerar.<br>"
		mensagem_alerta_pagina = mensagem_alerta_pagina  & "* Para realizar mudança de <code>turma/turno/série</code>, basta entrar na aba dados escolares e selecionar a turma desejada. Se caso o aluno tiver sua série trocada durante a mudança, será criado pelo sistema uma nova grade de disciplinas zerando a anterior."		
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=sca_aluno_cad.asp-->
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
		<script src="js_app/sca_aluno.js?v=3"></script>
		<script type="text/javascript">
			$(document).ready(function () {
				 //definirMascaraCelular($("#txtFoneResidencial"));
				 //definirMascaraCelular($("#txtFonecelular"));
				 //definirMascaraCelular($("#txtFoneComercial"));
				 //definirMascaraCelular($("#txtPaifone"));
				 //definirMascaraCelular($("#txtMaefone"));
				 //definirMascaraCelular($("#txtResponsavelfone"));
				 
				 $("#txtCepresidencia").on("blur", function () {
					var cep = $(this).val();
					obterEndercoPorCEP(cep);	//dentro do sca_aluno.js
				});
			});
			
			/* busca de CEP agora fica no js_app/sca_aluno.js (tenta ViaCEP, OpenCEP e BrasilCEP)
			var obterEndercoPorCEP = function (numeroCEP) {
				$("#txtLogradouro").val("");
				$("#txtBairroaluno").val("");
				$("#cmbUFResidencia").val("9");
				$("#txtCidaderesidencia").val("");
				$("#txtComp_endereco").val("");

				var cep = numeroCEP.replace("-", "");
				var url = "https://viacep.com.br/ws/" + cep + "/json/";
				//var url = "https://opencep.com/v1/" + cep + ".json";

				$.getJSON(url, cep)
				 .done(function (endereco) {
					 if (endereco != null) {
						 $("#txtLogradouro").val($.trim(endereco.logradouro));
						 $("#txtBairroaluno").val(endereco.bairro);
						 //$("#cmbUFResidencia").val(endereco.uf);
						 $("#txtComp_endereco").val(endereco.complemento);
						 $("#txtCidaderesidencia").val(endereco.localidade);
					 }
				 });;
			};
			*/
			
			//var definirMascaraCelular = function (el) {
			//	$(el).keydown(function (event) {
			//		var target, phone, element;
			//		target = (event.currentTarget) ? event.currentTarget : event.srcElement;
			//		phone = target.value.replace(/\D/g, '');
			//		element = $(target);
			//		element.unmask();
			//		if (phone.length > 5 && (phone.substr(2, 1) == "9")) { //ele só vai colocar no formato de SP quando for ddd 11 e iniciar com 9.
			//			element.mask("(00) 00000-0000");
			//		} else {
			//			element.mask("(00) 0000-0000");
			//		}
			//	});
			//}
        </script>
		
        
    </body>
</html>
