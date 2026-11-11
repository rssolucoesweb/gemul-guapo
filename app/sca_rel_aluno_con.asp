<%
	strPaginaDestino = "sca_rel_alunoCon.asp"
	strEmpresaGrupo_submit	  = "S"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmit         = "S"
	strExecutarSubmitTipoEmpresa= "S"
	strExecutarFiltroTipoEmpresa = "1,2,3,4"
	intCodTipoEmpresa     	= Trim(Request.Form("cmbTipoEmpresa"))
	IF intCodTipoEmpresa = "" THEN intCodTipoEmpresa = "0"
	intCodEmpresaGrupo     	= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strMes					= Trim(Request.Form("cmbMes"))
	intCodFormaIngresso 	= Trim(Request.Form("cmbFormaIngresso"))
	intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))
	UNIFORME_TAMANHO     	= Trim(Request.Form("UNIFORME_TAMANHO"))
	TENIS_TAMANHO     		= Trim(Request.Form("TENIS_TAMANHO"))
	ID_CENSO     			= Trim(Request.Form("ID_CENSO"))
	COD_ETNIA     			= Trim(Request.Form("COD_ETNIA"))

	if strMes = "" then strMes = "0"

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	IF strlpp = "" THEN strlpp = "0"
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	IF strclasse = "" OR strclasse = "0" THEN strclasse = "celulaarial10" 

	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   


	if trim(intCodTurma) <> "" then
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

	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if strSexo = "" then strSexo = "0"
	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" method="post" action="sca_rel_alunoCon.asp">
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
						<%if session("NivelPermissao") = "A" then%>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Tipo de Unidade:</label>
									<!--#include file="includes/inc_cmdTipoEmpresaSession.asp" -->
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="form-label">Unidade:</label>
									<!--#include file="includes/inc_cmbEmpresaGrupoSession.asp" -->
								</div>
							</div>
						</div>
						<%else%>
						<input name="cmbTipoEmpresa" type="hidden" id="cmbTipoEmpresa" value="9999">
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
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Curso:</label>
									<!--#include file="includes/inc_cmdCurso.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Per&iacute;odo:</label>
									<!--#include file="includes/inc_cmdPeriodo.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turno:</label>
									 <!--#include file="includes/inc_cmdTurno.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Turma:</label>
									 <!--#include file="includes/inc_cmdTurma.asp" -->
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-group">
									<label class="form-label">Situa&ccedil;&atilde;o:</label>
									<!--#include file="includes/inc_cmdSituacaoAluno.asp" -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Sexo:</label>
									<!--#include file="includes/inc_cmdSexo.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Aniversariante:</label>
									 <!--#include file="includes/inc_cmbMes.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Idade:</label>
									 <!--#include file="includes/inc_cmbIdade.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Necessidade especiais</label>
									 <!--#include file="includes/inc_cmdNecessidadeEspecialSN.asp" -->
								</div>
							</div>
							<div class="col-sm-2">
								<div class="form-group">
									<label class="form-label">Atendimento Especial:</label>
									<select name="cmbAtendimentoEspecial" class="form-control" id="cmbAtendimentoEspecial"  >
									  <option value="0" >Selecione...</option>
									  <option value="S" >Sim</option>
									  <option value="N" >Não</option>
									</select>
								</div>
							</div>	
							<div class="col-sm-2">	
								<div class="form-group">
									<label class="form-label">Usa Sala AEE</label>
									<select name="cmbSalaAEE" class="form-control" id="cmbSalaAEE">
									<option value="0" >Selecione...</option>
										<option value="N" <%if strSalaAEE = "N" then response.Write("selected") %>>N&atilde;o</option>
										<option value="S" <%if strSalaAEE = "S" then response.Write("selected") %>>Sim</option>
									</select>
									</div>
							</div>	
						</div>
						
						<div class="alert alert-success" role="alert" id="listaDeficiencias" style="display:none">
										
							<div class="checkbox-title">Selecione as necessidade especiais que deseja filtrar para o relatório:</div>		
							<!-- Deficiência -->
							<div class="checkbox-title">Deficiência</div>
							<div class="row">
								<div class="col-md-6 checkbox-group">
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="2" onClick="verificaOpcaoDeficiencia(this);"> Baixa Visão</label>
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="1" onClick="verificaOpcaoDeficiencia(this);"> Cegueira</label>
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="15" onClick="verificaOpcaoDeficiencia(this);"> Deficiência Auditiva</label>
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="14" onClick="verificaOpcaoDeficiencia(this);"> Deficiência Física</label>
								</div>
								<div class="col-md-6 checkbox-group">
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="5" onClick="verificaOpcaoDeficiencia(this);"> Deficiência Intelectual</label>
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="18" onClick="verificaOpcaoDeficiencia(this);"> Visão Monocular</label>
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="3" onClick="verificaOpcaoDeficiencia(this);"> Surdez</label>
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="4" onClick="verificaOpcaoDeficiencia(this);"> Surdocegueira</label>
								</div>
							</div>
				
							<!-- Transtorno Global do Desenvolvimento -->
							<div class="checkbox-title">Transtorno do Espectro Autista</div>
							<div class="row">
								<div class="col-md-6 checkbox-group">
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="11" onClick="verificaOpcaoDeficiencia(this);"> Transtorno do Espectro Autista (TEA)</label>
								</div>
							</div>

							<!-- Altas Habilidades -->
							<div class="checkbox-title">Altas Habilidades ou Superdotação</div>
							<div class="row">
								<div class="col-md-12 checkbox-group">
									<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" value="8" onClick="verificaOpcaoDeficiencia(this);"> Altas Habilidades ou Superdotação</label>
								</div>
							</div>
							
						</div>
						
						
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ordem:</label>
									<select name="cmbOrdem" class="form-control" id="cmbOrdem"  >
									  <%IF intCodEmpresaGrupo = "0" THEN%>
									  <option value="unidade" >Unidade</option>
									  <%END IF%>
									  <option value="alfabetica" >Alfabetica</option>
									  <option value="matricula" >Matrícula</option>
									  <option value="datamatricula" >Data da Matricula</option>
									  <option value="dataafastamento" >Data de Afastamento</option>
									  <option value="idade" >Idade</option>
									  <option value="bairro" >Bairro</option>
									</select>
								</div>
							</div>	
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Agrupar:</label>
									<select name="cmbQuebraPagina" class="form-control" id="cmbQuebraPagina">
										<option value="NORMAL" >Nenhum</option>
										<option value="TURMA" >Por Turma</option>
									  </select>
								</div>
							</div>	
							
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Linha por Página:</label>
									 <!--#include file="includes/inc_cmbLinhaPorPagina.asp" -->
								</div>
							</div>
							
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Tamanho da Fonte:</label>
									 <!--#include file="includes/inc_cmbTamanhoFonteArial.asp" -->
								</div>
							</div>
						</div>
						
						<br>
						<div class="row">
							<div class="col-sm-12">
								<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2">
									<tr>
									  <td  colspan="6" class="texto1"><strong>Colunas para o relatório:<br><br></strong></td>
									</tr>
									
									<tr>
										<td height="20"><input disabled checked type="checkbox" name="matricula" value="S"> Matrícula</td>
										<td height="20"><input type="checkbox" name="id_censo" value="S"> ID Censo</td>
									</tr>
									<tr>
										<td height="20"><input disabled checked type="checkbox" name="nomealuno" value="S"> Nome do Aluno</td>
										<td height="20"><input type="checkbox" name="idade" value="S"> Idade</td>
										
									</tr>
									
									<tr>
										<td height="20"><input type="checkbox" name="assinatura" value="S"> Assinatura</td>
										<td height="20"><input type="checkbox" name="naturalidade" value="S"> Naturalidade </td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="assinaturapaiemae" value="S">  Assinatura Pai e Mae</td>
										<td height="20"><input type="checkbox" name="necessidadeespeciais" value="S"> Necessidade Especiais</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="atendimentoespecial" value="S"> Atendimento Especial</td>
										<td height="20"><input type="checkbox" name="nomemae" value="S"> Nome da Mae</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="usodaimagem" value="S"> Autoriza uso da imagem</td>
										<td height="20"><input type="checkbox" name="nomepai" value="S"> Nome do Pai</td>
										
									</tr>
									<tr>
										
										<td height="20"><input type="checkbox" name="bolsafamilia" value="S"> Auxílio Brasil</td>
										<td height="20"><input type="checkbox" name="nomeresponsavel" value="S"> Nome Responsável</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="bairro" value="S"> Bairro</td>
										
										<td height="20"><input type="checkbox" name="numeroendereco" value="S"> Número	</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="cartaosus" value="S"> Cartão do SUS</td>
										
										<td height="20"><input type="checkbox" name="numeroprocessojudicial" value="S"> Número do processo judicial	</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="cidade" value="S"> Cidade</td>
										
										<td height="20"><input type="checkbox" name="identidade" value="S"> Número RG Nascimento</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="codigoseguranca" value="S"> Cód. Segurança</td>
										
										<td height="20"><input type="checkbox" name="observacaoprocesso" value="S"> Observação do processo</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="complementoendereco" value="S"> Complemento	</td>
										<td height="20"><input type="checkbox" name="restricaoalimentar" value="S"> Restrição alimentar</td>
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="controlerequerimento" value="S"> Controle de Entrega e Recebimento</td>
										<td height="20"><input type="checkbox" name="sexo" value="S"> Sexo do Aluno</td>
										
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="cpf" value="S"> CPF</td>
										<td height="20"><input type="checkbox" name="situacaoaluno" value="S"> Situação do aluno</td>
										
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="dataafastamento" value="S"> Data Afastamento</td>
										<td height="20"><input type="checkbox" name="telefonecelular" value="S"> Telefone Celular</td>
										
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="datamatricula" value="S"> Data Matrícula</td>
										<td height="20"><input type="checkbox" name="telefonecomercial" value="S"> Telefone Comercial</td>	
										
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="datanascimento" value="S"> Data Nascimento</td>
										<td height="20"><input type="checkbox" name="telefoneresidencial" value="S"> Telefone Residencial</td>
										
										
									</tr>
									<tr>
										<td height="20"><input type="checkbox" name="email" value="S"> Email do Aluno</td>
										<td height="20"><input type="checkbox" name="telefoneresponsavel" value="S"> Telefone Responsável</td>
										
										
									</tr>

									<tr>
										<td height="20"><input type="checkbox" name="endereco" value="S"> Endereço</td>
										
										<td height="20"><input type="checkbox" name="turma" value="S"> Turma</td>
										
									</tr>
									<tr>
										
										<td height="20"><input type="checkbox" name="cod_etnia" value="S"> Etnia</td>
										<td height="20"><input type="checkbox" name="transportescolar" value="S"> Transporte Escolar Municipal</td>										
																			
										
									</tr>	
									<tr>
										
										<td height="20"><input type="checkbox" name="medicamento" value="S"> Faz uso de medicamento controlado</td>
										
										<td height="20"><input type="checkbox" name="TENIS_TAMANHO" value="S"> Tamanho Calçado</td>
										
									</tr>									
									<tr>
										<td height="20"><input type="checkbox" name="alergia" value="S"> Possui alergia</td>
										<td height="20"><input type="checkbox" name="UNIFORME_TAMANHO" value="S"> Tamanho Uniforme</td>
																				
									</tr>										
									<tr>
										<td height="20"></td>
										<%if session("NivelPermissao") = "A" then%>
										<td height="20"><input type="checkbox" name="unidade" value="S"> Unidade</td>
										<%end if%>
										
									</tr>	
									<tr>
										<td height="20"></td>
										
										<td height="20"><input type="checkbox" name="sala_aee" value="S"> Usa Sala AEE</td>	
									</tr>										
								  </table>
							
							</div>
						</div>
						
						<br>
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_geraRelatorio.asp" -->
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>