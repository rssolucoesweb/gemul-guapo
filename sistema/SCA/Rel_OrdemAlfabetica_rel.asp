<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Ordem Alfabtica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	intCodCurso	 			= Trim(Request.QueryString("cmbCurso"))
	intCodPeriodo 			= Trim(Request.QueryString("cmbPeriodo"))
	intSemestre 			= Trim(Request.QueryString("cmbSemestre"))
	intCodTurno		 		= Trim(Request.QueryString("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	if intCodComp 		= "" then intCodComp = "0"
	if intCodSerie 		= "" then intCodSerie = "0"
	if intCodTurno 		= "" then intCodTurno = "0"
	if intCodSemestre 	= "" then intCodSemestre = "0"

	strTituloRelatorio  	= "Relatório de Alunos por Ordem Alfabética<br>"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="13%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="36%" class="celula"><div align="center"><strong>Nome do Aluno </strong></div></td>
		<td width="17%" class="celula"><div align="center"><strong>Data de Nascimento </strong></div></td>
		<td width="34%" class="celula"><div align="center"><strong>Nome da M&atilde;e </strong></div></td>
	  </tr>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho
	cont = 0
	sql = "SELECT MATRICULA, NOMEALUNO, DATANASCIMENTO, MAE "
	sql = sql & " FROM SCA_ALUNO"
	sql = sql & " where cod_empresa = " & session("CodEmpresa")
	sql = sql & " ORDER BY NOMEALUNO"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="celula" align="center"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("MAE")%>&nbsp;</td>
			  </tr>
			<%
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
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
