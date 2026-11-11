<%
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""

	' Consulta a Categoria	
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
	if strVerificaCategoria = "Professor" then 
		intSemestre 		= session("strSemestre")
		strAnoLetivo		= session("strAnoLetivo")
	else	
		intSemestre 		= Trim(Request("cmbSemestre"))
	end if	
	intCodGrade				= Trim(Request("cmbGrade"))
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	strMes					= Trim(Request("cmbMes"))
	strQuinzena		 		= Trim(Request("cmbQuinzena"))	

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strDataLancamento		= trim(request("txtDataLancamento"))
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
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, "
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
	acao = "A"
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_falta_interdisciplinarCon.asp">
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
									<label class="form-label">Turma do professor:</label>
									<!--#include file="includes/inc_cmdTurmaProfessorFaltas.asp"-->
								</div>
							</div>
							<%end if%>
						
						
						
						<% if trim(strTipoLancamento) = "D" then %>
							%>
							<script>
								alert("Essa aplicação se destina ao lançamento INTERDISCIPLINAR. \nPor favor, para essa turma utilize lancamento DISCIPLINAR.");
								window.location.href  = 'academico.asp'
							</script>
							<%
						end if 
						
						IF intCodTurmaProfessor<>"0" and strVerificaCategoria = "Professor" THEN
							strTurmaIntegral=""
							sql = "select DISTINCT T.DESC_TURNO"
							sql = sql & " from SCA_TURMA A"
							sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = A.Cod_Turno"
							sql = sql & " WHERE A.COD_TURMA =" & intCodTurmaProfessor
							sql = sql & " AND LEFT(T.DESC_TURNO,1) = 'I'"
							SQL = SQL & " AND A.cod_empresa=" & Session("CodEmpresa")
							RS.OPEN SQL, CNN
							IF not RS.EOF THEN
								strTurmaIntegral = "S"
							end if
							rs.close
							
							sql = "select DISTINCT T.DESC_TURNO"
							sql = sql & " from SCA_HORARIO_AULA A"
							sql = sql & " INNER JOIN SCA_HORARIO H ON A.COD_HORARIO = H.CODIGO"
							sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = H.CodTurno"
							sql = sql & " where A.cod_colaborador = " & intCodColaboradorProfessor
							sql = sql & " AND A.COD_TURMA =" & intCodTurmaProfessor
							sql = sql & " AND LEFT(T.DESC_TURNO,1) = 'V'"
							SQL = SQL & " AND A.cod_empresa=" & Session("CodEmpresa")
						'	response.write sql

							RS.OPEN SQL, CNN
							IF not RS.EOF THEN
								strMostraMensagemBloqueiaLancFaltas = "S"
							END IF
							rs.close
							
							if strMostraMensagemBloqueiaLancFaltas = "S" and strTurmaIntegral = "S" then
								%>
								<script>
									alert("Turma selecionada é de turno INTEGRAL, só poderá lançar de faltas no turno matutino, você poderá lançar ocorrências, clicando no icone na coluna ocorrências!");
								</script>
								<%
								strDisabilitaLancFaltas = "disabled"
							end if
						end if%>
						
						
							<% if strVerificaCategoria = "Professor" then%>
							<div class="col-sm-3">
								<div class="form-group">
								
									<label class="form-label">Disciplina Professor:</label>
									<!--#include file="includes/inc_cmbDisciplinaTurmaFaltas.asp"-->
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
									<input name="txtDataLancamento" type="text" class="text" id="txtDataLancamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>" >
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
							<button onClick="window.location='sca_falta_interdisciplinarCon.asp'" name="cmbLimpar" id="cmbLimpar" type="button" class="btn btn-outline-warning">Limpar tela</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
	if intCodTurma    	= "" then intCodTurma="0"
	if intCodSemestre 			= "" then intCodSemestre="0"
	if intCodTurma<>"0" and strMes<>"0" and strMes<>"" then

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
								<%	cont = 0
								
									
									if strAtivos = "A" then
										intCodSituacaoAluno = 1
									else
										intCodSituacaoAluno = 0
									end if
									sql = sqlAlunoTurma(intCodTurma, "")
								
									rs.open sql, cnn
									if rs.eof = false then
										while not rs.eof
											cont = cont  + 1
											strCodigoAluno      = rs("codigo")
											strMatricula		= rs("MATRICULA")
											
											sql = " select ad.codigo, ad.COD_DISCIPLINA, nf.codigo as codNota from SCA_ALUNO_DISCIPLINA ad "
											sql = sql & " left join SCA_NOTAS_FALTAS nf on nf.cod_aluno_disciplina = ad.CODIGO "
											sql = sql & " where ad.COD_ALUNO = " & strCodigoAluno
											sql = sql & " and ISNULL(nf.codigo,'0') = '0' " 
											rs1.open sql, cnn
											if rs1.eof = false then
												while not rs1.eof
												
													strCodAlunoDisciplina  	= rs1("CODIGO")
													strCodDisciplinaNovo  	= rs1("COD_DISCIPLINA")
													
													if strCodAlunoDisciplina <> "0" then
														'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
														strCriaNotas = "S"
														'sql = "SELECT COD_ALUNO_DISCIPLINA "
														'sql = sql & " FROM SCA_NOTAS_FALTAS "
														'sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
														'rsAux.open sql, cnn
														'if rsAux.eof then
														if isnull(rs1("codNota")) then
															strCriaNotas = "N"
															strDesabilitaAluno 	= " disabled "
															strSituacaoAluno	= " <strong>(Não não existe registro de notas)</strong>"
														end if
														'end if
														'rsAux.close
														if strCriaNotas = "N" then
														   strMarcaCriaNotas = "N"
														   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
														   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
														   SQL = SQL & "" & Session("CodEmpresa") & ","
														   SQL = SQL & "" & strCodigoAluno & ","
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
											

											'Função que verifica a siuação do aluno
											strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

										 %>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%><%=tipo_criterio%></td>
											<td><button onClick="lancarOcorrencias('<%=rs("codigo")%>','<%=rs("NOMEALUNO")%>')" type="button" class="btn btn-outline-success btn-sm">Ocorrencias</button>
											</td>
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
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>