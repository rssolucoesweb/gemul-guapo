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
		<!--include file=includes/inc_videoTutorial.asp-->
		
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

				document.getElementById("btnAlterar").disabled = true;

				frm.action = "sca_avaliacao_cod.asp?media=S";
				frm.submit();
				return true;	
			}
		</script>
    </body>
</html>
