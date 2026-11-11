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
</head>
<body>
<!--#include file="../../includes/inc_PersonalizarSistema.asp"-->

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
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-70820196-1', 'auto');
  ga('send', 'pageview');

</script>