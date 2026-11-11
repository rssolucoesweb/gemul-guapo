<%
	acao = "I"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitRotaTransporteescolar = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCodRota 				= Trim(Request.Form("cmbRota"))
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	if intCodTurma <> "0" then
	
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
	
		sql = "SELECT cod_aluno "
		sql = sql & " FROM SCA_ROTA_VICULA_ALUNO"
		sql = sql & " WHERE CodTurma = " & intCodTurma
		sql = sql & " And CodRota = " & intCodRota
		rs.open sql, cnn
	
		if rs.eof = false then
			acao = "AE"
		else
			acao = "I"
		end if
		rs.close
	
	end if 


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_vincula_rota.asp">
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
						
						<input name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
						<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
						<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
						<input name="txtPodeEditar" value="<%=strPodeEditar%>" type="hidden">
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						
							<div class="col-sm-3">
								<div class="form-group">
								
									<label class="form-label">Turma</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>

							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Rota</label>
									<!--#include file="includes/inc_cmdRotaUnidade.asp"-->
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
if intCodTurma    = "" then intCodTurma="0"
if intCodPeriodo = "" then intCodPeriodo="0"

if intCodTurma<>"0" then%>

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
									<th><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></th>
									<th><strong>Ordem</strong></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
									cont  = 0
									sql = "SELECT  SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_TURMA.TurmaAluno, SCA_SITUACAOALUNO.DESC_SITUACAOALUNO"
									sql = sql & " FROM SCA_ALUNO_TURMA "
									sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
									SQL = SQL & " INNER JOIN SCA_ALUNO_ANO_LETIVO ON SCA_ALUNO_ANO_LETIVO.Cod_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_ANO_LETIVO.SITUACAO='A' "
									sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
									sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
									sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
									sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.Cod_SituacaoAluno"				
									sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso "
									sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
									sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
									sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
									sql = sql & " and 	SCA_ALUNO_TURMA.Semestre IN (" & intSemestre & ")"
									if intCodCurso <> "0" then
										sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
									end if
									if intCodPeriodo <> "0" then
										sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
									end if
									if intCodTurno <> "0" then
										sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
									end if
									if intCodTurma <> "0" then
										sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
									end if
									sql = sql & " and SCA_SITUACAOALUNO.DESC_SITUACAOALUNO = 'ATIVO'"
									sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
									rs.open sql, cnn
									
									if rs.eof = false then
									
									while not rs.eof
										cont = cont +1
										strMarca  				= ""
										strCodigoAluno        	= rs("codigo")
										strMatricula		  	= rs("MATRICULA")
																	
										sql = "SELECT cod_aluno "
										sql = sql & " FROM SCA_ROTA_VICULA_ALUNO"
										sql = sql & " WHERE cod_aluno = " & strCodigoAluno
										sql = sql & " and codRota = " & intCodRota
										RsAux.open sql, cnn
							
										if RsAux.eof = false then
											strMarca = "checked"
										end if
										RsAux.close
									
										 %>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="checkbox" id="chkAluno" name="chkAluno" <%=strMarca%> value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO")%></td>
											<td><%=rs("TURMAALUNO")%>&nbsp;&nbsp;<%=rs("NOMETURMA")%></td>
											<td><%=rs("Desc_SituacaoAluno")%></td>
										</tr>
										 <%
										 rs.movenext
									  wend
									  
								  else
									 %>
									 <tr> 
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