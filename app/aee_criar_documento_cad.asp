<%
	acao = "I"
	intCodDocumento		= Trim(Request("txtCodigo"))
	strTitulo	 		= Trim(Request.Form("txtTitulo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	if TRIM(Session("NivelPermissao")) = "A" then
	   strMostraSomenteDeptoAtual = "" 'mostra todos os deptos
    else   
	   strMostraSomenteDeptoAtual = "S" 'mostra somente o depto atual
	end if	
	if trim(intCodDocumento) <> "" then
	
		sql = "SELECT codigo, titulo, Documento, campos, situacaoaluno, situacao"
		sql = sql & " FROM AEE_DOCUMENTO"
		sql = sql & " Where codigo = " & intCodDocumento
		rs.open sql, cnn
		
		if rs.eof = false then
			strSituacao 				= rs("situacao")
			strTitulo 				= rs("Titulo")
			strDescricao			= rs("Documento")
			strDescricao 			= REPLACE(REPLACE(rs("documento"),"&lt;","["),"&gt;","]")
			strCampos				= rs("campos")
			strsituacaoaluno		= rs("situacaoaluno")
			
			acao = "AE"

		end if 
		rs.close
		
	end if 
	
	strMarcaNomeAluno 		= ""
	strMarcaMatricula 		= ""
	strMarcaDataNascimento 	= ""
	strMarcaCidadeNascimento= ""
	strMarcaUfNascimento 	= ""
	strMarcaCidadeResidencia= ""
	strMarcaUfResidencia 	= ""
	strMarcaFone		 	= ""
	strMarcaEmail		 	= ""

	strMarcaIdentidade	 	= ""
	strMarcaCPF 			= ""
	strMarcaTitulo		 	= ""
	
	strMarcaAnoLetivo 		= ""
	strMarcaPai 			= ""
	strMarcaMae 			= ""
	strMarcaCursoAtual 		= ""
	strMarcaPeriodoAtual 	= ""
	strMarcaTurnoAtual 		= ""

	strMarcaTurmaAluno 		= ""
	strMarcaSituacaoAluno	= ""
	strMarcaDataIngresso	= ""

	strMarcaCidade	 		= ""
	strMarcaDia 			= ""
	strMarcaMes 			= ""
	strMarcaAno 			= ""
	strMarcaSecretario 		= ""
	strMarcaDiretor 		= ""

	strMarcaNomeUnidadeEscolar	= ""
	strMarcaEnderecoUnidadeEscolar	= ""
	strMarcaTelefoneUnidadeEscolar	= ""

	strMarcaCodigoSeguranca 		= ""
	strMarcaNomeResponsavel		= ""

	strMarcaAnoConclusao 	= ""
	strMarcaSemestre	 	= ""
	strAutorizacao			= ""
	strDataAutorizacao		= ""
	strDataReconhecimento	= ""
	strReconhecimento		= ""
	strCH_Exigida			= ""
	strDataColacao			= ""
	strDataCertificado		= ""
	strDataMatricula		= ""
	strNacionalidade		= ""
	strEstadoCivil			= ""
	strPercentualFrequencia	= ""
	
	

	estiloInicialNomeAluno = "style='display:none'"
	estiloInicialMatricula = "style='display:none'"
	estiloInicialDataNascimento = "style='display:none'"
	estiloInicialCidadeNascimento = "style='display:none'"
	estiloInicialUfNascimento = "style='display:none'"
	estiloInicialCidadeResidencia = "style='display:none'"
	estiloInicialUfResidencia = "style='display:none'"
	estiloInicialFone = "style='display:none'"
	estiloInicialEmail = "style='display:none'"

	estiloInicialIdentidade = "style='display:none'"
	estiloInicialCPF 		= "style='display:none'"
	estiloInicialTitulo 	= "style='display:none'"

	estiloInicialAnoLetivo = "style='display:none'"
	estiloInicialPai = "style='display:none'"
	estiloInicialMae = "style='display:none'"
	estiloInicialCursoAtual = "style='display:none'"
	estiloInicialPeriodoAtual = "style='display:none'"
	estiloInicialTurnoAtual = "style='display:none'"
	
	estiloInicialTurmaAluno = "style='display:none'"	
	estiloInicialSituacaoAluno = "style='display:none'"
	estiloInicialDataIngresso = "style='display:none'"

	estiloInicialCidade = "style='display:none'"
	estiloInicialDia = "style='display:none'"
	estiloInicialMes = "style='display:none'"
	estiloInicialAno = "style='display:none'"
	estiloInicialSecretario = "style='display:none'"
	estiloInicialDiretor = "style='display:none'"
	
	estiloInicialNomeUnidadeEscolar = "style='display:none'"
	estiloInicialEnderecoUnidadeEscolar = "style='display:none'"
	estiloInicialTelefoneUnidadeEscolar = "style='display:none'"
	
	estiloInicialCodigoSeguranca = "style='display:none'"
	estiloInicialNomeResponsavel = "style='display:none'"

	estiloInicialAnoConclusao = "style='display:none'"
	estiloInicialSemestre = "style='display:none'"
	estiloInicialAutorizacao = "style='display:none'"
	estiloInicialDataAutorizacao = "style='display:none'"
	estiloInicialDataReconhecimento = "style='display:none'"
	estiloInicialCH_Exigida = "style='display:none'"
	
	estiloInicialReconhecimento = "style='display:none'"
	estiloInicialDataColacao = "style='display:none'"
	estiloInicialDataCertificado = "style='display:none'"
	estiloInicialDataMatricula = "style='display:none'"
	estiloInicialNacionalidade = "style='display:none'"
	estiloInicialEstadoCivil = "style='display:none'"
	estiloInicialPercentualFrequencia = "style='display:none'"
    
	'
	estiloInicialLogradouro = "style='display:none'"
	estiloInicialNumero_Endereco = "style='display:none'"
	estiloInicialComp_Endereco = "style='display:none'"
	estiloInicialBairroAluno = "style='display:none'"
	'

	if strCampos <> "" then

		vetCampos = split(strCampos,",")
		for i=0 to ubound(vetCampos)
			if trim(vetCampos(i)) = "NOMEALUNO" then 
				strMarcaNomeAluno = "checked"
				estiloInicialNomeAluno = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "MATRICULA" then 
				strMarcaMatricula = "checked"
				estiloInicialMatricula = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATANASCIMENTO" then 
				strMarcaDataNascimento = "checked"
				estiloInicialDataNascimento = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
				strMarcaCidadeNascimento = "checked"
				estiloInicialCidadeNascimento = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "UFNASCIMENTO" then 
				strMarcaUfNascimento = "checked"
				estiloInicialUfNascimento = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "CIDADERESIDENCIA" then 
				strMarcaCidadeResidencia = "checked"
				estiloInicialCidadeResidencia = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "UFRESIDENCIA" then 
				strMarcaUfResidencia = "checked"
				estiloInicialUfResidencia = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "FONE" then 
				strMarcaFone = "checked"
				estiloInicialFone = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "EMAIL" then 
				strMarcaEmail = "checked"
				estiloInicialEmail = "style='display:table-row'"
			end if
			
			if trim(vetCampos(i)) = "IDENTIDADE" then 
				strMarcaIdentidade = "checked"
				estiloInicialIdentidade = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "CPF" then 
				strMarcaCPF = "checked"
				estiloInicialCPF = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "TITULO" then 
				strMarcaTitulo = "checked"
				estiloInicialTitulo = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "ANOLETIVO" then 
				strMarcaAnoLetivo = "checked"
				estiloInicialAnoLetivo = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "PAI" then 
				strMarcaPai = "checked"
				estiloInicialPai = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "MAE" then 
				strMarcaMae = "checked"
				estiloInicialMae = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "CURSOATUAL" then 
				strMarcaCursoAtual = "checked"
				estiloInicialCursoAtual = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "PERIODOATUAL" then 
				strMarcaPeriodoAtual = "checked"
				estiloInicialPeriodoAtual = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "TURNOATUAL" then 
				strMarcaTurnoAtual = "checked"
				estiloInicialTurnoAtual = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "SITUACAOALUNO" then 
				strMarcaSituacaoAluno = "checked"
				estiloInicialSituacaoAluno = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATAINGRESSO" then 
				strMarcaDataIngresso = "checked"
				estiloInicialDataIngresso = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "TURMAALUNO" then 
				strMarcaTurmaAluno = "checked"
				estiloInicialTurmaAluno = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "CIDADE" then 
				strMarcaCidade = "checked"
				estiloInicialCidade = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DIA" then 
				strMarcaDia = "checked"
				estiloInicialDia = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "MES" then 
				strMarcaMes = "checked"
				estiloInicialMes = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "ANO" then 
				strMarcaAno = "checked"
				estiloInicialAno = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "SECRETARIO" then 
				strMarcaSecretario = "checked"
				estiloInicialSecretario = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DIRETOR" then 
				strMarcaDiretor = "checked"
				estiloInicialDiretor = "style='display:table-row'"
			end if
			
			if trim(vetCampos(i)) = "NOME_UNIDADE_ESCOLAR" then 
				strMarcaNomeUnidadeEscolar = "checked"
				estiloInicialNomeUnidadeEscolar = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "ENDERECO_UNIDADE_ESCOLAR" then 
				strMarcaEnderecoUnidadeEscolar = "checked"
				estiloInicialEnderecoUnidadeEscolar = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "TELEFONE_UNIDADE_ESCOLAR" then 
				strMarcaTelefoneUnidadeEscolar = "checked"
				estiloInicialTelefoneUnidadeEscolar = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "CODIGO_SEGURANCA" then 
				strMarcaCodigoSeguranca = "checked"
				estiloInicialCodigoSeguranca = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "NOME_RESPONSAVEL" then 
				strMarcaNomeResponsavel = "checked"
				estiloInicialNomeResponsavel = "style='display:table-row'"
			end if
			
			if trim(vetCampos(i)) = "ANOCONCLUSAO" then 
				strMarcaAnoConclusao = "checked"
				estiloInicialAnoConclusao = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "SEMESTRE" then 
				strMarcaSemestre = "checked"
				estiloInicialSemestre = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "AUTORIZACAO" then 
				strMarcaAutorizacao = "checked"
				estiloInicialAutorizacao = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATAAUTORIZACAO" then 
				strMarcaDataAutorizacao = "checked"
				estiloInicialDataAutorizacao = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATARECONHECIMENTO" then 
				strMarcaDataReconhecimento = "checked"
				estiloInicialDataReconhecimento = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "RECONHECIMENTO" then 
				strMarcaReconhecimento = "checked"
				estiloInicialReconhecimento = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "CH_EXIGIDA" then 
				strMarcaCH_Exigida = "checked"
				estiloInicialCH_Exigida = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATACOLACAO" then 
				strMarcaDataColacao = "checked"
				estiloInicialDataColacao = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATACERTIFICADO" then 
				strMarcaDataCertificado = "checked"
				estiloInicialDataCertificado = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "DATAMATRICULA" then 
				strMarcaDataMatricula = "checked"
				estiloInicialDataMatricula = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "NACIONALIDADE" then 
				strMarcaNacionalidade = "checked"
				estiloInicialNacionalidade = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "ESTADOCIVIL" then 
				strMarcaEstadoCivil = "checked"
				estiloInicialEstadoCivil = "style='display:table-row'"
			end if

			if trim(vetCampos(i)) = "LOGRADOURO" then 
				strLogradouro = "checked"
				estiloInicialLogradouro = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "NUMERO_ENDERECO" then 
				strNumeroEndereco = "checked"
				estiloInicialNumero_Endereco = "style='display:table-row'"
			end if
			if trim(vetCampos(i)) = "COMP_ENDERECO" then 
				strCompEndereco = "checked"
				estiloInicialComp_Endereco = "style='display:table-row'"
			end if
			
			if trim(vetCampos(i)) = "BAIRROALUNO" then 
				strBairroAluno = "checked"
				estiloInicialBairroAluno = "style='display:table-row'"
			end if
			
			if trim(vetCampos(i)) = "PERCENTUALFREQUENCIA" then 
				strMarcaPercentualFrequencia = "checked"
				estiloInicialPercentualFrequencia = "style='display:table-row'"
			end if
			
		next
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
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodDocumento%>">
							
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label class="form-label">Título</label>
										<input type="text" id="txtTitulo" name="txtTitulo" class="form-control" value="<%=strTitulo%>"  maxlength="50">
									
									</div>
                                </div>
                            </div>
							
							<br>
							
							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										
										
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										  <tr>
											<td width="100%" height="80" class="texto1">
											
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
												  <tr  style="cursor:pointer" onClick="return dadosAluno()">
													<td width="80%"  height="35" class="texto1"><img id="imgDadosAluno" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Pessoais do Aluno</strong></td>
													<td width="20%" >
														<strong>Campos obrigatórios no texto</strong>
													</td>
												  </tr>
												  <tr  style="display:none"  id="mostraDadosAluno">
													<td width="80%" class="texto1" style="vertical-align: top;">
													<!-- INICIO CAMPO - DADOS ALUNO-->
														<table width="100%" border="0" cellpadding="0" cellspacing="0">					
														  <tr>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('NOMEALUNO',this.checked)" type="checkbox" name="campos" value="NOMEALUNO" <%=strMarcaNomeAluno%>>Nome do Aluno</strong></td>
															<td width="181" class="texto1"><strong><input  onClick="mostraCampoInserir('MATRICULA',this.checked)" type="checkbox" name="campos" value="MATRICULA" <%=strMarcaMatricula%>>Matrícula do Aluno</strong></td>
															<td width="164" class="texto1"><strong><input onClick="mostraCampoInserir('DATANASCIMENTO',this.checked)"  type="checkbox" name="campos" value="DATANASCIMENTO" <%=strMarcaDataNascimento%>>Data Nasc. do Aluno</strong></td>
															<td width="200" class="texto1"><strong><input onClick="mostraCampoInserir('CIDADENASCIMENTO',this.checked)"  type="checkbox" name="campos" value="CIDADENASCIMENTO" <%=strMarcaCidadeNascimento%>>Cidade de Nascimento</strong></td>
														  </tr>
														  <tr>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('UFNASCIMENTO',this.checked)"  type="checkbox" name="campos" value="UFNASCIMENTO" <%=strMarcaUfNascimento%>>Estado de Nasc.</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('IDENTIDADE',this.checked)"  type="checkbox" name="campos" value="IDENTIDADE" <%=strMarcaIdentidade%>>Identidade</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('CPF',this.checked)"  type="checkbox" name="campos" value="CPF" <%=strMarcaCPF%>>CPF</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('TITULO',this.checked)"  type="checkbox" name="campos" value="TITULO" <%=strMarcaTitulo%>>T&iacute;tulo de Eleitor</strong></td>
														  </tr>
														  <tr>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('ESTADOCIVIL',this.checked)"  type="checkbox" name="campos" value="ESTADOCIVIL" <%=strMarcaEstadoCivil%>>Estado Civil </strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('PAI',this.checked)"  type="checkbox" name="campos" value="PAI" <%=strMarcaPai%>>Pai do Aluno</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('MAE',this.checked)"  type="checkbox" name="campos" value="MAE" <%=strMarcaMae%>>Mãe do Aluno</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('NACIONALIDADE',this.checked)"  type="checkbox" name="campos" value="NACIONALIDADE" <%=strMarcaNacionalidade%>>Nacionalidade</strong></td>
														  </tr>
														  <tr>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('LOGRADOURO',this.checked)"  type="checkbox" name="campos" value="LOGRADOURO" <%=strLogradouro%>>Logradouro</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('NUMERO_ENDERECO',this.checked)"  type="checkbox" name="campos" value="NUMERO_ENDERECO" <%=strNumeroEndereco%>>Numero</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('COMP_ENDERECO',this.checked)"  type="checkbox" name="campos" value="COMP_ENDERECO" <%=strCompEndereco%>>Complemento</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('BAIRROALUNO',this.checked)"  type="checkbox" name="campos" value="BAIRROALUNO" <%=strBairroAluno%>>Bairro</strong></td>
														  </tr>
														  <tr>
															<td width="200" class="texto1"><strong><input onClick="mostraCampoInserir('CIDADERESIDENCIA',this.checked)"  type="checkbox" name="campos" value="CIDADERESIDENCIA" <%=strMarcaCidadeResidencia%>>Cidade de Residência</strong></td>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('UFRESIDENCIA',this.checked)"  type="checkbox" name="campos" value="UFRESIDENCIA" <%=strMarcaUfResidencia%>>Estado de Residência</strong></td>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('EMAIL',this.checked)"  type="checkbox" name="campos" value="EMAIL" <%=strMarcaEmail%>>Email</strong></td>
															<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('FONE',this.checked)"  type="checkbox" name="campos" value="FONE" <%=strMarcaFone%>>Telefone(s)</strong></td>
														  </tr>
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('NOME_RESPONSAVEL',this.checked)"  type="checkbox" name="campos" value="NOME_RESPONSAVEL" <%=strMarcaNomeResponsavel%>>Nome do responsável</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('CODIGO_SEGURANCA',this.checked)"  type="checkbox" name="campos" value="CODIGO_SEGURANCA" <%=strMarcaCodigoSeguranca%>>Código de Segurança</strong></td>
															<td class="texto1">&nbsp;</td>
															<td class="texto1">&nbsp;</td>
														  </tr>
														</table>
													</td>
													<td width="20%">
														<span id="NOMEALUNO" <%=estiloInicialNomeAluno%>>[a id=NOMEALUNO][/a]</span>
														<span id="MATRICULA" <%=estiloInicialMatricula%>>[a id=MATRICULA][/a]</span>
														<span id="DATANASCIMENTO" <%=estiloInicialDataNascimento%>>[a id=DATANASCIMENTO][/a]</span>
														<span id="CIDADENASCIMENTO" <%=estiloInicialCidadeNascimento%>>[a id=CIDADENASCIMENTO][/a]</span>
														<span id="UFNASCIMENTO" <%=estiloInicialUfNascimento%>>[a id=UFNASCIMENTO][/a]</span>
														<span id="IDENTIDADE" <%=estiloInicialCPF%>>[a id=IDENTIDADE][/a]</span>
														<span id="CPF" <%=estiloInicialMatricula%>>[a id=CPF][/a]</span>
														<span id="TITULO" <%=estiloInicialTitulo%>>[a id=TITULO][/a]</span>
														<span id="ESTADOCIVIL" <%=estiloInicialEstadoCivil%>>[a id=ESTADOCIVIL][/a]</span>
														<span id="PAI" <%=estiloInicialPai%>>[a id=PAI][/a]</span>
														<span id="MAE" <%=estiloInicialMae%>>[a id=MAE][/a]</span>
														<span id="NACIONALIDADE" <%=estiloInicialNacionalidade%>>[a id=NACIONALIDADE][/a]</span>
														<span id="LOGRADOURO" <%=estiloInicialLogradouro%>>[a id=LOGRADOURO][/a]</span>
														<span id="NUMERO_ENDERECO" <%=estiloInicialNumero_Endereco%>>[a id=NUMERO_ENDERECO][/a]</span>
														<span id="COMP_ENDERECO" <%=estiloInicialComp_Endereco%>>[a id=COMP_ENDERECO][/a]</span>
														<span id="BAIRROALUNO" <%=estiloInicialBairroAluno%>>[a id=BAIRROALUNO][/a]</span>
														<span id="CIDADERESIDENCIA" <%=estiloInicialCidadeResidencia%>>[a id=CIDADERESIDENCIA][/a]</span>
														<span id="UFRESIDENCIA" <%=estiloInicialUfResidencia%>>[a id=UFRESIDENCIA][/a]</span>
														<span id="EMAIL" <%=estiloInicialEmail%>>[a id=EMAIL][/a]</span>
														<span id="FONE" <%=estiloInicialFone%>>[a id=FONE][/a]</span>
														<span id="NOME_RESPONSAVEL" <%=estiloInicialNomeResponsavel%>>[a id=NOME_RESPONSAVEL][/a]</span>
														<span id="CODIGO_SEGURANCA" <%=estiloInicialCodigoSeguranca%>>[a id=CODIGO_SEGURANCA][/a]</span>
													</td>
												  </tr>
												  <tr style="cursor:pointer">
													<td height="35" class="texto1" style="cursor:hand" onClick="return dadosEscolares()"><img id="imgDadosEscolares" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Dados Escolares</strong></td>
													<td>
														<strong>Campos obrigatórios no texto</strong>
													</td>
												  </tr>
												  <tr style="display:none"  id="mostraDadosEscolares">
													<td width="80%" class="texto1" style="vertical-align: top;">
													<!-- INICIO CAMPO - DADOS ESCOLARES-->
														<table width="100%" border="0" cellpadding="0" cellspacing="0">					
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('ANOLETIVO',this.checked)"  type="checkbox" name="campos" value="ANOLETIVO" <%=strMarcaAnoLetivo%>>Ano Letivo</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('CURSOATUAL',this.checked)"  type="checkbox" name="campos" value="CURSOATUAL" <%=strMarcaCursoAtual%>>Curso Atual</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('PERIODOATUAL',this.checked)"  type="checkbox" name="campos" value="PERIODOATUAL" <%=strMarcaPeriodoAtual%>>Período Atual</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('TURNOATUAL',this.checked)"  type="checkbox" name="campos" value="TURNOATUAL" <%=strMarcaTurnoAtual%>>Turno Atual</strong></td>
															</tr>
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('TURMAALUNO',this.checked)"  type="checkbox" name="campos" value="TURMAALUNO" <%=strMarcaTurmaAluno%>>Turma do Aluno</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('SITUACAOALUNO',this.checked)"  type="checkbox" name="campos" value="SITUACAOALUNO" <%=strMarcaSituacaoAluno%>>Situação do Aluno</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('DATAINGRESSO',this.checked)"  type="checkbox" name="campos" value="DATAINGRESSO" <%=strMarcaDataIngresso%>>Forma Ingresso </strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('DATAMATRICULA',this.checked)"  type="checkbox" name="campos" value="DATAMATRICULA" <%=strMarcaDataMatricula%>>Data da Matr&iacute;cula </strong></td>
															</tr>
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('DATACOLACAO',this.checked)"  type="checkbox" name="campos" value="DATACOLACAO" <%=strMarcaDataColacao%>>Data Cola&ccedil;&atilde;o </strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('DATACERTIFICADO',this.checked)"  type="checkbox" name="campos" value="DATACERTIFICADO" <%=strMarcaDataCertificado%>>Data Certificado </strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('ANOCONCLUSAO',this.checked)"  type="checkbox" name="campos" value="ANOCONCLUSAO" <%=strMarcaAnoConclusao%>>Ano Conclus&atilde;o </strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('SEMESTRE',this.checked)"  type="checkbox" name="campos" value="SEMESTRE" <%=strMarcaSemestre%>>Semestre</strong></td>
														  </tr> 
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('PERCENTUALFREQUENCIA',this.checked)"  type="checkbox" name="campos" value="PERCENTUALFREQUENCIA" <%=strMarcaPercentualFrequencia%>>Percentual de Frequência </strong></td>
															<td class="texto1"><strong></strong></td>
															<td class="texto1"><strong></strong></td>
															<td class="texto1"><strong></strong></td>
														  </tr>
													   </table>
													</td>
													<td>
														<span id="ANOLETIVO" <%=estiloInicialAnoLetivo%>>[a id=ANOLETIVO][/a]</span>
														<span id="CURSOATUAL" <%=estiloInicialCursoAtual%>>[a id=CURSOATUAL][/a]</span>
														<span id="PERIODOATUAL" <%=estiloInicialPeriodoAtual%>>[a id=PERIODOATUAL][/a]</span>
														<span id="TURNOATUAL" <%=estiloInicialTurnoAtual%>>[a id=TURNOATUAL][/a]</span>
														<span id="TURMAALUNO" <%=estiloInicialTurmaAluno%>>[a id=TURMAALUNO][/a]</span>
														<span id="SITUACAOALUNO" <%=estiloInicialSituacaoAluno%>>[a id=SITUACAOALUNO][/a]</span>
														<span id="DATAINGRESSO" <%=estiloInicialDataIngresso%>>[a id=DATAINGRESSO][/a]</span>
														<span id="DATAMATRICULA" <%=estiloInicialDataMatricula%>>[a id=DATAMATRICULA][/a]</span>
														<span id="DATACERTIFICADO" <%=estiloInicialDataCertificado%>>[a id=DATACERTIFICADO][/a]</span>
														<span id="DATACOLACAO" <%=estiloInicialDataColacao%>>[a id=DATACOLACAO][/a]</span>
														<span id="ANOCONCLUSAO" <%=estiloInicialAnoConclusao%>>[a id=ANOCONCLUSAO][/a]</span>
														<span id="SEMESTRE" <%=estiloInicialSemestre%>>[a id=SEMESTRE][/a]</span>
														<span id="PERCENTUALFREQUENCIA" <%=estiloInicialPercentualFrequencia%>>[a id=PERCENTUALFREQUENCIA][/a]</span>
													</td>
												  </tr>
												  <tr style="cursor:pointer">
													<td height="35" class="texto1" style="cursor:hand" onClick="return dadosDataAtual()"><img id="imgDadosDataAtual" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es data atual</strong></td>
													<td>
														<strong>Campos obrigatórios no texto</strong>
													</td>
												  </tr>
												  <tr style="display:none"  id="mostraDadosDataAtual">
													<td width="80%" class="texto1" style="vertical-align: top;">
													<!-- INICIO CAMPO - DADOS DATA ATUAL-->
														<table width="100%" border="0" cellpadding="0" cellspacing="0">					
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('CIDADE',this.checked)"  type="checkbox" name="campos" value="CIDADE" <%=strMarcaCidade%>>Cidade</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('DIA',this.checked)"  type="checkbox" name="campos" value="DIA" <%=strMarcaDia%>>Dia</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('MES',this.checked)"  type="checkbox" name="campos" value="MES" <%=strMarcaMes%>>M&ecirc;s</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('ANO',this.checked)"  type="checkbox" name="campos" value="ANO" <%=strMarcaAno%>>Ano</strong></td>
														  </tr>
													   </table>
													</td>
													<td>
														<span id="CIDADE" <%=estiloInicialCidade%>>[a id=CIDADE][/a]</span>
														<span id="DIA" <%=estiloInicialDia%>>[a id=DIA][/a]</span>
														<span id="MES" <%=estiloInicialMes%>>[a id=MES][/a]</span>
														<span id="ANO" <%=estiloInicialAno%>>[a id=ANO][/a]</span>
													</td>
												  </tr>
												  <tr style="cursor:pointer">
													<td height="35" class="texto1" style="cursor:hand" onClick="return dadosRepresentantes()"><img id="imgDadosRepresentantes" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es dos Representantes Legais</strong></td>
													<td>
														<strong>Campos obrigatórios no texto</strong>
													</td>
												  </tr>
												  <tr style="display:none" id="mostraDadosRepresentantes" >
													<td width="80%" class="texto1" style="vertical-align: top;">
													<!-- INICIO CAMPO - DADOS REPRESENTANTES-->
													<table width="100%" border="0" cellpadding="0" cellspacing="0">					
													  <tr>
														<td class="texto1"><strong><input onClick="mostraCampoInserir('SECRETARIO',this.checked)"  type="checkbox" name="campos" value="SECRETARIO" <%=strMarcaSecretario%>>Secretário(a) Geral&nbsp;&nbsp;</strong></td>
														<td class="texto1"><strong><input onClick="mostraCampoInserir('DIRETOR',this.checked)"  type="checkbox" name="campos" value="DIRETOR" <%=strMarcaDiretor%>>Diretor(a)</strong></td>
														<td class="texto1">&nbsp;</td>
														<td class="texto1">&nbsp;</td>
													  </tr>
													</table>
													</td>
													<td>
														<span id="SECRETARIO" <%=estiloInicialSecretario%>>[a id=SECRETARIO][/a]</span>
														<span id="DIRETOR" <%=estiloInicialDiretor%>>[a id=DIRETOR][/a]</span>
													</td>
												  </tr>
												  <tr style="cursor:pointer">
													<td height="35" class="texto1" style="cursor:hand" onClick="return dadosAutorizacao()"><img id="imgDadosAutorizacao" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&atilde;o de  Autoriza&ccedil;&atilde;o</strong></td>
													<td>
														<strong>Campos obrigatórios no texto</strong>
													</td>
												  </tr>
												  <tr style="display:none"  id="mostraDadosAutorizacao">
													<td width="80%" class="texto1" style="vertical-align: top;">
													<!-- INICIO CAMPO - DADOS AUTORIZAÇÃO-->
													<table width="100%" border="0" cellpadding="0" cellspacing="0">					
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('AUTORIZACAO',this.checked)"  type="checkbox" name="campos" value="AUTORIZACAO" <%=strMarcaAutorizacao%>>Autoriza&ccedil;&atilde;o</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('DATAAUTORIZACAO',this.checked)"  type="checkbox" name="campos" value="DATAAUTORIZACAO" <%=strMarcaDataAutorizacao%>>
															Data Autoriza&ccedil;&atilde;o </strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('RECONHECIMENTO',this.checked)"  type="checkbox" name="campos" value="RECONHECIMENTO" <%=strMarcaReconhecimento%>>Reconhecimento</strong></td>
															<td class="texto1"><strong>
															  <input onClick="mostraCampoInserir('DATARECONHECIMENTO',this.checked)"  type="checkbox" name="campos" value="DATARECONHECIMENTO" <%=strMarcaDataReconhecimento%>>
															  Data Reconhecimento</strong></td>
														  </tr>
														  <tr>
															<td class="texto1"><strong>
															  <input onClick="mostraCampoInserir('CH_EXIGIDA',this.checked)"  type="checkbox" name="campos" value="CH_EXIGIDA" <%=strMarcaCH_Exigida%>>CH Exigida </strong></td>
															<td colspan="3" class="texto1">&nbsp;</td>
															</tr>
													</table>
													</td>
													<td>
														<span id="AUTORIZACAO" <%=estiloInicialAutorizacao%>>[a id=AUTORIZACAO][/a]</span>
														<span id="DATAAUTORIZACAO" <%=estiloInicialDataAutorizacao%>>[a id=DATAAUTORIZACAO][/a]</span>
														<span id="RECONHECIMENTO" <%=estiloInicialReconhecimento%>>[a id=RECONHECIMENTO][/a]</span>
														<span id="DATARECONHECIMENTO" <%=estiloInicialDataReconhecimento%>>[a id=DATARECONHECIMENTO][/a]</span>
														<span id="CH_EXIGIDA" <%=estiloInicialCH_Exigida%>>[a id=CH_EXIGIDA][/a]</span>
													</td>
												  </tr>
												  <tr style="cursor:pointer">
													<td height="35" class="texto1" style="cursor:hand" onClick="return dadosValidacao()"><img id="imgDadosValidacao" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Validações</strong></td>
													<td>
														&nbsp;
													</td>
												  </tr>
												  <tr style="display:none"  id="mostraDadosValidacao">
													<td width="80%" class="texto1" style="vertical-align: top;">
													<!-- INICIO CAMPO - DADOS AUTORIZAÇÃO-->
													<table width="100%" border="0" cellpadding="0" cellspacing="0">					
														  <tr>
															<td width="34%" class="texto1">
															<input type="hidden" name="posicaofinanceira" value="S" <%=strMarcaPosicaoFinanceira%>>
															</td>
															<td width="40%" class="texto1">&nbsp;</td>
															<td width="13%" class="texto1">&nbsp;</td>
															<td width="13%" class="texto1">&nbsp;</td>
														  </tr>
														  <tr>
															<td class="texto1"><strong>
															  Situa&ccedil;&atilde;o cadastral: </strong></td>
															<td colspan="3" class="texto1" style="vertical-align: top;">
															<strong>
															<%
															if strsituacaoaluno <> "" then
																vetor = split(strsituacaoaluno,",")
															end if
															sql = "select * from sca_situacaoaluno"
															sql = sql & " where status='A'"
															rs.open sql, cnn
															if rs.eof = false then
																cont = 0
																while not rs.eof
																
																	selecionado = ""
																	if strsituacaoaluno <> "" then
																		for i=0 to ubound(vetor)
																			if trim(vetor(i)) = trim(rs("cod_situacaoAluno")) then
																				selecionado = "checked"
																			end if
																		next
																	end if
																	%>
																	  <input <%=selecionado%> type="checkbox" name="situacaoaluno" value="<%=rs("cod_situacaoAluno")%>">
																	  <%=rs("desc_situacaoAluno")%>
																	<%
																	cont = cont + 1
																	if cont = 4 then response.Write("<br>")
																	rs.movenext
																wend
															end if
															rs.close
															%>							  
															  
															</strong></td>
															</tr>
													</table>
													</td>
													<td>
													&nbsp;
													</td>
												  </tr>
												  
												  <tr style="cursor:pointer">
													<td height="35" class="texto1" style="cursor:hand" onClick="return dadosUnidadeEscolar()"><img id="imgDadosUnidadeEnsino" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Unidade Escolar</strong></td>
													<td>
														<strong>Campos obrigatórios no texto</strong>
													</td>
												  </tr>
												  <tr style="display:none"  id="mostraDadosUnidadeEscolar">
													<td width="80%" class="texto1" style="vertical-align: top;">
													
													<table width="100%" border="0" cellpadding="0" cellspacing="0">					
														  <tr>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('NOME_UNIDADE_ESCOLAR',this.checked)"  	 type="checkbox" name="campos" value="NOME_UNIDADE_ESCOLAR" 	<%=strMarcaNomeUnidadeEscolar%>>Unidade Escolar&nbsp;&nbsp;</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('ENDERECO_UNIDADE_ESCOLAR',this.checked)"  type="checkbox" name="campos" value="ENDERECO_UNIDADE_ESCOLAR" <%=strMarcaEnderecoUnidadeEscolar%>>Endereço&nbsp;&nbsp;</strong></td>
															<td class="texto1"><strong><input onClick="mostraCampoInserir('TELEFONE_UNIDADE_ESCOLAR',this.checked)"  type="checkbox" name="campos" value="TELEFONE_UNIDADE_ESCOLAR" <%=strMarcaTelefoneUnidadeEscolar%>>Telefone</strong></td>
															<td class="texto1">&nbsp;</td>
														  </tr>
													</table>
													</td>
													<td>
														<span id="NOME_UNIDADE_ESCOLAR" <%=estiloInicialNomeUnidadeEscolar%>>[a id=NOME_UNIDADE_ESCOLAR][/a]</span>
														<span id="ENDERECO_UNIDADE_ESCOLAR" <%=estiloInicialEnderecoUnidadeEscolar%>>[a id=ENDERECO_UNIDADE_ESCOLAR][/a]</span>
														<span id="TELEFONE_UNIDADE_ESCOLAR" <%=estiloInicialTelefoneUnidadeEscolar%>>[a id=TELEFONE_UNIDADE_ESCOLAR][/a]</span>
													</td>
												  </tr>
											</table>
										
										</table>
									
									</div>
                                </div>
                            </div>
							<textarea id="txtTexto" name="txtTexto"><%=strDescricao%></textarea>
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
							
							<div class="row">
								<div class="col-sm-4">
									<div class="form-group">
										<label class="form-label">Situação</label>
										<!--#include file="includes/inc_cmbSituacao.asp"-->
									</div>
								</div>
								<div class="col-sm-8">
									<div class="form-group">
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
					
	sql = "SELECT CODIGO, TITULO, SITUACAO"
	sql = sql & " FROM AEE_DOCUMENTO"
	sql = sql & " Order by SITUACAO, TITULO"
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
									<th><strong>C&oacute;digo</strong></th>
									<th><strong>Título</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								SITUACAO = "Ativo"
								FUNDO=""
								IF RS("SITUACAO") = "I" THEN
									FUNDO = " bgcolor='#FFA6A6' "
									
									SITUACAO = "Inativo"
								END IF
								%>
								  <tr <%=FUNDO%> style="cursor: pointer" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
									<td class="celula"><%=rs("codigo")%></td>
									<td height="20" class="celula"><%=trim(rs("TITULO"))%></td>
									<td height="20" class="celula"><%=situacao%></td>
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
