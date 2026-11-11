<html>
<head>
    <title>Matrícula</title>
	<link href="https://fonts.googleapis.com/css?family=Anton|Ubuntu+Condensed" rel="stylesheet">

	<style>
		span{
			font-family: 'Ubuntu Condensed', sans-serif;
			font-size: 20px;
		}
		div{
		TEXT-ALIGN: CENTER;
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
<!--
    <img src="http://chart.apis.google.com/chart?chxt=x,y&cht=bvs&chd=t:60,70,85,65,40&chco=76A4FB&chls=2.0&chs=180x150&chxl=0:|Jan|Fev|Mar|Abr|Mai" alt="" />
	<img src="http://chart.apis.google.com/chart?cht=p3&chd=t:45,20,20,15&chs=480x200&chl=45%|20%|20%|15%&chdl=Janeiro|Fevereiro|Março|Abril" alt="" />
<img src="http://chart.apis.google.com/chart?cht=p&chd=t:45,20,20,15,45,55&chs=320x200&chdl=IE6|Firefox|IE7|Chrome|Safari|Opera
&chco=c60000" alt="" />
<img src="http://chart.apis.google.com/chart?cht=p3&chd=t:45,12,20,5,20,15&chs=320x200&chdl=Corel|Adobe|Apple|Microsoft|Sun|Sony
&chco=1da3f8" alt="" />
<img src="http://chart.apis.google.com/chart?cht=p3&chd=t:45,20,20,15&chs=660x300&chl=45%|20%|20%|15%&
chdl=Janeiro|Fevereiro|Mar%C3%A7o|Abril&chco=c60000|1da3f8|58e015|fffc00&chf=bg,s,dddddd&
chma=20,20,00,30|100,20" alt="" />
<br>
-->
<%
'----------------------
'vagas oferecidas
'----------------------
strVO2013_EI = 515
strVO2014_EI = 1187
strVO2015_EI = 1195
strVO2016_EI = 1800
strVO2017_EI = 0

strVO2013_EF = 11215
strVO2014_EF = 11522
strVO2015_EF = 10958
strVO2016_EF = 10060
strVO2017_EF = 0

strVOMaiorValor = 12000

'----------------------
'inscritos por curso
'----------------------
strIC2013_EI = 511
strIC2014_EI = 1187
strIC2015_EI = 1268
strIC2016_EI = 1009
strIC2017_EI = 0

strIC2013_EF = 7148
strIC2014_EF = 8582
strIC2015_EF = 8737
strIC2016_EF = 8245
strIC2017_EF = 0

strICMaiorValor = 10000
'----------------------
'reservas
'----------------------
strR2013_EI = 1621
strR2014_EI = 3945
strR2015_EI = 6253
strR2016_EI = 9634
strR2017_EI = 0

strRMaiorValor = 10000
'----------------------
'reservas por agrupamento
'----------------------
strRA2013_I = 314
strRA2014_I = 587
strRA2015_I = 1138
strRA2016_I = 1690
strRA2017_I = 0

strRA2013_II = 429
strRA2014_II = 775
strRA2015_II = 1366
strRA2016_II = 2076
strRA2017_II = 0

strRA2013_III = 402
strRA2014_III = 908
strRA2015_III = 1336
strRA2016_III = 2020
strRA2017_III = 0

strRA2013_IV = 398
strRA2014_IV = 941
strRA2015_IV = 1394
strRA2016_IV = 1859
strRA2017_IV = 0
           
strRA2013_V = 78
strRA2014_V = 734
strRA2015_V = 1019
strRA2016_V = 1989
strRA2017_V = 0

strRAMaiorValor = 2500


'----------------------
'inscricoes 1 dia
'----------------------
strINSC2013_I = 3232
strINSC2014_I = 5094
strINSC2015_I = 4937
strINSC2016_I = 3412
strINSC2017_I = 0

strINSC2013_C = 540
strINSC2014_C = 788
strINSC2015_C = 869
strINSC2016_C = 342
strINSC2017_C = 0

strINSCMaiorValor = 7000

M=REQUEST("M")
'IF M=1 THEN
%>
<div style="align:center"><span>Vagas Oferecidas</span>
<br>
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:<%=strVO2013_EI%>,<%=strVO2014_EI%>,<%=strVO2015_EI%>,<%=strVO2016_EI%>,<%=strVO2017_EI%>|<%=strVO2013_EF%>,<%=strVO2014_EF%>,<%=strVO2015_EF%>,<%=strVO2016_EF%>,<%=strVO2017_EF%>&chco=fa432a,76A4FB,faae2a&chs=675x250&chxl=0:|2013|2014|2015|2016|2017&chxr=1,10,<%=strVOMaiorValor%>&chds=0,<%=strVOMaiorValor%>&chg=20,10&chdl=Ed.Infantil|Ens.Fundamental&chbh=35,10,25" />
</div>
<div style="align:center"><span>Inscritos por Curso</span>
<br>
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:<%=strIC2013_EI%>,<%=strIC2014_EI%>,<%=strIC2015_EI%>,<%=strIC2016_EI%>,<%=strIC2017_EI%>|<%=strIC2013_EF%>,<%=strIC2014_EF%>,<%=strIC2015_EF%>,<%=strIC2016_EF%>,<%=strIC2017_EF%>&chco=fa432a,76A4FB,faae2a&chs=675x250&chxl=0:|2013|2014|2015|2016|2017&chxr=1,10,<%=strICMaiorValor%>&chds=0,<%=strICMaiorValor%>&chg=20,10&chdl=Ed.Infantil|Ens.Fundamental&chbh=35,10,25" />
</div>
<div style="align:center"><span>Cadastro de Reservas - Educação Infantil</span>
<br>
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:<%=strR2013_EI%>,<%=strR2014_EI%>,<%=strR2015_EI%>,<%=strR2016_EI%>,<%=strR2017_EI%>&chco=76A4FB,faae2a&chs=575x250&chxl=0:|2013|2014|2015|2016|2017&chxr=1,10,<%=strRMaiorValor%>&chds=0,<%=strRMaiorValor%>&chg=20,10&chdl=Reservas&chbh=50,10,25" />
</div>
<%'ELSE%>
<div style="align:center"><span>Reserva por Agrupamento</span>
<br>
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:
<%=strRA2013_I%>,<%=strRA2013_II%>,<%=strRA2013_III%>,<%=strRA2013_IV%>,<%=strRA2013_V%>|
<%=strRA2014_I%>,<%=strRA2014_II%>,<%=strRA2014_III%>,<%=strRA2014_IV%>,<%=strRA2014_V%>|
<%=strRA2015_I%>,<%=strRA2015_II%>,<%=strRA2015_III%>,<%=strRA2015_IV%>,<%=strRA2015_V%>|
<%=strRA2016_I%>,<%=strRA2016_II%>,<%=strRA2016_III%>,<%=strRA2016_IV%>,<%=strRA2016_V%>|
<%=strRA2017_I%>,<%=strRA2017_II%>,<%=strRA2017_III%>,<%=strRA2017_IV%>,<%=strRA2017_V%>
&chco=fa432a,76A4FB,359B62,8A2BE2,faae2a&chs=795x250&chxl=0:|Agrupamento I|Agrupamento II|Agrupamento III|Agrupamento IV|Agrupamento V&chxr=1,10,<%=strRAMaiorValor%>&chds=0,<%=strRAMaiorValor%>&chg=20,10&chdl=2013|2014|2015|2016|2017&chbh=15,10,25" />
</div>
<br>
<div style="align:center"><span>Inscrições no 1º Dia</span>
<br>
<img src="http://chart.apis.google.com/chart?cht=bvg&chxt=x,y&chd=t:
<%=strINSC2013_I%>,<%=strINSC2014_I%>,<%=strINSC2015_I%>,<%=strINSC2016_I%>,<%=strINSC2017_I%>|
<%=strINSC2013_C%>,<%=strINSC2014_C%>,<%=strINSC2015_C%>,<%=strINSC2016_C%>,<%=strINSC2017_C%>
&chco=2E8B57,76A4FB,faae2a&chs=675x250&chxl=0:|2013|2014|2015|2016|2017&chxr=1,10,<%=strINSCMaiorValor%>&chds=0,<%=strINSCMaiorValor%>&chg=20,10&chdl=Internet|Callcenter&chbh=35,10,25" />
</div>

<%'END IF%>
</html>