<style type="text/css">

<!--
.style2 {color: #FFFFFF}
.tituloTopo
{
    FONT-WEIGHT: bolder;
    FONT-SIZE: 14pt;
    COLOR: #000000;
    FONT-FAMILY: Tahoma;
    TEXT-DECORATION: none
}
.SubtituloTopo{
    FONT-SIZE: 9pt;
    COLOR:#666666;
    font-family: Tahoma;
    TEXT-DECORATION: none
}
.SubtituloGestores{
    FONT-SIZE: 7pt;
    COLOR:#666666;
    font-family: Tahoma;
    TEXT-DECORATION: none
}

-->
</style>
<script type="text/javascript" src="../../js/menu.js"></script>
<script type="text/javascript" src="../../js/anylinkvertical.js"></script>
<style type="text/css">
	@import "../../js/css.css";
</style>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-70820196-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-70820196-1');
</script>

</head>
<body>
<!--#include file="../../includes/inc_PersonalizarSistema.asp"-->
<%
	if trim(request.ServerVariables("SERVER_NAME")) = "desenv.gemul.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "localhost" then
		RESPONSE.WRITE "<div align='center'><font size='+1' color='#FF0000' face='Tahoma, Geneva, sans-serif'>********************* ACESSANDO O SERVIDOR DE DESENVIMENTO **************************</font></div>"
	end if	
%>

<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">

  <% if strPersonalizarSistema = "S" then %>
       <tr>
        <td height="8" bgcolor="#FFFFFF"><!--#include file="../../includes/inc_TopoSistema.asp"--></td>
      </tr>
  <% else%>
      <tr>
        <td height="8" bgcolor="#000000"><img src="../../images/Topo.jpg" width="766" height="102"></td>
      </tr>
  <% end if %>  
  
  </tr>
  <tr>
    <td height="10" class="FundoTopo"><!--#include file="../menuSistema.asp"--></td>
  </tr>
</table>
</body>
</html>