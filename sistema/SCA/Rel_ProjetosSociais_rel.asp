<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script><style type="text/css">
<!--
-->
</style></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
		
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodProjetoSociais 	= Trim(Request.Form("cmbProjetoSociais"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strMesInicial			= Trim(Request.Form("txtMesInicial"))
	strMesFinal				= Trim(Request.Form("txtMesFinal"))
	if strMesInicial = "" then strMesInicial = "0"
	if strMesFinal = "" then strMesFinal = "0"
 
    intNumeroMeses  = (ccur(strMesFinal) - ccur(strMesInicial)) + 1
	if intNumeroMeses <= 0 then
	   intNumeroMeses = 1
	end if	
    
	if strMesInicial = "1" then strDescricaoMesInicial = " Janeiro "
	if strMesInicial = "2" then strDescricaoMesInicial = " Fevereiro "
	if strMesInicial = "3" then strDescricaoMesInicial = " Março "
	if strMesInicial = "4" then strDescricaoMesInicial = " Abril "
	if strMesInicial = "5" then strDescricaoMesInicial = " Maio "
	if strMesInicial = "6" then strDescricaoMesInicial = " Junho "
	if strMesInicial = "7" then strDescricaoMesInicial = " Julho "
	if strMesInicial = "8" then strDescricaoMesInicial = " Agosto "
	if strMesInicial = "9" then strDescricaoMesInicial = " Setembro "
	if strMesInicial = "10" then strDescricaoMesInicial = " Outubro "
	if strMesInicial = "11" then strDescricaoMesInicial = " Novembro "
	if strMesInicial = "12" then strDescricaoMesInicial = " Dezembro "

	if strMesFinal = "1" then strDescricaoMesFinal = " Janeiro "
	if strMesFinal = "2" then strDescricaoMesFinal = " Fevereiro "
	if strMesFinal = "3" then strDescricaoMesFinal = " Março "
	if strMesFinal = "4" then strDescricaoMesFinal = " Abril "
	if strMesFinal = "5" then strDescricaoMesFinal = " Maio "
	if strMesFinal = "6" then strDescricaoMesFinal = " Junho "
	if strMesFinal = "7" then strDescricaoMesFinal = " Julho "
	if strMesFinal = "8" then strDescricaoMesFinal = " Agosto "
	if strMesFinal = "9" then strDescricaoMesFinal = " Setembro "
	if strMesFinal = "10" then strDescricaoMesFinal = " Outubro "
	if strMesFinal = "11" then strDescricaoMesFinal = " Novembro "
	if strMesFinal = "12" then strDescricaoMesFinal = " Dezembro "

	
	if intCodProjetoSociais <> "" then
	
		sql = "SELECT COD_PROJETOSOCIAIS, DESC_PROJETOSOCIAIS"
		sql = sql & " FROM SCA_PROJETOSOCIAIS"
					
		sql = sql & " where COD_EMPRESA = " & Session("CodEmpresa")	
		sql = sql & " and COD_PROJETOSOCIAIS = " & intCodProjetoSociais	
		sql = sql & " Order by DESC_PROJETOSOCIAIS"
		rs.open sql, cnn
		if rs.eof = false then
			strDescricao     = rs("DESC_PROJETOSOCIAIS")
		end if
		rs.close
	
	end if 
	
	if intSemestre = "3" then
	   msgReferencia = " - Referência: " & strAnoLetivo 
	else
	   msgReferencia = " - Referência: " & strAnoLetivo & "/" & intSemestre
	end if
	
	strTituloRelatorio  	= strDescricao & msgReferencia & "<BR> Frequência:" & strDescricaoMesInicial & " a " & strDescricaoMesFinal

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		  <tr bgcolor="#CCCCCC">
			<td width="9%" align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
			<td width="35%" class="celula"><strong>Nome do Aluno</strong></td>
			<td width="26%" class="celula"><strong>Nome da M&atilde;e </strong></td>
			<td width="11%" class="celula"><strong>Data Nascimento </strong>
			<div align="center"></div></td>
			<td width="10%" align="center" class="celula"><strong>Telefone</strong></td>
			<td width="9%" align="center" class="celula"><strong>Turma</strong></td>
			<td width="9%" align="center" class="celula style1"><strong>N. Benef&iacute;cio</strong></td>
			<td width="9%" align="center" class="celula"><strong>Frequ&ecirc;ncia</strong></td>
		  </tr>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	sql = " SELECT A.COD_EMPRESA, A.CODIGO, A.MATRICULA, A.NOMEALUNO, A.MAE, A.DATANASCIMENTO, A.FONERESIDENCIAL, T.NOMETURMA, PV.CODPROJETOSOCIAIS, PV.NUMEROBENEFICIO "
	sql = sql & " FROM SCA_PROJETOSOCIAIS_VINCULO PV "
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = PV.COD_ALUNO AND A.COD_EMPRESA = PV.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = PV.CODTURMA AND T.COD_EMPRESA = PV.COD_EMPRESA "
	sql = sql & " WHERE PV.COD_EMPRESA = " & session("CodEmpresa")
	sql = sql & " and PV.CODPROJETOSOCIAIS = " & intCodProjetoSociais
	sql = sql & " and PV.ano_letivo = " & strAnoLetivo	
	sql = sql & " and PV.semestre = " & intSemestre	
	if strOrdem = "alfabetica" then
		sql = sql & " Order By A.NOMEALUNO"
	elseif strOrdem = "Turma" then
		sql = sql & " Order By T.NOMETURMA, A.NOMEALUNO"
	end if
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
			sql = " SELECT "
			sql = sql & " 100-isnull(((SELECT SUM(FALTA) FROM SCA_FALTAS_DIARIA "
			sql = sql & " WHERE cod_empresa = " & session("CodEmpresa") & " and cod_aluno = " & rs("codigo") & " and ano_letivo = " & session("strAnoLetivo") & " and semestre = " & session("strSemestre") & " and MONTH(data) >= " & strMesInicial & " and MONTH(data)<= " & strMesFinal & " ) * 100 ) / SUM(GCD.Ch_Mensal) * " & intNumeroMeses & ",'0') as frequencia "
			sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
			sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
			sql = sql & " SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO  AND AD.cod_empresa = T.cod_empresa INNER JOIN "
			sql = sql & " SCA_DISCIPLINA DI ON DI.COD_EMPRESA = AD.COD_EMPRESA AND DI.COD_DISCIPLINA = AD.COD_DISCIPLINA INNER JOIN "
			sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA INNER JOIN "
			sql = sql & " SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular "
			sql = sql & " WHERE AD.COD_EMPRESA = " & session("CodEmpresa")
			sql = sql & " AND A.CODIGO = " & rs("codigo")	
			rs1.open sql, cnn
			if not rs1.eof then 
			   intfrequencia = rs1("frequencia")
			   if isnull(intfrequencia) or intfrequencia < 0 then intfrequencia = "0"
			else   
			   intfrequencia = "0"
			end if   
			rs1.close   
		
			%>
			  <tr>
				<td class="celula" align="left"><div align="center"><%=rs("MATRICULA")%>&nbsp;</div></td>
				<td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="celula"><%=rs("MAE")%>&nbsp;</td>
				<td align="center" class="celula"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
				<td class="celula" align="center"><strong><%=rs("FONERESIDENCIAL")%>&nbsp;</strong></td>
				<td class="celula" align="center"><%=rs("NomeTurma")%>&nbsp;</td>
				<td class="celula" align="center"><%=rs("NUMEROBENEFICIO")%>&nbsp;</td>
				<td class="celula" align="center">&nbsp;<%=intfrequencia%>%</td>
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
			<td colspan="8" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="8" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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