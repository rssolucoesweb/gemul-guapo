<%
	acao = "I"

	strExecutarSubmitCurso = "S"
	strExecutarSubmitTipoCalculo = "S"
	strDesabilitaEditar = "disabled"
	intCodSemestre 			= request.Form("cmbSemestre")

	strcondicaoEF_notaInicial	= request.Form("condicaoEF_notaInicial")
	strcondicaoEF_notaFinal		= request.Form("condicaoEF_notaFinal")
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if	
	if intCodSemestre 		= "" then intCodSemestre = "0"
	strTipoFormulaFinal		= request.Form("formulaFinal")
	if strTipoFormulaFinal = "" then strTipoFormulaFinal = "EF"

	
	intCodTipoCalculoCriterio = Trim(Request.form("cmbTipoCalculoCriterio"))
	intCodCurso 				= Trim(Request.form("cmbCurso"))
	if intCodCurso = "" then
		intCodCurso = Trim(Request("cmbCurso"))
	end if

	if intCodCurso = "" then intCodCurso="0"
	if intCodTipoCalculoCriterio = "" then intCodTipoCalculoCriterio="0"
	'seleciona os dados da composição escolhida
	if intCodCurso <> "0" and strAnoLetivo<>"" then
		sql	=	"select * from SCA_CRITERIO_AVALIACAO"
		sql	=	sql & " where ano_letivo = '" & strAnoLetivo & "'"
		sql	=	sql & " and cod_curso = " & intCodCurso
		rs.open sql, cnn
		if rs.eof = false then
			strDesabilitaEditar= ""
			intCodigo		   				= trim(rs("codigo"))
			intCodCurso		   				= trim(rs("cod_curso"))
			strAnoLetivo	   				= trim(rs("ano_letivo"))
			intCodTipoCalculoCriterio		= trim(rs("cod_tipo_calculo"))
			strMedia           				= trim(rs("media_aprovacao"))
			strMediaAprovacaoFinal      	= trim(rs("media_aprovacao_final"))
			strTipoFormulaFinal 			= trim(rs("tipoFormulaFinal"))
			intFrequencia      				= trim(rs("frequencia_minima_percentual"))
			intDuracao         				= trim(rs("qtd_aula"))

			if isnull(rs("condicaoEF_notaInicial")) = false then
				strcondicaoEF_notaInicial = rs("condicaoEF_notaInicial")
			else
				strcondicaoEF_notaInicial = ""
			end if
			if isnull(rs("condicaoEF_notaFinal")) = false then
				strcondicaoEF_notaFinal = rs("condicaoEF_notaFinal")
			else
				strcondicaoEF_notaFinal = ""	
			end if				
					
			
			intNumDisciplinaRec         = rs("num_disciplina_recuperacao")
			intNumDisciplinaPorgParcial = rs("num_disciplina_prog_parcial")
			
			acao = "AE"
		
		end if
		rs.close
		
	end if
	
	'seleciona o nome da composicao
	sql="select descricao from sca_curso"
	sql=sql & " where cod_curso = " & intCodCurso
	rs.open sql, cnn
	if rs.eof = false then
		strNomeComp = rs("descricao")
	end if
	rs.close
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
	<form id="frm" name="frm" method="post">
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
						
						<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-6">	
								<div class="form-group">
									<label class="form-label">Curso</label>
									<!--#include file="includes/inc_cmdCurso.asp"-->
								</div>
							</div>	

							<div class="col-sm-4">	
								<div class="form-group">
									<label class="form-label">Tipo de Cálculo</label>
									<!--#include file="includes/inc_cmbTipoCalculoCriterio.asp"-->
								</div>
							</div>	
						</div>
						<hr>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">M&eacute;dia de Aprova&ccedil;&atilde;o Recupera&ccedil;&atilde;o</label>
									<input name="txtMediaAprovacaoFinalREC" type="text" class="form-control" id="txtMediaAprovacaoFinalREC" value="<%=strMediaAprovacaoFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)">
								</div>
							</div>	
							<div class="col-sm-6">	
								<div class="form-group">
									<label class="form-label">Qtde. de disciplinas p/recupera&ccedil;&atilde;o</label>
									<input name="txtNumDisciplinaRec" type="text" class="form-control" id="txtNumDisciplinaRec" onKeyPress="return formataCampo(this,2,3)" value="<%=intNumDisciplinaRec%>" size="3" maxlength="2">
								</div>
							</div>	
						</div>
						<div class="row">
							<div class="col-sm-6">	
								<div class="form-group">
									<label class="form-label">Qtde. de disciplinas p/depend&ecirc;ncia</label>
									<input name="txtNumDisciplinaPorgParcial" type="text" class="form-control" id="txtNumDisciplinaPorgParcial" onKeyPress="return formataCampo(this,2,3)" value="<%=intNumDisciplinaPorgParcial%>" size="3" maxlength="2">
								</div>
							</div>	
							<div class="col-sm-6">	
								<div class="form-group">
									<label class="form-label">M&eacute;dia de Aprova&ccedil;&atilde;o Final</label>
									<input name="txtMedia" type="text" class="form-control" id="txtMedia" value="<%=strMedia%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)">
								</div>
							</div>	
						</div>
						<div class="row">
							<div class="col-sm-6">	
								<div class="form-group">
									<label class="form-label">Percentual de Faltas para Reprova&ccedil;&atilde;o acima de</label>
									<input name="txtFrequencia" type="text" class="form-control" id="txtFrequencia" value="<%=intFrequencia%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
								</div>
							</div>
							<div class="col-sm-6">	
								<div class="form-group">
									<label class="form-label">Dias Letivos</label>
									<input name="txtDuracao" type="text" class="form-control" id="txtDuracao" value="<%=intDuracao%>" size="5" maxlength="3">
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
	cont =0
	intQtdeAvaliacao = 0

if intCodigo = "" then intCodigo = 0
if intCodCurso = "" then intCodCurso = "0"
if intCodCurso <> "0" and intCodTipoCalculoCriterio<>"0" and strAnoLetivo<>"" then

	cont =0
	sql = "select _ca.codigo, _cri.descricao as criterio, _ca.descricao, _ca.sigla, _ca.posicao, _lan.Descricao as tipo_lancamento, _ca.formula, _ca.digitar"
	sql = sql & " from SCA_CALCULO _ca"
	sql = sql & " inner join SCA_TIPO_CALCULO _tc on _tc.codigo = _ca.cod_tipo_calculo"
	sql = sql & " inner join SCA_CRITERIO _cri on _cri.codigo = _tc.cod_criterio"
	sql = sql & " inner join SCA_TIPO_LANCAMENTO _lan on _lan.codigo = _ca.cod_tipo_lancamento"
	sql = sql & " where _tc.cod_criterio = " & intCodCriterio
	sql = sql & " and _ca.cod_tipo_calculo = " & intCodTipoCalculoCriterio
	sql = sql & " Order by _ca.posicao"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						Tipo de Cálculo
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
									<th><strong>Critério</strong></th>
									<th><strong>Descrição</strong></th>
									<th><strong>Sigla</strong></th>
									<th><strong>Tipo</strong></th>
									<th><strong>Campo</strong></th>
									<th><strong>F&oacute;rmula</strong></th>
									<th><strong>Digitar</strong></th>
								  </tr>
								</thead>
								<tbody>
									<%
									while not rs.eof
										cont = cont + 1	
										%>
										  <tr>
											<td class="celula"><%=rs("criterio")%>&nbsp;</td>
											<td height="20" class="celula"><%=trim(rs("descricao"))%></td>
											<td height="20" class="celula"><%=trim(rs("sigla"))%></td>
											<td class="celula"><%=rs("tipo_lancamento")%></td>
											<td height="20" class="celula">C<%=trim(rs("posicao"))%></td>
											<td class="celula"><%=trim(rs("formula"))%>&nbsp;</td>
											<td class="celula" align="center"><%=trim(rs("digitar"))%>&nbsp;</td>
										  </tr>
										  <%				
										rs.movenext
									wend
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
		rs.close
	end if
	  
	%>
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>