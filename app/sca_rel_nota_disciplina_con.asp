<%

	strPerfil =  validaPermissao(session("usuarioweb"), "SCA")

	strPaginaTitulo = "Rel_NotasDisciplina_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmit	  = "S"
	strExecutarSubmitDisciplinaDoProfessor = "S"
	
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

    if strVerificaCategoria <> "Professor" then
	   intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
	   intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	else
	   intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	   intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
	end if   

    if strVerificaCategoria <> "Professor" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else   
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if   
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")	
    strAtivos               = trim(request("cmbativos"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp 	= "" then intCodComp = "0"
	if intCodSerie 	= "" then intCodSerie = "0"
	if intCodTurno 	= "" then intCodTurno = "0"
	if intCodTurma 	= "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento 	= "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma 	= "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

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
<form id="frm" method="post" action="sca_rel_nota_disciplinaCon.asp">
<input name="cmbPeriodo" type="hidden" value="<%=intCodPeriodo%>">
<input name="cmbCurso" type="hidden" value="<%=intCodCurso%>">
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
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									<% if strVerificaCategoria <> "Professor" then %>
									<!--#include file="includes/inc_cmdTurma.asp"-->
									<% else %>	 
									<!--#include file="includes/inc_cmdTurmaProfessor.asp"-->
									<% end if %>   
								</div>
							</div>
			  
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Disciplina:</label>
									<% if strVerificaCategoria <> "Professor" then %>
									<!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
									<% else %>
									<!--#include file="includes/inc_cmdDisciplinaDoProfessor.asp"-->			  
									<% end if %>
								</div>
							</div>
							
							
							
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o acadêmica:</label>
									<!--#include file="includes/inc_cmbAtivos.asp" -->
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Mostrar resultado:</label>
									<input type="checkbox" name="mostra_resultado" value="S">
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
	if intCodTurma    = "" then intCodTurma="0"
	if intCodPeriodo = "" then intCodPeriodo="0"

	if intCodTurma<>"0" and intCodPeriodo<>"0" then
	
	%>

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
								  </tr>
								</thead>
								<tbody>
								<%
								'seleciona os alunos da turma através de sua disciplina
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
								
								' Se for professor busca dados somente no semestre atual
								if strVerificaCategoria = "Professor"  and trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  and trim(intSemestre) <> trim(session("strSemestre")) then
									buscaHistorico = "N"
									%>
									<script>
										alert("Informação anterior ao Semestre Letivo encontra-se Indisponível, procurar a Secretaria.");
										window.location.href  = 'sca_rel_nota_disciplinaCon.asp'
									</script>
									<%
								end if	 
								'	 
								if buscaHistorico = "N" then
									sql = sqlAlunoTurma(intCodTurma, "")
								else   
								   'seleciona os alunos pelo ano e semestres do histórico 			
								   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA, ss.DESC_SITUACAOALUNO, '' AS SEQUENCIA, '' as data_SituacaoAluno "
								   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
								   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
								   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO" 'AND A.COD_EMPRESA = HE.COD_EMPRESA "
								   sql = sql & " INNER JOIN SCA_CONTROLE_SITUACAO_ALUNO_FECHAMENTO SA ON SA.COD_ALUNO = A.CODIGO"
								   SQL = SQL & " AND SA.ANO_LETIVO = HE.ANO_LETIVO"
								   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO" 'AND AT.COD_EMPRESA = A.COD_EMPRESA "
								   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SS"
								   sql = sql & " 		ON SS.Cod_SituacaoAluno = SA.COD_SITUACAOALUNO"
								   'sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
								   sql = sql & " WHERE AT.COD_TURMA = " & intCodTurma	
								   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
								   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
								   if intCodDisciplinaTurma<>"0" then
										sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
								   end if
								   SQL = SQL & " AND SA.COD_SITUACAOALUNO_ATUAL=1"
								   sql = sql & " ORDER BY NOMEALUNO "
								end if
								
								rs.open sql, cnn
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1
										strCodigoAluno        = rs("codigo")
										strMatricula		  = rs("MATRICULA")
										strSituacaoAluno 	= rs("DESC_SITUACAOALUNO")
										mostraLinha 		= "S"
										if strAtivos = "A" and strSituacaoAluno<>"ATIVO" then
											mostraLinha = ""
										end if
										
										if mostraLinha = "S" then
											'Função que verifica a siuação do aluno
											strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
											
											if rs("DESC_SITUACAOALUNO")<>"ATIVO" then
												strSituacaoAluno 	= "&nbsp&nbsp<font size='1' color='red'>" & rs("DESC_SITUACAOALUNO") & " " & rs("data_SituacaoAluno") & "</font>"
											end if
											%>
											 <tr style="cursor: pointer">
												<td width="1%">
													<input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>">
												</td>
												<td><%=zeroleft(cont,2)%></td>
												<td><%=strMatricula%></td>
												<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
											</tr>
											 <%
									     end if
										 
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