<%
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	
	'Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strVerificaCategoria = ""
	else
	
		if (Session("Seg_CodCategoria") = "1") then
			strVerificaCategoria 		= "Professor"
			intCodColaboradorProfessor 	= rs("codigo")
		ELSE
			strVerificaCategoria = ""
		END IF	
	
	end if
	rs.close
	
	strExecutarSubmitCurso	  	= "S"
	strExecutarSubmitPeriodo  	= "S"
	strExecutarSubmitSemestre 	= "S"
	strExecutarSubmitTurno	  	= "S"
	strExecutarSubmitTurma	 	= "S"
	strExecutarSubmitMes 		= "S"
	strSemestre 				= session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strQtdeFaltas = request("txtQtdeFaltas")
	if strQtdeFaltas = "" then strQtdeFaltas = "1"
	
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
	strQuinzena	 			= Trim(Request("cmbQuinzena"))
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	strMes					= Trim(Request("cmbMes"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strData					= trim(request("txtData"))
	strAtivos				= trim(request("cmbativos"))
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	strTipoPeriodo = "D"
	sql = " SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, "
	sql = sql & " SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_PERIODO.Tipo "
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
		strTipoLancamento = rs("Tipo")
	END IF
	rs.close
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

	'controla os botões
	acao = "A"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_falta_disciplinarCon.asp">
<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">
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
							<div class="col-sm-5">
								<div class="form-group">
								
									<label class="form-label">Turma:</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
							<%end if%>
							<% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-5">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									<!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
								</div>
							</div>
							<%end if%>
						
						
						
						<% if trim(strTipoLancamento) = "I" then %>
							%>
							<script>
								alert("Essa aplicação se destina ao lançamento DISCIPLINAR. \nPor favor, para essa turma utilize lancamento INTERDISCIPLINAR.");
								window.location.href  = 'academico.asp'
							</script>
							<%
						end if
							%>						
						
						
						
							<% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-3">
								<div class="form-group">
								
									<label class="form-label">Disciplina Professor:</label>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessorFaltas.asp"-->
									- Caso n&atilde;o seja informado a disciplina ser&aacute; atualizada pelo hor&aacute;rio.
								</div>
							</div>
							<%end if%>
							<% if strVerificaCategoria = "" then%>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Disciplina Professor:</label>
									<!--#include file="includes/inc_cmbDisciplinaTurmaFaltas.asp"-->
								</div>
							</div>
							<%end if%>
						</div>
						
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Op&ccedil;&otilde;es de lan&ccedil;amentos:</label>
									<select name="cmbQuinzena" class="form-control" id="cmbQuinzena" onChange='submit()'>
										<option value="1" <%if strQuinzena = "1" then response.Write("selected") %>>1º Quinzena</option>
										<option value="2" <%if strQuinzena = "2" then response.Write("selected") %>>2º Quinzena</option>
										<option value="3" <%if strQuinzena = "3" then response.Write("selected") %>>Por dia</option>
									</select>
								</div>
							</div>
						
						<% if strQuinzena = "3" then %>
						
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Data:</label>
									<input name="txtDataLancamento" type="text" class="form-control" id="txtDataLancamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>" >
								</div>
							</div>
						
						<% end if%>
						
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mês:</label>
									<!--#include file="includes/inc_cmbMes.asp"-->
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Avaliação:</label>
									<!--#include file="includes/inc_cmbAvaliacao.asp"-->
								</div>
							</div>
							
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Situações:</label>
									<!--#include file="includes/inc_cmbAtivos.asp"-->
								</div>
							</div>
						</div>
						
	
							
						<br>
						<div class="frame-wrap">
							<button onClick="return cadastrarFaltas()"  name="cmbCadastrar" id="cmbCadastrar" type="button" class="btn btn-outline-success">Cadastrar<%=strMsnBotaoHistorico%></button>
							<button onClick="window.location='sca_falta_disciplinarCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodTurma    	= "" then intCodTurma="0"
			if intCodSemestre 			= "" then intCodSemestre="0"
			if intCodTurma<>"0" and strMes<>"0" and strMes<>"" and intCodDisciplinaTurma<>"" and intCodDisciplinaTurma<>"0" then

	%>

	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas - alunos ativos
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
									<th><strong>Ocorr&ecirc;ncias</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
								'seleciona os alunos da turma através de sua disciplina
									Cont=0
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
									if buscaHistorico = "N" then
									   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
									   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
									   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
									   sql = sql & " GCD.COD_DISCIPLINA, "
									   sql = sql & " ISNULL(GCD.Omitir_Criterio,'N') as Omitir_Criterio, "
									   sql = sql & " A.NOMEALUNO, "
									   sql = sql & " A.MATRICULA, "
									   sql = sql & " '' AS SEQUENCIA, "
									   sql = sql & " SA.DESC_SITUACAOALUNO, TC.DESCRICAO AS TIPO_CRITERIO "
									   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD  " 
									   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
									   sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = AD.COD_TURMA"
									   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO INNER JOIN "
									   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
									   sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AD.COD_ALUNO AND TAI.ANO_LETIVO = TUR.ANOLETIVO"
									   sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_calculo"
									   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
									   sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplinaTurma
									   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
									   if strAtivos = "A" then
											sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO') " 
									   end if
									   sql = sql & " ORDER BY A.NOMEALUNO "
									   if ucase(session("usuarioweb")) = "SERGIO" then
											'response.write sql
									   end if
									
									else   
									
									   'seleciona os alunos pelo ano e semestres do histórico 			
									   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, 'N' as Omitir_Criterio, TC.DESCRICAO AS TIPO_CRITERIO "
									   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
									   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
									   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
									   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO " 
									   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = HE.COD_EMPRESA "
									   sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AT.COD_ALUNO AND AT.ANO_LETIVO = TAI.ANO_LETIVO"
									   sql = sql & " LEFT JOIN SCA_TIPO_CALCULO TC ON TC.codigo = TAI.cod_tipo_calculo"
									   sql = sql & " WHERE At.COD_EMPRESA = " & Session("CodEmpresa")
									   sql = sql & " AND AT.COD_TURMA = " & intCodTurma	
									   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
									   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
									   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
									   sql = sql & " ORDER BY NOMEALUNO "
									end if

									rs.open sql, cnn
									if rs.eof = false then
										while not rs.eof
										  
										strCodAluno             = rs("CODIGO")
										intCodEmp               = Session("CodEmpresa") 
										strDesabilitaAluno 	  	= ""
										strSituacaoAluno 		= ""
										tipo_criterio = rs("tipo_criterio")
										if not isnull(tipo_criterio) then
											tipo_criterio = "<font color='blue'>&nbsp;(" & rs("tipo_criterio") & ")</font>"
										end if
										if buscaHistorico = "N" then
										  
											sql = " select ad.codigo, ad.COD_DISCIPLINA, nf.codigo as codNota from SCA_ALUNO_DISCIPLINA ad "
											sql = sql & " left join SCA_NOTAS_FALTAS nf on nf.cod_aluno_disciplina = ad.CODIGO "
											sql = sql & " where ad.COD_ALUNO = " & strCodAluno
											sql = sql & " and ISNULL(nf.codigo,'0') = '0' " 
											
											rs1.open sql, cnn
											if rs1.eof = false then
												while not rs1.eof
												
													strCodAlunoDisciplina  	= rs1("CODIGO")
													
													if strCodAlunoDisciplina <> "0" then
														'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
														strCriaNotas = "S"

														if isnull(rs1("codNota")) then
															strCriaNotas = "N"
															strDesabilitaAluno 	= " disabled "
															strSituacaoAluno	= " <strong>(registro de notas atualizado)</strong>"
														end if
														
														if strCriaNotas = "N" then
														   strMarcaCriaNotas = "N"
														   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
														   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
														   SQL = SQL & "" & intCodEmp & ","
														   SQL = SQL & "" & strCodAluno & ","
														   SQL = SQL & "" & strCodAlunoDisciplina & ","
														   SQL = SQL & "" & intCodPeriodo & ","
														   SQL = SQL & "" & strAnoLetivo & ","
														   SQL = SQL & "" & intSemestre & ","
														   SQL = SQL & "" & rs1("COD_DISCIPLINA") & ","
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null,"
														   SQL = SQL & "null)"
														   cnn.execute SQL
														   'GravarLog sql - Não é necessário porque o próprio sistema cria quando não tiver notas
														end if
													 end if
													rs1.movenext
												wend
											end if
											rs1.close
										 end if	
										 if rs("Omitir_Criterio") = "S" then
											strDesabilitaAluno 	= " disabled "
										 end if
										 strMatricula		          = rs("MATRICULA")
										 strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
										 'Função que verifica a siuação do aluno
										 strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
										 cont = cont + 1
										 %>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
												<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
											<td><button onClick="lancarOcorrencias('<%=rs("codigo")%>','<%=rs("NOMEALUNO")%>')" type="button" class="btn btn-outline-success btn-sm">Ocorrencias</button></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  
								  else
									 %>
									 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
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