<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />

    <!-- Bootstrap e estilos existentes -->
    <link href="../css/bootstrap.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="../css/geral.css" rel="stylesheet" />

    <!-- Fonte divertida e nosso tema infantil -->
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="../css/infantil.css" rel="stylesheet" />
	<style>
		/* ====== TABELA ESTILOSA ====== */
		.tabelaResumo {
			width: 85% !important;
			margin: 30px auto;
			border-collapse: separate;
			border-spacing: 0;
			background: #ffffff;
			border-radius: 12px;
			overflow: hidden;
			font-family: "Fredoka", sans-serif;
			box-shadow: 0 4px 12px rgba(0,0,0,0.08);
		}

		/* Células */
		.tabelaResumo td {
			padding: 14px 18px;
			font-size: 18px;
			border-bottom: 1px solid #e5e5e5;
		}

		/* Última linha sem borda */
		.tabelaResumo tr:last-child td {
			border-bottom: none;
		}

		/* Linhas alternadas */
		.tabelaResumo tr:nth-child(odd) {
			background: #fdfdfd;
		}
		.tabelaResumo tr:nth-child(even) {
			background: #F2FAFF;
		}

		/* Cabeçalho improvisado (como você usa a primeira coluna como texto) */
		.tabelaResumo tr td:first-child {
			font-weight: 700;
			color: #333;
		}

		/* Segunda coluna — números */
		.tabelaResumo tr td:nth-child(2) {
			text-align: center;
			font-weight: 600;
			color: #006699;
		}

		/* Hover divertido */
		.tabelaResumo tr:hover {
			background: #E1F5FF;
			transition: 0.3s;
		}

		/* Bordas mais suaves */
		.tabelaResumo td, .tabela tr {
			border: none !important;
		}

		/* Título acima da tabela (se quiser usar futuramente) */
		.tabelaTitulo {
			text-align: center;
			font-size: 22px;
			font-weight: 700;
			color: #005b8f;
			margin-bottom: 10px;
		}
		
		.box-msg-titulo {
			text-align: center!important;
		}
		
		/* Educação Infantil - amarelo claro */
		.linha-infantil {
			background: #FFF8C4; /* amarelo clarinho */
		}

		/* Ensino Fundamental - azul claro */
		.linha-fundamental {
			background: #E3F2FF; /* azul bebê */
		}

		/* Total - cinza claro */
		.linha-total {
			background: #dafdd6;
		}

		/* Opcional: melhorar visual */
		.linha-total td strong {
			color: #333;
			font-weight: 700;
		}
		/* Educação Infantil - amarelo claro */
		.linha-infantil td {
			background: #FFF6B0 !important;
		}

		/* Ensino Fundamental - azul claro */
		.linha-fundamental td {
			background: #DFF0FF !important;
		}

		/* Total - cinza claro */
		.linha-total td {
			background: #dafdd6 !important;
		}

		</style>
    <title>Matrícula 2026 - Guapó</title>
</head>
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_cnn.asp"-->
<body>

    <div class="container-fluid topo">
        <div class="row">
            <div class="col-md-6 imgTopo">
                <img id="logoAparecida" src="../img/logomarca-topo-guapo.png" alt="Guapó" vspace="15" />
            </div>
            <div class="col-md-6 imgTopo">
                <img id="logoGemul" src="../img/logomarca-topo-gemul.png" alt="Gemul - Gestor de Municípios" vspace="15" />
            </div>
        </div>
    </div>

    <div class="container box-msg box-msg-titulo">
        <div class="row">
            <div class="col-md-12">
                <div class="alert alert-dismissible fade in" role="alert" style="background: linear-gradient(180deg, #FFF 0%, #F8F9FF 100%);">
                    <h1 align="center"><strong><font color="#990000">Matrícula Informatizada 2026</font></strong></h1>
                    <p align="center">&nbsp;</p>
                    <h2 align="center"><strong>Inscrições para Educação Infantil e Ensino Fundamental!</strong></h2>
                    <!--h2 align="center"><strong>ENCERRADAS</strong>!</h2-->
                </div>
            </div>
        </div>
    </div>




<%
cont =0
intTotal = 0
SQL = "execute [s_Mat_ResumoGeralMatricula] 2026"
rs.open sql, cnn
if rs.eof = false then
	intTotalInscricoes = rs("totalInscricoes")
	intTotalEI = rs("totalEI")
	intTotalEICMEI = rs("totalEICMEI")
	intTotalEIComBolsa = rs("totalEIcomBolsa")
	intTotalEISemBolsa = rs("totalEIsemBolsa")
	intTotalEF = rs("totalEF")
	intTotalReservaEI = rs("totalReservaEI")
	intTotalReservaEF = rs("totalReservaEF")
	%>
      	
	 <div class="container box-msg">
        <div class="row">
            <div class="col-md-12">	
				<table class="tabelaResumo" width="65%" align="center">
					<tr class="linha-infantil">
						<td class="celula"><strong>Educação Infantil</strong></td>
						<td class="celula" align="center"><%=intTotalEI%></td>
					</tr>

					<tr class="linha-fundamental">
						<td class="celula"><strong>Ensino Fundamental</strong></td>
						<td class="celula" align="center"><%=intTotalEF%></td>
					</tr>

					<tr class="linha-total">
						<td class="celula"><strong>Total de Inscrições</strong></td>
						<td class="celula" align="center"><strong><%=intTotalEI+intTotalEF%></strong></td>
					</tr>
				</table>

			</div>
		</div>
		<div class="row">
            <div class="col-md-12">	
				<table width = "65%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabelaResumo">
					<tr bgcolor="#E7FBFE">
						<td height="35" class="celula"><strong> Cadastro de Reserva - Educação Infantil</strong></td>
						<td height="35" align="center" class="celula"><%=intTotalReservaEI%></td>
					</tr>
				</table> 
			</div>
		</div>
    </div>
 
 		   
      <%
end if
rs.close
%>
<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <!--input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" -->
				<!--input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" -->
    <input type="button" class="btn btn-warning" value="Atualizar Dados" onClick="window.location='Resumo.asp';" >
  <br /><br />
    
    </div>