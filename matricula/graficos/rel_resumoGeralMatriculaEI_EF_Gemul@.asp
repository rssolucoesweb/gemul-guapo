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
<!--#include file="includes/inc_formatadata.asp"-->
<%
strUsuarioCallcenter		= "S"
%>
<!--#include file="../includes/inc_cnn.asp"-->

<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <!--input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" -->
				<!--input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" -->
    <input type="button" class="btn btn-default" value="<< Voltar" onClick="window.location='resumo@.asp';" >
    <input type="button" class="btn btn-warning" value="Atualizar Dados" onClick="window.location='rel_resumoGeralMatriculaEI_EF_Gemul@.asp';" >
  <br /><br />
    
    </div>

<div style="background: #fff; padding: 25px; border: #000 0px solid; width: 100%; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src="img/logo-grafico.png" alt="Prefeitura de Aparecida de Goiânia" /></td>
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
SQL = "execute [s_Mat_ResumoGeralMatricula]"
rs.open sql, cnn
if rs.eof = false then
	intTotalInscricoes = rs("totalInscricoes")
	intTotalEI = rs("totalEI")
	intTotalEICMEI = rs("totalEICMEI")
	intTotalEIParcial = rs("totalEIparcial")
	intTotalEIComBolsa = rs("totalEIcomBolsa")
	intTotalEISemBolsa = rs("totalEIsemBolsa")
	intTotalEF = rs("totalEF")
	intTotalReserva = rs("totalReserva")
	vagas_disponivel_EI = rs("vagas_disponivel_EI")
	vagas_disponivel_EF = rs("vagas_disponivel_EF")
	%>
      	<table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr >
              <td width="80%" height="40" class="celula12"><strong>Total Geral de Inscri&ccedil;&otilde;es</strong></td>
              <td height="40" align="center" class="celula12"><strong><%=intTotalInscricoes%></strong></td>
      		</tr>
        </table>    
<br>
		<table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr>
                <td height="46" colspan="2" class="celula12"><strong>Total de Inscrições de Ed. Infantil</strong></td>
                <td width="20%" height="46" align="center" class="celula12"><strong><%=intTotalEI%></strong></td>
            </tr>
            <tr>
              <td width="43%" height="20" class="celula12"><strong>Ed. Infantil (Integral/CMEIS)</strong></td>
              <td width="37%" align="center" class="celula12"><strong><%=intTotalEICMEI%></strong></td>
              <td rowspan="4" align="right" class="celula12">&nbsp;</td>
            </tr>
            <!--tr>
              <td height="20" class="celula12"><strong>&nbsp;Com bolsa fam&iacute;lia</strong></td>
              <td height="20" align="right" class="celula12"><%'=intTotalEIComBolsa%>&nbsp;</td>
            </tr>
            <tr>
              <td height="20" class="celula12"><strong>&nbsp;Sem bolsa fam&iacute;lia</strong></td>
              <td height="20" align="right" class="celula12"><%'=intTotalEISemBolsa%>&nbsp;</td>
            </tr-->
            <tr>
              <td height="20" class="celula12"><strong>Ed. Infantil (Parcial)</strong></td>
              <td height="20" align="center" class="celula12"><strong><%=intTotalEIParcial%></strong></td>
            </tr>
         </table>    
<br>
      	<table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr>
              <td width="80%" height="40" class="celula12"><strong>Disponibilidade Ed. Infantil</strong></td>
              <td height="40" align="center" class="celula12"><strong><%=vagas_disponivel_EI%></strong></td>
      		</tr>
        </table>    
<br>
      	<table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr>
              <td width="80%" height="40" class="celula12"><strong>Total de Inscrições de Ensino Fundamental</strong></td>
              <td height="40" align="center" class="celula12"><strong><%=intTotalEF%></strong></td>
      		</tr>
        </table>    
<br>
      	<table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr>
              <td width="80%" height="40" class="celula12"><strong>Disponibilidade Ensino Fundamental</strong></td>
              <td height="40" align="center" class="celula12"><strong><%=vagas_disponivel_EF%></strong></td>
      		</tr>
        </table>    
<br>
      	<table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr>
              <td width="80%" height="40" class="celula12"><strong>Total de Inscrições de Cadastro de Reserva</strong></td>
              <td height="40" align="center" class="celula12"><strong><%=intTotalReserva%></strong></td>
      		</tr>
        </table>    
<%
end if
rs.close
%>