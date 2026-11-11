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
            GEMUL - Acompanhamento
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file="includes/inc_formatadata.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<style>
			.verde 
				{
				color: #0dc90d;
				}
			.vermelho 
				{
				color: red;
				}
				
			.fonteCodigo {
				font-size: 11px !important;
				font-weight: bold !important;
			}
			
		
			.filtro {
				display: flex !important; /* Ativa o modo Flexbox */
			}
			
			.item {
				flex: 1; /* Cada item vai crescer para ocupar o espaço disponível */
				margin: 10px; /* Espaço ao redor dos itens */
				padding: 20px; /* Espaço interno dos itens */
				background-color: #f0f0f0; /* Cor de fundo dos itens */
				border: 1px solid #ccc; /* Borda dos itens */
			}
			
			.colunaMaior {
				width: 250px !important; /* Define a largura para todas as colunas */
			}
			
			
		</style>
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/ste_transporte_acompanhamento.asp"
		menu_principal = "Manutenção"
		sistema = "GEMUL"
		sistema_sigla = "STE"
		modulo = "STE"
		pagina = "Acompanhamento das solicitações cadastradas"
		descricao_pagina = "Vincula a solicitação a rota do transporte escolar"
		mensagem_alerta_pagina = ""
		strEmpresa_submit = "S"
		strSituacao = request("cmbSituacao")
		if strSituacao = "" then strSituacao = "S"
		
		intCodSetor = request("cmbSetor")
		if intCodSetor = "" then intCodSetor = "0"
		
		intCodTurno = request("cmbTurno")
		if intCodTurno = "" then intCodTurno = "0"
		
		intCodEmpresa = request("cmbEmpresa")
		if intCodEmpresa = "" then intCodEmpresa = "0"
		
		intCodEscolaEstadual = request("cmbEscolaEstadual")
		if intCodEscolaEstadual = "" then intCodEscolaEstadual = "0"
		
		strRede = request("cmbRede")
		if strRede = "" then 
			strRede = "0"
		end if

		strMostraComboEscolaMunicipal = " style='display: none'"
		strMostraComboEscolaEstadual = " style='display: none'"
		
		if strRede = "M" then
			strMostraComboEscolaMunicipal = " style='display: block'"
			strMostraComboEscolaEstadual = " style='display: none'"
		elseif strRede = "E" then
			strMostraComboEscolaMunicipal = " style='display: none'"
			strMostraComboEscolaEstadual = " style='display: block'"
		end if 
		
		strTurno = ""
		strAnoLetivo = year(date)
		Cod_Semestre = 3
		if intCodTurno<>"0" then
			sql = "SELECT DESC_TURNO"
			sql = sql & " FROM SCA_TURNO"
			SQL = SQL & " WHERE cod_turno = " & intCodTurno
			RS.OPEN SQL, CNN
			IF RS.EOF = FALSE THEN
				strTurno = RS("DESC_TURNO")
			END IF
			rs.close
		end if
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=ste_transporte_acompanhamento_cad.asp-->
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
		<script src="js_app/ste_transporte_acompanhamento.js"></script>
        <script type="text/javascript">
        </script>
    </body>
</html>
