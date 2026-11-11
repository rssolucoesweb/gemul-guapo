<%

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

    intCodAula 				= Trim(Request.querystring("aula")) 
	bolAulaExtra 			= Trim(Request("bolAulaExtra"))

	dataAula                = Trim(Request("dataAula"))

	retorno 				= Trim(Request.querystring("retorno")) 

	SESSION("controlePeriodoDeTempo") = 2

	'PERFIL COORDENADORES - 17
	'PERFIL PROFESSORES   - 11
	'PERFIL ADMINISTRADOR - 2	
	strCodPefilAcesso = "17,2,11"
%>
<!--#include file="includes/inc_VerificaAcessoPerfilAdmProfessor.asp"-->
<%
	if (strAcessoPerfil="FOIRETIRADOESSAVALIDACAO") then
		%>
		<script>
			alert("Essa funcionalidade do Planejamento do professor por turma, deve ser utilizada pelo professor ou coordenador, você deverá ter acesso a algum desse perfil!")
			window.history.back();
		</script>
		<%
		response.end
	end if
%>
<%
if dataAula<> "" and intCodAula<>"" then
	'CORRIGE PROBLEMA DA DATA DA AULA NO CONTEUDO MINISTRADO
	sql="update cm"
	sql=sql & " set cm.data_aula = '" & formataDataBD(dataAula) & "'"
	sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
	sql=sql & " inner join SCA_CONTEUDO_MINISTRADO_PROFESSOR cm"
	sql=sql & " on pp.cod_planejamento_professor = cm.cod_planejamento_professor"
	sql=sql & " where pp.cod_empresa =" & session("CodEmpresa")	
	'sql=sql & " and pp.cod_colaborador =" & intCodProfessor
	sql=sql & " and pp.anoLetivo =" & strAnoLetivo
	sql=sql & " and pp.semestre =" & strSemestre
	sql=sql & " and pp.numero_aula =" & intCodAula
	sql=sql & " and pp.cod_disciplina =" & intCodDisciplina
	sql=sql & " and pp.cod_turma =" & intCodTurma
	'sql=sql & " and cm.data_aula is null"
	sql=sql & " and pp.data_aula_extra is null"
	if ucase(session("usuarioweb")) = "SERGIO" then
		response.write sql
		cnn.execute sql
	end if
end if
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
                        'response.write sql
                        rs.open sql, cnn
                        if rs.eof = false then
                            intCodigoPlanejamento = rs("cod_planejamento_geral")
                        end if
                        rs.close

						sql="select cod_planejamento_geral, cod_situacao_planejamento from SCA_PLANEJAMENTO_GERAL"
						sql=sql & " where cod_planejamento_geral_pai=" & intCodigoPlanejamento
						sql=sql & " and cod_empresa = " & session("codEmpresa")	
						rs.open sql, cnn
						if rs.eof = false then
							intCodigoPlanejamentoEscola = rs("cod_planejamento_geral")
						end if
						rs.close

						'verifica se já tem planejamento do professor para a aula informada
						strDataValidado = ""
						sql="select cod_planejamento_professor, validado, desc_conteudo_complementar, observacao from SCA_PLANEJAMENTO_PROFESSOR"
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
						'response.write sql
						rs.open sql, cnn
						if rs.eof = false then
							intCodigoPlanejamentoProfessor = rs("cod_planejamento_professor")
							strValidado = rs("validado")
							strObservacao = rs("observacao")							
							strConteudoComplementar = rs("desc_conteudo_complementar")
						end if
						rs.close	

						'valida periodo autorizado para preenchimento
						intQtdeDias = 0
						sql="select quantidade_dias from SCA_CONTEUDO_MINISTRADO_Periodo"
						rs.open sql, cnn
						if rs.eof = false then
							intQtdeDias = rs("quantidade_dias")
						end if
						rs.close						
						
						'valida periodo autorizado para preenchimento
						intQtdeDias = 0
						strBloqueio = "H"
						sql="select quantidade_dias, bloqueio from SCA_CONTEUDO_MINISTRADO_Periodo"
						rs.open sql, cnn
						if rs.eof = false then
							intQtdeDias = rs("quantidade_dias")
							strBloqueio = rs("bloqueio")
						end if
						rs.close
						
						strDataBase = cdate(formataDataBD(datediff("d",intQtdeDias, formataDataBD(date))))

						if not bolAulaExtra then

							if cdate(formataDataBD(dataAula)) >= strDataBase and cdate(formataDataBD(dataAula)) <= cdate(formataDataBD(date)) then
								bolPeriodoValido = true
							else
								bolPeriodoValido = false
							end if

						else
							if cdate(formataDataBD(intCodAula)) >= strDataBase and cdate(formataDataBD(intCodAula)) <= cdate(formataDataBD(date)) then
								bolPeriodoValido = true
							else
								bolPeriodoValido = false
							end if							
						end if					
							
						'quando tiver desabilitado a validação do conteudo ministrado
						if strBloqueio = "D" then
							bolPeriodoValido = true
						end if
						
						if strValidado <> "S" then
							if bolPeriodoValido = false then
								strValidado = "S"
							end if						
						end if																	
						
						'-----------------------
						'temporario retirar em janeiro
						'foi colacado fixo e deve ser retirado
						'bolPeriodoValido = true
						'----------------------------
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
							<input name="txtHiddenAula"		 type="hidden" value="<%=intCodAula%>" 			id="txtHiddenAula">
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
										<input type="text" id="txtDataAula" name="txtDataAula" class="form-control" value="<%=dataAula%>" disabled >
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
										<label class="form-label">Aula</label>
										<input type="text" id="txtAula" name="txtAula" class="form-control" value="<%=intCodAula%>" disabled >
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
									pagina_anterior = "sca_planejamento_professor.asp?pagina=cm"
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
		<strong>Atenção!</strong> Esta aula está fora do período autorizado para o cadastro de conteúdo ministrado (<%=formataDataAP(datediff("d",intQtdeDias,formataDataBd(date)))%> a <%=formataDataAP(date)%>).
	</div>
	<%end if%>	

    <div class="row">

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
									Conteúdo Planejado
								</h2>
								<div class="panel-toolbar">
									<button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
								</div>
							</div>
							<div class="panel-container show">
								<div id="div-2" class="panel-content"></div>
							</div>
						</div>                 

                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">

						<div class="panel">
							<div class="panel-hdr color-warning-800">
								<h2>
									Outros Conteúdos
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
                                                    <option value="1">1° Bimestre</option>
                                                    <option value="2">2° Bimestre</option>
                                                    <option value="3">3° Bimestre</option>
                                                    <option value="4">4° Bimestre</option>
                                                    <option value="5">Unico</option>
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
                </div>

                
            </div>        
        </div>

        <div class="col-xl-6"> 
            
            <div class="panel">
                <div class="panel-hdr color-warning-800">
                    <h2>
                        Conteúdo Ministrado
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">                
                        <div style="padding-top:20px" id="divListaConteudoMinistrado"></div>
                    </div>
                </div>
                
            </div>   
			
            <div class="panel">
                <div class="panel-hdr color-warning-800">
                    <h2>
                        Conteúdos Complementares
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    </div>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">                
                        <textarea id="txtConteudoComplementar" name="txtConteudoComplementar" style="width: 100%; height: 100px ;"><%=strConteudoComplementar%></textarea>
						<%if bolPeriodoValido then%>
						<button id='btnSalvarConteudoComplementar' type='button' class='btn btn-success btn-pills btn-sm btn-block waves-effect waves-themed salvar' onClick='salvaConteudoComplementar(<%=intCodigoPlanejamentoProfessor%>)'>Salvar Conteúdo Complementar</button>
						<%end if%>
                    </div>
                </div>
                
            </div>	
			<%if bolPeriodoValido then%>
            <div class="panel">
                <div class="panel-hdr color-warning-800">
                    <h2>
                        Replicar conteúdo Ministrado
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel waves-effect waves-themed" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    </div>					
                </div>

                <div class="panel-container show">
                    <div class="panel-content">     
						<form method="post" id="frmReplicar">
							<div id="divListaTurmas"></div>           
							<button id='btnReplicar' type='button' class='btn btn-primary btn-pills btn-sm btn-block waves-effect waves-themed salvar' onClick='replicar()'>Replicar</button>
						</form>
                    </div>
                </div>
                
            </div>				
			<%end if%>
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
						
						
					</div>
				</div>
			</div>
		</div>
	</div>		
				
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>