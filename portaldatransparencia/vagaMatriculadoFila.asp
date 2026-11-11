<%@ Language="VBScript" CodePage="65001" %>
<% Response.CodePage = 65001 %>
<% Response.Charset  = "UTF-8" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Portal da Transparência - Vagas Matriculados e Disponibilidade</title>
    <link rel="stylesheet" href="css/index.css"> <!-- Se tiver CSS global -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<style>
		body {
			margin: 0;
			font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
		}

		/* Container geral para alinhamento */
		.container {
			max-width: 1100px;       /* largura máxima fixa para desktop */
			margin-left: auto;
			margin-right: auto;
			padding-left: 15px;      /* espaçamento interno horizontal */
			padding-right: 15px;
			box-sizing: border-box;  /* inclui padding na largura */
		}

		/* Main content e card usam o container para alinhamento */
		.main-content, .card {
			width: 100%; /* ocupa toda largura do container */
		}

		.top-bar {
			width: 100%;                   /* toda largura da janela */
			background-color: #0b4f91;    /* fundo azul */
			box-sizing: border-box;
		}
		
		.top-bar .container {
			max-width: 1100px;     /* mesma largura do restante da página */
			margin: 0 auto;        /* centralizar */
			padding: 10px 15px;    /* espaçamento interno */
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		/* Logo na top-bar */
		.top-bar .logos img {
			height: 40px;
		}

		/* Título na top-bar */
		.top-bar .titulo {
			font-weight: bold;
			text-transform: uppercase;
			font-size: 18px;
		}

		/* Tornar a tabela responsiva */
		.table {
			width: 100%;
			border-collapse: collapse;
			overflow-x: auto;
			display: block; /* para scroll horizontal em telas pequenas */
		}

		/* Responsividade para telas pequenas */
		@media (max-width: 768px) {



			/* Faz o top-bar empilhar verticalmente e centralizar */
			.top-bar {
				flex-direction: column;
				align-items: center;
				text-align: center;
				gap: 10px;
			}

			/* Ajusta título para tamanho menor */
			.top-bar .titulo {
				font-size: 16px;
			}

			/* Ajusta filtros para ficarem empilhados */

			.filtros {
					display: block;       /* empilha os filtros */
					flex-direction: column;
					gap: 5px;
			}

			.filtro-item {
				width: 100%;          /* ocupa toda largura */
			}

			.filtro-item select {
				width: 100%;          /* combos preenchem o container */
				min-width: unset;     /* remove restrição mínima do desktop */
				box-sizing: border-box;
			}
			
			/* Tabela com scroll horizontal */
			.table {
				display: block;
				overflow-x: auto;
			}
			
		}
		
		
		.titulo {
			color: white;      /* Cor branca */
			font-weight: bold; /* Negrito */
			text-transform: uppercase; /* Caixa alta */
		}


		.subtitulo {
			text-transform: uppercase; /* Caixa alta */
		}


		
		.main-content {
			padding: 5px;
		}

		.card {
			background-color: #ffffff;   /* Fundo branco */
			border-radius: 12px;         /* Bordas arredondadas */
			padding: 15px;               /* Espaçamento interno */
			box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Sombra suave */
		}
		
		.table {
			width: 100%;
			border-collapse: collapse; /* Junta as bordas */
		}

		/* Cabeçalho */
		.table thead th {
			background-color: #f5f5f5;
			border-bottom: 1px solid #dddddd;
			padding: 8px;
			text-align: left;
		}

		/* Bordas finas nas linhas */
		.table tbody tr {
			border-bottom: 1px solid #e0e0e0; /* Cinza claro */
		}

		/* Fundo alternado (zebrado) */
		.table tbody tr:nth-child(even) {
			background-color: #f9f9f9; /* Cinza bem claro */
		}

		.table tbody tr:nth-child(odd) {
			background-color: #ffffff; /* Branco */
		}

		/* Espaçamento interno */
		.table td {
			padding: 8px;
		}

		/* Efeito ao passar o mouse (opcional, fica bonito) */
		.table tbody tr:hover {
			background-color: #f1f1f1;
		}
		
		.atualizacao {
			font-family: 'Segoe UI', Arial, sans-serif; /* Fonte mais moderna */
			font-size: 12px;
			color: #666666; /* Cinza elegante */
			margin-bottom: 20px; /* Espaço antes da tabela */
		}
		
		.resultado_situacao {
			font-size: 11px; /* diminui um pouco */
		}
		
		.resultado_situacao_titulo {
			font-size: 14px; /* diminui um pouco */
			font-weight: bold; /* negrito */
			color: #003366; /* azul escuro */
		}
		
		.resultado_situacao_total {
			font-size: 11px; /* diminui um pouco */
			font-weight: bold; /* negrito */
			color: #003366; /* azul escuro */
		}
		
		.filtros {
			display: flex;
			gap: 20px;              /* Espaço entre os filtros */
			margin-bottom: 20px;    /* Espaço antes da tabela */
			align-items: end;
		}

		.filtro-item {
			display: flex;
			flex-direction: column;
			font-size: 14px;
		}

		.filtro-item label {
			margin-bottom: 5px;
			font-weight: 600;
			color: #444;
		}

		.filtro-item select {
			padding: 6px 8px;
			border: 1px solid #ccc;
			border-radius: 6px;
			min-width: 180px;
		}
		
		/* Overlay tela inteira */
		#loading {
			position: fixed;
			width: 100%;
			height: 100%;
			background: rgba(255, 255, 255, 0.95);
			top: 0;
			left: 0;
			z-index: 9999;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		/* Conteúdo central */
		.loading-content {
			text-align: center;
			font-family: 'Segoe UI', Arial, sans-serif;
			color: #333;
			font-size: 18px;
		}

		/* Ícone */
		.loading-content i {
			font-size: 40px;
			color: #007bff;
			margin-bottom: 10px;
			display: block;
		}
		
		.btn-voltar {
			background-color: #0b4f91;
			color: #ffffff;
			border: none;
			padding: 8px 14px;
			border-radius: 6px;
			cursor: pointer;
			font-size: 14px;
			display: inline-flex;
			align-items: center;
			gap: 6px;
		}

		.btn-voltar i {
			color: #ffffff; /* ícone branco */
		}

		.btn-voltar:hover {
			background-color: #083d70; /* azul um pouco mais escuro */
		}
		</style>
		
			
	</script>
	<!-- CSS COMBO COM FILTRO -->
	<style>
	.combo-container {
		position: relative;
		width: 100%;
		max-width: 100%;
		min-width: 500px;
	}

	#comboEmpresaInput {
		width: 100%;
		padding: 6px 12px;
		border-radius: 6px;
		border: 1px solid #ccc;
		font-size: 15px;
	}

	.combo-dropdown {
		position: absolute;
		top: 105%;
		left: 0;
		right: 0;
		max-height: 350px;
		overflow-y: auto;
		background: white;
		border: 1px solid #ddd;
		border-radius: 6px;
		box-shadow: 0 8px 20px rgba(0,0,0,0.08);
		display: none;
		z-index: 9999;
	}

	.combo-item {
		padding: 10px 12px;
		cursor: pointer;
		font-size: 14px;
	}

	.combo-item:hover {
		background-color: #f1f5f9;
	}

	.combo-item.selected {
		background-color: #e5f0ff;
		font-weight: 600;
	}	
	</style>
	<!-- FIM CSS COMBO COM FILTRO -->	
	</script>
	
	<!-- SCRIPT COMBO COM FILTRO -->
	<script>
		function abrirComboEmpresa() {
			document.getElementById("comboEmpresaDropdown").style.display = "block";
		}

		function fecharComboEmpresa() {
			document.getElementById("comboEmpresaDropdown").style.display = "none";
		}

		function selecionarEmpresa(valor, texto) {

			const inputTexto = document.getElementById("comboEmpresaInput");
			const hidden     = document.getElementById("cmbEmpresa");

			if (!inputTexto || !hidden) {
				alert("Erro interno: campos do combo não encontrados na página.");
				return;
			}

			inputTexto.value = texto;
			hidden.value = valor;

			// Remove seleção anterior
			const itens = document.getElementsByClassName("combo-item");
			for (let i = 0; i < itens.length; i++) {
				itens[i].classList.remove("selected");
			}

			// Marca o item atual
			for (let i = 0; i < itens.length; i++) {
				if (itens[i].getAttribute("data-value") == valor) {
					itens[i].classList.add("selected");
					break;
				}
			}

			fecharComboEmpresa();

			// Submete o form
			document.getElementById("frm").submit();
		}


		function filtrarComboEmpresa() {
			const filtro = document.getElementById("comboEmpresaInput").value.toUpperCase();
			const itens = document.getElementsByClassName("combo-item");

			let algumVisivel = false;

			for (let i = 0; i < itens.length; i++) {
				const txt = itens[i].innerText.toUpperCase();

				if (txt.indexOf(filtro) > -1) {
					itens[i].style.display = "";
					algumVisivel = true;
				} else {
					itens[i].style.display = "none";
				}
			}

			document.getElementById("comboEmpresaDropdown").style.display = "block";
		}

		// Fecha ao clicar fora
		document.addEventListener("click", function(event) {
			const combo = document.querySelector(".combo-container");
			if (!combo.contains(event.target)) {
				fecharComboEmpresa();
			}
		});

		document.addEventListener("DOMContentLoaded", function() {

			const hidden = document.getElementById("cmbEmpresa");
			const input  = document.getElementById("comboEmpresaInput");
			const itens  = document.getElementsByClassName("combo-item");

			if (!hidden || !input) return;

			const valorAtual = hidden.value;

			for (let i = 0; i < itens.length; i++) {
				if (itens[i].getAttribute("data-value") == valorAtual) {

					// Marca visualmente
					itens[i].classList.add("selected");

					// Coloca o TEXTO no input
					input.value = itens[i].textContent.trim();

					// (Opcional) rola até ele
					itens[i].scrollIntoView({ block: "nearest" });

					break;
				}
			}

		});	

	</script>

	<!-- FIM SCRIPT COMBO COM FILTRO -->	
</head>
<body>
	
	<!--div id="loading">
		<div class="loading-content">
			<i class="fa-solid fa-spinner fa-spin"></i>
			<span>Carregando, aguarde...</span>
		</div>
	</div-->
	
	<%
	intCodEmpresa = request.form("cmbEmpresa")
	if intCodEmpresa = "" then intCodEmpresa = "0"
	intCodPeriodo = request.form("cmbPeriodo")
	if intCodPeriodo = "" then intCodPeriodo = "0"
	%>



    <div class="top-bar">
        <div class="logos">
            <img src="img/logomarca-topo-guapo-semed.png" alt="Prefeitura de Guapó">
        </div>
        <div class="titulo">
            TOTAL DE VAGAS, MATRICULADOS E DISPONIBILIDADE
        </div>
    </div>


	<!--#include file="../includes/inc_cnn.asp"-->
    <!--#include file="../includes/inc_formatadata.asp"-->
	<!--#include file="../includes/inc_formataCPF.asp"-->
    
    <form name="frm" method="post" id="frm" action="vagaMatriculadoFila.asp" onsubmit="showLoading()">
	
    <div class="container">
        <div class="main-content">
			   <!-- Botão Voltar -->
			   <div style="margin-bottom:15px; text-align:right;">
					<button type="button" onclick="window.location.href='index.asp';"  class="btn-voltar">
						<i class="fa-solid fa-arrow-left"></i> Voltar
					</button>
				</div>
			   <div class="card">
					<h2>Vagas, matriculados e disponibilidade por unidade escolar</h2>
					<p class="atualizacao">
						Fila de espera atualizada em <%=formatadataap(date)%>&nbsp;<%=time%>
					</p>
					<div class="filtros">
						
						<div class="filtro-item">
							<label for="unidade">Unidade:</label>
							<!--#include file="includes/inc_cmbUnidades.asp"-->
						</div>

						<div class="filtro-item">
							<label for="periodo">Período:</label>
							<!--#include file="includes/inc_cmbPeriodosFila.asp"-->
						</div>

					</div>
					<div class="col-md-12">
						<font size="-1">
							<table class="table table-striped">
							  <thead>
								<tr>
								  <th width="15%" scope="col">Curso</th>
								  <th width="10%" scope="col">Período</th>
								  <th width="10%" scope="col">Turno</th>
								  <th width="10%" scope="col">Vagas</th>
								  <th width="10%" scope="col">Matriculados</th>
								  <th width="10%" scope="col">Disponível</th>
								</tr>
							  </thead>
							  <tbody>
								<%
								ano_letivo = year(date)
								sql = "exec [SP_portalDaTransparencia_vagas] " & ano_letivo & "," & intCodEmpresa & "," & intCodPeriodo
								'response.write sql & "<hr>"
								rs.open sql, cnn
								if not rs.eof then 
									cont = 0
									controle=0
									while not rs.eof 
										if empresa<>RS("empresa") then
											if controle=1 then
											%>
											<tr class="resultado_situacao_total">
											  <td colspan="3"><font color="#0000CC">Total</font></td>
											  <td align="center"><font color="#0000CC"><%=total_vagas%></font></td>
											  <td align="center"><font color="#0000CC"><%=total_matriculados%></font></td>
											  <td align="center"><font color="#0000CC"><%=total_disponivel%></font></td>
											</tr>
											<%
												total_vagas = 0
												total_matriculados = 0
												total_disponivel = 0
											end if
											%>
											<tr class="resultado_situacao_titulo">
											  <td colspan="6"><font color="#0000CC"><%=RS("empresa")%></font></td>
											</tr>
											<%
										end if
										
										total_vagas = total_vagas + RS("vagas")
										total_matriculados = total_matriculados + RS("matriculados")
										disponivel = RS("Disponiveis")
										if disponivel<0 then disponivel = 0
										%>
										<tr class="resultado_situacao">
										  <td><font color="#0000CC"><%=rs("curso")%></font></td>
										  <td><font color="#0000CC"><%=RS("periodo")%></font></td>
										  <td><font color="#0000CC"><%=RS("Turno")%></font></td>
										  <td align="center"><font color="#0000CC"><%=RS("vagas")%></font></td>
										  <td align="center"><font color="#0000CC"><%=RS("matriculados")%></font></td>
										  <td align="center"><font color="#0000CC"><%=disponivel%></font></td>
										</tr>
										<%
										controle=1
										empresa = RS("empresa")
										
										total_disponivel = total_disponivel + (disponivel)
										rs.movenext
									wend
										%>
										<tr class="resultado_situacao_total">
										  <td colspan="3"><font color="#0000CC">Total</font></td>
										  <td align="center"><font color="#0000CC"><%=total_vagas%></font></td>
										  <td align="center"><font color="#0000CC"><%=total_matriculados%></font></td>
										  <td align="center"><font color="#0000CC"><%=total_disponivel%></font></td>
										</tr>
										<%
								else
								%>
								<tr>
								  <td colspan="7"><span class="obrigatorio"><strong>Sem registros!</strong></span></td>
								</tr>
								<%
								end if
								rs.close
								%>
								</tbody>
							</table>
							
						</font>
		
					</div>
			   </div>
		</div>
	</div>
	</form>
	<!-- Rodapé fixo -->
	<footer class="footer-fixed" role="contentinfo">
		<div class="footer-left">
			<span>Rede Municipal de Educação de Guapó</span>
		</div>

		<div class="footer-right">
		</div>
	</footer>


	<script>
		window.onload = function() {
//			document.getElementById("loading").style.display = "none";
		};
	</script>

</body>
</html>
