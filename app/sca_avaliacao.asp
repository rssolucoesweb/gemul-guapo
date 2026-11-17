<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
Response.Buffer = false
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
            GEMUL - Lançamento de notas das avaliações
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<!--#include file="../includes/inc_formatadata.asp"-->
		<!--#include file="includes/inc_aguarde.asp"-->
		<!--#include file=includes/inc_videoTutorial.asp-->
		

        <style>
          /* A tabela conserva a largura do nome e rola horizontalmente em telas menores. */
          .avaliacao-tabela-scroll { overflow-x: auto; width: 100%; }
          .avaliacao-tabela { width: 100%; min-width: 1200px; table-layout: fixed; }
          .avaliacao-tabela th, .avaliacao-tabela td { vertical-align: middle; }
          .avaliacao-tabela .col-ordem { width: 65px; }
          .avaliacao-tabela .col-matricula { width: 110px; }
          .avaliacao-tabela .col-nome { width: 300px; min-width: 300px; overflow-wrap: normal; word-break: normal; }
          .avaliacao-tabela .col-manual { width: 112px; text-align: center; }
          .avaliacao-tabela .col-nota { width: 125px; text-align: center; }
          .avaliacao-tabela .col-foto { width: 70px; text-align: center; }
          .avaliacao-tabela td.col-nome { line-height: 1.5; }
          /* Centraliza o indicador de aguarde em relação à janela, sem depender do menu. */
          #aguarde { position: fixed !important; top: 50% !important; left: 50% !important;
                     transform: translate(-50%, -50%) !important; z-index: 10050 !important; }
        </style>
    </head>
	<!-- class para trocar o menu para top ou lateral  <body class="mod-bg-1 "> -->
	<body class="nav-function-top header-function-fixed" style="">
	
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/sca_avaliacao.asp"
		menu_principal = "Inicial"
		sistema = "GEMUL"
		sistema_sigla = "SCA"
		modulo = "SCA"
		pagina = "Lançamento de notas das avaliações"
		descricao_pagina = "Cadastro das notas das avaliações, opções de inclusão, alteração, exclusão e consulta."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=sca_avaliacao_cad.asp-->
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
		<script>

			function maskIt(w,e,m,r,a){
				  // Cancela se o evento for Backspace
				  if (!e) var e = window.event
				  if (e.keyCode) code = e.keyCode;
				  else if (e.which) code = e.which;
				  // Variáveis da função
				  var txt  = (!r) ? w.value.replace(/[^\d]+/gi,'') : w.value.replace(/[^\d]+/gi,'').reverse();
				  var mask = (!r) ? m : m.reverse();
				  var pre  = (a ) ? a.pre : "";
				  var pos  = (a ) ? a.pos : "";
				  var ret  = "";
				  if(code == 9 || code == 8 || txt.length == mask.replace(/[^#]+/g,'').length) return false;
				  // Loop na máscara para aplicar os caracteres
				  for(var x=0,y=0, z=mask.length;x<z && y<txt.length;){
				  if(mask.charAt(x)!='#'){
				  ret += mask.charAt(x); x++; } 
				  else {
				  ret += txt.charAt(y); y++; x++; } }
				  // Retorno da função
				  ret = (!r) ? ret : ret.reverse() 
				  w.value = pre+ret+pos; }
				  // Novo método para o objeto 'String'
				  String.prototype.reverse = function(){
				 return this.split('').reverse().join(''); 
			 
			 };	

			function controlaFoco(proximoEnter) {
				var codigoTecla = event.keyCode;
				if (codigoTecla==13) { //enter
					document.all(proximoEnter).focus();
					document.all(proximoEnter).select();
				}
					
			}
			function calculaNota(valor){ //->função que ignora deixa somente 1 número após a vírgula. Ex.: 6.86 para 6.8
			
				var qtde;
				var i;
				var VNota = "";
				var ponto = false;
				valor = "" + valor.toFixed(1); //->converte para string
				qtde = valor.length;
			
				for(i=0;i<qtde;i++){
					VNota = VNota + valor.substring(i,i+1);
					if (valor.substring(i,i+1) =="."){
						ponto = true;
						break;
					}
				}
				
				if (ponto){
					VNota = VNota + valor.substring(i+1,i+2)
				}	
				
				return VNota;
			}


			function resultadoConsulta(intCodigo){
				
				var frm = document.getElementById("frm");
				frm.txtCodigo.value=intCodigo;
				frm.submit();
			}
			
			function validaNota(valor, posicao, linha){

				valor = valor.replace(",", "");

				if (valor < 0 || valor > 100){
					alert("Atenção: nota inválida, deve estar entre 0 a 10!");
					document.all["txtNota_" + linha + "_" + posicao].value = "";
					document.all["txtNota_" + linha + "_" + posicao].select();
					document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
					document.all["txtNota_" + linha + "_" + posicao].focus();
					return false;
				}else{
					if (valor.substring(0,2) == "10" && valor.substring(2,3) == "," && valor.substring(3,4) != "0") {
						alert("Atenção: nota inválida, deve estar entre 0 a 10!");
						document.all["txtNota_" + linha + "_" + posicao].value = "";
						document.all["txtNota_" + linha + "_" + posicao].select();
						document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
						document.all["txtNota_" + linha + "_" + posicao].focus();
						return false;
					
					}
					document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#FFB7B7";
					return true;
				}
			}	
			
			function AlunoFoto(codAluno) {
				window.open(
					'sca_foto_aluno.asp?cod_aluno=' + codAluno,
					'_blank',
					'resizable=yes,scrollbars=no'
				);
			}
			

            // Alterna o modo manual apenas para o aluno selecionado.
            function alternarNotaParcialManual(linha, marcado) {
                var campos = document.querySelectorAll('[data-nota-linha="' + linha + '"]');
                for (var i=0; i<campos.length; i++) {
                    var campo=campos[i];
                    var parcial=campo.getAttribute('data-nota-parcial')==='S';
                    if (parcial) {
                        campo.readOnly=!marcado;
                        if (!marcado) campo.value='';
                    } else {
                        if (marcado) campo.value='';
                        campo.readOnly=marcado || campo.getAttribute('data-original-readonly')==='1';
                    }
                }
            }
            function validarParciaisManuais() {
                var checks=document.querySelectorAll('input[name^="chkParcialManual_"]:checked');
                for(var i=0;i<checks.length;i++) {
                    var linha=checks[i].name.split('_').pop();
                    var campo=document.querySelector('[data-nota-linha="'+linha+'"][data-nota-parcial="S"]');
                    if(!campo || !/^\d+(?:[,.]\d{1,2})?$/.test(campo.value.trim()) || Number(campo.value.replace(',','.'))>10) {
                        alert('Informe uma Nota Parcial válida de 0 a 10 para o aluno da linha '+linha+'.');
                        if(campo) campo.focus();
                        return false;
                    }
                }
                return true;
            }

            async function atualizarNotasTransferencia(codAluno, botao) {
                if (!confirm('Deseja aproveitar as notas da escola de origem para este aluno?')) return false;
                botao.disabled = true;
                var textoAnterior = botao.textContent;
                botao.textContent = 'Atualizando...';
                try {
                    var dados = new URLSearchParams();
                    dados.append('codAluno', String(codAluno));
                    dados.append('anoLetivo', String(document.querySelector('[name="txtAnoLetivo"]').value));
                    var resposta = await fetch('sca_avaliacao_atualizar_transferencia.asp', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                        body: dados.toString(),
                        credentials: 'same-origin'
                    });
                    var resultado = (await resposta.text()).trim();
                    if (!resposta.ok || resultado !== 'OK') throw new Error(resultado || 'Falha na atualização.');
                    alert('Notas atualizadas com sucesso.');
                    var frm = document.getElementById('frm');
                    frm.action = 'sca_avaliacao.asp';
                    frm.submit(); // mantém os filtros selecionados
                } catch (erro) {
                    alert('Não foi possível atualizar as notas: ' + erro.message);
                    botao.disabled = false;
                    botao.textContent = textoAnterior;
                }
                return false;
            }

			function cadastrarNotas(){
			
				var frm = document.getElementById("frm");
				var intContMarcado=0;
				var strAlunos='';
				var strEja='';
				
				if (frm.cmbSemestre.value == "0"){
					alert("O Semestre deve ser informado!");
					frm.cmbSemestre.focus();
					return false;
				}
				if (frm.cmbCalculoAvaliacao.value == "0"){
					alert("Avaliação deve ser informada!");
					frm.cmbCalculoAvaliacao.focus();
					return false;
				}
				
				if (!validarParciaisManuais()) return false;
				document.getElementById("btnIncluir").disabled = true;
				
				frm.action = "sca_avaliacao_cod.asp";
				frm.submit();
				return true;	
			}
			
			function enviarMedia(){
			
				var frm = document.getElementById("frm");
				var intContMarcado=0;
				var strAlunos='';
				var strEja='';
				
				if (frm.cmbSemestre.value == "0"){
					alert("O Semestre deve ser informado!");
					frm.cmbSemestre.focus();
					return false;
				}
				if (frm.cmbCalculoAvaliacao.value == "0"){
					alert("Avaliação deve ser informada!");
					frm.cmbCalculoAvaliacao.focus();
					return false;
				}

				if (!validarParciaisManuais()) return false;
				document.getElementById("btnAlterar").disabled = true;

				frm.action = "sca_avaliacao_cod.asp?media=S";
				frm.submit();
				return true;	
			}
		</script>
    </body>
</html>
