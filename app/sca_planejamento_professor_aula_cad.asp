<%
	'parametros para o botao voltar
	intCodProfessorRetorno           = Trim(Request.Form("cmbProfessor"))
	intCodTurmaProfessorRetorno      = Trim(Request.Form("cmbTurmaProfessor"))
	intCodCursoRetorno               = Trim(Request.Form("cmbCurso"))
	intCodPeriodoRetorno             = Trim(Request.Form("cmbPeriodo"))
	intCodTurnoRHRetorno             = Trim(Request.Form("cmbTurnoRH"))
	'---------------------------------


	function UltimoDia(data)
		UltimoDia = dateadd("d",-1,cDate("01/" & month(dateadd("m",1,data)) & "/" & year(dateadd("m",1,data))))
	End function
	
	acao = "I"

	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
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
	
	intCodProfessor	        = Trim(Request.Form("txtCodProfessor"))
	strProfessor	        = Trim(Request.Form("txtProfessor"))

    intCodAula 				= Trim(Request("aula")) 
	strDataAula 			= Trim(Request("dataAula")) 
	bolAulaExtra			= Trim(Request("bolAulaExtra"))
	'dataAula                = Trim(Request("dataAula"))
	
	'response.write bolAulaExtra & "|" & intCodAula & "|" & dataAula
	'response.end
	
	'para sabado letivo
	if not isnumeric(intCodAula) then
		if intCodAula <> "" then
			strAnoLetivo        = year(intCodAula)
			strMes             	= month(intCodAula)
		end if
	else
		if strDataAula <> "" then
			strAnoLetivo        = year(strDataAula)
			strMes             	= month(strDataAula)
		end if
	end if
	
	retorno 				= Trim(Request("retorno")) 

	SESSION("controlePeriodoDeTempo") = 1

	'PERFIL COORDENADORES - 17
	'PERFIL PROFESSORES   - 11
	'PERFIL ADMINISTRADOR - 2	
	strCodPefilAcesso = "17,2,11"
%>
<!--#include file="includes/inc_VerificaAcessoPerfilAdmProfessor.asp"-->
<%
	'if (strAcessoPerfil="") then
		%>
		<!--script>
			//alert("Essa funcionalidade do Planejamento do professor por turma, deve ser utilizada pelo professor ou coordenador, você deverá ter acesso a algum desse perfil!")
			//window.history.back();
		</script -->
		<%
		'response.end
	'end if
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

                        <%
                        intCodigoPlanejamento = 0
                        intCodigoPlanejamentoEscola = 0
                        intCodigoSituacaoPlanejamento = 1 'Aguardando Cadastro
                        intCodigoSituacaoPlanejamentoEscola = 4 'Aguardando Secretaria
						
						
                        sql="select cod_planejamento_geral, cod_situacao_planejamento from SCA_PLANEJAMENTO_GERAL"
                        sql=sql & " where anoLetivo = " & strAnoLetivo
                        sql=sql & " and semestre = " & strSemestre
                        sql=sql & " and cod_periodo = " & intCodPeriodo
                        sql=sql & " and cod_disciplina = " & intCodDisciplina
						if ucase(trim(session("usuarioWeb"))) = "ROBERTO.JUNIOR" or ucase(trim(session("usuarioWeb"))) = "SERGIO" then
							'response.write sql & "<hr>"
							'response.end
						end if
                        rs.open sql, cnn
                        if rs.eof = false then
                            intCodigoPlanejamento = rs("cod_planejamento_geral")
                        end if
                        rs.close
						
						situacaoLiberadoParaProfessor = ""
						sql="select cod_planejamento_geral, cod_situacao_planejamento from SCA_PLANEJAMENTO_GERAL"
						sql=sql & " where cod_planejamento_geral_pai=" & intCodigoPlanejamento
						sql=sql & " and cod_empresa = " & session("codEmpresa")	
						if ucase(trim(session("usuarioWeb"))) = "ROBERTO.JUNIOR" or ucase(trim(session("usuarioWeb"))) = "SERGIO" then
							'response.write sql & "<hr>"
							'response.end
						end if
						rs.open sql, cnn
						if rs.eof = false then
							intCodigoPlanejamentoEscola = rs("cod_planejamento_geral")
							situacaoLiberadoParaProfessor = rs("cod_situacao_planejamento")
						end if
						rs.close
						
						if situacaoLiberadoParaProfessor <> "7" then 
							%>
							<script>
								alert("Planejamento do professor não está liberado o preenchimento!");
								//window.history.back();
							</script>
							<%
							response.end
						end if

						'verifica se já tem planejamento do professor para a aula informada
						strDataValidado = ""
						sql="select cod_planejamento_professor, validado, observacao, observacao_secretaria, data_hora_validado from SCA_PLANEJAMENTO_PROFESSOR"
						sql=sql & " where cod_planejamento_geral =" &  intCodigoPlanejamentoEscola
						if not bolAulaExtra then
							sql=sql & " and numero_aula =" & intCodAula	
						else
							sql=sql & " and data_aula_extra ='" & formataDataBD(intCodAula) & "'"
						end if
						sql=sql & " and cod_turma = " & intCodTurma
						sql=sql & " and cod_disciplina = " & intCodDisciplina
						'sql=sql & " and cod_colaborador=" & intCodProfessor
						sql=sql & " and cod_turno = " & intCodTurno
						sql=sql & " order by validado desc"
						if ucase(trim(session("usuarioWeb"))) = "ROBERTO.JUNIOR" or ucase(trim(session("usuarioWeb"))) = "SERGIO" then
							'response.write sql
						end if
						rs.open sql, cnn
						if rs.eof = false then
							intCodigoPlanejamentoProfessor = rs("cod_planejamento_professor")
							strValidado = rs("validado")
							strObservacao = rs("observacao")
							strObservacaoSecretaria = rs("observacao_secretaria")
							strDataValidado = rs("data_hora_validado")
							if isnull(strDataValidado) then strDataValidado = ""
						end if
						rs.close	

						'valida periodo autorizado para preenchimento
						bolPeriodoValido = false
						sql="select cod_planejamento_periodo from sca_planejamento_periodo"
						sql=sql & " where mes=" & strMes
						sql=sql & " and ano_letivo=" & strAnoLetivo						
						if not bolAulaExtra then
							if day(strDataAula) <= 15 then
								'sql=sql & " and (('" & formataDataBd(strDataAula) & "' between data_inicial_primeiro and data_final_primeiro )"
								sql=sql & " and ('" & formataDataBd(date) & "' between data_inicial_primeiro and data_final_primeiro )"
							else
								'sql=sql & " and (('" & formataDataBd(strDataAula) & "' between data_inicial_segundo and data_final_segundo) "
								sql=sql & " and ('" & formataDataBd(date) & "' between data_inicial_segundo and data_final_segundo) "
							end if
						else
							if day(formataDataBd(intCodAula)) <= 15 then
								'sql=sql & " and (('" & formataDataBd(intCodAula) & "' between data_inicial_primeiro and data_final_primeiro)"
								sql=sql & " and ('" & formataDataBd(date) & "' between data_inicial_primeiro and data_final_primeiro)"
							else
								'sql=sql & " and (('" & formataDataBd(intCodAula) & "' between data_inicial_segundo and data_final_segundo)"
								sql=sql & " and ('" & formataDataBd(date) & "' between data_inicial_segundo and data_final_segundo)"
							end if
						end if

						'if session("usuarioWeb") = "SERGIO" THEN
						'	RESPONSE.WRITE day(strDataAula) & "<hr>"
						'	RESPONSE.WRITE SQL & "<hr>"
						'end if							

						rs.open sql, cnn
						if rs.eof = false then
							bolPeriodoValido = true
						end if
						rs.close						
						
						if bolPeriodoValido = false then
							
							'if session("usuarioWeb") = "SERGIO" THEN
							'	RESPONSE.WRITE strAnoLetivo & "<hr>"
							'	RESPONSE.WRITE strAnoLetivo & "/" & strMes & "/01" & "<hr>"
							'end if
							
							dataInicioPrimeiraQuinzena = formataDataBDcomZero(strAnoLetivo & "/" & strMes & "/01")
							dataFinalPrimeiraQuinzena = formataDataBDcomZero(strAnoLetivo & "/" & strMes & "/15")
							
							dataInicioSegundaQuinzena = formataDataBDcomZero(strAnoLetivo & "/" & strMes & "/16")
							dataFinalSegundaQuinzena = formataDataBDcomZero(UltimoDia(dataInicioPrimeiraQuinzena))
							
							sql= " select e.data_expira "
							sql=sql & " from SCA_PLANEJAMENTO_PERIODO_EXTRA e"
							sql=sql & " inner join sca_planejamento_periodo p on p.cod_planejamento_periodo = e.cod_planejamento_periodo"
							sql=sql & " where e.cod_colaborador = " & intCodProfessor
							sql=sql & " and p.mes = " & strMes
							sql=sql & " and p.ano_letivo = " & strAnoLetivo	
							
							if not bolAulaExtra then
								if day(strDataAula) <= 15 then
									sql=sql & " and e.quinzena = 1"
									sql=sql & " and ('" & formataDataBDcomZero(strDataAula) & "' between '" & dataInicioPrimeiraQuinzena & "' and '" & dataFinalPrimeiraQuinzena & "')"
									sql=sql & " and ('" & formataDataBDcomZero(date) & "' between data_inicial_primeiro and e.data_expira )"
								else
									sql=sql & " and e.quinzena = 2"
									sql=sql & " and ('" & formataDataBDcomZero(strDataAula) & "' between '" & dataInicioSegundaQuinzena & "' and '" & dataFinalSegundaQuinzena & "') "
									sql=sql & " and ('" & formataDataBDcomZero(date) & "' between data_inicial_segundo and e.data_expira) "
								end if
							else
								if day(formataDataBd(intCodAula)) <= 15 then
									sql=sql & " and e.quinzena = 1"
									sql=sql & " and ('" & formataDataBDcomZero(intCodAula) & "' between '" & dataInicioPrimeiraQuinzena & "' and '" & dataFinalPrimeiraQuinzena & "')"
									sql=sql & " and ('" & formataDataBDcomZero(date) & "' between data_inicial_primeiro and e.data_expira)"
								else
									sql=sql & " and e.quinzena = 2"
									sql=sql & " and ('" & formataDataBDcomZero(intCodAula) & "' between '" & dataInicioSegundaQuinzena & "' and '" & dataFinalSegundaQuinzena & "')"
									sql=sql & " and ('" & formataDataBDcomZero(date) & "' between data_inicial_segundo and e.data_expira)"
								end if
							end if
							
							sql=sql & " and e.situacao = 'A'"
							
							'if session("usuarioWeb") = "SERGIO" THEN
							'	RESPONSE.WRITE SQL & "<hr>"
							'	RESPONSE.WRITE SQL & "<hr>" & date
							'	RESPONSE.WRITE SQL & "<hr>" & formataDataBDcomZero(date)
							'end if	
							rs.open sql, cnn
							if rs.eof = false then
								bolPeriodoValido = true
								data_expira = rs("data_expira")
							end if
							rs.close
						
						end if

						if strValidado <> "S" then
							if bolPeriodoValido = false then
								'strValidado = "S"
							end if						
						end if																	

                        %>

						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" 		 type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtCodCurso" 		 type="hidden" value="<%=intCodCurso%>" 		id="txtCodCurso">
							<input name="txtCodPeriodo" 	 type="hidden" value="<%=intCodPeriodo%>" 		id="txtCodPeriodo">
							<input name="txtCodTurno" 		 type="hidden" value="<%=intCodTurno%>" 		id="txtCodTurno">
							<input name="txtCodDisciplina" 	 type="hidden" value="<%=intCodDisciplina%>" 	id="txtCodDisciplina">
							<input name="txtCodTurma" 		 type="hidden" value="<%=intCodTurma%>" 		id="txtCodTurma">
							<input name="txtCodProfessor"	 type="hidden" value="<%=intCodProfessor%>" 	id="txtCodProfessor">
							<input name="txtHiddenAnoLetivo" type="hidden" value="<%=strAnoLetivo%>" 		id="txtHiddenAnoLetivo">
							<input name="txtSemestre"		 type="hidden" value="<%=strSemestre%>" 		id="txtSemestre">

							<input name="txtHiddenAula"		 type="hidden" value="<%if bolAulaExtra then response.write formataDataAP(intCodAula) else response.write intCodAula%>" 			id="txtHiddenAula">
							<input name="bolAulaExtra"		 type="hidden" value="<%=bolAulaExtra%>" 			id="bolAulaExtra">
							<input name="txtCodPlanejamento" type="hidden" value="<%=intCodigoPlanejamento%>" 	id="txtCodPlanejamento">
							<input name="txtCodPlanejamentoEscola"	  type="hidden" value="<%=intCodigoPlanejamentoEscola%>" 	id="txtCodPlanejamentoEscola">
							<input name="txtCodPlanejamentoProfessor" type="hidden" value="<%=intCodigoPlanejamentoProfessor%>" 	id="txtCodPlanejamentoProfessor">
							<input name="edicao" type="hidden" value="<%=strValidado%>" 	id="edicao">
							<%if bolPeriodoValido then%>
                            	<input name="periodoValido" type="hidden" value="S" id="periodoValido">
							<%else%>
								<input name="periodoValido" type="hidden" value="N" id="periodoValido">
							<%end if%>	                            
							
														
							<!-- parametro do retorno do voltar-->
							<input name="cmbProfessor" 		type="hidden" id="cmbProfessor" 		value="<%=intCodProfessorRetorno%>">
							<input name="cmbTurmaProfessor" type="hidden" id="cmbTurmaProfessor" 	value="<%=intCodTurmaProfessorRetorno%>">
							<input name="cmbCurso" 			type="hidden" id="cmbCurso" 			value="<%=intCodCursoRetorno%>">
							<input name="cmbPeriodo" 		type="hidden" id="cmbPeriodo" 			value="<%=intCodPeriodoRetorno%>">
							<input name="cmbTurnoRH" 		type="hidden" id="cmbTurnoRH" 			value="<%=intCodTurnoRHRetorno%>">
							<input name="strConsultar" 		type="hidden" id="strConsultar"			value="S">

							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano Letivo</label>
										<input type="text" id="txtAnoLetivo" name="txtAnoLetivo" class="form-control" value="<%=strAnoLetivo%>" disabled maxlength="4">
									</div>
								</div>	
								<div class="col-sm-3">
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
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Turno</label>
										<input type="text" id="txtTurno" name="txtTurno" class="form-control" value="<%=strTurno%>" disabled >
									</div>								
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Data Aula</label>
										<input type="text" id="txtDataAula" name="txtDataAula" class="form-control" value="<%=strDataAula%>" disabled >
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
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Turma</label>
										<input type="text" id="txtTurma" name="txtTurma" class="form-control" value="<%=strTurma%>" disabled >
									</div>								
								</div>

								<div class="col-sm-5">
									<div class="form-group">
										<label class="form-label">Professor</label>
										<input type="text" id="txtProfessor" name="txtProfessor" class="form-control" value="<%=strProfessor%>" disabled >
									</div>								
								</div>

								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Aula <%if bolAulaExtra then response.write "Extra"%></label>
										<input type="text" id="txtAula" name="txtAula" class="form-control" value="<%if bolAulaExtra then response.write formataDataAP(intCodAula) else response.write intCodAula%>" disabled >
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
								if retorno = "" then
									pagina_anterior = "sca_planejamento_professor.asp?pagina=pp&strConsultar=S&txtAnoLetivo=" & strAnoLetivo & "&cmbTurnoRH=" & intCodTurnoRH & "&cmbProfessor=" & intCodProfessorRetorno
								else
									pagina_anterior = retorno
								end if
								%>
								<!--#include file="includes/inc_botoes_consulta_novo.asp"-->
							</div>


						</form>
					</div>
				</div>				
			</div>
		</div>
	</div>

	<%if bolPeriodoValido = false then%>
	<div class="alert alert-warning alert-dismissible fade show" role="alert">
		<strong>Atenção!</strong> Esta aula está fora do período autorizado para planejamento.
	</div>
	<%end if%>	

    <div class="row">
        <div class="col-xl-6">
            <div class="panel">
                <div class="panel-hdr color-warning-800">
                    <h2>
                        Planejamento Anual
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    </div>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">
						<div class="row">

							<div class="col-sm-8">
								<div class="form-group">
									<label class="form-label">Unidade Temática/Linguagem/Práticas de Linguagens</label>
										<select name="cmbUnidadeTematica" id="cmbUnidadeTematica" class="form-control" onChange="return carregaPlanejamento(<%=intCodigoPlanejamento%>)">
											<option value="0" selected>Selecione...</option>
											<%
											sql="select cod_item_planejamento_geral, descricao from SCA_item_PLANEJAMENTO_GERAL"
											sql=sql & " where cod_planejamento_geral =" & intCodigoPlanejamento
											sql=sql & " and cod_tipo_planejamento is null"
											sql=sql & " and (cod_empresa is null or cod_empresa=" & session("codEmpresa") & ")"
											rs.open sql, cnn
											if rs.eof = false then
												while not rs.eof
													%>
													<option value="<%=rs("cod_item_planejamento_geral")%>"><%=rs("descricao")%></option>
													<%
													rs.movenext
												wend
											end if
											rs.close
											%>
										</select>
								</div>								
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<%if SESSION("controlePeriodoDeTempo") = 1 then 
										strLabel = "Bimestre"
									elseif SESSION("controlePeriodoDeTempo") = 2 then 
										strLabel = "Trimestre" 
									end if %>							
									<label class="form-label"><%=strLabel%></label>
									<select name="cmbBimestre" id="cmbBimestre" class="form-control" onChange="atualizaBimestreTela()">
										<%if SESSION("controlePeriodoDeTempo") = 1 then%>
										<option value="5">Unico</option>
										<!--option value="1">1° Bimestre</option>
										<option value="2">2° Bimestre</option>
										<option value="3">3° Bimestre</option>
										<option value="4">4° Bimestre</option-->
										<%elseif SESSION("controlePeriodoDeTempo") = 2 then%>
										<option value="1">1° Trimestre</option>
										<option value="2">2° Trimestre</option>
										<option value="3">3° Trimestre</option>
										<option value="5">Unico</option>
										<%end if%>
									</select>
								</div>								
							</div>				
						</div>

                        <div style="padding-top:20px" id="divListaPlanejamento"></div>
                    </div>
                </div>
            </div>        
        </div>
        <div class="col-xl-6">
            <div class="panel">
                <div class="panel-hdr color-warning-800">
                    <h2>
                        Planejamento do Professor
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    </div>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">


						<div class="panel">
							<div class="panel-hdr color-warning-800">
								<h2>
									Habilidades
								</h2>
								<div class="panel-toolbar">
									<button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
								</div>
							</div>
							<div class="panel-container show">
								<div id="div-1" class="panel-content"></div>
							</div>
						</div>

						<div class="panel">
							<div class="panel-hdr color-warning-800">
								<h2>
									Objetos de conhecimento / Objeto de aprendizagem e desenvolvimento
								</h2>
								<div class="panel-toolbar">
									<button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
								</div>
							</div>
							<div class="panel-container show">
								<div id="div-2" class="panel-content"></div>
							</div>
						</div>	

						<div class="panel">
							<div class="panel-hdr color-warning-800">
								<h2>
									Metodologia
								</h2>
								<div class="panel-toolbar">
									<button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
								</div>
							</div>
							<div class="panel-container show">
								<div class="panel-content">

								<textarea class="textArea" rows="10" <%if strValidado = "S" then response.Write("disabled") %> id="txtMetodologia" name="txtMetodologia"></textarea>
								<button id="btnMetodologia" type="button" <%if strValidado = "S" then response.Write("disabled") %> class="btn btn-success btn-pills btn-sm btn-block waves-effect waves-themed salvar">Salvar alterações</button>
								</div>
							</div>
						</div>	

						<div class="panel">
							<div class="panel-hdr color-warning-800">
								<h2>
									Avaliação
								</h2>
								<div class="panel-toolbar">
									<button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
								</div>
							</div>
							<div class="panel-container show">
								<div class="panel-content">
									<textarea class="textArea" <%if strValidado = "S" then response.Write("disabled") %> rows="10" id="txtAvaliacao" name="txtAvaliacao"></textarea>
									<button id="btnAvaliacao" <%if strValidado = "S" then response.Write("disabled") %> type="button" class="btn btn-success btn-pills btn-sm btn-block waves-effect waves-themed salvar">Salvar alterações</button>
								</div>
							</div>
						</div>																


                    </div>
                </div>
            </div>        
        </div>
    </div>
	<%
	
	if strAcessoPerfil <> "COORDENADOR" then
		bloqueiaComboAlteracao = "disabled"
	end if
	if strValidado = "S" then
		bloqueiaComboAlteracao = "disabled"
	end if
	%>

	<div class="row">
		<div class="col-xl-12">
			<div class="panel">
				<div class="panel-hdr color-warning-800">
					<h2>
						Validação do Coordenador
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Validado</label>
										<select <%=bloqueiaComboAlteracao%> name="cmbValidado" class="form-control" id="cmbValidado">
											<option value="N" <%if strValidado = "N" then response.Write("selected") %>>NAO</option>
											<option value="S" <%if strValidado = "S" then response.Write("selected") %>>SIM</option>
										</select>
								</div>								
							</div>
						</div>								
							
						<div class="row">
							<div class="col-sm-12">
							
								<div class="panel-container show">
								
									<div class="panel-content">
										<label class="form-label">Observação</label>
										<textarea <%=bloqueiaComboAlteracao%> class="textArea" rows="10" id="txtObservacao" name="txtObservacao"><%=strObservacao%></textarea>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="panel-container show">
									<div class="panel-content">
										<%if strAcessoPerfil = "COORDENADOR" and bloqueiaComboAlteracao="" then%><button id="btnObservacao" type="button" onClick="validar('<%=intCodigoPlanejamentoProfessor%>')"  class="btn btn-success btn-pills btn-sm btn-block waves-effect waves-themed">Validar Planejamento</button><%end if%>
									</div>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="panel-container show">
									<div class="panel-content">
										<%if bloqueiaComboAlteracao="" then%><button id="btnExcluirPlanejamento" type="button" onClick="excluir('<%=intCodigoPlanejamentoProfessor%>')"  class="btn btn-danger btn-pills btn-sm btn-block waves-effect waves-themed">Excluir Planejamento</button><%end if%>
									</div>
								</div>
							</div>
							
							<%
										'if ucase(trim(session("usuarioWeb"))) = "03210691100" then
										''Session("NivelPermissao") = "A"
										'	response.write "Session(NivelPermissao)=" & Session("NivelPermissao") & "<br>"
										'	response.write "bloqueiaComboAlteracao=" & bloqueiaComboAlteracao & "<br>"
										'	response.write "intCodigoPlanejamentoProfessor=" & intCodigoPlanejamentoProfessor & "<br>"
										'	response.write "strAcessoPerfil=" & strAcessoPerfil
										'end if		
										
							if Session("NivelPermissao") = "A" then%>
							
							<div class="col-sm-4">
								<div class="panel-container show">
									<div class="panel-content">
									
										<%
																			

										if bloqueiaComboAlteracao<>"" then%>

										<%
										if intCodigoPlanejamentoProfessor = "" then intCodigoPlanejamentoProfessor = 0
											'verifica se já existe conteúndo-ministrado. Caso exista, não permitir a exlusão
											sql="select * from SCA_CONTEUDO_MINISTRADO_PROFESSOR"
											sql=sql & " where cod_planejamento_professor =" & intCodigoPlanejamentoProfessor
											rs.open sql, cnn
											if rs.eof then
												if strAcessoPerfil<> "PROFESSOR" then
												%>
													<button id="btnCancelaraValidacao" type="button" onClick="cancelar('<%=intCodigoPlanejamentoProfessor%>')"  class="btn btn-info btn-pills btn-sm btn-block waves-effect waves-themed">Cancelar Validação</button>											
												<%
												end if
											else 
												%>
													<button id="btnCancelaraValidacao" type="button" class="btn btn-warning btn-pills btn-sm btn-block waves-effect waves-themed">Não é possível excluir a validação.</button>	
												<%
											end if
											rs.close										
											%>

										<%end if%>
									</div>
								</div>
							</div>
							<%end if%>
						</div>
						
						<%if Session("NivelPermissao") = "A" then%>
							<div class="row">
								<div class="col-sm-12">
								
									<div class="panel-container show">
									
										<div class="panel-content">
											<label class="form-label">Observação da Secretaria</label>
											<textarea <%=bloqueiaComboAlteracao%> class="textArea" rows="10" id="txtObservacaoSecretaria" name="txtObservacaoSecretaria"><%=strObservacaoSecretaria%></textarea>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-4">
									<div class="panel-container show">
										<div class="panel-content">
											<%if bloqueiaComboAlteracao="" then%><button id="btnObservacaoSecretaria" type="button" onClick="salvarObservacaoSecretaria('<%=intCodigoPlanejamentoProfessor%>')"  class="btn btn-success btn-pills btn-sm btn-block waves-effect waves-themed">Salvar Observação</button><%end if%>
										</div>
									</div>
								</div>
							</div>
						<%end if%>
						<%
						if intCodigoPlanejamentoProfessor <> "" then
							sql = "select u.USUA_NOME_COMPLETO as incluido_por, p.data_hora_incl, u1.USUA_NOME_COMPLETO as validado_por, p.data_hora_validado, 	u2.USUA_NOME_COMPLETO as alterado_por, p.data_hora_altr"
							sql = sql & " from SCA_PLANEJAMENTO_PROFESSOR p"
							sql = sql & " left join SEG_USUARIOS_SISTEMA u on u.USUA_CODG = p.usuario_incl"
							sql = sql & " left join SEG_USUARIOS_SISTEMA u1 on u1.USUA_CODG = p.usuario_validado"
							sql = sql & " left join SEG_USUARIOS_SISTEMA u2 on u2.USUA_CODG = p.usuario_altr"
							sql = sql & " where cod_planejamento_professor=" & intCodigoPlanejamentoProfessor
							'response.write sql
							rs.open sql, cnn
							if not rs.eof then
								incluido_por = ucase(rs("incluido_por"))
								alterado_por = ucase(rs("alterado_por"))
								data_alterado = rs("data_hora_altr")
								if alterado_por <> "" then
									if incluido_por = alterado_por then
										alterado_por = ""
										data_alterado = ""
									end if
								end if
								data_incluido = rs("data_hora_incl")
								validado_por = ucase(rs("validado_por"))
								data_validado = rs("data_hora_validado")
							%>
							<div id="card_inclusao" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_inclusao > .card-inclusao" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Inclusão/Validação&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Inclusão/Validação&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-inclusao p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										<div class="row">
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Incluído por</label>
													<input readonly name="incluido_por" type="text" class="form-control" id="incluido_por" size="100" maxlength="50" value="<%=incluido_por%>">
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Data inclusão</label>
													<input readonly name="data_incluido_por" type="text" class="form-control" id="data_incluido_por" size="100" maxlength="50" value="<%=data_incluido%>">
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Alterado por</label>
													<input readonly name="alterado_por" type="text" class="form-control" id="alterado_por" size="100" maxlength="50" value="<%=alterado_por%>">
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Data Alteração</label>
													<input readonly name="data_alterado_por" type="text" class="form-control" id="data_alterado_por" size="100" maxlength="50" value="<%=data_alterado%>">
												</div>
											</div>												
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Validado por</label>
													<input readonly name="validado_por" type="text" class="form-control" id="validado_por" size="100" maxlength="50" value="<%=validado_por%>">
												</div>
											</div>
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Data validação</label>
													<input readonly name="data_validado" type="text" class="form-control" id="data_validado" size="100" maxlength="50" value="<%=data_validado%>">
												</div>
											</div>											
										</div>							
																	
									</div>
								</div>
							</div>
							<%
							end if
							rs.close
						end if
						%>
					</div>
				</div>
			</div>
		</div>
	</div>				
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>