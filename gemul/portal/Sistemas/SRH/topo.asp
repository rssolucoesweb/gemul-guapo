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
<link href="../../../estilo/menu.css" rel="stylesheet" type="text/css">
<script src="../../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../topoLogado.asp"-->
<table  width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <th height="90" scope="col">
    
    <table width="900" align="center" border="0" cellpadding="0" cellspacing="0">
      <tr valign="top">
        <td colspan="2" background="../../../images/FundoTopoAdm.png">
        
        <table width="94%" align="center" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="21%"><img src="../../../images/Grupo/<%=session("codGrupo")%>/Empresa/<%=session("codEmpresa")%>/<%=session("logomarcaEmpresa")%>" width="180" height="78" /></td>

            <td width="8%" class="tituloPrincipal">&nbsp;</td>
            <td width="41%" class="tituloPrincipal" align="center">Módulo&nbsp;<%=session("NomeModulo")%></td>
            <td width="30%" class="tituloPrincipal" align="right"><img src="../../../images/grupo/topoEmpresa.gif" alt="" height="51" /></td>
          </tr>
        </table>
        
        </td>
      </tr>
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