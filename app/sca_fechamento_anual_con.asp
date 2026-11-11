<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	mostra_botao_resumo_turma_fechamento = "S"
	strSemestre 			= session("strSemestre")
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodGrade				= Trim(Request("cmbGrade"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplinaTurma  = trim(request("cmbDisciplinaTurma"))
	strSituacaoAluno  = trim(request("cmbSituacaoAluno"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"

	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, isnull(sca_turma.DesvincularCriterioAvaliacao,'N') as DesvincularCriterioAvaliacao"
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
		strDesvincularCriterioAvaliacao = rs("DesvincularCriterioAvaliacao")
	END IF
	rs.close


	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	TipoAtualizacao	= Trim(Request("cmbTipoAtualizacao"))

	if strMatricula <> "" then
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if
	if intCodTurma<> "" and intAnoLetivo<>"" then
		fechamento = "N"
		sql = "select codigo"
		sql = sql & " from SCA_FECHAMENTO_AGENDAMENTO"
		sql = sql & " where situacao = 'F'"
		sql = sql & " and COD_TURMA = " & intCodTurma
		sql = sql & " and ano_letivo = " & intAnoLetivo
		rs.open sql, cnn
		if rs.eof = false then
			fechamento = "S"
		end if
		rs.close
	end if
	strRetiraAtivo = "S" 'retira da combo os ativos

	'controla os botões
	acao = "I"
	
	'************************************************************
	'para aparecida canedo abadia
	'IF intCodCurso<>"" AND intCodCurso <> "0" THEN
	'	'carrega campos
	'	sql = "SELECT SCA_TIPO_AVALIACAO.posicao, SCA_TIPO_AVALIACAO.descricao"
	'	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	'	sql = sql & " INNER JOIN SCA_TIPO_CRITERIO ON SCA_TIPO_CRITERIO.CODIGO = SCA_TIPO_AVALIACAO.COD_TIPO_CRITERIO "
	'	sql = sql & " WHERE COD_CURSO = " & intCodCurso
	'	sql = sql & " AND bimestre NOT IN (6,7)"
	'	sql = sql & " AND DIGITAR = 'S'"
	'	sql = sql & " AND COD_TIPO_CRITERIO = 1 order by posicao"
	'	vetCampo = null
	'	rs.open sql, cnn
	'	if not rs.eof then
	'		vetCampo = rs.getRows
	'	end if
	'	rs.close
	'END IF
	'************************************************************

	intMediaAprovacao = 0
	IF intCodCurso<>"" AND intCodCurso <> "0" THEN
	'carrega campos
		sql="select c.posicao, c.descricao, ca.media_aprovacao, ca.num_disciplina_prog_parcial "', c.formula, c.digitar, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
		sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
		sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
		sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
		sql=sql & " where c.cod_tipo_lancamento not in (6,7) and c.DIGITAR = 'S' and ca.ano_letivo = " & strAnoLetivo
		sql=sql & " and ca.cod_curso = " & intCodCurso
		sql=sql & " order by c.posicao"
		
		IF trim(ucase(SESSION("USUARIOWEB"))) = "SERGIO" THEN
			'response.write sql 
			'response.end
		END IF
		vetCampo = null
		rs.open sql, cnn
		if not rs.eof then
			intMediaAprovacao 			= rs("media_aprovacao")
			intQtdeDisciplinaDependencia = rs("num_disciplina_prog_parcial")
			
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
	END IF
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_fechamento_anualCon.asp">
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
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-8" class="panel">
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
						<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
						<div class="row">
							
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo:</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Semestre:</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
							
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
							
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o Acad&ecirc;mica de Destino:</label>
									 <!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>
							
						</div>
						<br>
						<%
						if intCodTurma    = "" then intCodTurma="0"
						if intCodTurma = "0" then 
							acao = "" 
							retira_incluir="S"
						end if
						%>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp" -->
						</div>
						
						<div class="alert alert-danger alert-dismissible fade show">
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true"><i class="fal fa-times"></i></span>
							</button>
							<div class="d-flex align-items-center">
								<div class="alert-icon width-8">
									<span class="icon-stack icon-stack-xl">
										<i class="base-2 icon-stack-3x color-danger-400"></i>
										<i class="base-10 text-white icon-stack-1x"></i>
										<i class="ni md-profile color-danger-800 icon-stack-2x"></i>
									</span>
								</div>
								<div class="flex-1 pl-1">
									<span class="h2">
										Aviso importante!
									</span>
									<br>
									Após realizar o fechamento da turma, não será possível desfazê-lo. Portanto, é essencial que você faça a conferencia e imprima todos os documentos necessários antes de concluir o fechamento.
								</div>
							</div>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodTurma    = "" then intCodTurma="0"
	if intCodSemestre = "" then intCodSemestre="0"
	if intCodTurma<>"0" then%> 

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Lista de alunos
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">		
						<%if trim(strDesvincularCriterioAvaliacao) = "S" then%>
						<div class="panel-tag">
							Turma com o Critério de Avaliação <code>DESVINCULADO</code>.
						</div>
						<%end if%>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<%if fechamento = "N" then%>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
									<th><strong>Ficha Incompleta</strong></th>
									<%
										for i=0 to ubound(vetCampo,2)
										%>
											<th  class="tamanhoFonte"><strong><%=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ucase(vetCampo(1,i)),"BIMESTRE","BIM."),"TRIMESTRE","TRIM."),"CONSELHO DE CLASSE","C.CLASSE"),"MÉDIA FINAL","MÉDIA"),"MÉDIA DA RECUPERAÇÃO","M.RECUP.")%></strong></th>
										<%
										next
									%>
									<th  class="tamanhoFonte"><strong>Resultado</strong></th>
									<%end if%>
									<%if fechamento = "S" then%>
									<th  class="tamanhoFonte"><strong>Situação <%=strAnoLetivo%></strong></th>
									<th  class="tamanhoFonte"><strong>Situação Fechamento </strong></th>
									<th  class="tamanhoFonte"><strong>Resultado</strong></th>
									<%end if%>
									<th  class="tamanhoFonte"><strong>Processamento</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								strBloquearFechamento = ""
								'seleciona os alunos da turma
								'seleciona os alunos da turma - intCodTurma
								'sql = sqlAlunoTurma(intCodTurma, intCodDisciplinaTurma)
								if fechamento = "S" then
									sql = "SELECT DISTINCT cf.RESULTADO_FINAL, f.COD_ALUNO AS CODIGO, f.COD_TURMA AS COD_TURMA, A.NOMEALUNO, A.MATRICULA, SAA.DESC_SITUACAOALUNO AS SITUACAO_ATUAL, SAD.DESC_SITUACAOALUNO AS SITUACAO_DESTINO, NULL as pendencias, f.situacao, f.data_hora_incl as data_situacao, f.data_processamento "
									sql = sql & " FROM SCA_ALUNO A "
									sql = sql & " INNER join SCA_FECHAMENTO_AGENDAMENTO f on f.cod_aluno = a.codigo "
									sql = sql & " INNER join SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO cf on cf.COD_ALUNO = a.codigo and cf.COD_TURMA = f.COD_TURMA and cf.ANO_LETIVO = f.ANO_LETIVO and cf.COD_EMPRESA = f.COD_EMPRESA"
									sql = sql & " INNER join SCA_SITUACAOALUNO SAA ON SAA.Cod_SituacaoAluno = cf.COD_SITUACAOALUNO_ATUAL"
									sql = sql & " INNER join SCA_SITUACAOALUNO SAD ON SAD.Cod_SituacaoAluno = cf.COD_SITUACAOALUNO_DESTINO"
									sql = sql & " WHERE f.COD_EMPRESA = " & Session("CodEmpresa") 
									sql = sql & " AND f.COD_TURMA = " & intCodTurma	 
									sql = sql & " ORDER BY A.NOMEALUNO"
								else
									sql = " SELECT distinct "
									sql = sql & " SCA_ALUNO.CODIGO, "
									sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, "
									sql = sql & " SCA_ALUNO.NOMEALUNO, "
									sql = sql & " SCA_ALUNO_TURMA.COD_TURMA, "
									sql = sql & " SCA_GRADECURRICULAR.Cod_Periodo, "
									sql = sql & " SCA_TURMA.NomeTurma,"
									sql = sql & " SCA_TURMA.TURMAALUNO, "
									sql = sql & " isnull(("
									sql = sql & " select top 1 ss.Desc_SituacaoAluno"
									sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
									sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
									sql = sql & " where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA "
									sql = sql & " and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO"
									sql = sql & " and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO"
									sql = sql & " order by cs.codigo desc"
									sql = sql & " ),'ATIVO') as Desc_SituacaoAluno,"
									sql = sql & " isnull(("
									sql = sql & " select top 1 ss.COD_SituacaoAluno"
									sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
									sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
									sql = sql & " where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA "
									sql = sql & " and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO "
									sql = sql & " and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO"
									sql = sql & " order by cs.codigo desc"
									sql = sql & " ),'1') as COD_SITUACAOALUNOATUAL,"
									sql = sql & " SCA_TURMA.Cod_FichaDescritiva, "
									sql = sql & " 	(	select codigo from SCA_ALUNO where CODIGO=SCA_ALUNO_TURMA.COD_ALUNO "
									sql = sql & " 		and ( NOMEALUNO is null or DATANASCIMENTO is null or DATAMATRICULA is null or SEXOALUNO is null or CIDADENASCIMENTO is null or UFNASCIMENTO is null or NACIONALIDADE is null "
									sql = sql & " 		or COD_TIPONACIONALIDADE is null or COD_PROFISSAO is null or COD_ETNIA is null or MAE is null )"
									sql = sql & " 	) as pendencias,TC.DESCRICAO AS TIPO_CRITERIO, C.DESCRICAO AS CURSO, P.Cod_Curso, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.DesvincularCriterioAvaliacao, f.situacao "
									sql = sql & " FROM SCA_ALUNO "
									sql = sql & " INNER JOIN SCA_ALUNO_TURMA ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
									sql = sql & " LEFT JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
									sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
									sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON SCA_TURMA.Cod_GradeCurricular = G.Cod_GradeCurricular "
									sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
									sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO AND TAI.ANO_LETIVO = SCA_TURMA.ANOLETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_CALCULO"
									sql = sql & " left join SCA_FECHAMENTO_AGENDAMENTO f on f.cod_aluno = SCA_ALUNO_TURMA.COD_ALUNO and f.cod_turma = SCA_ALUNO_TURMA.COD_TURMA"
									sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")	
									sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma  
									sql = sql & " and SCA_ALUNO_TURMA.ANO_LETIVO = " & strAnoLetivo
									sql = sql & " and SCA_ALUNO_TURMA.SITUACAO in ('A','T','D','C')"
									sql = sql & " and SCA_TURMA.situacao = 'A' "

									if strSituacaoAluno <> "0" then

										sql = sql & " AND ("
										sql = sql & " select top 1 ss.Cod_SituacaoAluno"
										sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
										sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
										sql = sql & " where CS.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA "
										sql = sql & " and CS.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO "
										sql = sql & " and CS.ANO_LETIVO = SCA_ALUNO_TURMA.ANO_LETIVO"
										sql = sql & " order by cs.codigo desc"
										sql = sql & " ) = " & strSituacaoAluno
										
									end if

									sql = sql & " order by SCA_ALUNO.NOMEALUNO"	
								end if
									IF trim(ucase(SESSION("USUARIOWEB"))) = "SERGIO" THEN
										'response.write sql 
										'response.end
									END IF
								cont = 0
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1
										strCodAluno             = rs("CODIGO")
										intCodEmp               = Session("CodEmpresa") 
										strDesabilitaAluno 	  	= ""
										strSituacaoAluno 		= ""
										strMatricula		          = rs("MATRICULA")
										
										strAprovadoConselho = ""
										sql = "select codigo from SCA_ALUNO_APROVADO_CONSELHO where cod_aluno = " & strCodAluno
										sql = sql & " and cod_turma = " & intCodTurma
										'response.write sql & "<br>"
										rsAux1.open sql, cnn
										if not rsAux1.eof then
											strAprovadoConselho = "S"
										end if
										rsAux1.close
										
										
										if fechamento = "N" then
											strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
											
											strPendencias		  = rs("pendencias")
											if isnull(strPendencias) then 
												strPendencias = ""
											else
												strPendencias = "<a href=""sca_aluno.asp?txtCodAluno=" & strCodAluno & """ class=""pendencia""><button type=""button"" class=""btn btn-danger waves-effect waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-info-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""Aluno com ficha cadastral incompleta, clique para fazer o preenchimento."">Atenção!</button></a>"
												if strDesc_SituacaoAluno="ATIVO" THEN strBloquearFechamento = "P"
											end if
											
											if strDesc_SituacaoAluno<>"ATIVO" THEN
												strPendencias = ""
											end if
										end if
											
										situacao		  = rs("situacao")
										if isnull(situacao) then 
											situacao = ""
										elseif situacao = "A" then 
											situacao = "<button style='width:170px' type=""button"" class=""btn btn-warning waves-warning waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-info-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""Agendado em " & rs("data_situacao") & ".""><span class='mensagem_situacao'><strong>Aguardando Processamento</strong></span></button>"
											strBloquearFechamento = "E"
										else
											strBloquearFechamento = "F"
											situacao = "<button style='width:170px' type=""button"" class=""btn btn-success waves-success waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-info-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""Processado em " & rs("data_processamento") & ".""><span class='mensagem_situacao'><strong>Processamento Finalizado</strong></span></button>"
										end if
										
										IF trim(strDesc_SituacaoAluno) = "PRÉ-MATRÍCULA" THEN
											strBloquearFechamento = "M"
										END IF
										
										'Função que verifica a siuação do aluno
										strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
										
											%>
										 <tr style="cursor: pointer">
												<input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
												<input type="hidden" value="<%=rs("codigo")%>" id="chkAluno" name="chkAluno">
												<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
											<%if fechamento = "N" then%>
											<td><%=strDesc_SituacaoAluno%></td>
											<td><%=strPendencias%>&nbsp;</td>
											<%end if%>
											<%if fechamento = "S" then%>
											<td><%=rs("situacao_atual")%></td>
											<td><%=rs("situacao_destino")%></td>
											<%end if%>
											<%
										if fechamento = "N" then
											sql = " SELECT distinct "
											for n=0 to ubound(vetCampo,2)
												campo = vetCampo(0,n)
											
												strComplemento = "0"	
												if cInt(campo)>9 then strComplemento = ""
											
												sql = sql & " case"
												sql = sql & " 	when NF.nota" & strComplemento & campo & " is null then 'X'"
												sql = sql & " 	else 'ok'"
												sql = sql & " end as nota" & strComplemento & campo & ", "
											next
											sql = sql & " case "
											sql = sql & " when rf.resultado_final is not null then rf.resultado_final "
											sql = sql & " else"
											sql = sql & " 	case"
											sql = sql & " 	when nf.media is null or nf.media < " & intMediaAprovacao & " then "
											sql = sql & " 		'RN'"
											sql = sql & " 	when NF.situacao is null OR NF.situacao='AP' then "
											sql = sql & " 		'AP'"
											sql = sql & " 	else"
											sql = sql & " 		 NF.situacao"
											sql = sql & " 	end"
											sql = sql & " end as situacao, isnull(GCD.Omitir_Criterio,'N') as Omitir_Criterio	"
											sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
											sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
											sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
											sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
											sql = sql & " SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
											sql = sql & " SCA_PERIODO PE ON PE.COD_PERIODO = GC.COD_PERIODO INNER JOIN "
											sql = sql & " SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
											sql = sql & " LEFT JOIN SCA_ALUNO_RESULTADO_FINAL RF ON RF.COD_ALUNO = AD.COD_ALUNO AND RF.COD_EMPRESA = AD.COD_EMPRESA AND RF.ANO_LETIVO = " & strAnoLetivo & " AND RF.COD_TURMA = " & intCodTurma
											sql = sql & " WHERE GCD.Omitir_Criterio='N' and AD.COD_EMPRESA = " & Session("CodEmpresa")
											sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
											sql = sql & " AND A.CODIGO = " & strCodAluno
											sql = sql & " AND A.CODIGO not in (SELECT COD_ALUNO FROM SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO WHERE ANO_LETIVO = NF.ANO_LETIVO AND COD_CURSO = PE.COD_CURSO)"
											
											IF trim(ucase(SESSION("USUARIOWEB"))) = "SERGIO" and strMatricula = "202102486" THEN
												'response.write sql 
												'response.end
											END IF
											
											vetNotas = null
											rsAux.open sql, cnn
											if not rsAux.eof then
												vetNotas = rsAux.getRows
											end if
											rsAux.close
											
											resultado_aluno = "<font color='green'>Aprovado</font>"
											resultado_aluno_grava = "Aprovado"
											intQtdeSituacaoNota = 0
											if trim(strDesvincularCriterioAvaliacao) = "S" then
												%>
												<td colspan="4" align="center"> 
													<strong><font color='blue'><i class="fal fa-arrow-circle-up"></i></font></strong>&nbsp;
												</td>
												<%	
											else
												if isArray(vetNotas) then
													
													for i=0 to ubound(vetCampo,2)
														
														
														situacao_nota = "<strong><font color='green'><i class='fal fa-check-circle'></i></font></strong>"
														for j=0 to ubound(vetNotas,2)
															
															strOmitir_Criterio		= trim(vetNotas(ubound(vetCampo,2)+2,j))
															strSituacaoNota			= trim(vetNotas(ubound(vetCampo,2)+1,j))
															resultado_aluno			= trim(vetNotas(ubound(vetCampo,2)+1,j))
															
															'IF trim(ucase(SESSION("USUARIOWEB"))) = "SERGIO" and strMatricula = "202102486" THEN
															'	response.write "strOmitir_Criterio:" & ubound(vetCampo,2) & "+2<br>"
															'	response.write "strOmitir_Criterio:" & strOmitir_Criterio & "<br>"
															'	response.write "resultado_aluno:" & ubound(vetCampo,2) & "+1<br>"
															'	response.write "resultado_aluno:" & resultado_aluno & "<br>"
															'	response.end
															'END IF
															
															'response.write "<br>ra:" & resultado_aluno
															
															if trim(strOmitir_Criterio) = "S" then
															else
																if trim(strSituacaoNota) = "RN" or trim(ucase(strSituacaoNota))="REPROVADO" then
																	intQtdeSituacaoNota = intQtdeSituacaoNota + 1
																	if cInt(intQtdeSituacaoNota) > cInt(intQtdeDisciplinaDependencia) then
																		resultado_aluno = "<font color='red'>Reprovado</font>"
																		resultado_aluno_grava = "Reprovado"
																	end if
																end if
																if trim(vetNotas(i,j)) = "X" then
																	situacao_nota = "<strong><font color='red'><i class='fal fa-times-circle'></i></font></strong>"
																	exit for
																end if
															end if
														next
														
														if strDesc_SituacaoAluno <> "ATIVO" then 
															situacao_nota = ""
															resultado_aluno_grava = ""
															resultado_aluno_tela = ""
														end if
														%>
														<td><%=situacao_nota%>&nbsp;</td>
														<%
													next
													
												else
												%>
												<td colspan="4"> 
													&nbsp;
												</td>
												<%	
												end if
											end if
										end if
										
										if fechamento = "N" then
											
											if trim(ucase(resultado_aluno)) = "AP" then
												resultado_aluno = "<font color='green'>Aprovado</font>"
											elseif trim(ucase(resultado_aluno)) = "RN" then
												resultado_aluno = "<font color='red'>Reprovado</font>"
											else
												if ucase(left(resultado_aluno,2)) = "AP" then
													resultado_aluno = "<font color='green'>" & resultado_aluno & "</font>"
												else
													resultado_aluno = "<font color='red'>" & resultado_aluno & "</font>"
												end if
											end if
											if strAprovadoConselho = "S" then
												resultado_aluno = "<font color='green'>Aprovado pelo Conselho</font>"
												resultado_aluno_grava = "Aprovado"
											end if
											
											
											
											if strDesc_SituacaoAluno <> "ATIVO" then resultado_aluno = ""
											%>
											<td> 
												<%if strDesc_SituacaoAluno = "ATIVO" then%>
													<div style="cursor: pointer" onClick="return abreModal('<%=strCodAluno%>','<%=intCodTurma%>','<%=Session("CodEmpresa")%>','<%=intCodCurso%>')">
													<%=resultado_aluno%> <i class="fal fa-file-search"></i>
													</div>
												<%end if%>
												<input type="hidden" value="<%=resultado_aluno_grava%>" id="resultado_final_aluno<%=rs("codigo")%>" name="resultado_final_aluno<%=rs("codigo")%>">
											</td>
											
											<td> 
												<%=situacao%>&nbsp;
											</td>
										<%
										else
										%>
											<td> 
												<%=rs("RESULTADO_FINAL")%>&nbsp;
											</td>
											<td> 
												<%=situacao%>&nbsp;
											</td>
										
										<%
										end if
										%>
										</tr>
										<%
										
										rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
									 <td colspan="6" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
									 </tr>
									 <%
								  end if
								  rs.close
								%>
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
		<input type="hidden" value="<%=strBloquearFechamento%>" id="txtBloquearFechamento" name="txtBloquearFechamento">
											
		<div class="modal fade" id="modalResultado" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

			<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Extrato de Notas e Faltas</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true"><i class="fal fa-times"></i></span>
						</button>
					</div>
					<div class="modal-body">
					
						<div id="divListaNotas"></div>	
						
					</div>	
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
					</div>
				</div>
			</div>

		</div>
		<div class="modal fade" id="modalSituacao" tabindex="-1" role="dialog" aria-hidden="true" >		

			<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Situação do Fechamento das Turmas</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true"><i class="fal fa-times"></i></span>
						</button>
					</div>
					<div class="modal-body">
					
						<div id="divListaTurmas"></div>	
						
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