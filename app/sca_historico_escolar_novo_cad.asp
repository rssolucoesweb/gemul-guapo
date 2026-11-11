<%
	strSimouNao_submit 					= "S"
    strExecutarSubmitCurso              = "S"
    strExecutarSubmitSemestre			= "S"
	strExecutarSubmitDisciplina	        = "S"
	strBotaoLimparTela 					= "N"
	strBotaoVoltaTelaAnterior 			= "S"
	strBotaoDisciplinasHistoricoEscolar 			= "S"
	
	
	strExecutarSubmitCredenciamento			= "S"
	strExecutarSubmitAutorizacao			= "S"
	strExecutarSubmitAutorizacaoRenovacao	= ""
	strExecutarSubmitRecredenciamento		= ""
	intCodEmpresa 						= Session("CodEmpresa")

	if Trim(Request("txtAnoHistorico")) = "" then
	   strAnoHistorico 					= session("strAnoLetivo")
	else   
	   strAnoHistorico 					= Trim(Request("txtAnoHistorico"))
	end if   

	if Trim(Request("cmbSemestreHistorico")) = "0" then
	   intSemestreHistorico 				= session("strSemestre")
	else   
	   intSemestreHistorico				= Trim(Request("cmbSemestreHistorico"))
	end if   

	intCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula						= Trim(Request("txtMatricula"))
	codHistoricoEscolar					= Trim(Request("codHistoricoEscolar"))
	codHistoricoEscolarDisciplina		= Trim(Request("codHistoricoEscolarDisciplina"))
	strExpandirHistorico				= Trim(Request("txtExpandirHistorico"))
	strEscola							= Trim(Request("txtEscola"))
	strCidade							= Trim(Request("txtCidade"))
	strUfResidencia						= Trim(Request("cmbUFResidencia"))
	
	intCodPeriodo 						= Trim(Request("cmbPeriodo"))
	intCodCurso	            			= Trim(Request("cmbCurso"))
	strSerie	            			= Trim(Request("txtSerie"))
	strCurso	            			= Trim(Request("txtCurso"))
	
	intCodDisciplina					= Trim(Request("cmbDisciplina"))
	intCodTurmaHistorico				= Trim(Request("cmbTurmaHistorico"))
	strCHTotal 							= Trim(Request("txtCHTotal"))
	strTotalFaltas 						= Trim(Request("txtTotalFaltas"))
	strMedia 							= Trim(Request("txtMedia"))
	strSituacaoPromocao 				= Trim(Request("cmbSituacaoPromocao"))
	strObservacao		   	 			= Trim(Request.Form("txtObservacao"))
	strSimouNao         				= Trim(Request("cmbSimouNao"))
	
	
	intCodCredenciamento				= Trim(Request("cmbCredenciamento"))
	intCodReCredenciamento				= Trim(Request("cmbRecredenciamento"))
	intCodAutorizacao					= Trim(Request("cmbAutorizacao"))
	intCodAutorizacaoRenovacao			= Trim(Request("cmbAutorizacaoRenovacao"))
	
	
	IF intCodCredenciamento		         = "" THEN intCodCredenciamento		    = "0"
	IF intCodReCredenciamento		     = "" THEN intCodReCredenciamento		= "0"
	IF intCodAutorizacao			     = "" THEN intCodAutorizacao			= "0"
	IF intCodAutorizacaoRenovacao	     = "" THEN intCodAutorizacaoRenovacao	= "0"
	
	'bloqueia historico disciplina
	strPeriodo_Disabled = "" 
	strDisciplina_Disabled = ""  
	strAno_Disabled = "" 
	strSemestre_Disabled = "" 
	strCH_Disabled = "" 
	strSituacaoPromocao_Disabled = "" 
	strMedia_Disabled = "" 
	
	strExecutarSubmitPeriodo = "S"
	strFuncaoSitPromocao = "S"
	
	acao="I"
	
	if codHistoricoEscolar <> "" then
		sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " WHERE	CODIGO = " & codHistoricoEscolar
		'response.Write(sql)
		rs.open sql, cnn
		if not rs.eof then
			'DADOS DO HISTORICO 
			strEscola			= Trim(Rs("escola"))
			strCidade			= Trim(Rs("cidade"))
			strUfResidencia		= Trim(Rs("uf"))
			if Trim(Request("txtAnoHistorico"))="" then
			   strAnoHistorico		= Trim(Rs("ano_letivo"))
			end if 
			mostrar_historico_rel = Trim(Rs("mostrar_historico_rel"))
			intSemestreHistorico= Trim(Rs("semestre"))
			strCurso			= Trim(Rs("curso"))
			strSerie			= Trim(Rs("serie"))
		    if Trim(Request("cmbCurso")) = "0" or Trim(Request("cmbCurso")) = "" then
			   intCodCurso		= Trim(Rs("cod_curso"))
			end if   
		    if Trim(Request("cmbPeriodo")) = "0" or Trim(Request("cmbPeriodo")) = "" then
			   intCodPeriodo		= Trim(Rs("cod_periodo"))
			end if   
			intCodAluno      	= Trim(rs("cod_aluno"))
			if  Trim(Request.Form("txtObservacao")) = "" then
				strObservacao		= Trim(Rs("observacao"))
			end if	
			strCHTotal = Trim(Rs("ch_total"))
			strTotalFaltas =  Trim(Rs("total_faltas"))
			if isnull(intCodCurso) then intCodCurso = "999999"

			'libera historico disciplina
			strPeriodo_Disabled = ""
			strDisciplina_Disabled = "" 
			strAno_Disabled = ""
			strSemestre_Disabled = ""
			strCH_Disabled = ""
			strSituacaoPromocao_Disabled = ""
			strMedia_Disabled = ""
			acao="A"
		end if
		rs.close
		strObservacaoGeral=""
		sql = "SELECT observacoes FROM SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL "
		sql = sql & " WHERE	cod_aluno = " & intCodAluno
		rs.open sql, cnn
		if not rs.eof then
			strObservacaoGeral			= Trim(Rs("observacoes"))
		end if
		rs.close
		
		sql = "SELECT L.cod_atos_legalizacao, A.cod_atos"
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO L"
		sql = sql & " inner join SCA_ATOS_LEGALIZACAO A on A.codigo = L.cod_atos_legalizacao"
		sql = sql & " WHERE	l.cod_aluno = " & intCodAluno
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
				if rs("cod_atos") = "1" then
					if request.form("cmbAutorizacao")="" then
						intCodAutorizacao					= Trim(rs("cod_atos_legalizacao"))
					end if
				end if
				if rs("cod_atos") = "2" then
					if request.form("cmbCredenciamento")="" then
						intCodCredenciamento					= Trim(rs("cod_atos_legalizacao"))
					end if
				end if
				rs.movenext
			wend
		end if
		rs.close

		sql = "select A.cod_atos, H.cod_atos_legalizacao_renovacao"
		sql = sql & " from SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO_RENOVACAO H"
		sql = sql & " inner join SCA_ATOS_LEGALIZACAO_RENOVACAO R on R.codigo = H.cod_atos_legalizacao_renovacao"
		sql = sql & " inner join SCA_ATOS_LEGALIZACAO A on A.codigo = R.cod_atos_legalizacao"
		sql = sql & " where H.cod_aluno = " & intCodAluno
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
				if rs("cod_atos") = "1" then
					if request.form("cmbAutorizacaoRenovacao")="" then
						intCodAutorizacaoRenovacao					= Trim(rs("cod_atos_legalizacao_renovacao"))
					end if
				end if
				if rs("cod_atos") = "2" then
					if request.form("cmbRecredenciamento")="" then
						intCodReCredenciamento					= Trim(rs("cod_atos_legalizacao_renovacao"))
					end if
				end if
				rs.movenext
			wend
		end if
		rs.close
	end if

	sql = " select RAZAOSOCIAL, MUNICIPIO, SCF_UF.codigo "
	sql = sql & " from seg_empresa "
	sql = sql & " INNER JOIN SCF_UF ON SCF_UF.sigla=SEG_EMPRESA.UF	"
	sql = sql & " and seg_empresa.codigo = " & intCodEmpresa
	rs.open sql, cnn
	if not rs.eof then
       if strEscola = "" then strEscola = Trim(Rs("RAZAOSOCIAL"))
       if strCidade = "" then strCidade = Trim(Rs("MUNICIPIO"))
       if strUfResidencia = "" then strUfResidencia = Trim(Rs("codigo"))
    end if
	rs.close

	
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_historico_escolar_novo.asp">

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
						<%
						strMatricula = ""
						strDataNascimento = ""
						strNomeCompleto = ""
						if intSemestreHistorico = "" then intSemestreHistorico = "0"
						sql = "SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO,"
						sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATACOLACAO,SCA_ALUNO.ANOCONCLUSAO,SCA_ALUNO.MAE "
						sql = sql & " FROM SCA_ALUNO "
						sql = sql & " where SCA_ALUNO.CODIGO = " & intCodAluno
						
						rs.open sql, cnn
						if not rs.eof then
							strMatricula = rs("MATRICULA")
							strDataNascimento = formatadataap(rs("DATANASCIMENTO"))
							strNomeCompleto = rs("NOMEALUNO") 
							
							%>
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Matr&iacute;cula:</strong></th>
										<th><strong><%=strMatricula%></strong></th>
										<th><strong>Aluno:</strong></th>
										<th><strong><%=strNomeCompleto%></strong></th>
										<th><strong>Data Nasc.:</strong></th>
										<th><strong><%=strDataNascimento%></strong></th>
									  </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
							<%
						else
						   %>
							<script>
							   alert("ATENÇÃO: O Aluno não encontrado, verifique!");
							   window.history.back();
							</script>
						   <%
						end if
						rs.close
			%>	
		
			<div id="card_endereco" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_endereco > .card-dados_endereco" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Dados do Histórico&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Dados do Histórico&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				
				<div class="card-dados_endereco p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						
						<div class="row">
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Ano</label>
									<input name="txtAnoHistorico" type="text" class="form-control" id="txtAnoHistorico" size="5" maxlength="4" value="<%=strAnoHistorico%>" onKeyPress="return formataCampo(this, 2, 4)" onchange='submit()'>
								</div>
							</div>	
							<div class="col-sm-1">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									<!--#include file="includes/inc_cmdSemestreHistorico.asp" -->
								</div>
							</div>	
						
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Curso</label>
									<!--#include file="includes/inc_cmdCursoHistoricoEscolar.asp" -->
									<%IF intCodCurso<>"999999" THEN%>
									<input name="txtCurso" type="hidden" class="text" id="txtCurso" size="50" maxlength="100" value="<%=strCurso%>" >
									<%END IF%>
								</div>
							</div>
							<%IF intCodCurso="999999" THEN%>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Nome do Curso</label>
									<input name="txtCurso" type="text" class="form-control" id="txtCurso" size="50" maxlength="100" value="<%=strCurso%>" >
								</div>
							</div>
							<%END IF%>
							<div class="col-sm-<%IF intCodCurso="999999" THEN%>3<%ELSE%>5<%END IF%>">
								<div class="form-group">
									<label class="form-label">Período/Série</label>
									<%IF intCodCurso="999999" THEN%>
									<input name="txtSerie" type="text" class="form-control" id="txtSerie" size="15" maxlength="100" value="<%=strSerie%>" >
									<%ELSE%>
									<!--#include file="includes/inc_cmdPeriodo.asp" --> 
									<input name="txtSerie" type="hidden" class="text" id="txtSerie" size="15" maxlength="100" value="<%=strSerie%>" >
									<%END IF%>
								</div>
							</div>
							<div class="col-sm-<%IF intCodCurso="999999" THEN%>1<%ELSE%>2<%END IF%>">
								<div class="form-group">
									<label class="form-label">Mostra na impressão</label>
									<select name="cmbMostrar" id="cmbMostrar" class="form-control" >
										<option <%if mostrar_historico_rel="" or mostrar_historico_rel = "S" then%> selected <%end if%> value="S">Sim</option>
										<option <%if mostrar_historico_rel = "N" then%> selected <%end if%>  value="N">Não</option> 
									</select>
								</div>
							</div>	
							
						</div>							
						<br>
						<div class="row">	
							
							<div class="col-sm-5">	
								<div class="form-group">
									<label class="form-label">Escola</label>
									<input name="txtEscola" type="text" class="form-control" id="txtEscola" size="50" maxlength="100" value="<%=strEscola%>">
								</div>
							</div>
							<div class="col-sm-2">	
								<div class="form-group">
									<label class="form-label">Cidade</label>
									<input name="txtCidade" type="text" class="form-control" id="txtCidade" size="50" maxlength="50" value="<%=strCidade%>">
								</div>
							</div>
						
							<div class="col-sm-1">	
								<div class="form-group">
									<label class="form-label">UF</label>
									<!--#include file="includes/inc_cmdUFResidencia.asp"-->
								</div>
							</div>
							
							<div class="col-sm-2">	
								<div class="form-group">
									<label class="form-label">Carga Hor&aacute;ria Total</label>
									<input name="txtCHTotal" type="text" class="form-control" id="txtCHTotal" size="5" maxlength="4" value="<%=strCHTotal%>" onKeyPress="return formataCampo(this, 2, 5)">
								</div>
							</div>
							<div class="col-sm-2">	
								<div class="form-group">
									<label class="form-label">Total de Faltas</label>
									<input name="txtTotalFaltas" type="text" class="form-control" id="txtTotalFaltas" size="5" maxlength="4" value="<%=strTotalFaltas%>" onKeyPress="return formataCampo(this, 2, 5)">
								</div>
							</div>
						</div>	
						<br>
						<div class="row">	
							
							<div class="col-sm-12">	
								<div class="form-group">
									<label class="form-label">Observação para <%=strAnoHistorico%></label>
									<textarea name="txtObservacao" cols="120" rows="4" class="form-control" id="txtObservacao"> <%=strObservacao%> </textarea>
									<br>M&aacute;ximo 2000 caracteres
								</div>
							</div>
							
						</div>								
						
					</div>
				</div>
			</div>
			<div id="card_obs" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_obs > .card-card_obs" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Observação Geral&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Observação Geral&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				
				<div class="card-card_obs p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						<div class="row">	
							
							<div class="col-sm-12">	
								<div class="form-group">
									<label class="form-label">Observação para todos os anos</label>
									<textarea name="txtObservacaoGeral" cols="120" rows="4" class="form-control" id="txtObservacaoGeral"> <%=strObservacaoGeral%> </textarea>
									<br>M&aacute;ximo 2000 caracteres
								</div>
							</div>
							
						</div>								
						
					</div>
				</div>
			</div>
			<div id="card_atos" class="card border">
				<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_atos > .card-card_atos" aria-expanded="true">
						<span class="collapsed-hidden"><strong>Atos Legais&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
						<span class="collapsed-reveal"><strong>Atos Legais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
				</div>
				
				<div class="card-card_atos p-0 collapse show" style="">
					<!-- notice we place the padding inside another div and remove the padding from the card body -->
					<div class="p-4">
						
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Credenciamento</label>
									<!--#include file="includes/inc_cmbCredenciamento.asp" -->
								</div>
							</div>	
						</div>							
						<br>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Recredenciamento</label>
									<!--#include file="includes/inc_cmbRecredenciamento.asp" -->
								</div>
							</div>	
						</div>							
						<br>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Autorização</label>
									<!--#include file="includes/inc_cmbAutorizacao.asp" -->
								</div>
							</div>	
						</div>							
						<br>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="form-label">Renovação da Autorização</label>
									<!--#include file="includes/inc_cmbAutorizacaoRenovacao.asp" -->
								</div>
							</div>	
						</div>							
						<br>
					</div>
				</div>
			</div>
			<%
			pagina_anterior						= "sca_historico_escolar_novoCon.asp?txtMatricula=" & strMatricula
			%>
			<br>
			<div class="frame-wrap">
				<!--#include file="includes/inc_botoes_cadastro.asp"-->
			</div>
					
		</div>
	</div>
	
	
		<input type="hidden" name="txtCodAluno"  value="<%=intCodAluno%>">
		<input type="hidden" name="txtMatricula"  value="<%=strMatricula%>">
		<input type="hidden" name="codHistoricoEscolar"  value="<%=codHistoricoEscolar%>">
		<input type="hidden" name="txtExpandirHistorico" value="<%=strExpandirHistorico%>">
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>