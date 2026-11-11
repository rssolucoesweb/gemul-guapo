<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
	<%
	Cod_aluno = request("Cod_aluno")
	cod_empresa = request("cod_empresa")
	cod_curso = request("cod_curso")
	cod_turma = request("cod_turma")
	
	sql = " SELECT SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.cod_Semestre, "
	sql = sql & " SCA_TURMA.cod_turma, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, "
	sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO, SCA_TURMA.AnoLetivo "
	sql = sql & " FROM SCA_ALUNO_DISCIPLINA  "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.Cod_Turma  "
	sql = sql & " AND SCA_TURMA.Cod_Empresa = SCA_ALUNO_DISCIPLINA.Cod_Empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = SCA_PERIODO.COD_CURSO "
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & cod_empresa
	sql = sql & " AND SCA_ALUNO_DISCIPLINA.Cod_aluno = " & Cod_aluno 
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		strAnoLetivo 			= rs("AnoLetivo")
		intSemestre				= rs("cod_Semestre")
		intCodCurso 			= rs("cod_curso")
		intCodTurma 			= rs("cod_turma")
		strDescricaoPeriodo  	= rs("PERIODO")
		strDescricaoCurso 	 	= rs("CURSO")
	else
		strAnoLetivo 			= 0
		intSemestre				= 0
		intCodCurso 			= 0
		intCodTurma 			= 0
		strDescricaoPeriodo  	= 0
		strDescricaoCurso 	 	= 0
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

	'carrega campos
	sql="select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & cod_curso
	sql=sql & " order by c.posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		strTipoCalculo 				= rs("TIPO_CALCULO")
		media_aprovacao 			= rs("media_aprovacao")
		media_aprovacao_final		= rs("media_aprovacao_final")
		intQtdeDisciplinaRecuperacao= rs("num_disciplina_recuperacao")
		intQtdeDisciplinaDependencia= rs("num_disciplina_prog_parcial")
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
	
	emitirNormal = "N"
	sql = "select codigo as cod_aluno, codigo from SCA_ALUNO"
	sql = sql & " where codigo in (" & Cod_aluno & ")"
	sql = sql & " and codigo not in ("
	sql = sql & " 				select cod_aluno from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO"
	sql = sql & " 				where cod_aluno in (" & Cod_aluno & ")"
	sql = sql & " 				and ano_letivo = " & strAnoLetivo
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

			sql = " SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, "
			sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.NOMETURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_NOTAS_FALTAS.MEDIA, "
			for i=0 to ubound(vetCampo,2)
				strPos = vetCampo(0,i)
				if cInt(strPos)<10 then strPos = "0" & strPos
				sql = sql & " 	SCA_NOTAS_FALTAS.NOTA"&strPos&", "
				sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
			next
			sql = sql & " SCA_DISCIPLINA.DESC_DISCIPLINA, SCA_TURNO.DESC_TURNO, SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,SCA_SITUACAOALUNO.DESC_SITUACAOALUNO,"
			sql = sql & " SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA,sca_turma.DesvincularCriterioAvaliacao,"
			sql = sql & " SCA_NOTAS_FALTAS.situacao, SCA_PERIODO.Descricao AS PERIODO, SCA_CURSO.Descricao AS CURSO, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual"
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.SITUACAO = 'A'"
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_TURMA.Cod_periodo"
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso"
			sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO "
			sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = SCA_ALUNO.COD_SITUACAOALUNO "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
			sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
			sql = sql & " LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
			sql = sql & " where SCA_TURMA.cod_empresa = " & cod_empresa
			sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & cod_turma
			sql = sql & " AND SCA_ALUNO.CODIGO = " &  cod_aluno
			sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO, SCA_DISCIPLINA.DESC_DISCIPLINA"
			rs.open sql, cnn
			if rs.eof = false then
				strNomeAluno 	 = rs("NOMEALUNO")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA")
				strDescricaoTurno= rs("DESC_TURNO")
				strDescricaoCurso= rs("CURSO")
				strDescricaoPeriodo= rs("PERIODO")
				strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")
				strSituacaoaluno = rs("DESC_SITUACAOALUNO")
				%>


					<!--Table hover-->
					<div id="panel-5" class="panel">
						<div class="panel-container show">
							<div class="panel-content">
								<div class="frame-wrap">
								
								<div class="table-responsive-lg">				
								
								<table border="0" cellspacing="0" cellpadding="0" align="left">
								  <tr>
									<td width="80px" >Aluno(a):</td>
									<td width="250px" >&nbsp;<strong><%=strNomeAluno%></strong></td>
									<td width="80px"  >Matr&iacute;cula:</td>
									<td >&nbsp;<strong><%=strMatricula%></strong></td>
								  </tr>
								  <tr>
								  </tr>
								  <tr>
									<td>Curso:</td>
									<td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
									<td>Per&iacute;odo:</td>
									<td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
								  </tr>
								  <tr>
									<td>Turno:</td>
									<td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
									<td></td>
									<td></td>
								  </tr>
								  <tr>
								  </tr>
								</table>
								<br>
								<table class="table table-bordered table-hover m-0">
										<thead class="thead-themed">
											<tr>
												<th>Disciplinas</th>

													<%
													for i=0 to ubound(vetCampo,2)
													%>
														<th><div align="center"><strong><%=replace(replace(replace(replace(replace(replace(vetCampo(1,i),"TRIMESTRE","TRIM"),"BIMESTRE","BIM"),"Média da Recuperação","MR"),"Conselho de Classe","CC"),"Média Final","MF"),"Recuperação","REC")%></strong></div></th>
														<% if left(vetCampo(1,i),1) = "1" or left(vetCampo(1,i),1) = "2" or left(vetCampo(1,i),1) = "3" or left(vetCampo(1,i),1) = "4" then%>
														<th><div align="center"><strong>Falta</strong></div></th>
														<% end if%>
													<%
													next
													%>
													<%if mostra_ch = "S" then%>
													<th><div align="center"><strong>Carga Horária</strong></div></th>
													<%end if%>
													<%if mostra_percentual_falta = "S" then%>
													<th><div align="center"><strong>% Faltas</strong></div></th>
													<%end if%>
													<%if mostra_resultado = "S" then%>
													<th><div align="center"><strong>Resultado</strong></div></th>
													<%end if%>
												  </tr>
											</thead>
													<%
													strQtdeDiscRep = 0
													strTotalFaltas = 0
													while not rs.eof	
														strDisciplina 	= rs("DESC_DISCIPLINA")
														strCHDisciplina	= rs("Ch_Anual")
														strOmitir_Criterio	= rs("Omitir_Criterio")
														strMedia		= "---"
														strResultadoFinal 		= ""
														
														if strOmitir_Criterio = "S" then
															strResultadoFinal = "<font color='#0000FF'>AP</font>"
														else
															if not isnull(rs("MEDIA")) and rs("MEDIA")<>"" then
																strMedia = FORMATNUMBER(rs("MEDIA"),1)
																
																if rs("situacao")="AP" then
																	strResultadoFinal = "<font color='#0000FF'>" & rs("situacao") & "</font>"
																elseif rs("situacao")="RN" then
																	strResultadoFinal = "<font color='#FF0000'>" & rs("situacao") & "</font>"
																else
																	strResultadoFinal = "---"
																end if

																if cCur(strMedia) < cCur(media_aprovacao_final) then
																	strQtdeDiscRep = strQtdeDiscRep + 1
																end if
															end if
														end if
															%>
															<td width="16%" align="left">&nbsp;<%=strDisciplina%></td>
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
																%>
																<td width="5%" align="center">&nbsp;<%=strNota%>&nbsp;</td>
																<% if left(vetCampo(1,i),1) = "1" or left(vetCampo(1,i),1) = "2" or left(vetCampo(1,i),1) = "3" or left(vetCampo(1,i),1) = "4" then%>
																<td width="5%" align="center">&nbsp;<%=strFalta%>&nbsp;</td>
																<% end if%>
																
																<%
															next
															
															if isnull(strCHDisciplina) then
																strPercFaltas = 0
															else
																if strTotalFaltas <> "" then
																	strPercFaltas = FORMATNUMBER((strTotalFaltas * 100)/strCHDisciplina,1)
																	if cCur(strPercFaltas) > cCur(frequencia_minima_percentual) then
																		strResultadoFinal = "<font color='#FF0000'>RF</font>"
																	end if
																end if
															end if
															
															%>
															<%if mostra_ch = "S" then%>
															<td width="5%" align="center">&nbsp;<%=strCHDisciplina%>&nbsp;</td>
															<%end if%>
															<%if mostra_percentual_falta = "S" then%>
															<td width="5%" align="center">&nbsp;<%=strPercFaltas%>&nbsp;</td>
															<%end if%>
															<%if mostra_resultado = "S" then%>
															<td width="5%" align="center">&nbsp;<%=strResultadoFinal%>&nbsp;</td>
															<%end if%>
														</tr>
														<%
														strTotalFaltas = 0
														rs.movenext
														
													wend
													%>
													</table>
													<%
												end if
												rs.close
											next
										end if%>



								</div>
								
							</div>
						</div>
					</div>
