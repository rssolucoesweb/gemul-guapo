<%@ Language="VBScript" CodePage="65001" %>
<% Response.CodePage = 65001 %>
<% Response.Charset  = "UTF-8" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Portal da Transparência - Vagas Matriculados e Fila</title>
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
		
		
		.lista-documentos {
			margin-top: 20px;
			display: flex;
			flex-direction: column;
			gap: 15px;
		}

		.documento-item {
			display: flex;
			justify-content: space-between;
			align-items: center;
			padding: 15px;
			border: 1px solid #e0e0e0;
			border-radius: 10px;
			background-color: #f9f9f9;
			transition: 0.2s ease;
		}

		.documento-item:hover {
			background-color: #f1f1f1;
		}

		.documento-info {
			display: flex;
			align-items: center;
			gap: 15px;
			font-weight: 600;
			color: #333;
		}

		.documento-info i {
			font-size: 28px;
			color: #c62828; /* vermelho tipo PDF */
		}

		.btn-download {
			background-color: #0b4f91;
			color: #fff;
			text-decoration: none;
			padding: 8px 14px;
			border-radius: 6px;
			font-size: 14px;
			display: flex;
			align-items: center;
			gap: 6px;
		}

		.btn-download:hover {
			background-color: #083d70;
		}
		
		.btn-download i {
			color: #ffffff;
		}
		
		.nota-informativa {
			margin-top: 30px;
			padding: 20px;
			background-color: #f4f8fc;
			border-left: 5px solid #0b4f91;
			border-radius: 8px;
			font-size: 14px;
			color: #333;
			line-height: 1.6;
		}

		.nota-informativa strong {
			color: #0b4f91;
		}

		.nota-informativa .titulo-nota {
			font-weight: bold;
			margin-bottom: 10px;
			text-transform: uppercase;
		}
				
		</style>
		
			
	</script>

</head>
<body>
	
	<div id="loading">
		<div class="loading-content">
			<i class="fa-solid fa-spinner fa-spin"></i>
			<span>Carregando, aguarde...</span>
		</div>
	</div>
	
	


    <div class="top-bar">
        <div class="logos">
            <img src="img/logomarca-topo-anapolis-semed.png" alt="Prefeitura de Anápolis">
        </div>
        <div class="titulo">
            PORTARIA E ANEXOS
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
					<h2>Portaria e anexos</h2>
					<div class="col-md-12">
					
						<font size="-1">
							
							<div class="lista-documentos">

								<!-- Documento 1 -->
								<div class="documento-item">
									<div class="documento-info">
										<i class="fa-solid fa-file-pdf"></i>
										Portaria 083 – Educação Infantil 2026
									</div>
									<a href="docs/Portaria_083_Educacao_Infantil_2026.pdf" 
									   class="btn-download" 
									   download>
										<i class="fa-solid fa-download"></i>
										Baixar
									</a>
								</div>

								<!-- Documento 2 -->
								<div class="documento-item">
									<div class="documento-info">
										<i class="fa-solid fa-file-pdf"></i>
										ANEXO II – Critérios de Pontuação
									</div>
									<a href="docs/ANEXO_II_CRITERIOS_DE_PONTUACAO.pdf" 
									   class="btn-download" 
									   download>
										<i class="fa-solid fa-download"></i>
										Baixar
									</a>
								</div>

								<!-- Documento 3 -->
								<div class="documento-item">
									<div class="documento-info">
										<i class="fa-solid fa-file-pdf"></i>
										ANEXO III – Documentos Comprobatórios
									</div>
									<a href="docs/ANEXO_III_DOCUMENTOS_COMPROBATORIOS.pdf" 
									   class="btn-download" 
									   download>
										<i class="fa-solid fa-download"></i>
										Baixar
									</a>
								</div>
							</div>		
							
						</font>
		
					</div>
					
					<div class="nota-informativa">

						<div class="titulo-nota">
							<i class="fa-solid fa-circle-info" style="color:#0b4f91;"></i>
							Nota Informativa
						</div>

						<p><strong>Senhores pais e/ou responsáveis,</strong></p>

						<p>
							A Lista de espera para vagas na CRECHE 
							(<strong>Infantil I, II e III</strong>) é organizada conforme critérios de 
							vulnerabilidade socioeconômica, de acordo com a 
							<strong>Portaria nº 083/2025</strong>.
						</p>

						<p>
							Informamos que a <strong>posição na fila não é fixa, podendo sofrer alterações</strong> 
							sempre que houver novas inscrições ou atualizações cadastrais de famílias 
							em maior situação de vulnerabilidade social.
						</p>

					</div>
			   </div>
		</div>
	</div>
	</form>
	<!-- Rodapé fixo -->
	<footer class="footer-fixed" role="contentinfo">
		<div class="footer-left">
			<span>Rede Municipal de Educação de Anápolis</span>
		</div>

		<div class="footer-right">
		</div>
	</footer>


	<script>
		window.onload = function() {
			document.getElementById("loading").style.display = "none";
		};
	</script>

</body>
</html>
