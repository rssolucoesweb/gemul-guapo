<!--#include file="includes/inc_aguarde.asp"-->
<%

	acao = "I"

	strAnoLetivo			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo="" then strAnoLetivo = Trim(Request.Form("txtHiddenAnoLetivo"))

	strSemestre             = Trim(Request("txtSemestre"))

	intCodTurno				= Trim(Request("txtCodTurno"))
	strTurno				= Trim(Request("txtTurno"))

	intCodProfessor	        = Trim(Request("txtCodProfessor"))
	strProfessor	        = Trim(Request("txtProfessor"))
	strMes	        = Trim(Request("cmbMes"))
	if strMes="" or strMes = "0" then strMes = month(date)

	strTemAcessoValidacao = "N"
	SQL = "SELECT ACES_PERF_CODG"
	SQL = SQL & " FROM SEG_ACESSOS_USUARIO"
	SQL = SQL & " WHERE ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	SQL = SQL & " AND ACES_PERF_CODG in (2,17)"
	'response.write sql
	rs.open sql, cnn
	if not rs.EOF then	
		'perfil professor não terá acesso a validação
		strTemAcessoValidacao = ""
	end if
	rs.close

	set rsAux2 = server.createObject("adodb.recordset")

	strNumAulaTurma = ""
	
	function buscaAulasExtrasTurma(cod_disciplina, Cod_Turma, strAnoLetivo, intCodTurno, codCursoAux, cursoAux, codPeriodoAux, periodoAux, codDisciplinaAux, disciplinaAux, turmaAux, semestre)

		existeAulaExtra= false
		
		sql = "select distinct H.DataLancamento, H.sequencia from SCA_HORARIO_AULA_EXTRA H"
		sql = sql & " inner join SCA_TURMA T ON T.Cod_Turma = H.Cod_turma AND T.Cod_Semestre=H.semestre"
		sql = sql & " inner join SCA_HORARIO HA ON HA.codigo = H.Cod_Horario"
		sql = sql & " where month(H.DataLancamento)=" & strMes
		sql = sql & " and H.Cod_Turma = " & Cod_Turma 
		sql = sql & " and H.Cod_Disciplina = " & cod_disciplina 
		sql = sql & " and H.Cod_Empresa = " & session("CodEmpresa")
		sql = sql & " and H.AnoLetivo = " & strAnoLetivo 
		sql = sql & " and HA.CodTurno = " & intCodTurno 
		if session("usuarioWeb") = "SERGIO" THEN
			'RESPONSE.WRITE SQL & "<BR>" & intCodTurno & "<hr>"
		end if
		rsAux.open sql, cnn
		if rsAux.eof = false then
			existeAulaExtra = true
			vetAulaExtra = rsAux.getRows()
		end if
		rsAux.close

		if existeAulaExtra then
			
			for contAulaExtra=0 to UBound(vetAulaExtra,2)
				dataAulaExtra = vetAulaExtra(0,contAulaExtra)
				sequenciaExtra = vetAulaExtra(1,contAulaExtra)

				estilo_cor_aux = "amarelo"
				codigoPlanejamentoProfAux = 0

				'Seleciona as Aulas Extras
				sql = "select p.data_aula_extra, p.cod_planejamento_professor, p.validado, p.observacao, (select COUNT(*) from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_planejamento_professor = p.cod_planejamento_professor) as qtde_conteudo_ministrado"
				sql = sql & " from SCA_PLANEJAMENTO_PROFESSOR p"
				'sql = sql & " left join SCA_CONTEUDO_MINISTRADO_PROFESSOR m on m.cod_planejamento_professor = p.cod_planejamento_professor "
				sql = sql & " where p.numero_aula is null"
				sql = sql & " and p.cod_disciplina = " & cod_disciplina
				sql = sql & " and p.cod_turma = " & Cod_Turma
				sql = sql & " and p.anoLetivo = " & strAnoLetivo
				sql = sql & " and p.semestre = " & semestre
				sql = sql & " and p.cod_turno = " & intCodTurno	
				sql = sql & " and p.cod_empresa = " & session("CodEmpresa")
				sql = sql & " and p.data_aula_extra='" & formataDataBD(dataAulaExtra) & "'"
				'if session("usuarioWeb") = "SERGIO" THEN
				'	RESPONSE.WRITE SQL & "<hr>"
				'end if										
				rsAux.open sql, cnn,3,3
				qtde_aux_verifica_erro = 0
				if rsAux.eof = false then
					'------| Data da Aula Extra
					dataAulaExtra = rsAux("data_aula_extra")
					'-------|
					if rsAux("qtde_conteudo_ministrado")=0 then
						if rsAux("validado") = "N" then
							estilo_cor_aux = "vermelho"
						elseif rsAux("validado") = "S" then
							estilo_cor_aux = "verde"
							if not isnull(rsAux("observacao")) then
								estilo_cor_aux = "azul"
							end if
						end if
					else
						estilo_cor_aux = "laranja"
					end if
					codigoPlanejamentoProfAux = rsAux("cod_planejamento_professor")
					qtde_aux_verifica_erro = rsAux.recordcount
				end if
				rsAux.close
				
				if dataAulaExtra<> "" and estilo_cor_aux = "laranja" then
					'CORRIGE PROBLEMA DA DATA DA AULA NO CONTEUDO MINISTRADO PARA O AULA EXTRA
					
					'sql="update m"
					'sql=sql & " set m.data_aula = '" & formataDataBD(dataAulaExtra) & "'"
					'sql=sql & " from SCA_CONTEUDO_MINISTRADO_PROFESSOR m"
					'sql=sql & " inner join SCA_PLANEJAMENTO_PROFESSOR p on p.cod_planejamento_professor = m.cod_planejamento_professor"
					'sql=sql & " where p.data_aula_extra = '" & formataDataBD(dataAulaExtra) & "'"
					'sql=sql & " and m.data_aula is null"
					'sql=sql & " and p.numero_aula is null"
					'sql=sql & " and p.cod_turma = " & Cod_Turma
					
					'if ucase(session("usuarioweb")) = "SERGIO" then
						'response.write sql & "<hr>"
						'response.end
						'cnn.execute sql
					'end if
				end if
				
				%>
				<td>
					<div class="estilo_aula_extra <%=estilo_cor_aux%>" style="cursor: pointer" onClick="return abreModal('<%=dataAulaExtra%>','<%=codCursoAux%>','<%=cursoAux%>','<%=codPeriodoAux%>','<%=periodoAux%>','<%=codDisciplinaAux%>','<%=disciplinaAux%>','<%=intCodTurno%>','<%=cod_turma%>','<%=turmaAux%>','<%=codigoPlanejamentoProfAux%>',true,'<%=dataAulaExtra%>','<%=semestre%>')">
						<strong>Sábado letivo <%=sequenciaExtra%></strong><br>
						<div class="tamanho_data_aula"><%=mid(formataDataAP(dataAulaExtra),1,5)%>
						
							<%
							if ucase(trim(session("usuarioWeb"))) = "ROBERTO.JUNIOR" then
								response.write " [" & qtde_aux_verifica_erro & "]"
							end if
							%>							
						
						</div>
					</div>
				</td>																
				<%	
			next		
		end if

	end function

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<form id="frm" name="frm" method="post" action="sca_planejamento_acompanhamento_professor.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></span></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						
							<input name="txtCodigo" 		type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtCodCurso" 		type="hidden" id="txtCodCurso">
							<input name="txtCurso" 			type="hidden" id="txtCurso">
							<input name="txtCodPeriodo" 	type="hidden" id="txtCodPeriodo">
							<input name="txtPeriodo" 		type="hidden" id="txtPeriodo">
							<input name="txtCodTurno" 		type="hidden" value="<%=intCodTurno%>" 		id="txtCodTurno">
							<input name="txtCodDisciplina" 	type="hidden" id="txtCodDisciplina">
							<input name="txtDisciplina" 	type="hidden" id="txtDisciplina">
							<input name="txtCodTurma" 		type="hidden" id="txtCodTurma">
							<input name="txtTurma" 			type="hidden" id="txtTurma">
							<input name="txtCodProfessor"	type="hidden" value="<%=intCodProfessor%>" 	id="txtCodProfessor">
							<input name="txtSemestre"		type="hidden" value="<%=strSemestre%>" 		id="txtSemestre">
							<input name="txtHiddenAnoLetivo" type="hidden" value="<%=strAnoLetivo%>" 	id="txtHiddenAnoLetivo">
							<input name="bolAulaExtra" type="hidden" 	id="bolAulaExtra">
							<input name="dataAula" 			type="hidden" 	id="dataAula">
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>" readonly maxlength="4">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<input type="text" id="txtTurno" name="txtTurno" class="form-control" value="<%=strTurno%>" readonly >
									</div>								
								</div>
								<div class="col-sm-7">
									<div class="form-group">
										<label class="form-label">Professor</label>
										<input type="text" id="txtProfessor" name="txtProfessor" class="form-control" value="<%=strProfessor%>" readonly >
									</div>								
								</div>
							</div>
							<br>
							<div>
								<%
								strBotaoLimparTelaAtual  = "N"
								strBotaoConsultarTelaAtual = "N"
								strBotaoVoltaTelaAnterior = "N"
								strBotaoVoltaTelaAnteriorSubmit = "S"
								pagina_anterior = "sca_planejamento_acompanhamento_professorCon.asp"
								if strMes = "" then strMes = month(date)
								%>
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Mês</label>
										<%strExecutarSubmitMes="S"%>
										<!--#include file="includes/inc_cmbMes.asp"-->
									</div>								
								</div>
							</div>
							<div class="row">
							<div class="row">
								
								<div class="col-sm-12">
									<div class="form-group">
										
									<%
									'sql = "SELECT d.mes, HA.Cod_Colaborador as codProfessor, HA.ANOLETIVO, HA.Semestre, cu.cod_curso, "
									'sql = sql & " CU.Descricao AS curso, P.Cod_Periodo, P.Descricao AS periodo, di.cod_disciplina as cod_disciplina, di.desc_disciplina as disciplina, "
									'sql = sql & " Tu.Cod_Turma, Tu.TurmaAluno as turma, d.ano, d.dia_mes"
									'sql = sql & " from sca_calendario_dia_ue d "
									'sql = sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
									'sql = sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
									'sql = sql & " inner join SCA_HORARIO_AULA HA on ha.AnoLetivo = d.ano and ha.DiaSemana = d.dia_semana and HA.COD_EMPRESA = c.cod_empresa"
									'sql = sql & " inner join SCA_HORARIO H ON H.codigo = HA.COD_HORARIO and h.cod_empresa = ha.Cod_Empresa"
									'sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turma = ha.Cod_turma"
									'sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_Disciplina = ha.Cod_Disciplina"
									'sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=Tu.COD_GRADECURRICULAR"
									'sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
									'sql = sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO"
									'sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")
									'sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo
									'sql = sql & " AND HA.SEMESTRE in (" & strSemestre & ")"
									'sql = sql & " and d.ano = " & strAnoLetivo
									'sql = sql & " and HA.Cod_Colaborador =  " & intCodProfessor
									'sql = sql & " and h.CodTurno =  " & intCodTurno
									'sql = sql & " and e.letivo='S' " 
									'sql = sql & " order by di.desc_disciplina, ha.Cod_turma, d.ano, d.mes, d.dia_mes"
									'if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN
									'	'response.write sql
									'end if
									sql = "exec [SP_AcompanhamentoPlanejamentoProfessor]" & Session("CodEmpresa") & "," & strAnoLetivo & "," & intCodProfessor & "," & intCodTurno
									if session("usuarioWeb") = "SERGIO" THEN
										RESPONSE.WRITE SQL & "<hr>"
									'	response.end
									end if
									RS.OPEN SQL, cnn
									IF NOT RS.EOF THEN
									numero_aula = 1
									ja_imprimiu_turma = "N"
									mostraMensagemNaoliberado = ""
									%>
									<table style="margin-bottom: 15px;">
											<%
											controle = 0
											while not rs.eof
												mostra_valida_turma = "N"
												strSemestre = rs("semestre")
												strDataAula = formataDataAp(rs("dia_mes") & "/" & rs("mes") & "/" & rs("ano"))
												strDataAulaTela = mid(strDataAula,1,5)
												liberadoClick = rs("liberadoClick")
												'estilo_cor = rs("cor")
												'codigoPlanejamentoProf = rs("cod_planejamento_professor")
												
												'if liberadoClick<>"S" then
												'	mostraMensagemNaoliberado = "S"
												'end if
												
												if controle=1 then
													if trim(rs("Cod_Turma")) <> trim(Cod_Turma) then
														numero_aula = 1
														if trim(rs("mes")) = trim(strMes) then
														%>
														</tr>
														</table>
														<table style="margin-bottom: 15px;">														
														<%
														end if
													end if
												end if
												
												if trim(rs("cod_disciplina")) <> trim(cod_disciplina) then
													'verifica se tem acesso a validação
													%>
													</table>
													<table style="margin-bottom: 15px;">													
													<tr>
														<td style="height: 50px; padding-top:30px; font-size:17px" colspan="100%"><strong><%=rs("disciplina")%></strong></td>														
													</tr>

													<%
													ja_imprimiu_turma = "N"
													Cod_Turma=0
													numero_aula = 1
												end if
												
												estilo_cor = "amarelo"
												codigoPlanejamentoProf = 0
												if trim(rs("mes")) = trim(strMes) then
													
													if liberadoClick = "S" then
														sql = "select p.cod_planejamento_professor, p.validado, p.observacao, (select COUNT(*) from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_planejamento_professor = p.cod_planejamento_professor) as qtde_conteudo_ministrado"
														sql = sql & " from SCA_PLANEJAMENTO_PROFESSOR p"
														'sql = sql & " left join SCA_CONTEUDO_MINISTRADO_PROFESSOR m on m.cod_planejamento_professor = p.cod_planejamento_professor "
														sql = sql & " where p.numero_aula = " & numero_aula
														sql = sql & " and p.cod_disciplina = " & rs("cod_disciplina")
														sql = sql & " and p.cod_turma = " & rs("cod_turma")
														sql = sql & " and p.anoLetivo = " & strAnoLetivo
														'sql = sql & " and cod_colaborador = " & intCodProfessor
														sql = sql & " and p.cod_turno = " & intCodTurno
														sql = sql & " and p.cod_planejamento_geral<>0"
														sql = sql & " order by validado desc"
														if session("usuarioWeb") = "ROBERTO.JUNIOR" AND numero_aula = "58" THEN
															RESPONSE.WRITE "<hr>" & SQL & "<hr>"
														end if
														rsAux.open sql, cnn,3,3
														qtde_aux_verifica_erro = 0
														if not rsAux.eof then
															if rsAux("qtde_conteudo_ministrado")=0 then
																if trim(rsAux("validado")) = "N" then
																	estilo_cor = "vermelho"
																elseif trim(rsAux("validado")) = "S" then
																	estilo_cor = "verde"
																	if not isnull(rsAux("observacao")) then
																		estilo_cor = "azul"
																	end if
																end if
															else
																estilo_cor = "laranja"
															end if
															codigoPlanejamentoProf = rsAux("cod_planejamento_professor")
															qtde_aux_verifica_erro = rsAux.recordcount
														end if
														rsAUx.close
													else
														estilo_cor = "cinza"
														mostraMensagemNaoliberado = "S"
													end if
													%>
												
													<%if ja_imprimiu_turma = "N" then%>
													<tr height="40">
														<td class="estilo_turma" width="80px" align="center"><strong><%=rs("periodo")%><br><%=rs("turma")%></strong></td>
														<td>
																<div class="estilo_aula <%=estilo_cor%>" <%if liberadoClick = "S" then%> style="cursor: pointer" onClick="return abreModal('<%=numero_aula%>','<%=rs("cod_curso")%>','<%=rs("curso")%>','<%=rs("cod_periodo")%>','<%=rs("periodo")%>','<%=rs("cod_disciplina")%>','<%=rs("disciplina")%>','<%=intCodTurno%>','<%=rs("cod_turma")%>','<%=rs("turma")%>','<%=codigoPlanejamentoProf%>',false,'','<%=strDataAula%>')" <%end if%>>
																	<strong><%=numero_aula%></strong>
																	<div class="tamanho_data_aula"><%=strDataAulaTela%>
																	
																		<%if ucase(trim(session("usuarioWeb"))) = "ROBERTO.JUNIOR" or ucase(trim(session("usuarioWeb"))) = "SERGIO" then
																			response.write " [" & qtde_aux_verifica_erro & "]"
																		end if
																		
																		strNumAulaTurma = strNumAulaTurma & numero_aula
																		
																		%>																		
																	
																	</div>

																</div>
														</td>
													
													<%	ja_imprimiu_turma = "S" 
													 else%>
														<td>
																<div class="estilo_aula <%=estilo_cor%>" <%if liberadoClick = "S" then%> style="cursor: pointer" onClick="return abreModal('<%=numero_aula%>','<%=rs("cod_curso")%>','<%=rs("curso")%>','<%=rs("cod_periodo")%>','<%=rs("periodo")%>','<%=rs("cod_disciplina")%>','<%=rs("disciplina")%>','<%=intCodTurno%>','<%=rs("cod_turma")%>','<%=rs("turma")%>','<%=codigoPlanejamentoProf%>',false,'','<%=strDataAula%>')" <%end if%>>
																	<strong><%=numero_aula%></strong>
																	<div class="tamanho_data_aula"><%=strDataAulaTela%>
																	
																		<%if ucase(trim(session("usuarioWeb"))) = "ROBERTO.JUNIOR" then
																			response.write "[" & qtde_aux_verifica_erro & "]"
																		end if

																		strNumAulaTurma = strNumAulaTurma & "," & numero_aula
																		%>																		
																	</div>
																</div>
														</td>
													<%end if%>
												<%end if%>
												<%
												controle 		= 1
												cod_disciplina 	= trim(rs("cod_disciplina"))
												Cod_Turma 		= trim(rs("Cod_Turma"))
												numero_aula 	= numero_aula + 1


												codCursoAux = rs("cod_curso")
												cursoAux = rs("curso")
												codPeriodoAux = rs("cod_periodo")
												periodoAux = rs("periodo")
												codDisciplinaAux = rs("cod_disciplina")
												disciplinaAux = rs("disciplina")
												turmaAux = rs("turma")

												mesAula = rs("mes")											

												rs.movenext
												if not rs.eof then
													codigoProximaDisciplina = rs("cod_disciplina")
													codigoProximaTurma = rs("cod_turma")
												else
													codigoProximaTurma = ""
													codigoProximaDisciplina = ""
												end if

												if (trim(codigoProximaTurma) <> trim(Cod_Turma)) or (trim(codigoProximaDisciplina) <> cod_disciplina)  then

													buscaAulasExtrasTurma cod_disciplina, Cod_Turma, strAnoLetivo, intCodTurno,codCursoAux, cursoAux, codPeriodoAux, periodoAux, codDisciplinaAux, disciplinaAux, turmaAux, strSemestre


													if liberadoClick = "S" and ((mesAula = 6 and (strSemestre = 1 or strSemestre = 3) and (strMes = 1 or strMes = 2 or strMes = 3 or strMes = 4 or strMes = 5 or strMes = 6)) or (mesAula = 12 and (strSemestre = 2 or strSemestre = 3) and (strMes = 8 or strMes = 9 or strMes = 10 or strMes = 11 or strMes = 12)) or (mesAula = 12 and strSemestre = 3 and (strMes = 1 or strMes = 2 or strMes = 3 or strMes = 4 or strMes = 5 or strMes = 6))) then%>
															<%if estilo_cor_aula <> "laranja" then%>
																<%if strTemAcessoValidacao = "" then%>
																	<td>
																		<button style="margin-left: 20px;" onclick="validarTurma(<%=cod_disciplina%>,<%=Cod_Turma%>,'<%=strNumAulaTurma%>')" type="button" class="btn btn-outline-success waves-effect waves-themed">Validar</button>
																	</td>
																	<td>
																		<button style="margin-left: 20px;" onclick="desvalidarTurma(<%=cod_disciplina%>,<%=Cod_Turma%>,'<%=strNumAulaTurma%>')" type="button" class="btn btn-outline-danger waves-effect waves-themed">Desvalidar</button>
																	</td>
																<%end if%>
															<%end if%>
														<%
														mostra_valida_turma = "N"
													end if

													strNumAulaTurma = ""
													ja_imprimiu_turma = "N"
													
												end if

											wend

											%>
										</tbody>
									</table>
									<br>
									<br>
									<div class="row">
										<%
										strSpan = "2"
										if mostraMensagemNaoliberado = "S" then
											strSpan = "2"
										%>
										<div class="col-sm-<%=strSpan%>">
											<div class="estilo_legenda cinza">
												<strong>Não liberado</strong>
											</div>
										</div>
										<%end if%>
										<div class="col-sm-<%=strSpan%>">
											<div class="estilo_legenda amarelo">
												<strong>Aguardando Planejamento</strong>
											</div>
										</div>
										<div class="col-sm-<%=strSpan%>">
											<div class="estilo_legenda vermelho">
												<strong>Planejado e não validado</strong>
											</div>
										</div>
										<div class="col-sm-<%=strSpan%>">
											<div class="estilo_legenda verde">
												<strong>Planejado e validado</strong>
											</div>
										</div>
										<div class="col-sm-<%=strSpan%>">
											<div class="estilo_legenda azul">
												<strong>Planejado/validado com observação</strong>
											</div>
										</div>
										<div class="col-sm-<%=strSpan%>">
											<div class="estilo_legenda laranja">
												<strong>Conteúdo Ministrado</strong>
											</div>
										</div>
									</div>
									<%
									else
									%>
									<div>
										<strong>Professor selecionado ainda não inicio o seu planejamento das aulas!</strong>
									</div>
									<%
									END IF
									RS.CLOSE
									%>

									</div>								
								</div>
							</div>

					</div>
				</div>

				
			</div>
		</div>
	</div>
	
	
	
	<!--div class="modal fade" id="modalNovoItem" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

			<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Planejamento do Professor - Aula</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true"><i class="fal fa-times"></i></span>
						</button>
					</div>
					<div class="modal-body">
					
						<div id="divListaAulas"></div>	
						
					</div>	
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
					</div>
				</div>
			</div>

	</div-->

	<div class="modal fade" id="modalReplicarAula" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">A aula <span class="spanAulaExtra"></span><b><span class="numAula"></span></b> já possui planejamento cadastrado. O que você deseja fazer?</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				<div class="modal-body">
					<div class="row"  style='margin-top: 5px ;'>
						<div class="col-sm-6" style="background-color: #f7f7f7; border: 2px solid #fff;">
							<div style="text-align: center ;padding-top: 10px;"><b>Replicar a aula <span class="spanAulaExtra"></span><span class="numAula"></span> para:<br>(selecione a(s) turma(s))</b></div>
							<div id="divListaTurmas"></div>	
						</div>
						<div class="col-sm-6" style="background-color: #f7f7f7; border: 2px solid #fff;">
							<div style="text-align: center ;padding-top: 10px;"><b>Visualizar Planejamento da Aula <span class="spanAulaExtra"></span><span class="numAula"></span></b></div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<input type="hidden" id="codigoPlanejamentoProf">
							<button id="btnReplicar" class='btn btn-outline-success btn-lg btn-block waves-effect waves-themed'>Replicar</button>
						</div>
						<div class="col-sm-6">
							<button id="btnVisualizarPlanejamento" class='btn btn-outline-primary btn-lg btn-block waves-effect waves-themed'>Visualizar Planejamento</button>
						</div>						
					</div>
				</div>	
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
				</div>
			</div>
		</div>

	</div>	
</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
<script type="text/javascript">
	aguarde.style.display="none"
</script>