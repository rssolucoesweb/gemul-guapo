<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Integralizacao Curricular
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
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
	
	strCod_empresa 					= Session("CodEmpresa")
	strCodAluno						= Trim(Request("txtCodAluno"))

	if strCodAluno = "" then
		strCodAluno					=	Trim(Request.form("chkAluno"))
	end if
	
	' Verificando a alocação do aluno
	sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA, SCA_TURMA.ANOLETIVO, SCA_GRADECURRICULAR.COD_AGRUPAMENTO, SCA_TURMA.Cod_GradeCurricular, SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_TURMA.Nometurma "
	sql = sql & " FROM SCA_ALUNO_TURMA " 
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO " 
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
	sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO.CODIGO = " & strCodAluno
	sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
	rs.open sql, cnn
	if not rs.eof then
	   	intCodCurso   					= rs("cod_curso") 
	   	intCodTurma    					= rs("COD_TURMA")
		intGradeagrupamento	            = rs("COD_AGRUPAMENTO")
	   	strSemestre    					= rs("COD_SEMESTRE")
	 	strAnoLetivo   					= rs("ANOLETIVO")
	end if
	rs.close
	
	'DESCRICAO DO CURSO
	sql="SELECT C.DESCRICAO, G.DATAINICIOVIGENCIA, G.DATAFIMVIGENCIA"
	sql=sql & " FROM SCA_CURSO C"
	sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_CURSO = C.COD_CURSO AND P.COD_EMPRESA = C.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_PERIODO = P.COD_PERIODO AND G.COD_EMPRESA = P.COD_EMPRESA"
	sql=sql & " WHERE G.COD_EMPRESA = " & session("CodEmpresa")
    
	if intGradeagrupamento = "0" then
	   sql=sql & " AND C.COD_CURSO = " & intCodCurso
	   sql=sql & " AND G.AnoReferencia = " & strAnoLetivo
	   sql=sql & " AND G.SemestreReferencia = " & strSemestre
	else   
	   sql=sql & " AND G.cod_agrupamento = " & intGradeagrupamento
	end if
	   
    sql=sql & " GROUP BY C.DESCRICAO, G.DATAINICIOVIGENCIA, G.DATAFIMVIGENCIA"
	sql=sql & " ORDER BY 2 DESC"
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoCurso 	 = UCASE(rs("DESCRICAO"))
		strVigencia = ""
		IF NOT ISNULL(rs("DATAINICIOVIGENCIA")) THEN
			strVigencia = "Vigência: " & FORMATADATAAP(rs("DATAINICIOVIGENCIA")) & " a " & FORMATADATAAP(rs("DATAFIMVIGENCIA"))
		END IF
	end if
	rs.close
		
	strFiltro	 			= Trim(Request("f"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "INTEGRALIZAÇÃO CURRICULAR "

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td colspan="4" class="TituloFormulario" align="center"><font size="+1"><%=UCASE(strDescricaoCurso)%></font><BR><%=strVigencia%></td>
	  </tr>
	</table>	
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="63%" height="15" rowspan="2" class="celula"><strong>Disciplinas da Grades</strong></td>
	    <td width="14%" rowspan="2" align="center" class="celula"><strong>Per&iacute;odo</strong></td>
	    <td colspan="3" align="center" class="celula"><strong>C.H.</strong></td>
	    <td width="8%" rowspan="2" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="7%" align="center" class="celula">S</td>
        <td width="8%" align="center" class="celula">M</td>
        <td width="8%" align="center" class="celula">A</td>
      </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	totalCh_Semanal = 0
	totalCh_Mensal = 0
	totalCh_Anual = 0
	contPeriodo = 0

	sql = "SELECT "
	sql = sql & " 	SCA_GRADECURRICULAR.Cod_GRADECURRICULAR,"
	sql = sql & " 	SCA_GRADECURRICULAR.Cod_AGRUPAMENTO,"
	sql = sql & " 	SCA_CURSO.COD_CURSO, "
	sql = sql & " 	SCA_CURSO.DESCRICAO, "
	sql = sql & " 	SCA_PERIODO.cod_periodo, "
	sql = sql & " 	SCA_PERIODO.Descricao as PERIODO, "
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
	sql = sql & " 	SCA_DISCIPLINA.DESC_Disciplina, SCA_GRAU.DESC_GRAU,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal,"
	sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Anual"
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA" 
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	sql = sql & " AND	SCA_PERIODO.Cod_Empresa = " & session("CodEmpresa")
	
    if intGradeagrupamento = "0" then
	   sql = sql & " WHERE	SCA_PERIODO.cod_Curso = " & intCodCurso
	   sql = sql & " AND 	SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivo 
	   sql = sql & " AND 	SCA_GRADECURRICULAR.SemestreReferencia = " & strSemestre
	else   
	   sql=sql & " AND SCA_GRADECURRICULAR.cod_agrupamento = " & intGradeagrupamento
	end if   
	sql = sql & " ORDER BY SCA_CURSO.DESCRICAO,SCA_PERIODO.Descricao,SCA_GRADECURRICULAR.Cod_GRADECURRICULAR, SCA_DISCIPLINA.DESC_Disciplina"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
			strCursando = " --- "
			
			sql = " select distinct hed.Situacao, he.Cod_aluno, hed.Cod_Disciplina, hed.cod_periodo"
			sql = sql & " from sca_historico_escolar_disciplina hed "
			sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
			sql = sql & " inner JOIN sca_periodo p ON p.cod_periodo = hed.cod_periodo "
			sql = sql & " where he.Cod_aluno = " & strCodAluno
			sql = sql & " and hed.Cod_Disciplina = " & trim(rs("Cod_Disciplina"))
			sql = sql & " and hed.cod_periodo = " & trim(rs("cod_periodo"))
			rsAux.open sql, cnn
			if not rsAux.eof then
				
				if trim(rsAux("Situacao")) = "CR" then
					strCursando = "CURSANDO"
				end if
				
				if trim(rsAux("Situacao")) = "RN" OR trim(rsAux("Situacao")) <> "RP"  then
					strCursando = "REPROVADO"
				end if
				
				if trim(rsAux("Situacao")) = "AP" then
					strCursando = "CURSADO"
				end if
			end if
			rsAux.close	 
	
			if cont > 1 and  trim(cod_periodo) <> trim(rs("cod_periodo")) then
			%>
			  <tr>
			    <td colspan="2" align="right" class="celula"><strong>Carga Hor&aacute;rio total do per&iacute;odo:&nbsp; </strong></td>
			    <td align="center" class="celula">&nbsp;<%=totalCh_Semanal%></td>
			    <td align="center" class="celula">&nbsp;<%=totalCh_Mensal%></td>
			    <td align="center" class="celula"><%=totalCh_Anual%>&nbsp;</td>
			    <td align="center" class="celula">&nbsp;</td>
	  		</tr>
			<%
				totalCh_Semanal = 0
				totalCh_Mensal = 0
				totalCh_Anual = 0
				contPeriodo = contPeriodo + 1
			end if
			%>
			  <tr>
			    <td align="left" class="celula"><%=rs("DESC_Disciplina")%>&nbsp</td>
			    <td align="center" class="celula"><%=rs("PERIODO")%>&nbsp</td>
			    <td align="center" class="celula">&nbsp;<%=rs("Ch_Semanal")%></td>
			    <td align="center" class="celula">&nbsp;<%=rs("Ch_Mensal")%></td>
			    <td align="center" class="celula"><%=rs("Ch_Anual")%>&nbsp;</td>
			    <td align="center" class="celula"><%=strCursando%>&nbsp;</td>
			  </tr>
			<%
			totalCh_Semanal = totalCh_Semanal + rs("Ch_Semanal")
			totalCh_Mensal = totalCh_Mensal + rs("Ch_Mensal")
			totalCh_Anual = totalCh_Anual + rs("Ch_Anual")

			totalGCh_Semanal = totalGCh_Semanal + rs("Ch_Semanal")
			totalGCh_Mensal = totalGCh_Mensal + rs("Ch_Mensal")
			totalGCh_Anual = totalGCh_Anual + rs("Ch_Anual")
			
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
			cod_periodo = trim(rs("cod_periodo"))
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
		%>
		  <tr>
			<td colspan="2" align="right" class="celula"><strong>Carga Hor&aacute;rio total do per&iacute;odo:</strong></td>
			<td align="center" class="celula">&nbsp;<%=totalCh_Semanal%></td>
			<td align="center" class="celula">&nbsp;<%=totalCh_Mensal%></td>
			<td align="center" class="celula">&nbsp<%=totalCh_Anual%></td>
			<td align="center" class="celula">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="2" align="right" class="celula"><strong>Carga Hor&aacute;rio total do curso:</strong></td>
			<td align="center" class="celula">&nbsp;<%=totalGCh_Semanal%></td>
			<td align="center" class="celula">&nbsp;<%=totalGCh_Mensal%></td>
			<td align="center" class="celula">&nbsp;<%=totalGCh_Anual%></td>
			<td align="center" class="celula">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="6" class="celula">Quantidade de Períodos: <%=contPeriodo%></td>
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
