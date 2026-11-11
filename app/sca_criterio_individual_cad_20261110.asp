<%
	acao = "IE"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitPeriodo  		= "S"
	strExecutarSubmitTurno	 		= "S"
	strExecutarSubmitTurma	 		= "S"	
	strExecutarSubmitTipoCriterio = "S"

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	intCodCriterio 			= Trim(Request("cmbCriterio"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodTipoCriterio		= Trim(Request("cmbTipoCriterio"))
	strAtivos				= Trim(Request.Form("cmbativos"))
	IF strAtivos = "" THEN strAtivos = "A" 
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	IF intCodComp 		= "" THEN intCodComp 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodTipoCriterio 		= "" then intCodTipoCriterio 		= "0"

	strMostraAlunos = ""

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"
	retiraCriterio = 1


%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_criterio_individual.asp">
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
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Turma</label>
									<!--#include file="includes/inc_cmdTurma.asp"-->
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Critério</label>
									<!--#include file="includes/inc_cmdCriterio.asp"-->
								</div>
							</div>
							
							<div class="col-sm-4">
								<div class="form-group">
								
									<label class="form-label">Tipo de Cálculo</label>
									<!--#include file="includes/inc_cmdTipoCalculo.asp"-->
								</div>
							</div>
							
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situação do Aluno</label>
									<!--#include file="includes/inc_cmbAtivos.asp"-->
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
	if intCodSemestre = "" then intCodSemestre="0"
	if intCodTurma<>"0" then
		Cont=0

	%>
	<input name="txtCodCurso" type="hidden" id="txtCodCurso" class="text" size="10" value="<%=intCodComp%>">
	<input name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
						
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
									<th><strong>Critério Individual</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
							cont = 0				
							'seleciona os alunos da turma'	
							sql = sqlAlunoTurma(intCodTurma, "")
							rs.open sql, cnn
							if rs.eof = false then
								selecionado = "checked"
								while not rs.eof

									cont = cont +1
									strCodigoAluno        = rs("codigo")
									strMatricula		  = rs("MATRICULA")
									
									strBloqAltrExcl 	  = ""
									corLinha 			  = " "
									tipo_criterio=""
									data_hora_incl=""
									usuario_incl=""
									resultado_tipo_criterio = ""
									sql = "select ta.codigo, tc.descricao as tipo_criterio, u.USUA_NOME_COMPLETO as USUARIO_INCL, ta.data_hora_incl"
									sql = sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO ta "
									sql = sql & " inner join SCA_TIPO_CRITERIO tc on tc.codigo = ta.cod_tipo_criterio" 
									sql = sql & " left join SEG_USUARIOS_SISTEMA u on u.USUA_CODG = ta.usuario_incl" 
									sql = sql & " where ta.ano_letivo = " & strAnoLetivo
									sql = sql & " and ta.cod_empresa = " & session("CodEmpresa")
									sql = sql & " and ta.cod_curso = " & intCodComp
									sql = sql & " and ta.cod_aluno = " & strCodigoAluno
									rsAux.open sql, cnn
									if not rsAux.eof then
										tipo_criterio		  	= rsAux("tipo_criterio")
										usuario_incl 			= rsAux("USUARIO_INCL")
										data_hora_incl 			= rsAux("data_hora_incl")
										
										resultado_tipo_criterio = "<strong>" & tipo_criterio & "</strong><br>" & usuario_incl & "<br>" & data_hora_incl
									end if
									rsAux.close
									
										 %>
										 <tr style="cursor: pointer">
											<td width="1%">
												<input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
												<input type="checkbox" id="chkAluno"  <%=strBloqAltrExcl%>  name="chkAluno" value="<%=rs("codigo")%>">
											</td>
											<td><%=zeroleft(cont,2)%></td>
											<td><%=strMatricula%></td>
											<td><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
											<td><%=resultado_tipo_criterio%></td>
											<td><%=rs("Desc_SituacaoAluno")%></td>
										</tr>
										 <%
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