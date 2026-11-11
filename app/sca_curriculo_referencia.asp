<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 


'----------------------
'----CONTROLE DE PERIODO DE TEMPO
'1 - BIMESTRE
'2 - TRIMESTRE

'se for EJA passa para bimestre

intCodCurso				= Trim(Request.Form("txtCodCurso"))	

if intCodCurso = "4" then 'eja
	SESSION("controlePeriodoDeTempo")=1
else
	SESSION("controlePeriodoDeTempo")=2
end if


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
            GEMUL - <%if SESSION("controleAcessoPlanejamentoAnual") = "1" then%>Curriculo Referência<%elseif SESSION("controleAcessoPlanejamentoAnual") = "2" then%>Planejamento Anual<%end if%>
        </title
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<link rel="stylesheet" media="screen, print" href="css/notifications/toastr/toastr.css">
		<!--#include file=inc_ico.asp-->
		<!--#include file="includes/inc_formatadata.asp"-->
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/jquery-2.1.3.min.js"></script>
		<script src="js/configuracoes_pagina.js"></script>
		<script src="js/js_funcoes_gerais.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		if SESSION("controleAcessoPlanejamentoAnual") = "1" then
			pagina_atual = "/app/sca_curriculo_referenciaCon.asp"
			menu_principal = "Inicial"
			sistema = "GEMUL"
			sistema_sigla = "PLA"
			modulo = "PLA"
			pagina = "Currículo Referência"
			descricao_pagina = "Cadastro do Currículo Referência, opções de inclusão, alteração, exclusão e consulta."
			pagina_anterior  = "sca_curriculo_referenciaCon.asp"
		elseif SESSION("controleAcessoPlanejamentoAnual") = "2" then
			pagina_atual = "/app/sca_planejamento_anualCon.asp"
			menu_principal = "Manutenção"
			sistema = "GEMUL"
			sistema_sigla = "PLA"
			modulo = "PLA"
			pagina = "PA - Planejamento Anual"
			descricao_pagina = "Cadastro do planejamento anual da unidade, com base no currículo referência, opções de inclusão, alteração, exclusão e consulta."
			pagina_anterior  = "sca_planejamento_anualCon.asp"
		end if
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=sca_curriculo_referencia_cad.asp-->
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
		<script src="js/notifications/toastr/toastr.js"></script>
		<script src="js_app/sca_curriculo_referencia.js?v=<%=now%>"></script>
        <script type="text/javascript">
        </script>
    </body>
</html>
