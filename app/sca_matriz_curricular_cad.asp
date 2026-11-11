<%
	acao = "I"

	strExecutarSubmitCurso		                 = "S"

	intCodEmp = Session("CodEmpresa")

	strPagina = "GradeCurricular_cad.asp"
	
	
	if trim(request.querystring("nCodigo")) <> "" then
		intCodigo 		= trim(request.querystring("nCodigo"))
	else
		intCodigo	 	= Trim(Request.Form("txtCodigo"))
	end if
    if Trim(Request.Form("txtCodigo")) <> "" then BloqueiaCampo = " readonly "

	intCodCurso				= Trim(Request.Form("cmbCurso"))
	intCodCursoResolucao	= Trim(Request.Form("cmbCursoResolucao"))
	intCodPeriodo			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	intAno					= Trim(Request.Form("txtAno"))
	intCodDisciplina		= Trim(Request("txtCodDisciplina"))
	intCodAgrupamento   	= Trim(Request("txtCodAgrupamento"))
	strNomeMatriz   	= Trim(Request("txtNomeMatriz"))
	diferenciada 			= Trim(Request.Form("diferenciada"))
	'intCodGradeEquivalente 		= Trim(Request.Form("cmbGradeEquivalente"))
				
	if trim(intCodigo) <> "" then
	
		sql = "SELECT     	SCA_GRADECURRICULAR.Cod_GradeCurricular, "
		sql = sql & " 		SCA_PERIODO.Cod_Curso, "
		sql = sql & " 		SCA_GRADECURRICULAR.AnoReferencia, "
		sql = sql & "       SCA_GRADECURRICULAR.SemestreReferencia, "
		sql = sql & " 		SCA_GRADECURRICULAR.Situacao, "
		sql = sql & " 		SCA_GRADECURRICULAR.Cod_Periodo, "
		sql = sql & "       SCA_GRADECURRICULAR.dataInicioVigencia, "
		sql = sql & "       SCA_GRADECURRICULAR.dataFimVigencia, "
		sql = sql & "       SCA_GRADECURRICULAR.diferenciada, "
		sql = sql & "       SCA_CURSO.Descricao as descCurso, SCA_PERIODO.Descricao AS DESC_PERIODO "
		sql = sql & " FROM  SCA_GRADECURRICULAR INNER "
		sql = sql & " JOIN 	SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " JOIN 	SCA_CURSO ON SCA_CURSO.Cod_CURSO = SCA_PERIODO.Cod_CURSO"
		sql = sql & " WHERE COD_GRADECURRICULAR = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("COD_GRADECURRICULAR")
			intCodCurso				= rs("Cod_Curso")
			intCodPeriodo			= rs("Cod_Periodo")
			intAno					= rs("AnoReferencia")
			intSemestre 			= rs("SemestreReferencia")
			strSituacao				= rs("Situacao")
			strNomeMatriz = rs("descCurso") & " - " & rs("DESC_PERIODO")
			'vingecia
			strDataInicio		= rs("dataInicioVigencia")
			strDataFim			= rs("dataFimVigencia")
			diferenciada		= rs("diferenciada")
			acao = "AE"

		end if 
		rs.close
		
	
	end if 
	
	if intCodCurso = "" then intCodCurso = 0
	
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
		<div class="col-xl-10">
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
							
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group"><strong>Matriz</strong></label>
										<div class="input-group">
											
											<input type="text" class="form-control" value="<%=intCodigo%>" name="txtCodigo" id="txtCodigo" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
											<div class="input-group-append">
												<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsulta('sca_matriz_curricular_con.asp')"><i class="fal fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-9">
									<div class="form-group">
										<label class="form-label"></label>
										<input type="text" name="txtNomeMatriz" readonly id="txtNomeMatriz" class="form-control" value="<%=strNomeMatriz%>">
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Curso</label>
										<!--#include file="includes/inc_cmdCurso.asp" -->
									</div>
								</div>	
								
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Período</label>
										<!--#include file="includes/inc_cmdPeriodo.asp" -->
									</div>
								</div>	
							
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Situa&ccedil;&atilde;o</label>
										<!--#include file="includes/inc_cmbSituacao.asp" -->
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Matriz Diferenciada</label>
										<select name="diferenciada" class="form-control" id="diferenciada" >
										  <option value="N" <%if diferenciada = "N" then response.Write("selected") %>>NÃO</option>
										  <option value="S" <%if diferenciada = "S" then response.Write("selected") %>>SIM</option>
										</select>
										
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Dados da Criação</strong></span>
								</div>	
							</div>					
							<br>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ano Refer&ecirc;ncia</label>
										<input  name="txtAno" type="text" class="form-control" id="txtAno"  value="<%=intAno%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Semestre Refer&ecirc;ncia</label>
										<!--#include file="includes/inc_cmdSemestre.asp" -->
									</div>
								</div>	
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ving&ecirc;ncia inicial</label>
										<input name="txtDataInicio" type="text" class="form-control" id="txtDataInicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicio%>">
									</div>
								</div>
								<div class="col-sm-3">
									<div class="form-group">
										<label class="form-label">Ving&ecirc;ncia final</label>
										<input name="txtDataFim" type="text" class="form-control" id="txtDataFim" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFim%>">
									</div>
								</div>
								
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Disciplinas</label>
										
										<!-- disc -->
                
										<%
										if intCodigo="" then
											sql = "	SELECT "
											SQL = SQL & " NULL as Cod_disciplina_grade, "
											SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
											SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
											SQL = SQL & " FROM SCA_DISCIPLINA where uso_historico = 'N'"
											SQL = SQL & " Order by SCA_DISCIPLINA.DESC_Disciplina"
										else
											sql = "	SELECT DISTINCT "
											SQL = SQL & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina as Cod_disciplina_grade, "
											SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
											SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
											SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA "
											SQL = SQL & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina"
											SQL = SQL & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo

											sql = SQL & " UNION SELECT "
											SQL = SQL & " NULL as Cod_disciplina_grade, "
											SQL = SQL & " COD_Disciplina,"
											SQL = SQL & " DESC_Disciplina"
											SQL = SQL & " FROM SCA_DISCIPLINA "
											SQL = SQL & " WHERE uso_historico = 'N' "
											SQL = SQL & " AND COD_Disciplina NOT IN ("
											
											SQL = SQL & " 		SELECT DISTINCT "
											SQL = SQL & " 		SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina"
											SQL = SQL & " 		FROM SCA_GRADECURRICULARDISCIPLINA "
											SQL = SQL & " 		INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina"
											SQL = SQL & " 		WHERE 1=1"
											SQL = SQL & " 		AND SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
											SQL = SQL & " 										)"

											SQL = SQL & " Order by 3"
										end if
										rs.open sql, cnn
										if not rs.eof then  
										%>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										  <tr>
											<%	
											cont = 0
											while not rs.eof
												if cint(cont) = 2 then 
													%>
													<tr>
													<%
												end if

												selecionaDisciplina = ""
												if not isnull(rs("Cod_disciplina_grade")) then selecionaDisciplina = " checked "
												%>
												<td width="33%" class="texto1"><input <%=selecionaDisciplina%> name="txtCodDisciplina" id="txtCodDisciplina" type="checkbox" value="<%=rs("COD_Disciplina")%>">
												<%=trim(ucase(rs("DESC_Disciplina")))%></td>
												<%
												cont = cont + 1
												if cint(cont) = 2 then 
													%>
													</tr>
															<tr>
													<%
													cont  = 0
												end if
												
												rs.movenext
											wend
											%>
											</tr>
										</table>
										<%
										end if
										rs.close				  
										%>                
										
										<!-- disc --> 
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
if intCodigo <> "" then
	sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina,  isnull(SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,'N') as Omitir_Criterio,"
	sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Pratica, SCA_GRADECURRICULARDISCIPLINA.Ch_Teorica, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina_Equivalente, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular_Equivalente,"
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina_Equivalente, "
	sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
	sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
	sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
	sql = sql & " order by SCA_DISCIPLINA.DESC_Disciplina"
	rs.open sql, cnn		
	if not rs.eof then
		id = 0
	%>
	<div class="row">
		<div class="col-xl-10">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> <%if diferenciada = "S" then%>&nbsp;<strong><font color="red">DIFERENCIADA</font></strong>&nbsp;<%end if%> cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na disciplina abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th>Ação</th>
									<th><strong>Disciplina</strong></th>
									<th><strong>C.H. Semanal</strong></th>
									<th><strong>C.H. Mensal</strong></th>
									<th><strong>C.H. Total</strong></th>
									<th><strong>C.H. Pr&aacute;tica</strong></th>
									<th><strong>C.H. Te&oacute;rica</strong></th>
									<th><strong>Omitir C.A.</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										intCodGradeEquivalente = rs("Cod_GradeCurricular_Equivalente")
										intCodDisciplinaGradeEquivalente = rs("Cod_GradeCurricularDisciplina_Equivalente")
										intCodDisciplinaEquivalente = rs("Cod_Disciplina_Equivalente")
										
										%>
										  <tr>
											<td style="cursor: pointer" class="celula">
											<%if trim(strBotaoAlterar) = "" then%> 
											<button onClick="return AlteraDisciplina('<%=intCodigo%>','<%=rs("Cod_GradeCurricularDisciplina")%>')"  type="button" class="btn btn-outline-primary btn-sm">Editar</button>
											<%end if%>
											<%if trim(strBotaoAlterar) = "" then%> 
											<button onClick="ExcluirDisciplina('<%=intCodigo%>','<%=rs("Cod_GradeCurricularDisciplina")%>')" type="button" class="btn btn-outline-danger btn-sm">Excluir</button>
											<%end if%>
											</td>
											<td height="20" class="celula"><strong><%=rs("DESC_Disciplina")%>&nbsp;</strong></td>
						
											<td height="20" class="celula"><%=trim(rs("Ch_Semanal"))%></td>
											<td height="20" class="celula"><%=trim(rs("Ch_Mensal"))%></td>
											<td height="20" class="celula"><%=trim(rs("Ch_Anual"))%></td>
											<td height="20" class="celula"><%=trim(rs("Ch_Pratica"))%></td>
											<td height="20" class="celula"><%=trim(rs("Ch_Teorica"))%></td>
											<td height="20" class="celula"><%=trim(rs("Omitir_Criterio"))%></td>
										  </tr>
										<%	
										cont										 = cont + 1
										rs.movenext
									wend
									%>
									<tr>
										<td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
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
end if	  
	%>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>