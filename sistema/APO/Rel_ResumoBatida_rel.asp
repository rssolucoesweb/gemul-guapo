<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
on error resume next  
	 
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
}
.style2 {
	font-size:14px;
}
-->
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--  include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina

	strData 		= Trim(Request.form("txtData"))

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
    <br>
	<table width="60%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="70%" align="center" class="celula"><strong>Unidade</strong></td>
	    <td width="10%" align="center" class="celula"><strong>Funcion&aacute;rios</strong></td>
	    <td width="10%" align="center" class="celula"><strong>Batidas</strong></td>
	    <td align="center" class="celula"><strong>Diferen&ccedil;a</strong></td>
      </tr>
	  <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	strTituloRelatorio  	= "RESUMO DE BATIDAS POR UNIDADE <BR> Data: " & formatadataAP(Trim(strData)) 
	intPagina = 1
	mostraCabecalho

	sql = " execute [dbo].[SP_APO_ResumoBatidas] " & SESSION("CODGRUPO")& ",'" & formatadataBD(strData) & "'"
    rs.open sql, cnn
	if not rs.eof then
		while not rs.eof
			%>
			  <tr >
				<td align="left" class="celula style2">&nbsp;&nbsp;<%=rs("unidade")%> - <%=rs("codigo")%></td>
				<td align="left" class="celula style2">&nbsp;<%=rs("qtde_funcionario")%></td>
				<td align="left" class="celula style2">&nbsp;<%=rs("qtde_batida")%></td>
				<td align="left" class="celula style2">&nbsp;<%=rs("qtde_funcionario")-rs("qtde_batida")%></td>
			  </tr>
			 <%
			 total_qtde_funcionario = total_qtde_funcionario + rs("qtde_funcionario")
			 total_qtde_batida = total_qtde_batida + rs("qtde_batida")
			 
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			rs.movenext	
			
		wend
	end if 
	rs.close
%>
      <tr bgcolor="#CCCCCC" >
        <td align="left" class="celula style2"><strong>&nbsp;&nbsp;Total</strong></td>
        <td align="left" class="celula style2">&nbsp;<%=total_qtde_funcionario%></td>
        <td align="left" class="celula style2">&nbsp;<%=total_qtde_batida%></td>
        <td align="left" class="celula style2">&nbsp;<%=total_qtde_funcionario-total_qtde_batida%></td>
      </tr>
  <tr >
    <td class="celula style2" colspan="4">&nbsp;&nbsp;<strong>Quantidade: &nbsp;<%=cont%></strong></td>
  </tr>
</table>

<script>
	aguarde.style.display="none";
</script>
<!--include file="../../includes/inc_apontamento_remove.asp"-->
</body>
</html>