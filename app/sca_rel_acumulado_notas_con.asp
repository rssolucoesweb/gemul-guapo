<script>
	function MarcaTodosAlunos(valor){
		
		var frm = document.getElementById("frm");
		var i;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox" && frm.elements[i].name == "chkAluno"){
				//verifica se o checkbox está marcado
				frm.elements[i].checked=valor;
			}
		}
	}
	function gerar(){
	
		var frm = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		
		
		var intAnoSession = <%=session("strAnoLetivo")%>;
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		
		if (frm.txtAnoLetivo.value>intAnoSession) {
			alert("Ano/Semestre letivo não permitido.");
			frm.txtAnoLetivo.focus();
			return false
		}
	
		if (frm.cmbCurso.value == 0){
			alert("O Curso deve ser informado!");
			frm.cmbCurso.focus();
			return false;
		}
		

		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < frm.elements.length; i++) {
			//verifica todos os checkbox
			if (frm.elements[i].type == "checkbox"){
				if (frm.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (frm.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("O(s) aluno(s) deve(m) ser informado(s)!");
			return false;
		}
		
		frm.action = "sca_rel_acumulado_notasREL.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
    strExecutarSubmit         = "S"  
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
    intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

	if intCodTurma = "" then intCodTurma = "0"
	if trim(intCodTurma) <> "0" then
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
	end if	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_acumulado_notas.asp">
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
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
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
								
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmdCurso.asp"-->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Período:</label>
									<!--#include file="includes/inc_cmdPeriodo.asp"-->
								</div>
							</div>
						</div>
						<div class="row">
						
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Turma:</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Tamanho da fonte:</label>
									<!--#include file="includes/inc_cmbTamanhoFonteArial.asp"-->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Extrato por folha:</label>
									<select name="cmbTotalExtrato" id="cmbTotalExtrato" class="form-control">
										<option value="1" <%if intTotalExtrato = "1" then response.Write("selected") %>>01</option>
										<option value="2" <%if intTotalExtrato = "2" then response.Write("selected") %>>02</option>
										<option value="3" <%if intTotalExtrato = "3" then response.Write("selected") %>>03</option>
										<option value="4" <%if intTotalExtrato = "4" then response.Write("selected") %>>04</option>
										<option value="5" <%if intTotalExtrato = "5" then response.Write("selected") %>>05</option>
										 <%if strclasse = "celulaarial7" or strclasse = "celulaarial8" or strclasse = "celulaarial9" or strclasse = "celulaarial10" then%>
										<option value="6" <%if intTotalExtrato = "6" then response.Write("selected") %>>06</option>
										<%end if%>
										 <%if strclasse = "celulaarial7" or strclasse = "celulaarial8"  or strclasse = "celulaarial9" then%>
										<option value="7" <%if intTotalExtrato = "7" then response.Write("selected") %>>07</option>
										<%end if%>
										<%if strclasse = "celulaarial7"  then%>
										<option value="8" <%if intTotalExtrato = "8" then response.Write("selected") %>>08</option>
										<%end if%>
										<%if strclasse = "celulaarial7" then%>
										<option value="9" <%if intTotalExtrato = "9" then response.Write("selected") %>>09</option>
										<%end if%>
									</select>
								</div>
							</div>
						</div>
						
						<div class="row">
						
							<div class="col-sm-3">
								<div class="form-group">
								
									<label class="form-label">Mostrar resultado:</label>
									<input type="checkbox" checked name="resultadoFinal" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Resultado definitivo:</label>
									<input type="checkbox" checked name="txtTipoResultadoFinal" value="D">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mostra C.H.:</label>
									<input type="checkbox" checked name="CH" value="S">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Mostra (%) faltas:</label>
									<input type="checkbox" checked name="PercFaltas" value="S">
								</div>
							</div>
						</div>
<%
strSomenteFonte7 = ""
strSomenteFonte8 = ""
strSomenteFonte9 = "N"
strSomenteFonte10 = "N"
strSomenteFonte11 = "N"
strSomenteFonte12 = "N"


%>
						<div class="row">
							
								<div class="col-sm-12">
									<div class="panel-tag">
										<span class="fw-300">Obs: Para a impress&atilde;o da Acumulada de Notas e faltas, seu navegador dever&aacute; ser configurado com as margens direita 05, esquerda 05, superior 05 e inferior 5. Dever&aacute; tamb&eacute;m ser exclu&iacute;do cabe&ccedil;alho e rodap&eacute; de seu navegador na op&ccedil;&atilde;o configurar p&aacute;gina.</span>
									</div>
								</div>
						</div>
									
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp"-->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%
if intCodTurma    = "" then intCodTurma="0"
if intCodPeriodo = "" then intCodPeriodo="0"
if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"

if intCodTurma<>"0" and intCodCurso<>"0" and intCodPeriodo<>"0" then
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
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input name="chkTodos" type="checkbox" value="" onClick="return MarcaTodosAlunos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%
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
									'seleciona os alunos do ano e semestre corrente 			
									sql = " SELECT DISTINCT "
									sql = sql & " AD.COD_ALUNO AS CODIGO, " 
									sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
									sql = sql & " A.NOMEALUNO, "
									sql = sql & " A.MATRICULA, "
									sql = sql & " SA.DESC_SITUACAOALUNO, TC.DESCRICAO AS TIPO_CRITERIO, TUR.NomeTurma, TUR.TurmaAluno   "
									sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD  " 
									sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
									sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = AD.COD_TURMA"
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AD.COD_ALUNO AND TAI.ANO_LETIVO = TUR.ANOLETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_CRITERIO TC ON TC.codigo = TAI.cod_tipo_criterio"
									sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
									'sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplina
									sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
									if intCodSituacaoAluno = "" or intCodSituacaoAluno = "0" then
									   sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
									else
									   sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
									end if
									if strMatriculaAluno <> "" then
										sql = sql & "AND A.MATRICULA = '" & strMatriculaAluno & "'"
									end if	
									sql = sql & " ORDER BY A.NOMEALUNO "
								else			
									'seleciona os alunos pelo ano e semestres do histórico 			
									sql = " select DISTINCT A.CODIGO, HED.COD_TURMA, A.NOMEALUNO, A.MATRICULA, SA.DESC_SITUACAOALUNO , TC.DESCRICAO AS TIPO_CRITERIO, TUR.NomeTurma, TUR.TurmaAluno  "
									sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
									sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
									sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
									sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
									sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = AT.COD_TURMA"
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AT.COD_ALUNO AND AT.ANO_LETIVO = TAI.ANO_LETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_CRITERIO TC ON TC.codigo = TAI.cod_tipo_criterio"
									sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
									sql = sql & " AND HED.COD_TURMA = " & intCodTurma	
									sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
									sql = sql & " AND HE.SEMESTRE = " & intSemestre 
									if intCodSituacaoAluno <> "" and intCodSituacaoAluno <> "0" then
									   sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
									end if   
									if strMatriculaAluno <> "" then
										sql = sql & "AND A.MATRICULA = '" & strMatriculaAluno & "'"
									end if	
									sql = sql & " ORDER BY NOMEALUNO "
								 end if
							 
								 rs.open sql, cnn
								
								'Armazena o código de todos os alunos da turma'
								strAlunosTurma=""
								if rs.eof = false then
									while not rs.eof
										cont = cont + 1
										strCodigoAluno        = rs("codigo")
										strMatricula		  = rs("MATRICULA")
										tipo_criterio = rs("tipo_criterio")
										if isnull(rs("TURMAALUNO")) then
											strNomeTurma		  = rs("NOMETURMA")
										else
											strNomeTurma		  = rs("TURMAALUNO") & " - " & rs("NOMETURMA")
										end if
										
										if not isnull(tipo_criterio) then
											tipo_criterio = "<font color='blue'>&nbsp;(" & rs("tipo_criterio") & ")</font>"
										end if
										if trim(strNomeTurma) <> trim(strNomeTurmaAnt) then
											%>
											  <tr bgcolor="#EFEFEF">
												<td colspan="5" align="center"><strong>Turma: <%=strNomeTurma%> &nbsp;</strong></td>
												</tr>
											  <tr>
											<%
										end if
										
										%>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
												<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;<%=tipo_criterio%></td>
											<td><%=rs("DESC_SITUACAOALUNO")%></td>
										</tr>
										 <%
										 strNomeTurmaAnt = strNomeTurma
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
		</div>
	</div> 
		<%
		end if
		%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>