<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: faltas diarias
-->
<html>
<head>
<title><%=session("Titulo")%> - Extrato de Notas e Faltas</title>
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
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	sub buscaProfessor(anoLetivo, semestre, codDisc, turma)
		professor = ""
		sql = "SELECT	C.NOME AS PROFESSOR"
		sql = sql & " 	FROM	SCA_HORARIO_AULA HA"
		sql = sql & " 	INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
		sql = sql & " 	INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " 	INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " 	INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " 	INNER JOIN SCA_CURSO CU ON CU.COD_EMPRESA=T.COD_EMPRESA AND CU.COD_CURSO=P.COD_CURSO"
		sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA=HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
		sql = sql & " 	INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
		sql = sql & " 	WHERE	HA.COD_EMPRESA	= " & session("CodEmpresa")
		sql = sql & " 	AND		HA.ANOLETIVO	= " & anoLetivo
		sql = sql & " 	AND		T.COD_TURMA 	= " & turma
		sql = sql & " 	AND		D.COD_DISCIPLINA = " & codDisc
		sql = sql & " 	AND		HA.SEMESTRE		= " & semestre
		RSaux.OPEN SQL, CNN
		IF not RSaux.EOF THEN
			professor	= ucase(RSaux("professor"))
		END IF
		RSaux.close
		response.Write(professor)
	end Sub	
	
	
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intCodDisciplina			= Trim(Request.Form("cmbDisciplinaTurma"))
	intMes						= Trim(Request.Form("cmbMes"))
	
	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Extrato de Notas e Faltas<br>"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	

	
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		intCodCurso 	= rs("cod_curso")
		intCodPeriodo = rs("cod_periodo")
		intCodTurno = rs("cod_turno")
		intSemestre = rs("cod_Semestre")
	END IF
	rs.close
	
	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	strMostraCH			= Trim(Request.Form("CH"))
	strMostraPercFaltas = Trim(Request.Form("PercFaltas"))
	
	strCod_empresa 		= Session("CodEmpresa")
	
	'DESCRICAO DO PERIODO	
	sql="SELECT P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO "
	sql=sql & " FROM 	SCA_PERIODO P "
	sql=sql & " INNER 	JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA "
	sql=sql & " WHERE 	C.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND 	P.COD_PERIODO = " & intCodPeriodo
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoPeriodo  = rs("PERIODO")
		strDescricaoCurso 	 = rs("CURSO")
	end if
	rs.close	
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strCC				= "6CC"
	strCodBimestre		= ""

	strCodAluno			= Trim(Request("chkAluno"))
	if strCodAluno <> "" then
		vetAluno	=	split(Trim(Request.form("chkAluno")),",")
	end if
	strMensagemExisteFaltas = false
	
	
	if strCodAluno <> "" then 
		contQuebra = 0		
		for j=0 to ubound(vetAluno)
			
			'NOTA ATUAL
			sql = " SELECT		SCA_ALUNO.CODIGO,"
			sql = sql & " 				SCA_ALUNO.MATRICULA, "
			sql = sql & " 				SCA_ALUNO.NOMEALUNO, "
			sql = sql & " 				SCA_ALUNO_TURMA.SEQUENCIA, "
			sql = sql & " 				SCA_ALUNO_TURMA.COD_TURMA, "
			sql = sql & " 				SCA_TURMA.NOMETURMA, "
			sql = sql & " 				SCA_FALTAS_DIARIA.FALTA,"
			sql = sql & " 				SCA_FALTAS_DIARIA.DATA,"
			sql = sql & " 				SCA_DISCIPLINA.DESC_DISCIPLINA,"
			sql = sql & " 				SCA_TURNO.DESC_TURNO,"
			sql = sql & " 				SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
			sql = sql & " 				SCA_DISCIPLINA.COD_DISCIPLINA "
			sql = sql & " from  SCA_FALTAS_DIARIA"
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_FALTAS_DIARIA.COD_ALUNO AND SCA_FALTAS_DIARIA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_FALTAS_DIARIA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA"
			sql = sql & " INNER JOIN SCA_DISCIPLINA		ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA"
			sql = sql & " INNER JOIN SCA_ALUNO_TURMA		ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_FALTAS_DIARIA.COD_ALUNO AND SCA_FALTAS_DIARIA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_ALUNO			ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_TURMA			ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
			sql = sql & " INNER JOIN SCA_TURNO			ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
			sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
			sql = sql & " and 	SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
			sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
			sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual
			sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestreAtual
			sql = sql & " and 	SCA_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
			sql = sql & " and 	SCA_ALUNO.CODIGO = " & vetAluno(j)
			sql = sql & " and	MONTH(SCA_FALTAS_DIARIA.DATA) = " & intMes
			sql = sql & " and	YEAR(SCA_FALTAS_DIARIA.DATA) = " & intAnoLetivoAtual
			sql = sql & " ORDER BY 	SCA_FALTAS_DIARIA.DATA"
			rs.open sql, cnn
			if rs.eof = false then
				mostraCabecalho
				strMensagemExisteFaltas = true
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strDescricaoTurno= rs("DESC_TURNO")
				%>
					<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
					  <tr>
						<td width="8%">Aluno(a):</td>
						<td width="63%">&nbsp;<strong><%=strNomeAluno%></strong></td>
						<td width="14%">Matr&iacute;cula:</td>
						<td width="15%">&nbsp;<strong><%=strMatricula%></strong></td>
					  </tr>
					  <tr>
						<td>Curso:</td>
						<td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
						<td>Turma:</td>
						<td>&nbsp;<strong><%=strNomeTurma%></strong></td>
					  </tr>
					  <tr>
					    <td>Per&iacute;odo:</td>
					    <td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					    <td>Turno:</td>
					    <td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
				      </tr>
					</table>
					<br>
					<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <tr>
				    <td align="center" class="celula"><font size="1">Disciplina: <strong><%=rs("DESC_DISCIPLINA")%></strong></font></td>
				    <td align="center" class="celula"><font size="1">Professor(a): <strong><% buscaProfessor intAnoLetivoAtual, intSemestreAtual, rs("COD_DISCIPLINA"), intCodTurma%></strong></font>&nbsp;</td>
				    </tr>
				  <tr>
				    <td width="50%" align="center" class="celula"><strong>Dias da(s) Falta(s)</strong></td>
					<td align="center" class="celula"><strong>Quantidade de Faltas</strong></td>	
					</tr>
				  <tr>
				<%
				strTotalFaltas = 0
				while not rs.eof	
						%>
					<td width="50%" align="center" class="celula">&nbsp;<%=FORMATADATAAP(rs("DATA"))%></td>
					<td width="50%" align="center" class="celula">&nbsp;<%=rs("FALTA")%>&nbsp;</td>
					  </tr>
						<%
						strTotalFaltas = strTotalFaltas + rs("FALTA")
					rs.movenext
				wend 
				%>
				  <tr>
				    <td align="center" class="celula"><strong>Total de Faltas</strong></td>
				    <td align="center" class="celula"><strong>&nbsp;<%=strTotalFaltas%>&nbsp;</strong></td>
				    </tr>
                </table>
<br>
				<!--#include file="../includes/inc_RepresentantesLegais.asp"-->
				<br>
			<%		
			end if
			rs.close
			contQuebra = contQuebra + 1
			if j <> ubound(vetAluno) and contQuebra = 2 then
				%>
				<pre></pre>				
				<%	
				contQuebra = 0		
			end if			
		next
		'next aluno		
	else
		rs.close
		cnn.close
		%>
		<script>
			alert("Aluno não foi encontrado, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	if strMensagemExisteFaltas = false then
		%>
		<script>
			alert("Não foi encontrado registro para esse relatório.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>