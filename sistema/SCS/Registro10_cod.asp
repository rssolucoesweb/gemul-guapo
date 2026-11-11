<!--
	::	Data de Criação...: 01/07/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Cadastro de Escola Sendo 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 											= Trim(Request.QueryString("acao"))
	intCodEmpresa									= Trim(Request.Form("txtCodEmpresa"))
	strTipoRegistro									= Trim(Request.Form("txtTipoRegistro"))
	intCodInep	 									= Trim(Request.Form("txtCodInep"))
	strNumeroCPFGestorEscola						= Trim(Request.Form("txtNumeroCPFGestorEscola"))
	strNomeGestorEscola 							= Trim(Request.Form("txtNomeGestorEscola"))
	strCargoGestorEscola							= Trim(Request.Form("txtCargoGestorEscola"))
	strEmailGestorEscolar							= Trim(Request.Form("txtEmailGestorEscolar"))

	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strLocalFuncionamentoEscolaPredioEscolar			= Trim(Request.Form("txtLocalFuncionamentoEscolaPredioEscolar"))
	strLocalFuncionamentoEscolaTemploIgreja				= Trim(Request.Form("txtLocalFuncionamentoEscolaTemploIgreja"))
	strLocalFuncionamentoEscolaSalaEmpresa				= Trim(Request.Form("txtLocalFuncionamentoEscolaSalaEmpresa"))
	strLocalFuncionamentoEscolaCasaProfessor			= Trim(Request.Form("txtLocalFuncionamentoEscolaCasaProfessor"))
	strLocalFuncionamentoEscolaSalasOutraEscola			= Trim(Request.Form("txtLocalFuncionamentoEscolaSalasOutraEscola"))
	strLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao	= Trim(Request.Form("txtLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao"))
	strLocalFuncionamentoEscolaSocioeducativo			= Trim(Request.Form("txtLocalFuncionamentoEscolaSocioeducativo"))
	strLocalFuncionamentoEscolaUnidadePrisional			= Trim(Request.Form("txtLocalFuncionamentoEscolaUnidadePrisional"))
	strLocalFuncionamentoEscolaOutros					= Trim(Request.Form("txtLocalFuncionamentoEscolaOutros"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strFormaOcupacaoPredio								= Trim(Request.Form("cmbFormaOcupacaoPredio"))
	strPredioCompartiladoComOutraEscola					= Trim(Request.Form("cmbPredioCompartiladoComOutraEscola"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strCodEscolaCompartilha1							= Trim(Request.Form("txtCodEscolaCompartilha1"))
	strCodEscolaCompartilha2							= Trim(Request.Form("txtCodEscolaCompartilha2"))
	strCodEscolaCompartilha3							= Trim(Request.Form("txtCodEscolaCompartilha3"))
	strCodEscolaCompartilha4							= Trim(Request.Form("txtCodEscolaCompartilha4"))
	strCodEscolaCompartilha5							= Trim(Request.Form("txtCodEscolaCompartilha5"))
	strCodEscolaCompartilha6							= Trim(Request.Form("txtCodEscolaCompartilha6"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strAguaConsumidaPelosAlunos							= Trim(Request.Form("cmbAguaConsumidaPelosAlunos"))
	strAbastecimentoAgua								= Trim(Request.Form("cmbAbastecimentoAgua"))
	strAbastecimentoAguaRedePublica						= Trim(Request.Form("cmbAbastecimentoAguaRedePublica"))
	strAbastecimentoAguaPocoArtesiano					= Trim(Request.Form("cmbAbastecimentoAguaPocoArtesiano"))
	strAbastecimentoAguaCacimbaCusternaPoco				= Trim(Request.Form("cmbAbastecimentoAguaCacimbaCusternaPoco"))
	strAbastecimentoAguaFonteRioIgarapeCorrego			= Trim(Request.Form("cmbAbastecimentoAguaFonteRioIgarapeCorrego"))
	strAbastecimentoAguaInexistente						= Trim(Request.Form("cmbAbastecimentoAguaInexistente"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strAbastecimentoEnergiaRedePublica					= Trim(Request.Form("cmbAbastecimentoEnergiaRedePublica"))
	strAbastecimentoEnergiaGerador						= Trim(Request.Form("cmbAbastecimentoEnergiaGerador"))
	strAbastecimentoEnergiaAlternativa					= Trim(Request.Form("cmbAbastecimentoEnergiaAlternativa"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strEsgotoSanitario										= Trim(Request.Form("cmbEsgotoSanitario"))
	strEsgotoSanitarioRedePublica							= Trim(Request.Form("cmbEsgotoSanitarioRedePublica"))
	strEsgotoSanitarioFossa									= Trim(Request.Form("cmbEsgotoSanitarioFossa"))
	strEsgotoSanitarioInexistente							= Trim(Request.Form("cmbEsgotoSanitarioInexistente"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strDestinacaoLixo										= Trim(Request.Form("cmbDestinacaoLixo"))
	strDestinacaoLixoColetaPeriodica						= Trim(Request.Form("cmbDestinacaoLixoColetaPeriodica"))
	strDestinacaoLixoQueima									= Trim(Request.Form("cmbDestinacaoLixoQueima"))
	strDestinacaoLixoJogaOutraArea							= Trim(Request.Form("cmbDestinacaoLixoJogaOutraArea"))
	strDestinacaoLixoRecicla								= Trim(Request.Form("cmbDestinacaoLixoRecicla"))
	strDestinacaoLixoEnterra								= Trim(Request.Form("cmbDestinacaoLixoEnterra"))
	strDestinacaoLixoOutros									= Trim(Request.Form("cmbDestinacaoLixoOutros"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strDependenciaExistentesEscola							= Trim(Request.Form("cmbDependenciaExistentesEscola"))
	strDependenciaExistentesEscolaSalaDiretoria				= Trim(Request.Form("cmbDependenciaExistentesEscolaSalaDiretoria"))
	strDependenciaExistentesEscolaSalaProfessores 			= Trim(Request.Form("cmbDependenciaExistentesEscolaSalaProfessores"))
	strDependenciaExistentesEscolaSalaSecrestaria			= Trim(Request.Form("cmbDependenciaExistentesEscolaSalaSecrestaria"))
	strDependenciaExistentesEscolaLaboratorioInformatica 	= Trim(Request.Form("cmbDependenciaExistentesEscolaLaboratorioInformatica"))
	strDependenciaExistentesEscolaLaboratorioCiencia	 	= Trim(Request.Form("cmbDependenciaExistentesEscolaLaboratorioCiencia"))
	strDependenciaExistentesEscolaSalaAEE	 				= Trim(Request.Form("cmbDependenciaExistentesEscolaSalaAEE"))
	strDependenciaExistentesEscolaQuadroEsporteCoberta		= Trim(Request.Form("cmbDependenciaExistentesEscolaQuadroEsporteCoberta"))
	strDependenciaExistentesEscolaQuadroEsporteDescoberta	= Trim(Request.Form("cmbDependenciaExistentesEscolaQuadroEsporteDescoberta"))
	strDependenciaExistentesEscolaCozinha	 				= Trim(Request.Form("cmbDependenciaExistentesEscolaCozinha"))
	strDependenciaExistentesEscolaBoblioteca	 			= Trim(Request.Form("cmbDependenciaExistentesEscolaBoblioteca"))
	strDependenciaExistentesEscolaSalaLeitura	 			= Trim(Request.Form("cmbDependenciaExistentesEscolaSalaLeitura"))
	strDependenciaExistentesEscolaParqueInfantil	 		= Trim(Request.Form("cmbDependenciaExistentesEscolaParqueInfantil"))
	strDependenciaExistentesEscolaBercario	 				= Trim(Request.Form("cmbDependenciaExistentesEscolaBercario"))
	strDependenciaExistentesEscolaBanheiroForaPredio	 	= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroForaPredio"))
	strDependenciaExistentesEscolaBanheiroDentroPredio	 	= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroDentroPredio"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------	
	strDependenciaExistentesEscolaBanheiroAdequadoinfantil	 							= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroAdequadoinfantil"))
	strDependenciaExistentesEscolaBanheiroMobilidadeReduzida	 						= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroMobilidadeReduzida"))
	strDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida	 	= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida"))
	strDependenciaExistentesEscolaBanheiroComChuveiro	 								= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroComChuveiro"))
	strDependenciaExistentesEscolaRefeitorio	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaRefeitorio"))
	strDependenciaExistentesEscolaDespensa	 											= Trim(Request.Form("cmbDependenciaExistentesEscolaDespensa"))
	strDependenciaExistentesEscolaAlmoxarifado	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaAlmoxarifado"))
	strDependenciaExistentesEscolaAuditorio	 											= Trim(Request.Form("cmbDependenciaExistentesEscolaAuditorio"))	
	strDependenciaExistentesEscolaPatioCoberto	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaPatioCoberto"))
	strDependenciaExistentesEscolaPatioDescoberto	 									= Trim(Request.Form("cmbDependenciaExistentesEscolaPatioDescoberto"))
	strDependenciaExistentesEscolaAlojamentoAluno	 									= Trim(Request.Form("cmbDependenciaExistentesEscolaAlojamentoAluno"))
	strDependenciaExistentesEscolaAlojamentoProfessor	 								= Trim(Request.Form("cmbDependenciaExistentesEscolaAlojamentoProfessor"))
	strDependenciaExistentesEscolaAreaVerde	 											= Trim(Request.Form("cmbDependenciaExistentesEscolaAreaVerde"))
	strDependenciaExistentesEscolaLavanderia	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaLavanderia"))
	strDependenciaExistentesEscolaNenhumaRelacionadas	 								= Trim(Request.Form("cmbDependenciaExistentesEscolaNenhumaRelacionadas"))
	strNumeroSalasAulaExistenteEscola	 												= Trim(Request.Form("txtNumeroSalasAulaExistenteEscola"))
	strNumeroSalasAulaDentroEForaPredio	 												= Trim(Request.Form("txtNumeroSalasAulaDentroEForaPredio"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------	
	strDependenciaExistentesEscolaBanheiroAdequadoinfantil	 							= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroAdequadoinfantil"))
	strDependenciaExistentesEscolaBanheiroMobilidadeReduzida	 						= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroMobilidadeReduzida"))
	strDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida	 	= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida"))
	strDependenciaExistentesEscolaBanheiroComChuveiro	 								= Trim(Request.Form("cmbDependenciaExistentesEscolaBanheiroComChuveiro"))
	strDependenciaExistentesEscolaRefeitorio	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaRefeitorio"))
	strDependenciaExistentesEscolaDespensa	 											= Trim(Request.Form("cmbDependenciaExistentesEscolaDespensa"))
	strDependenciaExistentesEscolaAlmoxarifado	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaAlmoxarifado"))
	strDependenciaExistentesEscolaPatioCoberto	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaPatioCoberto"))
	strDependenciaExistentesEscolaPatioDescoberto	 									= Trim(Request.Form("cmbDependenciaExistentesEscolaPatioDescoberto"))
	strDependenciaExistentesEscolaAlojamentoAluno	 									= Trim(Request.Form("cmbDependenciaExistentesEscolaAlojamentoAluno"))
	strDependenciaExistentesEscolaAlojamentoProfessor	 								= Trim(Request.Form("cmbDependenciaExistentesEscolaAlojamentoProfessor"))
	strDependenciaExistentesEscolaAreaVerde	 											= Trim(Request.Form("cmbDependenciaExistentesEscolaAreaVerde"))
	strDependenciaExistentesEscolaLavanderia	 										= Trim(Request.Form("cmbDependenciaExistentesEscolaLavanderia"))
	strDependenciaExistentesEscolaNenhumaRelacionadas	 								= Trim(Request.Form("cmbDependenciaExistentesEscolaNenhumaRelacionadas"))
	strNumeroSalasAulaExistenteEscola	 												= Trim(Request.Form("txtNumeroSalasAulaExistenteEscola"))
	strNumeroSalasAulaDentroEForaPredio	 												= Trim(Request.Form("txtNumeroSalasAulaDentroEForaPredio"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	strEquipamentosAparelhoTelevisao													= Trim(Request.Form("cmbEquipamentosAparelhoTelevisao"))
	strEquipamentosVideocassete															= Trim(Request.Form("cmbEquipamentosVideocassete"))
	strEquipamentosAparelhoDVD															= Trim(Request.Form("cmbEquipamentosAparelhoDVD"))
	strEquipamentosAtenaParabolica														= Trim(Request.Form("cmbEquipamentosAtenaParabolica"))
	strEquipamentosCopiadora															= Trim(Request.Form("cmbEquipamentosCopiadora"))
	strEquipamentosRetroprojetor														= Trim(Request.Form("cmbEquipamentosRetroprojetor"))
	strEquipamentosImpresssora															= Trim(Request.Form("cmbEquipamentosImpresssora"))
	strEquipamentosAparelhoSom															= Trim(Request.Form("cmbEquipamentosAparelhoSom"))
	strEquipamentosDataShow																= Trim(Request.Form("cmbEquipamentosDataShow"))
	strEquipamentosFax																	= Trim(Request.Form("cmbEquipamentosFax"))
	strEquipamentosFilmadora															= Trim(Request.Form("cmbEquipamentosFilmadora"))
	strEquipamentosComputadores															= Trim(Request.Form("cmbEquipamentosComputadores"))
	strQuantidadeComputadoresAdministrativo												= Trim(Request.Form("txtQuantidadeComputadoresAdministrativo"))
	strQuantidadeComputadoresAlunos														= Trim(Request.Form("txtQuantidadeComputadoresAlunos"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strTotalFuncionarioEscola															= Trim(Request.Form("txtTotalFuncionarioEscola"))
	strAlimentacaoEscolaPNAE															= Trim(Request.Form("cmbAlimentacaoEscolaPNAE"))
	strAlimentacaoEscolaAlunos															= Trim(Request.Form("cmbAlimentacaoEscolaAlunos"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strAlimentacaoEducacionalAEE														= Trim(Request.Form("cmbAlimentacaoEducacionalAEE"))
	strAtividadeComplementar															= Trim(Request.Form("cmbAtividadeComplementar"))
	strModalidadeEnsinoRegular															= Trim(Request.Form("cmbModalidadeEnsinoRegular"))
	strModalidadeEducacional															= Trim(Request.Form("cmbModalidadeEducacional"))
	strEspecialModalidadeSubstitutiva													= Trim(Request.Form("cmbEspecialModalidadeSubstitutiva"))
	strModalidadeEducacionalJovensAdultos 												= Trim(Request.Form("cmbModalidadeEducacionalJovensAdultos"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strEtapas0a3Anos 												= Trim(Request.Form("cmbEtapas0a3Anos"))
	strEtapas4a5Anos 												= Trim(Request.Form("cmbEtapas4a5Anos"))
	strEtapas8Anos 													= Trim(Request.Form("cmbEtapas8Anos"))
	strEtapas9Anos 													= Trim(Request.Form("cmbEtapas9Anos"))
	strEtapasMedio 													= Trim(Request.Form("cmbEtapasMedio"))
	strEtapasMedioIntegrado 										= Trim(Request.Form("cmbEtapasMedioIntegrado"))
	strEtapasNormalMagisterio 										= Trim(Request.Form("cmbEtapasNormalMagisterio"))
	strEtapasEnsinoRegularEducacaoProfissional 						= Trim(Request.Form("cmbEtapasEnsinoRegularEducacaoProfissional"))
	strEtapasCreche0a3Anos 											= Trim(Request.Form("cmbEtapasCreche0a3Anos"))
	strEtapasCreche4a5Anos 											= Trim(Request.Form("cmbEtapasCreche4a5Anos"))
	strEnsinoFundamental8anos 										= Trim(Request.Form("cmbEnsinoFundamental8anos"))
	strEnsinoFundamental9anos										= Trim(Request.Form("cmbEnsinoFundamental9anos"))
	strEnsinoMedioMedio 											= Trim(Request.Form("cmbEnsinoMedioMedio"))
	strEnsinoMedioIntegrado 										= Trim(Request.Form("cmbEnsinoMedioIntegrado"))
	strEtapasEducacaoMagisterio 									= Trim(Request.Form("cmbEtapasEducacaoMagisterio"))
	strEtapasEducacaoProfissional 									= Trim(Request.Form("cmbEtapasEducacaoProfissional"))
	strEtapasEducacaoEspecialEJAEnsinoFundametal 					= Trim(Request.Form("cmbEtapasEducacaoEspecialEJAEnsinoFundametal"))
	strEtapasEJAEnsinoFundametal 									= Trim(Request.Form("cmbEtapasEJAEnsinoFundametal"))
	strEtapasEJAEnsinoFundametalProjovem 							= Trim(Request.Form("cmbEtapasEJAEnsinoFundametalProjovem"))
	strEtapasEJAEnsinoMedio 										= Trim(Request.Form("cmbEtapasEJAEnsinoMedio"))
	strEnsinoFudamentalOrganizadoCiclos 							= Trim(Request.Form("cmbEnsinoFudamentalOrganizadoCiclos"))
	strLocalizacaoDiferenciadaEscola 								= Trim(Request.Form("cmbLocalizacaoDiferenciadaEscola"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strMateriasUltiza 												= Trim(Request.Form("cmbMateriasUltiza"))
	strMateriasQuilombola 											= Trim(Request.Form("cmbMateriasQuilombola"))
	strMateriasIndigina 											= Trim(Request.Form("cmbMateriasIndigina"))
	strEducacaoIndigina 											= Trim(Request.Form("cmbEducacaoIndigina"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strLinguaIndigina 												= Trim(Request.Form("cmbLinguaIndigina"))
	strLinguaPortuguesa 											= Trim(Request.Form("cmbLinguaPortuguesa"))
	strCodigoLinguaIndigina 										= Trim(Request.Form("txtCodigoLinguaIndigina"))
	strEscolaEspecialTurmasAlfabetizado 							= Trim(Request.Form("cmbEscolaEspecialTurmasAlfabetizado"))
	strEscolaAbreFinaisSemanaComunidade 							= Trim(Request.Form("cmbEscolaAbreFinaisSemanaComunidade"))
	strEscolaAlternancia 											= Trim(Request.Form("cmbEscolaAlternancia"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Escola Salva com sucesso..."
		
		sql = "Delete From REGISTRO10 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO10( Cod_empresa, TipoRegistro, CodInep, NumeroCPFGestorEscola, NomeGestorEscola, CargoGestorEscola, EmailGestorEscolar, "
		sql = sql & " LocalFuncionamentoEscolaPredioEscolar, LocalFuncionamentoEscolaTemploIgreja, LocalFuncionamentoEscolaSalaEmpresa, "
		sql = sql & " LocalFuncionamentoEscolaCasaProfessor, LocalFuncionamentoEscolaSalasOutraEscola,LocalFuncionamentoEscolaGalpaoRachoPaiolBarracao, "
		sql = sql & " LocalFuncionamentoEscolaSocioeducativo, LocalFuncionamentoEscolaUnidadePrisional, LocalFuncionamentoEscolaOutros,"
		sql = sql & " FormaOcupacaoPredio, PredioCompartiladoComOutraEscola ,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " CodEscolaCompartilha1, CodEscolaCompartilha2, CodEscolaCompartilha3, CodEscolaCompartilha4, CodEscolaCompartilha5, CodEscolaCompartilha6, "
		sql = sql & " AguaConsumidaPelosAlunos, AbastecimentoAgua, AbastecimentoAguaRedePublica, AbastecimentoAguaPocoArtesiano, AbastecimentoAguaCacimbaCusternaPoco," 
		sql = sql & " AbastecimentoAguaFonteRioIgarapeCorrego, AbastecimentoAguaInexistente ,"
		sql = sql & " AbastecimentoEnergiaRedePublica, AbastecimentoEnergiaGerador, AbastecimentoEnergiaAlternativa,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " EsgotoSanitario, EsgotoSanitarioRedePublica, EsgotoSanitarioFossa, EsgotoSanitarioInexistente, "
		sql = sql & " DestinacaoLixo, DestinacaoLixoColetaPeriodica, DestinacaoLixoQueima, DestinacaoLixoJogaOutraArea, "
		sql = sql & " DestinacaoLixoRecicla, DestinacaoLixoEnterra, DestinacaoLixoOutros,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " DependenciaExistentesEscola, DependenciaExistentesEscolaSalaDiretoria, DependenciaExistentesEscolaSalaProfessores, "
		sql = sql & " DependenciaExistentesEscolaSalaSecrestaria, DependenciaExistentesEscolaLaboratorioInformatica, DependenciaExistentesEscolaLaboratorioCiencia, "
		sql = sql & " DependenciaExistentesEscolaSalaAEE, DependenciaExistentesEscolaQuadroEsporteCoberta, DependenciaExistentesEscolaQuadroEsporteDescoberta, "
		sql = sql & " DependenciaExistentesEscolaCozinha, DependenciaExistentesEscolaBoblioteca ,"
		sql = sql & " DependenciaExistentesEscolaSalaLeitura, DependenciaExistentesEscolaParqueInfantil, DependenciaExistentesEscolaBercario, " 
		sql = sql & " DependenciaExistentesEscolaBanheiroForaPredio, DependenciaExistentesEscolaBanheiroDentroPredio,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " DependenciaExistentesEscolaBanheiroAdequadoinfantil, DependenciaExistentesEscolaBanheiroMobilidadeReduzida, DependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida, "
		sql = sql & " DependenciaExistentesEscolaBanheiroComChuveiro, DependenciaExistentesEscolaRefeitorio,"
		sql = sql & " DependenciaExistentesEscolaDespensa, DependenciaExistentesEscolaAlmoxarifado, DependenciaExistentesEscolaAuditorio, "
		sql = sql & " DependenciaExistentesEscolaPatioCoberto, DependenciaExistentesEscolaPatioDescoberto,"
		sql = sql & " DependenciaExistentesEscolaAlojamentoAluno, DependenciaExistentesEscolaAlojamentoProfessor, DependenciaExistentesEscolaAreaVerde, "
		sql = sql & " DependenciaExistentesEscolaLavanderia, DependenciaExistentesEscolaNenhumaRelacionadas, NumeroSalasAulaExistenteEscola, NumeroSalasAulaDentroEForaPredio,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " EquipamentosAparelhoTelevisao, EquipamentosVideocassete, EquipamentosAparelhoDVD, EquipamentosAtenaParabolica, EquipamentosCopiadora, "
		sql = sql & " EquipamentosRetroprojetor, EquipamentosImpresssora, EquipamentosAparelhoSom, EquipamentosDataShow, EquipamentosFax, EquipamentosFilmadora, "
		sql = sql & " EquipamentosComputadores, QuantidadeComputadoresAdministrativo, QuantidadeComputadoresAlunos, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " TotalFuncionarioEscola, AlimentacaoEscolaPNAE, AlimentacaoEscolaAlunos, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " AlimentacaoEducacionalAEE, AtividadeComplementar, ModalidadeEnsinoRegular, ModalidadeEducacional,  "
		sql = sql & " EspecialModalidadeSubstitutiva,  ModalidadeEducacionalJovensAdultos ,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " Etapas0a3Anos ,  Etapas4a5Anos , Etapas8Anos, Etapas9Anos, EtapasMedio, EtapasMedioIntegrado, "
		sql = sql & " EtapasNormalMagisterio,  EtapasEnsinoRegularEducacaoProfissional , EtapasCreche0a3Anos, EtapasCreche4a5Anos, EnsinoFundamental8anos, "
		sql = sql & " EnsinoFundamental9anos,  EnsinoMedioMedio ,EnsinoMedioIntegrado, EtapasEducacaoMagisterio, EtapasEducacaoProfissional, "
		sql = sql & " EtapasEducacaoEspecialEJAEnsinoFundametal,  EtapasEJAEnsinoFundametal ,"
		sql = sql & " EtapasEJAEnsinoFundametalProjovem,  EtapasEJAEnsinoMedio ,"
		sql = sql & " EnsinoFudamentalOrganizadoCiclos,  LocalizacaoDiferenciadaEscola, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " MateriasUltiza,  MateriasQuilombola, MateriasIndigina,  EducacaoIndigina ,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " LinguaIndigina,  LinguaPortuguesa, CodigoLinguaIndigina, "
		sql = sql & " EscolaEspecialTurmasAlfabetizado,  EscolaAbreFinaisSemanaComunidade, EscolaAlternancia)"
	
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & intCodInep & "',"
		sql = sql & "'" & strNumeroCPFGestorEscola & "',"
		sql = sql & "'" & strNomeGestorEscola & "',"
		sql = sql & "'" & strCargoGestorEscola & "',"
		sql = sql & "'" & strEmailGestorEscolar & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaPredioEscolar & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaTemploIgreja & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaSalaEmpresa & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaCasaProfessor & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaSalasOutraEscola & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaSocioeducativo & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaUnidadePrisional & "',"
		sql = sql & "'" & strLocalFuncionamentoEscolaOutros & "',"
		sql = sql & "'" & strFormaOcupacaoPredio & "',"
		sql = sql & "'" & strPredioCompartiladoComOutraEscola & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strCodEscolaCompartilha1 & "',"
		sql = sql & "'" & strCodEscolaCompartilha2 & "',"
		sql = sql & "'" & strCodEscolaCompartilha3 & "',"
		sql = sql & "'" & strCodEscolaCompartilha4 & "',"
		sql = sql & "'" & strCodEscolaCompartilha5 & "',"
		sql = sql & "'" & strCodEscolaCompartilha6 & "',"
		sql = sql & "'" & strAguaConsumidaPelosAlunos & "',"
		sql = sql & "'" & strAbastecimentoAgua & "',"
		sql = sql & "'" & strAbastecimentoAguaRedePublica & "',"
		sql = sql & "'" & strAbastecimentoAguaPocoArtesiano & "',"
		sql = sql & "'" & strAbastecimentoAguaCacimbaCusternaPoco & "',"
		sql = sql & "'" & strAbastecimentoAguaFonteRioIgarapeCorrego & "',"
		sql = sql & "'" & strAbastecimentoAguaInexistente & "',"
		sql = sql & "'" & strAbastecimentoEnergiaRedePublica & "',"
		sql = sql & "'" & strAbastecimentoEnergiaGerador & "',"
		sql = sql & "'" & strAbastecimentoEnergiaAlternativa & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strEsgotoSanitario & "',"
		sql = sql & "'" & strEsgotoSanitarioRedePublica & "',"
		sql = sql & "'" & strEsgotoSanitarioFossa & "',"
		sql = sql & "'" & strEsgotoSanitarioInexistente & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strDestinacaoLixo & "',"
		sql = sql & "'" & strDestinacaoLixoColetaPeriodica & "',"
		sql = sql & "'" & strDestinacaoLixoQueima & "',"
		sql = sql & "'" & strDestinacaoLixoJogaOutraArea & "',"
		sql = sql & "'" & strDestinacaoLixoRecicla & "',"
		sql = sql & "'" & strDestinacaoLixoEnterra & "',"
		sql = sql & "'" & strDestinacaoLixoOutros & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strDependenciaExistentesEscola & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaSalaDiretoria & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaSalaProfessores & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaSalaSecrestaria & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaLaboratorioInformatica & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaLaboratorioCiencia & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaSalaAEE & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaQuadroEsporteCoberta & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaQuadroEsporteDescoberta & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaCozinha & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBoblioteca & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaSalaLeitura & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaParqueInfantil & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBercario & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBanheiroForaPredio & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBanheiroDentroPredio & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strDependenciaExistentesEscolaBanheiroAdequadoinfantil & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBanheiroMobilidadeReduzida & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaBanheiroComChuveiro & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaRefeitorio & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaDespensa & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaAlmoxarifado & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaAuditorio & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaPatioCoberto & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaPatioDescoberto & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaAlojamentoAluno & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaAlojamentoProfessor & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaAreaVerde & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaLavanderia & "',"
		sql = sql & "'" & strDependenciaExistentesEscolaNenhumaRelacionadas & "',"
		sql = sql & "'" & strNumeroSalasAulaExistenteEscola & "',"
		sql = sql & "'" & strNumeroSalasAulaDentroEForaPredio & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strEquipamentosAparelhoTelevisao & "',"
		sql = sql & "'" & strEquipamentosVideocassete & "',"
		sql = sql & "'" & strEquipamentosAparelhoDVD & "',"
		sql = sql & "'" & strEquipamentosAtenaParabolica & "',"
		sql = sql & "'" & strEquipamentosCopiadora & "',"
		sql = sql & "'" & strEquipamentosRetroprojetor & "',"
		sql = sql & "'" & strEquipamentosImpresssora & "',"
		sql = sql & "'" & strEquipamentosAparelhoSom & "',"
		sql = sql & "'" & strEquipamentosDataShow & "',"
		sql = sql & "'" & strEquipamentosFax & "',"
		sql = sql & "'" & strEquipamentosFilmadora & "',"
		sql = sql & "'" & strEquipamentosComputadores & "',"
		sql = sql & "'" & strQuantidadeComputadoresAdministrativo & "',"
		sql = sql & "'" & strQuantidadeComputadoresAlunos & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strTotalFuncionarioEscola & "',"
		sql = sql & "'" & strAlimentacaoEscolaPNAE & "',"
		sql = sql & "'" & strAlimentacaoEscolaAlunos & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strAlimentacaoEducacionalAEE & "',"
		sql = sql & "'" & strAtividadeComplementar & "',"
		sql = sql & "'" & strModalidadeEnsinoRegular & "',"
		sql = sql & "'" & strModalidadeEducacional & "',"
		sql = sql & "'" & strEspecialModalidadeSubstitutiva & "',"
		sql = sql & "'" & strModalidadeEducacionalJovensAdultos & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strEtapas0a3Anos & "',"
		sql = sql & "'" & strEtapas4a5Anos & "',"
		sql = sql & "'" & strEtapas8Anos & "',"
		sql = sql & "'" & strEtapas9Anos & "',"
		sql = sql & "'" & strEtapasMedio & "',"
		sql = sql & "'" & strEtapasMedioIntegrado & "',"
		sql = sql & "'" & strEtapasNormalMagisterio & "',"
		sql = sql & "'" & strEtapasEnsinoRegularEducacaoProfissional & "',"
		sql = sql & "'" & strEtapasCreche0a3Anos & "',"
		sql = sql & "'" & strEtapasCreche4a5Anos & "',"
		sql = sql & "'" & strEnsinoFundamental8anos & "',"
		sql = sql & "'" & strEnsinoFundamental9anos & "',"
		sql = sql & "'" & strEnsinoMedioMedio & "',"
		sql = sql & "'" & strEnsinoMedioIntegrado & "',"
		sql = sql & "'" & strEtapasEducacaoMagisterio & "',"
		sql = sql & "'" & strEtapasEducacaoProfissional & "',"
		sql = sql & "'" & strEtapasEducacaoEspecialEJAEnsinoFundametal & "',"
		sql = sql & "'" & strEtapasEJAEnsinoFundametal & "',"
		sql = sql & "'" & strEtapasEJAEnsinoFundametalProjovem & "',"
		sql = sql & "'" & strEtapasEJAEnsinoMedio & "',"
		sql = sql & "'" & strEnsinoFudamentalOrganizadoCiclos & "',"
		sql = sql & "'" & strLocalizacaoDiferenciadaEscola & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strMateriasUltiza & "',"
		sql = sql & "'" & strMateriasQuilombola & "',"
		sql = sql & "'" & strMateriasIndigina & "',"
		sql = sql & "'" & strEducacaoIndigina & "',"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & "'" & strLinguaIndigina & "',"
		sql = sql & "'" & strLinguaPortuguesa & "',"
		sql = sql & "'" & strCodigoLinguaIndigina & "',"
		sql = sql & "'" & strEscolaEspecialTurmasAlfabetizado & "',"
		sql = sql & "'" & strEscolaAbreFinaisSemanaComunidade & "',"
		sql = sql & "'" & strEscolaAlternancia & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO10 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro10_con.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>