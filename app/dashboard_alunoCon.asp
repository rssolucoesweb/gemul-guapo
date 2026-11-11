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
                font-size: xxx-large; 
				color: #555;
            }
            .qtde: hover {
                font-size: xxx-large; 
				color: #999;
				cursor: pointer;
            }			
            .qtde-descricao {
                font-size: smal; 
				color: #999
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
		pagina = "Dashboard - Alunos"
		descricao_pagina = "Gráficos e relatórios gerenciais."
		mensagem_alerta_pagina = ""
		%>
        <!-- INICIO pagina -->
        <div class="page-wrapper">
            <div class="page-inner">
                
				<!--#include file=inc_lado_esquerdo.asp-->
				
                <div class="page-content-wrapper">
				
					<!--#include file=inc_cabecalho.asp-->
					
                    <!-- INICIO conteudo -->
					<!--#include file=dashboard_aluno_con.asp-->
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
			var chartMatriculadosPorMes = null
			var charAlunosPorTurno = null

			$( document ).ready(function() {
				if (document.getElementById("cmbAnoLetivo").value === "0") {
					document.getElementById("cmbAnoLetivo").value = "<%=session("strAnoLetivo")%>";
				}
				 filtrarDados()
			});	

			// Função principal para desabilitar o botão e filtrar dados
			async function filtrarDados() {

				document.getElementById("btnFiltrar").disabled = true;
				const strUnidadeEnsino = document.getElementById("cmbEmpresaGrupo").value;
				const strAnoLetivo = document.getElementById("cmbAnoLetivo").value;
				const strTipoUnidadeEnsino = document.getElementById("cmbTipoEmpresa").value;

				await fetchData(strTipoUnidadeEnsino, strUnidadeEnsino, strAnoLetivo);

				document.getElementById("btnFiltrar").disabled = false;
			}

			// Função para buscar os dados
			async function fetchData(strTipoUnidadeEnsino, strUnidadeEnsino, strAnoLetivo) {
				try {
					// Primeira chamada: Quantitativo por curso
					const response1 = await fetch(
						`dashboard_aluno_cod.asp?acao=qtde&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}&strAnoLetivo=${strAnoLetivo}`
					);
					const data1 = await response1.json();

					let totalEI = 0, totalEF = 0, totalEJA = 0;

					data1.forEach(item => {
						switch (item.curso) {
							case 'EDUCAÇÃO INFANTIL':
								totalEI = item.quantitativo;
								break;
							case 'ENSINO FUNDAMENTAL':
								totalEF = item.quantitativo;
								break;
							case 'EJA':
								totalEJA = item.quantitativo;
								break;
							default:
								break;
						}
					});

					const total = totalEI + totalEF + totalEJA;

					document.getElementById("total").innerHTML = total.toString();
					document.getElementById("totalEI").innerHTML = totalEI.toString();
					document.getElementById("totalEF").innerHTML = totalEF.toString();
					document.getElementById("totalEJA").innerHTML = totalEJA.toString();

					// Segunda chamada: Alunos por mês
					const response2 = await fetch(`dashboard_aluno_cod.asp?acao=alunosPorMes&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}&strAnoLetivo=${strAnoLetivo}`);
					const data2 = await response2.json();

					const meses = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
					const labelsMeses = data2.map(item => meses[item.mes - 1]);
					const valuesMeses = data2.map(item => item.quantidade);

					if (!chartMatriculadosPorMes) {
						const ctxMeses = document.getElementById('alunosPorMes').getContext('2d');
						chartMatriculadosPorMes = new Chart(ctxMeses, {
							type: 'bar',
							maintainAspectRatio: false,
							responsive: true,
							data: {
								labels: labelsMeses,
								datasets: [{
									label: 'Quantidade de Alunos por Mês',
									data: valuesMeses,
									backgroundColor: '#90EE90',
									borderColor: '#90EE90',
									borderWidth: 1
								}]
							},
							options: {
								scales: {
									x: { stacked: false },
									y: { beginAtZero: true }
								}
							}
						});
					}else {

						chartMatriculadosPorMes.data = {							
								labels: labelsMeses,
								datasets: [{
									label: 'Quantidade de Alunos por Mês',
									data: valuesMeses,
									backgroundColor: '#90EE90',
									borderColor: '#90EE90',
									borderWidth: 1
								}]
							}
						chartMatriculadosPorMes.update();
					}

					// // Terceira chamada: Alunos por turno
					const response3 = await fetch(`dashboard_aluno_cod.asp?acao=alunosPorTurno&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}&strAnoLetivo=${strAnoLetivo}`);
					const data3 = await response3.json();

					const labelsTurno = data3.map(item => item.turno);
					const valuesTurno = data3.map(item => item.quantidade);

					if (!charAlunosPorTurno) {
						const ctxTurno = document.getElementById('alunosPorTurno').getContext('2d');
						charAlunosPorTurno = new Chart(ctxTurno, {
							type: 'doughnut',
							data: {
								labels: labelsTurno,
								datasets: [{
									label: 'Quantidade',
									data: valuesTurno,
									backgroundColor: ['#FFD700', '#1E90FF', '#993399','#FF8C00'],
									borderColor: ['#DAA520', '#4682B4', '#80080', '#CD6600'],
									borderWidth: 0
								}]
							},
							options: {
								responsive: true,
								plugins: {
									legend: { position: 'top' },
									tooltip: { enabled: true }
								}
							}
						});
					}else {
						charAlunosPorTurno.data = {							
							labels: labelsTurno,
							datasets: [{
								label: 'Quantidade',
								data: valuesTurno,
								backgroundColor: ['#FFD700', '#1E90FF', '#993399','#FF8C00'],
								borderColor: ['#DAA520', '#4682B4', '#80080', '#CD6600'],
								borderWidth: 0
							}]
						}						
						charAlunosPorTurno.update();
					}
				} catch (error) {
					console.error("Erro ao buscar os dados:", error);
				}
			}

			// Evento para executar automaticamente ao carregar a página

			$(document).ready(function () {
				
				let anoLetivo = document.getElementById("cmbAnoLetivo").value;
				
				if (anoLetivo === "") { 
					anoLetivo = '<%=session("strAnoLetivo")%>'; // Define o valor padrão caso esteja vazio
				}
				
				fetchData(0, 0, anoLetivo); // Chama a função fetchData com os valores
			});

			function alunoModalidade(strModalidade) {
				var tipo_unidade = document.getElementById("cmbTipoEmpresa").value;
				var unidade = document.getElementById("cmbEmpresaGrupo").value;
				var ano = document.getElementById("cmbAnoLetivo").value;
				var url = "dashboard_alunoModalidadeCon.asp?cmbTipoEmpresa=" + tipo_unidade + "&cmbEmpresaGrupo=" + unidade + "&cmbAnoLetivo=" + ano + "&strModalidade=" + strModalidade;
				window.location.href = url;
			}

		</script>
	
        
    </body>
</html>
