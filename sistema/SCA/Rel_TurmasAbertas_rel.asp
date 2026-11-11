<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/05/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de Turmas Abertas
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
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
	
	strAnoCab 				= "2011"
	strTituloRelatorio  	= "Turmas Abertas "
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="9%" align="center" class="celula"><strong>Cod.Empresa</strong></td>
		<td width="64%" class="celula"><strong>Nome</strong></td>
		<td width="27%" class="celula"><strong>Turma</strong>		  <div align="center"></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = " Select"
	sql = sql & " distinct e.COD_GRUPO, e.RAZAOSOCIAL, t.NomeTurma "
	sql = sql & " from SCA_ALUNO_DISCIPLINA ad "
	sql = sql & " inner join SCA_TURMA t on t.Cod_Turma=ad.COD_TURMA_REMANEJAMENTO "
	sql = sql & " and t.AnoLetivo = 2011"
	sql = sql & " inner join SEG_EMPRESA e on e.CODIGO =  t.Cod_Empresa"
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><%=rs("COD_GRUPO")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("RAZAOSOCIAL")%>&nbsp;</td>
				<td class="celula"><%=rs("NomeTurma")%>&nbsp;</td>
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
			<td colspan="3" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="3" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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