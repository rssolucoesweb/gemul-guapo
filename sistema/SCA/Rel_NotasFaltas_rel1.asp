<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Ficha Individual do Aluno
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
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intQtdeQuebraExtrato  	    = Trim(Request.Form("cmbQtdeQuebraExtrato"))
	
	intIntervaloPercFaltaInicial	= Trim(Request.Form("txtIntervaloPercFaltaInicial"))
	intIntervaloPercFaltaFinal	= Trim(Request.Form("txtIntervaloPercFaltaFinal"))

	intIntervaloMediaInicial	= Trim(Request.Form("txtIntervaloMediaInicial"))
	intIntervaloMediaFinal		= Trim(Request.Form("txtIntervaloMediaFinal"))

	intIntervaloPercFaltaInicial	= ""
	intIntervaloPercFaltaFinal	= ""

	intIntervaloMediaInicial	= ""
	intIntervaloMediaFinal		= ""

	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Notas e Faltas por Disciplinas"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	
	intColunas = 0
	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	if strMostraResultadoFinal = "S" then intColunas = intColunas + 1
	strMostraCH			= Trim(Request.Form("CH"))
	if strMostraCH = "S" then intColunas = intColunas + 1
	strMostraPercFaltas = Trim(Request.Form("PercFaltas"))
	if strMostraPercFaltas = "S" then intColunas = intColunas + 1
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	strCod_empresa 		= Session("CodEmpresa")
	

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

	'BUSCA A AVALIACOES
	'BUSCA A AVALIACOES
	sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE<>8"
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn
	if not rs.eof then
		while not rs.eof
			if cInt(rs("bimestre")) < 5 then
				intColunas = intColunas + 2
			else
				intColunas = intColunas + 1
			end if
			rs.movenext
		wend
	end if
	rs.close
	'adiciona 1 para disciplina
	intColunas = intColunas + 1
	'adiciona 1 para media
	intColunas = intColunas + 1
	
	
	sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.SIGLA, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " AND		TA.BIMESTRE<>8"
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn, 3, 1
	if rs.eof then
		rs.close
		%>
			<script>
					var men = 'ATENÇÃO: \nNão foi encontrado critério de avaliação para o curso <%=strDescricaoCurso%> dessa turma. Deseja cadastrar o critério desse curso?';
					if (confirm(men)) {
						window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
					} else {
						window.history.back();
					}
			</script>
		<%
		response.end
	else
		intMediaAprovacao = rs("media_aprovacao")
		intCont = 1
		redim vetTipoNota(rs.recordCount,2)
		strDescTipoNotaTitulo = ""
		while not rs.eof
			if strDescTipoNotaTitulo = "" then
				strDescTipoNotaTitulo = RS("BIMESTRE")
			else
				strDescTipoNotaTitulo = strDescTipoNotaTitulo & "," & RS("BIMESTRE")
			end if
			
			if isnull(RS("BIMESTRE")) or isnull(RS("POSICAO")) then
				rs.close
				cnn.close
				%>
				<script>
					alert("ATENÇÃO: Tipo de avaliação não foi informado corretamente, favor acessar o menu Cadastro/Tipo de Avaliação e fazer as correções.");
					window.history.back();
				</script>
				<%
				response.end			
			end if
			
			vetTipoNota(intCont,1) = ZeroLeft(RS("POSICAO"),2) & "_" & RS("BIMESTRE")
			vetTipoNota(intCont,2) = RS("SIGLA")
			intCont = intCont + 1
			rs.movenext
		wend
	end if
	rs.close
	
	strCodAluno			= Trim(Request("chkAluno"))
	if strCodAluno <> "" then
		vetAluno	=	split(Trim(Request.form("chkAluno")),",")
	end if
	bolLinhaTilulo = true
	mostraCabecalho
	if strCodAluno <> "" then 

		contQuebra = 0		
		for j=0 to ubound(vetAluno)

			'aluno na turma
			sql = "select AT.COD_TURMA, T.Cod_GradeCurricular"
			sql = sql & " from SCA_ALUNO_TURMA AT"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
			sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
			sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
			sql = sql & " and AT.COD_ALUNO = " &  vetAluno(j)
			sql = sql & " and AT.ANO_LETIVO = " &  intAnoLetivoAtual
			sql = sql & " and AT.SEMESTRE IN (" &  intSemestreAtual & ")"
			sql = sql & " and AT.SITUACAO = 'A'"'ATIVA

			rs.open sql, cnn
			if not rs.eof then
				intCodTurma = rs("cod_Turma")
			end if
			rs.close
	
			if intCodTurma <> "" then
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
				'regra para buscar dados de anos anteriores
				if cInt(intAnoLetivoAtual)<cInt(intAnoLetivoSession) then
				'HISTORICO ESCOLAR
					sql = " SELECT SCA_ALUNO.CODIGO, "
					sql = sql & " 	SCA_ALUNO.MATRICULA, "
					sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
					sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Anual,"
					sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
					sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
					sql = sql & " 	SCA_TURMA.NOMETURMA, "
					sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
					sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.MEDIA, "
					for i=1 to ubound(vetTipoNota)
						strPos = left(vetTipoNota(i,1),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					next
					sql = sql & " 	SCA_DISCIPLINA.DESC_DISCIPLINA,"
					sql = sql & " 	SCA_TURNO.DESC_TURNO,"
					sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
					sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.CODIGO AS COD_NOTA, "
					sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.SITUACAO "
					sql = sql & " FROM SCA_ALUNO_TURMA "
					sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
					sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
					sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.Cod_GradeCurricularDisciplina AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.Cod_Disciplina "
					sql = sql & " LEFT JOIN SCA_HISTORICO_ESCOLAR  ON SCA_HISTORICO_ESCOLAR.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_HISTORICO_ESCOLAR.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
					sql = sql & " LEFT JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA ON SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_HISTORICO_ESCOLAR = SCA_HISTORICO_ESCOLAR.CODIGO AND SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
					sql = sql & " where	SCA_TURMA.cod_empresa = " & strCod_empresa
					sql = sql & " AND		SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
					sql = sql & " AND		SCA_ALUNO_TURMA.SITUACAO = 'A'"
					sql = sql & " AND		SCA_ALUNO.CODIGO = " & vetAluno(j)
					sql = sql & " AND		SCA_HISTORICO_ESCOLAR.ANO_LETIVO = " & intAnoLetivoAtual
					sql = sql & " AND		SCA_HISTORICO_ESCOLAR.SEMESTRE = " & intSemestreAtual
					sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO "
				else
				'NOTA ATUAL
					sql = " SELECT SCA_ALUNO.CODIGO, "
					sql = sql & " 	SCA_ALUNO.MATRICULA, "
					sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
					sql = sql & " 	SCA_GRADECURRICULARDISCIPLINA.Ch_Anual,"
					sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
					sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
					sql = sql & " 	SCA_TURMA.NOMETURMA, "
					sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
					sql = sql & " 	SCA_NOTAS_FALTAS.MEDIA, "
					for i=1 to ubound(vetTipoNota)
						strPos = left(vetTipoNota(i,1),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					next
					sql = sql & " 	SCA_DISCIPLINA.DESC_DISCIPLINA,"
					sql = sql & " 	SCA_TURNO.DESC_TURNO,"
					sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
					sql = sql & " 	SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA, "
					sql = sql & " 	SCA_NOTAS_FALTAS.SITUACAO "
					sql = sql & " FROM SCA_ALUNO_TURMA "
					sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
					sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_DISCIPLINA		ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA"
					sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.Cod_GradeCurricularDisciplina AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.Cod_Disciplina"
					sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
					sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
					sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
					sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
					sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & intAnoLetivoAtual
					sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestreAtual
					
					sql = sql & " AND SCA_ALUNO.CODIGO = " & vetAluno(j)
					sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"
				
				end if
				rs.open sql, cnn
				if rs.eof = false then
					strNomeAluno 	 = rs("NOMEALUNO")
					strMatricula 	 = rs("MATRICULA")
					strNomeTurma 	 = rs("NOMETURMA")
					strDescricaoTurno= rs("DESC_TURNO")
					if bolLinhaTilulo then
					%>
					<table width="90%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
					  <tr>
						<td width="16%" rowspan="2" align="center" class="celulaextrato">Disciplinas</td>
						<%
						strTipoNotaAprentadaAnterior = ""
						FOR I=1 TO UBOUND(vetTipoNota) 
							if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
								strColspan = ""
								vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
								if ubound(vet)>=1 then	
									if cInt(right(vetTipoNota(I,1),1)) > 4 then	
										strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
									else
										strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
									end if
								end if
								strBim = right(vetTipoNota(I,1),1) & "ºBimestre" 
								'5	Média Provisória 
								'6	Exame
								'7	Conselho de Classe
								'8	Media Final							
								if cInt(right(vetTipoNota(I,1),1)) > 4 then strBim = vetTipoNota(I,2)
								if cInt(right(vetTipoNota(I,1),1)) = 5 then strBim = "Média Provisória"
								if cInt(right(vetTipoNota(I,1),1)) = 6 then strBim = "Exame"
								if cInt(right(vetTipoNota(I,1),1)) = 7 then strBim = "Conselho de Classe"
								%>
								<td            align="center" class="celulaextrato" <%=strColspan%>><%=strBim%></td>
								<%
							end if
							strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
						NEXT %>
						<td align="center" class="celulaextrato" >Média</td>
						<%if strMostraResultadoFinal = "S" then%>
						<td align="center" class="celulaextrato" >Resultado</td>
						<%end if%>
						<%if strMostraCH = "S" then%>
						<td align="center" class="celulaextrato" >Carga</td>
						<%end if%>
						<%if strMostraPercFaltas = "S" then%>
						<td align="center" class="celulaextrato" >Faltas</td>
						<%end if%>
						</tr>
					  <tr>
						<%	strTipoNotaAprentadaAnterior = ""
							FOR I=1 TO UBOUND(vetTipoNota) 
								if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7"  then
								%>
								<td align="center" class="celulaextrato">Faltas</td>	
								<%
								end if
								%>
								<td align="center" class="celulaextrato"><%=vetTipoNota(I,2)%></td>
								<%
								strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
							NEXT %>
						<td align="center" class="celulaextrato" >Final</td>
						<%if strMostraResultadoFinal = "S" then%>
						<td align="center" class="celulaextrato" >Final</td>
						<%end if%>
						<%if strMostraCH = "S" then%>
						<td align="center" class="celulaextrato" >Horaria</td>
						<%end if%>
						<%if strMostraPercFaltas = "S" then%>
						<td align="center" class="celulaextrato" >(%)</td>
						<%end if%>
						</tr>
					<% bolLinhaTilulo = false
					end if
					if trim(strNomeTurma) <> trim(strNomeTurmaAnt) then
					%>
					  <tr bgcolor="#EFEFEF">
						<td colspan="<%=intColunas%>" align="center" class="celula"><strong>(<%=strNomeTurma%>)&nbsp;&nbsp;<%=strDescricaoCurso%> - <%=strDescricaoPeriodo%></strong></td>
						</tr>
					  <tr>
					<%
					end if
					strNomeTurmaAnt = strNomeTurma
					%>
					  <tr>
						<td colspan="<%=intColunas%>" align="left" class="celula">&nbsp;&nbsp;&nbsp;&nbsp;<strong>&nbsp;<%=strMatricula%> - <%=strNomeAluno%></strong></td>
						</tr>
					  <tr>
					<%
					strTotalFaltas = 0
					while not rs.eof	
						strTotalFalta 	= 0
						strDisciplina 	= rs("DESC_DISCIPLINA")
						strMedia		= "---"
						strResultadoFinal 	= ""
						strCHDisciplina		= RS("Ch_Anual")
						
						bolMostraLinha = true
						strFalta = 0
							
						'utilizado somente quando for utilizado o filtro de percentual de faltas
						if intIntervaloPercFaltaInicial <> "" and intIntervaloPercFaltaFinal <> "" then
						   FOR I=1 TO UBOUND(vetTipoNota) 
								strPos = left(vetTipoNota(i,1),2)
								if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
									strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
								end if
								if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
									if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
										strFalta = strFalta  + rs("FALTA" & strPos)
									end if
								end if
								if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7"  then
									if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
									strFalta = rs("FALTA" & strPos)
								end if
								strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
						   NEXT 
						
						   if isnull(strCHDisciplina) then
								strPercFaltas = 0
								bolMostraLinha = false
						   else
								strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
								if strPercFaltas >= intIntervaloPercFaltaInicial and strPercFaltas <= intIntervaloPercFaltaFinal then
								   bolMostraLinha = true
								else
								   bolMostraLinha = false
								end if					
						   end if
							
						end if
						
						if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
						
							strMedia = FORMATNUMBER(rs("MEDIA"),1)
							if cCur(strMedia) < cCur(intMediaAprovacao) then
								strResultadoFinal = "<font color='#FF0000'>RN</font>"
							else
								strResultadoFinal = "<font color='#0000FF'>AP</font>"
							end if
							if intIntervaloMediaInicial <> "" and intIntervaloMediaFinal <> "" then
								if rs("MEDIA") >= intIntervaloMediaInicial and rs("MEDIA") <= intIntervaloMediaFinal then
								   bolMostraLinha = true
								else
								   bolMostraLinha = false
								end if
							end if
						else
						
							if intIntervaloMediaInicial <> "" and intIntervaloMediaFinal <> "" then
								bolMostraLinha = false
							end if                    
						end if
						
						if bolMostraLinha then
						
							
							IF TRIM(RS("SITUACAO"))="RN" THEN
								strResultadoFinal = "<font color='#FF0000'>RN</font>"
							ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
								strResultadoFinal = "<font color='#0000FF'>AP</font>"
							END IF
								%>
								<td width="16%" align="left" class="celulaextrato">&nbsp;<%=strDisciplina%></td>
								<%	
								strTipoNotaAprentadaAnterior = ""
								strFalta = 0
								
								FOR I=1 TO UBOUND(vetTipoNota) 
									strPos = left(vetTipoNota(i,1),2)
									strNota = "---"
									if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
										strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
									end if
									if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
										if trim(strTipoNotaAprentadaAnterior) = trim(right(vetTipoNota(I,1),1)) or strTipoNotaAprentadaAnterior = "" then
											strFalta = strFalta  + rs("FALTA" & strPos)
										end if
									end if
									if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" and trim(right(vetTipoNota(I,1),1)) <> "7"  then
										%>
										<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strFalta%>&nbsp;</td>
										<%
										if not isnull(strFalta) then strTotalFaltas = strTotalFaltas + strFalta
										strFalta = rs("FALTA" & strPos)
									end if
									%>
									<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strNota%>&nbsp;</td>
									<%
									strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
								NEXT 
								
								
								if isnull(strCHDisciplina) then
									strPercFaltas = 0
								else
									strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
								end if
								%>
								<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strMedia%>&nbsp;</td>
								<%if strMostraResultadoFinal = "S" then%>
								<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
								<%end if%>
								<%if strMostraCH = "S" then%>
								<td width="5%" align="center" class="celulaextrato">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
								<%end if%>
								<%if strMostraPercFaltas = "S" then%>
								<td width="5%" align="center" class="celulaextrato">&nbsp;<%if strPercFaltas<>0 then response.Write formatNumber(strPercFaltas,1) %>&nbsp;</td>
								<%end if%>
							  </tr>
								<%
							end if 
							strTotalFaltas = 0
						rs.movenext
					wend 
				end if
				rs.close
				contQuebra = contQuebra + 1
				'A contQuebra tem que ser igual Qtde. Quebra informado na tela pelo usuario 
				if j <> ubound(vetAluno) and contQuebra = intQtdeQuebraExtrato then
					%>
	<%	
					contQuebra = 0		
				end if	
				%>
					  <tr>
						<td align="right" colspan="<%=intColunas-1%>" class="celulaextrato"><strong>Resultado Final</strong>&nbsp;&nbsp;</td>
						<td align="left" class="celulaextrato">&nbsp;</td>
					  </tr>
					  <tr>
					<%					
			end if
		next
				%></table>
<%		
		'next aluno		
	else
		rs.close
		cnn.close
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
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
