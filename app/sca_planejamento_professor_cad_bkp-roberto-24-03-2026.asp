<%
	'parametros para o botao voltar
	intCodProfessorRetorno           = Trim(Request.Form("cmbProfessor"))
	intCodTurmaProfessorRetorno      = Trim(Request.Form("cmbTurmaProfessor"))
	intCodCursoRetorno               = Trim(Request.Form("cmbCurso"))
	intCodPeriodoRetorno             = Trim(Request.Form("cmbPeriodo"))
	intCodTurnoRHRetorno             = Trim(Request.Form("cmbTurnoRH"))
	'---------------------------------

	acao = "I"
	
	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo")) 'session("strAnoLetivo")
	if strAnoLetivo="" then strAnoLetivo = Trim(Request.Form("txtHiddenAnoLetivo"))

	strSemestre             = Trim(Request.Form("txtSemestre"))

	intCodCurso				= Trim(Request.Form("txtCodCurso"))	
	strCurso				= Trim(Request.Form("txtCurso"))	

	intCodPeriodo			= Trim(Request.Form("txtCodPeriodo"))
	strPeriodo				= Trim(Request.Form("txtPeriodo"))

	intCodTurno				= Trim(Request.Form("txtCodTurno"))
	strTurno				= Trim(Request.Form("txtTurno"))

	intCodDisciplina        = Trim(Request.Form("txtCodDisciplina"))
	strDisciplina           = Trim(Request.Form("txtDisciplina"))
	
	intCodTurma      		= Trim(Request.Form("txtCodTurma"))
	strTurma	            = Trim(Request.Form("txtTurma"))
	
	intCodProfessor	        = Trim(Request.Form("cmbProfessor"))
	if intCodProfessor = "" then intCodProfessor = request.form("txtCodProfessor")
	strProfessor	        = Trim(Request.Form("txtProfessor"))

'--------------------------------------------------------
	bolRodarScriptCargaRelatorio = false
	'if strAnoLetivo = "2023" then
		sql="select count(*)"
		sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
		sql=sql & " inner join SCA_CONTEUDO_MINISTRADO_PROFESSOR cm"
		sql=sql & " on pp.cod_planejamento_professor = cm.cod_planejamento_professor"
		sql=sql & " where pp.cod_empresa =" & session("CodEmpresa")	
		'sql=sql & " and pp.cod_colaborador =" & intCodProfessor
		sql=sql & " and pp.anoLetivo =" & strAnoLetivo
		sql=sql & " and pp.semestre =" & strSemestre
		sql=sql & " and pp.cod_disciplina =" & intCodDisciplina
		sql=sql & " and pp.cod_turma =" & intCodTurma
		sql=sql & " and (cm.data_aula is null or cm.data_aula='1900-01-01')"
		sql=sql & " and (pp.data_aula_extra is null or pp.data_aula_extra='1900-01-01')"
		if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN
			response.write sql
		end if
		rs.open sql, CNN
		if rs.eof = false then
			if rs(0) > 0 then
				bolRodarScriptCargaRelatorio = true
			end if
		end if
		rs.close
	'end if
	'--------------------------------------------------------	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
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
						<form id="frm" name="frm" method="post">
							<input name="pagina"            type="hidden" id="pagina" value="<%=strControlePagina%>">
							<input name="txtCodigo" 		type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtCodCurso" 		type="hidden" value="<%=intCodCurso%>" 		id="txtCodCurso">
							<input name="txtCodPeriodo" 	type="hidden" value="<%=intCodPeriodo%>" 	id="txtCodPeriodo">
							<input name="txtCodTurno" 		type="hidden" value="<%=intCodTurno%>" 		id="txtCodTurno">
							<input name="txtCodDisciplina" 	type="hidden" value="<%=intCodDisciplina%>" id="txtCodDisciplina">
							<input name="txtCodTurma" 		type="hidden" value="<%=intCodTurma%>" 		id="txtCodTurma">
							<input name="txtCodProfessor"	type="hidden" value="<%=intCodProfessor%>" 	id="txtCodProfessor">
							<input name="txtSemestre"		type="hidden" value="<%=strSemestre%>" 		id="txtSemestre">
							<input name="txtHiddenAnoLetivo" type="hidden" value="<%=strAnoLetivo%>" 	id="txtHiddenAnoLetivo">

							<!-- parametro do retorno do voltar-->
							<input name="cmbProfessor" 		type="hidden" id="cmbProfessor" 		value="<%=intCodProfessorRetorno%>">
							<input name="cmbTurmaProfessor" type="hidden" id="cmbTurmaProfessor" 	value="<%=intCodTurmaProfessorRetorno%>">
							<input name="cmbCurso" 			type="hidden" id="cmbCurso" 			value="<%=intCodCursoRetorno%>">
							<input name="cmbPeriodo" 		type="hidden" id="cmbPeriodo" 			value="<%=intCodPeriodoRetorno%>">
							<input name="cmbTurnoRH" 		type="hidden" id="cmbTurnoRH" 			value="<%=intCodTurnoRHRetorno%>">
							<input name="strConsultar" 		type="hidden" id="strConsultar" 		value="S">
							

							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>" disabled maxlength="4">
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<input type="text" id="txtCurso" name="txtCurso" class="form-control" value="<%=strCurso%>" disabled >
									</div>
								</div>	
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Período</label>
										<input type="text" id="txtPeriodo" name="txtPeriodo" class="form-control" value="<%=strPeriodo%>" disabled >
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<input type="text" id="txtTurno" name="txtTurno" class="form-control" value="<%=strTurno%>" disabled >
									</div>								
								</div>
							</div>	
							<div class="row">
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Disciplina</label>
										<input type="text" id="txtDisciplina" name="txtDisciplina" class="form-control" value="<%=strDisciplina%>" disabled >
									</div>								
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Turma</label>
										<input type="text" id="txtTurma" name="txtTurma" class="form-control" value="<%=strTurma%>" disabled >
									</div>								
								</div>

								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Professor</label>
										<input type="text" id="txtProfessor" name="txtProfessor" class="form-control" value="<%=strProfessor%>" disabled >
									</div>								
								</div>
							</div>

							<br>
							<div class="frame-wrap">
								<%
								strBotaoLimparTelaAtual  = "N"
								strBotaoConsultarTelaAtual = "N"
								strBotaoVoltaTelaAnterior = "N"
								strBotaoVoltaTelaAnteriorSubmit = "S"
								pagina_anterior = "sca_planejamento_professorCon.asp?pagina=" & strControlePagina
								%>
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>
							<!-- CALENDARIO ESCOLAR -->


							<%
							
							sql= " select DiaSemana, count(*) as aulas "
							sql=sql & " from SCA_HORARIO_AULA ha"
							sql=sql & " inner join SCA_HORARIO h on ha.Cod_Horario = h.codigo"
							sql=sql & " where ha.Cod_Colaborador = " & intCodProfessor 
							sql=sql & " and ha.AnoLetivo = " & strAnoLetivo
							sql=sql & " and ha.Cod_turma = " & intCodTurma
							sql=sql & " and ha.Cod_Disciplina = " & intCodDisciplina
							sql=sql & " and h.CodTurno=" & intCodTurno
							sql=sql & " group by ha.DiaSemana order by 1"
							'if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN
								'RESPONSE.WRITE SQL & "<hr>"
							'end if		
							vetAulaNaSemana = null
							RS.open sql, cnn
							if not RS.eof then
								vetAulaNaSemana = RS.getRows
							end if
							RS.close
						
							
							dim numero_aula
							dim numero_aula_extra
							numero_aula = 0
							numero_aula_extra = 0
							
							sub montaCalendario (MesCal, AnoCal)

								PrimeiroDiaMes = DateSerial(AnoCal,MesCal,1)
								UltimoDiaMes   = DateSerial(AnoCal,MesCal+1,1-1)
								Inicio         = ABS(1 - WeekDay(PrimeiroDiaMes))
								Fim            = 7 - WeekDay(UltimoDiaMes)
								Start          = 1 - Inicio
								TheEnd         = Day(UltimoDiaMes) + Fim 
								J=1
											
								%>

										 <table width="80%" border="1" cellpadding="0" cellspacing="0" class="tabela">
												<tr>
												  <td width="20%" class="celula" align="center" colspan="7"><font size="1"><strong><%=ucase(monthname(MesCal))%></strong></font></td>
												</tr>
												<tr>
												  <td align="center" class="celula"><strong>Dom</strong></td>
												  <td align="center" class="celula"><strong>Seg</strong></td>
												  <td align="center" class="celula"><strong>Ter</strong></td>
												  <td align="center" class="celula"><strong>Qua</strong></td>
												  <td align="center" class="celula"><strong>Qui</strong></td>
												  <td align="center" class="celula"><strong>Sex</strong></td>
												  <td align="center" class="celula"><strong>Sab</strong></td>
												</tr>
												<%
												controle = 0
												posicao = 0
												
												For i= Start to TheEnd
													cod_calendario_evento = ""
													Data = DateSerial(AnoCal,MesCal,i)
													
													if trim(MesCal) = trim(month(DateSerial(AnoCal,MesCal,i))) then
														bloqueio = ""
														liberaPlanejamentoProfessor = "N"
														cursor = ""
														sql="select e.cod_calendario_evento, e.cor, d.detalhes, e.letivo  "
														sql=sql & " from sca_calendario_dia_ue d "
														sql=sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
														sql=sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
														sql=sql & " where c.cod_empresa = " & session("CodEmpresa")				
														sql=sql & " and ("
														sql=sql & " 	dia_mes =" & day(DateSerial(AnoCal,MesCal,i)) 
														sql=sql & " 	and mes =" & month(DateSerial(AnoCal,MesCal,i))
														sql=sql & " 	and ano =" & year(DateSerial(AnoCal,MesCal,i))
														sql=sql & " )"	
														'if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN
														'	RESPONSE.WRITE SQL & "<hr>"
														'end if
														rs.open sql, cnn
														if rs.eof = false then
															corFundo = rs("cor")
															strDetalhe = rs("detalhes")
															qtde_aulas = 0
															if trim(rs("letivo")) = "S" then
																diaSemana = weekday(year(DateSerial(AnoCal,MesCal,i)) & "/" & month(DateSerial(AnoCal,MesCal,i)) & "/" & day(DateSerial(AnoCal,MesCal,i))) 
																liberaPlanejamentoProfessor = "N"
																cursor = ""
																existeAulaDiaSemana = "N"
																aulas = ""
																aulasExtras = ""

																if isArray(vetAulaNaSemana) then
																	for k=0 to ubound(vetAulaNaSemana,2)
																	
																		if trim(diaSemana) = trim(vetAulaNaSemana(0,k)) then
																			existeAulaDiaSemana = "S"
																			qtde_aulas = vetAulaNaSemana(1,k)
																		end if
																	next
																	if session("usuarioWeb") = "ROBERTO.JUNIOR" THEN																	
																		RESPONSE.WRITE existeAulaDiaSemana
																	END IF
																	if trim(existeAulaDiaSemana) = "S" then
																		for h=1 to qtde_aulas
																			numero_aula = numero_aula + 1
																			if aulas = "" then
																				aulas = numero_aula
																			else
																				aulas = aulas & "," & numero_aula
																			end if


																			'verifica se tem conteúdo Ministrado
																			'e se o registro possui data_aula cadastrada.
																			'Se não possuir, atualiza
																			if bolRodarScriptCargaRelatorio then												
																				sql="update cm"
																				sql=sql & " set cm.data_aula = '" & year(DateSerial(AnoCal,MesCal,i)) & "-" & month(DateSerial(AnoCal,MesCal,i)) & "-" & day(DateSerial(AnoCal,MesCal,i)) & "'"
																				sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
																				sql=sql & " inner join SCA_CONTEUDO_MINISTRADO_PROFESSOR cm"
																				sql=sql & " on pp.cod_planejamento_professor = cm.cod_planejamento_professor"
																				sql=sql & " where pp.cod_empresa =" & session("CodEmpresa")	
																				'sql=sql & " and pp.cod_colaborador =" & intCodProfessor
																				sql=sql & " and pp.anoLetivo =" & strAnoLetivo
																				sql=sql & " and pp.semestre =" & strSemestre
																				sql=sql & " and pp.numero_aula =" & numero_aula
																				sql=sql & " and pp.cod_disciplina =" & intCodDisciplina
																				sql=sql & " and pp.cod_turma =" & intCodTurma
																				sql=sql & " and (cm.data_aula is null or cm.data_aula='1900-01-01')"
																				sql=sql & " and (pp.data_aula_extra is null or pp.data_aula_extra='1900-01-01')"

																				cnn.execute sql
																			end if

																		next
																		
																		liberaPlanejamentoProfessor = "S"
																		corFundo = "#89fc44"
																		cursor = "style='cursor: pointer;' onclick='carregaAulas(""" & diaSemana & """,""" & aulas & """,""" & Data & """,false)'"
																	else

																		'Verifica se é aula extra
																		sql= " select *"
																		sql=sql & " from SCA_HORARIO_AULA_extra ha"
																		sql=sql & " inner join SCA_HORARIO h on ha.Cod_Horario = h.codigo"
																		sql=sql & " where ha.Cod_Colaborador = " & intCodProfessor 
																		sql=sql & " and ha.AnoLetivo = " & strAnoLetivo
																		sql=sql & " and ha.Cod_turma = " & intCodTurma
																		sql=sql & " and ha.Cod_Disciplina = " & intCodDisciplina
																		sql=sql & " and h.CodTurno=" & intCodTurno
																		sql=sql & " and ha.dataLancamento='" & formatadataBd(Data) & "'" 
																		'if session("usuarioWeb") = "ROBERTO.JUNIOR" AND MONTH(DATA)=5 AND DAY(DATA)=6 THEN																	
																		'	RESPONSE.WRITE SQL
																		'END IF
																		numero_aula_extra = ""																		
																		rsAux.open sql, cnn
																		if not rsAux.eof then
																			while not rsAux.eof
																				if numero_aula_extra = "" then
																					numero_aula_extra = rsAux("codigo")
																				else
																					numero_aula_extra = numero_aula_extra & "," & rsAux("codigo")
																				end if
																				
																				corFundo = "#89fc44"
																				cursor = "style='cursor: pointer;' onclick='carregaAulas(""" & diaSemana & """,""" & numero_aula_extra & """,""" & Data & """,true)'"
																				
																				rsAux.movenext
																			wend
																		end if
																		rsAux.close																		
																	end if

																end if
															end if
														else
															corFundo = ""
															strDetalhe = ""
															diaSemana = ""
															liberaPlanejamentoProfessor = "N"
															cursor = ""
															existeAulaDiaSemana = "N"
															aulas = ""
														end if
														rs.close
													end if
													
													if trim(i) = trim(day(now)) and trim(MesCal)=trim(Month(now)) and trim(AnoCal) = trim(year(now)) Then
														'Dia Hoje
														IF corFundo = "" THEN corFundo = "#ffffff"
														posicao = posicao + 1	
														Response.Write "<TD " & cursor & " align='center' height='15' width='10' bgcolor='" & corFundo & "'  class='celula'><FONT COLOR=BLUE><strong>"& Day(DateSerial(AnoCal,MesCal,i)) & "</strong></font></TD>"
													Elseif (i<1) or (i > Day(UltimoDiaMes)) Then
														'mes anterior e posterior
														if (Weekday(DateSerial(AnoCal,MesCal,i)) = 7 or Weekday(DateSerial(AnoCal,MesCal,i))=1) and corFundo="" then corFundo = "#COCOCO"
														if corFundo="" then corFundo="#fff"
														Response.Write "<TD align='center' height='15' width='10'  class='celula'>&nbsp;</TD>"
													Else
														if (Weekday(DateSerial(AnoCal,MesCal,i)) = 7 or Weekday(DateSerial(AnoCal,MesCal,i))=1) and corFundo="" then corFundo = "#COCOCO"
														'Dias do m&ecirc;s
														posicao = posicao + 1	
														Response.Write "<TD " & cursor & " align='center' height='15' width='10' bgcolor='" & corFundo & "'  class='celula'><FONT COLOR='#000'>"& Day(DateSerial(AnoCal,MesCal,i)) & "</font></TD>"
													End if
													
													If j = 7 then
														 J = 0
														 Response.Write "</tr><TR>"
													end if
													J = j + 1	
												NEXT%>
									   </tr>
								  </table>
							<%end sub%>


								<% 
								sql = "SELECT cod_calendario_ue"
								sql = sql & " FROM SCA_CALENDARIO_ue"
								sql = sql & " Where SITUACAO = 'A' AND ANO_LETIVO = " & strAnoLetivo
								rs.open sql, cnn
								if rs.eof = false then
									intCodCalendario		= rs("cod_calendario_ue")
								end if 
								rs.close
								
								mes = strMes
								ano = strAnoLetivo	 
										 
								Session.LCID = 1046 'BRASIL
								Dim URL,Dia, Mes, Ano, PrimeiroDiaMes, UltimoDiaMes 
								Dim Inicio,Fim, Start, TheEnd,i, j
								
								URL= Request.ServerVAriables("SCRIPT_NAME")

								dia = day(now)
								
								%>
									<h2>
										<div align="center">
										<span class="titulo"><font size="+1"><%=strNome%></font></span>
										</div>
									</h2>
								
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<%
								controleCal = 0
								
								for cal = 1 to 4
									controleCal = controleCal + 1
									MesCalendario  = controleCal
									MesCalendario1 = controleCal+1
									MesCalendario2 = controleCal+2
									controleCal = MesCalendario2
									%>
									  <tr>
										<td height="130" valign="top">
											<%
											montaCalendario MesCalendario, strAnoLetivo
											%>
										</td>
										 <td height="130" valign="top">
											<%
											montaCalendario MesCalendario1, strAnoLetivo
											%>
										</td>
										<td height="130" valign="top">
											<%
											montaCalendario MesCalendario2, strAnoLetivo
											%>
										</td>
									</tr>
							   
									 
							<%next%>

							</table>

							<br />

							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td width="33%" height="130" valign="top">
								
									<%
									
									SQL = "select cor, nome, letivo from SCA_CALENDARIO_EVENTO"
									SQL = SQL & " where cod_grupo ="&session("codGrupo")
									SQL = SQL & " order by 1"
									rs.open sql, cnn
									if not rs.eof then
										%>
										<table width="80%" border="1" cellspacing="0" cellpadding="0" class="tabela">
										  <tr>
											<td class="celula" align="center" colspan="3"><font size="1"><strong>LEGENDA</strong></font></td>
										  </tr>
										  <tr>
											<td class="celula" align="center" colspan="2"><strong>Evento</strong></td>
											<td class="celula" align="center"><strong>Letivo</strong></td>
										  </tr>
										  <tr>
												<td  height="15" class="celula" bgcolor="#89fc44" width="20">&nbsp;</td>
												<td class="celula">&nbsp;&nbsp;DIA LETIVO - PROFESSOR C/AULA</td>
												<td class="celula">&nbsp;&nbsp;Sim</td>
											</tr>
										  <%
										  while not rs.eof
											letivo = " "
											if rs("letivo") = "S" then letivo = "Sim"
											if rs("letivo") = "N" then letivo = "Não"
											%>
											<tr>
												<td  height="15" class="celula" bgcolor="<%=rs("cor")%>" width="20">&nbsp;</td>
												<td class="celula">&nbsp;&nbsp;<%=rs("nome")%></td>
												<td class="celula">&nbsp;&nbsp;<%=letivo%></td>
											</tr>
											<%
											rs.movenext
										  wend
										  %>
										</table>
										<%
									end if
									rs.close
									%>
								
								</td>
								<td width="33%" valign="top">
								
							<%
									SQL = "SELECT MES, DIA_MES, DETALHES  "
									SQL = SQL & " FROM SCA_CALENDARIO_DIA_ue d"
									SQL = SQL & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
									SQL = SQL & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
									SQL = SQL & " where c.cod_empresa = " & session("CodEmpresa")		
									SQL = SQL & " and e.cod_calendario_evento=1"'FERIADO
									SQL = SQL & " and d.ano = " & strAnoLetivo 
									SQL = SQL & " ORDER BY ANO, MES, dia_mes"
									rs.open sql, cnn
									if not rs.eof then
										%>
										<table width="80%" border="1" cellspacing="0" cellpadding="0" class="tabela">
										  <tr>
											<td class="celula" colspan="3" align="center"><font size="1"><strong>FERIADOS</strong></font></td>
										  </tr>
										  <%
										  flag_mes = ""
										  while not rs.eof
											if flag_mes <> left(ucase(monthname(RS("MES"))),3) then
												nome_mes = left(ucase(monthname(RS("MES"))),3)
												'cor = "style='background-color:#CCC'"
											else
												nome_mes = ""
												'cor = "style='background-color:#FFF'"
											end if
											if cor = "" then
												if nome_mes <> "" then cor = "style='background-color:#CCC'"
											else
												if nome_mes <> "" then cor = ""
											end if
											%>
											<tr <%=cor%>>
												<td width="20%" height="15" align="center" class="celula"><%=left(ucase(monthname(RS("MES"))),3)%></td>
											<td align="center" class="celula"  width="5%"><%=RS("DIA_MES")%></td>
												<td align="center" class="celula" width="75%"><%=RS("DETALHES")%></td>
											</tr>
											<%
											rs.movenext
										  wend
										  %>
										</table>
										<%
									end if
									rs.close
									%>
									
								</td>
								<td width="33%" valign="top">
								
								<%

									SQL = "SELECT MES, COUNT(*) AS QTDE "
									SQL = SQL & " from sca_calendario_dia_ue d "
									SQL = SQL & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
									SQL = SQL & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
									SQL = SQL & " where c.cod_empresa = " & session("CodEmpresa")
									SQL = SQL & " and d.ano = " & strAnoLetivo & " and e.letivo = 'S'"'DIA LETIVO
									SQL = SQL & " GROUP BY d.MES"
									SQL = SQL & " order by 1"
									rs.open sql, cnn
									if not rs.eof then
										%>
										<table width="80%" border="1" cellspacing="0" cellpadding="0" class="tabela">
										  <tr>
											<td colspan="2"  class="celula" align="center"><font size="1"><strong>DIAS LETIVOS</strong></font></td>
										  </tr>
										  <%
											total=0
											totalGeral=0
										  while not rs.eof
											%>
											<tr>
												<td align="center" class="celula"><%=ucase(monthname(RS("MES")))%></td>
												<td align="center" class="celula"><%=rs("QTDE")%></td>
											</tr>
											<%
											total = total + rs("QTDE")
											totalGeral = totalGeral + rs("QTDE")
											rs.movenext
										  wend
										  
										  %>
											
											<tr bgcolor="#CCCCCC">
												<td align="center" class="celula"><strong>Total</strong></td>
												<td align="center" class="celula"><strong><%=totalGeral%></strong></td>
											</tr>
														  
										</table>
										<%
									end if
									rs.close
									SQL = " select Descricao, periodo  "
									SQL = SQL & " from sca_bimestre"
									SQL = SQL & " where Ano_letivo=" & strAnoLetivo
									SQL = SQL & " order by Descricao"
									rs.open sql, cnn
									if not rs.eof then
									%>
										<br>
										<table width="80%" border="1" cellspacing="0" cellpadding="0" class="tabela">
										  <tr>
											<td colspan="2"  class="celula" align="center"><font size="1"><strong>TABELA BIMESTRAL</strong></font></td>
										  </tr>
										  <%
										 while not rs.eof
											%>
											<tr>
												<td align="center" class="celula"><%=rs("Descricao")%></td>
												<td align="center" class="celula"><%=rs("periodo")%></td>
											</tr>
											<%
											rs.movenext
										  wend
										  %>
										</table>
										<%
									end if
									rs.close
									%>	
								</td>
							  </tr>
							</table>

							<!-- CALENDARIO ESCOLAR -->
							

						</form>
					</div>
				</div>

				
			</div>
		</div>
	</div>	
	
	<div class="modal fade" id="modalNovoItem" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

			<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"><%=strTituloPagina%> - Aula</h5>
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

	</div>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>