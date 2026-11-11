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
<title><%=session("Titulo")%> - DEMONSTRATIVO DE SITUAÇÕES ACADÊMICAS</title>
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
dim strInfoTurma

intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
if intCodSemestre = "" then intCodSemestre = "0"

strTituloRelatorio  	= "DEMONSTRATIVO DE SITUAÇÕES ACADÊMICAS - " & intAnoLetivoAtual & "/" & intSemestreAtual

sub mostraCabecalho()
	%>
   	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
   	<br>
   	<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
   	<tr bgcolor="#CCCCCC">
  	<td width="25%" class="celula"><div align="center"><strong>Turma</strong></div></td>
	<td width="28%" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o Acad&ecirc;mica </strong></div></td>
 	<td width="27%" class="celula"><div align="center"><strong> Total de Situa&ccedil;&otilde;es </strong></div></td>
 	<td width="20%" class="celula"><div align="center"><strong>Percentual</strong></div></td>
   	</tr>
	<%
end Sub
	
sub fimTabela()
	response.Write("</table>")
end Sub

intPagina = 1
mostraCabecalho
cont = 0

sql = "SET NOCOUNT ON "
sql = sql & " SELECT TUR.NOMETURMA, COUNT(SAA.COD_SITUACAOALUNO) AS TOTAL_TURMA "
sql = sql & " INTO #TEMP "
sql = sql & " FROM SCA_SITUACAO_ACADEMICA_ALUNO SAA "
sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = SAA.COD_TURMA AND TUR.COD_EMPRESA = SAA.COD_EMPRESA "
sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = SAA.COD_SITUACAOALUNO AND SA.COD_EMPRESA = SAA.COD_EMPRESA "
sql = sql & " WHERE SAA.COD_EMPRESA = " & session("CodEmpresa")
sql = sql & " AND SAA.ANO_LETIVO = " & intAnoLetivoAtual
sql = sql & " AND SAA.SEMESTRE= " & intSemestreAtual
sql = sql & " GROUP BY TUR.NOMETURMA "
sql = sql & " SELECT " 
sql = sql & " TUR.NOMETURMA, "
sql = sql & " SA.DESC_SITUACAOALUNO, " 
sql = sql & " COUNT(SAA.COD_SITUACAOALUNO)AS TOTAL_SITUACAO, "
sql = sql & " TMP.TOTAL_TURMA, "
sql = sql & " Isnull(COUNT(SAA.COD_SITUACAOALUNO),'0')*100/TMP.TOTAL_TURMA as PERCENTUAL "
sql = sql & " FROM SCA_SITUACAO_ACADEMICA_ALUNO SAA "
sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = SAA.COD_TURMA AND TUR.COD_EMPRESA = SAA.COD_EMPRESA " 
sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = SAA.COD_SITUACAOALUNO AND SA.COD_EMPRESA = SAA.COD_EMPRESA "
sql = sql & " INNER JOIN #TEMP TMP ON TMP.NOMETURMA = TUR.NOMETURMA "
sql = sql & " WHERE SAA.COD_EMPRESA = " & session("CodEmpresa") 
sql = sql & " AND SAA.ANO_LETIVO = " & intAnoLetivoAtual
sql = sql & " AND SAA.SEMESTRE= " & intSemestreAtual
sql = sql & " GROUP BY TUR.NOMETURMA, SA.DESC_SITUACAOALUNO,  TMP.TOTAL_TURMA "
sql = sql & " ORDER BY TUR.NOMETURMA "
rs.open sql, cnn
if not rs.eof then 
	While not rs.eof
		%>
		<tr>
		<td align="left" class="celula"><div align="center"><%=rs("NOMETURMA")%>&nbsp;</div></td>
		<td align="left" class="celula"><div align="center"><%=rs("DESC_SITUACAOALUNO")%>&nbsp;</div></td>
		<td align="left" class="celula"><div align="center"><%=rs("TOTAL_SITUACAO")%>&nbsp;</div></td>
		<td align="left" class="celula"><div align="center"><%=rs("PERCENTUAL")%>%&nbsp;</div></td>
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
		strNomeTurma = rs("NOMETURMA") 
		intTotalTurma = rs("TOTAL_TURMA") 
		rs.movenext
		if not rs.eof then
		    if  strNomeTurma <> rs("NOMETURMA") then
		       	%>
			   	<tr>
	          	<td colspan="2" class="celula">&nbsp;</td>
              	<td class="celula" bgcolor="#CCCCCC"><div align="right"><strong>Total da Turma <%=strNomeTurma%> </strong></div></td>
              	<td class="celula" bgcolor="#CCCCCC"><div align="center"><%=intTotalTurma%>&nbsp;</div></td>
      			</tr>
				<%
			end if
		else
			%>
			<tr>
			<td colspan="2" class="celula">&nbsp;</td>
			<td class="celula" bgcolor="#CCCCCC"><div align="right"><strong>Total da Turma <%=strNomeTurma%> </strong></div></td>
			<td class="celula" bgcolor="#CCCCCC"><div align="center"><%=intTotalTurma%></div></td>
			</tr>
			<%
		end if		
	wend
else
	%>
	  <tr>
		<td height="38" colspan="4" align="center" class="celula"><p><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p>	    </td>
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
