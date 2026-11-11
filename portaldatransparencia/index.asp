<%@ Language="VBScript" CodePage="65001" %>
<% Response.CodePage = 65001 %>
<% Response.Charset  = "UTF-8" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Lista de espera da Rede Municipal de Educação</title>
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
			color: #fff;
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

		}
		
		
		
		.main-content {
			padding: 5px;
		}

		.card {
			background-color: #ffffff;   /* Fundo branco */
			border-radius: 12px;         /* Bordas arredondadas */
			padding: 65px;               /* Espaçamento interno */
			box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Sombra suave */
		}
		
		.menu-botoes {
			display: flex;
			gap: 50px;
			justify-content: center;
			margin-top: 50px;
			margin-bottom: 50px;
			flex-wrap: wrap;
		}

		.btn-menu {
			background-color: #0b4f91;
			color: #ffffff;
			text-decoration: none;
			width: 350px;
			height: 140px;
			border-radius: 12px;
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			font-size: 18px;
			font-weight: bold;
			text-align: center;
			box-shadow: 0 6px 15px rgba(0,0,0,0.15);
			transition: all 0.3s ease;
		}

		.btn-menu i {
			font-size: 40px;
			margin-bottom: 15px;
			color: #fff;
		}

		.btn-menu:hover {
			background-color: #083d70;
			transform: translateY(-5px);
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
            <img src="img/logomarca-topo-guapo-semed.png" alt="Prefeitura de Guapó">
        </div>
        <div class="titulo">
            PORTAL DA TRANSPARÊNCIA
        </div>
    </div>


	<!--#include file="../includes/inc_cnn.asp"-->
    <!--#include file="../includes/inc_formatadata.asp"-->
	<!--#include file="../includes/inc_formataCPF.asp"-->
    
    <form name="frm" method="post" id="frm" action="listaEspera.asp" onsubmit="showLoading()">
	
    <div class="container">
        <div class="main-content">
			   
			   <div class="card">
					<h2 style="text-align:center;">Lista de espera da Rede Municipal de Educação</h2>

					<div class="menu-botoes">

						<a href="listaEspera.asp" class="btn-menu">
							<i class="fa-solid fa-list"></i>
							Lista de Espera em Creches
						</a>

						<a href="vagaMatriculadoFila.asp" class="btn-menu">
							<i class="fa-solid fa-school"></i>
							Vagas, matriculados e disponibilidade
						</a>
						
						<a href="https://acessoainformacao.guapo.go.gov.br/cidadao/legislacao/portaria/id=1551" target="_black" class="btn-menu">
							<i class="fa-solid fa-file-lines"></i>
							Critérios de Priorização
						</a>
						
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
			document.getElementById("loading").style.display = "none";
		};
	</script>

</body>
</html>
