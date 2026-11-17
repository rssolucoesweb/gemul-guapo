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
            GEMUL - Módulo Acadêmico
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/academico.asp"
		menu_principal = "Inicial"
		sistema = "GEMUL"
		sistema_sigla = "SCA"
		modulo = "SCA"
		pagina = "Acadêmico"
		descricao_pagina = "Gerencie toda vida acadêmica do aluno."
		mensagem_alerta_pagina = ""
		Session("MatriculaInformatizada")=""
		
		'**************************************
		'verifica perfil para mostrar alerta
		'**************************************
		'PERFIL COORDENADORES - 17
		'PERFIL ADMINISTRADOR - 2
		'PERFIL SECREATARIO GERAL - 15	
		'PERFIL COORDENADORES (TURNO) - 79
		strTemAcessoAlerta = "N"
		strCodPefilAcesso = "17,79,2,15"	'Guapó: 79 = COORDENADORES (TURNO); não tem o 38
		SQL = "SELECT ACES_PERF_CODG"
		SQL = SQL & " FROM SEG_ACESSOS_USUARIO"
		SQL = SQL & " WHERE ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
		SQL = SQL & " AND ACES_PERF_CODG in (" & strCodPefilAcesso & ")"
		rs.open sql, cnn
		if not rs.EOF then	
			strTemAcessoAlerta = "S"
		end if
		rs.close
		
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
                    <!-- INICIO conteudo -->
					<%
					if strTemAcessoAlerta = "S" then
					%>
					<!--#include file=academico_cad_ajax.asp-->
					<%
					else
					%>
					<!--#include file=academico_cad.asp-->
					<%
					end if
					%>
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
		<script src="js_app/sca_situacao_academica.js"></script>
        <script type="text/javascript">
        </script>
    </body>
</html>
