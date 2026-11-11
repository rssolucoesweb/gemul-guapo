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

</head>
<body>
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_cnn.asp"-->
<%

cont =0
intTotal = 0
SQL = "exec [s_MAt_Resumo_Matricula] 'Inscrições 1º dia'"
rs.open sql, cnn
if rs.eof = false then
	while not rs.eof
		if rs("curso")="INTERNET" then 
			strINSC2013_I = rs("2013")
			strINSC2014_I = rs("2014")
			strINSC2015_I = rs("2015")
			strINSC2016_I = rs("2016")
			strINSC2017_I = rs("2017")
			strINSC2018_I = rs("2018")
			strINSC2019_I = rs("2019")
			strINSC2020_I = rs("2020")
		end if
		if rs("curso")="CALLCENTER" then 
			strINSC2013_C = rs("2013")
			strINSC2014_C = rs("2014")
			strINSC2015_C = rs("2015")
			strINSC2016_C = rs("2016")
			strINSC2017_C = rs("2017")
			strINSC2018_C = rs("2018")
			strINSC2019_C = rs("2019")
			strINSC2020_C = rs("2020")
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
strINSCMaiorValor = intTotal
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
        Inscrições no 1º dia<br />
    </div>
    
<br>
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:
<%=strINSC2013_I%>,<%=strINSC2014_I%>,<%=strINSC2015_I%>,<%=strINSC2016_I%>,<%=strINSC2017_I%>,<%=strINSC2018_I%>,<%=strINSC2019_I%>,<%=strINSC2020_I%>|
<%=strINSC2013_C%>,<%=strINSC2014_C%>,<%=strINSC2015_C%>,<%=strINSC2016_C%>,<%=strINSC2017_C%>,<%=strINSC2018_C%>,<%=strINSC2019_C%>,<%=strINSC2020_C%>
&chco=2E8B57,76A4FB,faae2a&chs=875x250&chxl=0:|2013|2014|2015|2016|2017|2018|2019|2020&chxr=1,10,<%=strINSCMaiorValor%>&chds=0,<%=strINSCMaiorValor%>&chg=20,10&chdl=Internet|Callcenter&chbh=35,10,25" />
<br>
<br>
<%
rs.movefirst
if rs.eof = false then
	%>
	<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	  <tr bgcolor="#E5E5E5">
		<td width="20%" height="19" ><strong>Inscrição</strong></td>
		<td width="10%" align="center" ><strong>2013</strong></td>
		<td width="10%" align="center" ><strong>2014</strong></td>
		<td width="10%" align="center" ><strong>2015</strong></td>
		<td width="10%" align="center" ><strong>2016</strong></td>
		<td width="10%" align="center" ><strong>2017</strong></td>
		<td width="10%" align="center" ><strong>2018</strong></td>
        <td width="10%" align="center" ><strong>2019</strong></td>
		<td width="10%" align="center" ><strong>2020</strong></td>
	  </tr>
	  <%
	while not rs.eof
		if rs("curso")="Total" then linha = " bgcolor='#CCCCCC' "
		if rs("curso")="INTERNET" then linha = " bgcolor='#89b89e' "
		if rs("curso")="CALLCENTER" then linha = " bgcolor='#9ec0ff' "
			%>
        <tr <%=linha%> >
            <td height="20" class="celula"><%=rs("curso")%></td>
            <td align="center" class="celula"><%=rs("2013")%></td>
            <td align="center" class="celula"><%=rs("2014")%></td>
            <td align="center" class="celula"><%=rs("2015")%></td>
            <td align="center" class="celula"><%=rs("2016")%></td>
            <td align="center" class="celula"><%=rs("2017")%></td>
            <td align="center" class="celula"><%=rs("2018")%></td>
            <td align="center" class="celula"><%=rs("2019")%></td>
			<td align="center" class="celula"><%=rs("2020")%></td>
        </tr>
		  <%		
		rs.movenext
	wend
	%>
</table>
<%
end if
rs.close%>