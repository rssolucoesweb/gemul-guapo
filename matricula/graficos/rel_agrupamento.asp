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
<!--#include file="../includes/inc_cnn.asp"-->

<%
cont =0
intTotal = 0
SQL = "exec [s_MAt_Resumo_Matricula] 'Reserva por Agrupamento'"
rs.open sql, cnn
if rs.eof = false then
	while not rs.eof
		if rs("curso")="Agrupamento I" then 
			strRA2013_I = rs("2013")
			strRA2014_I = rs("2014")
			strRA2015_I = rs("2015")
			strRA2016_I = rs("2016")
			strRA2017_I = rs("2017")
			strRA2018_I = rs("2018")
			strRA2019_I = rs("2019")
			strRA2020_I = rs("2020")
		elseif rs("curso")="Agrupamento II" then 	
			strRA2013_II = rs("2013")
			strRA2014_II = rs("2014")
			strRA2015_II = rs("2015")
			strRA2016_II = rs("2016")
			strRA2017_II = rs("2017")
			strRA2018_II = rs("2018")
			strRA2019_II = rs("2019")
			strRA2020_II = rs("2020")
		elseif rs("curso")="Agrupamento III" then 	
			strRA2013_III = rs("2013")
			strRA2014_III = rs("2014")
			strRA2015_III = rs("2015")
			strRA2016_III = rs("2016")
			strRA2017_III = rs("2017")
			strRA2018_III = rs("2018")
			strRA2019_III = rs("2019")
			strRA2020_III = rs("2020")
		elseif rs("curso")="Agrupamento IV" then 	
			strRA2013_IV = rs("2013")
			strRA2014_IV = rs("2014")
			strRA2015_IV = rs("2015")
			strRA2016_IV = rs("2016")
			strRA2017_IV = rs("2017")
			strRA2018_IV = rs("2018")
			strRA2019_IV = rs("2019")
			strRA2020_IV = rs("2020")
		elseif rs("curso")="Agrupamento V" then 	  
			strRA2013_V = rs("2013")
			strRA2014_V = rs("2014")
			strRA2015_V = rs("2015")
			strRA2016_V = rs("2016")
			strRA2017_V = rs("2017")
			strRA2018_V = rs("2018")
			strRA2019_V = rs("2019")
			strRA2020_V = rs("2020")
		end if
		if rs("curso")<>"Total" then 
			if intTotal < rs("2013") then intTotal = rs("2013")
			if intTotal < rs("2014") then intTotal = rs("2014")
			if intTotal < rs("2015") then intTotal = rs("2015")
			if intTotal < rs("2016") then intTotal = rs("2016")
			if intTotal < rs("2017") then intTotal = rs("2017")
			if intTotal < rs("2018") then intTotal = rs("2018")
			if intTotal < rs("2019") then intTotal = rs("2019")
			if intTotal < rs("2020") then intTotal = rs("2020")
		end if
		rs.movenext
	wend
end if

strRAMaiorValor = intTotal
%>
<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" >
				<input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" >
    <br /><br />
    
    </div>

<div style="background: #fff; padding: 25px; border: #000 0px solid; width: 875px; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src="img/logo.png" alt="Prefeitura de Aparecida de Goiânia" /></td>
      </tr>
  </table>
<br>
<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
    	Matr&iacute;cula Informatizada - <%=strAnoLetivo%><br />
        Cadastro de Reservas por Agrupamento<br />
    </div>
    
<br>
<DIV align="center">
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:


<%=strRA2015_I%>,<%=strRA2015_II%>,<%=strRA2015_III%>,<%=strRA2015_IV%>,<%=strRA2015_V%>|
<%=strRA2016_I%>,<%=strRA2016_II%>,<%=strRA2016_III%>,<%=strRA2016_IV%>,<%=strRA2016_V%>|
<%=strRA2017_I%>,<%=strRA2017_II%>,<%=strRA2017_III%>,<%=strRA2017_IV%>,<%=strRA2017_V%>|
<%=strRA2018_I%>,<%=strRA2018_II%>,<%=strRA2018_III%>,<%=strRA2018_IV%>,<%=strRA2018_V%>|
<%=strRA2019_I%>,<%=strRA2019_II%>,<%=strRA2019_III%>,<%=strRA2019_IV%>,<%=strRA2019_V%>|
<%=strRA2020_I%>,<%=strRA2020_II%>,<%=strRA2020_III%>,<%=strRA2020_IV%>,<%=strRA2020_V%>
&chco=fa432a,76A4FB,359B62,8A2BE2,0561b1,faae2a,FF8000&chs=1000x250&chxl=0:|Agrupamento I|Agrupamento II|Agrupamento III|Agrupamento IV|Agrupamento V&chxr=1,10,<%=strRAMaiorValor%>&chds=0,<%=strRAMaiorValor%>&chg=20,10&chdl=2015|2016|2017|2018|2019|2020&chbh=15,10,25" />
<br>
<br>

<%
rs.movefirst
if rs.eof = false then
	%>
	<table width = "120%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	  <tr bgcolor="#E5E5E5">
		<td width="20%" height="19" ><strong>Agrupamento</strong></td>
		<td width="10%" align="center" ><strong>2015</strong></td>
		<td width="10%" align="center" ><strong>2016</strong></td>
		<td width="10%" align="center" ><strong>2017</strong></td>
		<td width="10%" align="center" ><strong>2018</strong></td>
        <td width="10%" align="center" ><strong>2019</strong></td>
		<td width="10%" align="center" ><strong>2020</strong></td>
	  </tr>
	  <%
	while not rs.eof
		
		if rs("curso")<>"Total" then
			%>
        <tr <%=linha%> >
            <td height="20" class="celula"><%=rs("curso")%></td>
            <td align="center" class="celula"><%=rs("2015")%></td>
            <td align="center" class="celula"><%=rs("2016")%></td>
            <td align="center" class="celula"><%=rs("2017")%></td>
            <td align="center" class="celula"><%=rs("2018")%></td>
            <td align="center" class="celula"><%=rs("2019")%></td>
			<td align="center" class="celula"><%=rs("2020")%></td>
        </tr>
		  <%	
		end if
		rs.movenext
	wend
	%>
</table>
<%
end if
rs.close%>
</DIV>
