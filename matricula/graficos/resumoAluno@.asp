<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<meta name="format-detection" content="telephone=no">
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/estilo.css">    
    <title>Matrícula de Aparecida de Goiânia</title>

    <style type='text/css'>
       
		@media print {
        #botoes_imprimir {
            display: none;
        }
        #botoes_imprimir_1 {
            display: none;
        }
    }

    td {
	    background: #fff; /* Linhas com fundo cinza */
		font-family: Verdana, Geneva, sans-serif !important;
		font-size: 12 !important;	 
	}
	
	.celula12 
	{ 
		border-top: 0 solid #FFFFFF; 
		border-left: 1 solid #FFFFFF; 
		border-bottom: 1 solid #000000; 
		border-right: 0 solid #000000;
		border-color:#B9B9B9;
		font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #000000;
	}
	
    </style>
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-70820196-3"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    
      gtag('config', 'UA-70820196-3');
    </script>    

</head>
<body>

</head>
<body>
<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <!--input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" -->
				<!--input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" -->
    <input type="button" class="btn btn-default" value="<< Voltar" onClick="window.location='resumo@.asp';" >
  <br /><br />
  <div style="background: #fff; padding: 25px; border: #000 0px solid; width: 100%; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src="img/logo-grafico.png" alt="Prefeitura de Aparecida de Goiânia" /></td>
      </tr>
  </table>
<br>

<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;"><br />
    Quantitativos de Alunos Ativos (Matriculados) - <%=year(date)%><br /><br />
</div>

<hr>
<input type="button" class="btn btn-primary" value="Educa&ccedil;&atilde;o Infantil" style="width:100%" onClick="window.location='rel_resumoGeralAlunoEI_EF_Gemul@.asp?tp=EI';" ><br>
<hr>
<input type="button" class="btn btn-info" value="Ensino Fundamental" style="width:100%" onClick="window.location='rel_resumoGeralAlunoEI_EF_Gemul@.asp?tp=EF';" ><br>
<hr>
<input type="button" class="btn btn-success" value="EJA" style="width:100%" onClick="window.location='rel_resumoGeralAlunoEI_EF_Gemul@.asp?tp=EJA';" ><br>
