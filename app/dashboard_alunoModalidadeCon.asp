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
				color: #555
            }
            .qtde-descricao {
                font-size: smal; 
				color: #999
            }

			tr:hover {
				background-color: #f2f2f2; /* Cor de fundo ao passar o mouse */
				cursor: pointer; /* Adiciona o efeito de cursor */
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
		pagina = "Dashboard - Aluno"
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
					<!--#include file=dashboard_alunoModalidade_con.asp-->
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

			var chartMatriculadosPorSerie = null
			var charAlunosPorTurno = null
			var strModalidade = document.getElementById("strModalidade").value;
			
			$( document ).ready(function() {
				if (document.getElementById("cmbEmpresaGrupo").value === "0") {
					document.getElementById("divAlunosNominal").style.display = "none";
				} else {
					document.getElementById("divAlunosNominal").style.display = "block";
				}
			});			

			// Função principal para desabilitar o botão e filtrar dados
			async function filtrarDados() {

				document.getElementById("btnFiltrar").disabled = true;
				
				const strTipoUnidadeEnsino = document.getElementById("cmbTipoEmpresa").value;
				const strUnidadeEnsino = document.getElementById("cmbEmpresaGrupo").value;
				const strAnoLetivo = document.getElementById("cmbAnoLetivo").value;
				
				document.getElementById("intCodTipoEmpresa").value = strTipoUnidadeEnsino;
				document.getElementById("intCodEmpresaGrupo").value = strUnidadeEnsino;
				document.getElementById("strAnoLetivo").value = strAnoLetivo;

				await fetchData(strTipoUnidadeEnsino, strUnidadeEnsino, strAnoLetivo);

				if (strUnidadeEnsino === "0") {
					document.getElementById("divAlunosNominal").style.display = "none";
				} else {
					document.getElementById("divAlunosNominal").style.display = "block";
				}

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

					let total=0;

					data1.forEach(item => {
						if (strModalidade === item.curso) {
							total = item.quantitativo;
						}
					});

					// const total = totalEI + totalEF + totalEJA;
					 document.getElementById("total").innerHTML = total;

					// Outros quantitativos
					const responseOutros = await fetch(`dashboard_aluno_cod.asp?acao=outrosQtde&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}&strAnoLetivo=${strAnoLetivo}&strModalidade=${strModalidade}`); // Substitua pela URL da API
					const dataOutros = await responseOutros.json();					
					if (dataOutros.length > 0) {
						const { transporte, atendimento_especial, bolsa_familia } = dataOutros[0];
						document.getElementById("totatTransporteEscolar").innerHTML = transporte;
						document.getElementById("totatAtendimentoEspecial").innerHTML = atendimento_especial;
						document.getElementById("totatBolsaFamilia").innerHTML = bolsa_familia;
					}



					// Segunda chamada: Alunos por mês
					const response2 = await fetch(`dashboard_aluno_cod.asp?acao=alunosPorSerie&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}&strAnoLetivo=${strAnoLetivo}&strModalidade=${strModalidade}`);
					const data2 = await response2.json();

					const labelsSeries = data2.map(item =>item.serie);
					const valuesSeries = data2.map(item => item.quantitativo);

					if (!chartMatriculadosPorSerie) {
						const ctxSeries = document.getElementById('alunosPorSerie').getContext('2d');
						chartMatriculadosPorSerie = new Chart(ctxSeries, {
							type: 'bar',
							maintainAspectRatio: false,
							responsive: true,
							data: {
								labels: labelsSeries,
								datasets: [{
									label: 'Quantidade de Alunos por Série',
									data: valuesSeries,
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
						//ATUALIZA O GRÁFICO
						chartMatriculadosPorSerie.data = {							
								labels: labelsSeries,
								datasets: [{
									label: 'Quantidade de Alunos por Série',
									data: valuesSeries,
									backgroundColor: '#90EE90',
									borderColor: '#90EE90',
									borderWidth: 1
								}]
							}
						chartMatriculadosPorSerie.update();
					}

					// // Terceira chamada: Alunos por turno
					const response3 = await fetch(`dashboard_aluno_cod.asp?acao=alunosPorTurno&strTipoUnidadeEnsino=${strTipoUnidadeEnsino}&strUnidadeEnsino=${strUnidadeEnsino}&strAnoLetivo=${strAnoLetivo}&strModalidade=${strModalidade}`);

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
									label: 'Quantidade de Alunos por Turno',
									data: valuesTurno,
									backgroundColor: ['#FFD700', '#1E90FF', '#993399'],
									borderColor: ['#DAA520', '#4682B4', '#00008B'],
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
						console.log("Atualizando gráfico de alunos por mês");
						charAlunosPorTurno.data = {							
							labels: labelsTurno,
							datasets: [{
								label: 'Quantidade de Alunos por Turno',
								data: valuesTurno,
								backgroundColor: ['#FFD700', '#1E90FF', '#993399'],
								borderColor: ['#DAA520', '#4682B4', '#00008B'],
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
			document.addEventListener("DOMContentLoaded", async () => {
				var tipo_unidade = document.getElementById("intCodTipoEmpresa").value;	
				var unidade = document.getElementById("intCodEmpresaGrupo").value;	
				var anoLetivo = document.getElementById("cmbAnoLetivo").value;
				
				if (anoLetivo === "") { 
					anoLetivo = '<%=session("strAnoLetivo")%>';
				}

				await fetchData(tipo_unidade, unidade, anoLetivo);
			});


			function atualizaListaAlunos(curso, periodo) {
				alert(curso + " " + periodo);
			}

			function formatarData(dataISO) {
            	const [ano, mes, dia] = dataISO.split("-");
            	return `${dia}/${mes}/${ano}`;
        	}

			function gerarImpressao(cod_aluno, ano_letivo, cod_turma, cod_empresa, semestre){
				var caminho = "/app/sca_rel_ficha_individual_rel.asp?notas=N&txtCodAluno="+ cod_aluno + "&txtAnoLetivo="+ ano_letivo + "&cmbSemestre="+ semestre + "&cmbTurma=" + cod_turma + "&txtCodEmpresa=" + cod_empresa;
				window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
			}			

			async function fetchAlunos(strModalidade, strPeriodo) {
            try {

				const tbody = document.querySelector("#alunos tbody");
                // Limpa o tbody antes de adicionar os novos dados
                tbody.innerHTML = '';
				const row = document.createElement("tr");
				row.innerHTML = `
					<td colspan="6">Aguarde... Buscando alunos...</td>
				`;
				tbody.appendChild(row);	

				const response = await fetch(`dashboard_aluno_cod.asp?acao=alunosNominal&strTipoUnidadeEnsino=${document.getElementById("cmbTipoEmpresa").value}&strUnidadeEnsino=${document.getElementById("cmbEmpresaGrupo").value}&strAnoLetivo=${document.getElementById("cmbAnoLetivo").value}&strModalidade=${strModalidade}&strPeriodo=${strPeriodo}`); // Substitua pela URL da API
                const data = await response.json();
                tbody.innerHTML = '';
                

				if (data.length > 0) {
					data.forEach(aluno => {
						const row = document.createElement("tr");
						row.innerHTML = `
							<td style="text-align: center;">${aluno.matricula}</td>
							<td>${aluno.nome}</td>
							<td style="text-align: center;">${formatarData(aluno.data_nascimento)}</td>
							<td>${aluno.periodo}</td>
							<td style="text-align: center;">${aluno.NomeTurma} - ${aluno.TurmaAluno}</td>
							<td style="text-align: end;">
								<button onclick="gerarImpressao(${aluno.codigo},${document.getElementById('cmbAnoLetivo').value},${aluno.Cod_Turma},${document.getElementById('cmbEmpresaGrupo').value},3)">📄 Ver Ficha</button>
							</td>
						`;
						tbody.appendChild(row);	
					});
					const row = document.createElement("tr");
					row.innerHTML = `<td colspan="6" style="text-align: end;padding-top:10px">Total de alunos: ${data.length}</td>`;			
					tbody.appendChild(row);			

				}else {
						const row = document.createElement("tr");
						row.innerHTML = `
							<td colspan="6">Nenhum aluno encontrado.</td>
						`;

						tbody.appendChild(row);	
				}
		
            } catch (error) {
                console.error("Erro ao buscar os alunos:", error);
            }
        }			

			// function alunoModalidade(strModalidade) {
			// 	var unidade = document.getElementById("cmbEmpresaGrupo").value;
			// 	var ano = document.getElementById("cmbAnoLetivo").value;
			// 	var url = "dashboard_alunoModalidadeCon.asp?cmbEmpresaGrupo=" + unidade + "&cmbAnoLetivo=" + ano + "&strModalidade=" + strModalidade;
			// 	window.location.href = url;
			// }




			// document.addEventListener("DOMContentLoaded", () => {

			// 	fetch("dashboard_alunoModalidade_cod.asp?acao=alunosPorSerie")
			// 		.then(response => response.json())
			// 		.then(data => {
			// 			const ctx = document.getElementById('alunosPorSerie').getContext('2d');
			// 			new Chart(ctx, {
			// 				type: 'bar',
			// 				data: data,
			// 				options: {
			// 					responsive: true,
			// 					plugins: {
			// 						legend: {
			// 							position: 'top' // Exibe a legenda no topo
			// 						},
			// 						tooltip: {
			// 							enabled: true // Exibe os valores ao passar o mouse
			// 						}
			// 					},
			// 					scales: {
			// 						x: {
			// 							stacked: false // Define as barras lado a lado
			// 						},
			// 						y: {
			// 							beginAtZero: true // Começa do zero
			// 						}
			// 					}
			// 				}
			// 			});
						
			// 		})
			// 		.catch(error => console.error("Erro ao buscar os dados: ", error));

			// 	fetch("dashboard_aluno_cod.asp?acao=alunosPorTurno")
			// 		.then(response => response.json())
			// 		.then(data => {

			// 			const labels = [];
			// 			const values = [];

			// 			// Mapear os dados recebidos
			// 			data.forEach(item => {
			// 				labels.push(item.turno);
			// 				values.push(item.quantidade);
			// 			});

			// 			// Criar o gráfico
			// 			const ctx = document.getElementById('alunosPorTurno').getContext('2d');
			// 			new Chart(ctx, {
			// 				type: 'doughnut', // Alterado para doughnut
			// 				data: {
			// 					labels: labels,
			// 					datasets: [{
			// 						label: 'Quantidade de Alunos por Turno',
			// 						data: values,
			// 						backgroundColor: ['#FFD700','#1E90FF','#993399'], // Cores para Masculino e Feminino
			// 						borderColor: ['#DAA520', '#4682B4','#00008B'], // Bordas para cada categoria
			// 						borderWidth: 0
			// 					}]
			// 				},
			// 				options: {
			// 					responsive: true,
			// 					plugins: {
			// 						legend: {
			// 							position: 'top',
			// 						},
			// 						tooltip: {
			// 							enabled: true
			// 						}
			// 					}
			// 				}
			// 			});
			// 		})
			// 		.catch(error => console.error("Erro ao buscar os dados: ", error));
					
			// 	fetch("dashboard_aluno_cod.asp?acao=alunosPorSexo")
			// 		.then(response => response.json())
			// 		.then(data => {

			// 			const labels = [];
			// 			const values = [];

			// 			// Mapear os dados recebidos
			// 			data.forEach(item => {
			// 				labels.push(item.sexo);
			// 				values.push(item.quantidade);
			// 			});

			// 			// Criar o gráfico
			// 			const ctx = document.getElementById('alunosPorSexo').getContext('2d');
			// 			new Chart(ctx, {
			// 				type: 'doughnut', // Alterado para doughnut
			// 				data: {
			// 					labels: labels,
			// 					datasets: [{
			// 						label: 'Quantidade de Alunos por Sexo',
			// 						data: values,
			// 						backgroundColor: ['#1E90FF','#d581d5'], // Cores para Masculino e Feminino
			// 						borderWidth: 0
			// 					}]
			// 				},
			// 				options: {
			// 					responsive: true,
			// 					plugins: {
			// 						legend: {
			// 							position: 'top',
			// 						},
			// 						tooltip: {
			// 							enabled: true
			// 						}
			// 					}
			// 				}
			// 			});
			// 		})
			// 		.catch(error => console.error("Erro ao buscar os dados: ", error));					

								
			// });
		</script>		
        
    </body>
</html>
