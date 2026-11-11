<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strAnoLetivo 			= request("txtAnoLetivo")
	intSemestre 			= Trim(Request("cmbSemestre"))

	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodTurno		 		= Trim(Request("cmbTurno"))

	buscaHistorico = "N"
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) < trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
	   end if	   
    end if

    if intSemestre = "3" then 
		msgTitulo = "<br>Período Letivo: " & strAnoLetivo
	else
		msgTitulo = "<br>Período Letivo: " & strAnoLetivo & "/" & intSemestre
	end if 
	strTituloRelatorio  	= "ATA DE RESULTADO FINAIS " & msgTitulo


	sql="SELECT frequencia_minima_percentual,qtd_aula "
	sql=sql & " FROM SCA_CRITERIO_AVALIACAO"
	sql=sql & " WHERE	COD_CURSO = " & intCodCurso
	rsAux1.open sql, cnn
	if not rsAux1.eof then
		intFrequenciaMinimaPerc = rsAux1("frequencia_minima_percentual")
		intDiasLetivo = rsAux1("qtd_aula")
		rsAux1.close
	else
		rsAux1.close
		%>
			<script>
					var men = 'ATENÇÃO: \nNão foi encontrado critério de avaliação. Deseja cadastrar o critério desse curso?';
					if (confirm(men)) {
						window.location="sca_criterio_avaliacao.asp";
					} else {
						window.history.back();
					}
			</script>
		<%
		response.end
	end if	


sub mostraCabecalho()
	%>
	<table class="table table-bordered table-hover m-0">
	<thead class="thead-themed">
        <% 
		if marca = 1 then 
			marca = 0
			%>
			<tr>
				<th height="29" colspan="<%=7 + colunaComplemento%>" class="celula"><strong>Turma:&nbsp;<%=rs("NomeTurma")%>&nbsp;<%=rs("TurmaAluno")%>&nbsp;-&nbsp;Curso:&nbsp;<%=rs("Curso")%> </strong></td>
			</tr>
			<% 
		end if 
		%>
	  	<tr>
			<th align="center"><input type="checkbox" name="chkTodos" class="form-control campo_chk" onClick="return marcaTodosAlunos(this.checked)"></td>
            <th><div align="center"><strong>Ordem</strong></div></td>
            <th><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <th><strong>&nbsp;&nbsp;Nome do Aluno</strong></td>
            <th><div align="left"><strong>Sit. Acad&ecirc;mica</strong></div></td>
			<th><strong>FALTAS</strong></td>
			<th><strong>RESULTADO</strong></td>
	  </tr>
	</thead>
	<tbody>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_rel_ata_resultadoCon.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	<%
	cont =0
	
	intPagina = 1
	IntOrd = 1
	mostraBotaoAprovar = ""
	
	
	sql = sqlAlunoTurma(intCodTurma, "")
	IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
		'response.write sql
		'response.end
		
		'sql = "SELECT distinct SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma, SCA_TURMA.TURMAALUNO, isnull(( select top 1 ss.Desc_SituacaoAluno from SCA_CONTROLE_SITUACAO_ALUNO CS inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO order by cs.codigo desc ),'ATIVO') as Desc_SituacaoAluno, isnull(( select top 1 ss.COD_SituacaoAluno from SCA_CONTROLE_SITUACAO_ALUNO CS inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO order by cs.codigo desc ),'1') as COD_SITUACAOALUNOATUAL, SCA_TURMA.Cod_FichaDescritiva, ( select codigo from SCA_ALUNO where CODIGO=SCA_ALUNO_TURMA.COD_ALUNO and ( NOMEALUNO is null or DATANASCIMENTO is null or DATAMATRICULA is null or SEXOALUNO is null or CIDADENASCIMENTO is null or UFNASCIMENTO is null or NACIONALIDADE is null or COD_TIPONACIONALIDADE is null or COD_PROFISSAO is null or COD_ETNIA is null or MAE is null ) ) as pendencias,TC.DESCRICAO AS TIPO_CRITERIO, C.DESCRICAO AS CURSO, P.Cod_Curso, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.DesvincularCriterioAvaliacao FROM SCA_ALUNO INNER JOIN SCA_ALUNO_TURMA ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO LEFT JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular LEFT JOIN SCA_GRADECURRICULAR G ON SCA_TURMA.Cod_GradeCurricular = G.Cod_GradeCurricular LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO AND TAI.ANO_LETIVO = SCA_TURMA.ANOLETIVO LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_CALCULO where SCA_ALUNO_TURMA.cod_aluno in (5378,372) and SCA_ALUNO_TURMA.cod_empresa = 1 and SCA_ALUNO_TURMA.COD_TURMA = 1639 and SCA_ALUNO_TURMA.ANO_LETIVO = 2024 and SCA_ALUNO_TURMA.SITUACAO in ('A','T','D','C') and SCA_TURMA.situacao = 'A' order by SCA_ALUNO.NOMEALUNO"
	END IF
	
	rs.open sql, cnn
	if not rs.eof then 
		
		strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")

		marca = 1
		
		'
		sql = " SELECT D.Cod_Disciplina, D.Desc_Abreviada, D.DESC_Disciplina "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
		SQL = SQL & " WHERE GCD.COD_GRADECURRICULAR = " & TRIM(rs("Cod_GradeCurricular"))
		sql = sql & " and D.situacao = 'A'"
		sql = sql & " Order by D.Cod_Disciplina "
		rsAux1.open sql, cnn, 3, 3
		if not rsAux1.eof then
			vetAux1 = rsAux1.getRows
			if isArray(vetAux1) then
				colunaComplemento = ubound(vetAux1,2)
			else
				colunaComplemento = 0
			end if
		else
			%>
			<script>
				alert("Atenção! Matriz curricular n. <%=TRIM(rs("Cod_GradeCurricular"))%> não cadastrada. Verifique!");
				window.location="Rel_NotasDisciplinaResumo_con.asp";
			</script>
			<%
			response.end
		end if
		rsAux1.close

		
	%>
	<div class="row">
		<div class="col-xl-8">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Selecione alunos clicando no checkbox abaixo.</span>
						</div>
						<div class="table-responsive-lg">
						  <%
						mostraCabecalho
						While not rs.eof
							cont = cont + 1
							Media = "0"
							Situacao = "----"
							SituacaoFinal = "<font color='#FF0000'>----</fonte>"
							mostrarMarcacao = "N"	
							
							sql = "SET NoCount ON "
							
							sql = sql & " IF OBJECT_ID('tempdb..#faltas') IS NOT NULL DROP TABLE #faltas"
							sql = sql & " select cod_aluno, ano_letivo, cod_periodo, data, 1 as falta "
							sql = sql & " into #faltas"
							sql = sql & " from [dbo].[SCA_FALTAS_DIARIA]"
							sql = sql & " where cod_aluno = " & TRIM(rs("CODIGO"))
							sql = sql & " and ano_letivo = " & strAnoLetivo
							sql = sql & " and semestre = " & intSemestre
							sql = sql & " group by cod_aluno, ano_letivo, cod_periodo, data"
							
							sql = sql & " IF OBJECT_ID('tempdb..#total_faltas') IS NOT NULL DROP TABLE #total_faltas"
							sql = sql & " select cod_aluno, ano_letivo, cod_periodo, sum(falta) as faltas"
							sql = sql & " into #total_faltas"
							sql = sql & " from #faltas"
							sql = sql & " where ano_letivo = " & strAnoLetivo
							sql = sql & " group by cod_aluno, ano_letivo, cod_periodo"
							
							if buscaHistorico = "N" then
								sql = sql & " SELECT replace(FORMAT( NF.MEDIA, '##.0' ),'.',',') as MEDIA, "
								sql = sql & " f.faltas, "
								sql = sql & " NF.Cod_Disciplina, "
								sql = sql & " D.DESC_Disciplina, "
								sql = sql & " NF.Situacao "
								sql = sql & " FROM SCA_NOTAS_FALTAS NF "
								sql = sql & " left JOIN #total_faltas f on f.cod_aluno = nf.cod_aluno and f.ano_letivo = nf.ano_letivo and f.cod_periodo = nf.cod_periodo"
								sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = NF.COD_Disciplina "
								sql = sql & " WHERE NF.COD_ALUNO = " & TRIM(rs("CODIGO"))
								sql = sql & " AND NF.ANO_LETIVO = " & strAnoLetivo
								sql = sql & " AND NF.SEMESTRE = " & intSemestre
								sql = sql & " and D.situacao = 'A'"
								sql = sql & " Order by D.Cod_Disciplina"
							else
								sql = sql & " SELECT replace(FORMAT( HED.MEDIA, '##.0' ),'.',',') as MEDIA, " 
								sql = sql & " f.faltas, "  
								sql = sql & " HED.Cod_Disciplina, "  
								sql = sql & " D.DESC_Disciplina, "  
								sql = sql & " HED.Situacao " 
								sql = sql & " FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA HED " 
								sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.codigo = HED.cod_historico_escolar "  
								sql = sql & " left JOIN #total_faltas f on f.cod_aluno = HE.cod_aluno and f.ano_letivo = HED.ano_letivo and f.cod_periodo = HED.cod_periodo"
								sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HED.COD_Disciplina "  
								sql = sql & " WHERE HE.COD_ALUNO = " & TRIM(rs("CODIGO")) 
								sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo 
								sql = sql & " AND HED.SEMESTRE = " & intSemestre 
								sql = sql & " and D.situacao = 'A'"	
								sql = sql & " Order by D.Cod_Disciplina "
							end if

							rsAux1.open sql, cnn, 3, 3
							if not rsAux1.eof then
								vetAux2 = rsAux1.getRows
							else
								vetAux2 = "0"
							end if
							rsAux1.close
							
							'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" and TRIM(rs("CODIGO"))="372" THEN
							'	response.write sql
							'	response.end
							'END IF
							strSituacaoAluno = ""
							if trim(rs("DESC_SITUACAOALUNO")) = "ATIVO" then
								strSituacaoAluno = ""
							else
								strSituacaoAluno = trim(rs("DESC_SITUACAOALUNO"))
							end if
							
							if strSituacaoAluno="" then
								strDisciplinaEncontrada = "N"
								if isArray(vetAux1) then
									
									Faltas = 0
									SituacaoFinalRF = ""
									SituacaoFinalNT = "AP"
									for j=0 to ubound(vetAux1,2)
									
										strExisteDisciplina = "N"

										if TRIM(strDesvincularCriterioAvaliacao) = "S" then
										else
					
											'verifica se existe falta
											if isArray(vetAux2) then
												k = 0
												Media = "0"
												Situacao = "----"
												do while k <= ubound(vetAux2,2)
												
													Faltas = vetAux2(1,k)
													if Faltas = "" or isnull(Faltas) then Faltas = 0
													
													if buscaHistorico = "N" then
														if vetAux1(0,j) = vetAux2(2,k) then
															strExisteDisciplina = "S"
															Media = vetAux2(0,k)
															Situacao = vetAux2(4,k)

									
															if vetAux2(4,k) <> "AP" then
																SituacaoFinalNT = "<font color='#FF0000'>" & Situacao & "</fonte>"
																mostrarMarcacao = "S"
															end if
															if Media = ",0" then Media = " "
															exit do
														end if
													else
														if vetAux1(0,j) = vetAux2(2,k) then
															strExisteDisciplina = "S"
															Media = vetAux2(0,k)
															Situacao = vetAux2(4,k)
															SituacaoFinalNT = Situacao  
															exit do
														end if
													end if
													
													k = k + 1
													
												loop
												if strExisteDisciplina = "N" then
												end if
												
											else
											end if
										end if
										if strExisteDisciplina = "S" then
											strDisciplinaEncontrada = "S"
										end if
										
									next

								end if
								mostraCheck = ""

									'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
									'	response.write rs("CODIGO") & " - Situacao: " & Situacao & "<br>"
									'	'response.end
									'END IF


								
								if buscaHistorico = "N" then
									sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO where cod_aluno = " & TRIM(rs("CODIGO")) 
									sql = sql & " and cod_turma = " & intCodTurma
									rsAux1.open sql, cnn
									if not rsAux1.eof then
										bolAprovadoConselho = "S"
									else
										bolAprovadoConselho = "N"
									end if
									rsAux1.close
									
								
									SituacaoFinal = SituacaoFinalNT
									
									'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
									'	response.write rs("CODIGO") & " - " & SituacaoFinal & "<br>"
									'	'response.end
									'END IF
									
									strPercFaltas = (Faltas * 100)/cInt(intDiasLetivo)
									if clng(strPercFaltas) > cInt(intFrequenciaMinimaPerc) then 
										SituacaoFinalRF = "<font color='#FF0000'>RF</font>"
										mostraCheck = "S"
										mostraBotaoAprovar = "S"
										mostrarMarcacao = "S"
									end if 
									
									if SituacaoFinalRF <> "" then 
										SituacaoFinal = SituacaoFinalRF
									end if
									if strSituacaoAluno <> "" then 
										SituacaoFinal = "<font color='#FF0000'>----</fonte>"
										mostrarMarcacao = "N"
									end if
					
									if TRIM(strDesvincularCriterioAvaliacao) = "S" then
										if trim(rs("DESC_SITUACAOALUNO")) = "ATIVO" then
											SituacaoFinal = "<font color='#0000FF'>AP</fonte>"
										else
											SituacaoFinal = "<font color='#FF0000'>----</fonte>"
										end if
									end if
									
								else
									SituacaoFinal = SituacaoFinalNT
					
									if TRIM(strDesvincularCriterioAvaliacao) = "S" then
										if trim(rs("DESC_SITUACAOALUNO")) = "ATIVO" then
											SituacaoFinal = "<font color='#0000FF'>AP</fonte>"
										else
											SituacaoFinal = "<font color='#FF0000'>----</fonte>"
										end if
									end if
									if strSituacaoAluno <> "" then SituacaoFinal = "<font color='#FF0000'>----</fonte>"
								end if
								if strDisciplinaEncontrada = "N" then
									SituacaoFinal = "<font color='#FF0000'>----</fonte>"
								end if  
								
							else
								SituacaoFinal = "<font color='#FFF'>----</fonte>"
								Faltas = "---"
								
							end if
									'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
									'	response.write rs("CODIGO") & " - Situacaoooo: " & Situacao & "<br>"
									'	'response.end
									'END IF							
							
							%>
							<tr>
							<td align="center" class="celula">
							
							<%if trim(mostrarMarcacao) = "S" then%>
								<input <%if bolAprovadoConselho = "S" then%>checked<%end if%> type="checkbox" id="chkAluno" class="form-control campo_chk" name="chkAluno" value="<%=rs("codigo")%>">
							<%end if%>
								
								</td>
							<td class="celula" align="left"><div align="center"><%=IntOrd%>&nbsp;</div></td>
							<td class="celula" align="left"><div align="center"><%=rs("MATRICULA")%></div></td>
							<td align="left" class="celula">&nbsp;&nbsp;<%=rs("NOMEALUNO")%></td>
							<td align="left" class="celula">&nbsp;&nbsp;<%=strSituacaoAluno%></td>
							<td align="center" class="celula"><strong><%=Faltas%></strong></td>
							<td align="center" class="celula"><strong><%if bolAprovadoConselho = "S" then%>AP<%else%><%=SituacaoFinal%><%end if%></strong></td>
							
							</tr>
							<%
							'quantidade de registros da página
							if intQtdeRegistroPorPagina = 2555 then
								 intPagina = intPagina + 1
								 intQtdeRegistroPorPagina = 1
								 fimTabela
								marca = 1
								mostraCabecalho
							end if	
							intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
							IntOrd = IntOrd + 1
							VchaveTurma = trim(rs("COD_TURMA"))
							
							rs.movenext
							if not rs.eof then
								if VchaveTurma <> trim(rs("COD_TURMA")) then
									marca = 1
								end if
							else				
								marca = 0
							end if

							if marca = 1 then
								 IntOrd = 1
								 intPagina = intPagina + 1
								 intQtdeRegistroPorPagina = 1
								 fimTabela
								mostraCabecalho
							end if		
								
							
						wend
							%>
									<tr>
										<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						
						
						<br>
						<div class="frame-wrap">
							<button onClick="return voltarAta()"  type="button" class="btn btn-outline-warning"> Voltar para Relatório</button>
							<button onClick="return aprovarPeloConselho()"  type="button" class="btn btn-success">    Salvar   </button>
						</div>
						<br>
						
					</div>
				</div>
			</div>
		</div>
	</div> 
	<%
	end if
	rs.close
	  
	%>		
	<input name="cmbCurso" type="hidden" value="<%=intCodCurso%>">	
	<input name="cmbPeriodo" type="hidden" value="<%=intCodPeriodo%>">	
	<input name="cmbTurma" type="hidden" value="<%=intCodTurma%>">	
	<input name="cmbTurno" type="hidden" value="<%=intCodTurno%>">	
	<input name="cmbSemestre" type="hidden" value="<%=intSemestre%>">	
</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>