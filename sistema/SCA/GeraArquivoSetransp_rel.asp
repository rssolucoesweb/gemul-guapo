<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: rel setransp
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
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSimouNao     		= Trim(Request.Form("cmbSimouNao"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "RELATÓRIO - SETRANSP"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="20%" class="celula"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="5%" class="celula"><div align="center"><strong>Data Nascimento</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Nome da Mãe</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Logradouro</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Quadra/Lote/Complemento</strong></div></td>
		<td width="5%" class="celula"><div align="center"><strong>Número</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Bairro</strong></div></td>
		<td width="10%" class="celula"><div align="center"><strong>Cidade</strong></div></td>
		<td width="5%" class="celula"><div align="center"><strong>Cod.Setransp</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = "SELECT SCA_ALUNO.LOGRADOURO, SCA_ALUNO.COMP_ENDERECO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE, "
	sql = sql & " SCA_ALUNO.NUMERO_ENDERECO, SCA_ALUNO.BAIRROALUNO, SCA_ALUNO.LOGRADOURO, SCA_ALUNO.CIDADERESIDENCIA, SCA_ALUNO.SETRANSP "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
	
	if strSimouNao = "S" then
	   sql = sql & " and SCA_ALUNO.SETRANSP is not null"
	end if
	
	if intCodCurso <> "0" then
		sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
	end if
	if intCodPeriodo <> "0" then
		sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
	end if
	if intCodTurno <> "0" then
		sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
	end if
	if intCodTurma <> "0" then
		sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
	end if
	if intCodSituacaoAluno <> "0" then
		sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	end if
 	sql = sql & " Order By SCA_ALUNO.NOMEALUNO"

	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("NOMEALUNO")))%>&nbsp;</td>
				<td class="celula" align="center"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("MAE")))%>&nbsp;</td>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("LOGRADOURO")))%>&nbsp;</td>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("COMP_ENDERECO")))%>&nbsp;</td>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("NUMERO_ENDERECO")))%>&nbsp;</td>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("BAIRROALUNO")))%>&nbsp;</td>
				<td class="celula" align="left"><%=UCASE(TRIM(rs("CIDADERESIDENCIA")))%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("SETRANSP")%>&nbsp;</td>
			  </tr>

			<%
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 30 then
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
			<td colspan="9" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="9" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
