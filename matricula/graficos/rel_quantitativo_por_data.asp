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

    tr.dif td {
	    background: #eee; /* Linhas com fundo cinza */
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
                <input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" >
				<input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" >
    <br /><br />
    
    </div>

<div style="background: #fff; padding: 25px; border: #000 0px solid; width: 700px; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src="img/logo.png" alt="Prefeitura de Aparecida de Goiânia" /></td>
      </tr>
  </table>
<br>
<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
    	Matr&iacute;cula Informatizada - <%=strAnoLetivo%><br />
        Quantitativo por Data<br />
    </div>
<%
cont =0
intTotal = 0
SQL = "execute SP_SolicitacaoPorData"
rs.open sql, cnn
if rs.eof = false then
	%>
	<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	  <tr bgcolor="#E5E5E5">
		<td width="20%" height="19" ><strong>Tipo</strong></td>
        <td width="38%" height="19" ><strong>Data</strong></td>
		<td width="37%" align="center" ><strong>Origem</strong></td>
		<td width="25%" align="center" ><strong>Quantitativo</strong></td>
	  </tr>
	  <%
	while not rs.eof
			%>
		  <tr>
	          <td height="20" align="center" class="celula"><strong><%=rs("tipo")%></strong>&nbsp;</td>
			<td height="20" class="celula"><strong><%=formatadataAP(rs("data"))%></strong></td>
			<td align="center" class="celula"><strong><%=rs("usuario")%></strong></td>
			<td height="20" align="center" class="celula"><%=rs("qtde")%>&nbsp;</td>
		  </tr>
		  <%		
		intTotal = intTotal + rs("qtde")
		rs.movenext
	wend
	%>
    <tr bgcolor="#CCCCCC" >
        <td height="20" colspan="3" class="celula"><strong>Total Geral</strong></td>
        <td height="20" align="center" class="celula"><%=intTotal%></td>
    </tr>
</table>
<%
end if
rs.close
%>