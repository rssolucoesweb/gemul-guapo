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

		intAnoAnterior = clng(strAnoLetivo) - 1
		' Busca critérios do ano anterior
		sql = " INSERT INTO SCA_CRITERIO_AVALIACAO ("
		sql = sql & " ano_letivo"
		sql = sql & " ,cod_curso"
		sql = sql & " ,cod_tipo_calculo"
		sql = sql & " ,media_aprovacao"
		sql = sql & " ,media_aprovacao_final"
		sql = sql & " ,qtd_aula"
		sql = sql & " ,frequencia_minima_percentual"
		sql = sql & " ,num_disciplina_recuperacao"
		sql = sql & " ,num_disciplina_prog_parcial"
		sql = sql & " ,tipoFormulaFinal"
		sql = sql & " ,condicaoEF_notaInicial"
		sql = sql & " ,condicaoEF_notaFinal"
		sql = sql & " )"

		sql = sql & " SELECT"
		sql = sql & " " & strAnoLetivo & " AS ano_letivo"
		sql = sql & " ,A.cod_curso"
		sql = sql & " ,A.cod_tipo_calculo"
		sql = sql & " ,A.media_aprovacao"
		sql = sql & " ,A.media_aprovacao_final"
		sql = sql & " ,A.qtd_aula"
		sql = sql & " ,A.frequencia_minima_percentual"
		sql = sql & " ,A.num_disciplina_recuperacao"
		sql = sql & " ,A.num_disciplina_prog_parcial"
		sql = sql & " ,A.tipoFormulaFinal"
		sql = sql & " ,A.condicaoEF_notaInicial"
		sql = sql & " ,A.condicaoEF_notaFinal"
		sql = sql & " FROM SCA_CRITERIO_AVALIACAO A"
		sql = sql & " WHERE A.ano_letivo = " & intAnoAnterior
		sql = sql & " AND NOT EXISTS ("
		sql = sql & "     SELECT 1"
		sql = sql & "     FROM SCA_CRITERIO_AVALIACAO B"
		sql = sql & "     WHERE B.ano_letivo = " & strAnoLetivo
		sql = sql & "       AND B.cod_curso = A.cod_curso"
		sql = sql & " )"

		cnn.Execute sql

		' Busca cálculos do ano anterior para os critérios do ano atual que estão sem cálculo
		sql = " INSERT INTO SCA_CALCULO_AVALIACAO ("
		sql = sql & " cod_criterio_avaliacao"
		sql = sql & " ,descricao"
		sql = sql & " ,sigla"
		sql = sql & " ,cod_calculo"
		sql = sql & " ,cod_tipo_lancamento"
		sql = sql & " ,posicao"
		sql = sql & " ,formula"
		sql = sql & " ,digitar"
		sql = sql & " ,usuario_incl"
		sql = sql & " ,data_hora_incl"
		sql = sql & " )"
		sql = sql & " SELECT"
		sql = sql & " N.codigo AS cod_criterio_avaliacao"
		sql = sql & " ,C.descricao"
		sql = sql & " ,C.sigla"
		sql = sql & " ,C.cod_calculo"
		sql = sql & " ,C.cod_tipo_lancamento"
		sql = sql & " ,C.posicao"
		sql = sql & " ,C.formula"
		sql = sql & " ,C.digitar"
		sql = sql & " ,'" & replace(session("usuarioWeb"), "'", "''") & "'"
		sql = sql & " ,GETDATE()"
		sql = sql & " FROM SCA_CRITERIO_AVALIACAO N"
		sql = sql & " INNER JOIN SCA_CRITERIO_AVALIACAO A"
		sql = sql & "     ON A.cod_curso = N.cod_curso"
		sql = sql & "    AND A.ano_letivo = " & intAnoAnterior
		sql = sql & "    AND A.codigo = (SELECT MAX(X.codigo) FROM SCA_CRITERIO_AVALIACAO X"
		sql = sql & "                    WHERE X.ano_letivo = " & intAnoAnterior & " AND X.cod_curso = N.cod_curso)"
		sql = sql & " INNER JOIN SCA_CALCULO_AVALIACAO C"
		sql = sql & "     ON C.cod_criterio_avaliacao = A.codigo"
		sql = sql & " WHERE N.ano_letivo = " & clng(strAnoLetivo)
		sql = sql & " AND NOT EXISTS ("
		sql = sql & "     SELECT 1"
		sql = sql & "     FROM SCA_CALCULO_AVALIACAO B"
		sql = sql & "     WHERE B.cod_criterio_avaliacao = N.codigo"
		sql = sql & " )"
		sql = sql & " ORDER BY N.codigo, C.posicao"

		cnn.Execute sql


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

		'Posicao de destino do bimestre na tabela SCA_NOTAS_FALTAS.
		'Esta posicao NAO e a mesma da Nota Parcial em SCA_NOTAS_PLANILHA.
		intPosicaoMediaFaltas = 0
		sqlPosicao = "SELECT POSICAO FROM SCA_CALCULO WHERE CODIGO=" & CLng(intCodCalculo)
		rsAux.open sqlPosicao, cnn
		if not rsAux.eof then
			if not isNull(rsAux("POSICAO")) then
				if isNumeric(rsAux("POSICAO")) then intPosicaoMediaFaltas = CLng(rsAux("POSICAO"))
			end if
		end if
		rsAux.close
		if intPosicaoMediaFaltas < 1 or intPosicaoMediaFaltas > 30 then
			Response.Write "Posicao do bimestre invalida em SCA_CALCULO."
			Response.End
		end if

		'Identifica a coluna da Nota Parcial na configuracao vigente.
		intIndiceNotaParcial = -1
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
		for idxParcial = 0 to ubound(vetCampo,2)
			if CStr(vetCampo(4,idxParcial)) = "9" then intIndiceNotaParcial = idxParcial
		next
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
				
				<div align="right">
					<ul class="list-table m-0">
						<li class="pl-3"><a href="#" onclick="abreVideo('tutorial/SCA/sca_avaliacao.mp4')" class="text-secondary fw-700"><font color="blue">Tutorial</font></a></li>
						<li class="pl-1 fs-xl"><a href="#" onclick="abreVideo('tutorial/SCA/sca_avaliacao.mp4')" class="text-secondary"><font color="blue"><i class="fal fa-question-circle" aria-hidden="true"></i></font></a></li>
					</ul>
				</div>					
				
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
								<button onClick="return enviarMedia()" id="btnAlterar" type="button" class="btn btn-outline-info">Salvar Notas e Enviar Média</button>
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
							
							<div class="table-responsive-lg avaliacao-tabela-scroll">
								<table class="table table-bordered table-hover m-0 avaliacao-tabela">
									<thead class="thead-themed">
									  <tr>
										<th class="col-ordem"><strong>Ordem</strong></th>
										<th class="col-matricula"><strong>Matr&iacute;cula</strong></th>
										<th class="col-nome"><strong>Nome</strong></th>
										<th class="col-manual" align="center"><strong>NOTA PARCIAL MANUAL</strong></th>
										<%
											for i=0 to ubound(vetCampo,2)
											%>
												<th class="col-nota" align="center"><strong><%=ucase(vetCampo(1,i))%></strong></th>
											<%
											next
											%>
										<th class="col-foto" align="center"><strong>FOTO</strong></th>
										
									  </tr>
									</thead>
									<tbody>
									<%	
										'seleciona os alunos da turma através de sua disciplina
										Cont=0
										buscaHistorico = "N" 
									   
									    sql = "SET NOCOUNT ON "

										sql = sql & ";WITH ALUNO_TURMA AS ("
										sql = sql & "    SELECT "
										sql = sql & "        AT.CODIGO,"
										sql = sql & "        AT.COD_EMPRESA,"
										sql = sql & "        AT.COD_ALUNO,"
										sql = sql & "        AT.COD_TURMA,"
										sql = sql & "        AT.SEQUENCIA,"
										sql = sql & "        AT.ANO_LETIVO,"
										sql = sql & "        AT.SEMESTRE,"
										sql = sql & "        AT.SITUACAO,"
										sql = sql & "        AT.DATA_SITUACAO,"
										sql = sql & "        ROW_NUMBER() OVER ("
										sql = sql & "            PARTITION BY AT.ANO_LETIVO, AT.COD_ALUNO, AT.COD_EMPRESA"
										sql = sql & "            ORDER BY AT.CODIGO DESC"
										sql = sql & "        ) AS RN"
										sql = sql & "    FROM SCA_ALUNO_TURMA AT"
										sql = sql & "    WHERE AT.COD_EMPRESA = " & Session("CodEmpresa")
										sql = sql & "      AND AT.COD_TURMA = " & intCodTurma
										sql = sql & "      AND AT.ANO_LETIVO = " & strAnoLetivo
										sql = sql & "      AND AT.SEMESTRE = " & intCodSemestre
										sql = sql & ")"

										sql = sql & " SELECT DISTINCT"
										sql = sql & "     A.CODIGO AS COD_ALUNO,"
										sql = sql & "     A.DATANASCIMENTO,"
										sql = sql & "     A.MATRICULA,"
										sql = sql & "     A.NOMEALUNO,"
										sql = sql & "     AT.COD_TURMA,"
										sql = sql & "     GC.Cod_Periodo,"
										sql = sql & "     T.NomeTurma,"
										sql = sql & "     T.TURMAALUNO,"

										' Situação atual do aluno NA EMPRESA
										sql = sql & "     ISNULL(ST.Desc_SituacaoAluno, 'ATIVO') AS Desc_SituacaoAluno,"
										sql = sql & "     ISNULL(ST.Cod_SituacaoAluno, 1) AS COD_SITUACAOALUNOATUAL,"
										sql = sql & "     ST.DATA_SITUACAO AS DATA_SITUACAOALUNO,"

										sql = sql & "     TC.DESCRICAO AS TIPO_CRITERIO,"
										sql = sql & "     P.Cod_Curso,"
										sql = sql & "     T.Cod_GradeCurricular,"
										sql = sql & "     T.DesvincularCriterioAvaliacao,"

										' Notas
										For n = 1 To 30
											strComplemento = "0"
											If CInt(n) > 9 Then strComplemento = ""
											sql = sql & " NF.nota" & strComplemento & n & ","
										Next

										sql = sql & " NF.CODIGO,"
										sql = sql & " AD.CODIGO AS COD_ALUNO_DISCIPLINA,"
										sql = sql & " C.DESCRICAO AS CURSO"

										sql = sql & " FROM SCA_ALUNO A"

										sql = sql & " INNER JOIN ALUNO_TURMA AT"
										sql = sql & "     ON AT.COD_ALUNO = A.CODIGO"
										sql = sql & "    AND AT.RN = 1"

										sql = sql & " LEFT JOIN SCA_TURMA T"
										sql = sql & "     ON AT.COD_TURMA = T.Cod_Turma"
										sql = sql & "    AND AT.ANO_LETIVO = T.AnoLetivo"
										sql = sql & "    AND AT.SEMESTRE = T.Cod_Semestre"
										sql = sql & "    AND AT.COD_EMPRESA = T.COD_EMPRESA"

										sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA AD"
										sql = sql & "     ON A.CODIGO = AD.COD_ALUNO"
										sql = sql & "    AND AD.COD_TURMA = AT.COD_TURMA"

										sql = sql & " LEFT JOIN SCA_NOTAS_PLANILHA NF"
										sql = sql & "     ON NF.COD_ALUNO_DISCIPLINA = AD.CODIGO"

										sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC"
										sql = sql & "     ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular"

										sql = sql & " LEFT JOIN SCA_PERIODO P"
										sql = sql & "     ON P.Cod_Periodo = GC.Cod_Periodo"

										sql = sql & " LEFT JOIN SCA_CURSO C"
										sql = sql & "     ON C.Cod_Curso = P.Cod_Curso"

										sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI"
										sql = sql & "     ON TAI.COD_ALUNO = AT.COD_ALUNO"
										sql = sql & "    AND TAI.ANO_LETIVO = AT.ANO_LETIVO"

										sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC"
										sql = sql & "     ON TC.CODIGO = TAI.COD_TIPO_CALCULO"

										' Busca a última situação do aluno na EMPRESA DA TURMA
										sql = sql & " OUTER APPLY ("
										sql = sql & "     SELECT TOP 1"
										sql = sql & "         SS.Cod_SituacaoAluno,"
										sql = sql & "         SS.Desc_SituacaoAluno,"
										sql = sql & "         CS.DATA_SITUACAO"
										sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
										sql = sql & "     INNER JOIN SCA_SITUACAOALUNO SS"
										sql = sql & "         ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
										sql = sql & "     WHERE CS.COD_EMPRESA = AT.COD_EMPRESA"
										sql = sql & "       AND CS.COD_ALUNO = AT.COD_ALUNO"
										sql = sql & "       AND CS.ANO_LETIVO = AT.ANO_LETIVO"
										sql = sql & "     ORDER BY CS.CODIGO DESC"
										sql = sql & " ) ST"

										sql = sql & " WHERE AT.COD_EMPRESA = " & Session("CodEmpresa")
										sql = sql & "   AND AT.COD_TURMA = " & intCodTurma
										sql = sql & "   AND AT.ANO_LETIVO = " & strAnoLetivo
										sql = sql & "   AND AT.SITUACAO IN ('A','T','D','C')"
										sql = sql & "   AND T.SITUACAO = 'A'"
										sql = sql & "   AND AD.COD_DISCIPLINA = " & intCodDisciplinaTurma

										' Somente alunos ATIVOS
										If strAtivos = "A" Then
											sql = sql & "   AND ISNULL(ST.Cod_SituacaoAluno, 1) = 1"
										End If

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
											strSituacaoAluno 	= rs("DESC_SITUACAOALUNO")
											if rs("DESC_SITUACAOALUNO")="ATIVO" then
												strSituacaoAluno 	= ""
											else
												strSituacaoAluno 	= "<br><font color=red>" & rs("DESC_SITUACAOALUNO") & "</font>"
											end if
											' Disponibilidade de aproveitamento de notas por transferencia.
											' Verificar disponibilidade de atualização de notas
											bolAtualizarNotasTransferencia = False

											If IsNumeric(strCodAluno) And IsNumeric(strAnoLetivo) And IsNumeric(Session("CodEmpresa")) and strCodAluno=25686 Then

												sqlVerificaTransf = "EXEC dbo.SP_SCA_Verificar_Notas_Transferencia " & strCodAluno & "," & strAnoLetivo & "," & Session("CodEmpresa")
												Set rsVerificaTransf = cnn.Execute(sqlVerificaTransf)

												If Not rsVerificaTransf.EOF Then
													bolAtualizarNotasTransferencia = rsVerificaTransf("LiberarAtualizacao")
												End If

												rsVerificaTransf.Close
												Set rsVerificaTransf = Nothing

											End If
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
											 
											'Valor identificado em SCA_NOTAS_FALTAS (somente leitura).
										bolParcialInferida = false
										valorParcialInferida = Null
										 bolParcialManual = false
										 if intIndiceNotaParcial >= 0 and isNumeric(strCodAlunoDisciplina) then
											 sqlManual = "SELECT CODIGO FROM SCA_NOTA_PARCIAL_MANUAL WHERE COD_ALUNO_DISCIPLINA=" & CLng(strCodAlunoDisciplina) & " AND COD_CALCULO=" & CLng(intCodCalculo) & " AND COD_CRITERIO_AVALIACAO=" & CLng(intCodCriterioAvaliacao)
											 rsAux.open sqlManual, cnn
											 bolParcialManual = not rsAux.eof
											 rsAux.close
										 end if

										 'So identifica automaticamente se nao existe controle manual.
										 if not bolParcialManual and intIndiceNotaParcial >= 0 and isNumeric(strCodAlunoDisciplina) then
											bolAvaliacoesVazias = true
											for idxVerifica = 0 to ubound(vetCampo,2)
												'Ignora apenas a propria Nota Parcial (tipo 9).
												'Os demais campos do calculo (avaliacoes e recuperacao) devem estar vazios.
												if idxVerifica <> intIndiceNotaParcial then
													posAvaliacao = Right("0" & CStr(vetCampo(0,idxVerifica)), 2)
													valorAvaliacao = rs("NOTA" & posAvaliacao)
													if not isNull(valorAvaliacao) then
														if Trim(CStr(valorAvaliacao)) <> "" then bolAvaliacoesVazias = false
													end if
												end if
											next

											if bolAvaliacoesVazias then
												posMediaFaltas = Right("0" & CStr(intPosicaoMediaFaltas), 2)
												sqlManual = "SELECT TOP 1 nota" & posMediaFaltas & " AS NOTA_BIMESTRE FROM SCA_NOTAS_FALTAS"
												sqlManual = sqlManual & " WHERE COD_ALUNO_DISCIPLINA=" & CLng(strCodAlunoDisciplina)
												sqlManual = sqlManual & " AND COD_EMPRESA=" & CLng(Session("CodEmpresa"))
												sqlManual = sqlManual & " AND ANO_LETIVO=" & CLng(strAnoLetivo)
												sqlManual = sqlManual & " AND SEMESTRE=" & CLng(intSemestre)
												sqlManual = sqlManual & " AND COD_PERIODO=" & CLng(intCodPeriodo)
												sqlManual = sqlManual & " AND COD_DISCIPLINA=" & CLng(intCodDisciplinaTurma)
												rsAux.open sqlManual, cnn
											if not rsAux.eof then
												if not isNull(rsAux("NOTA_BIMESTRE")) then
													valorParcialInferida = rsAux("NOTA_BIMESTRE")
													bolParcialInferida = true
													bolParcialManual = true
											end if
											end if
											rsAux.close
											end if
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
												<td class="col-nome"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=strSituacaoNotas%><%=msnRegistroNaoCriado%>
                                                 <% If bolAtualizarNotasTransferencia Then %>
                                                 <div style="margin-top:5px;">
                                                     <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="return atualizarNotasTransferencia(<%=CLng(strCodAluno)%>, this);">
                                                        Atualizar Notas
                                                     </button>
                                                 </div>
                                                 <% End If %>
                                             </td>
											 <td align="center"><%if intIndiceNotaParcial >= 0 then%><input type="checkbox" name="chkParcialManual_<%=contLanc%>" id="chkParcialManual_<%=contLanc%>" value="S" <%if bolParcialManual then response.write "checked" end if%> onchange="alternarNotaParcialManual(<%=contLanc%>, this.checked)" <%if isnull(rs("CODIGO")) then response.write "disabled" end if%>><%end if%></td>
											 <%
											 for i=0 to ubound(vetCampo,2)
												strComplementoNota = "0"	
												if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
												strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
												if bolParcialInferida and i = intIndiceNotaParcial then
													strNota = valorParcialInferida
												end if
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
													if vetCampo(3,i) = "N" and i <> intIndiceNotaParcial then 
														%>
														<%=strNota%>&nbsp;
														<%
													else
														%>
														<input data-original-readonly="<%if strPodeFazerAlteracao="readonly" or (strCampoEdicao="readonly" and i<>intIndiceNotaParcial) then response.write "1" end if%>" data-nota-linha="<%=contLanc%>" data-nota-indice="<%=i%>" data-nota-parcial="<%if i=intIndiceNotaParcial then response.write "S" else response.write "N" end if%>" <%if bolParcialManual and i<>intIndiceNotaParcial then response.write "readonly" end if%> <%if i=intIndiceNotaParcial then%><%if not bolParcialManual then response.write "readonly" end if%><%else%><%=strPodeFazerAlteracao%> <%=strCampoEdicao%><%end if%> onBlur="return validaNota(this.value,'<%=strComplemento%><%=i%>','<%=contLanc%>')" type="text" class="<%=strStyleCampo%>" style="width:65px;min-width:65px;max-width:65px;text-align:center;padding-left:4px;padding-right:4px;box-sizing:border-box;display:inline-block;" name="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" id="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" value="<%=strNota%>" size="4" maxlength="4" onKeyUp="maskIt(this,event,'###,#',true)"  <%if vetCampo(4,i)="8" then response.Write strStyle%>>
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
												<button onClick="return enviarMedia()" id="btnAlterar" type="button" class="btn btn-outline-info">Salvar Notas e Enviar Média</button>
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