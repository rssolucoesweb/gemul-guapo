<%

	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
	else
		strVerificaCategoria = ""
	end if
	rs.close
	
	strBloqueia_NotasDocente = ""
	sql = " SELECT top 1 Bloqueia_NotasDocente, Bloqueia_NotasSecretaria "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	
	if rs.EOF = false then								
		strBloqueia_NotasDocente 	 = trim(rs("Bloqueia_NotasDocente"))
		strBloqueia_NotasSecretaria  = trim(rs("Bloqueia_NotasSecretaria"))
	end if
	rs.close
	
	if strVerificaCategoria = "Professor" then 
		
		if strBloqueia_NotasDocente = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.location.href  = 'academico.asp'
		</script>
		<%
		end if
	else
		if strBloqueia_NotasSecretaria = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.location.href  = 'academico.asp'
		</script>
		<%
		end if
	end if
	
	strExecutarSubmitCurso	  	= "S"
	strExecutarSubmitPeriodo  	= "S"
	strExecutarSubmitSemestre 	= "S"
	strExecutarSubmitTurno	  	= "S"
	strExecutarSubmitTurma	 	= "S"
	strSemestre 				= session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	'REGRA QUANDO O ANO DIGITADO FOR MENOR QUE O DA SESSION
	'SERÁ GRAVADO DO ARQUIVO DE HISTORICO
	if Cint(strAnoLetivo) < Cint(session("strAnoLetivo")) then
		'GRAVANDO NO ARQUIVO DE HISTORICO
		strGravarOnde = "HISTORICO"
		strMsnBotaoHistorico  = " notas no Histórico"
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		strMsnBotaoHistorico  = ""
	end if
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodGrade				= Trim(Request("cmbGrade"))
	
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	strMes					= Trim(Request("cmbMes"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodTurnoRH           = Trim(Request("cmbTurnoRH")) 
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strData					= trim(request("txtData"))
	mostraConteudo			= trim(request("mostraConteudo"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodEstagio = "" then intCodEstagio = "0"

	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
	END IF
	rs.close
	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_diario_eletronicoCon.asp">
<input name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">
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
							
							<% if strVerificaCategoria = "" then%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
							 <%end if%>
							 <% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurmaProfessor.asp" -->
								</div>
							</div>
							 <%end if%>
							 <% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Disciplina <%=strVerificaCategoria%>:</label>
									 <!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp" -->
								</div>
							</div>
							<%end if%>
							<% if strVerificaCategoria = "" then%>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Disciplina:</label>
									 <!--#include file="includes/inc_cmbDisciplinaTurma.asp" -->
								</div>
							</div>
							<%end if%>
						</div>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									<%
									filtroTurno="S"
									intCodTurnoRH = intCodTurno 
									%>									
									<!--#include file="includes/inc_cmbTurnoRH.asp" -->
								</div>
							</div>

							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Conte&uacute;do Ministrado:</label>
									<select name="mostraConteudo" id="mostraConteudo"  class="form-control" >
										<option value="N" <% if mostraConteudo = "N" then response.Write("selected")%>>Não</option>
										<option value="S" <% if mostraConteudo = "S" then response.Write("selected")%>>Sim</option>
									</select>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">M&ecirc;s:</label>
									 <!--#include file="includes/inc_cmbMes.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Avaliação:</label>
									<!--#include file="includes/inc_cmbAvaliacao.asp"-->
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<strong>Obs:</strong> Para emiss&atilde;o do di&aacute;rio frequencia eletr&ocirc;nico o conteudo programatico dever&aacute; estar enviado para a disciplina selecionada.
								</div>
							</div>
						</div>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%
	if intCodTurma    	= "" then intCodTurma="0"
	if intCodSemestre 	= "" then intCodSemestre="0"
	
	buscaHistorico = "N"
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
		  buscaHistorico = "S"
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
	   end if	   
	end if
	
	if intCodTurma<>"0" then%> 
	<div class="row">
		<div class="col-xl-12">
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
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<%if buscaHistorico = "N" then%>
									<th><strong>Situação</strong></th>
									<%end if%>
								  </tr>
								</thead>
								<tbody>
								<%					
								'seleciona os alunos da turma
								'seleciona os alunos da turma - intCodTurma
								'sql = sqlAlunoTurma(intCodTurma, "")
								cont = 0
								
								if buscaHistorico = "N" then
									sql = " SELECT distinct "
									sql = sql & " AD.COD_ALUNO AS CODIGO, " 
									sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
									sql = sql & " A.NOMEALUNO, "
									sql = sql & " A.MATRICULA, "
									sql = sql & " '' AS SEQUENCIA, "
									sql = sql & " SA.DESC_SITUACAOALUNO "
									sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
									sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
									sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO  "
									sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
									' Filtra o estagio
									sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
									sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
									sql = sql & " ORDER BY A.NOMEALUNO "
									
								else   
								   'seleciona os alunos pelo ano e semestres do histórico 			
								   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA "
								   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
								   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
								   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO" 'AND A.COD_EMPRESA = HE.COD_EMPRESA "
								   sql = sql & " INNER JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO SA ON SA.COD_ALUNO = A.CODIGO"
								   SQL = SQL & " AND SA.ANO_LETIVO = HE.ANO_LETIVO"
								   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO" 'AND AT.COD_EMPRESA = A.COD_EMPRESA "
								   'sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
								   sql = sql & " WHERE AT.COD_TURMA = " & intCodTurma	
								   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
								   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
								   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
								   SQL = SQL & " AND SA.COD_SITUACAOALUNO_ATUAL=1"
								   sql = sql & " ORDER BY NOMEALUNO "
								end if
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1
										strCodigoAluno      = rs("codigo")
										strMatricula		= rs("MATRICULA")

										'Função que verifica a siuação do aluno
										strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

										%>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO")%></td>
											<%if buscaHistorico = "N" then%>
											<td><%=rs("DESC_SITUACAOALUNO")%></td>
											<%end if%>
										</tr>
										 <%
										 strNomeTurmaAnt = strNomeTurma
										 rs.movenext
									  wend
									  %>
									   <tr>
										<td colspan="4" align="left"><strong>Quantidade de alunos: <%=cont%></strong></td>
									  </tr>
									  <%
								  else
									 %>
									 <tr> 
									 <td colspan="4" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>