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
        <style>
            .qtde {
                font-size: 60px;
                text-align: center;
            }
            .panel-qtde {
                text-align: center;
            }
        </style>		
        <meta charset="utf-8">
        <title>
            GEMUL - Dashboard
        </title>
		<!--#include file="includes/inc_verificaSessionApp.asp"-->
		<!--#include file="includes/inc_cnn.asp"-->
		<!--#include file=inc_meta.asp-->
		<!--#include file=inc_css.asp-->
		<!--#include file=inc_ico.asp-->
		<!--#include file="includes/inc_formatadata.asp"-->
    </head>
    <body class="nav-function-top header-function-fixed" style="">
        <!-- DOC: script para salvar e carregar as configurações da página -->
		<script src="js/configuracoes_pagina.js"></script>
		<script src="js/js_funcoes_gerais.js"></script>
		<%
		pagina_inicial_do_modulo = "academico.asp"
		pagina_atual = "/app/dashboardCon.asp"
		menu_principal = "Dashboard"
		sistema = "GEMUL"
		sistema_sigla = "DAS"
		modulo = "DAS"
		pagina = "Dashboard - Servidores"
		descricao_pagina = "Gráficos e relatórios gerenciais."
		mensagem_alerta_pagina = ""
		
		strFiltro = request("f")
		intCodTipoEmpresa = request("cmbTipoEmpresa")
		intCodEmpresaGrupo = request("cmbEmpresaGrupo")
		strAnoLetivo  = request("cmbAnoLetivo")
		
		if strFiltro = "P" then
			strFiltroDesc = "Professores"
			strCategoria = 1
		elseif strFiltro = "A" then
			strFiltroDesc = "Administrativo"
			strCategoria = 2
		end if
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=dashboard_servidorDetalhe_con.asp-->
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
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
		<script>
			let myChart = null
			vetColor = [];

			$( document ).ready(function() {

				if (document.getElementById("cmbAnoLetivo").value === "0") {
					document.getElementById("cmbAnoLetivo").value = "<%=session("strAnoLetivo")%>";
				}
				let anoLetivo = document.getElementById("cmbAnoLetivo").value;
				let strCategoria = document.getElementById("txtCategoria").value;
				let strTipoUnidadeEnsino = document.getElementById("txtTipoEmpresa").value;
				let strUnidadeEnsino = document.getElementById("txtEmpresa").value;
				filtrarDados()
				fetchData(strTipoUnidadeEnsino, strUnidadeEnsino, anoLetivo, strCategoria); // Chama a função fetchData com os valores

				vetColor.push("#FF4069");
				vetColor.push("#FFCD56");
				vetColor.push("#36A2EB");
				vetColor.push("#00ACAC");
				vetColor.push("#da6c39");
				vetColor.push("#da6c39");

				vetColor.push("#FF4070");
				vetColor.push("#FFCD57");
				vetColor.push("#36A2EC");
				vetColor.push("#00ACAD");
				vetColor.push("#da6c40");

				vetColor.push("#FF4071");
				vetColor.push("#FFCD58");
				vetColor.push("#36A2ED");
				vetColor.push("#00ACAE");
				vetColor.push("#da6c41");    

				vetColor.push("#FF4072");
				vetColor.push("#FFCD59");
				vetColor.push("#36A2EE");
				vetColor.push("#00ACAF");
				vetColor.push("#da6c42");   

			});	

			// Função principal para desabilitar o botão e filtrar dados
			async function filtrarDados() {

				document.getElementById("btnFiltrar").disabled = true;
				const strTipoUnidadeEnsino = document.getElementById("cmbTipoEmpresa").value;
				const strUnidadeEnsino = document.getElementById("cmbEmpresaGrupo").value;
				const strAnoLetivo = document.getElementById("cmbAnoLetivo").value;
				const strCategoria = document.getElementById("txtCategoria").value;
				await fetchData(strTipoUnidadeEnsino, strUnidadeEnsino, strAnoLetivo, strCategoria);

				document.getElementById("btnFiltrar").disabled = false;
			}
			
			async function fetchData(strTipoUnidadeEnsino, strUnidadeEnsino, strAnoLetivo, strCategoria) {
				try {

					const response = await fetch(`dashboard_servidorDetalhe_cod.asp?acao=qtdeServidor&strCategoria=${strCategoria}&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}`);
					const data = await response.json();					
					if (data.length > 0) {
						const { concursado, nao_concursado } = data[0];
						document.getElementById("totalConcursados").innerHTML = concursado;
						document.getElementById("totalNaoConcursados").innerHTML = nao_concursado;
						document.getElementById("total").innerHTML = concursado + nao_concursado;
					}

					graficoPorVinculo();
					
				} catch (error) {
					console.error("Erro ao buscar os dados:", error);
				}
			}

function graficoPorVinculo () {

	$.get("dashboard_servidorDetalhe_cod.asp", { acao: "porVinculo", strTipoUnidadeEnsino: document.getElementById("cmbTipoEmpresa").value, strUnidadeEnsino: document.getElementById("cmbEmpresaGrupo").value, strCategoria: document.getElementById("txtCategoria").value }, function (data, status) {


		objJson = JSON.parse(data);

		vetVinculo = [];
		vetQtde = [];
        vetBackGround = [];

		var vinculo = "";
		for (var i = 0; i < objJson.length; i++) {
			if (vinculo !== objJson[i].vinculo.trim()) {
				vinculo = objJson[i].vinculo.trim();
				vetVinculo.push(vinculo)
                vetQtde.push(objJson[i].qtde)
                vetBackGround.push(vetColor[i])
			}
		}

		var color = Chart.helpers.color;
		var barChartData = {
			labels: vetVinculo,
			datasets: [{
				label: "Quantidade por Vinculo", // Adicione essa linha para definir um rótulo
				backgroundColor: vetBackGround,
				borderColor: '#ffffff',
				borderWidth: 1,
				data: vetQtde
			}]
		};

		if (myChart) {
			myChart.destroy();
		}		

		var ctx = document.getElementById('porVinculo').getContext('2d');
		myChart= new Chart(ctx, {
			type: 'bar',
			data: barChartData,
			options: {
				responsive: true,
			}
		});

	});

}	
		


		

		</script>
    </body>
</html>
