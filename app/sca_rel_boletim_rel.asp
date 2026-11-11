<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Extrato de notas e faltas</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
</head>
<body>
<br>
<%
	dim intPagina
	strTipoPeriodo	 		= Trim(Request.Form("txtTipoPeriodo"))
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	strAnoLetivo				= intAnoLetivoAtual
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	strCodAluno					= Trim(Request("chkAluno"))
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intCodCurso					= Trim(Request.Form("cmbCurso"))
	intTotalRegistroPorPagina	= Trim(Request.Form("cmbTotalExtrato"))
	strclasse               	= Trim(Request.Form("cmbTamanhoFonteArial"))
	
	strCod_empresa				= session("codEmpresa")
	buscaHistorico = "N"
	msnHistorico = ""
	
	mostra_resultado			= Trim(Request.Form("mostra_resultado"))
	mostra_resultado_final			= Trim(Request.Form("mostra_resultado_final"))
	mostra_ch					= Trim(Request.Form("mostra_ch"))
	mostra_assinatura			= Trim(Request.Form("mostra_assinatura"))
	mostra_percentual_falta		= Trim(Request.Form("mostra_percentual_falta"))
	
	if trim(intSemestreAtual) = "3" then
	   if trim(intAnoLetivoAtual) <> trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if
	else
	   if trim(intAnoLetivoAtual) <> trim(session("strAnoLetivo"))  or trim(intSemestreAtual) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if	   
    end if
	
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	strTituloRelatorio  	= "Extrato de notas e faltas"
	
	'carrega campos
	sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " order by c.posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		strTipoCalculo 				= rs("TIPO_CALCULO")
		media_aprovacao 			= rs("media_aprovacao")
		media_aprovacao_final		= rs("media_aprovacao_final")
		intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
		intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
		if isnull(intQtdeDisciplinaDependencia) then intQtdeDisciplinaDependencia  = 0 
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		frequencia_minima_percentual= rs("frequencia_minima_percentual")
		
		vetCampo = rs.getRows
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.history.back();
		</script>
		<%
		response.end
	end if
	rs.close
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	strCodAluno			= Trim(Request("chkAluno"))
	
	emitirDiferenciado = "N"
	sql = "select cod_aluno, cod_aluno as codigo "
	sql = sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO"
	sql = sql & " inner join SCA_ALUNO ON SCA_ALUNO.CODIGO = SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO.COD_ALUNO"
	sql = sql & " where SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO.cod_aluno in (" & strCodAluno & ")"
	sql = sql & " and SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO.ano_letivo = " & intAnoLetivoAtual
	sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	vetAlunoCriterioDiferenciado = null
	rs.open sql, cnn
	if not rs.eof then
		vetAlunoCriterioDiferenciado = rs.getRows
		emitirDiferenciado = "S"
	end if
	rs.close
	
	emitirNormal = "N"
	sql = "select codigo as cod_aluno, codigo from SCA_ALUNO"
	sql = sql & " where codigo in (" & strCodAluno & ")"
	sql = sql & " and codigo not in ("
	sql = sql & " 				select cod_aluno from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO"
	sql = sql & " 				where cod_aluno in (" & strCodAluno & ")"
	sql = sql & " 				and ano_letivo = " & intAnoLetivoAtual
	sql = sql & ")"
	sql = sql & " order by NOMEALUNO"
	vetAluno = null
	rs.open sql, cnn
	if not rs.eof then
		vetAluno = rs.getRows
		emitirNormal = "S"
	end if
	rs.close
	
	if emitirNormal = "S" then
		contQuebra = 0
		for j=0 to ubound(vetAluno,2)
		
			intCodAluno  = vetAluno(0,j)		
			intPagina = 1
			mostraCabecalho


			if buscaHistorico = "S" then
				'HISTORICO ESCOLAR
				sql = " SELECT A.CODIGO, "
				sql = sql & " 	A.MATRICULA, "
				sql = sql & " 	A.NOMEALUNO, "
				sql = sql & " 	A.DATAMATRICULA, "					
				sql = sql & " 	A.DATAFASTAMENTO, "
				sql = sql & " 	HED.COD_TURMA, "
				sql = sql & " 	T.NOMETURMA, "
				sql = sql & " 	T.TURMAALUNO, "
				sql = sql & " 	G.Cod_Periodo, "
				'sql = sql & " 	HED.MEDIA, "
				sql = sql & " 	Isnull(HED.MEDIA,'0') AS MEDIA, "
				sql = sql & " 	(Isnull(HED.falta01,'0') + Isnull(HED.falta02,'0') + Isnull(HED.falta03,'0') + Isnull(HED.falta04,'0') + Isnull(HED.falta05,'0') + Isnull(HED.falta06,'0') + Isnull(HED.falta07,'0') + Isnull(HED.falta08,'0') + Isnull(HED.falta09,'0') + Isnull(HED.falta10,'0') + Isnull(HED.falta11,'0') + Isnull(HED.falta12,'0') + Isnull(HED.falta13,'0') + Isnull(HED.falta14,'0') + Isnull(HED.falta15,'0'))*100/ISNULL(HED.CARGA_HORARIA,'1') as percFaltas, "
				sql = sql & " 	HED.CARGA_HORARIA as CH_ANUAL,"
				sql = sql & " 	GCD.Omitir_Criterio, isnull(T.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao,"
				sql = sql & "   HED.situacao, PE.Descricao AS PERIODO, CU.Descricao AS CURSO, GCD.Ch_Anual,"
				for i=0 to ubound(vetCampo,2)
					strPos = vetCampo(0,i)
					if cInt(strPos)<10 then strPos = "0" & strPos
					sql = sql & " 	HED.NOTA"&strPos&", "
					sql = sql & " 	HED.FALTA"&strPos&", "
				next
				sql = sql & " 	D.DESC_DISCIPLINA,"
				sql = sql & " 	TU.DESC_TURNO,"
				sql = sql & " 	HED.CODIGO AS COD_NOTA, "
				sql = sql & " 	SA.DESC_SITUACAOALUNO, "
				sql = sql & " 	HED.SITUACAO, PE.TIPO, PE.COD_PERIODO"
					
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
				sql = sql & " LEFT JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO FE on FE.COD_ALUNO = HE.COD_ALUNO and FE.ano_letivo = HED.ANO_LETIVO and HED.COD_TURMA = FE.COD_TURMA "
				sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = FE.COD_SITUACAOALUNO_ATUAL "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.Ano_Letivo AND T.COD_SEMESTRE = HED.SEMESTRE AND T.cod_empresa = HE.cod_empresa "
				sql = sql & " INNER JOIN SCA_PERIODO PE ON PE.COD_PERIODO = T.COD_PERIODO"
				sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO = PE.COD_PERIODO"
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO "
				sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = HED.Cod_GradeCurricularDisciplina "					
				sql = sql & " WHERE HE.COD_EMPRESA = " & strCod_empresa
				'sql = sql & " AND HED.COD_TURMA = " & intCodTurma
				sql = sql & " AND A.CODIGO = " & vetAluno(0,j)
				sql = sql & " AND D.uso_historico='N'"
				sql = sql & " AND HED.ANO_LETIVO =  " & intAnoLetivoAtual
				sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
				sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA 	"	
				
			else

				sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, "
				sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.NOMETURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_NOTAS_FALTAS.MEDIA, "
				for i=0 to ubound(vetCampo,2)
					strPos = vetCampo(0,i)
					if cInt(strPos)<10 then strPos = "0" & strPos
					sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
					sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
				next
				sql = sql & " SCA_DISCIPLINA.DESC_DISCIPLINA, SCA_TURNO.DESC_TURNO, isnull(SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,'N') as Omitir_Criterio,SCA_SITUACAOALUNO.DESC_SITUACAOALUNO,"
				sql = sql & " SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA,isnull(sca_turma.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao,"
				sql = sql & " SCA_NOTAS_FALTAS.situacao, SCA_TURMA.TURMAALUNO, SCA_PERIODO.Descricao AS PERIODO, SCA_CURSO.Descricao AS CURSO, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, SCA_PERIODO.TIPO,SCA_PERIODO.COD_PERIODO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.SITUACAO in ('A','C','T')"
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_TURMA.Cod_periodo"
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso"
				sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = (select top 1 COD_SITUACAOALUNO from SCA_CONTROLE_SITUACAO_ALUNO where COD_ALUNO = SCA_ALUNO.CODIGO and ANO_LETIVO = SCA_TURMA.anoletivo and COD_EMPRESA = SCA_TURMA.cod_empresa order by codigo desc) "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
				sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
				sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
				sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " AND SCA_ALUNO.CODIGO = " &  intCodAluno
				sql = sql & " AND SCA_DISCIPLINA.uso_historico='N'"
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO, SCA_DISCIPLINA.DESC_DISCIPLINA"
			
			end if
			
			'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
			'	RESPONSE.WRITE sql
			'END IF
			
			rs.open sql, cnn
			if rs.eof = false then
				strTipoPeriodo 	 = rs("TIPO")
				intCodPeriodo	 = rs("cod_periodo")
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strTurma 	 	 = rs("TURMAALUNO")
				strDescricaoTurno= rs("DESC_TURNO")
				strDescricaoCurso= rs("CURSO")
				strDescricaoPeriodo= rs("PERIODO")
				strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")
				strSituacaoaluno = rs("DESC_SITUACAOALUNO")
				
				'BUSCA DO HISTORICO
				if TRIM(buscaHistorico) = "S" then
					sql = "select s.Desc_SituacaoAluno "
					sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO f"
					sql = sql & " inner join SCA_SITUACAOALUNO s on s.Cod_SituacaoAluno = f.COD_SITUACAOALUNO_ATUAL"
					sql = sql & " where f.COD_ALUNO=" & intCodAluno
					sql = sql & " and f.ANO_LETIVO = " & strAnoLetivo
					
					rsAux.open sql, cnn
					if rsAux.eof = false then
						strSituacaoaluno = rsAux("DESC_SITUACAOALUNO")
					end if
					rsAux.close
				end if
				%>
					
				<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td class="<%=strclasse%>_semlinha" width="10%">Aluno(a):</td>
					<td class="<%=strclasse%>_semlinha" width="50%">&nbsp;<strong><%=strNomeAluno%></strong></td>
					<td class="<%=strclasse%>_semlinha" width="10%">Matr&iacute;cula:</td>
					<td class="<%=strclasse%>_semlinha" width="30%">&nbsp;<strong><%=strMatricula%></strong></td>
				  </tr>
				  <tr>
					<td class="<%=strclasse%>_semlinha">Curso:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strDescricaoCurso%></strong></td>
					<td class="<%=strclasse%>_semlinha">Turma:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strTurma%>&nbsp;<%=strNomeTurma%></strong></td>
				  </tr>
				  <tr>
					<td class="<%=strclasse%>_semlinha">Per&iacute;odo:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					<td class="<%=strclasse%>_semlinha">Turno:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strDescricaoTurno%></strong></td>
				  </tr>
				</table>
				<br>
				<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <tr>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Disciplinas </strong></div></td>
					<%
					for i=0 to ubound(vetCampo,2)
					%>
						<td width="5%" class="<%=strclasse%>"><div align="center"><strong><%=vetCampo(1,i)%></strong></div></td>
						<% if (left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4") and strTipoPeriodo="D" then%>
						<td width="5%" class="<%=strclasse%>"><div align="center"><strong>Falta</strong></div></td>
						<% end if%>
					<%
					next
					%>
					<%if mostra_ch = "S" and strTipoPeriodo="D" then%>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Carga Horária</strong></div></td>
					<%end if%>
					<%if mostra_percentual_falta = "S" and strTipoPeriodo="D" then%>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>% Faltas</strong></div></td>
					<%end if%>
					<%if mostra_resultado = "S" and strTipoPeriodo="D" then%>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Resultado</strong></div></td>
					<%end if%>
				  </tr>
					<%
					strQtdeDiscRep = 0
					strQtdeDiscRepFalta = 0
					strTotalFaltas = 0
					while not rs.eof	
						strDisciplina 			= rs("DESC_DISCIPLINA")
						strCHDisciplina			= rs("Ch_Anual")
						strOmitir_Criterio		= rs("Omitir_Criterio")
						strMedia				= "---"
						strResultadoFinal 		= ""
							
							%>
							<td width="16%" align="left" class="<%=strclasse%>">&nbsp;<%=strDisciplina%></td>
							<%	
							
							for i=0 to ubound(vetCampo,2)
								strPos = vetCampo(0,i)
								if cInt(strPos)<10 then strPos = "0" & strPos
								
								strNota = "---"
								
								if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
									strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
								end if
								strFalta = ""
								if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
									strFalta = rs("FALTA" & strPos)
									strTotalFaltas = strTotalFaltas + strFalta
								end if
								
								if trim(strOmitir_Criterio) = "S" or trim(strDesvincularCriterioAvaliacao) = "S" then
									%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
									<% 
									if (left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4") and strTipoPeriodo="D" then
									%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
									<% 
									end if
								else
									if TRIM(strSituacaoaluno) <> "ATIVO" and TRIM(strSituacaoaluno) <> "TRANSFERIDO" then %>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
										<% 
										if (left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4") and strTipoPeriodo="D" then
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
										<% 
										end if
									else
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strNota%>&nbsp;</td>
										<% 
										if (left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4") and strTipoPeriodo="D" then
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strFalta%>&nbsp;</td>
										<% 
										end if
									end if
								end if
							next
							
							
							if trim(strOmitir_Criterio) = "S" or trim(strDesvincularCriterioAvaliacao) = "S" then
								strResultadoFinal = "<font color='#0000FF'>---</font>"
							else
								if not isnull(rs("MEDIA")) then
									strMedia = FORMATNUMBER(rs("MEDIA"),1)
									if trim(rs("situacao"))="AP" then
										strResultadoFinal = "<font color='#0000FF'>" & rs("situacao") & "</font>"
									elseif trim(rs("situacao"))="RN" then
										strResultadoFinal = "<font color='#FF0000'>" & rs("situacao") & "</font>"
									elseif trim(rs("situacao"))="RF" then
										strResultadoFinal = "<font color='#FF0000'>" & rs("situacao") & "</font>"
										strQtdeDiscRepFalta = strQtdeDiscRepFalta + 1
									else
										strResultadoFinal = "---"
									end if

									if cCur(strMedia) < cCur(media_aprovacao_final) then
										strQtdeDiscRep = strQtdeDiscRep + 1
									end if
								end if
							end if
							
							
							if isnull(strCHDisciplina) then
								strPercFaltas = 0
							else
								if trim(strOmitir_Criterio) = "S" or trim(strDesvincularCriterioAvaliacao) = "S" then
									strResultadoFinal = "<font color='#0000FF'>---</font>"
								else
									
									if trim(strTotalFaltas) <> "" then
										strPercFaltas = FORMATNUMBER((strTotalFaltas * 100)/strCHDisciplina,1)
										if cCur(strPercFaltas) > cCur(frequencia_minima_percentual) then
											strResultadoFinal = "<font color='#FF0000'>RF</font>"
											
											sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO where cod_aluno = " & intCodAluno
											sql = sql & " and cod_turma = " & intCodTurma
											rsAux1.open sql, cnn
											if not rsAux1.eof then
												strResultadoFinal = "<font color='#097a12'>AP</font>"
												strQtdeDiscRepFalta = 0
											end if
											rsAux1.close
										end if
									end if
									
									if strQtdeDiscRepFalta>0 then
										sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO where cod_aluno = " & intCodAluno
										sql = sql & " and cod_turma = " & intCodTurma
										rsAux1.open sql, cnn
										if not rsAux1.eof then
											strResultadoFinal = "<font color='#097a12'>AP</font>"
											strQtdeDiscRepFalta = 0
										end if
										rsAux1.close
									end if
								
								end if
							end if
							
							if TRIM(strSituacaoaluno) <> "ATIVO" and TRIM(strSituacaoaluno) <> "TRANSFERIDO"  then %>
							
								<%if mostra_ch = "S" and strTipoPeriodo="D"  then%>
								<td width="5%" align="center" class="<%=strclasse%>">---</td>
								<%end if%>
								<%if mostra_percentual_falta = "S" and strTipoPeriodo="D"  then%>
								<td width="5%" align="center" class="<%=strclasse%>">---</td>
								<%end if%>
								<%if mostra_resultado = "S" and strTipoPeriodo="D"  then%>
								<td width="5%" align="center" class="<%=strclasse%>">---</td>
								<%end if%>
								
							<%else%>
								
								<%if mostra_ch = "S" and strTipoPeriodo="D" then%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
								<%end if%>
								<%if mostra_percentual_falta = "S" and strTipoPeriodo="D" then%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strPercFaltas%>&nbsp;</td>
								<%end if%>
								<%if mostra_resultado = "S" and strTipoPeriodo="D" then%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
								<%end if%>
								
							<%end if%>
						</tr>
						<%
						strTotalFaltas = 0
						rs.movenext
						
					wend
					
					if TRIM(buscaHistorico) = "S" then
						if trim(strSituacaoaluno) <> "ATIVO" then 
							strResultadoFinal = strSituacaoaluno
						end if
					end if
					%>
					</table>
					
					<!--#include file="includes/inc_resultado_ch_frequencia_faltas.asp"-->	
					<!--#include file="includes/inc_MostraResultadoFinal.asp"-->
					<br>
					<%if mostra_assinatura = "S" then%>
					<!--#include file="includes/inc_RepresentantesLegaisExtratoNotas.asp"-->
					<%end if%>
					<br>
					<%
			end if
			rs.close
			contQuebra = contQuebra + 1
			if j <> ubound(vetAluno,2) and cInt(contQuebra) = cInt(intTotalRegistroPorPagina) then
				%>
				<pre>&nbsp;</pre>				
				<%	
				contQuebra = 0		
			end if
			
			
		next
	end if
	'para criterio diferenciado
	if emitirDiferenciado = "S" then

		contQuebra = 0
		for j=0 to ubound(vetAlunoCriterioDiferenciado,2)
		
			intCodAluno  = vetAlunoCriterioDiferenciado(0,j)		
			intPagina = 1
			mostraCabecalho
			
			'carrega campos
			sql="select ca.posicao, ca.descricao, ca.formula, ca.digitar, ca.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO  "
			sql=sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO ii"
			sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ii.cod_tipo_calculo"
			sql=sql & " inner join SCA_CALCULO ca on ca.cod_tipo_calculo = ii.cod_tipo_calculo"
			sql=sql & " where ii.ano_letivo = " & strAnoLetivo
			sql=sql & " and ii.cod_aluno = " & intCodAluno
			sql=sql & " order by ca.posicao"

			IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
				'RESPONSE.WRITE sql
			END IF

			vetCampo = null
			rs.open sql, cnn
			if not rs.eof then
				strTipoCalculo 				= rs("TIPO_CALCULO")
				vetCampo = rs.getRows
			end if
			rs.close

			if buscaHistorico = "S" then
				'HISTORICO ESCOLAR
				sql = " SELECT A.CODIGO, "
				sql = sql & " 	A.MATRICULA, "
				sql = sql & " 	A.NOMEALUNO, "
				sql = sql & " 	A.DATAMATRICULA, "					
				sql = sql & " 	A.DATAFASTAMENTO, "
				sql = sql & " 	HED.COD_TURMA, "
				sql = sql & " 	T.NOMETURMA, "
				sql = sql & " 	T.TURMAALUNO, "
				sql = sql & " 	G.Cod_Periodo, "
				'sql = sql & " 	HED.MEDIA, "
				sql = sql & " 	Isnull(HED.MEDIA,'0') AS MEDIA, "
				sql = sql & " 	(Isnull(HED.falta01,'0') + Isnull(HED.falta02,'0') + Isnull(HED.falta03,'0') + Isnull(HED.falta04,'0') + Isnull(HED.falta05,'0') + Isnull(HED.falta06,'0') + Isnull(HED.falta07,'0') + Isnull(HED.falta08,'0') + Isnull(HED.falta09,'0') + Isnull(HED.falta10,'0') + Isnull(HED.falta11,'0') + Isnull(HED.falta12,'0') + Isnull(HED.falta13,'0') + Isnull(HED.falta14,'0') + Isnull(HED.falta15,'0'))*100/ISNULL(HED.CARGA_HORARIA,'1') as percFaltas, "
				sql = sql & " 	HED.CARGA_HORARIA as CH_ANUAL,"
				sql = sql & " 	GCD.Omitir_Criterio, isnull(T.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao,"
				sql = sql & "   HED.situacao, PE.Descricao AS PERIODO, CU.Descricao AS CURSO, GCD.Ch_Anual,"
				for i=0 to ubound(vetCampo,2)
					strPos = vetCampo(0,i)
					if cInt(strPos)<10 then strPos = "0" & strPos
					sql = sql & " 	HED.NOTA"&strPos&", "
					sql = sql & " 	HED.FALTA"&strPos&", "
				next
				sql = sql & " 	D.DESC_DISCIPLINA,"
				sql = sql & " 	TU.DESC_TURNO,"
				sql = sql & " 	HED.CODIGO AS COD_NOTA, "
				sql = sql & " 	SA.DESC_SITUACAOALUNO, "
				sql = sql & " 	HED.SITUACAO"
					
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
				sql = sql & " LEFT JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO FE on FE.COD_ALUNO = HE.COD_ALUNO and FE.ano_letivo = HED.ANO_LETIVO and HED.COD_TURMA = FE.COD_TURMA "
				sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = FE.COD_SITUACAOALUNO_ATUAL "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = HED.COD_TURMA AND T.ANOLETIVO = HED.Ano_Letivo AND T.COD_SEMESTRE = HED.SEMESTRE AND T.cod_empresa = HE.cod_empresa "
				sql = sql & " INNER JOIN SCA_PERIODO PE ON PE.COD_PERIODO = T.COD_PERIODO"
				sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO = PE.COD_PERIODO"
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO "
				sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = HED.Cod_GradeCurricularDisciplina "					
				sql = sql & " WHERE HE.COD_EMPRESA = " & strCod_empresa
				'sql = sql & " AND HED.COD_TURMA = " & intCodTurma
				sql = sql & " AND A.CODIGO = " & vetAlunoCriterioDiferenciado(0,j)
				sql = sql & " AND HED.ANO_LETIVO =  " & intAnoLetivoAtual
				sql = sql & " AND HED.SEMESTRE = " & intSemestreAtual
				sql = sql & " AND SCA_DISCIPLINA.uso_historico='N'"
				sql = sql & " ORDER BY A.NOMEALUNO, D.DESC_DISCIPLINA 	"	
				
			else

				sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, "
				sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.NOMETURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_NOTAS_FALTAS.MEDIA, "
				for i=0 to ubound(vetCampo,2)
					strPos = vetCampo(0,i)
					if cInt(strPos)<10 then strPos = "0" & strPos
					sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
					sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
				next
				sql = sql & " SCA_DISCIPLINA.DESC_DISCIPLINA, SCA_TURNO.DESC_TURNO, isnull(SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,'N') as Omitir_Criterio,SCA_SITUACAOALUNO.DESC_SITUACAOALUNO,"
				sql = sql & " SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA,isnull(sca_turma.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao,"
				sql = sql & " SCA_NOTAS_FALTAS.situacao, SCA_TURMA.TURMAALUNO, SCA_PERIODO.Descricao AS PERIODO, SCA_CURSO.Descricao AS CURSO, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.SITUACAO = 'A'"
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_TURMA.Cod_periodo"
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso"
				sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = (select top 1 COD_SITUACAOALUNO from SCA_CONTROLE_SITUACAO_ALUNO where COD_ALUNO = SCA_ALUNO.CODIGO and ANO_LETIVO = SCA_TURMA.anoletivo and COD_EMPRESA = SCA_TURMA.cod_empresa order by codigo desc) "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
				sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
				sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
				sql = sql & " where SCA_TURMA.cod_empresa = " & strCod_empresa
				sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " AND SCA_ALUNO.CODIGO = " &  intCodAluno
				sql = sql & " AND SCA_DISCIPLINA.uso_historico='N'"
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO, SCA_DISCIPLINA.DESC_DISCIPLINA"
			
			end if
			
			'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
			'	RESPONSE.WRITE sql
			'END IF
			
			rs.open sql, cnn
			if rs.eof = false then
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strTurma 	 	 = rs("TURMAALUNO")
				strDescricaoTurno= rs("DESC_TURNO")
				strDescricaoCurso= rs("CURSO")
				strDescricaoPeriodo= rs("PERIODO")
				strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")
				strSituacaoaluno = rs("DESC_SITUACAOALUNO")
				
				'BUSCA DO HISTORICO
				if TRIM(buscaHistorico) = "S" then
					sql = "select s.Desc_SituacaoAluno "
					sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO f"
					sql = sql & " inner join SCA_SITUACAOALUNO s on s.Cod_SituacaoAluno = f.COD_SITUACAOALUNO_ATUAL"
					sql = sql & " where f.COD_ALUNO=" & intCodAluno
					sql = sql & " and f.ANO_LETIVO = " & strAnoLetivo
					
					rsAux.open sql, cnn
					if rsAux.eof = false then
						strSituacaoaluno = rsAux("DESC_SITUACAOALUNO")
					end if
					rsAux.close
				end if
				%>
					
				<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td class="<%=strclasse%>_semlinha" width="10%">Aluno(a):</td>
					<td class="<%=strclasse%>_semlinha" width="50%">&nbsp;<strong><%=strNomeAluno%></strong></td>
					<td class="<%=strclasse%>_semlinha" width="10%">Matr&iacute;cula:</td>
					<td class="<%=strclasse%>_semlinha" width="30%">&nbsp;<strong><%=strMatricula%></strong></td>
				  </tr>
				  <tr>
					<td class="<%=strclasse%>_semlinha">Curso:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strDescricaoCurso%></strong></td>
					<td class="<%=strclasse%>_semlinha">Turma:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strTurma%>&nbsp;<%=strNomeTurma%></strong></td>
				  </tr>
				  <tr>
					<td class="<%=strclasse%>_semlinha">Per&iacute;odo:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					<td class="<%=strclasse%>_semlinha">Turno:</td>
					<td class="<%=strclasse%>_semlinha">&nbsp;<strong><%=strDescricaoTurno%></strong></td>
				  </tr>
				</table>
				<br>
				<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <tr>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Disciplinas </strong></div></td>
					<%
					for i=0 to ubound(vetCampo,2)
					%>
						<td width="5%" class="<%=strclasse%>"><div align="center"><strong><%=vetCampo(1,i)%></strong></div></td>
						<% if left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4" then%>
						<td width="5%" class="<%=strclasse%>"><div align="center"><strong>Falta</strong></div></td>
						<% end if%>
					<%
					next
					%>
					<%if mostra_ch = "S" then%>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Carga Horária</strong></div></td>
					<%end if%>
					<%if mostra_percentual_falta = "S" then%>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>% Faltas</strong></div></td>
					<%end if%>
					<%if mostra_resultado = "S" then%>
					<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Resultado</strong></div></td>
					<%end if%>
				  </tr>
					<%
					strQtdeDiscRep = 0
					strTotalFaltas = 0
					while not rs.eof	
						strDisciplina 			= rs("DESC_DISCIPLINA")
						strCHDisciplina			= rs("Ch_Anual")
						strOmitir_Criterio		= rs("Omitir_Criterio")
						strMedia				= "---"
						strResultadoFinal 		= ""
							
							%>
							<td width="16%" align="left" class="<%=strclasse%>">&nbsp;<%=strDisciplina%></td>
							<%	
							
							for i=0 to ubound(vetCampo,2)
								strPos = vetCampo(0,i)
								if cInt(strPos)<10 then strPos = "0" & strPos
								
								strNota = "---"
								
								if not isnull(rs("NOTA" & strPos)) and rs("NOTA" &strPos)<>"" then
									strNota = FORMATNUMBER(rs("NOTA" & strPos),1)
								end if
								strFalta = ""
								if not isnull(rs("FALTA" & strPos)) and rs("FALTA" &strPos)<>"" then
									strFalta = rs("FALTA" & strPos)
									strTotalFaltas = strTotalFaltas + strFalta
								end if
								
								if trim(strOmitir_Criterio) = "S" or trim(strDesvincularCriterioAvaliacao) = "S" then
									%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
									<% 
									if left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4" then
									%>
									<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
									<% 
									end if
								else
									if TRIM(strSituacaoaluno) <> "ATIVO" then %>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
										<% 
										if left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4" then
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;---&nbsp;</td>
										<% 
										end if
									else
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strNota%>&nbsp;</td>
										<% 
										if left(vetCampo(4,i),1) = "1" or left(vetCampo(4,i),1) = "2" or left(vetCampo(4,i),1) = "3" or left(vetCampo(4,i),1) = "4" then
										%>
										<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strFalta%>&nbsp;</td>
										<% 
										end if
									end if
								end if
							next
							
							
							if trim(strOmitir_Criterio) = "S" or trim(strDesvincularCriterioAvaliacao) = "S" then
								strResultadoFinal = "<font color='#0000FF'>---</font>"
							else
								if not isnull(rs("MEDIA")) then
									strMedia = FORMATNUMBER(rs("MEDIA"),1)
									if trim(rs("situacao"))="AP" then
										strResultadoFinal = "<font color='#0000FF'>" & rs("situacao") & "</font>"
									elseif trim(rs("situacao"))="RN" then
										strResultadoFinal = "<font color='#FF0000'>" & rs("situacao") & "</font>"
									elseif trim(rs("situacao"))="RF" then
										strResultadoFinal = "<font color='#FF0000'>" & rs("situacao") & "</font>"
										strQtdeDiscRepFalta = strQtdeDiscRepFalta + 1
									else
										strResultadoFinal = "---"
									end if

									if cCur(strMedia) < cCur(media_aprovacao_final) then
										strQtdeDiscRep = strQtdeDiscRep + 1
									end if
								end if
							end if
							
							
							if isnull(strCHDisciplina) then
								strPercFaltas = 0
							else
								if trim(strOmitir_Criterio) = "S" or trim(strDesvincularCriterioAvaliacao) = "S" then
									strResultadoFinal = "<font color='#0000FF'>---</font>"
								else
									if trim(strTotalFaltas) <> "" then
										strPercFaltas = FORMATNUMBER((strTotalFaltas * 100)/strCHDisciplina,1)
										if cCur(strPercFaltas) > cCur(frequencia_minima_percentual) then
											strResultadoFinal = "<font color='#FF0000'>RF</font>"
											
											sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO where cod_aluno = " & intCodAluno
											sql = sql & " and cod_turma = " & intCodTurma
											rsAux1.open sql, cnn
											if not rsAux1.eof then
												strResultadoFinal = "<font color='#097a12'>AP</font>"
												strQtdeDiscRepFalta = 0
											end if
											rsAux1.close
											
											
										end if
										
										
										if strQtdeDiscRepFalta>0 then
											sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO where cod_aluno = " & intCodAluno
											sql = sql & " and cod_turma = " & intCodTurma
											rsAux1.open sql, cnn
											if not rsAux1.eof then
												strResultadoFinal = "<font color='#097a12'>AP</font>"
												strQtdeDiscRepFalta = 0
											end if
											rsAux1.close
										end if
									end if
								end if
							end if
							
							if TRIM(strSituacaoaluno) <> "ATIVO" then %>
							
								<%if mostra_ch = "S" then%>
								<td width="5%" align="center" class="<%=strclasse%>">---</td>
								<%end if%>
								<%if mostra_percentual_falta = "S" then%>
								<td width="5%" align="center" class="<%=strclasse%>">---</td>
								<%end if%>
								<%if mostra_resultado = "S" then%>
								<td width="5%" align="center" class="<%=strclasse%>">---</td>
								<%end if%>
								
							<%else%>
								
								<%if mostra_ch = "S" then%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
								<%end if%>
								<%if mostra_percentual_falta = "S" then%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strPercFaltas%>&nbsp;</td>
								<%end if%>
								<%if mostra_resultado = "S" then%>
								<td width="5%" align="center" class="<%=strclasse%>">&nbsp;<%=strResultadoFinal%>.&nbsp;</td>
								<%end if%>
								
							<%end if%>
						</tr>
						<%
						strTotalFaltas = 0
						rs.movenext
						
					wend
					
					if TRIM(buscaHistorico) = "S" then
						if trim(strSituacaoaluno) <> "ATIVO" then 
							strResultadoFinal = strSituacaoaluno
						end if
					end if
					%>
					</table>
					<!--#include file="includes/inc_MostraResultadoFinal.asp"-->
					<br>
					<%if mostra_assinatura = "S" then%>
					<!--#include file="includes/inc_RepresentantesLegaisExtratoNotas.asp"-->
					<%end if%>
					<br>
					<%
			end if
			rs.close
			contQuebra = contQuebra + 1
			if j <> ubound(vetAlunoCriterioDiferenciado,2) and cInt(contQuebra) = cInt(intTotalRegistroPorPagina) then
				%>
				<pre>&nbsp;</pre>				
				<%	
				contQuebra = 0		
			end if
			
			
		next
	end if
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
