<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!DOCTYPE html>
<!-- 
GEMUL 
Desenvolvedor: Sérgio Borges
Guapó - matrícula no layout novo (tela antiga: gemul2015/Sistema/MAT)
-->
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            GEMUL - Região - vincular setores
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<!--#include file="includes/inc_formatadata.asp"-->
    </head>
    <body class="nav-function-top header-function-fixed" style="">
		<script src="js/configuracoes_pagina.js"></script>
		<script src="js/js_funcoes_gerais.js"></script>
		<%
		pagina_inicial_do_modulo = "matricula.asp"
		pagina_atual = "/app/mat_regiao.asp"
		menu_principal = "Matrícula"
		sistema = "GEMUL"
		sistema_sigla = "MAT"
		modulo = "MAT"
		pagina = "Região - vincular setores"
		descricao_pagina = "Setores vinculados à região."
		mensagem_alerta_pagina = ""
		%>
        <div class="page-wrapper">
            <div class="page-inner">
				<!--#include file=inc_lado_esquerdo.asp-->
                <div class="page-content-wrapper">
					<!--#include file=inc_cabecalho.asp-->
					<!--#include file=mat_regiao_setor_cad.asp-->
					<!--#include file=inc_rodape.asp-->
					<!--#include file=inc_modal_atalho.asp-->
                </div>
            </div>
        </div>
		<!--#include file=inc_menu_rapido.asp-->
		<!--#include file=inc_mensagem.asp-->
        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
		<script>
			function salvar(acao){
				var frm = document.getElementById("frm");
				frm.action = "mat_regiao_setor_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}
			function marcaTodos(){
				var frm = document.getElementById("frm");
				for (var i = 0; i < frm.elements.length; i++) {
					if (frm.elements[i].type == "checkbox" && frm.elements[i].name == "chkEmp") frm.elements[i].checked = frm.chkTodos.checked;
				}
				return true;
			}
		</script>
    </body>
</html>
