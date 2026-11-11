<style>
	
	.botaoVerdeClaro {
		background-color: #1da62d;
		border: #000;
		color: white;
		padding: 6px 26px;
		text-decoration: Block;
		margin: 2px 2px;
		cursor: pointer;
	}
	
	.botaoAzulClaro {
		background-color: #2d8be8;
		border: #000;
		color: white;
		padding: 6px 26px;
		text-decoration: Block;
		margin: 2px 2px;
		cursor: pointer;
	}
	
	.btn-arquivo {
		font-size: 14px !important;
		text-align: center !important;
		padding: 0.375rem 0.844rem !important;
		font-size: 0.75rem !important;
		line-height: 1.5 !important;
		border-radius: 4px !important;
	}

</style>

<!----------image croppie-->
<link rel="Stylesheet" type="text/css" href="../assets/croppie/bower_components/sweetalert/dist/sweetalert.css" />
<link rel="Stylesheet" type="text/css" href="../assets/croppie/croppie.css" />
<link rel="Stylesheet" type="text/css" href="../assets/croppie/foto-aluno/foto-aluno.css?V=2" />
<!----------------------->

<%
	mensagem_alerta_pagina_2 = ""
	retira_incluir = "S"
	strUsuarioLiberadoParaMatricularDireto = ""
	sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
	sql = sql & " Where cod_grupo = " & Session("CodGrupo")
	sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
	rs.open sql, cnn
	if rs.eof = false then
		strUsuarioLiberadoParaMatricularDireto = ucase(trim(session("usuarioWeb")))
	end if 
	rs.close
	
	strAcessoPerfil = ""
	'VERIFICA SE O USUARIO TEM ACESSO AO PERFIL DE ADMINISTRADOR SCA
	strCodPefilAcesso = "2" 
	SQL = "SELECT ACES_PERF_CODG"
	SQL = SQL & " FROM SEG_ACESSOS_USUARIO"
	SQL = SQL & " WHERE ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	SQL = SQL & " AND ACES_PERF_CODG in (" & strCodPefilAcesso & ")"
	'response.write sql
	rs.open sql, cnn
	if not rs.EOF then	
		strAcessoPerfil = "ADMINISTRADOR"
	end if
	rs.close
	
	'controle de inclusão
	AlunoNovo 				= Request("AlunoNovo") 				'aluno novo
	receberTransferencia 	= Request("receberTransferencia") 	'aluno novo que vem de outra unidade
	
	strPagina 				= "sca_aluno.asp"
	strPaginaTitulo 		= "sca_aluno.asp"
	strMostraTodasTurmas 	= Request.Form("strMostraTodasTurmas")
	strExecutarSubmitGradeCurricular = "S"
	strExecutarSubmitSemestre = "S"
	
	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
		if trim(Session("MatriculaInformatizada")) = "SIM"  then
			strExecutarSubmitTurma = "S"
			%>
			<!--script>
				alert("ATENÇÃO: Não será permitida alteração de Nome durante a efetivação. O nome poderá ser apenas corrigido.");
			</script-->
			<%
		else
			if Session("CodEmpresa") <> "!!" then
				IF session("codGrupo") = "7" THEN
					%>
					<!--script>
						alert("ATENÇÃO: Inclusão bloqueada temporáriamente durante o processo de matrícula.");
					</script -->
					<%
				END IF	
			end if
		end if	
	else
		mensagem_alerta_pagina_2 = "ATENÇÃO:<br>"
		mensagem_alerta_pagina_2 = mensagem_alerta_pagina_2  & "* Seu usuário está com acesso direto a inclusão de aluno, essa inclusão não passará pela matrícula." 

	end if
	
	'chave da tabela    
	strCod_empresa 			= Session("CodEmpresa")
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
    intSemestre 	        = Trim(Request("cmbSemestre"))
	
	if strAnoLetivo = "" then
	   strAnoLetivo          = session("strAnoLetivo")
    end if

	if intSemestre = "0" or intSemestre = "" then
	   intSemestre          = session("strSemestre")
    end if
	
	if Trim(Request("txtAnoLetivoAnterior")) <> "" then
		strAnoLetivoAnterior = Request("txtAnoLetivoAnterior")
	else
		strAnoLetivoAnterior = strAnoLetivo
	end if

	strMatriculaLocalizar 		= Trim(Request.Form("txtMatriculaLocalizar"))
	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
	intCodEmpresaGrupoUsuario	= Trim(Request.Form("cmdEmpresaGrupoUsuario"))

	strNomeBotaoFoto		= "Incluir Foto (10Kb)"
	strImgAlunoSemFoto = "img/aluno-sem-foto-incluir.jpg"
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	intCodAluno			= Trim(Request("txtCodAluno"))			
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	'dados pessoais
	strDatamatricula 			= formataDataAP(Trim(Request.Form("txtDatamatricula")))
	strNumeroRegistroNascimento	= Trim(Request.Form("txtNumeroRegistroNascimento"))
	strCPF						= formataCPFap(Trim(Request.Form("txtcpf")))
	
	strFolha			= Trim(Request.Form("txtFolha"))
	strLivro			= Trim(Request.Form("txtLivro"))
	strTermo			= Trim(Request.Form("txtTermo"))
	strNomeCartorio		= Trim(Request.Form("txtNomeCartorio"))
	
	strSexo		 				= Trim(Request.Form("cmbSexo"))
	strDatanascimento 			= formataDataAP(Trim(Request.Form("txtDatanascimento")))
	strDataEmissaoCertidaoNasc 	= formataDataAP(Trim(Request.Form("txtDataEmissaoCertidaoNascimento")))
	 
	strCidadenascimento 	= Trim(Request.Form("txtCidadenascimento"))
	strUfnascimento 		= Trim(Request.Form("cmbUfnascimento"))
	strNacionalidade 		= Trim(Request.Form("cmbNacionalidade"))	
	if strNacionalidade = "" then strNacionalidade 		= "Brasileira"
	strTipoNacionalidade 	= Trim(Request.Form("cmbTipoNacionalidade"))
	if strTipoNacionalidade = "" then strTipoNacionalidade 		= "1"
	intCodEstadocivil 		= Trim(Request.Form("cmbEstadoCivil"))
	intCodProfissao 		= Trim(Request.Form("cmbProfissao"))
	
	intCodReligiao 			= Trim(Request.Form("cmbReligiao"))
	intCodEtnia 			= Trim(Request.Form("cmbEtnia"))
	intCodNecessidadeEspecial 	= Trim(Request.Form("cmbNecessidadeEspecial"))

	intCodCondicaoEspecial	 = Trim(Request.Form("cmbCondicaoEspecial"))
	strCondicaoEspecialOutro = Trim(Request.Form("txtCondicaoEspecialOutro"))
	
	strAtendimentoespecial 		= Trim(Request.Form("txtAtendimentoespecial"))
	strSalaAEE		 		= Trim(Request.Form("cmbSalaAEE"))
	strFoneResidencial 		= Trim(Request.Form("txtFoneResidencial"))
	strFonecomercial 		= Trim(Request.Form("txtFonecomercial"))
	strFoneCelular	 		= Trim(Request.Form("txtFonecelular"))
	strEmail 				= Trim(Request.Form("txtEmail"))
	
	RESPONSAVEL_QUEM 				= Trim(Request.Form("RESPONSAVEL_QUEM"))
	RESPOSAVEL_POSSUI_DOCUMENTACAO 	= Trim(Request.Form("RESPOSAVEL_POSSUI_DOCUMENTACAO"))

	MEDICAMENTO_CONTROLADO 		= Trim(Request.Form("MEDICAMENTO_CONTROLADO"))
	MEDICAMENTO_CONTROLADO_QUAL = Trim(Request.Form("MEDICAMENTO_CONTROLADO_QUAL"))
	TRANSPORTE_ESCOLAR 			= Trim(Request.Form("TRANSPORTE_ESCOLAR"))
	AUTORIZA_USO_IMAGEM 		= Trim(Request.Form("AUTORIZA_USO_IMAGEM"))
	RESTRICAO_ALIMENTAR 		= Trim(Request.Form("RESTRICAO_ALIMENTAR"))
	RESTRICAO_ALIMENTAR_QUAL 	= Trim(Request.Form("RESTRICAO_ALIMENTAR_QUAL"))
	ALERGIA 					= Trim(Request.Form("ALERGIA"))
	ALERGIA_QUAL 				= Trim(Request.Form("ALERGIA_QUAL"))
	
	intCodTamanhoRoupa 			= Trim(Request.Form("cmbTamanhoRoupa"))
	intCodTamanhoCalcado 		= Trim(Request.Form("cmbTamanhoCalcado"))
	
	
	ID_CENSO 				= Trim(Request.Form("ID_CENSO"))

	'endereço
	strLogradouro 		= Trim(Request.Form("txtLogradouro"))
	strNumero_endereco 	= Trim(Request.Form("txtNumero_endereco"))
	strComp_endereco 	= Trim(Request.Form("txtComp_endereco"))
	strBairroaluno 		= Trim(Request.Form("txtBairroaluno"))
	strCidaderesidencia	= Trim(Request.Form("txtCidaderesidencia"))
	strUfresidencia 	= Trim(Request.Form("cmbUfresidencia"))
	strCepresidencia 	= Trim(Request.Form("txtCepresidencia"))
	
	'dados familiares
	strPai 				= Trim(Request.Form("txtPai"))
	strPaifalecido 		= Trim(Request.Form("txtPaifalecido"))
	strPaifone 			= Trim(Request.Form("txtPaifone"))
	strPaidatanascimento= formataDataAP(Trim(Request.Form("txtPaidatanascimento")))
	intCodProfissaoPai	= Trim(Request.Form("cmbProfissaoPai"))
	intCodGrauInstrucaoPai= Trim(Request.Form("cmbGrauInstrucaoPai"))

	strMae 				= Trim(Request.Form("txtMae"))
	strMaefalecida 		= Trim(Request.Form("txtMaefalecida"))
	strMaefone 			= Trim(Request.Form("txtMaefone"))
	strMaedatanascimento= formataDataAP(Trim(Request.Form("txtMaedatanascimento")))
	intCodProfissaoMae	= Trim(Request.Form("cmbProfissaoMae"))
	intCodGrauInstrucaoMae= Trim(Request.Form("cmbGrauInstrucaoMae"))

	strResponsavel 				= Trim(Request.Form("txtResponsavel"))
	strCPFResponsavel 			= Trim(Request.Form("txtCPFResponsavel"))
	strResponsavelfone 			= Trim(Request.Form("txtResponsavelfone"))
	strResponsaveldatanascimento= formataDataAP(Trim(Request.Form("txtResponsaveldatanascimento")))
	intCodProfissaoResponsavel	= Trim(Request.Form("cmbProfissaoResponsavel"))
	intCodGrauInstrucaoResponsavel= Trim(Request.Form("cmbGrauInstrucaoResponsavel"))

	intQtdeIrmao 		= Trim(Request.Form("cmdQtdeIrmao"))
	intQtdeIrmaoEscola	= Trim(Request.Form("cmdQtdeIrmaoEscola"))
	
	'documentos
	strIdentidade 		= Trim(Request.Form("txtIdentidade"))
	strIdentidadeOrgao	= Trim(Request.Form("txtIdentidadeOrgao"))
	strIdentidadeUF		= Trim(Request.Form("cmbUFIdentidade"))
	strTituloNumero 	= Trim(Request.Form("txtTituloNumero"))
	strTituloZona 		= Trim(Request.Form("txtTituloZona"))
	strTituloSecao 		= Trim(Request.Form("txtTituloSecao"))
	strRegmilitar 		= Trim(Request.Form("txtRegmilitar"))
	strCpfaluno 		= Trim(Request.Form("txtCpfaluno"))
	
	'dados escolares
	intCodGradeCompleta	= Trim(Request.Form("cmbGradeCompleta"))
	if intCodGradeCompleta = "" then intCodGradeCompleta = "0"

	strMesanovestibular = Trim(Request.Form("txtMesanovestibular"))

	intCodFormaIngresso 	= Trim(Request.Form("cmbOrigem"))
	strDataingresso 		= formataDataAP(Trim(Request.Form("txtDataingresso")))
	intCodSituacaoAluno 	= Trim(Request.Form("cmbSituacaoAluno"))

	strDatafastamento 		= formataDataAP(Trim(Request.Form("txtDatafastamento")))
	intCodMotivoAfastamento	= Trim(Request.Form("cmbMotivoAfastamento"))
	strObsafastamento 		= Trim(Request.Form("txtObsafastamento"))

	strDatacolacao 			= formataDataAP(Trim(Request.Form("txtDatacolacao")))
	strAnoconclusao 		= Trim(Request.Form("txtAnoconclusao"))

	strEscola				= Trim(Request.Form("txtEscola"))
	strEscolaOrigem			= Trim(Request.Form("txtEscolaOrigem"))
	strCodigoInep			= Trim(Request.Form("txtCodigoInep"))
	
	strCidade			 				= Trim(Request.Form("txtCidade"))
	strAnoconclusaoEnsinoMedio 			= Trim(Request.Form("txtAnoconclusaoEnsinoMedio"))
	strSemestreconclusaoEnsinoMedio 	= Trim(Request.Form("txtSemestreconclusaoEnsinoMedio"))
	intCodDisciplinaVestibular 			= Trim(Request.Form("cmbDisciplinaVestibular"))
	
	
	strUfEnsinoMedio	= Trim(Request.Form("cmbUFEnsinoMedio"))


	strSemconclusao 	= Trim(Request.Form("txtSemconclusao"))
	strDataConclusao 	= formataDataAP(Trim(Request.Form("txtDataConclusao")))
	strDatacertificado 	= formataDataAP(Trim(Request.Form("txtDatacertificado")))

	intViaCarterinha 	= Trim(Request.Form("cmbViaCarterinha"))
	strSetransp 		= Trim(Request.Form("txtSetransp"))
	strCartaoSUS 		= Trim(Request.Form("txtCartaoSUS"))
	strBolsaFamilia 		= Trim(Request.Form("txtBolsaFamilia"))

	'dados finaceiro
	intCodPlanoPagamento 	= Trim(Request.Form("cmbPlanoPagamento"))

	strLogradouro_cobranca 		= Trim(Request.Form("txtLogradouro_cobranca"))
	strNumero_endereco_cobranca	= Trim(Request.Form("txtNumero_endereco_cobranca"))
	strComp_endereco_cobranca 	= Trim(Request.Form("txtComp_endereco_cobranca"))

	sql = "SELECT isnull(Sigla,'EB') as NivelEnsinoSigla"
	sql = sql & " FROM SCA_GRAU"
	rs.open sql, cnn
	if rs.eof = false then
		strNivelEnsinoSigla		= Trim(rs("NivelEnsinoSigla"))
	end if 
	rs.close


	if receberTransferencia = "S" then
	'****RECEBE TRASNFERENCIA ********
		strCod_empresa 	= Trim(Request("txtCodEmpresa"))
		strCodAluno 	= Trim(Request("txtCodAluno"))
		sql = "SELECT S.Desc_SituacaoAluno, A.*, AA.ANO_LETIVO, E.SITUACAO AS SITUACAO_NECESSIDADE_ESPECIAL "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
		sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL E ON E.Cod_necespecial = A.Cod_necespecial "
		sql = sql & " Where AA.COD_EMPRESA = " & strCod_empresa
		sql = sql & " And 	A.codigo = " & strCodAluno
		
		
		rs.open sql, cnn
		
		if rs.eof = false then
			strSituacaoAluno				= TRIM(rs("Desc_SituacaoAluno"))
			SITUACAO_NECESSIDADE_ESPECIAL	= TRIM(rs("SITUACAO_NECESSIDADE_ESPECIAL"))
			'dados pessoais
			strCodAluno						= TRIM(rs("Codigo"))
			intCodAluno						= TRIM(rs("Codigo"))
			strMatricula 					= TRIM(rs("Matricula"))
			strNomealuno 					= TRIM(rs("Nomealuno"))
			strDatamatricula 				= formataDataAP(TRIM(rs("Datamatricula")))
			strNumeroRegistroNascimento  	= TRIM(rs("NUMREGISTRONASC"))
			strCPF  						= formataCPFap(TRIM(rs("cpf")))
			strAnoletivo_ano_letivo			= rs("ANO_LETIVO")
			strFolha						= TRIM(rs("Folha"))
			strLivro						= TRIM(rs("Livro"))
			strTermo						= TRIM(rs("Termo"))
			strNomeCartorio					= TRIM(rs("NomeCartorio"))
			strSexo		 					= TRIM(rs("SexoAluno"))
			strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
			strDataEmissaoCertidaoNasc 		= formataDataAP(TRIM(rs("DataEmissaoCertidaoNascimento")))
			strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
			strUfnascimento 				= TRIM(rs("Ufnascimento"))
			strNacionalidade 				= TRIM(rs("Nacionalidade"))
			if isnull(strNacionalidade) then strNacionalidade 		= "Brasileira"
			
			strTipoNacionalidade			= TRIM(rs("cod_TipoNacionalidade"))
			if isnull(strTipoNacionalidade) then strTipoNacionalidade 		= "1"
			
			intCodEstadocivil 				= TRIM(rs("cod_EstadoCivil"))
			intCodProfissao 				= TRIM(rs("cod_Profissao"))
			intCodEtnia 					= TRIM(rs("cod_Etnia"))

			intCodReligiao 					= TRIM(rs("cod_Religiao"))
			intCodNecessidadeEspecial 		= TRIM(rs("Cod_necespecial"))
			strAtendimentoespecial 			= TRIM(rs("Atendimentoespecial"))
			strSalaAEE						= TRIM(rs("sala_aee"))
			strFoneResidencial 				= TRIM(rs("FoneResidencial"))
			strFonecomercial 				= TRIM(rs("Fonecomercial"))
			strFoneCelular	 				= TRIM(rs("Fonecelular"))
			strEmail 						= TRIM(rs("Email"))
			
			'endereço
			strLogradouro 					= TRIM(rs("Logradouro"))
			strNumero_endereco 				= TRIM(rs("Numero_endereco"))
			strComp_endereco 				= TRIM(rs("Comp_endereco"))
			strBairroaluno 					= TRIM(rs("Bairroaluno"))
			strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
			strUfresidencia 				= TRIM(rs("Ufresidencia"))
			strCepresidencia 				= TRIM(rs("Cepresidencia"))
			
			'dados familiares
			strPai 							= TRIM(rs("Pai"))
			strPaifalecido 					= TRIM(rs("Paifalecido"))
			strPaifone 						= TRIM(rs("Paifone"))
			strPaidatanascimento			= formataDataAP(TRIM(rs("Paidatanascimento")))
			intCodProfissaoPai				= TRIM(rs("Pai_cod_profissao"))
			intCodGrauInstrucaoPai			= TRIM(rs("Pai_cod_grauinstrucao"))

			strMae 							= TRIM(rs("Mae"))
			strMaefalecida 					= TRIM(rs("Maefalecida"))
			strMaefone 						= TRIM(rs("Maefone"))
			strMaedatanascimento			= formataDataAP(TRIM(rs("Maedatanascimento")))
			intCodProfissaoMae				= TRIM(rs("Mae_cod_profissao"))
			intCodGrauInstrucaoMae			= TRIM(rs("Mae_cod_grauinstrucao"))

			strResponsavel 					= TRIM(rs("Responsavel"))
			if isnull(rs("Responsavel")) then strResponsavel = strMae
			strCPFResponsavel				= TRIM(rs("CPFResponsavel"))
			strResponsavelfone 				= TRIM(rs("Responsavelfone"))
			strResponsaveldatanascimento	= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
			intCodProfissaoResponsavel		= TRIM(rs("Responsavel_cod_profissao"))
			intCodGrauInstrucaoResponsavel	= TRIM(rs("Responsavel_cod_grauinstrucao"))

			intQtdeIrmao 					= TRIM(rs("Qtde_irmao"))
			intQtdeIrmaoEscola				= TRIM(rs("Qtde_irmao_escola"))

			'documentos
			strIdentidade 					= TRIM(rs("Identidade"))
			strIdentidadeOrgao				= TRIM(rs("IdentidadeOrgao"))
			strIdentidadeUF					= TRIM(rs("IdentidadeUF"))
			
			strTituloNumero 				= TRIM(rs("TituloEleitor"))
			strTituloZona	 				= TRIM(rs("TituloZona"))
			strTituloSecao	 				= TRIM(rs("TituloSecao"))
			
			strRegmilitar 					= TRIM(rs("Regmilitar"))
			strCpfaluno 					= TRIM(rs("Cpfaluno"))
			
			'dados escolares
			intCodGradeCompleta				= TRIM(rs("Cod_gradevestibular"))
			strMesanovestibular 			= TRIM(rs("Mesanovestibular"))
		
			intCodFormaIngresso 			= TRIM(rs("cod_FormaIngresso"))
			strDataingresso 				= formataDataAP(TRIM(rs("Dataingresso")))
			intCodSituacaoAluno				= TRIM(rs("cod_SituacaoAluno"))
		
			strDatafastamento 				= formataDataAP(TRIM(rs("Datafastamento")))
			intCodMotivoAfastamento			= TRIM(rs("Cod_motivoafastamento"))
			strObsafastamento 				= TRIM(rs("Obsafastamento"))
		
			strDatacolacao 					= formataDataAP(TRIM(rs("Datacolacao")))
			strAnoconclusao 				= TRIM(rs("Anoconclusao"))
			strSemconclusao 				= TRIM(rs("Semconclusao"))
			strDataConclusao 				= TRIM(rs("DataConclusao"))

			strDatacertificado 				= formataDataAP(TRIM(rs("Datacertificado")))
			intCodDisciplinaVestibular		= TRIM(rs("Disciplina_Processo_Seletivo"))

			intViaCarterinha 				= TRIM(rs("Ctrviace"))
			strSetransp 					= TRIM(rs("Setransp"))
		
			'dados finaceiro
			intCodPlanoPagamento 			= TRIM(rs("cod_PlanoTurma"))
		
			strLogradouro_cobranca 			= TRIM(rs("Logradouro_cobranca"))
			strNumero_endereco_cobranca		= TRIM(rs("Numero_endereco_cobranca"))
			strComp_endereco_cobranca 		= TRIM(rs("Comp_endereco_cobranca"))
		
			strEscola						= Trim(RS("Escola_ensinomedio"))
			strEscolaOrigem					= Trim(RS("Escola_origem"))
			strCodigoInep					= Trim(RS("CodigoInep"))
			strCidade			 			= Trim(RS("Cidade_ensinomedio"))
			strAnoconclusaoEnsinoMedio 		= Trim(RS("ano_ensinomedio"))
			strSemestreconclusaoEnsinoMedio	= Trim(RS("semestre_ensinomedio"))
			strUfEnsinoMedio				= Trim(RS("uf_ensinomedio"))		
			strBolsaFamilia					= Trim(RS("bolsa_Familia"))
			strCartaoSUS					= Trim(RS("CartaoSUS"))
			if isnull(strBolsaFamilia) then strBolsaFamilia = ""

			RESPONSAVEL_QUEM = RS("RESPONSAVEL_QUEM")	
			RESPONSAVEL_GRAU_PARESTESCO = RS("RESPONSAVEL_GRAU_PARESTESCO")	
			RESPOSAVEL_POSSUI_DOCUMENTACAO = RS("RESPOSAVEL_POSSUI_DOCUMENTACAO")	
			MEDICAMENTO_CONTROLADO = RS("MEDICAMENTO_CONTROLADO")	
			MEDICAMENTO_CONTROLADO_QUAL  = RS("MEDICAMENTO_CONTROLADO_QUAL")	
			TRANSPORTE_ESCOLAR 	 = RS("TRANSPORTE_ESCOLAR")		
			AUTORIZA_USO_IMAGEM  = RS("AUTORIZA_USO_IMAGEM")			
			RESTRICAO_ALIMENTAR  = RS("RESTRICAO_ALIMENTAR")			
			RESTRICAO_ALIMENTAR_QUAL  = RS("RESTRICAO_ALIMENTAR_QUAL")		
			ALERGIA  				= RS("ALERGIA")			
			ALERGIA_QUAL  			= RS("ALERGIA_QUAL")	
			intCodCondicaoEspecial 			= TRIM(rs("Cod_condicao_especial"))
			strCondicaoEspecialOutro 		= TRIM(rs("condicao_especial_outro"))

			
			intCodTamanhoRoupa				= Trim(RS("cod_tamanho_roupa"))
			intCodTamanhoCalcado			= Trim(RS("cod_tamanho_calcado"))
			ID_CENSO  			= RS("ID_CENSO")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			acao = "I"
			rs.close

'			strCaminhoFoto = session("strCaminhoRaiz") & "/gemul2015/fotoAluno/semFoto.gif"
'			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
'	
'			sql = "SELECT arquivo "
'			sql = sql & " FROM 	SCA_ALUNO_FOTO"
'			sql = sql & " Where COD_EMPRESA = " & strCod_empresa
'			sql = sql & " And 	codAluno = " & strCodAluno
'			rs.open sql, cnn
'			if rs.eof = false then
'				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rs("arquivo")
'				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
'				strNomeBotaoFoto	= "Alterar Foto"
'			end if
'			rs.close
			strCssCampo="text"
			
			
			if session("NivelPermissao") = "A" then
				BloqueiaCampo = ""
			else
				if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
					if trim(Session("MatriculaInformatizada")) = "SIM" then
						if strDatamatricula = "" then strDatamatricula = formatadataAP(date)
					end if
					strCssCampo="textDisabled"
					BloqueiaCampo = " readonly "
				end if
				
				if trim(Session("MatriculaInformatizada")) = "SIM"  then 
					strDesabilitaExcluir = " Disabled "
				end if
				if strBloqAltrExcl="S" and trim(Session("MatriculaInformatizada"))="" then 
					strDesabilitaExcluir = " Disabled "
					strDesabilitaAlterar = " Disabled "
				end if
			end if
			%>
			<script>
				alert("ATENÇÃO: Aluno foi recebido com sucesso, favor preencher os dados escolares do aluno e salvar para efetivar a INCLUSÃO!")
			</script>
			<%
			
		end if 
	
	
	'****RECEBE TRASNFERENCIA ********
	else
		'Buscar dados de outra unidade


		if trim(session("NivelPermissao")) = "A" then
			if Trim(Request.Form("LocalizarMATRICUA")) = "S" and strNomealuno = "" then
				strimportar = "S"

				if strimportar = "S" then
					sql = " SELECT A.*, E.SITUACAO AS SITUACAO_NECESSIDADE_ESPECIAL FROM SCA_ALUNO A "
					sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO"
					sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL E ON E.Cod_necespecial = A.Cod_necespecial "
					sql = sql & " Where A.MATRICULA = '" & trim(strMatriculaLocalizar) & "'"
					sql = sql & " And A.COD_EMPRESA = " & trim(intCodEmpresaGrupo) 
					sql = sql & " And S.Desc_SituacaoAluno <> 'ATIVO' "  
					
					rs.open sql, cnn
					if rs.eof = false then
						''strCodAluno						= TRIM(rs("Codigo"))
						''intCodAluno						= TRIM(rs("Codigo"))
						''strMatricula 					= TRIM(rs("Matricula"))
						SITUACAO_NECESSIDADE_ESPECIAL	= TRIM(rs("SITUACAO_NECESSIDADE_ESPECIAL"))
						strNomealuno 					= TRIM(rs("Nomealuno"))
						strNumeroRegistroNascimento  	= TRIM(rs("NUMREGISTRONASC"))
						strCPF  						= formataCPFap(TRIM(rs("cpf")))
						strFolha						= TRIM(rs("Folha"))
						strLivro						= TRIM(rs("Livro"))
						strTermo						= TRIM(rs("Termo"))
						strNomeCartorio					= TRIM(rs("NomeCartorio"))
						strSexo		 					= TRIM(rs("SexoAluno"))
						strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
						strDataEmissaoCertidaoNasc 		= formataDataAP(TRIM(rs("DataEmissaoCertidaoNascimento")))
						'strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
						if Trim(Request.Form("cmbCodigoMunicipio")) = "0" or Trim(Request.Form("cmbCodigoMunicipio")) = "" then 
							strCidadenascimento	= TRIM(rs("Cidadenascimento"))
						end if
						if Trim(Request.Form("cmbUfnascimento")) = "0"  or Trim(Request.Form("cmbUfnascimento")) = ""  then 
							strUfnascimento 	= TRIM(rs("Ufnascimento"))
						end if	
			
						if strUfnascimento = "" or isnull(strUfnascimento) then strUfnascimento = "0"
			
						strUfnascimento 	= TRIM(rs("Ufnascimento"))
						strCidadenascimento	= TRIM(rs("Cidadenascimento"))
			
			
						strNacionalidade 				= TRIM(rs("Nacionalidade"))
						strTipoNacionalidade			= TRIM(rs("cod_TipoNacionalidade"))
						intCodEstadocivil 				= TRIM(rs("cod_EstadoCivil"))
						intCodProfissao 				= TRIM(rs("cod_Profissao"))
						intCodEtnia 					= TRIM(rs("cod_Etnia"))
			
						intCodReligiao 					= TRIM(rs("cod_Religiao"))
						intCodNecessidadeEspecial 		= TRIM(rs("Cod_necespecial"))
						strAtendimentoespecial 			= TRIM(rs("Atendimentoespecial"))
						strSalaAEE						= TRIM(rs("sala_aee"))
						strFoneResidencial 				= TRIM(rs("FoneResidencial"))
						strFonecomercial 				= TRIM(rs("Fonecomercial"))
						strFoneCelular	 				= TRIM(rs("Fonecelular"))
						strEmail 						= TRIM(rs("Email"))
						
						'endereço
						strLogradouro 					= TRIM(rs("Logradouro"))
						strNumero_endereco 				= TRIM(rs("Numero_endereco"))
						strComp_endereco 				= TRIM(rs("Comp_endereco"))
						strBairroaluno 					= TRIM(rs("Bairroaluno"))
						strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
						strUfresidencia 				= TRIM(rs("Ufresidencia"))
						strCepresidencia 				= TRIM(rs("Cepresidencia"))
						
						'dados familiares
						strPai 							= TRIM(rs("Pai"))
						strPaifalecido 					= TRIM(rs("Paifalecido"))
						strPaifone 						= TRIM(rs("Paifone"))
						strPaidatanascimento			= formataDataAP(TRIM(rs("Paidatanascimento")))
						intCodProfissaoPai				= TRIM(rs("Pai_cod_profissao"))
						intCodGrauInstrucaoPai			= TRIM(rs("Pai_cod_grauinstrucao"))
			
						strMae 							= TRIM(rs("Mae"))
						strMaefalecida 					= TRIM(rs("Maefalecida"))
						strMaefone 						= TRIM(rs("Maefone"))
						strMaedatanascimento			= formataDataAP(TRIM(rs("Maedatanascimento")))
						intCodProfissaoMae				= TRIM(rs("Mae_cod_profissao"))
						intCodGrauInstrucaoMae			= TRIM(rs("Mae_cod_grauinstrucao"))
			
						strResponsavel 					= TRIM(rs("Responsavel"))
						strCPFResponsavel				= TRIM(rs("CPFResponsavel"))
						strResponsavelfone 				= TRIM(rs("Responsavelfone"))
						strResponsaveldatanascimento	= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
						intCodProfissaoResponsavel		= TRIM(rs("Responsavel_cod_profissao"))
						intCodGrauInstrucaoResponsavel	= TRIM(rs("Responsavel_cod_grauinstrucao"))
			
						intQtdeIrmao 					= TRIM(rs("Qtde_irmao"))
						intQtdeIrmaoEscola				= TRIM(rs("Qtde_irmao_escola"))
			
						'documentos
						strIdentidade 					= TRIM(rs("Identidade"))
						strIdentidadeOrgao				= TRIM(rs("IdentidadeOrgao"))
						strIdentidadeUF					= TRIM(rs("IdentidadeUF"))
						
						strTituloNumero 				= TRIM(rs("TituloEleitor"))
						strTituloZona	 				= TRIM(rs("TituloZona"))
						strTituloSecao	 				= TRIM(rs("TituloSecao"))
						
						strRegmilitar 					= TRIM(rs("Regmilitar"))
						
						if isnull(rs("Cpfaluno")) or trim(rs("Cpfaluno")) = "" then
							strCpfaluno 					= TRIM(rs("Cpfaluno"))
						else
							strCpfaluno 					= Zeroleft(TRIM(rs("Cpfaluno")),11)
						end if
						
						'dados finaceiro
						strEscola						= Trim(RS("Escola_ensinomedio"))
						strBolsaFamilia					= Trim(RS("bolsa_Familia"))
						strCartaoSUS					= Trim(RS("CartaoSUS"))
						
						RESPONSAVEL_QUEM = RS("RESPONSAVEL_QUEM")	
						RESPONSAVEL_GRAU_PARESTESCO = RS("RESPONSAVEL_GRAU_PARESTESCO")	
						RESPOSAVEL_POSSUI_DOCUMENTACAO = RS("RESPOSAVEL_POSSUI_DOCUMENTACAO")	
						MEDICAMENTO_CONTROLADO = RS("MEDICAMENTO_CONTROLADO")	
						MEDICAMENTO_CONTROLADO_QUAL  = RS("MEDICAMENTO_CONTROLADO_QUAL")	
						TRANSPORTE_ESCOLAR 	 = RS("TRANSPORTE_ESCOLAR")		
						AUTORIZA_USO_IMAGEM  = RS("AUTORIZA_USO_IMAGEM")			
						RESTRICAO_ALIMENTAR  = RS("RESTRICAO_ALIMENTAR")			
						RESTRICAO_ALIMENTAR_QUAL  = RS("RESTRICAO_ALIMENTAR_QUAL")	
						ALERGIA  = RS("ALERGIA")			
						ALERGIA_QUAL  = RS("ALERGIA_QUAL")
						
						intCodCondicaoEspecial 			= TRIM(rs("Cod_condicao_especial"))
						strCondicaoEspecialOutro 		= TRIM(rs("condicao_especial_outro"))
						
						intCodTamanhoRoupa				= Trim(RS("cod_tamanho_roupa"))
						intCodTamanhoCalcado			= Trim(RS("cod_tamanho_calcado"))
						ID_CENSO  = RS("ID_CENSO")
						
						if isnull(strBolsaFamilia) then strBolsaFamilia = ""
												
					else
						%>
						<script>
							alert("Não foi Localizado dados para importação. Verifique!")
						</script>
						<%
					end if
					rs.close
				end if
			end if
			'Fim de busca de dados de outra unidade
		end if

		if (trim(strCodAluno) <> "" or trim(strMatricula) <> "") and intCodGradeCompleta = "0" then
			sql = "SELECT iif(S.Desc_SituacaoAluno is null,Ss.Desc_SituacaoAluno,S.Desc_SituacaoAluno) as Desc_SituacaoAluno, iif(S.cod_SituacaoAluno is null,Ss.cod_SituacaoAluno,S.cod_SituacaoAluno) as codSituacaoAluno, A.*, aT.ano_letivo, AT.COD_EMPRESA, AT.SITUACAO, E.SITUACAO AS SITUACAO_NECESSIDADE_ESPECIAL "
			sql = sql & " FROM SCA_ALUNO A "
			sql = sql & " left join sca_aluno_turma at on at.cod_aluno = a.codigo and at.cod_empresa = " & session("codEmpresa")
			'sql = sql & " left join SCA_CONTROLE_SITUACAO_ALUNO c on c.COD_ALUNO = a.CODIGO and c.ANO_LETIVO = " & session("strAnoLetivo") & " and at.COD_EMPRESA = c.COD_EMPRESA"
			sql = sql & " left join SCA_CONTROLE_SITUACAO_ALUNO c on c.COD_ALUNO = a.CODIGO and at.COD_EMPRESA = c.COD_EMPRESA"
			sql = sql & " left join sca_situacaoaluno s on s.cod_situacaoaluno = c.cod_situacaoaluno "
			sql = sql & " left join sca_situacaoaluno ss on ss.cod_situacaoaluno = a.cod_situacaoaluno "
			sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL E ON E.Cod_necespecial = A.Cod_necespecial "
			sql = sql & " WHERE 1=1"
			if strCodAluno <> "" then
				sql = sql & " And 	A.codigo = " & strCodAluno
			else
				sql = sql & " And 	A.matricula = " & strMatricula
			end if
			sql = sql & " order by c.codigo desc"
			rs.open sql, cnn
			if rs.eof = false then
				strSituacao				= UCASE(TRIM(rs("SITUACAO")))
				strSituacaoAluno		= UCASE(TRIM(rs("Desc_SituacaoAluno")))
				intCodSituacaoAluno		= rs("codSituacaoAluno")
				SITUACAO_NECESSIDADE_ESPECIAL	= TRIM(rs("SITUACAO_NECESSIDADE_ESPECIAL"))
				
				'dados pessoais
				strCodAluno						= TRIM(rs("Codigo"))
				intCodAluno						= TRIM(rs("Codigo"))
				strMatricula 					= TRIM(rs("Matricula"))
				strNomealuno 					= TRIM(rs("Nomealuno"))
				strDatamatricula 				= formataDataAP(TRIM(rs("Datamatricula")))
				strNumeroRegistroNascimento  	= TRIM(rs("NUMREGISTRONASC"))
				strCPF  						= formataCPFap(TRIM(rs("cpf")))
				strAnoletivo_ano_letivo			= rs("ANO_LETIVO")
				strFolha						= TRIM(rs("Folha"))
				strLivro						= TRIM(rs("Livro"))
				strTermo						= TRIM(rs("Termo"))
				strNomeCartorio					= TRIM(rs("NomeCartorio"))
				strSexo		 					= TRIM(rs("SexoAluno"))
				strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
				strDataEmissaoCertidaoNasc 		= formataDataAP(TRIM(rs("DataEmissaoCertidaoNascimento")))
				strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
				strUfnascimento 				= TRIM(rs("Ufnascimento"))
				strNacionalidade 				= TRIM(rs("Nacionalidade"))
				if isnull(strNacionalidade) then strNacionalidade 		= "Brasileira"
				
				strTipoNacionalidade			= TRIM(rs("cod_TipoNacionalidade"))
				if isnull(strTipoNacionalidade) then strTipoNacionalidade 		= "1"
				
				intCodEstadocivil 				= TRIM(rs("cod_EstadoCivil"))
				intCodProfissao 				= TRIM(rs("cod_Profissao"))
				intCodEtnia 					= TRIM(rs("cod_Etnia"))

				intCodReligiao 					= TRIM(rs("cod_Religiao"))
				intCodNecessidadeEspecial 		= TRIM(rs("Cod_necespecial"))
				strAtendimentoespecial 			= TRIM(rs("Atendimentoespecial"))
				strSalaAEE						= TRIM(rs("sala_aee"))
				strFoneResidencial 				= TRIM(rs("FoneResidencial"))
				strFonecomercial 				= TRIM(rs("Fonecomercial"))
				strFoneCelular	 				= TRIM(rs("Fonecelular"))
				strEmail 						= TRIM(rs("Email"))
				
				'endereço
				strLogradouro 					= TRIM(rs("Logradouro"))
				strNumero_endereco 				= TRIM(rs("Numero_endereco"))
				strComp_endereco 				= TRIM(rs("Comp_endereco"))
				strBairroaluno 					= TRIM(rs("Bairroaluno"))
				strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
				strUfresidencia 				= TRIM(rs("Ufresidencia"))
				strCepresidencia 				= TRIM(rs("Cepresidencia"))
				
				'dados familiares
				strPai 							= TRIM(rs("Pai"))
				strPaifalecido 					= TRIM(rs("Paifalecido"))
				strPaifone 						= TRIM(rs("Paifone"))
				strPaidatanascimento			= formataDataAP(TRIM(rs("Paidatanascimento")))
				intCodProfissaoPai				= TRIM(rs("Pai_cod_profissao"))
				intCodGrauInstrucaoPai			= TRIM(rs("Pai_cod_grauinstrucao"))

				strMae 							= TRIM(rs("Mae"))
				strMaefalecida 					= TRIM(rs("Maefalecida"))
				strMaefone 						= TRIM(rs("Maefone"))
				strMaedatanascimento			= formataDataAP(TRIM(rs("Maedatanascimento")))
				intCodProfissaoMae				= TRIM(rs("Mae_cod_profissao"))
				intCodGrauInstrucaoMae			= TRIM(rs("Mae_cod_grauinstrucao"))

				strResponsavel 					= TRIM(rs("Responsavel"))
				if isnull(rs("Responsavel")) then strResponsavel = strMae
				strCPFResponsavel				= TRIM(rs("CPFResponsavel"))
				strResponsavelfone 				= TRIM(rs("Responsavelfone"))
				strResponsaveldatanascimento	= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
				intCodProfissaoResponsavel		= TRIM(rs("Responsavel_cod_profissao"))
				intCodGrauInstrucaoResponsavel	= TRIM(rs("Responsavel_cod_grauinstrucao"))

				intQtdeIrmao 					= TRIM(rs("Qtde_irmao"))
				intQtdeIrmaoEscola				= TRIM(rs("Qtde_irmao_escola"))

				'documentos
				strIdentidade 					= TRIM(rs("Identidade"))
				strIdentidadeOrgao				= TRIM(rs("IdentidadeOrgao"))
				strIdentidadeUF					= TRIM(rs("IdentidadeUF"))
				
				strTituloNumero 				= TRIM(rs("TituloEleitor"))
				strTituloZona	 				= TRIM(rs("TituloZona"))
				strTituloSecao	 				= TRIM(rs("TituloSecao"))
				
				strRegmilitar 					= TRIM(rs("Regmilitar"))
				strCpfaluno 					= TRIM(rs("Cpfaluno"))
				
				'dados escolares
				intCodGradeCompleta				= TRIM(rs("Cod_gradevestibular"))
				strMesanovestibular 			= TRIM(rs("Mesanovestibular"))
			
				intCodFormaIngresso 			= TRIM(rs("cod_FormaIngresso"))
				strDataingresso 				= formataDataAP(TRIM(rs("Dataingresso")))
			
				strDatafastamento 				= formataDataAP(TRIM(rs("Datafastamento")))
				intCodMotivoAfastamento			= TRIM(rs("Cod_motivoafastamento"))
				strObsafastamento 				= TRIM(rs("Obsafastamento"))
			
				strDatacolacao 					= formataDataAP(TRIM(rs("Datacolacao")))
				strAnoconclusao 				= TRIM(rs("Anoconclusao"))
				strSemconclusao 				= TRIM(rs("Semconclusao"))
				strDataConclusao 				= TRIM(rs("DataConclusao"))

				strDatacertificado 				= formataDataAP(TRIM(rs("Datacertificado")))
				intCodDisciplinaVestibular		= TRIM(rs("Disciplina_Processo_Seletivo"))

			
				intViaCarterinha 				= TRIM(rs("Ctrviace"))
				strSetransp 					= TRIM(rs("Setransp"))
			
				'dados finaceiro
				intCodPlanoPagamento 			= TRIM(rs("cod_PlanoTurma"))
			
				strLogradouro_cobranca 			= TRIM(rs("Logradouro_cobranca"))
				strNumero_endereco_cobranca		= TRIM(rs("Numero_endereco_cobranca"))
				strComp_endereco_cobranca 		= TRIM(rs("Comp_endereco_cobranca"))
			
				strEscola						= Trim(RS("Escola_ensinomedio"))
				strEscolaOrigem					= Trim(RS("Escola_origem"))
				strCodigoInep					= Trim(RS("CodigoInep"))
				strCidade			 			= Trim(RS("Cidade_ensinomedio"))
				strAnoconclusaoEnsinoMedio 		= Trim(RS("ano_ensinomedio"))
				strSemestreconclusaoEnsinoMedio	= Trim(RS("semestre_ensinomedio"))
				strUfEnsinoMedio				= Trim(RS("uf_ensinomedio"))		
				strBolsaFamilia					= Trim(RS("bolsa_Familia"))
				strCartaoSUS					= Trim(RS("CartaoSUS"))
				if isnull(strBolsaFamilia) then strBolsaFamilia = ""


				RESPONSAVEL_QUEM = RS("RESPONSAVEL_QUEM")	
				RESPONSAVEL_GRAU_PARESTESCO = RS("RESPONSAVEL_GRAU_PARESTESCO")	
				RESPOSAVEL_POSSUI_DOCUMENTACAO = RS("RESPOSAVEL_POSSUI_DOCUMENTACAO")	
				MEDICAMENTO_CONTROLADO = RS("MEDICAMENTO_CONTROLADO")	
				MEDICAMENTO_CONTROLADO_QUAL  = RS("MEDICAMENTO_CONTROLADO_QUAL")	
				TRANSPORTE_ESCOLAR 	 = RS("TRANSPORTE_ESCOLAR")		
				AUTORIZA_USO_IMAGEM  = RS("AUTORIZA_USO_IMAGEM")			
				RESTRICAO_ALIMENTAR  = RS("RESTRICAO_ALIMENTAR")			
				RESTRICAO_ALIMENTAR_QUAL  = RS("RESTRICAO_ALIMENTAR_QUAL")	
				ALERGIA  = RS("ALERGIA")			
				ALERGIA_QUAL  = RS("ALERGIA_QUAL")	
				intCodCondicaoEspecial 			= TRIM(rs("Cod_condicao_especial"))
				strCondicaoEspecialOutro 		= TRIM(rs("condicao_especial_outro"))
				
				intCodTamanhoRoupa				= Trim(RS("cod_tamanho_roupa"))
				intCodTamanhoCalcado			= Trim(RS("cod_tamanho_calcado"))	
				ID_CENSO  = RS("ID_CENSO")
						
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
				
				IF rs("codSituacaoAluno") = "1" THEN 'ativo
					acao = "AE"
					alunoAtivo = "S"
				end if
				IF rs("codSituacaoAluno") = "2" THEN 'ativo
					acao = "AE"
				end if
				
				intCodEmpresaUltima = rs("COD_EMPRESA")
				'if session("codGrupo") = "7" then strDesabilitaAlterar	= "disabled"
				
				rs.close

'				strCaminhoFoto = session("strCaminhoRaiz") & "/gemul2015/fotoAluno/semFoto.gif"
'				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
'		
'				sql = "SELECT arquivo "
'				sql = sql & " FROM 	SCA_ALUNO_FOTO"
'				sql = sql & " Where COD_EMPRESA = " & strCod_empresa
'				sql = sql & " And 	codAluno = " & strCodAluno
'				rs.open sql, cnn
'				if rs.eof = false then
'					strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rs("arquivo")
'					strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
'					strNomeBotaoFoto	= "Alterar Foto"
'				end if
'				rs.close
			else
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
				acao = ""
'				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
'				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"

				rs.close
				
				'verifica se o aluno esta ativo em outra unidade
				sql = "SELECT "
				sql = sql & "     A.CODIGO,"
				sql = sql & "     A.MATRICULA,"
				sql = sql & "     A.NOMEALUNO,"
				sql = sql & "     CC.COD_EMPRESA,"
				sql = sql & "     A.DATAMATRICULA,"
				sql = sql & "     SA.DESC_SITUACAOALUNO,"
				sql = sql & "     A.DATAFASTAMENTO,"
				sql = sql & "     CC.UNIDADE"
				sql = sql & " FROM SCA_ALUNO A"
				sql = sql & " OUTER APPLY ("
				sql = sql & "     SELECT TOP 1"
				sql = sql & "         C.COD_EMPRESA,"
				sql = sql & "         C.COD_SITUACAOALUNO,"
				sql = sql & "         E.RAZAOSOCIAL AS UNIDADE"
				sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
				sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
				sql = sql & "     WHERE "
				sql = sql & "         C.COD_ALUNO = A.CODIGO"
				sql = sql & "         AND C.ANO_LETIVO = " & trim(session("strAnoLetivo"))
				sql = sql & "     ORDER BY C.CODIGO DESC"
				sql = sql & " ) CC"
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA "
				sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
				if strCodAluno <> "" then
					sql = sql & " where 	A.codigo = " & strCodAluno
				else
					sql = sql & " where 	A.matricula = " & strMatricula
				end if
				rs.open sql, cnn
				if rs.eof = false then
					if session("codEmpresa") <> rs("COD_EMPRESA") then
						mensagemAlunoAtivoEmOutroUnidade = "S"
						strAlunoAtivoNaUnidade = rs("unidade")
						strMatricula = ""
						strCodAluno = ""
						strNomealuno = ""
					end if
				end if
				rs.close
			end if 
		else
			if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
				if trim(Session("MatriculaInformatizada")) = "SIM" then
					strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				else	
					strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
					if session("codGrupo") <> "7" then strDesabilitaIncluir	= "disabled"
					if Session("CodEmpresa") = "999" and strimportar = "S" then strDesabilitaIncluir	= "disabled"
				end if
			end if
			
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			acao = ""
'			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
'			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
		end if 
		
		if  trim(strCodAluno) <> "" then
			intIdadeParaPeriodo = 0
			'aluno na turma
			sql = "select top 1 T.NomeTurma, T.TurmaAluno, T.COD_TURMA, P.idade_limite"
			sql = sql & " from SCA_ALUNO_TURMA AT"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA AND AT.ANO_LETIVO = T.AnoLetivo "
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = T.COD_PERIODO "
			sql = sql & " Where AT.COD_EMPRESA = " &  strCod_empresa
			sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
			sql = sql & " order by AT.CODIGO desc"
			rs.open sql, cnn
			if not rs.eof then
				intCodTurma = rs("COD_TURMA")
				intIdadeParaPeriodo = rs("idade_limite")
				strNomeTurma 	= rs("NomeTurma")
				strNomeTurmaAluno	= rs("TurmaAluno")
			else
				if alunoAtivo = "S" then
					strNomeTurma = "SEM TURMA"
					strNomeTurmaAluno = "NÃO FOI ENCONTRADA"
				end if
			end if
			rs.close
			
			if session("codGrupo") = "7" then
				strBloqAltrExcl = ""
				' bloqueia o alterar e excluir para alunos não efetivados
				sql = " select Efetivacao from MAT_inscricao " 
				sql = sql & " where cod_aluno = " &  strCodAluno
				rs.open sql, cnn
				if rs.eof = false then
					if rs("Efetivacao") = "S" then
						strBloqAltrExcl = ""
					else
						strBloqAltrExcl = "S"
					end if
				end if 
				rs.close
			end if
		end if
		strCssCampo="text"
		BloqueiaCampo = ""
		if session("codGrupo") = "7" then
			if strDesabilitaAlterar = "" then
				if session("NivelPermissao") = "A" then
					BloqueiaCampo = ""
				else
					if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
						if trim(Session("MatriculaInformatizada")) = "SIM" then
							if strDatamatricula = "" then strDatamatricula = formatadataAP(date)
						end if
						strCssCampo="textDisabled"
						BloqueiaCampo = " readonly "
					end if
					
					if trim(Session("MatriculaInformatizada")) = "SIM"  then 
						strDesabilitaExcluir = " Disabled "
					end if
					if strBloqAltrExcl="S" and trim(Session("MatriculaInformatizada"))="" then 
						strDesabilitaExcluir = " Disabled "
						strDesabilitaAlterar = " Disabled "
					end if
				end if
				'if isnull(strUfnascimento) or strUfnascimento = "0" or strUfnascimento = "" then strUfnascimento = "9"
			end if
		end if
	end if
	
	if AlunoNovo = "S" then
	
		
		strNomealuno 		= Trim(Request.Form("txtAluno"))
		strDatanascimento 	= formatadataAP(Trim(Request.Form("txtDataNascimento")))
		strMae 				= Trim(Request.Form("txtMae"))

		strDesabilitaIncluir = ""
		strDesabilitaExcluir = " Disabled "
		strDesabilitaAlterar = " Disabled "
		acao = "I"
	end if
	
	strFotoAluno = REQUEST("txtFotoAlunoHidden")
	strCodAlunoFotoCarregada = REQUEST("txtCodAlunoFotoAlunoHidden")
	if strCodAlunoFotoCarregada <> strCodAluno then
		strFotoAluno = ""
	end if
	
	'response.write strFotoAluno
	IF strCodAluno <>"" AND (strFotoAluno = "" or strFotoAluno = strImgAlunoSemFoto) THEN
		SQL="SELECT BASE64 FROM SCA_ALUNO_FOTO WHERE COD_ALUNO=" & strCodAluno & " and base64<>'img/aluno-sem-foto.jpg'"
		RS.OPEN SQL, cnn
		IF RS.EOF = FALSE THEN
			strFotoAluno = RS("BASE64")
		END IF
		RS.CLOSE
	END IF

	if strFotoAluno = "" then strFotoAluno = strImgAlunoSemFoto
	
	marcouNecessidadeEspecial1  = ""
	marcouNecessidadeEspecial2  = ""
	marcouNecessidadeEspecial3  = ""
	marcouNecessidadeEspecial4  = ""
	marcouNecessidadeEspecial5  = ""
	marcouNecessidadeEspecial8  = ""
	marcouNecessidadeEspecial11 = ""
	marcouNecessidadeEspecial14 = ""
	marcouNecessidadeEspecial15 = ""
	marcouNecessidadeEspecial18 = ""

	IF strCodAluno <>"" then
	
		'busca necessidade_especiais
		sql = "select COD_NECESSIDADEESPECIAL from SCA_ALUNO_NECESSIDADEESPECIAL where cod_aluno = " & strCodAluno
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
				if rs("COD_NECESSIDADEESPECIAL") = "1"  then marcouNecessidadeEspecial1   = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "2"  then marcouNecessidadeEspecial2   = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "3"  then marcouNecessidadeEspecial3   = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "4"  then marcouNecessidadeEspecial4   = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "5"  then marcouNecessidadeEspecial5   = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "8"  then marcouNecessidadeEspecial8   = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "11" then marcouNecessidadeEspecial11  = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "14" then marcouNecessidadeEspecial14  = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "15" then marcouNecessidadeEspecial15  = " checked "
				if rs("COD_NECESSIDADEESPECIAL") = "18" then marcouNecessidadeEspecial18  = " checked "
				rs.movenext
			wend
		end if
		rs.close
		
		if intCodTurma <>"" and intCodTurma<>"0" and strDatanascimento<>"" and intIdadeParaPeriodo<>"0" then
			mensagem_distorcao_idade_serie=""
			
			Dim dataNascimentoParaDistorcaoIdadeSerie, hoje, idade

			dataNascimentoParaDistorcaoIdadeSerie = CDate(strDatanascimento) ' data de nascimento
			hoje = Date() ' data atual

			' Calcula a diferença de anos
			idade = DateDiff("yyyy", dataNascimentoParaDistorcaoIdadeSerie, hoje)

			' Ajusta se ainda não fez aniversário este ano
			If Month(hoje) < Month(dataNascimentoParaDistorcaoIdadeSerie) Or (Month(hoje) = Month(dataNascimentoParaDistorcaoIdadeSerie) And Day(hoje) < Day(dataNascimentoParaDistorcaoIdadeSerie)) Then
				idade = idade - 1
			End If

			
			if cInt(idade)>cInt(intIdadeParaPeriodo) then
				if cInt(idade)>=2 then idade_mensagem = idade & " anos "
				if cInt(idade)<1 then idade_mensagem = idade & " ano "
				mensagem_distorcao_idade_serie="Identificamos que o aluno tem atualmente " & idade_mensagem & " (nascido em " & formatadataap(strDatanascimento)& "), o que excede a idade esperada para a turma."
			end if
		end if
		
	end if
	
	'response.write "<br>strCodAluno:" & strCodAluno
	'response.write "<br>intCodTurma:" & intCodTurma
	'response.write "<br>strDatanascimento:" & strDatanascimento
	'response.write "<br>idade:" & idade
	
	'-----------| TOTAL DE ALUNOS ATIVOS |-----------------
	totalAlunoAtivo = 0

	sql="select COUNT(*)" 
	sql=sql & " from sca_aluno_turma sat"
	sql=sql & " inner join SCA_ALUNO sa on sat.COD_ALUNO = sa.CODIGO"
	sql=sql & " inner join SCA_SITUACAOALUNO sit on sa.COD_SITUACAOALUNO = sit.Cod_SituacaoAluno"
	sql=sql & " where sat.COD_EMPRESA =" & strCod_empresa
	sql=sql & " and sat.ANO_LETIVO =" & strAnoLetivo
	sql=sql & " and sat.SITUACAO = 'A'"
	sql=sql & " and sit.Desc_SituacaoAluno = 'ATIVO'"
	rs.open sql, cnn
	if rs.eof = false then
		totalAlunoAtivo = rs(0)
	end if
	rs.close	

	'-----------| TOTAL DE ALUNOS COM CADASTRO INCOMPLETO |-----------------
	totalAlunoCadIncompleto = 0
	
	dim strCamposObrigatorios, vetCamposObrigatorios

	strCamposObrigatorios = "Nomealuno,Datamatricula,Datanascimento,SexoAluno,Cidadenascimento,Nacionalidade,Ufnascimento,cod_Profissao,cod_Etnia,Fonecelular,Cidaderesidencia,Bairroaluno"
	vetCamposObrigatorios = split(strCamposObrigatorios,",")

	sql="select COUNT(*)" 
	sql=sql & " from sca_aluno_turma sat"
	sql=sql & " inner join SCA_ALUNO sa on sat.COD_ALUNO = sa.CODIGO"
	sql=sql & " inner join SCA_SITUACAOALUNO sit on sa.COD_SITUACAOALUNO = sit.Cod_SituacaoAluno"
	sql=sql & " where sat.COD_EMPRESA =" & strCod_empresa
	sql=sql & " and sat.ANO_LETIVO =" & strAnoLetivo
	sql=sql & " and sat.SITUACAO = 'A'"
	sql=sql & " and sit.Desc_SituacaoAluno = 'ATIVO'"
	sql=sql & " and ("

	for i = 0 to ubound(vetCamposObrigatorios)
		if i > 0 then
			sql=sql & " or "
		end if
		
		if vetCamposObrigatorios(i)="Ufnascimento" then
			sql=sql & " ((Rtrim(Ltrim(sa." & vetCamposObrigatorios(i) & ")) = '' or sa." & vetCamposObrigatorios(i) & " is null) and (sa.nacionalidade='BRASILEIRA'))"
		else
			sql=sql & " (Rtrim(Ltrim(sa." & vetCamposObrigatorios(i) & ")) = '' or sa." & vetCamposObrigatorios(i) & " is null) "
		end if
	next
	
	sql=sql & ")"
	
	rs.open sql, cnn
	if rs.eof = false then
		totalAlunoCadIncompleto = rs(0)
	end if
	rs.close

	totalAlunoCadCompleto = totalAlunoAtivo - totalAlunoCadIncompleto
	
	
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



	<%
	IF strAcessoPerfil <> "ADMINISTRADOR" then 
	%>
		<div class="alert alert-warning alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>Atenção! </strong> Inclusão somente pelo processo de matrícula.
		</div>
	<%
	END IF	
	
	if alunoAtivo = "S" and strNomeTurma = "SEM TURMA" then%>
		<div class="alert alert-danger alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
			
			<h5 class="alert-heading">
				<i class="fal fa-info-circle"></i> ATENÇÃO!
			</h5>
			
			A turma do aluno não foi encontrada.<br>
			Na ficha abaixo, acesse <strong>Dados Escolares</strong>, selecione a turma atual do aluno e clique em <strong>Alterar</strong>.
		</div>

		<%
	end if
	
	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
		if trim(Session("MatriculaInformatizada")) = "SIM" then %>
		<div class="alert alert-info alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>Informativo Matrícula! </strong> Aluno vindo do Processo de Matricula Informatizada.
		</div>
		<%
		end if
	end if
	if mensagem_alerta_pagina_2 <> "" then 
		%>
		<div class="alert alert-danger alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<%=mensagem_alerta_pagina_2%>
		</div>
		<%
	end if
	if mensagem_distorcao_idade_serie <> "" then 
		%>
		
		<div class="alert alert-warning alert-dismissible fade show" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>

			<!-- Container flex para alinhar ícone e texto na mesma linha -->
			<div style="display: flex; align-items: center;">
				<div class="alert-icon width-8" style="flex-shrink: 0;">
					<span class="icon-stack icon-stack-xl">
						<i class="base-2 icon-stack-3x color-warning-400"></i>
						<i class="base-10 text-white icon-stack-1x"></i>
						<i class="ni md-profile color-warning-800 icon-stack-2x"></i>
					</span>
				</div>

				<div class="flex-1 pl-1">
					<span class="h2">Aviso!</span><br>
					<%=mensagem_distorcao_idade_serie%>
				</div>
			</div>
		</div>
		<%
	end if
	if mensagemAlunoAtivoEmOutroUnidade = "S" then
	%>
		<div class="alert alert-danger  alert-dismissible fade show">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true"><i class="fal fa-times"></i></span>
			</button>
			<div class="d-flex align-items-center">
				<div class="alert-icon width-8">
					<span class="icon-stack icon-stack-xl">
						<i class="base-2 icon-stack-3x color-warning -400"></i>
						<i class="base-10 text-white icon-stack-1x"></i>
						<i class="ni md-profile color-warning -800 icon-stack-2x"></i>
					</span>
				</div>
				<div class="flex-1 pl-1">
					<span class="h2">
						Aviso!
					</span>
					<br>
					Aluno selecionado está ativo na unidade <%=strAlunoAtivoNaUnidade%>.
				</div>
			</div>
		</div>
	<%
	end if
	%>
	
	<div class="row">
		<div class="col-xl-4 ">
			<div id="divAlunoAtivo" class="panel" style="background-color: #b3eeff">
				<div class="panel-hdr">
					<h2 style="display: flex; align-items: center; gap: 10px;">
						<i class="fal fa-users" style="font-size:20px; color:#000;"></i> <span>Total de Alunos Ativos</span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span style="font-size: 30px" id="totalAlunoAtivo"><%=totalAlunoAtivo%></span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-4">
			<div id="divAlunoCadCompleto" class="panel" style="background-color: #b6ffb3">
				<div class="panel-hdr">
					<h2 style="display: flex; align-items: center; gap: 10px;">
						<i class="fal fa-check" style="font-size:20px; color:#000;"></i> <span>Cadastro completo</span>
					</h2>					
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span style="font-size: 30px" id="totalAlunoCadCompleto"><%=totalAlunoCadCompleto%></span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-4">
			<div id="divAlunoCadIncompleto" class="panel" style="background-color: #ffd0d0; cursor: pointer" onclick="return abreConsulta('sca_alunoCadInconpleto_con.asp?strCamposObrigatorios=<%=strCamposObrigatorios%>');" style="cursor: pointer;">
				<div class="panel-hdr">
					<h2 style="display: flex; align-items: center; gap: 10px;">
						<i class="fal fa-info-circle" style="font-size:20px; color:#000;"></i> <span>Cadastro incompleto</span>
					</h2>	
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; justify-content: end; flex-direction: column; align-items: end;">
						<span style="font-size: 30px" id="totalAlunoCadInCompleto"><%=totalAlunoCadIncompleto%></span>
					</div>
				</div>
			</div>
		</div>	
			
	</div>	
	
	<%
	'parametro para a lista de ocorrencias
	'1 -  intCodAluno
	'2 - intCodEmpresa
	'colocar a função 	function AbreFecha(Linha,Figura)
	intCodAluno	  = strCodAluno
	intCodEmpresa = strCod_empresa
	%>
	<!--#include file="includes/inc_ListaOcorrencias.asp"-->
	<%
	if trim(Session("MatriculaInformatizada")) = "SIM"  then 
		if acao = "" then
			acao = "AE"
		else
			if right(acao,1) <> "E" then acao = acao & "E"
		end if
	end if
	%>
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
						
						<form id="frm" name="frm"  method="post" action="sca_aluno.asp">
							<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
							<input name="receberTransferencia" type="hidden" id="receberTransferencia" value="<%=receberTransferencia%>">
							<input name="AlunoNovo" type="hidden" id="AlunoNovo" value="<%=AlunoNovo%>">
							<input name="txtCodAluno" type="hidden" id="txtCodAluno" class="form-control" size="10" value="<%=strCodAluno%>" maxlength="10">
							<input name="txtNomeAnt" type="hidden" id="txtNomeAnt" value="<%=strNomealuno%>" > 
							<input name="txtNomeMaeAnt" 		type="hidden" id="txtNomeMaeAnt" value="<%=strMae%>" > 
							<input name="txtNomePaiAnt" 		type="hidden" id="txtNomePaiAnt" value="<%=strPai%>" > 
							<input name="txtNomeResponsavelAnt" type="hidden" id="txtNomeResponsavelAnt" value="<%=strResponsavel%>" > 
							<input name="txtBolsaFamiliaAnterior" type="hidden" class="form-control" id="txtBolsaFamiliaAnterior" value="<%=strBolsaFamilia%>"/>
							<input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="form-control" size="10" value="<%=strCod_empresa%>" maxlength="10">
							<input name="txtCodSituacaoAluno" type="hidden" id="txtCodSituacaoAluno" value="<%=intCodSituacaoAluno%>">
							<%IF intCodAluno <> "" THEN%>
							<table class="table m-0">
								<thead class="thead-themed">
									<tr>
										<th>Turma Atual: <font color="blue"><strong><%=strNomeTurmaAluno%> - <%=strNomeTurma%></strong></font></th>
										<th>Código de Segurança: <font color="#FF0000"><strong><%=strCodAluno%></strong></font></th>
										<th>Situação do aluno: <font color="green"><strong><%=strSituacaoAluno%></strong></font></th>
									</tr>
								</thead>
							</table>
							<br>
							<%end if%>
							<div class="row">
								<div class="col-sm-3">
									<div class="form-group"><strong>Matrícula do aluno</strong></label>
										<div class="input-group">
											<input type="text" class="form-control" <%=BloqueiaCampo%>  value="<%=strMatricula%>" name="txtMatricula" id="txtMatricula" placeholder="" aria-label="" aria-describedby="button-addon5" onKeyPress="return formataCampo(this, 2, 10)" onBlur="carregaAluno()">
											<div class="input-group-append">
												<button class="btn btn-primary waves-effect waves-themed" type="button" id="button-addon5" onClick="return abreConsulta('sca_aluno_con.asp')" ><i class="fal fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-group">
										<%IF strAcessoPerfil = "ADMINISTRADOR" then %>
										<br>
										<button class="btn btn-success waves-effect waves-themed" type="button" id="button-addon5" onClick="return verificar()" >Incluir Aluno <i class="fal fa-arrow-alt-circle-right"></i></button>
										<%end if%>
									</div>
								</div>
								
								<div class="col-sm-3">
									<div class="form-group">
									
									</div>
								</div>	
							</div>
							<br>

							<div id="card_dados_pessoais" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_dados_pessoais > .card-dados_pessoais" aria-expanded="true">
										<span class="collapsed-hidden"><strong>Dados Pessoais&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Dados Pessoais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-dados_pessoais p-0 collapse show" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										<div class="row">
											<div class="col-md-2">
												<div class="row">
													<div class="col-sm-12">
														<table style="width:120px; height:170px; border:1px solid #999;background-color:#CCC" cellpadding="2" cellspacing="2">
															<tr>
																<td>
																	<div id="divFoto"  onclick="return abreEditorFoto()">
																		<img id="fotoAluno" src="<%=strFotoAluno %>" style="border:1px solid #999999; width:120px; height:170px;" />
																	</div>
																</td>
															</tr>
															<tr>
																<td>
																	<a style="font-size:12px; color:#666; cursor:pointer" onclick="return limparFoto()">&nbsp;<img src="img/excluir.gif" style="vertical-align: middle" />&nbsp;&nbsp;remover foto</a>
																</td>
															</tr>
														</table>
													   <input type="hidden" name="txtFotoAlunoHidden" id="txtFotoAlunoHidden" value="<%=strFotoAluno %>" />              
													   <input type="hidden" name="txtFotoAlunoAnteriorHidden" id="txtFotoAlunoAnteriorHidden" value="<%=strFotoAluno %>" />              
													   <input type="hidden" name="txtCodAlunoFotoAlunoHidden" id="txtCodAlunoFotoAlunoHidden" value="<%=strCodAluno %>" />              
													</div>
												</div>												
											</div>
											<div class="col-md-10">
												<div class="row">
													<div class="col-sm-4">
														<div class="form-group">
															<label class="form-label">Nome completo *</label>
															<input <%=BloqueiaCampo%> name="txtNomealuno" type="text" class="form-control <%=strCssCampo%>" id="txtNomealuno" size="50" maxlength="70" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 70)">
														</div>
													</div>	
													<div class="col-sm-2">
														<div class="form-group">
															<label class="form-label">Data de nascimento *</label>
															<input  name="txtDataNascimento" type="text" class="form-control <%=strCssCampo%>" id="txtDataNascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>">
														</div>
													</div>	
													<div class="col-sm-2">
														<div class="form-group">
															<label class="form-label">CPF *</label>
															<input name="txtcpf" type="text" class="form-control" id="txtcpf" size="12" maxlength="15" value="<%=strCPF%>" onKeyPress="return formataCampo(this,5,14)" onBlur="return validaCPFAluno(this)">
														</div>
													</div>	
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Data da matrícula *</label>
															<input name="txtDatamatricula" type="text" class="form-control" id="txtDatamatricula" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatamatricula%>"> 
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Sexo *</label>
															<!--#include file="includes/inc_cmdSexo.asp" -->
														</div>
													</div>
												</div>
												<br>
												<div class="row">
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Número RG Nasc.</label>
															<input name="txtNumeroRegistroNascimento" type="text" class="form-control" id="txtNumeroRegistroNascimento" size="40" maxlength="40" value="<%=strNumeroRegistroNascimento%>"  onKeyPress="return formataCampo(this, 2, 40)">
														</div>
													</div>	
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Data emissão RG</label>
															<input name="txtDataEmissaoCertidaoNascimento" type="text" class="form-control" id="txtDataEmissaoCertidaoNascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataEmissaoCertidaoNasc%>">
														</div>
													</div>
													<div class="col-sm-4">	
														<div class="form-group">
															<label class="form-label">Nome do cartório</label>
															<input name="txtNomeCartorio" type="text" class="form-control" id="txtNomeCartorio" size="50" maxlength="50" value="<%=strNomeCartorio%>">
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Folha</label>
															<input name="txtFolha" type="text" class="form-control" id="txtFolha" size="20" maxlength="20" value="<%=strFolha%>">
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Livro</label>
															<input name="txtLivro" type="text" class="form-control" id="txtLivro" size="20" maxlength="20" value="<%=strLivro%>">
														</div>
													</div>
												</div>							
												<br>
												<div class="row">
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Naturalidade *</label>
															<input name="txtCidadenascimento" type="text" class="form-control" id="txtCidadenascimento" size="40" maxlength="40" value="<%=strCidadenascimento%>" onKeyPress="return formataCampo(this, 1, 40)">
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">UF de nascimento *</label>
															<!--#include file="includes/inc_cmdUFNascimento.asp" -->
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Nacionalidade *</label>
															<!--#include file="includes/inc_cmdNacionalidade.asp"-->
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Tipo de nacionalidade *</label>
															<!--#include file="includes/inc_cmdTipoNacionalidade.asp" -->
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Profissão *</label>
															<%if intCodProfissao = "0" or intCodProfissao = "" or isnull(intCodProfissao) then intCodProfissao = "157"%><!--#include file="includes/inc_cmdProfissao.asp" -->
														</div>
													</div>
													<div class="col-sm-2">
														<div class="form-group">
															<label class="form-label">Etnia *</label>
															<!--#include file="includes/inc_cmdEtnia.asp" -->
														</div>
													</div>	
												</div>	
												<br>
												<div class="row">
													<div class="col-sm-2">
														<div class="form-group">
															<label class="form-label">Cartão SUS *</label>
															<input name="txtCartaoSUS" type="text" class="form-control" id="txtCartaoSUS" size="15" maxlength="15"  onBlur="validaCNS(this.value)" value="<%=strCartaoSUS%>"  />
														</div>
													</div>	
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Bolsa Família</label>
															<input name="txtBolsaFamilia" type="text" class="form-control" id="txtBolsaFamilia" size="15" maxlength="11" onKeyPress="return formataCampo(this, 2, 11)" value="<%=strBolsaFamilia%>" onBlur="validaDigitacaoBolsaFamilia()" />
														</div>
													</div>									
													<div class="col-sm-4">	
														<div class="form-group">
															<label class="form-label">Estado civil</label>
															<!--#include file="includes/inc_cmdEstadoCivil.asp" -->
														</div>
													</div>	
													<div class="col-sm-4">
														<div class="form-group">
															<label class="form-label">Religi&atilde;o</label>
															<!--#include file="includes/inc_cmdReligiao.asp" -->
														</div>
													</div>	
													
												</div>
												<br>
												<div class="row">
													<div class="col-sm-6">
														<div class="form-group">
															<label class="form-label">Email</label>
															<input name="txtEmail" type="text" class="form-control" id="txtEmail" size="50" maxlength="100" value="<%=strEmail%>">
														</div>
													</div>	
													<div class="col-sm-2">
														<div class="form-group">
															<label class="form-label">Fone residencial</label>
															<input name="txtFoneResidencial" type="text" class="form-control" id="txtFoneResidencial"  size="20" maxlength="15" value="<%=strFoneResidencial%>">
														</div>
													</div>	
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Celular</label>
															<input name="txtFonecelular" type="text" class="form-control" id="txtFonecelular"  size="20" maxlength="15" value="<%=strFonecelular%>">
														</div>
													</div>
													<div class="col-sm-2">	
														<div class="form-group">
															<label class="form-label">Fone comercial</label>
															<input name="txtFoneComercial" type="text" class="form-control" id="txtFoneComercial"  size="20" maxlength="15" value="<%=strFoneComercial%>">
														</div>
													</div>
												</div>
												<br>
												<div class="row">
													<div class="col-sm-3">	
														<div class="form-group">
															<label class="form-label">Atendimento especial</label>
															<select name="txtAtendimentoespecial" class="form-control" id="txtAtendimentoespecial">
																<option value="N" <%if strAtendimentoespecial = "N" then response.Write("selected") %>>N&atilde;o</option>
																<option value="S" <%if strAtendimentoespecial = "S" then response.Write("selected") %>>Sim</option>
															</select>
														</div>
													</div>	
													<div class="col-sm-3">	
														<div class="form-group">
															<label class="form-label">Usa Sala AEE</label>
															<select name="cmbSalaAEE" class="form-control" id="cmbSalaAEE">
																<option value="N" <%if strSalaAEE = "N" then response.Write("selected") %>>N&atilde;o</option>
																<option value="S" <%if strSalaAEE = "S" then response.Write("selected") %>>Sim</option>
															</select>
															</div>
													</div>		
													<div class="col-sm-2">
														<div class="form-group">
															<label class="form-label">Condição especial</label>
															<!--#include file="includes/inc_cmdCondicaoEspecial.asp" -->
														</div>
													</div>	
													<%
													if trim(intCodCondicaoEspecial) = "8" then 
														display_condicao_especial = "style='display:table-row'"
													else
														display_condicao_especial = "style='display:none'"
													end if
													%>											
													<div class="col-sm-4" <%=display_condicao_especial%> id="coluna_condicao_especial">
														<div class="form-group">
															<label class="form-label">Qual?</label>
															<input name="txtCondicaoEspecialOutro" type="text" class="form-control" id="txtCondicaoEspecialOutro" size="100" maxlength="250" value="<%=strCondicaoEspecialOutro%>" >
														</div>
													</div>
												</div>
											</div>
										</div>
										
									</div>
								</div>
							</div>
							
							<%
							strSem = session("strSemestre")	
							if session("strSemestre") = "3" then strSem = "Anual"
							if session("strSemestre") = "1,3" then strSem = "1ºSem/Anual"
							if session("strSemestre") = "2,3" then strSem = "2ºSem/Anual"

							if strCodAluno <> "" then
								intCodTurma = ""
								intCod_GradeCurricular = ""

								'aluno na turma
								sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular"
								sql = sql & " from SCA_ALUNO_TURMA AT"
								sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
								sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo "
								'sql = sql & " AND AT.SEMESTRE = T.Cod_Semestre"
								sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
								sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
								'sql = sql & " and AT.ANO_LETIVO = " &  strAnoLetivo
								'sql = sql & " and AT.SEMESTRE in (" &  intSemestre & ")"
								sql = sql & " and AT.SITUACAO = 'A'"'ATIVA
								sql = sql & " order by AT.CODIGO desc"
								'response.write sql
								rs.open sql, cnn
								if not rs.eof then
									intCodTurma = rs("cod_Turma")
									intCod_GradeCurricular = rs("Cod_GradeCurricular")
								end if
								rs.close
							
								if trim(intCodTurma) = "" then
									'aluno na turma
									sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular, AT.ANO_LETIVO, AT.SEMESTRE"
									sql = sql & " from SCA_ALUNO_TURMA AT"
									sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
									sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
									sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
									sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
									sql = sql & " order by AT.CODIGO desc"
									rs.open sql, cnn
									if not rs.eof then
										intCodTurma = rs("cod_Turma")
										intCod_GradeCurricular = rs("Cod_GradeCurricular")
										if strAnoLetivo = "" then
										   strAnoLetivo 	= rs("ANO_LETIVO")
										end if
										if intSemestre = "" or intSemestre = "0" then    
										   intSemestre 	= rs("SEMESTRE")
										end if   
										if intSemestre = "3" then strSem = "Anual"
										if intSemestre = "1" then strSem = "1ºSem"
										if intSemestre = "2" then strSem = "2ºSem"
									end if
									rs.close
								end if					
							end if	
							
							if Session("MatriculaInformatizada")="SIM" then
								strAnoLetivo = Session("MatriculaInformatizadaAnoEfetivacao")  
							end if
							
							
							
							%>
							<div id="card_necessidade_especiais" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_necessidade_especiais > .card-necessidade_especiais" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Necessidade Especiais&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Necessidade Especiais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-necessidade_especiais p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										
										
										<!-- Deficiência -->
										<div class="checkbox-title">Deficiência</div>
										<div class="row">
											<div class="col-md-6 checkbox-group">
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial2%> value="2" onClick="verificaOpcaoDeficiencia(this);"> Baixa Visão</label>
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial1%> value="1" onClick="verificaOpcaoDeficiencia(this);"> Cegueira</label>
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial15%> value="15" onClick="verificaOpcaoDeficiencia(this);"> Deficiência Auditiva</label>
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial14%> value="14" onClick="verificaOpcaoDeficiencia(this);"> Deficiência Física</label>
											</div>
											<div class="col-md-6 checkbox-group">
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial5%> value="5" onClick="verificaOpcaoDeficiencia(this);"> Deficiência Intelectual</label>
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial18%> value="18" onClick="verificaOpcaoDeficiencia(this);"> Visão Monocular</label>
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial3%> value="3" onClick="verificaOpcaoDeficiencia(this);"> Surdez</label>
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial4%> value="4" onClick="verificaOpcaoDeficiencia(this);"> Surdocegueira</label>
											</div>
										</div>
							
										<!-- Transtorno Global do Desenvolvimento -->
										<div class="checkbox-title">Transtorno do Espectro Autista</div>
										<div class="row">
											<div class="col-md-6 checkbox-group">
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial11%> value="11" onClick="verificaOpcaoDeficiencia(this);"> Transtorno do Espectro Autista (TEA)</label>
											</div>
										</div>

										<!-- Altas Habilidades -->
										<div class="checkbox-title">Altas Habilidades ou Superdotação</div>
										<div class="row">
											<div class="col-md-12 checkbox-group">
												<label><input type="checkbox" class="form-check-input" name="chkDeficiencia" <%=marcouNecessidadeEspecial8%> value="8" onClick="verificaOpcaoDeficiencia(this);"> Altas Habilidades ou Superdotação</label>
											</div>
										</div>
										
									</div>
								</div>
							</div>
							
							
							<div id="card_dados_escolares" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_dados_escolares > .card-dados_escolares" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Dados Escolares&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Dados Escolares&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-dados_escolares p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										
										<div class="row">
											<div class="col-sm-3">
												<div class="form-group">
													<label class="form-label">Ano letivo *</label>
													<%if strMostraAnoLetivo = "hidden" then%><%=strAnoLetivo%><%end if%><input  name="txtAnoLetivo" type="<%=strMostraAnoLetivo%>" class="form-control" id="txtAnoLetivo"  onChange="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"> 
												</div>
											</div>	
											<div class="col-sm-3">
												<div class="form-group">
													<label class="form-label">Semestre *</label>
													<!--#include file="includes/inc_cmdSemestre.asp" -->
												</div>
											</div>	
											<%
											if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
												if intCodTurma = "" then intCodTurma ="0"
												if intCodPeriodo = "" then intCodPeriodo ="0"
												if intCodTurno = "" then intCodTurno ="0"
												if Session("MatriculaInformatizada")="SIM" then
													intCodTurmaTroca = intCodTurma
													''---------------------------------------------------''
													'' NOVA REGRA - para o process de matricula o sistema 
													'' efetivará o aluno na turna em ordem de preenchimento sequencial
													''---------------------------------------------------''
													'' BUSCA TURMA DISPONIVEL PARA A ESCOLA SELECIONADA
													''---------------------------------------------------''
													sql = "select tu.cod_turno, tu.cod_periodo"
													sql = sql & " from SCA_TURMA TU"
													sql = sql & " where TU.Cod_Empresa  = " & session("codEmpresa")
													sql = sql & " and TU.cod_turma = " & intCodTurma
													'if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then
													'	response.write sql
													'	response.end
													'end if
													rs.open sql, cnn,3,3
													if not RS.EOF then
														intCodTurno = rs("cod_turno")
														intCodPeriodo = rs("cod_periodo")
													end if
													rs.close
													
													intCodTurma = "0"

													sql = "select  top 1 tu.cod_turma, tu.NomeTurma, tu.sala"
													sql = sql & " from SCA_TURMA TU "
													sql = sql & " where TU.Cod_Empresa = " & session("codEmpresa") 
													sql = sql & " and TU.Situacao = 'A' "
													sql = sql & " and tu.AnoLetivo = " & Session("MatriculaInformatizadaAnoEfetivacao")   
													sql = sql & " and tu.Cod_Semestre = " & strSemestre 
													sql = sql & " and tu.Cod_Periodo = " & intCodPeriodo 
													sql = sql & " and TU.Cod_Turno = " & intCodTurno 
													'sql = sql & " and "
													'sql = sql & " 	case "
													'sql = sql & " 		when isnull(tu.capacidade,0) <  isnull(tu.vagasReservadas,0) then "
													'sql = sql & " 			isnull(tu.capacidade,0) - "
													'sql = sql & " 			( "
													'sql = sql & " 			select COUNT(AT1.CODIGO) "
													'sql = sql & " 			from SCA_ALUNO_TURMA AT1 "
													'sql = sql & " 			INNER JOIN SCA_ALUNO A1 ON AT1.COD_ALUNO = A1.CODIGO "
													'sql = sql & " 			inner join SCA_SITUACAOALUNO sa1 on sa1.Cod_SituacaoAluno = a1.Cod_SituacaoAluno "
													'sql = sql & " 			where AT1.Situacao = 'A' "
													'sql = sql & " 			and AT1.Ano_Letivo = " & Session("MatriculaInformatizadaAnoEfetivacao")  
													'sql = sql & " 			and AT1.Semestre = " & strSemestre 
													'sql = sql & " 			and AT1.cod_turma = tu.cod_turma "
													'sql = sql & " 			and desc_situacaoaluno = 'ATIVO' "
													'sql = sql & " 			)"
													'sql = sql & " 		else "
													'sql = sql & " 			isnull(tu.capacidade,0) -  isnull(tu.vagasReservadas,0) -"
													'sql = sql & " 			( "
													'sql = sql & " 			select COUNT(AT1.CODIGO) "
													'sql = sql & " 			from SCA_ALUNO_TURMA AT1 "
													'sql = sql & " 			INNER JOIN SCA_ALUNO A1 ON AT1.COD_ALUNO = A1.CODIGO "
													'sql = sql & " 			inner join SCA_SITUACAOALUNO sa1 on sa1.Cod_SituacaoAluno = a1.Cod_SituacaoAluno "
													'sql = sql & " 			where AT1.Situacao = 'A' "
													'sql = sql & " 			and AT1.Ano_Letivo = " & Session("MatriculaInformatizadaAnoEfetivacao")  
													'sql = sql & " 			and AT1.Semestre = " & strSemestre 
													'sql = sql & " 			and AT1.cod_turma = tu.cod_turma "
													'sql = sql & " 			and desc_situacaoaluno = 'ATIVO' "
													'sql = sql & " 			)"
													'sql = sql & " 	end"
													'sql = sql & " 	> 0"
													sql = sql & " order by tu.sala"
													
													if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then
														'response.write sql
														'response.End()
													end if

													rs.open sql, cnn,3,3
													if not RS.EOF then
														if not isnull(rs("cod_turma")) then
															intCodTurma = rs("cod_turma")
															strNomeTurma = rs("NomeTurma")
														end if
													end if
													rs.close
													if intCodTurma = "0" then
														%>
														<script>
															alert("Não foi localiza a turma do aluno, tente fazer novamente a efetivação!")
															window.location = '../gemul2015/sistema/mat/EfetivacaoAluno_con.asp';
														</script>
														<%
														response.end
													end if
												%>
											
											<div class="col-sm-6">
												<div class="form-group">
													<label class="form-label">Turma <%=Session("MatriculaInformatizadaAnoEfetivacao")%> *</label>
													<input disabled name="txtTurma" type="text" class="form-control" id="txtTurma" size="12" maxlength="15" value="<%=strNomeTurmaAluno%> - <%=strNomeTurma%>" onKeyPress="return formataCampo(this,5,14)" onBlur="return validaCPFAluno(this)">
												</div>
												
												<input readonly name="txtTurmaNome" 	type="hidden" class="textDisabled" size="20" id="txtTurmaNome" 		value="<%=strNomeTurma%>">
												<input readonly name="cmbTurma" 		type="hidden" class="textDisabled" size="20" id="cmbTurma" 			value="<%=intCodTurma%>">
												<input readonly name="cmbTurmaTroca" 	type="hidden" class="textDisabled" size="20" id="cmbTurmaTroca" 	value="<%=intCodTurmaTroca%>">

											</div>
											<%else
					
												if strCodAluno<>"" and Session("MatriculaInformatizada")<>"SIM" then
													strMsnDadosEfetivacao = ""
													sql = "SELECT isnull(efetivacao,'N') as efetivacao" 
													sql = sql & " FROM MAT_INSCRICAO"
													sql = sql & " where COD_ALUNO = " & strCodAluno
													SQL = SQL & " and excluido='N'"
													'response.write sql
													rs.open sql, cnn
													if not RS.EOF then
														if rs("efetivacao") = "N" then
															strMsnDadosEfetivacao 		= "ATENÇÃO: Aluno não foi efetivado pela MATRÍCULA, acesse a matrícula e faça a efetivação deste aluno!"
														end if
													end if
													rs.close
													
													if strMsnDadosEfetivacao <> "" then
														SQL = "DELETE MAT_OCORRENCIA_MATRICULA WHERE OCORRENCIA='Efetivação da matrícula' AND COD_ALUNO = " & strCodAluno & " AND USUARIO_INCL = '" & Session("UsuarioWeb") & "'"
														CNN.EXECUTE SQL
														%>
														<script>
															alert("<%=strMsnDadosEfetivacao%>");
															window.history.back()
														</script>
														<%
														response.end
													end if
												end if					
											
											
											%>
												<div class="col-sm-6">
													<div class="form-group">
														<label class="form-label">Turma <%=strAnoLetivo%>/<%=strSem%> *</label>
														<!--#include file="includes/inc_cmdTurmaAluno.asp" -->
													</div>
												</div>

											<%end if%>
											<%
										else
					
											if strCodAluno<>"" and Session("MatriculaInformatizada")<>"SIM" then
												strMsnDadosEfetivacao = ""
												sql = "SELECT isnull(efetivacao,'N') as efetivacao" 
												sql = sql & " FROM MAT_INSCRICAO"
												sql = sql & " where COD_ALUNO = " & strCodAluno
												'response.write sql
												rs.open sql, cnn
												if not RS.EOF then
													if rs("efetivacao") = "N" then
														strMsnDadosEfetivacao 		= "ATENÇÃO: Aluno não foi efetivado pela MATRÍCULA, acesse a matrícula e faça a efetivação deste aluno!"
													end if
												end if
												rs.close
												
												if strMsnDadosEfetivacao <> "" then
													SQL = "DELETE MAT_OCORRENCIA_MATRICULA WHERE OCORRENCIA='Efetivação da matrícula' AND COD_ALUNO = " & strCodAluno & " AND USUARIO_INCL = '" & Session("UsuarioWeb") & "'"
													CNN.EXECUTE SQL
													%>
													<script>
														alert("<%=strMsnDadosEfetivacao%>");
														window.location="../MAT/EfetivacaoAluno_con.asp";
													</script>
													<%
													response.end
												end if
											end if					
										
										
												%>
												<div class="col-sm-6">
													<div class="form-group">
														<label class="form-label">Turma <%=strAnoLetivo%>/<%=strSem%> *</label>
														<!--#include file="includes/inc_cmdTurmaAluno.asp" -->
													</div>
												</div>
										<%end if%>
										</div>							
										<br>
										<div class="row">	
											
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Forma de ingresso</label>
													<!--#include file="includes/inc_cmdFormaIngresso.asp" -->
												</div>
											</div>
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Data ingresso</label>
													<input name="txtDataingresso" type="text" class="form-control" id="txtDataingresso" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataingresso%>">
												</div>
											</div>	
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">ID Censo</label>
													<input name="ID_CENSO" type="text" class="form-control" id="ID_CENSO" size="7" maxlength="12" value="<%=ID_CENSO%>" >
												</div>
											</div>
										</div>
										<br>
										<div class="row">
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Data afastamento</label>
													<input name="txtDatafastamento" type="text" class="form-control" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>">
												</div>
											</div>
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Motivo afastamento</label>
													<!--#include file="includes/inc_cmdMotivoAfastamento.asp" -->
												</div>
											</div>
											<div class="col-sm-2">	
												<div class="form-group">
													<label class="form-label">Setransp</label>
													<input name="txtSetransp" type="text" class="form-control" id="txtSetransp" size="20" maxlength="15" value="<%=strSetransp%>">
												</div>
											</div>
											<div class="col-sm-2">	
												<div class="form-group">
													<label class="form-label">Código INEP</label>
													<input name="txtCodigoInep" type="text" class="form-control" id="txtCodigoInep" size="20" maxlength="15" value="<%=strCodigoInep%>">
												</div>
											</div>
										</div>							
										<br>
										<div class="row">
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Número do processo judicial</label>
													<input name="txtProcessoJudicial" type="text" class="form-control" id="txtProcessoJudicial" size="40" maxlength="50" value="<%=strProcessoJudicial%>">
												</div>
											</div>
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Observação do processo judicial</label>
													<textarea  onkeyup="blocTextoProcesso(this.value,'<%=contProcesso%>')"  name="txtProcessoJudicialObs" cols="55" rows="3" class="form-control" id="txtProcessoJudicialObs"><%=strProcessoJudicialObs%></textarea>
													<font color="#FF0000">(caracteres restantes: <span id="contProcesso">500</span>)</font>	
												</div>
											</div>
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Observação</label>
													<textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtObsafastamento" cols="55" rows="3" class="form-control" id="txtObsafastamento"><%=strObsafastamento%></textarea>
													<font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font>	
												</div>
											</div>
												
										</div>	
										
										
									</div>
								</div>
							</div>
							<!--#include file="includes/inc_verifica_fechamento_anual.asp"-->

							<div id="card_endereco" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_endereco > .card-dados_endereco" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Endereço&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Endereço&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-dados_endereco p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										
										<div class="row">
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">CEP</label>
													<input name="txtCepresidencia" type="text" class="form-control" id="txtCepresidencia" size="9" maxlength="9" value="<%=strCepresidencia%>" onKeyPress="mascara(this,cep)" >
												</div>
											</div>	
											<div class="col-sm-8">
												<div class="form-group">
													<label class="form-label">Logradouro</label>
													<input name="txtLogradouro" type="text" class="form-control" id="txtLogradouro" size="40" maxlength="60" value="<%=strLogradouro%>">
												</div>
											</div>	
										
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Número</label>
													<input name="txtNumero_endereco" type="text" class="form-control" id="txtNumero_endereco" size="20" maxlength="5" value="<%=strNumero_endereco%>">
												</div>
											</div>
											
										</div>							
										<br>
										<div class="row">	
											
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Complemento</label>
													<input name="txtComp_endereco" type="text" class="form-control" id="txtComp_endereco" size="50" maxlength="50" value="<%=strComp_endereco%>" >
												</div>
											</div>
											<div class="col-sm-3">	
												<div class="form-group">
													<label class="form-label">Bairro</label>
													<input name="txtBairroaluno" type="text" class="form-control" id="txtBairroaluno" size="40" maxlength="40" value="<%=strBairroaluno%>">
												</div>
											</div>
										
											<div class="col-sm-3">	
												<div class="form-group">
													<label class="form-label">Município</label>
													<input readonly name="txtCidaderesidencia" type="text" class="form-control" id="txtCidaderesidencia" size="40" maxlength="40" value="<%=strCidaderesidencia%>">
												</div>
											</div>	
										
											<div class="col-sm-2">	
												<div class="form-group">
													<label class="form-label">UF</label>
													<!--#include file="includes/inc_cmdUFResidencia.asp" -->
												</div>
											</div>
											
										</div>							
										
									</div>
								</div>
							</div>
							<div id="card_dados_familiares" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_dados_familiares > .card-dados_familiares" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Dados Familiares&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Dados Familiares&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-dados_familiares p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										
										<div class="row">
											<div class="col-sm-3">
												<div class="form-group">
													<label class="form-label">Nome do pai</label>
													<input name="txtPai" type="text" class="form-control" id="txtPai" size="40" maxlength="50" value="<%=strPai%>" onKeyPress="return formataCampo(this, 1, 50)">
												</div>
											</div>	
											<div class="col-sm-1">
												<div class="form-group">
													<label class="form-label">Falecido</label>
													<select name="txtPaifalecido" class="form-control" id="txtPaifalecido">
														<option value="N" <%if strPaifalecido = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if strPaifalecido = "S" then response.Write("selected") %>>Sim</option>
													</select>
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Data nascimento</label>
													<input name="txtPaidatanascimento" type="text" class="form-control" id="txtPaidatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strPaidatanascimento%>">
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Telefone</label>
													<input name="txtPaifone" type="text" class="form-control" id="txtPaifone"  size="20" maxlength="15" value="<%=strPaifone%>">
												</div>
											</div>
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Profissão</label>
													<!--#include file="includes/inc_cmdProfissaoPai.asp" -->
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Grau instrução</label>
													<!--#include file="includes/inc_cmdGrauInstrucaoPai.asp" -->
												</div>
											</div>												
										</div>							
										<br>
										<div class="row">
											<div class="col-sm-3">
												<div class="form-group">
													<label class="form-label">Nome da mãe *</label>
													<input name="txtMae" <%=BloqueiaCampo%> type="text" class="form-control" id="txtMae" size="40" maxlength="50" value="<%=strMae%>" onKeyPress="return formataCampo(this, 1, 50)">
												</div>
											</div>	
											<div class="col-sm-1">
												<div class="form-group">
													<label class="form-label">Falecida</label>
													<select name="txtMaefalecida" class="form-control" id="txtMaefalecida">
														<option value="N" <%if strMaefalecida = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if strMaefalecida = "S" then response.Write("selected") %>>Sim</option>
													</select>
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Data nascimento</label>
													<input name="txtMaedatanascimento" type="text" class="form-control" id="txtMaedatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strMaedatanascimento%>">
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Telefone</label>
													<input name="txtMaefone" type="text" class="form-control" id="txtMaefone"  size="20" maxlength="15" value="<%=strMaefone%>">
												</div>
											</div>
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Profissão</label>
													<!--#include file="includes/inc_cmdProfissaoMae.asp" -->
												</div>
											</div>	
											<div class="col-sm-2">
												<div class="form-group">
													<label class="form-label">Grau instrução</label>
													<!--#include file="includes/inc_cmdGrauInstrucaoMae.asp" -->
												</div>
											</div>												
										</div>							
																
										<br>
										<div class="row">	
											
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Quantidade de irmãos</label>
													<!--#include file="includes/inc_cmdQtdeIrmao.asp" -->
												</div>
											</div>
											<div class="col-sm-4">	
												<div class="form-group">
													<label class="form-label">Na mesma escola</label>
													<!--#include file="includes/inc_cmdQtdeIrmaoEscola.asp" -->
												</div>
											</div>
											
										</div>							
										
									</div>
								</div>
							</div>
							<div id="card_dados_responsavel" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_dados_responsavel > .card-dados_responsavel" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Dados do Responsável&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Dados do Responsável&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-dados_responsavel p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										<div class="row">
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Responsável é</label>
													<select name="RESPONSAVEL_QUEM" class="form-control" id="RESPONSAVEL_QUEM" onChange="verificaOutroResponsavel()">
														<option value="0" >Selecione...</option>
														<option value="PAI" <%if RESPONSAVEL_QUEM = "PAI" then response.Write("selected") %>>Pai</option>
														<option value="MAE" <%if RESPONSAVEL_QUEM = "MAE" then response.Write("selected") %>>Mãe</option>
														<option value="OUTRO" <%if RESPONSAVEL_QUEM = "OUTRO" then response.Write("selected") %>>Outro</option>
													</select>
												</div>
											</div>	
											<%
											if RESPONSAVEL_QUEM <> "OUTRO" then display_outro_responsavel = "style='display:none'"
											%>
											<div id="coluna_outro_resposavel" <%=display_outro_responsavel%> class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Grau de parentesco</label>
													<input name="RESPONSAVEL_GRAU_PARESTESCO" type="text" class="form-control" id="RESPONSAVEL_GRAU_PARESTESCO" size="50" maxlength="50" value="<%=RESPONSAVEL_GRAU_PARESTESCO%>" >
												</div>
											</div>
										</div>	
										
										<div class="row">
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Nome do responsável</label>
													<input name="txtResponsavel" type="text" class="form-control" id="txtResponsavel" size="50" maxlength="50" value="<%=strResponsavel%>" onKeyPress="return formataCampo(this, 1, 50)">
												</div>
											</div>	
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">CPF</label>
													<input name="txtCPFResponsavel" type="text" class="form-control" id="txtCPFResponsavel" size="20" maxlength="14" value="<%=strCPFResponsavel%>" onKeyPress="return formataCampo(this, 5, 14)" onBlur="return validaCPF(this)" >
												</div>
											</div>	
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Data nascimento</label>
													<input name="txtResponsaveldatanascimento" type="text" class="form-control" id="txtResponsaveldatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strResponsaveldatanascimento%>">
												</div>
											</div>	
										</div>							
										<div class="row">
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Telefone</label>
													<input name="txtResponsavelfone" type="text" class="form-control" id="txtResponsavelfone" onKeyPress="mascara(this,telefone)"  size="20" maxlength="15" value="<%=strResponsavelfone%>">
												</div>
											</div>
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Profissão</label>
													<!--#include file="includes/inc_cmdProfissaoResponsavel.asp" -->
												</div>
											</div>	
											<div class="col-sm-4">
												<div class="form-group">
													<label class="form-label">Grau instrução</label>
													<!--#include file="includes/inc_cmdGrauInstrucaoResponsavel.asp" -->
												</div>
											</div>												
										</div>							
									</div>
								</div>
							</div>
							
							<div id="card_informacoes_adicionais" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#card_informacoes_adicionais > .card-informacoes_adicionais" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Informações adicionais&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Informações adicionais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div class="card-informacoes_adicionais p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label class="form-label">Faz uso de medicamento controlado?</label>
													<select name="MEDICAMENTO_CONTROLADO" class="form-control" id="MEDICAMENTO_CONTROLADO" onChange="verificaMedicamento()">
														<option value="N" <%if MEDICAMENTO_CONTROLADO = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if MEDICAMENTO_CONTROLADO = "S" then response.Write("selected") %>>Sim</option>
													</select>
												</div>
											</div>
											<%
											if MEDICAMENTO_CONTROLADO = "N" or MEDICAMENTO_CONTROLADO="" or isnull(MEDICAMENTO_CONTROLADO) then display_mendicamento = "style='display:none'"
											%>											
											<div class="col-sm-6" <%=display_mendicamento%> id="coluna_medicamento">
												<div class="form-group">
													<label class="form-label">Qual?</label>
													<input name="MEDICAMENTO_CONTROLADO_QUAL" type="text" class="form-control" id="MEDICAMENTO_CONTROLADO_QUAL" size="50" maxlength="50" value="<%=MEDICAMENTO_CONTROLADO_QUAL%>" >
												</div>
											</div>	
										</div>							
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label class="form-label">Utiliza transporte escolar municipal?</label>
													<select name="TRANSPORTE_ESCOLAR" class="form-control" id="TRANSPORTE_ESCOLAR">
														<option value="N" <%if TRANSPORTE_ESCOLAR = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if TRANSPORTE_ESCOLAR = "S" then response.Write("selected") %>>Sim</option>
													</select>
												</div>
											</div>
										</div>							
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label class="form-label">Autoriza o uso da imagem do filho(a) em eventos da SEMEC/ESCOLA?</label>
													<select name="AUTORIZA_USO_IMAGEM" class="form-control" id="AUTORIZA_USO_IMAGEM">
														<option value="N" <%if AUTORIZA_USO_IMAGEM = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if AUTORIZA_USO_IMAGEM = "S" then response.Write("selected") %>>Sim</option>
													</select>
												</div>
											</div>
										</div>							
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label class="form-label">Possui restrição alimentar?</label>
													<select name="RESTRICAO_ALIMENTAR" class="form-control" id="RESTRICAO_ALIMENTAR" onChange="verificaRestricao()">
														<option value="N" <%if RESTRICAO_ALIMENTAR = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if RESTRICAO_ALIMENTAR = "S" then response.Write("selected") %>>Sim</option>
													</select>
												</div>
											</div>
											<%
											if RESTRICAO_ALIMENTAR = "N" or RESTRICAO_ALIMENTAR="" or isnull(RESTRICAO_ALIMENTAR) then display_alimento = "style='display:none'"
											%>											
											<div class="col-sm-6" <%=display_alimento%> id="coluna_alimento">
												<div class="form-group">
													<label class="form-label">Qual?</label>
													<input name="RESTRICAO_ALIMENTAR_QUAL" type="text" class="form-control" id="RESTRICAO_ALIMENTAR_QUAL" size="50" maxlength="50" value="<%=RESTRICAO_ALIMENTAR_QUAL%>" >
												</div>
											</div>	
										</div>
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label class="form-label">Possui alergia?</label>
													
													<select name="ALERGIA" class="form-control" id="ALERGIA" onChange="verificaAlergia()">
														<option value="N" <%if ALERGIA = "N" then response.Write("selected") %>>N&atilde;o</option>
														<option value="S" <%if ALERGIA = "S" then response.Write("selected") %>>Sim</option>
													</select>
													
												</div>
											</div>
											<%
											if ALERGIA = "N" or ALERGIA="" or isnull(ALERGIA) then display_alergia = "style='display:none'"
											%>											
											<div class="col-sm-6" <%=display_alergia%> id="coluna_alergia">
												<div class="form-group">
													<label class="form-label">Qual?</label>
													<input name="ALERGIA_QUAL" type="text" class="form-control" id="ALERGIA_QUAL" size="50" maxlength="50" value="<%=ALERGIA_QUAL%>" >
												</div>
											</div>	
										</div>
										
										<div class="row">
											<div class="col-sm-3">
												<div class="form-group">
													<label class="form-label">Tamanho do Uniforme</label>
													<!--#include file="includes/inc_cmbTamanhoRoupa.asp" -->
												</div>
											</div>
																					
											<div class="col-sm-3">
												<div class="form-group">
													<label class="form-label">Número do Calçado</label>
													<!--#include file="includes/inc_cmbTamanhoCalcado.asp" -->
												</div>
											</div>	
										</div>
										
										
										
										
									</div>
								</div>
							</div>
							<% if strCodAluno<>"" then %>
							<div id="card_laudo_medico" class="card border">
								<div class="card-header" style="cursor: pointer;" data-toggle="collapse" data-target="#collapse_laudo_medico" onclick="carregaLaudoCardClick()" aria-expanded="false">
										<span class="collapsed-hidden"><strong>Laudo Médico&nbsp;&nbsp;<em class="fal fa-angle-up"></em></strong></span>
										<span class="collapsed-reveal"><strong>Laudo Médico&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></span>
								</div>
								<div id="collapse_laudo_medico" class="card-laudo_medico p-0 collapse" style="">
									<!-- notice we place the padding inside another div and remove the padding from the card body -->
									<div class="p-4">
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<button  class="btn btn-primary" onclick="abrirModal(event)">Anexar Arquivo</button>
												</div>
											</div>
											
										</div>
										<div class="row">
											<div class="col-sm-12">
											  <table class="table table-bordered table-hover" id="tabela_arquivos">
												<thead class="table-light">
												  <tr>
													<th>Descrição</th>
													<th>Nome do Arquivo</th>
													<th style="width: 120px;">Visualizar</th>
													<th style="width: 120px;">Download</th>
													<th style="width: 120px;">Excluir</th>
												  </tr>
												</thead>
												<tbody id="lista_arquivo_laudo">
												  <!-- Arquivos do aluno serão listados aqui -->
												</tbody>
											  </table>
											</div>
										</div>											
									</div>
								</div>
							</div>
							<% end if %>
							<br>
							
							<div class="frame-wrap">
							<% 
							if strCodAluno <> "" and strCodAluno <> "0" then %>
							<button class="btn btn-primary" type="button" id="button-addon5" onClick="return AlunoDocumentacoes('<%=strCodAluno%>')" >** Atualizar Documentações Pendentes **</button>
							<% end if 
							
							
							if strCodAluno <> "" and strCodAluno <> "0" and trim(intCodEmpresaUltima) = trim(session("codEmpresa")) then 
							%>
							<!--button class="btn btn-success" type="button" id="button-addon5" onclick="return renovar()" >** Renovação de Matrícula **</button-->
						  <%end if%>	
		  
							</div>
		  
		  
							<div class="frame-wrap">
								<!--#include file="includes/inc_botoes_cadastro.asp"-->
							</div>
							
							<input name="txtCodTurmaAtual" type="hidden" value="<%=ZeroLeft(intCodTurma,8)%>_<%=ZeroLeft(intCod_GradeCurricular,8)%>">
							<input name="txtCodTurmaRenovacao" type="hidden" value="<%=intCodTurma%>">
							<input name="txtAnoLetivoAnterior" type="hidden" value="<%=strAnoLetivoAnterior%>">
							<input name="txtSitNecesEspecialAtual" type="hidden" value="<%=SITUACAO_NECESSIDADE_ESPECIAL%>">
							<input name="txtCodNecesEspecialAtual" type="hidden" value="<%=intCodNecessidadeEspecial%>">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	
<div class="modal fade" id="modalEditorFoto" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">		

		<div class="modal-dialog modal-md modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Foto do(a) aluno(a)</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true"><i class="fal fa-times"></i></span>
					</button>
				</div>
				<div class="modal-body">
				
					<div class="fotoAlunoSIGE-wrap upload-fotoAlunoSIGE">
						<div>
							<div>
								<div>
									<div class="actions" id="divLocalImagem">
										<p>Selecione uma imagem:</p>
										<a class="btn file-btn localImagem" id="btnImagemDoComputador">
											<span>do Computador</span>
											<input type="file" id="upload" value="Choose a file" accept="image/x-png,image/jpeg" />
										</a>
										<a class="btn localImagem" href="#" onclick="attachWebCam()" id="btnImagemDaWebCam">da WebCam</a>
									</div>   
			
									<!--div class="upload-msg">
										Foto do Aluno
									</!--div-->
			
									
									<div id="my_camera" class="upload-fotoAlunoSIGE-wrap" style="padding-top:15px"></div>
									<div class="upload-fotoAlunoSIGE-wrap">
										<div id="upload-fotoAlunoSIGE"></div>
										<input type="hidden" id="fileFromWebCam" value="" />
									</div>
			
									<div class="actions" style="padding-top:50px">
										<a class="btn" id="btnCaptutarImagem" onclick="take_snapshot()" href="#">Capturar da WebCam</a>
										<a class="btn upload-result" id="btnRecortarImagem" href="#close-modal" rel="modal:close">Recortar</a>
										<a class="btn" id="btnCancelarImagem">Cancelar</a>
									</div>                            
								</div>
							</div>
						</div>
					</div>
					
				</div>	
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
				</div>
			</div>
		</div>

	</div>	
	
	<% if strCodAluno<>"" then %>
	<!-- Modal -->
	<div class="modal fade" id="modalUpload" tabindex="-1" aria-labelledby="modalUploadLabel" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered modal-md"><!-- modal-sm, modal-md, modal-lg -->
		<div class="modal-content">
		  <div class="modal-header bg-primary text-white">
			<h5 class="modal-title" id="modalUploadLabel">Anexar Arquivo</h5>
			<button type="button" class="close" onclick="fecharModal()"  aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
		  </div>

		  <div class="modal-body">
			<div class="mb-3">
			  <label for="tipoArquivo" class="form-label">Tipo de Arquivo</label>
			  <select id="tipoArquivo" class="form-select">
				<option value="PDF">PDF do Laudo Médico</option>
			  </select>
			</div>

			<div class="mb-3">
			  <label for="descricao" class="form-label">Descrição</label>
			  <input type="text" id="descricao" class="form-control" placeholder="Descreva o arquivo">
			</div>

			<div class="mb-3">
			  <label for="arquivo" class="form-label">Selecione o Arquivo</label>
			  <input type="file" id="arquivo" class="form-control">
			</div>
		  </div>

		  <div class="modal-footer">
			<button type="button" class="btn btn-success" id="enviarArquivo" onclick="enviarArquivo()">Enviar</button>
			<button type="button" class="btn btn-secondary" onclick="fecharModal()">Cancelar</button>
		  </div>
		</div>
	  </div>
	</div>
	<!-- Modal para visualizar arquivo -->
	<!-- Modal para visualizar arquivo -->
	<div class="modal fade" id="visualizarArquivoModal" tabindex="-1" aria-labelledby="visualizarArquivoLabel" aria-hidden="true">
	  <div class="modal-dialog modal-lg">
		<div class="modal-content">
		  <div class="modal-header">
			<h5 class="modal-title" id="visualizarArquivoLabel">Visualizar Arquivo</h5>
		  </div>
		  <div class="modal-body" id="previewArquivo"></div>
		</div>
	  </div>
	</div>

	<% end if %>
	
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>

    <!----------webcam----------->
    <script type="text/javascript" src="../assets/webcam/webcam.min.js"></script>
    <!------------------------->

    <!----------image croppie-->
    <script src="../assets/croppie/bower_components/sweetalert/dist/sweetalert.min.js"></script>
    <script src="../assets/croppie/croppie.js"></script>
    <script src="../assets/croppie/foto-aluno/foto-aluno.js?v=3"></script>
    <script src="../assets/croppie/bower_components/exif-js/exif.js"></script>
    <!-------------------->

<script>
	//esta função está no arquivo '../assets/croppie/foto-aluno/foto-aluno.js'
	FotoAlunoSIGE.init();
	
</script>
<% if strCodAluno<>"" then %>
<!-- modal do anexar arquivo -->
<script>

function carregaLaudoCardClick() {
	mostrarLoading();
    carregarArquivosAluno('<%=strCodAluno%>');
}


function mostrarLoading() {
  const tbody = document.getElementById("lista_arquivo_laudo");
  tbody.innerHTML = `
    <tr>
      <td colspan="5" class="text-center">
        <span class="spinner-border spinner-border-sm"></span>
        Carregando arquivos...
      </td>
    </tr>
  `;
}

function abrirModal(e) {
  if (e) e.preventDefault(); // impede o submit
  $("#modalUpload").modal('show');
}

function fecharModal() {
	$("#modalUpload").modal('hide');
}

function enviarArquivo() {
  const fileInput = document.getElementById("arquivo");
  const file = fileInput.files[0];
  const tipo = document.getElementById("tipoArquivo").value;
  const descricao = document.getElementById("descricao").value;
  const cod_aluno = document.getElementById("txtCodAluno").value;

  if (!file) {
    alert("Selecione um arquivo!");
    return;
  }
  
	const botao = document.getElementById("enviarArquivo");
    botao.innerText = "Enviando...";
    
    // opcional: desativar o botão para evitar clique duplo
    botao.disabled = true;
  
  const reader = new FileReader();
  reader.onload = function(e) {
    const base64Data = e.target.result.split(',')[1]; // tira o prefixo data:...

    // Enviar via fetch (AJAX)
    fetch("sca_aluno_arquivo_cod.asp", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "tipo=" + encodeURIComponent(tipo) +
            "&descricao=" + encodeURIComponent(descricao) +
			"&cod_aluno=" + encodeURIComponent(cod_aluno) +
            "&arquivoBase64=" + encodeURIComponent(base64Data) +
            "&nomeArquivo=" + encodeURIComponent(file.name)
    })
    .then(r => r.text())
    .then(resp => {
      console.log(resp);
      fecharModal();
	  carregarArquivosAluno(cod_aluno);
    })
    .catch(err => alert("Erro: " + err));
  };
  reader.readAsDataURL(file);
}

// ======================
// Carrega a lista de arquivos do aluno
// ======================
function carregarArquivosAluno(cod_aluno) {

  mostrarLoading(); // 👈 aqui

  fetch("sca_aluno_arquivo_lista.asp?cod_aluno=" + cod_aluno)
    .then(r => r.json())
    .then(data => {
      const tbody = document.getElementById("lista_arquivo_laudo");
      tbody.innerHTML = "";

      if (!data || data.length === 0) {
        tbody.innerHTML = "<tr><td colspan='5' class='text-center text-muted'>Nenhum arquivo enviado.</td></tr>";
        return;
      }

      data.forEach(file => {
        const tr = document.createElement("tr");

        const tdDescricao = document.createElement("td");
        tdDescricao.innerText = file.descricao || "";
        tr.appendChild(tdDescricao);

        const tdNome = document.createElement("td");
        tdNome.innerText = file.nomeArquivo;
        tr.appendChild(tdNome);

        const tdView = document.createElement("td");
        const btnView = document.createElement("button");
        btnView.className = "btn btn-sm btn-info";
        btnView.innerHTML = '<i class="fal fa-search fa-fw fa-lg"></i>';
        btnView.onclick = (event) => visualizarArquivo(file, event);
        tdView.appendChild(btnView);
        tr.appendChild(tdView);

        const tdDownload = document.createElement("td");
        const aDownload = document.createElement("a");
        aDownload.className = "btn btn-sm btn-success";
        aDownload.innerHTML = '<i class="fal fa-file fa-fw fa-lg"></i>';
        aDownload.href = file.base64;
        aDownload.download = file.nomeArquivo;
        tdDownload.appendChild(aDownload);
        tr.appendChild(tdDownload);

        const tdExcluir = document.createElement("td");
        const btnExcluir = document.createElement("button");
        btnExcluir.className = "btn btn-sm btn-danger";
        btnExcluir.innerHTML = '<i class="fal fa-times fa-fw fa-lg"></i>';
        btnExcluir.onclick = (event) => excluirArquivo(file, event);
        tdExcluir.appendChild(btnExcluir);
        tr.appendChild(tdExcluir);

        tbody.appendChild(tr);
      });
    })
    .catch(err => {
      console.error("Erro ao carregar arquivos:", err);
      const tbody = document.getElementById("lista_arquivo_laudo");
      tbody.innerHTML = "<tr><td colspan='5' class='text-center text-danger'>Erro ao carregar arquivos.</td></tr>";
    });
}


// ======================
// Exclui um arquivo
// ======================
function excluirArquivo(file, e) {
  if (e) e.preventDefault();

  if (!file.idArquivo) {
    alert("ID do arquivo não encontrado!");
    console.error("Arquivo inválido:", file);
    return;
  }

  if (!confirm("Deseja realmente excluir o arquivo '" + file.nomeArquivo + "'?")) return;

  fetch("sca_aluno_arquivo_excluir.asp", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: "id_arquivo=" + encodeURIComponent(file.idArquivo)
  })
  .then(r => r.text())
  .then(resp => {
    console.log("Resposta da exclusão:", resp);

    if (resp.trim().toUpperCase() === "OK") {
      alert("Arquivo excluído com sucesso!");
      carregarArquivosAluno(file.codAluno);
    } else {
      alert("Erro ao excluir: " + resp);
    }
  })
  .catch(err => {
    console.error("Erro ao excluir arquivo:", err);
    alert("Erro ao excluir arquivo.");
  });
}




function visualizarArquivo(file, e) {
  if (e) e.preventDefault();
  const tipo = file.base64.split(";")[0].replace("data:", "");
  const preview = document.getElementById("previewArquivo");
  preview.innerHTML = "";

  if (tipo.startsWith("image/")) {
    const img = document.createElement("img");
    img.src = file.base64;
    img.className = "img-fluid";
    preview.appendChild(img);
  } else if (tipo === "application/pdf") {
    const iframe = document.createElement("iframe");
    iframe.src = file.base64;
    iframe.width = "100%";
    iframe.height = "600px";
    preview.appendChild(iframe);
  } else {
    preview.innerHTML = "<p>Visualização não disponível. Faça o download do arquivo.</p>";
  }

  const modal = new bootstrap.Modal(document.getElementById("visualizarArquivoModal"));
  modal.show();
}

</script>
<% end if %>