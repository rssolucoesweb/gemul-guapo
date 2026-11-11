<%
	acao = "I"
	strExecutarSubmitCurso	         = "S"
	strExecutarSubmitPeriodo         = "S"
	strExecutarSubmitGradeCurricular = "S"   
	strExecutarDisciplinaGrade       = "S"
	strPlanoEnsino_submit 			 = "S"

	strPaginaTitulo        					 	= "PlanoEnsino_cad.asp"

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
		intAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
		intAnoLetivo = request.Form("txtAnoLetivo")
	end if
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	    strSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	    strSemestre = request.Form("cmbSemestre")
	end if


	intCodigo 				= Trim(Request("txtCodigo"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intCodGrade				= Trim(Request("cmbGrade"))
	intCodDisciplinaGrade   = Trim(Request("cmbDisciplinaGrade"))
	strPlanoEnsino          = Trim(Request("cmbPlanoEnsino"))
	strTexto 				= Trim(Request("txttexto"))
 
	
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intCodGrade = "" then intCodGrade = "0"
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_PLANOENSINO "
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		if not rs.eof then
		
		   intCodigo							= rs("Codigo")
		   AnoLetivo							= rs("AnoLetivo")
		   intSemestre							= rs("Semestre")
		   intCodCurso							= rs("Cod_Curso")
		   intCodPeriodo						= rs("Cod_Periodo")
		   if Trim(Request.Form("cmbGrade"))="" or  Trim(Request.Form("cmbGrade")) = "0" then
		      intCodGrade						= rs("Cod_GradeCurricular")
		   end if
		   'if Trim(Request.Form("cmbDisciplinaGrade"))="" or  Trim(Request.Form("cmbDisciplinaGrade")) = "0" then
		      intCodDisciplinaGrade				= rs("Cod_GradeCurricularDisciplina")
		   'end if
		   strObjetivos							= rs("Objetivos")
		   strEmenta							= rs("Ementa")
		   strConteudoProgramatico				= rs("Conteudo_Programatico")
		   strMetodologia						= rs("Metodologia")
		   strBibliografiaBasica				= rs("Bibliografia_Basica")
		   strBibliografiaComplementar			= rs("Bibliografia_Complementar")
		   strCriterioAvaliacao					= rs("Criterio_Avaliacao")

			acao = "AE"

		end if 
		rs.close
	end if 
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></span></li>
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
			<div id="panel-1" class="panel">
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
						<form id="frm" name="frm" method="post">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Ano Letivo:</label>
										<input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Semestre:</label>
										 <!--#include file="includes/inc_cmdSemestre.asp" -->
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Curso:</label>
										<!--#include file="includes/inc_cmdCurso.asp" -->
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Período:</label>
										<!--#include file="includes/inc_cmdPeriodo.asp" -->
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Grade:</label>
										<!--#include file="includes/inc_cmdGradeCurricular.asp" -->
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Disciplina:</label>
										 <!--#include file="includes/inc_cmdDisciplinaGrade.asp" -->
									</div>
								</div>
							</div>
							<% 
							if strPlanoEnsino = "0" then strPlanoEnsino = "OBJ"
							
							if strPlanoEnsino = "OBJ" then
								msgPlanoEnsino 	= "OBJETIVOS"
								strTexto 		= strObjetivos
							elseif strPlanoEnsino = "EME" then	
								msgPlanoEnsino 	= "EMENTA"
								strTexto 		= strEmenta
							elseif strPlanoEnsino = "CON" then	
								msgPlanoEnsino 	= "CONTEÚDO PROGRAMÁTICO"
								strTexto 		= strConteudoProgramatico
							elseif strPlanoEnsino = "MET" then	
								msgPlanoEnsino 	= "METODOLOGIA DE AVALIAÇÃO"
								strTexto 		= strMetodologia
							elseif strPlanoEnsino = "BIB" then	
								msgPlanoEnsino 	= "BIBLIOGRAFIA BÁSICA"
								strTexto 		= strBibliografiaBasica
							elseif strPlanoEnsino = "BIC" then	
								msgPlanoEnsino 	= "BIBLIOGRAFIA COMPLEMENTAR"
								strTexto 		= strBibliografiaComplementar
							elseif strPlanoEnsino = "CRI" then	
								msgCriterioAvalicao = "CRITÉRIO DE AVALIAÇÃO"
								strTexto 		= strCriterioAvaliacao
							end if	
							%>
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Ementa:</label>
										<!--#include file="includes/inc_cmbPlanoEnsino.asp" -->
									</div>
								</div>
							</div>
							
							<textarea id="txtTexto" name="txtTexto"><%=strTexto%></textarea>
							<div class="row">
								<div class="col-xl-12">
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <div class="js-summernote" id="saveToLocal">
												
											</div>
											
                                            <div class="mt-3">
                                                <div class="custom-control custom-checkbox">
                                                    <input type="checkbox" class="custom-control-input" id="autoSave">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
							
							<br>
							
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	cont =0
	if intCodCurso = "" then intCodCurso= "0"
	sql = "SELECT con.codigo, cur.descricao as Curso, per.descricao as periodo, dis.desc_disciplina, Objetivos, Ementa, Conteudo_Programatico, Metodologia, Bibliografia_Basica, Bibliografia_Complementar, Criterio_Avaliacao " 
	sql = sql & " FROM sca_planoensino con "
	sql = sql & " inner join sca_curso cur on cur.cod_curso = con.cod_curso "
	sql = sql & " inner join sca_periodo per on per.cod_periodo = con.cod_periodo "
	sql = sql & " inner join sca_disciplina dis on dis.cod_disciplina = con.cod_gradecurricularDisciplina "
	sql = sql & " inner join SCA_GRADECURRICULAR gc on gc.Cod_GradeCurricular = con.Cod_GradeCurricular "
	sql = sql & " where con.AnoLetivo = " & strAnoLetivo
	sql = sql & " and con.Semestre = " & strSemestre
	sql = sql & " and con.cod_curso = " & intCodCurso
	sql = sql & " order by cur.descricao, per.descricao, dis.desc_disciplina " 	
	rs.open sql, cnn
			
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastrados
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Grade - Curso</strong></th>
									<th><strong>Per&iacute;odo</strong></th>
									<th><strong>Disciplina</strong></th>
									<th><strong>Objetivo</strong></th>
									<th><strong>Ementa</strong></th>
									<th><strong>Conte&uacute;do</strong></th>
									<th><strong>Metodologia</strong></th>
									<th><strong>Bibliografia B&aacute;sica </strong></th>
									<th><strong>Bibliografia Complem.</strong></th>
									<th><strong>Crit&eacute;rio de Avalia&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									
									while not rs.eof
										cont = cont + 1

										msgObjetivos = "OK"
										msgEmenta = "OK"
										msgConteudo_Programatico = "OK"
										msgMetodologia = "OK"
										msgBibliografia_Basicas = "OK"
										msgBibliografia_Complementar = "OK"
										msgCriterio_Avalicao = "OK"

										if rs("periodo") <> periodo then
											if strCorLinha = "bgcolor='#D5EAFF'" then
												strCorLinha = " bgcolor='#D9FFEC'"
											else
												strCorLinha = "bgcolor='#D5EAFF'"
											end if
										end if

										if isnull(rs("Objetivos")) or rs("Objetivos") = "" then msgObjetivos = "----"
										if isnull(rs("Ementa")) or rs("Ementa") = "" then msgEmenta = "----"
										if isnull(rs("Conteudo_Programatico")) or rs("Conteudo_Programatico") = "" then msgConteudo_Programatico = "----"
										if isnull(rs("Metodologia")) or rs("Metodologia") = "" then msgMetodologia = "----"
										if isnull(rs("Bibliografia_Basica")) or rs("Bibliografia_Basica") = "" then msgBibliografia_Basicas = "----"
										if isnull(rs("Bibliografia_Complementar")) or rs("Bibliografia_Complementar") = "" then msgBibliografia_Complementar = "----"
										if isnull(rs("Criterio_Avaliacao")) or rs("Criterio_Avaliacao") = "" then msgCriterio_Avalicao = "----"

										%>
										  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
											<td><%=rs("Cod_Agrupamento")%>&nbsp;-&nbsp;<%=rs("Curso")%></td>
											<td><%=trim(rs("periodo"))%></td>
											<td><%=trim(rs("desc_disciplina"))%></td>
											<td align="center"><%=msgObjetivos%></td>
											<td align="center"><%=msgEmenta%></td>
											<td align="center"><%=msgConteudo_Programatico%></td>
											<td align="center"><%=msgMetodologia%></td>
											<td align="center"><%=msgBibliografia_Basicas%></td>
											<td align="center"><%=msgBibliografia_Complementar%></td>
											<td align="center"><%=msgCriterio_Avalicao%></td>
										  </tr>
										  <%	
										periodo = rs("periodo")
					
										rs.movenext
									wend
									%>
									<tr>
										<td height="21" colspan="12" class="celula">Total Registros : <%=cont%></td>
									</tr>
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
	rs.close
	  
	%>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
