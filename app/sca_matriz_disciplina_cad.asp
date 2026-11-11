<%
	acao = "I"

	
	if  Trim(Request("txtMatricula")) <> "" then
		strMostraBotaoImprimir	= "S"
	end if	
	strExecutarSubmitCurso	  			= "S"
	strExecutarSubmitPeriodo  			= "S"
	strExecutarSubmitTurno	  			= "S"
	strExecutarSubmitSemestre 			= "S"
	strExecutarSubmitTurma	  			= "S"
	strExecutarSubmitSitDisciplina      = "S"
	strReloadDisciplinaRem				= "S"
	strExecutarSubmitGradeCurricular 	= "S"
	strExecutarDisciplinaGrade 			= "S"
	strExecutarSubmitSituacaoPromocaoSemCriterio = "S"
	strBotaoEcluirDiscGradeAluno = ""	
	mostra_botao_arquivo_notas = "S"
	
	' Consulta a Categoria Colaborador
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaTipolancamento = "Professor"
	else
		strVerificaTipolancamento = ""
	end if
	rs.close
	
	intCodigo = Trim(Request.Form("txtCodigo"))
	
	if  session("NivelPermissao") <> "A" then
		strSemestre 						= session("strSemestre")
		intSemestre 						= session("strSemestre")
		strAnoLetivo 						= session("strAnoLetivo")
	else
		intSemestre 						= Trim(Request.Form("cmbSemestre"))
		strSemestre 						= Trim(Request.Form("cmbSemestre"))
		strAnoLetivo 						= Trim(Request.Form("txtAnoLetivo"))
	end if	
	if strSemestre = "" then strSemestre = session("strSemestre")
	if intSemestre = "" then intSemestre = session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	
	strCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula 						= Trim(Request("txtMatricula"))
	strNomealuno 						= Trim(Request("txtNomealuno"))

	intCodCurso	 						= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 						= Trim(Request.Form("cmbPeriodo"))
	intCodGrade 						= Trim(Request.Form("cmbGrade"))
	
	intCodDisciplinaGrade				= Trim(Request.Form("cmbDisciplinaGrade"))
	strFiltraTurmasGrade				= Trim(Request("txtFiltraTurmasGrade"))
	intCodTurmaGradeRemanejamento   	= Trim(Request.Form("cmbTurmaGradeRemanejamento"))
	strSituacaoDisciplina 				= Trim(Request.Form("cmbSituacaoDisciplina"))
    strSituacaoPromocao 				= Trim(Request("cmbSituacaoPromocao"))
	strSituacaoPromocaoTodos			= Trim(Request("txtSituacaoPromocaoTodos"))

	intCodTurmaRemejamento				= Trim(Request.Form("cmbTurmaRem"))
	intCodGradeRemanejamento			= Trim(Request.Form("cmbGradeRemanejada"))
	intCodDisciplinaRemanejamento 		= Trim(Request.Form("cmbDisciplinaRemanejamento"))

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodGradeRemanejamento = "" then intCodGradeRemanejamento 		= "0"
	
	if intCodTurmaRemejamento 	= "" then intCodTurmaRemejamento 		= "0"
	if intCodDisciplinaRemanejamento = "" then intCodDisciplinaRemanejamento 		= "0"
	
	strMostraAlunos = ""

	strBloqueiaInclusaoDisciplinar = ""
	sql = " SELECT top 1 isnull(Limite_Inclusao_Disciplinar,'99') as Limite_Inclusao_Disciplinar "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strLimiteInclusaoDisciplinar  = trim(rs("Limite_Inclusao_Disciplinar"))
	end if
	rs.close

	strMsgExisteHorario  	= ""
	strFlagExisteHorario 	= "S"
	sql = " SELECT TOP 1 CODIGO FROM SCA_HORARIO_AULA "  
	sql = sql & " WHERE AnoLetivo = " & strAnoLetivo  
	sql = sql & " AND Semestre = " & intSemestre  
	rs.Open SQL, cnn
	if rs.EOF = false then
	else								
		strMsgExisteHorario  	= " - Hor&aacute;rio n&atilde;o cadastrado para o ano e semestre informado."
		strFlagExisteHorario 	= "N"
	end if
	rs.close


 	strSituacaoAluno = ""
	if strMatricula <> "" then
		
		sql = " SELECT TOP 1"
		sql = sql & " A.CODIGO,"	
		sql = sql & " A.MATRICULA,"	
		sql = sql & " A.NOMEALUNO,"
		sql = sql & " C.Cod_curso,"
		sql = sql & " C.DESCRICAO AS CURSO,"
		sql = sql & " C.SIGLA,"
		sql = sql & " C.Gerenciar_Acompanhamento,"
		sql = sql & " P.DESCRICAO AS PERIODO,"
		sql = sql & " AT.COD_TURMA AS TURMA_ATUAL, T.COD_TURNO AS TURNO_ATUAL, T.cod_gradecurricular, P.Cod_Periodo, C.Tipo_Modulacao,"
		sql = sql & " SA.Desc_SituacaoAluno"
		sql = sql & " FROM SCA_ALUNO A"
		SQL = SQL & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO " 'AND AA.SITUACAO='A' "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
		sql = sql & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND AA.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
		sql = sql & " LEFT JOIN SCA_PERIODO P ON GC.COD_PERIODO = P.COD_PERIODO "
		sql = sql & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO"
		sql = sql & " LEFT JOIN SCA_GRAU G ON G.COD_GRAU = C.COD_GRAU"
		sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = A.UFRESIDENCIA"
		sql = sql & " LEFT JOIN SCF_UF UFI ON UFI.CODIGO = A.IDENTIDADEUF"
		sql = sql & " WHERE A.MATRICULA = " & strMatricula
		sql = sql & " AND AA.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " Order BY AT.CODIGO DESC "
		rs.open sql, cnn
		'response.write sql
		'response.end
		if rs.eof = false then
			strCodAluno						= Trim(rs("CODIGO"))
			strMatricula 					= Trim(rs("Matricula"))
			strNomealuno 					= Trim(rs("Nomealuno"))
			''intCodCurso 					= Trim(rs("Cod_curso"))
			strGerenciarAcompanhamento 		= Trim(rs("Gerenciar_Acompanhamento"))
			intTurmaAtual       			= Trim(rs("TURMA_ATUAL"))
			intTurnoAtual       			= Trim(rs("TURNO_ATUAL"))
			strTipoModulacao				= trim(rs("Tipo_Modulacao"))
			strSituacaoAluno				= TRIM(rs("Desc_SituacaoAluno"))
			'intCodGrade			 	= Trim(rs("cod_gradecurricular"))
			''intCodPeriodo	    	= Trim(rs("Cod_Periodo"))	
			strBotaoExcluirDiscGradeAluno= "S"
			acao = "I"
		end if
		rs.close	
		
	end if

	
		
	
	if trim(intCodigo) <> "" then
		
		sql = " SELECT AL.COD_EMPRESA, AL.COD_ALUNO, AL.COD_TURMA, AL.COD_TURMA_REMANEJAMENTO, "
		sql = sql & " AL.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, AL.COD_SITUACAO_ACADEMICA,"
		sql = sql & " AL.COD_GRADECURRICULARDISCIPLINA, AL.SITUACAO, "
		sql = sql & " P.Cod_Periodo, GC.Cod_GradeCurricular,"
		sql = sql & " GCD.Cod_Disciplina, GCD1.Cod_Disciplina as DisciplinaRemanejamento "
		sql = sql & " FROM SCA_ALUNO_DISCIPLINA AL "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AL.COD_TURMA AND T.COD_EMPRESA = AL.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = GC.COD_PERIODO "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDISCIPLINA = AL.COD_GRADECURRICULARDISCIPLINA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD1 ON GCD1.Cod_GradeCurricularDISCIPLINA = AL.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"

		sql = sql & " where AL.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " and AL.CODIGO = " & intCodigo
			
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodGrade										= rs("Cod_GradeCurricular")
			intCodPeriodo									= rs("Cod_Periodo")
			intCodTurmaGradeRemanejamento					= rs("COD_TURMA")
			strSituacaoDisciplina							= rs("SITUACAO")
			intCodDisciplinaGrade							= rs("Cod_Disciplina")
			
			if strTipoModulacao = "P" then
				if intCodDisciplinaRemanejamento = "0" or intCodDisciplinaRemanejamento = "" then
					intCodDisciplinaRemanejamento						= rs("DisciplinaRemanejamento")
				end if
		
				if intCodTurmaRemejamento = "0" or intCodTurmaRemejamento = "" then
					intCodTurmaRemejamento					= rs("COD_TURMA_REMANEJAMENTO")
				end if
			else
				intCodDisciplinaRemanejamento				= rs("DisciplinaRemanejamento")
				intCodTurmaRemejamento						= rs("COD_TURMA_REMANEJAMENTO")

				if strSituacaoPromocao = "0" or strSituacaoPromocao = "" then
					strSituacaoPromocao					= rs("COD_TURMA_REMANEJAMENTO")
				end if

			end if	

			strCodGradeCurricularDisciplina					= rs("COD_GRADECURRICULARDISCIPLINA")
			strCodGradeCurricularDisciplinaRemanejamento	= rs("COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO")
			
			acao = "A"

		end if 
		rs.close
		
	end if
	
	if strMatricula <> "" then
		if strSituacaoAluno <> "ATIVO" then
			%>
			<script>
				alert("Situacao Academica nao Permitida, verifique se o mesmo esteja ATIVO.");
			</script>
			<%
			acao = ""
		end if
	end if
	
	if intCodTurmaRemejamento = "0" then intCodTurmaRemejamento = intCodTurmaGradeRemanejamento
	if intCodDisciplinaRemanejamento = "0" then intCodDisciplinaRemanejamento = intCodDisciplinaGrade
	
	if intCodTurmaOrigem = "0" then intCodTurmaOrigem = intCodTurmaGradeRemanejamento
	if strNomeTurmaOrigem = "0" then strNomeTurmaOrigem = strNomeTurma
	
	if trim(intSemestre) = "" or  trim(intSemestre) = "0"  then intSemestre  = session("strSemestre")
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post">
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
						
						
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group"><strong>Matrícula do Aluno</strong></label>
										<div class="input-group">
											<input type="text" class="form-control" value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
											<div class="input-group-append">
												<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsulta('sca_aluno_con.asp')" ><i class="fal fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-9">
									<div class="form-group">
										<label class="form-label"></label>
										<input type="text" name="txtNomealuno" readonly id="txtNomealuno" class="form-control" value="<%=strNomeAluno%>">
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Ano letivo</label>
										<input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
									</div>
								</div>	
								
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Semestre</label>
										<!--#include file="includes/inc_cmdSemestre.asp" -->
									</div>
								</div>	
							
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<!--#include file="includes/inc_cmdCurso.asp" -->
									</div>
								</div>	
								<%
								if request.Form("txtHiddenStatus") <> "" then
								   strDesabilitaSerie = "disabled"
								end if
								%>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Período</label>
										<!--#include file="includes/inc_cmdPeriodo.asp" -->
									</div>
								</div>	
							</div>
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Matriz</label>
										<!--#include file="includes/inc_cmdGradeCurricular.asp" -->
									</div>
								</div>	
								
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Disciplina</label>
										<!--#include file="includes/inc_cmdDisciplinaGrade.asp" -->
									</div>
								</div>	
							
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Situação disciplinar</label>
										<!--#include file="includes/inc_cmdSituacaoDisciplina.asp" -->
									</div>
								</div>	
								
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Turma - Disponível no Horário</label>
										<!--#include file="includes/inc_cmdTurmaGradeRemanejamento.asp" -->
										<span>
											Listar Todas as Turmas?
											<input <%if trim(strFiltraTurmasGrade) = "S" then response.Write("checked")%>  type="checkbox" name="txtFiltraTurmasGrade" value="S" onClick="submit()"> <%=strMsgExisteHorario%>        
										</span>
									</div>
								</div>	
							</div>
							<br>
							<input  name="txtCodGrade" type="hidden" class="text" id="txtCodGrade"   value="<%=strCodGradeCurricularDisciplina%>" size="10" maxlength="10" >
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Dados Remanejamento ( Opcional )</strong></span>
								</div>	
							</div>					
							<br>
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Remanejamento - Turmas no Hor&aacute;rio</label>
										<!--#include file="includes/inc_cmdTurmaRem.asp"-->
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Matriz Curricular</label>
										<!--#include file="includes/inc_cmdGradeCurricularRemanejada.asp"-->
									</div>
								</div>	
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Disciplina Remanejada</label>
										<!--#include file="includes/inc_cmbDisciplinaRemanejada.asp"-->
										<input  name="txtCodGradeRemanejamento" type="hidden" class="text" id="txtCodGradeRemanejamento"   value="<%=strCodGradeCurricularDisciplinaRemanejamento%>" size="10" maxlength="10" >
									</div>
								</div>	
								
							</div>	
							<br>
							
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							
						
					</div>
				</div>
			</div>
		</div>
	</div>

	<%
if strCodAluno <> "" then
			 
			    if strGerenciarAcompanhamento = "A" then
			

					sql = " Select sum(ch_horas) as CH_Aluno, Count(ch_horas) as TotalDisciplina_ALuno "
					sql = sql & " From sca_aluno_disciplina ad "
					sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
					sql = sql & " where ad.cod_aluno = " & strCodAluno
					sql = sql & " and ad.situacao <> 'AD'"
					rs.open sql, cnn		
					if not rs.eof then
						intCHAluno 				=  rs("CH_Aluno")
						intTotalDisciplinaALuno	=  rs("TotalDisciplina_ALuno")
						if isnull(intCHAluno) then intCHAluno = 0
						if isnull(intTotalDisciplinaALuno) then intTotalDisciplinaALuno = 0
					end if			
					rs.close
	
					sql = " SELECT sum(ch_horas) as CH_Matriz, Count(ch_horas) as TotalDisciplina_Matriz "
					sql = sql & " FROM SCA_TURMA T "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular and GC.Situacao='A' "
					sql = sql & " WHERE Cod_Turma = " & intTurmaAtual
					rs.open sql, cnn		
					if not rs.eof then
						intCHMatriz 		    	=  rs("CH_Matriz")
						intTotalDisciplinaMatriz	=  rs("TotalDisciplina_Matriz")
						if isnull(intCHMatriz) then intCHMatriz = 0
						if isnull(intTotalDisciplinaMatriz) then intTotalDisciplinaMatriz = 0
					end if			
					rs.close
					
					if Session("NivelPermissao") <> "A" then
	
						if intTotalDisciplinaALuno > strLimiteInclusaoDisciplinar then
							%>
							<script>
								alert("Foi atingido o numero máximo de inclusões, procure a Secretaria Geral.");
							</script>
							<%
							strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
							strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
							strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
						end if

					end if	
	
					TotalInclusoes = 0
					ValorAcrescimo = 0
					ValorFinal = 0
					if intCHAluno > intCHMatriz then TotalInclusoes = 1
					if intTotalDisciplinaALuno >  intTotalDisciplinaMatriz then 
					   TotalInclusoes = intTotalDisciplinaALuno - intTotalDisciplinaMatriz
					end if 
					if intCHAluno <= intCHMatriz then TotalInclusoes = 0  
					ValorAcrescimo = ((ValorApagar1 * 25 ) / 100) * TotalInclusoes
					ValorFinal = ValorAcrescimo + ValorApagar1

				else
				
					if intPlanoPagamento <> "" then 

				        ' Primeiro Valor do Aluno
						ValorApagar1 = "0"
						sql = " select top 1 valor1, valor2, valor3, valor4 from scf_planoparcela "
						sql = sql & " where cod_plano = " & intPlanoPagamento
						sql = sql & " and ano = " & strAnoLetivo
						sql = sql & " and CodSemestre = " & intSemestre
						sql = sql & " order by Ano, parcela desc "
						rs.open sql, cnn
						if rs.eof = false then
							ValorApagar1 = Trim(rs("valor1"))
							if ValorApagar1 = "" or isnull(ValorApagar1) then ValorApagar1 = "0"
						end if   
						rs.close

					    ' Base de Calculo para achar hora aula - Valor bruto
						ValorApagarBruto = "0"
						sql = " select top 1 valor1, valor2, valor3, valor4 from scf_planoparcela "
						sql = sql & " where cod_plano = " & intPlanoPagamento
						sql = sql & " and ano = " & strAnoLetivo
						sql = sql & " and CodSemestre = " & intSemestre
						sql = sql & " order by Ano, parcela desc "
						rs.open sql, cnn
						if rs.eof = false then
						    ValorApagarBruto = Trim(rs("valor4"))
						    if isnull(rs("valor4")) or rs("valor4") = "" then ValorApagarBruto = Trim(rs("valor3"))
						    if isnull(rs("valor3")) or rs("valor3") = "" then ValorApagarBruto = Trim(rs("valor2"))
						    if isnull(rs("valor2")) or rs("valor2") = "" then ValorApagarBruto = Trim(rs("valor1"))
							if ValorApagarBruto = "" or isnull(ValorApagarBruto) then ValorApagarBruto = "0"
							
							ValorApagarBruto = Trim(rs("valor1"))
							
						end if   
						rs.close

					end if	
	
					sql = " Select sum(ch_horas) as CH_Aluno, Count(ch_horas) as TotalDisciplina_ALuno "
					sql = sql & " From sca_aluno_disciplina ad "
					sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
					sql = sql & " where ad.cod_aluno = " & strCodAluno
					sql = sql & " and ad.situacao <> 'AD'"
					rs.open sql, cnn		
					if not rs.eof then
						intCHAluno 				=  rs("CH_Aluno")
						intTotalDisciplinaALuno	=  rs("TotalDisciplina_ALuno")
						if isnull(intCHAluno) then intCHAluno = 0
						if isnull(intTotalDisciplinaALuno) then intTotalDisciplinaALuno = 0
					end if			
					rs.close
	
					sql = " SELECT sum(ch_horas) as CH_Matriz, Count(ch_horas) as TotalDisciplina_Matriz "
					sql = sql & " FROM SCA_TURMA T "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular and GC.Situacao='A' "
					sql = sql & " WHERE Cod_Turma = " & intTurmaAtual
					rs.open sql, cnn		
					if not rs.eof then
						intCHMatriz 		    	=  rs("CH_Matriz")
						intTotalDisciplinaMatriz	=  rs("TotalDisciplina_Matriz")
						if isnull(intCHMatriz) then intCHMatriz = 0
						if isnull(intTotalDisciplinaMatriz) then intTotalDisciplinaMatriz = 0
					end if			
					rs.close
	
					if intTotalDisciplinaALuno > (intTotalDisciplinaMatriz + strLimiteInclusaoDisciplinar)  then
						%>
						<script>
							alert("Foi atingido o numero maximo de inclusoes, procure a Secretaria Geral.");
						</script>
						<%
						
						strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
						strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
						strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

					end if
					
					TotalInclusoes = 0
					ValorAcrescimo = 0
					ValorFinal = 0

					if intCHAluno > intCHMatriz then
					   if intCHMatriz > 0 then 
					   	  ValorAcrescimo = (ValorApagarBruto/intCHMatriz) * (intCHAluno - intCHMatriz)
					   else
					      ValorAcrescimo = 0
					   end if 
					   ValorFinal = ValorAcrescimo + ValorApagar1
					else
					   ValorFinal = ValorApagar1
					end if

				end if	

				sql = " Select ad.COD_TURMA_REMANEJAMENTO, ad.codigo, gcd.CH_horas,"
				sql = sql & " ad.cod_disciplina, ad.situacao, sp.DESCRICAO, "
				sql = sql & " d.desc_disciplina, gc.cod_periodo as Periodo_Disciplina, "
				sql = sql & " dr.desc_disciplina as desc_disciplinaRema ,"
				sql = sql & " t.cod_semestre, t.AnoLetivo, t.nometurma, t.turmaaluno, t.cod_gradecurricular, "
				sql = sql & " tr.nometurma as nometurmaRema, tr.turmaaluno as turmaalunorem "
				sql = sql & " From sca_aluno_disciplina ad "
				sql = sql & " left join sca_disciplina d on d.cod_disciplina = ad.cod_disciplina "
				sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
				sql = sql & " left join sca_gradecurricular gc on gc.Cod_GradeCurricular = gcd.Cod_GradeCurricular "
				sql = sql & " left join sca_disciplina dr on dr.cod_disciplina = gcd.Cod_Disciplina "
				sql = sql & " left join sca_turma t on t.cod_turma = ad.cod_turma "
				sql = sql & " left join sca_turma tr on tr.cod_turma = ad.COD_TURMA_REMANEJAMENTO "
				sql = sql & " left join SCA_PERIODO p ON p.Cod_Periodo = gc.Cod_Periodo"
				sql = sql & " left join SCA_SITUACAO_PROMOCAO sp ON sp.CODIGO = ad.COD_SITUACAO_ACADEMICA"
				sql = sql & " where	ad.cod_aluno = " & strCodAluno
				sql = sql & " order by p.sequencia, d.desc_disciplina"
				rs.open sql, cnn		
				if not rs.eof then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na disciplina abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th></th>
									<th><strong>Turma Curricular</strong></th>
									<th><strong>Disciplina</strong></th>
									<th><strong>Turma Remanejamento</strong></th>
									<th><strong>Disciplina Remanejamento</strong></th>
									<th><strong><strong>C.H horas</strong></strong></th>
									<th><strong>Ano Letivo</strong></th>
									<th><strong><strong>Semestre</strong></strong></th>
									<th><strong>Situa&ccedil;&atilde;o<Br>Curricular</strong></th>
									<th><strong>Situa&ccedil;&atilde;o<Br>
									Acad&ecirc;mica</strong></th>
									</tr>
								</thead>
								<tbody>
									<%
									id = 0
									while not rs.eof 
									
										strSituacaoDisciplinaAbreviado 	=  rs("situacao")
										intCodAlunoDisciplina 			=  rs("codigo")
										intCodTurmaRemejamento 			=  rs("COD_TURMA_REMANEJAMENTO")
										intCodGradeCurricular 			=  rs("cod_gradecurricular")
										
										
										if trim(rs("SITUACAO")) = "CR" then 
											strSituacao = "Curricular"
										end if
										
										if trim(rs("SITUACAO")) = "DE" then 
											strSituacao = "Dep./Acompanhamento"
										end if

										if trim(rs("SITUACAO")) = "AD" then 
											strSituacao = "Adapta&ccedil;&atilde;o"
										end if
										
										if trim(rs("SITUACAO")) = "DI" then 
											strSituacao = "Dispensa"
										end if
										if trim(rs("DESCRICAO")) = "" or isnull(rs("DESCRICAO")) then 
											strDescSituacaoAluno = "A CURSAR"
										else
											strDescSituacaoAluno =  "<font color='#FF0000'>" & rs("DESCRICAO") & "</font>"
										end if
										'
										'Parametros pra carregar Optativas
										'
										AnoLetivoMostraOptativa = strAnoLetivo
										SemestreMostraOptativa = intSemestre
										CursoMostraOptativa = trim(intCodCurso)
										PeriodoMostraOptativa = trim(rs("Periodo_Disciplina"))
										TurnoMostraOptativa = trim(intTurnoAtual)
										DisciplinaMostraOptativa = trim(rs("cod_disciplina"))    
										CodigoAlunoMostraOptativa = strCodAluno
										' Mensagem Carrega em: - (MsgOptativa)
										%>
										<!--#include file="includes/inc_MostraOptativas.asp"-->

										<tr>
											<td>
											<input id="cod_excluirDisc" name="cod_excluirDisc" type="checkbox" value="<%=rs("codigo")%>"></td>
											<td><%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></td>
											<td style="cursor:pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')" ><strong><%=rs("DESC_Disciplina")%></strong>&nbsp;<font color='#FF0000'><strong><%=MsgOptativa%></strong></font></td>
											<td><%=rs("TurmaAluno")%>&nbsp;&nbsp;<%=rs("nometurmaRema")%></td>
											<td><%=rs("desc_disciplinaRema")%></td>
											<td><%=rs("CH_Horas")%></td>
											<td><%=rs("anoletivo")%></td>
											<td><%=rs("cod_semestre")%></td>
											<td><%=strSituacao%>&nbsp;</td>
											<td><%=strDescSituacaoAluno%>&nbsp;</td>
										</tr>
										<%
										id = id + 1
										rs.movenext
									wend 
								end if			
								rs.close
								%>
									<tr>
										<td height="21" colspan="10" class="celula">Total Registros : <%=cont%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> 
	<%
end if	  
	%>
</form>	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>