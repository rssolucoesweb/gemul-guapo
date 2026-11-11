<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 27/10/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Entrada
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

	function resultadoConsulta(intCodigo){
		window.opener.document.getElementById("txtCodigo").value=intCodigo
		window.opener.document.getElementById("frm").submit();
		window.close();
	}
</script>
<%
	strNome = Request.Form("txtNome")
	strAno = Request.Form("txtAno")
	if strAno = "" then strAno = year(date)
%>
<form method="POST" id="frm" name="frm" action="#">
  <div align="center"></div>
  <table width="100%" align="left" bgcolor="#FFFFFF" class="formulario">
    <tr>
      <td width="100%" height="85" align="center">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td  align="center"><span class="tituloPrincipal">Consulta de Entradas </span></td>
          </tr>
        </table>
		<br>
		Ano: <input name="txtAno" type="text" class="text" id="txtAno" size="5" maxlength="4" value="<%=strAno%>" onBlur="submit()">
		<br>
	    <%
		cont =0

		sql = " SELECT E.Codigo, E.CodEmpresa, E.CodFornecedor, E.Numero, E.Data_Entrada, E.Valor_Total, E.excluida, "
		sql = sql & " F.razaosocialNome as NOME_FANTASIA"
		sql = sql & " FROM EST_Entrada E "
		sql = sql & " inner join EST_FORNECEDOR F on F.Codigo = E.CodFornecedor"
		sql = sql & " Where E.CodEmpresa = " & session("codEmpresa")
		sql = sql & " and year(E.DATA_ENTRADA) = " & strAno
		sql = sql & " Order by codigo desc "
		rs.open sql, cnn
						
		if rs.eof = false then
		%>
	    <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td class="celula"><strong>Codigo</strong><strong class="TextoForm"></strong></td>
            <td width="52%" class="celula"><strong>Fornecedor</strong></td>
            <td width="16%" class="celula"><span class="texto1"><strong>N/Nota</strong></span></td>
            <td width="21%" class="celula" align="center"><strong>Data</strong></td>
            <td width="21%" height="21" class="celula"><strong>Valor</strong></td>
          </tr>
		  <%
		 	while not rs.eof
			cont = cont + 1		
			excluida = ""
			if rs("excluida") = "S" then
				excluida = "bgcolor='#FFAEAE'"
				msnExluida = "S"
			end if
			%>
          <tr <%=excluida%> style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"> 
            <td width="11%" class="texto"><%=rs("Codigo")%></td>
            <td class="texto"><%=rs("NOME_FANTASIA")%></td>
            <td class="texto"><%=rs("Numero")%></td>
            <td class="texto"><%=rs("Data_Entrada")%></td>
            <td height="21" class="texto"><%=formatnumber(rs("Valor_Total"),2)%></td>
          </tr>
		  <%				
			rs.movenext
			wend
			%>
         	<tr> 
            	<td height="21" colspan="5" class="texto">Total Registros: <%=cont%></td>
        	</table>
	  	<%
		end if
		rs.close
		if msnExluida <> "" then
		%>
        	<table bgcolor='#FFAEAE' width="50%" border="0" cellspacing="0" cellpadding="0" class="tabela">
              <tr>
                <td height="25" class="texto"><strong>Entrada foi exclu&iacute;da&nbsp;</strong></td>
              </tr>
            </table>
			<br>
        <%
		end if
		%>
        </td> 
    </tr>
  </table>
</form>
</body>
</html>