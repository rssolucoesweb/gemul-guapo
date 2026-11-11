<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../../../estiloMenu/superfish.css" media="screen">
</head>
<body>
<script type="text/javascript" src="../../../jsMenu/jquery-1.2.6.min.js"></script>
<script type="text/javascript" src="../../../jsMenu/hoverIntent.js"></script>
<script type="text/javascript" src="../../../jsMenu/superfish.js"></script>
<script type="text/javascript">

// initialise plugins
jQuery(function(){
	jQuery('ul.sf-menu').superfish();
});

</script>
<%
'calocar a valida pagina
%>
<table  width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <th height="90" scope="col">
    
    <table width="900" align="center" border="0" cellpadding="0" cellspacing="0">

      <tr valign="top">
        <td width="698" bgcolor="#003366">
        <div id="smoothmenu1" class="menu" onMouseOver="escondeCombo('hidden')" onMouseOut="escondeCombo('visible')">
		<%if strMostraMenuPortal = "" then%>
		<%=Session("strMontraMenuPortal")%>
        <%end if%>
        </div>
		</td>
        <td width="202" bgcolor="#003366" class="tituloPagina" valign="middle" align="right"><%=strNomeDaPaginaPortal%>&nbsp;&nbsp;&nbsp;</td>
      </tr>
    </table></th>
  </tr>
</table>