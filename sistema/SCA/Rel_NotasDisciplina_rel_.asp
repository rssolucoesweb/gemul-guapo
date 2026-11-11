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
<title><%=session("Titulo")%> - Notas por Disciplina</title>
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

	dim intPagina
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual

	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Notas por Disciplinas<br>"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	
	intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	intCodTurma 		= Trim(Request.Form("cmbTurma"))
	strCod_empresa 		= Session("CodEmpresa")
	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	
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
	'BUSCA A AVALIACOES
	sql="SELECT TA.POSICAO, TA.DESCRICAO, TA.BIMESTRE, CA.media_aprovacao"
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
	sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
	sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
	sql=sql & " WHERE	CA.COD_EMPRESA = " & strCod_empresa
	sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
	sql=sql & " ORDER BY TA.POSICAO"
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
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
			vetTipoNota(intCont,2) = RS("DESCRICAO")
			intCont = intCont + 1
			rs.movenext
		wend
	end if
	rs.close	
	strCodAluno			= Trim(Request("chkAluno"))
	

	if strCodAluno <> "" then 
		contQuebra = 0		
		mostraCabecalho
		'regra para buscar dados de anos anteriores
			if cInt(intAnoLetivoAtual)<cInt(intAnoLetivoSession) then
			'HISTORICO ESCOLAR
				sql = " SELECT SCA_ALUNO.CODIGO, "
				sql = sql & " 	SCA_ALUNO.MATRICULA, "
				sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
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
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.SITUACAO"
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
				sql = sql & " AND		SCA_ALUNO.CODIGO IN (" & strCodAluno & ")" 
				sql = sql & " AND		SCA_HISTORICO_ESCOLAR.ANO_LETIVO = " & intAnoLetivoAtual
				sql = sql & " AND		SCA_HISTORICO_ESCOLAR.SEMESTRE = " & intSemestreAtual
				sql = sql & " and 		SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " AND 		SCA_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO "
		else
		'NOTA ATUAL				
				sql = " SELECT SCA_ALUNO.CODIGO, "
				sql = sql & " 	SCA_ALUNO.MATRICULA, "
				sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
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
				sql = sql & " 	SCA_NOTAS_FALTAS.SITUACAO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_DISCIPLINA		ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA"
				sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
				sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
				sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " AND SCA_ALUNO.CODIGO IN (" & strCodAluno & ")" 
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " AND SCA_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"		
		end if
		rs.open sql, cnn
		if rs.eof = false then
			strNomeTurma 	 = rs("NOMETURMA")
			strDescricaoTurno= rs("DESC_TURNO")
			strDisciplina 	= rs("DESC_DISCIPLINA")
			%>
				<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td width="8%">Curso:</td>
					<td width="63%">&nbsp;<strong><%=strDescricaoCurso%></strong></td>
					<td width="14%">Turma:</td>
					<td width="15%">&nbsp;<strong><%=strNomeTurma%></strong></td>
				  </tr>
				  <tr>
					<td>Per&iacute;odo:</td>
					<td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					<td>Turno:</td>
					<td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
				  </tr>
				  <tr>
				    <td colspan="4" class="TituloFormulario" align="center"><font size="+1"><%=UCASE(strDisciplina)%></font></td>
			      </tr>
				</table>
				<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
			  <tr>
			    <td width="7%" rowspan="2" align="center" class="celula">Matr&iacute;cula</td>
				<td width="35%" rowspan="2" align="center" class="celula">Nome do Aluno </td>

					<%
					strTipoNotaAprentadaAnterior = ""
					FOR I=1 TO UBOUND(vetTipoNota) 
						if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) then
							strColspan = ""
							vet = split(strDescTipoNotaTitulo,right(vetTipoNota(I,1),1))
							if ubound(vet)>=1 then	
								if right(vetTipoNota(I,1),1) = "5" or right(vetTipoNota(I,1),1) = "6"  then	
									strColspan = "colspan='" & ubound(vet) & "'" 'quat de notas * 2 + 1 da coluna da falta
								else
									strColspan = "colspan='" & ubound(vet)+1 & "'" 'quat de notas * 2 + 1 da coluna da falta
								end if
							end if
							strBim = right(vetTipoNota(I,1),1) & "ºBimestre" 
							if right(vetTipoNota(I,1),1) = "5" then strBim = "Exame Final"
							if right(vetTipoNota(I,1),1) = "6" then strBim = "CC"
							%>
							<td align="center" class="celula" <%=strColspan%>><%=strBim%></td>
							<%
						end if
						strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
					NEXT %>
				<td width="7%" align="center" class="celula" >Média</td>
				<td width="7%" align="center" class="celula" >Faltas</td>
				<%if strMostraResultadoFinal = "S" then%>
				<td width="7%" align="center" class="celula" >Resultado</td>
				<%END IF%>
				</tr>
			  <tr>
			<%	strTipoNotaAprentadaAnterior = ""
				FOR I=1 TO UBOUND(vetTipoNota) 
					if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6" then
					%>
					<td align="center" class="celula">Faltas</td>	
					<%
					end if
					%>
					<td align="center" class="celula"><%=vetTipoNota(I,2)%></td>
					<%
					strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
				NEXT %>
				<td width="7%" align="center" class="celula" >Total</td>
				<td width="7%" align="center" class="celula" >Total</td>
				<%if strMostraResultadoFinal = "S" then%>
				<td width="7%" align="center" class="celula" >Final</td>
				<%END IF%>
				</tr>
			<%
			while not rs.eof
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strTotalFalta 	= 0
				
				strMedia		= "---"
				strResultadoFinal 		= ""
				if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
					strMedia = FORMATNUMBER(rs("MEDIA"),1)
					if cCur(strMedia) < cCur(intMediaAprovacao) then
						strResultadoFinal = "<font color='#FF0000'>RN</font>"
					else
						strResultadoFinal = "<font color='#0000FF'>AP</font>"
					end if
				end if

				IF RS("SITUACAO")="RN" THEN
					strResultadoFinal = "<font color='#FF0000'>RN</font>"
				ELSEIF RS("SITUACAO")="AP" THEN
					strResultadoFinal = "<font color='#0000FF'>AP</font>"
				END IF
				
					%>
				  <tr>
					<td align="left" class="celula"><%=strMatricula%></td>
					<td align="left" class="celula">&nbsp;<%=strNomeAluno%></td>
					<%	strTipoNotaAprentadaAnterior = ""
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
							if trim(strTipoNotaAprentadaAnterior) <> trim(right(vetTipoNota(I,1),1)) and strTipoNotaAprentadaAnterior <> "" and trim(right(vetTipoNota(I,1),1)) <> "6"  then
								%>
								<td width="5%" align="center" class="celula">&nbsp;<%=strFalta%>&nbsp;</td>
								<%
								strFalta = rs("FALTA" & strPos)
							end if
							%>
							<td width="5%" align="center" class="celula">&nbsp;<%=strNota%>&nbsp;</td>
							<%
							strTipoNotaAprentadaAnterior = right(vetTipoNota(I,1),1)
						NEXT %>					
					<td width="13%" align="center" class="celula">&nbsp;<%=strMedia%>&nbsp;</td>
					<td width="13%" align="center" class="celula"><%=strTotalFalta%>&nbsp;</td>
					<%if strMostraResultadoFinal = "S" then%>
					<td width="13%" align="center" class="celula">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
					<%end if%>
				  </tr>
					<%
				contQuebra = contQuebra + 1
				if contQuebra >= 40 then
					fimTabela
					%>
					<pre></pre>				
					<%	
					contQuebra = 0		
					mostraCabecalho
				end if			
				rs.movenext
			wend 
			%></table>
			<br>
			<!--#include file="../includes/inc_RepresentantesLegais.asp"-->
			<br>
		<%		
		end if
		rs.close
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