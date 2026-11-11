<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 16/01/2017
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Mapa Geral de Vagas - Matricula 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCodGrupo 			= Session("CodGrupo")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	percentual	 			= Trim(Request.Form("percentual"))
	strTituloRelatorio 	= "Relatório de Quantitativo e Percentual - Educação Infantil"

	sub mostraCabecalho
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
      <tr bgcolor="#CCCCCC">
        <td width="27%" rowspan="3" class="celula"><strong>Escola</strong></td>
        <td height="16" colspan="2" align="center" class="celula"><strong>Inscri&ccedil;&otilde;es</strong></td>
        <td colspan="2" align="center" class="celula"><strong>Efetivados</strong></td>
      </tr>
      <tr bgcolor="#CCCCCC">
        <td height="16" align="center" class="celula"><strong>Com Bolsa</strong></td>
        <td align="center" class="celula"><strong>Sem Bolsa</strong></td>
        <td align="center" class="celula"><strong>Com Bolsa</strong></td>
        <td align="center" class="celula"><strong>Sem Bolsa</strong></td>
      </tr>
      <tr bgcolor="#CCCCCC">
        <td width="4%" height="16" align="center" class="celula"><strong>Qtde</strong></td>
        <td width="4%" align="center" class="celula"><strong>Qtde</strong></td>
        <td width="4%" align="center" class="celula"><strong>Qtde</strong></td>
        <td width="4%" align="center" class="celula"><strong>Qtde</strong></td>
      </tr>
      <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	intQtdeRegistroPorPagina = 1
	
	cont = 0
	
	mostraCabecalho 
	
	SQL = "execute [s_MAt_Resumo_percentual_ei] " & strAnoLetivo & "," & strCodGrupo
	vetMapa = null
	rs.open sql, cnn
	if not rs.eof then
		vetMapa = rs.getRows
	end if
	rs.close
	cont = 0
	if isArray(vetMapa) then
		cor = ""
		for i=0 to ubound(vetMapa,2)
			cont = cont + 1
			if cor = "" then cor = "bgcolor='#E1E1E1'" else cor = ""
			
			perc_insc_com = formatNumber(vetMapa(8,i),0)
			if vetMapa(8,i) = "0" then perc_insc_com = ""
			
			perc_insc_sem = formatNumber(vetMapa(9,i),0)
			if vetMapa(9,i) = "0" then perc_insc_sem = ""
			
			perc_efet_com = formatNumber(vetMapa(10,i),0)
			if vetMapa(10,i) = "0" then perc_efet_com = ""
			
			perc_efet_sem = formatNumber(vetMapa(11,i),0)
			if vetMapa(11,i) = "0" then perc_efet_sem = ""
			%>
				<tr <%=cor%>>
					<td class="celula" align="left"><%=vetMapa(1,i) %></td>
					<td align="center" class="celula"><%=vetMapa(4,i) %></td>
					<td align="center" class="celula"><%=vetMapa(5,i) %></td>
					<td align="center" class="celula"><%=vetMapa(6,i) %></td>
					<td align="center" class="celula"><%=vetMapa(7,i) %></td>
				</tr>
			<%	
			inscricoesComBolsa = inscricoesComBolsa + vetMapa(4,i)
			inscricoesSemBolsa = inscricoesSemBolsa + vetMapa(5,i)
			efetivacaoComBolsa = efetivacaoComBolsa + vetMapa(6,i)
			efetivacaoSemBolsa = efetivacaoSemBolsa + vetMapa(7,i)
		next
		%>
<tr  bgcolor="#CCCCCC">
  <td class="celula" align="right"><strong>Total&nbsp;</strong></td>
  <td align="center" class="celula"><%=inscricoesComBolsa%>&nbsp;</td>
  <td align="center" class="celula"><%=inscricoesSemBolsa%>&nbsp;</td>
  <td align="center" class="celula"><%=efetivacaoComBolsa%>&nbsp;</td>
  <td align="center" class="celula"><%=efetivacaoSemBolsa%>&nbsp;</td>
 </tr>

		<%
	end if
	%>
    </table>
<%response.write " -> " & cont & " Unidades"%>
    <br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
