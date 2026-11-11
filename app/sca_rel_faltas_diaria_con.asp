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

		if (frm.optOpcao[0].checked) {
			caminho = "sca_rel_faltas_diaria_REL.asp"
		}	
		if (frm.optOpcao[1].checked) {
			caminho = "sca_rel_faltas_diaria_faltantes_rel.asp"
		}	
	
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		
		if (frm.optOpcao[0].checked) {
			if (frm.cmbTurma.value == 0){
				alert("A turma deve ser informada!");
				frm.cmbTurma.focus();
				return false;
			}		
			if (frm.cmbDisciplinaTurma.value == 0){
				alert("A disciplina deve ser informada!");
				frm.cmbDisciplinaTurma.focus();
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
		}
		
		frm.action = caminho;
		frm.submit();
		
		
	}	
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitMes 	  = "S"

	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strVerificaHistorico	= Trim(Request("optVerificaHistorico"))
	strOpcaoRelatorio		= Trim(Request("optOpcao"))
	if strOpcaoRelatorio = "" then strOpcaoRelatorio = "0"

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then intSemestre  = session("strSemestre")	

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp 	= "" then intCodComp = "0"
	if intCodSerie 	= "" then intCodSerie = "0"
	if intCodTurno 	= "" then intCodTurno = "0"
	if intCodTurma 	= "" then intCodTurma = "0"
	if intCodCurso 	= "" then intCodCurso = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento 	= "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma 	= "" then intCodDisciplinaTurma = "0"
	if intCodNota 				= "" then intCodNota="0"
	if strVerificaHistorico 	= "" then strVerificaHistorico = "N"

	strSituacaoTurmaCad = ""
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.SITUACAO "
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
		strSituacaoTurmaCad = rs("Situacao")
	END IF
	rs.close
	
	strSituacaoTurmaFechada = "N"
	sql = "SELECT Cod_Turma "
	sql = sql & " FROM SCA_CONTROLE_FECHAMENTO "
	sql = sql & " WHERE Cod_Turma= " & intCodTurma
	RS.OPEN sql, CNN
	IF not RS.EOF THEN
		strSituacaoTurmaFechada = "S"
	END IF
	rs.close
	
	buscaHistorico = "N"
	msnHistorico = ""
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if	   
    end if

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""


	strDesabilitaRel2 = ""
	quantidadeMaior = 30
	msn = "<strong><i>falta configurar o envio de mensagens no menu inicial.</i></strong>"
	'verifica se tem mensagem configurada
	sql = "select m.quantidade_maior, m.mensagem "
	sql = sql & " from SEG_CONFIGURAR_MENSAGEM m "
	sql = sql & " inner join SEG_CONFIGURAR_MENSAGEM_PERFIL p on p.cod_configurar_mensagem = m.codigo "
	sql = sql & " where 1=1 "	'p.cod_perfil in (" & Session("CodPerfilUsuario") & ")"
	sql = sql & " and m.tipo = 'QUANTIDADE_FALTAS'"
	sql = sql & " and m.cod_grupo = " & session("CodGrupo")
	rsAux.open sql, cnn
	if not rsAux.eof then
		mensagemAlerta = rsAux("mensagem")
		quantidadeMaior = rsAux("quantidade_maior")
		strDesabilitaRel2 = ""
		msn = ""
	end if
	rsAux.close

%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_faltas_diaria.asp">
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
							<div class="col-sm-12">
								<div class="form-group">
								
									<label class="form-label">Op&ccedil;&atilde;o de Relat&oacute;rio:</label>
									<BR><input onChange="submit()" <% if strOpcaoRelatorio = "" or strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">
										Faltas Diária&nbsp;&nbsp;&nbsp;&nbsp; <br>
									<input <%=strDesabilitaRel2%> onChange="submit()" <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">
										Alunos com mais de <%=quantidadeMaior%> faltas&nbsp;&nbsp;<br><%=msn%>
		
								</div>
							</div>
						</div>
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
						<%if strOpcaoRelatorio = "0" then%>
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Disciplina:</label>
									<!--#include file="includes/inc_cmbDisciplinaTurma.asp"-->
								</div>
							</div>
						<% end if %>
							
						<%if strOpcaoRelatorio = "0" or strOpcaoRelatorio="" then%>
							<% if strSituacaoTurmaFechada = "S" then %>
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Buscar Hist&oacute;rico (anos anteriores):</label>
										<br> <input  <% if strVerificaHistorico = "S" then response.Write("checked")%> name="optVerificaHistorico" type="radio" value="S"  onClick="submit()"> Sim <br> 
										<input <% if strVerificaHistorico = "N" then response.Write("checked")%> name="optVerificaHistorico" type="radio" value="N" onClick="submit()"> Não      
									</div>
								</div>
							<% end if %>
						<% end if %>
    
						<% 
						if strVerificaHistorico = "S" then  
							strTabela = "SCA_FALTAS_DIARIA_HISTORICO"
						else  
							strTabela = "SCA_FALTAS_DIARIA"
						end if 
						%>
							
							
						</div>
						
						
						<div class="row">
							
								<div class="col-sm-12">
									<div class="panel-tag">
										<span class="fw-300">Obs: Para a impress&atilde;o, seu navegador dever&aacute; ser configurado com as margens direita 05, esquerda 05, superior 05 e inferior 5. Dever&aacute; tamb&eacute;m ser exclu&iacute;do cabe&ccedil;alho e rodap&eacute; de seu navegador na op&ccedil;&atilde;o configurar p&aacute;gina.</span>
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
									<th><strong>Histório de Lançamentos</strong></th>
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
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AD.COD_ALUNO AND TAI.ANO_LETIVO = TUR.ANOLETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_calculo TC ON TC.codigo = TAI.cod_tipo_calculo"
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
									sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO "
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO " 
									sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO "
									sql = sql & " INNER JOIN SCA_TURMA TUR ON TUR.COD_TURMA = AT.COD_TURMA"
									sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI ON TAI.COD_ALUNO = AT.COD_ALUNO AND AT.ANO_LETIVO = TAI.ANO_LETIVO"
									sql = sql & " LEFT JOIN SCA_TIPO_CRITERIO TC ON TC.codigo = TAI.cod_tipo_criterio"
									sql = sql & " WHERE he.COD_EMPRESA = " & Session("CodEmpresa")
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
												<td colspan="6" align="center"><strong>Turma: <%=strNomeTurma%> &nbsp;</strong></td>
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
											<td>
											
											<% 
											strLacamentos = "" 
											sql = " select FD.DATA, P.Descricao, SUM(FD.FALTA) AS FALTA "
											sql = sql & " from " & strTabela & " FD "
											sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = FD.cod_disciplina "
											sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = FD.cod_periodo "
											sql = sql & " where FD.cod_empresa = " & Session("CodEmpresa") 
											sql = sql & " and ano_letivo = " & strAnoLetivo
											sql = sql & " and semestre = " & intSemestre 
											sql = sql & " and cod_aluno = " & strCodigoAluno 
											sql = sql & " and FD.cod_disciplina = " & intCodDisciplinaTurma 
											sql = sql & " GROUP BY FD.DATA, P.Descricao	"
											rsaux.open sql, cnn
											if rsaux.eof = false then
												while not rsaux.eof
													strLacamentos = strLacamentos + formatadataAp(rsaux("DATA")) & " - " & rsaux("Descricao") & ": " & rsaux("FALTA") & " Falta(s)<br>"
													rsaux.movenext
												wend
											end if
											rsaux.close
											%>
											<br><%=strLacamentos%>
											
											</td>
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