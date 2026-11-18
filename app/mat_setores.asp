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
            GEMUL - Setores
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
		pagina_atual = "/app/mat_setores.asp"
		menu_principal = "Matrícula"
		sistema = "GEMUL"
		sistema_sigla = "MAT"
		modulo = "MAT"
		pagina = "Setores"
		descricao_pagina = "Cadastro de setores com opções de inclusão, alteração, exclusão e consulta."
		mensagem_alerta_pagina = ""
		%>
        <div class="page-wrapper">
            <div class="page-inner">
				<!--#include file=inc_lado_esquerdo.asp-->
                <div class="page-content-wrapper">
					<!--#include file=inc_cabecalho.asp-->
					<!--#include file=mat_setores_cad.asp-->
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
			function resultadoConsulta(intCodigo){
				var frm = document.getElementById("frm");
				frm.txtCodigo.value = intCodigo;
				frm.submit();
			}
			function salvar(acao){
				var frm = document.getElementById("frm");
				if (frm.txtDescricao && frm.txtDescricao.value == "") {
					alert("A descrição deve ser informada!");
					frm.txtDescricao.focus();
					return false;
				}
				if (acao == "E" && !confirm("Confirma a exclusão do setor?")) return false;
				frm.action = "mat_setores_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}
		</script>
    </body>
</html>
