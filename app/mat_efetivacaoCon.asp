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
            GEMUL - Efetivação
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file="includes/inc_formataCPF.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<style>
		.col-1, .col-2, .col-3, .col-4, .col-5, .col-6, .col-7, .col-8, .col-9, .col-10, .col-11, .col-12, .col, .col-auto, .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm, .col-sm-auto, .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12, .col-md, .col-md-auto, .col-lg-1, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg, .col-lg-auto, .col-xl-1, .col-xl-2, .col-xl-3, .col-xl-4, .col-xl-5, .col-xl-6, .col-xl-7, .col-xl-8, .col-xl-9, .col-xl-10, .col-xl-11, .col-xl-12, .col-xl, .col-xl-auto {
			padding-top: 0.75rem;
		}
		
		  table td,
		  table th {
			vertical-align: middle !important;
		  }

		  table input.form-control {
			display: inline-block;
			width: auto;
			margin: 0 auto;
		  }

	</style>
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "matricula.asp"
		pagina_atual = session("urlRaizLocalSistema") & "/app/mat_efetivacaoCon.asp"
		menu_principal = "Matrícula"
		sistema_sigla = "MAT"
		modulo = "MAT"
		pagina = "Confirmação da Efetivação de Aluno Novatos"
		descricao_pagina = "Confirmação e correção de dados do aluno para efetivação."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=mat_efetivacao_con.asp-->
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
        <script type="text/javascript">
		
				function DadosDoAluno(){
					var frm = document.getElementById("frm");
					if (frm.txtNomealuno.value==""){
						alert("O Nome do Aluno deve ser informado.")
						frm.txtNomealuno.focus()
						return false;
					}
					if (frm.txtDatanascimento.value==""){
						alert("A Data de Nascimento deve ser informada.")
						frm.txtDatanascimento.focus()
						return false;
					}
					if (frm.txtMae.value==""){
						alert("Nome da Mãe deve ser informada.")
						frm.txtMae.focus()
						return false;
					}
					document.frm.cmdConfirmar.disabled = true;
					document.frm.cmdConfirmar.value = "Aguarde, efetivação está sendo processada.";
					document.querySelectorAll('[disabled]').forEach(el => {
						el.disabled = false;
					  });
					frm.action = "mat_efetivacaoCon_cod.asp?acao=I";
					frm.submit();
					return true;	
				}
				
				function cancelarSolicitacao(){
					var frm = document.getElementById("frm");
					if (!confirm('Deseja realmente cancelar essa solicitação?'))
						return false;
					else{
						frm.action = "mat_efetivacaoCon_cod.asp?acao=C";
						frm.submit();
						return true;	
					}
				}
				

        </script>
    </body>
</html>
