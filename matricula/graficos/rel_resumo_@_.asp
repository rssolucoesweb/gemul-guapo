<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<meta name="format-detection" content="telephone=no">
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/estilo.css">    
    <title>Matrícula de Guapó</title>

    <style type='text/css'>
       
		@media print {
        #botoes_imprimir {
            display: none;
        }
        #botoes_imprimir_1 {
            display: none;
        }
    }

    tr.dif td {
	    background: #fff; /* Linhas com fundo cinza */
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
<!--#include file="includes/inc_formatadata.asp"-->
<%
strUsuarioCallcenter		= "S"
%>
<!--#include file="../includes/inc_cnn.asp"-->



<div style="background: #fff; padding: 25px; border: #000 0px solid; width: 100%; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src=",,/img/logo.png" alt="Prefeitura de Guapó" /></td>
      </tr>
  </table>
<br>
<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
    	Matr&iacute;cula Informatizada - <%=strAnoLetivo%><br />
    Resumo Geral<br /><br />
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
      	
		
      	<table width = "65%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr bgcolor="#E7FBFE">
                <td height="35" class="celula"><strong> Educação Infantil</strong></td>
                <td height="35" align="center" class="celula"><%=intTotalEI%></td>
            </tr>
			<tr bgcolor="#E7FBFE">
              <td height="35" class="celula"><strong> Ensino Fundamental</strong></td>
              <td height="35" align="center" class="celula"><%=intTotalEF%></td>
      		</tr>
			<tr bgcolor="#E7FBFE">
              <td height="35" class="celula"><strong> Total de Inscri&ccedil;&otilde;es</strong></td>
              <td height="35" align="center" class="celula"><strong><%=intTotalInscricoes%></strong></td>
      		</tr>
        </table>    
		
 
 		   
      <%
end if
rs.close
%>
<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <!--input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" -->
				<!--input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" -->
    <input type="button" class="btn btn-warning" value="Atualizar Dados" onClick="window.location='rel_resumo_@_.asp';" >
  <br /><br />
    
    </div>