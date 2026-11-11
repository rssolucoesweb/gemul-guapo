<%
	acao = ""

	intCodigo	 						= Trim(Request.Form("txtCodigo"))
    strReplicar   						= Trim(Request.Form("cmbReplicar"))
	intAno								= Trim(Request.Form("txtAno"))
	intSemestre							= Trim(Request.Form("cmbSemestre"))
	strDataEncerramento					= Trim(Request.Form("txtDataEncerramento"))
	strSimouNaoDocente					= Trim(Request.Form("cmbSimouNaoDocente"))
	intCodAvaliacaoAgrupamento			= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
    strSimouNaoSecretaria    			= Trim(Request.Form("cmbSimouNaoSecretaria"))
    strSimouNaoCampoAcumuladaFalta 		= Trim(Request.Form("cmbSimouNaoCampoAcumuladaFalta"))
    strSimouNaoDocumentacaoColaboradores= Trim(Request.Form("cmbSimouNaoDocumentacaoColaboradores"))
    strSimouNaoHabilitaPlanoEnsino      = Trim(Request.Form("cmbSimouNaoHabilitaPlanoEnsino"))
    strSimouNaoPreMatricula      		= Trim(Request.Form("cmbSimouNaoPreMatricula"))
    strSimouNaoDocumentos 				= Trim(Request.Form("cmbSimouNaoDocumentos"))
    strSimouNaoBiblioteca 				= Trim(Request.Form("cmbSimouNaoBiblioteca"))
    strCriarGradeChecandoHistorico 		= Trim(Request.Form("cmbCriarGradeChecandoHistorico"))
	strNotificacao1						= Trim(Request.Form("txtNotificacao1"))
	strNotificacao2						= Trim(Request.Form("txtNotificacao2"))
	strMes								= Trim(Request("cmbMes"))

    strGestorMaster = ""
    strGestorSuporte  = ""
    strGestorManutencao = ""
	sql = "select ISNULL(USUARIO_MASTER,'N') as USUARIO_MASTER, "
	sql = sql & " ISNULL(GESTOR_SUPORTE,'N') as GESTOR_SUPORTE, "
	sql = sql & " ISNULL(GESTOR_MANUTENCAO,'N') as GESTOR_MANUTENCAO "
	sql = sql & " From SEG_USUARIOS_SISTEMA"
	sql = sql & " where Usua_Codg = '"& Trim(session("UsuarioWeb")) & "'"
	rs.open sql, cnn
	if rs.eof = false then
	   strGestorMaster = trim(rs("USUARIO_MASTER"))
	   strGestorSuporte = trim(rs("GESTOR_SUPORTE"))
	   strGestorManutencao = trim(rs("GESTOR_MANUTENCAO"))
	end if
	rs.close


	if strMes = "0" then strMes = month(date) 
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento, Bloqueia_NotasDocente, Permitir_AlteracaoNotaDocente, "
		sql = sql & " Bloqueia_NotasSecretaria, Bloqueia_CampoAcumuladaFalta, Bloqueia_ConteudoProgramatico, Habilitar_PlanoEnsino, Habilitar_PreMatricula, "
		sql = sql & " NC_Matricula_Documentacoes, NC_Matricula_Biblioteca, DocumentacaoColaboradores, notificacao1, notificacao2, CriarGrade_ChecandoHistorico"
		sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo							= rs("Codigo")
			intAno								= rs("ano_letivo")
			intAnoAnterior						= rs("ano_letivo")
			intSemestre							= rs("semestre")
			strDataEncerramento					= formataDataAP(rs("data_encerramento"))
			strSimouNaoDocente					= rs("Bloqueia_NotasDocente")
			intCodAvaliacaoAgrupamento			= rs("Permitir_AlteracaoNotaDocente")
			
			strSimouNaoSecretaria				= rs("Bloqueia_NotasSecretaria")
			strSimouNaoCampoAcumuladaFalta		= rs("Bloqueia_CampoAcumuladaFalta")
			strSimouNaoHabilitaPlanoEnsino      = rs("Habilitar_PlanoEnsino")
			
			if Trim(Request.Form("cmbSimouNaoPreMatricula")) = "0" then
				strSimouNaoPreMatricula     		= rs("Habilitar_PreMatricula")
			end if
			
			strSimouNaoDocumentos	     		= rs("NC_Matricula_Documentacoes")
			strSimouNaoBiblioteca     			= rs("NC_Matricula_Biblioteca")
			strSimouNaoDocumentacaoColaboradores= rs("DocumentacaoColaboradores")
			strNotificacao1						= rs("Notificacao1")
			strNotificacao2						= rs("Notificacao2")
			strMes								= rs("Bloqueia_ConteudoProgramatico")
			strCriarGradeChecandoHistorico		= rs("CriarGrade_ChecandoHistorico")
			
			if isnull(strMes) then strMes = "0"
			
			acao = "A"

		end if 
		rs.close
		
	else
	    if session("nivelpermissao")= "A" then
		   acao = "I"
		end if   
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
							<input name="txtAnoAnterior" type="hidden" id="txtAnoAnterior" value="<%=intAnoAnterior%>">
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Fechamento do ano letivo</strong></span>
								</div>	
							</div>					
							<br>
							<% if strGestorMaster = "S" or strGestorSuporte = "S" or strGestorManutencao = "S" then %>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Replicar configura&ccedil;&otilde;es em todas unidades do grupo</label>
										<select name="cmbReplicar" class="form-control" id="cmbReplicar">
										  <option value="N" <%if strReplicar = "N" then response.Write("selected") %>>NAO</option>
										  <option value="S" <%if strReplicar = "S" then response.Write("selected") %>>SIM</option>
										</select>
									</div>
								</div>	
							</div>
							<% end if %> 
							<div class="row">
								<div class="col-sm-6">	
									<div class="form-group">
										<label class="form-label">Ano</label>
										<input type="text" id="txtAno" name="txtAno" class="form-control" value="<%=intAno%>" maxlength="4"  onKeyPress="return formataCampo(this,2,4)">
									</div>
								</div>
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Semestre</label>
										<!--#include file="includes/inc_cmdSemestreTodos.asp"-->
									</div>
								</div>	
								<div class="col-sm-3">	
									<div class="form-group">
										<label class="form-label">Data de Encerramento</label>
										<input type="text" id="txtDataEncerramento" name="txtDataEncerramento" class="form-control" value="<%=strDataEncerramento%>" maxlength="10" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)">
									</div>
								</div>
								
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Controlando Atividades</strong></span>
								</div>	
							</div>					
							<br>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Bloquear Lancto Notas Docentes?</label>
										<select name="cmbSimouNaoDocente" class="form-control" id="cmbSimouNaoDocente"  >
										  <option value="0">Selecione...</option>
										  <option value="S" <%if strSimouNaoDocente = "S" then response.Write("selected") %>>SIM</option>
										  <option value="N" <%if strSimouNaoDocente = "N" then response.Write("selected") %>>NAO</option>
										</select>
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Permitir altera&ccedil;&atilde;o Notas ao Docentes?</label>
										<!--#include file="includes/inc_cmdTipoAvaliacaoAgrupamentoDigitacao.asp"-->
									</div>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Bloquear Lancto Notas Secretaria?</label>
										<select name="cmbSimouNaoSecretaria" class="form-control" id="cmbSimouNaoSecretaria" >
										  <option value="0">Selecione...</option>
										  <option value="S" <%if strSimouNaoSecretaria = "S" then response.Write("selected") %>>SIM</option>
										  <option value="N" <%if strSimouNaoSecretaria = "N" then response.Write("selected") %>>NAO</option>
										</select>
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Bloquear Campo Acumulada de Faltas?</label>
										<select name="cmbSimouNaoCampoAcumuladaFalta" class="form-control" id="cmbSimouNaoCampoAcumuladaFalta">
										  <option value="0">Selecione...</option>
										  <option value="S" <%if strSimouNaoCampoAcumuladaFalta = "S" then response.Write("selected") %>>SIM</option>
										  <option value="N" <%if strSimouNaoCampoAcumuladaFalta = "N" then response.Write("selected") %>>NAO</option>
										</select>
									</div>
								</div>									
							</div>	
							<br>
							
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Bloquear Conte&uacute;do Program&aacute;tico at&eacute; o m&ecirc;s</label>
										<!--#include file="includes/inc_cmbMesConteudo.asp"-->
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Habilitar Plano de Ensino?</label>
										<select name="cmbSimouNaoHabilitaPlanoEnsino" class="form-control" id="cmbSimouNaoHabilitaPlanoEnsino" >
										  <option value="0">Selecione...</option>
										  <option value="S" <%if strSimouNaoHabilitaPlanoEnsino = "S" then response.Write("selected") %>>SIM</option>
										  <option value="N" <%if strSimouNaoHabilitaPlanoEnsino = "N" then response.Write("selected") %>>NAO</option>
										</select>
									</div>
								</div>									
							</div>	
							<br>
							
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Criar ou Atualizar Matriz Curricular checando o Hist&oacute;rico?</label>
										<select name="cmbCriarGradeChecandoHistorico" class="form-control" id="cmbCriarGradeChecandoHistorico">
										  <option value="0">Selecione...</option>
										  <option value="S" <%if strCriarGradeChecandoHistorico = "S" then response.Write("selected") %>>SIM</option>
										  <option value="N" <%if strCriarGradeChecandoHistorico = "N" then response.Write("selected") %>>NAO</option>
										</select>
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">Controlar Documenta&ccedil;&atilde;o de Colaboradores pelo Grau de Instru&ccedil;&atilde;o?</label>
										<select name="cmbSimouNaoDocumentacaoColaboradores" class="form-control" id="cmbSimouNaoDocumentacaoColaboradores">
										  <option value="0">Selecione...</option>
										  <option value="S" <%if strSimouNaoDocumentacaoColaboradores = "S" then response.Write("selected") %>>SIM</option>
										  <option value="N" <%if strSimouNaoDocumentacaoColaboradores = "N" then response.Write("selected") %>>NAO</option>
										</select>
									</div>
								</div>	
							</div>	
							<br>
							<div class="row">
								<div class="col-sm-12">
									<span><strong>Quadro de Avisos  ( at&eacute; 800 caracteres por linha )</strong></span>
								</div>	
							</div>					
							<br>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">01.</label>
										<textarea name="txtNotificacao1" cols="120" rows="6" class="form-control" id="txtNotificacao1"><%=strNotificacao1%></textarea>
									</div>
								</div>	
								<div class="col-sm-6">
									<div class="form-group">
										<label class="form-label">02.</label>
										<textarea name="txtNotificacao2" cols="120" rows="6" class="form-control" id="txtNotificacao2"><%=strNotificacao2%></textarea>
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
	sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento"
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " Order by codigo"
	rs.open sql, cnn
			
	if rs.eof = false then
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
						<div class="panel-tag">
							<span class="fw-300">Para editar clique na linha abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Ano letivo</strong></th>
									<th><strong>Semestre</strong></th>
									<th><strong>Data de Encerramento</strong></th>
								  </tr>
								</thead>
								<tbody>
								
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("ano_letivo")%></td>
									<td height="20" class="celula"><%=trim(rs("semestre"))%></td>
									<td height="20" class="celula"><%=formataDataAP(trim(rs("data_encerramento")))%></td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
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