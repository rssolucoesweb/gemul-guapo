<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Noticias
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>
	function Consulta(){
		frm.submit();
	}

	function resultadoConsulta(intCodNotica){
		window.opener.frm.txtCodNoticia.value=intCodNotica
		window.opener.frm.submit();
		window.close();
	}
</script>
<%
	strTitulo = Request.Form("txtTitulo")
%>
<form method="POST" id="frm" action="#">
  <div align="center"></div>
  <table width="582" align="left" bgcolor="#FFFFFF" class="formulario">
    <tr>
      <td width="100%" height="85" align="center">
	  <table width="101%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center"><span class="tituloPrincipal">Consulta de Noticias </span></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="123"><span class="TextoForm">Titulo :</span></td>
            <td width="374"><input name="txtTitulo" type="text" class="text" id="txtTitulo" size="40" maxlength="40" value="<%=strTitulo%>"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../../includes/inc_botoes_consulta.asp"--></td>
          </tr>
        </table>
		<br>
	    <%
		cont =0
		
		sql = "SELECT SIT_Noticias.Codigo, SIT_Noticias.Titulo, SIT_Noticias.Data, "
		sql = sql & " SIT_TipoNoticia.Descricao" 
		sql = sql & " FROM SIT_Noticias INNER JOIN SIT_TipoNoticia "
		sql = sql & " ON SIT_Noticias.CodTipoNoticia = SIT_TipoNoticia.Codigo "
		sql = sql & " Where SIT_Noticias.CodEmpresa = " & session("codEmpresa")

		if strTitulo <> "" then
			sql = sql & " And Titulo LIKE '%" & strTitulo & "%'"
		end if
		
		sql = sql & " Order by Data desc"

		rs.open sql, cnn
						
		if rs.eof = false then
		%>
	    <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td class="celula"><strong>Data</strong><strong class="TextoForm">&nbsp;</strong></td>
            <td class="celula"><strong>Tit&uacute;lo</strong></td>
            <td height="21" class="celula"><strong>Categoria</strong></td>
          </tr>
		  <%
		 	while not rs.eof
			cont = cont + 1		
			%>
          <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"> 
            <td width="12%" class="texto"><%=formataDataAP(rs("Data"))%></td>
            <td width="65%" class="texto"><%=rs("Titulo")%></td>
            <td width="23%" height="21" class="texto"><%=rs("descricao")%></td>
          </tr>
		  <%				
			rs.movenext
			wend
		%>
         <tr> 
            <td height="21" colspan="3" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
        </table>
	  <%
		end if
		rs.close
		%></td> 
    </tr>
  </table>
</form>
</body>
</html>