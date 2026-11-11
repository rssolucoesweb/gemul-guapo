<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
strPaginaDestino = ""
%>
<%
strAnoCab = Trim(Request.QueryString("AnoLetivo"))
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
</head>
<body>
<script src="js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/js_dragdrop.js"></script>

<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
	sub buscaProfessor(anoLetivo, semestre, codDisc, turma)
		professor = ""
		sql = "SELECT	C.NOME AS PROFESSOR"
		sql = sql & " 	FROM	SCA_HORARIO_AULA HA"
		sql = sql & " 	INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
		sql = sql & " 	INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " 	INNER JOIN SCA_GRADECURRICULAR G ON  G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " 	INNER JOIN SCA_PERIODO P ON  P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " 	INNER JOIN SCA_CURSO CU ON  CU.COD_CURSO=P.COD_CURSO"
		sql = sql & " 	INNER JOIN SRH_COLABORADOR C ON  C.CODIGO=HA.COD_COLABORADOR"
		sql = sql & " 	INNER JOIN SCA_DISCIPLINA D ON  D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
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
	
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intCodDisciplina			= Trim(Request.Form("cmbDisciplinaTurma"))
	strVerificaHistorico		= Trim(Request("optVerificaHistorico"))

	if trim(intSemestreAtual) = "3" then
	   msgTitulo  =  "<br>Período Letivo: " & intAnoLetivoAtual
	else
	   msgTitulo  =  "<br>Período Letivo: " & intAnoLetivoAtual & "/" & intSemestreAtual
    end if

	if strVerificaHistorico = "S" then  
    	strTabela = "SCA_FALTAS_DIARIA_HISTORICO"
    else  
    	strTabela = "SCA_FALTAS_DIARIA"
    end if 
	
	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "EXTRATO DIARIO DE FALTAS<BR>" & msgTitulo

	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
<%
	end Sub
	sub fimTabela()
		response.Write("</table></div>")
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
	sql=sql & " INNER 	JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO"
	sql=sql & " WHERE 	 P.COD_PERIODO = " & intCodPeriodo
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
			
			sql = " SELECT "
			sql = sql & " NULL as TAXA, " 
			sql = sql & " NULL AS DATA_ABONO, " 
			sql = sql & " NULL AS USUARIO_ABONO, " 
			sql = sql & " A.CODIGO, " 
			sql = sql & " A.MATRICULA, " 
			sql = sql & " A.NOMEALUNO, " 
			sql = sql & " T.COD_TURMA, " 
			sql = sql & " T.NOMETURMA, T.TURMAALUNO, " 
			sql = sql & " FD.DATA, " 
			sql = sql & " D.DESC_DISCIPLINA, " 
			sql = sql & " TUR.DESC_TURNO, " 
			sql = sql & " D.COD_DISCIPLINA, " 
			sql = sql & " COUNT(FD.FALTA) AS FALTA " 
			sql = sql & " from " & strTabela & " FD "
			sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = FD.COD_ALUNO "
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = FD.COD_DISCIPLINA " 
			sql = sql & " INNER JOIN SCA_TURMA T ON (SELECT TOP 1 COD_TURMA FROM SCA_ALUNO_TURMA WHERE COD_ALUNO = A.CODIGO AND SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual & " and SCA_ALUNO_TURMA.Semestre in (" & intSemestreAtual & ") ORDER BY CODIGO DESC) = T.Cod_Turma "
			sql = sql & " INNER JOIN SCA_TURNO TUR ON TUR.COD_TURNO = T.Cod_TURNO " 
			sql = sql & " where FD.cod_empresa = " & strCod_empresa
			'sql = sql & " and T.COD_TURMA = " & intCodTurma 
			sql = sql & " and T.AnoLetivo = " & intAnoLetivoAtual
			sql = sql & " and T.Cod_Semestre = " & intSemestreAtual 
			sql = sql & " and FD.COD_DISCIPLINA = " & intCodDisciplina 
			sql = sql & " and YEAR(FD.DATA) = " & intAnoLetivoAtual 
			sql = sql & " and A.CODIGO = " & vetAluno(j)
			sql = sql & " GROUP BY A.CODIGO, A.MATRICULA, A.NOMEALUNO, T.COD_TURMA, T.NOMETURMA, T.TURMAALUNO, FD.DATA, D.DESC_DISCIPLINA, TUR.DESC_TURNO, D.COD_DISCIPLINA "
			sql = sql & " ORDER BY FD.DATA "
			'response.write sql
			rs.open sql, cnn
			if rs.eof = false then
				mostraCabecalho
				strMensagemExisteFaltas = true
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("TURMAALUNO") & " " & rs("NOMETURMA")
				strDescricaoTurno= rs("DESC_TURNO")
				%>
				<div class="table-responsive-lg">
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
					</div>
					<br>
					<div class="table-responsive-lg">
					<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <tr>
				    <td width="50%" height="43" align="center" class="celula"><font size="2">Disciplina:<strong><font size="2"><strong><%=rs("DESC_DISCIPLINA")%></strong></font></strong></font></td>
				    <td width="50%" align="center" class="celula"><font size="2">Professor(a): <strong>
			        <% buscaProfessor intAnoLetivoAtual, intSemestreAtual, rs("COD_DISCIPLINA"), intCodTurma%></strong></font>&nbsp;</td>
				    </tr>
                  </table>
				  </div>
				  <div class="table-responsive-lg">
					<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <tr>
				    <td width="15%" align="center" class="celula"><strong>Data da Falta</strong></td>
					<td align="center" class="celula"><strong>Quantidade de Faltas</strong></td>	
					</tr>
				  <tr>
				<%
				strTotalFaltas = 0
				while not rs.eof	
						%>
					<td width="15%" align="center" class="celula">&nbsp;<%=FORMATADATAAP(rs("DATA"))%></td>
					<td width="14%" align="center" class="celula">&nbsp;<%=rs("FALTA")%>&nbsp;</td>
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
				</div>
<br>
				<!--#include file="includes/inc_RepresentantesLegais.asp"-->
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
