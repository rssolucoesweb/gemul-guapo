<%
	acao = "I"

	strExecutarSubmitTurma	  	= "S"
	strSubmitDisciplinaQuadro 	= "S"
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitCalculoAvaliacao = "S"
	submitDisciplinaTurma = "S"
	
	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "3"
	
	strBloqueia_NotasSecretaria = ""
	
	sql = " SELECT top 1 Bloqueia_NotasSecretaria "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueia_NotasSecretaria  = trim(rs("Bloqueia_NotasSecretaria"))
	end if
	rs.close
	if strBloqueia_NotasSecretaria = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.history.back();
		</script>
		<%
	end if
	
	'Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and (CodCategoria = 1)"'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
		intcategoria="1"
	else
		intcategoria="0"
		strVerificaCategoria = ""
		
		sql = "select cod_colaborador, tipoModulacao "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and status = 'A'" 'Ativo
		sql = sql & " and cod_colaborador in ("
		sql = sql & " select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " and Situacao = 'A'" 'Ativo
		sql = sql & " )"
		'response.write sql
		rsAux.open sql, cnn
		if rsAux.EOF = false then	
			if rsAux("tipoModulacao") = "PROFESSOR" then
				strVerificaCategoria 		= "Professor"
				intcategoria="1"
			else
				strVerificaCategoria 		= ""
			end if
			intCodColaboradorProfessor 	= trim(rsAux("cod_colaborador"))
		end if
		rsAux.close
	end if
	rs.close
	
	if strVerificaCategoria  = "Professor" then
	   		 %>
			<script>
				//alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
				//window.history.back();
			</script>
			<%
		
	end if	
	
	strAnoLetivo			= request("txtAnoLetivo")
	intSemestre 			= Trim(Request("cmbSemestre"))
	
	if strVerificaCategoria <> "Professor" then
		intCodTurma				= Trim(Request("cmbTurma"))
	else
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
		intCodTurma  = intCodTurmaProfessor
	end if
	
	if strVerificaCategoria <> "Professor" then
		intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina	= Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma = intCodDisciplina
	end if
	
	strAtivos               = trim(request("cmbativos"))
	strTipoNota             = trim(request("chkTipoNota"))
	strAluno         	    = trim(request("chkAluno"))
	
	intCodCalculo	= trim(request("cmbCalculoAvaliacao"))
	
	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	
	if trim(intCodTurma) <> "" then
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
		END IF
		rs.close
		
		
		
		
		'cria registro de notas para a turma caso não exista
	
		sql=" INSERT INTO SCA_NOTAS_PLANILHA ("
		sql=sql & "     cod_empresa,"
		sql=sql & "     cod_aluno,"
		sql=sql & "     cod_aluno_disciplina,"
		sql=sql & "     ano_letivo,"
		sql=sql & "     semestre,"
		sql=sql & "     cod_periodo,"
		sql=sql & "     cod_disciplina"
		sql=sql & " )"
		sql=sql & " SELECT "
		sql=sql & "     ad.cod_empresa,"
		sql=sql & "     ad.cod_aluno,"
		sql=sql & "     ad.codigo,"
		sql=sql & "    " & strAnoLetivo & ","
		sql=sql & "    " & intSemestre & ","
		sql=sql & "    " & intCodPeriodo & ","
		sql=sql & "     ad.cod_disciplina"
		sql=sql & " FROM SCA_ALUNO_DISCIPLINA ad"
		sql=sql & " WHERE NOT EXISTS ("
		sql=sql & "     SELECT 1"
		sql=sql & "     FROM SCA_NOTAS_PLANILHA np"
		sql=sql & "     WHERE np.cod_empresa = ad.cod_empresa"
		sql=sql & "       AND np.cod_aluno = ad.cod_aluno"
		sql=sql & "       AND np.cod_aluno_disciplina = ad.codigo"
		sql=sql & "       AND np.ano_letivo = " & strAnoLetivo
		sql=sql & "       AND np.cod_disciplina = ad.cod_disciplina"
		sql=sql & " )"
		sql=sql & " AND ad.cod_turma = " & intCodTurma
		cnn.execute sql
	end if
	
	strSemestre = intSemestre
	
	if intCodCurso<>"" then
		'carrega campos
		sql="select ca.codigo, c.posicao, c.descricao, c.formula, c.digitar, c.codigo as cod_calculo, c.cod_tipo_lancamento as tipo, tc.DESCRICAO AS TIPO_CALCULO, ca.* "
		sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
		sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
		sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
		sql=sql & " where ca.ano_letivo = " & strAnoLetivo
		sql=sql & " and ca.cod_curso = " & intCodCurso
		sql=sql & " order by c.posicao"
		rs.open sql, cnn
		if not rs.eof then
			strTipoCalculo 				= rs("TIPO_CALCULO")
			intCodCriterioAvaliacao		= rs("codigo")
			intCodCalculo 				= rs("COD_CALCULO")
			if trim(request("cmbCalculoAvaliacao"))<>"" and trim(request("cmbCalculoAvaliacao"))<>"0" then
				intCodCalculo	= trim(request("cmbCalculoAvaliacao"))
			end if
			strMediaAprovacaoFinal 		= rs("media_aprovacao_final")
			strMediaAprovacaoExame 		= rs("media_aprovacao")
			intCondicaoEF_notaInicial 	= rs("condicaoEF_notaInicial")
			intCondicaoEF_notaFinal 	= rs("condicaoEF_notaFinal")
			strTipoFormulaFinal 		= rs("tipoFormulaFinal")
			intFrequenciaMinimaPerc		= rs("frequencia_minima_percentual")
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
		
		
		'carrega campos
		sql="select posicao, descricao, formula, digitar, cod_tipo_lancamento as tipo "
		sql=sql & " from SCA_CALCULO_AVALIACAO "
		sql=sql & " where cod_calculo = " & intCodCalculo
		sql=sql & " and cod_criterio_avaliacao = " & intCodCriterioAvaliacao
		'sql=sql & " AND digitar='S'"
		sql=sql & " order by posicao"

		vetCampo = null
		rs.open sql, cnn
		if not rs.eof then
			vetCampo = rs.getRows
		else
			rs.close
			%>
			<script>
				alert("O cáculo da avaliação não foi criado!");
				window.history.back();
			</script>
			<%
			response.end
		end if
		rs.close
	end if
	
	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<form id="frm" method="post" action="sca_avaliacao.asp">
		<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
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
				
				<!--div align="right">
					<ul class="list-table m-0">
						<li class="pl-3"><a href="#" onclick="abreVideo('tutorial/SCA/sca_avaliacao.mp4')" class="text-secondary fw-700"><font color="blue">Tutorial</font></a></li>
						<li class="pl-1 fs-xl"><a href="#" onclick="abreVideo('tutorial/SCA/sca_avaliacao.mp4')" class="text-secondary"><font color="blue"><i class="fal fa-question-circle" aria-hidden="true"></i></font></a></li>
					</ul>
				</div-->					
				
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
							<div class="row">
								<div class="col-sm-1">
									<div class="form-group">
										<label class="form-label">Ano Letivo:</label>
										<input readonly name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
									</div>
								</div>
								<div class="col-sm-2">
									<div class="form-group">
										<label class="form-label">Semestre:</label>
										 <!--#include file="includes/inc_cmdSemestre.asp" -->
									</div>
								</div>
								<div class="col-sm-5">
									<div class="form-group">
										<label class="form-label">Turma <%=strVerificaCategoria%></label>
										  <% if strVerificaCategoria <> "Professor" then %>
											 <!--#include file="includes/inc_cmdTurma.asp"-->
										  <% else %>	 
											 <!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
										  <% end if %>              
									</div>
								</div>
							
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Disciplina</label>
										  <% if strVerificaCategoria <> "Professor" then %>
											 <!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
										  <% else %>	 
											 <!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp"-->			
										  <% end if %>              
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Situação</label>
										  <!--#include file="includes/inc_cmbAtivos.asp"-->         
									</div>
								</div>
								<div class="col-sm-9">
									<div class="form-group">
										<label class="form-label">Avaliação</label>
										  <!--#include file="includes/inc_cmdCalculoAvaliacao.asp"-->         
									</div>
								</div>
							</div>
							<br>
							<div class="frame-wrap">
								<button onClick="return cadastrarNotas()" id="btnIncluir" type="button" class="btn btn-outline-success">Salvar Notas</button>
								<button onClick="return enviarMedia()" id="btnAlterar" type="button" class="btn btn-outline-info">Enviar Média</button>
								<button onClick="window.location='sca_avaliacao.asp'"  type="button" class="btn btn-outline-warning">Limpar tela</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<%
		if intCodTurma    = "" then intCodTurma="0"
		if intCodSemestre = "" then intCodSemestre="0"
		if intCodTurma<>"0" and intCodDisciplinaTurma<>"0" and intCodCalculo<>"0" then%> 
		
		<!--#include file="includes/inc_ListaEnvioMedia.asp"-->
		
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
							
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th width="30px"><strong>Ordem</strong></th>
										<th width="80px"><strong>Matr&iacute;cula</strong></th>
										<th><strong>Nome</strong></th>
										<%
											for i=0 to ubound(vetCampo,2)
											%>
												<th align="center" width="13%"><strong><%=ucase(vetCampo(1,i))%></strong></th>
											<%
											next
											%>
										<th align="center" width="80px"><strong>FOTO</strong></th>
										
									  </tr>
									</thead>
									<tbody>
									<%	
										'seleciona os alunos da turma através de sua disciplina
										Cont=0
										buscaHistorico = "N" 
									   
									    sql = " SET NOCOUNT ON IF OBJECT_ID('tempdb..#SCA_ALU_TURMA') IS NOT NULL DROP TABLE #SCA_ALU_TURMA"
										sql = sql & " Select max(codigo) as codigo_SCA_ALUNO_TURMA, ANO_LETIVO, COD_ALUNO, COD_EMPRESA"
										sql = sql & " into #SCA_ALU_TURMA"
										sql = sql & " from SCA_ALUNO_TURMA"
										sql = sql & " where COD_EMPRESA = " & Session("CodEmpresa") 
										sql = sql & " and COD_TURMA = " & intCodTurma
										sql = sql & " and ANO_LETIVO = " & strAnoLetivo
										sql = sql & " and SEMESTRE = " & intCodSemestre
										sql = sql & " group by ANO_LETIVO, COD_ALUNO, COD_EMPRESA"
										sql = sql & " IF OBJECT_ID('tempdb..#SCA_ALUNO_TURMA') IS NOT NULL DROP TABLE #SCA_ALUNO_TURMA"
										sql = sql & " Select at.CODIGO, at.COD_EMPRESA, at.COD_ALUNO, at.COD_TURMA, at.SEQUENCIA, at.ANO_LETIVO, at.SEMESTRE, at.SITUACAO, at.DATA_SITUACAO"
										sql = sql & " into #SCA_ALUNO_TURMA"
										sql = sql & " from SCA_ALUNO_TURMA at "
										sql = sql & " inner join #SCA_ALU_TURMA aa on aa.codigo_SCA_ALUNO_TURMA = at.codigo "
										sql = sql & " SELECT DISTINCT"
										sql = sql & " 	A.CODIGO AS COD_ALUNO,"
										sql = sql & " 	A.DATANASCIMENTO,"
										sql = sql & " 	A.MATRICULA,"
										sql = sql & " 	A.NOMEALUNO,"
										sql = sql & " 	AT.COD_TURMA,"
										sql = sql & " 	GC.Cod_Periodo,"
										sql = sql & " 	T.NomeTurma,"
										sql = sql & " 	T.TURMAALUNO,"
										sql = sql & " 	ISNULL("
										sql = sql & " 		("
										sql = sql & " 			SELECT TOP 1 SS.Desc_SituacaoAluno"
										sql = sql & " 			FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
										sql = sql & " 			INNER JOIN SCA_SITUACAOALUNO SS "
										sql = sql & " 				ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
										sql = sql & " 			WHERE CS.COD_EMPRESA = AT.COD_EMPRESA"
										sql = sql & " 			  AND CS.COD_ALUNO   = AT.COD_ALUNO"
										sql = sql & " 			  AND CS.ANO_LETIVO  = AT.ANO_LETIVO"
										sql = sql & " 			ORDER BY CS.CODIGO DESC"
										sql = sql & " 		),"
										sql = sql & " 		'ATIVO'"
										sql = sql & " 	) AS Desc_SituacaoAluno,"
										sql = sql & " 	ISNULL("
										sql = sql & " 		("
										sql = sql & " 			SELECT TOP 1 SS.Cod_SituacaoAluno"
										sql = sql & " 			FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
										sql = sql & " 			INNER JOIN SCA_SITUACAOALUNO SS "
										sql = sql & " 				ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
										sql = sql & " 			WHERE CS.COD_EMPRESA = AT.COD_EMPRESA"
										sql = sql & " 			  AND CS.COD_ALUNO   = AT.COD_ALUNO"
										sql = sql & " 			  AND CS.ANO_LETIVO  = AT.ANO_LETIVO"
										sql = sql & " 			ORDER BY CS.CODIGO DESC"
										sql = sql & " 		),"
										sql = sql & " 		1"
										sql = sql & " 	) AS COD_SITUACAOALUNOATUAL,"
										sql = sql & " 	TC.DESCRICAO AS TIPO_CRITERIO,"
										sql = sql & " 	P.Cod_Curso,"
										sql = sql & " 	T.Cod_GradeCurricular,"
										sql = sql & " 	T.DesvincularCriterioAvaliacao,"
										for n=1 to 30
											strComplemento = "0"	
											if cInt(n)>9 then strComplemento = ""
											sql = sql & " NF.nota" & strComplemento & n & ", "
										next
										sql = sql & " NF.CODIGO, AD.CODIGO AS COD_ALUNO_DISCIPLINA," 										
										sql = sql & " 	C.DESCRICAO  AS CURSO"
										sql = sql & " FROM SCA_ALUNO A"
										sql = sql & " INNER JOIN #SCA_ALUNO_TURMA AT"
										sql = sql & " 	ON AT.COD_ALUNO = A.CODIGO"
										sql = sql & " LEFT JOIN SCA_TURMA T"
										sql = sql & " 	ON AT.COD_TURMA  = T.Cod_Turma"
										sql = sql & "    AND AT.ANO_LETIVO = T.AnoLetivo"
										sql = sql & "    AND AT.SEMESTRE  = T.Cod_Semestre"
										sql = sql & "    AND AT.COD_EMPRESA = T.COD_EMPRESA"
									    sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA AD ON A.CODIGO = AD.COD_ALUNO and ad.cod_turma  = AT.cod_turma  "
									    sql = sql & " LEFT JOIN SCA_NOTAS_PLANILHA NF ON NF.cod_aluno_disciplina = AD.CODIGO "
										sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC"
										sql = sql & " 	ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular"
										sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G"
										sql = sql & " 	ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
										sql = sql & " LEFT JOIN SCA_PERIODO P"
										sql = sql & " 	ON P.Cod_Periodo = G.Cod_Periodo"
										sql = sql & " LEFT JOIN SCA_CURSO C"
										sql = sql & " 	ON C.Cod_Curso = P.Cod_Curso"
										sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI"
										sql = sql & " 	ON TAI.COD_ALUNO  = AT.COD_ALUNO"
										sql = sql & "    AND TAI.ANO_LETIVO = T.ANOLETIVO"
										sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC"
										sql = sql & " 	ON TC.CODIGO = TAI.COD_TIPO_CALCULO"
										sql = sql & " WHERE AT.COD_EMPRESA = " & Session("CodEmpresa") 
										sql = sql & "   AND AT.COD_TURMA   = " & intCodTurma
										sql = sql & "   AND AT.ANO_LETIVO  = " & strAnoLetivo
										sql = sql & "   AND AT.SITUACAO IN ('A','T','D','C')"
										sql = sql & "   AND T.SITUACAO = 'A'"
										sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
										if strAtivos = "A" then	
											sql = sql & " AND	ISNULL("
											sql = sql & " 		("
											sql = sql & " 			SELECT TOP 1 SS.Desc_SituacaoAluno"
											sql = sql & " 			FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
											sql = sql & " 			INNER JOIN SCA_SITUACAOALUNO SS "
											sql = sql & " 				ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
											sql = sql & " 			WHERE CS.COD_EMPRESA = AT.COD_EMPRESA"
											sql = sql & " 			  AND CS.COD_ALUNO   = AT.COD_ALUNO"
											sql = sql & " 			  AND CS.ANO_LETIVO  = AT.ANO_LETIVO"
											sql = sql & " 			ORDER BY CS.CODIGO DESC"
											sql = sql & " 		),"
											sql = sql & " 		'ATIVO'"
											sql = sql & " 	) = 'ATIVO'"
											
									    end if	
										sql = sql & " ORDER BY A.NOMEALUNO"
										'if session("usuarioWeb")="SERGIO" then
										'		response.write sql
										'end if
										rs.open sql, cnn
										if rs.eof = false then
											while not rs.eof
											  
											strCodAluno             = rs("COD_ALUNO")
											intCodEmp               = Session("CodEmpresa") 
											strDesabilitaAluno 	  	= ""
											strCriaNotas 			= "N"
											
											'ATUALIZA GRADE DO ALUNO
											SQL = " INSERT INTO SCA_ALUNO_DISCIPLINA"
											SQL = SQL & " ("
											SQL = SQL & " 	COD_EMPRESA,"
											SQL = SQL & " 	COD_ALUNO,"
											SQL = SQL & " 	COD_TURMA,"
											SQL = SQL & " 	COD_TURMA_REMANEJAMENTO,"
											SQL = SQL & " 	COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO,"
											SQL = SQL & " 	COD_GRADECURRICULARDISCIPLINA,"
											SQL = SQL & " 	COD_DISCIPLINA,"
											SQL = SQL & " 	SITUACAO,"
											SQL = SQL & " 	COD_SITUACAO_ACADEMICA"
											SQL = SQL & " )"
											SQL = SQL & " SELECT"
											SQL = SQL & " 	T.COD_EMPRESA,"
											SQL = SQL & " 	" & strCodAluno & ","
											SQL = SQL & " 	T.COD_TURMA,"
											SQL = SQL & " 	T.COD_TURMA,"
											SQL = SQL & " 	GD.COD_GRADECURRICULARDISCIPLINA,"
											SQL = SQL & " 	GD.COD_GRADECURRICULARDISCIPLINA,"
											SQL = SQL & " 	GD.COD_DISCIPLINA,"
											SQL = SQL & " 	'CR',"
											SQL = SQL & " 	NULL"
											SQL = SQL & " FROM SCA_TURMA T"
											SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD"
											SQL = SQL & " 	ON GD.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR"
											SQL = SQL & " WHERE T.COD_TURMA = " & intCodTurma
											SQL = SQL & " AND NOT EXISTS ("
											SQL = SQL & " 	SELECT 1"
											SQL = SQL & " 	FROM SCA_ALUNO_DISCIPLINA AD"
											SQL = SQL & " 	WHERE AD.COD_ALUNO = " & strCodAluno
											SQL = SQL & " 	  AND AD.COD_DISCIPLINA = GD.COD_DISCIPLINA"
											SQL = SQL & " 	  AND AD.COD_TURMA = T.COD_TURMA"
											SQL = SQL & " );"
											'RESPONSE.WRITE SQL
											cnn.execute sql	
											
											if isnull(rs("CODIGO")) or trim(rs("CODIGO"))="" then
												strCriaNotas = "S"
												strSituacaoNotas	= " <br><strong>(registro de notas atualizado)</strong>"
												sql = " select top 1 ad.codigo, ad.COD_DISCIPLINA, nf.codigo as codNota "
												sql = sql & " from SCA_ALUNO_DISCIPLINA ad "
												sql = sql & " inner join SCA_NOTAS_PLANILHA nf on nf.cod_aluno_disciplina = ad.CODIGO "
												sql = sql & " where ad.COD_ALUNO = " & strCodAluno
												
												'if session("usuarioWeb")="SERGIO" then
												'		response.write sql
												'end if
												rs1.open sql, cnn
												if rs1.eof = false then
													strCriaNotas = "N"
													strSituacaoNotas 		= ""
												end if
												rs1.close
											end if
											if strCriaNotas = "S" then
												sql = "INSERT INTO SCA_NOTAS_PLANILHA (cod_empresa,cod_aluno,cod_aluno_disciplina,ano_letivo,semestre,cod_periodo,cod_disciplina)"
												sql = sql & " SELECT "
												sql = sql & " 	COD_EMPRESA,"
												sql = sql & " 	COD_ALUNO,"
												sql = sql & " 	CODIGO,"
											    SQL = SQL & "" & strAnoLetivo & ","
											    SQL = SQL & "" & intSemestre & ","
												SQL = SQL & "" & intCodPeriodo & ","
												sql = sql & " 	COD_DISCIPLINA"
												sql = sql & " FROM SCA_ALUNO_DISCIPLINA "
												sql = sql & " WHERE COD_ALUNO = " & strCodAluno
												cnn.execute sql	
												strCriaNotas = "N"
												strSituacaoNotas 		= ""
											end if
											
											strMatricula		          = rs("MATRICULA")
											strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
											'Função que verifica a siuação do aluno
											strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
											cont = cont + 1
											contLanc 				= contLanc + 1
											strCodAlunoNota		= RS("CODIGO")
											strCodAluno 			= RS("COD_ALUNO")
											strCodAlunoZeros 		= ZeroLeft(RS("COD_ALUNO"),10)  
											intCodEmp             = Session("CodEmpresa") 
											strSituacaoAluno 		= ""

											strCodAlunoDisciplina  	= rs("COD_ALUNO_DISCIPLINA")
											'if strCodAlunoDisciplina <> "0" then
											'	'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
											'	strCriaNotas = "S"
											'	sql = "SELECT COD_ALUNO_DISCIPLINA "
											'	sql = sql & " FROM SCA_NOTAS_PLANILHA "
											'	sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
											'	rsAux.open sql, cnn
											'	if rsAux.eof then
											'		strCriaNotas = "N"
											'	end if
											'	rsAux.close
											'end if	 
											 
											 strMatricula		          = rs("MATRICULA")
											 strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
											 'Função que verifica a siuação do aluno
											 strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
											 msnRegistroNaoCriado=""
											 if isnull(rs("CODIGO")) then
												msnRegistroNaoCriado = "<br>Registro de notas criado."
											 end if
											 
											 %>
											 <tr style="cursor: pointer">
												 <td><%=zeroleft(cont,2)%></td>
												 <td><%=strMatricula%>
													<%
													if session("usuarioWeb")="SERGIO" then
													'response.write "<br>strCodAlunoDisciplina:" & strCodAlunoDisciplina
													'response.write "<br>CODIGO:|" & rs("CODIGO") & "|"
													'response.write "<br>strCodAluno:" & strCodAluno
													'response.write "<hr>"
													'	response.end
													end if
													%>
													 <input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina_<%=contLanc%>">
													 <input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("CODIGO")%>">
													 <input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=strCodAluno%>">
												 </td>
												<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=strSituacaoNotas%><%=msnRegistroNaoCriado%></td>
											 <%
											 for i=0 to ubound(vetCampo,2)
												strComplementoNota = "0"	
												if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
												strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
												strCampoEdicao = ""
												strStyleCampo = "form-control"
												strStyleFundoCelulaTabela = "" 
												if isnull(strNota) or strNota="" then
													strPodeFazerAlteracao = ""
												else
													'Encerramento das atividade esta como liberado, desconsidera a regra de bloqueio
													if intPermitirAlteracaoNotaDocente <> 9 then ' Liberado
														if strTipoAcessoCadastroNotas = "PROF" then 
														   strStyleCampo = "textDesabilitaSemCaixa"
														   strPodeFazerAlteracao = "readonly"
														   if trim(vetCampo(4,i)) = trim(intPermitirAlteracaoNotaDocente) then 
																strPodeFazerAlteracao = ""
															end if
														else
															strPodeFazerAlteracao = ""   
														end if   
													else
														strPodeFazerAlteracao = ""  
													end if
												end if
												
												if isnull(rs("CODIGO")) then
													strCampoEdicao = "readonly"	
												end if
												
												if vetCampo(3,i) = "N" then 
													strCampoEdicao = "readonly"
													strStyleFundoCelulaTabela = "bgcolor='#D4D4D4'" 
												end if

												strComplemento = "0"
												if cInt(i)>9 then strComplemento = ""
												if CInt(intQtdeRegistros) = CInt(contLanc) then
													strProximoCampo = "btnSalvar"
												else
													strProximoCampo = "txtNota_" & contLanc+1 & "_" &strComplemento & i
												end if
												
												%>
												<td align="center">
													<%
													if vetCampo(3,i) = "N" then 
														%>
														<%=strNota%>&nbsp;
														<%
													else
														%>
														<input <%=strPodeFazerAlteracao%> <%=strCampoEdicao%>  onBlur="return validaNota(this.value,'<%=strComplemento%><%=i%>','<%=contLanc%>')" type="text" class="<%=strStyleCampo%>" name="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" id="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" value="<%=strNota%>" size="4" maxlength="4" onKeyUp="maskIt(this,event,'###,#',true)"  <%if vetCampo(4,i)="8" then response.Write strStyle%>>
														<%
													end if
													%>
												</td>
												<%   
												   
											 next	
											 %>
											 <td align="center" onClick="AlunoFoto('<%=strCodAluno%>')"><a href="#"><img src="../images/logo_camera.gif" width="22" height="22"></a></td>
											 </tr>
											 <%
											 rs.movenext
										  wend
										  
									  else
										 %>
										 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
										 <td colspan="5" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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
				<div class="row">
					<div class="col-xl-12">
						<div id="panel-1" class="panel">
							<div class="panel-container show">
								<div class="panel-content">					
									<div class="row">
										<div class="col-sm-12">
											<div class="frame-wrap">
												<button  onClick="return cadastrarNotas()" id="btnIncluir" type="button" class="btn btn-outline-success">Salvar Notas</button>
												<button  onClick="return enviarMedia()" id="btnAlterar" type="button" class="btn btn-outline-info">Enviar Média</button>
												<button onClick="window.location='sca_avaliacao.asp'"  type="button" class="btn btn-outline-warning">Limpar tela</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		</div> 
		<%end if%>
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="txtCodCalculo" value="<%=intCodCalculo%>">
		<input type="hidden" name="txtCodCriterioAvaliacao" value="<%=intCodCriterioAvaliacao%>">
		<input type="hidden" name="txtCodPeriodo" value="<%=intCodPeriodo%>">
		
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
<script type="text/javascript">
	aguarde.style.display="none"
</script>