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
    <td height="10" class="FundoTopo"></td>
  </tr>
</table>
</body>
</html>