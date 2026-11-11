<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 03/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: feriados
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<br>
<%
	dim intPagina
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	strTituloRelatorio  	= "FERIÁDOS"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table align="center" width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="37%" class="celula"><div align="center"><strong>Data do Feriado</strong> </div></td>
		<td width="63%" class="celula"><div align="center"><strong>Descrição do Feriado </strong> </div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	intQtdeRegistroPorPagina = 0
	
	sql = "select *"
	sql = sql & " from SCA_FERIADO"
	sql = sql & " where cod_empresa = " &  session("CodEmpresa")
	sql = sql & " and 	Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	Semestre = " & intSemestre
	sql = sql & " order by "
	sql = sql & " 	data"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			<tr> 
			  <td class="celula" align="left">&nbsp;<%=FORMATADATAAP(rs("DATA"))%>&nbsp;(<%=PegaDiaSemana(rs("DATA"))%>)</td>
			  <td class="celula" align="left">&nbsp;<%=rs("DESCRICAO")%>&nbsp;</td>
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
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
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
</body>
</html>
