<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Aluno 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(intCodigo, Nome){
		window.opener.frm.txtInscricao.value = intCodigo;
		window.opener.frm.txtNomealuno.value = Nome;
		window.opener.frm.submit();
		window.close();
	}
</script>
<%
	strAluno			= Trim(Request("txtAluno"))
	strConsultar		= Trim(Request("strConsultar"))
%>
<form method="POST" id="frm" action="#">
<input name="strConsultar" type="hidden" value="S">
  <table width="100%" align="left" class="CorFundo" >
    <tr>
      <td width="486" height="85" align="center">
	  <table width="477" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" class="tituloPrincipal">Consulta Inscri&ccedil;&atilde;o </td>
          </tr>
          <tr>
            <td width="125">&nbsp;</td>
            <td width="352">&nbsp;</td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Nome do Aluno:   </span></td>
            <td><input name="txtAluno" type="text" class="text" id="txtAluno" size="50" maxlength="50" value="<%=strAluno%>" /></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_consulta.asp"--></td>
          </tr>
        </table>
		<br>
		<table width = "484" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		  <tr bgcolor="#E5E5E5">
			<td class="TextoForm"><strong>Insc.</strong></td>
			<td width="57%" bgcolor="#E5E5E5" class="TextoForm"><strong>Nom</strong><strong>e do Aluno </strong></td>
		    <td width="14%" bgcolor="#E5E5E5" class="TextoForm"><strong>Valida&ccedil;&atilde;o</strong></td>
		    <td width="17%" bgcolor="#E5E5E5" class="TextoForm"><strong>Sit. Financ.</strong></td>
		  </tr>
		  <%
			cont =0
			
			if strConsultar <> "" then
				sql = "SELECT CODIGO, NOMEALUNO, ISNULL(ATIVADO,'N') as ATIVADO, Cod_TipoPagamento"
				sql = sql & " FROM SCA_VESTIBULAR_DADOS"
				sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
				if strAluno <> "" then
					sql = sql & " and NOMEALUNO LIKE '" & strAluno & "%'"
				end if
				sql = sql & " order by NOMEALUNO"
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
						cont = cont + 1	
					    strCod_TipoPagamento            = rs("Cod_TipoPagamento")
						if strCod_TipoPagamento <>  1 then
						   strStatusPagamento = "PAGO"
						else 
						   strStatusPagamento = "-----"
						end if

						%>
						  <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("codigo")%>','<%=rs("NOMEALUNO")%>')">
							<td width="12%" height="26" class="Texto">&nbsp;<%=trim(rs("codigo"))%></td>
							<td class="Texto">&nbsp;<%=trim(rs("NOMEALUNO"))%></td>
						    <td class="Texto"><div align="center"><%=trim(rs("ATIVADO"))%>&nbsp;</div></td>
						    <td class="Texto"><div align="center"><%=trim(strStatusPagamento)%>&nbsp;</div></td>
						  </tr>
						<%				
					rs.movenext
					wend
					%>
					<tr> 
					<td height="21" colspan="6" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
					<%
				end if
				rs.close
			end if
			%>
	</table>
	</td> 
    </tr>
  </table>
</form>
</body>
</html>
