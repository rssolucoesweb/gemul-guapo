<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Senso</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strFuncao = ""
	strPaginaTitulo 								= "Cadastro de Escola - Caracterização e Infraestrutura - Registro 10"
	intCodEmpresa									= Trim(Request("CodEscola"))
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
	strEsgotoSanitario									= Trim(Request.Form("cmbEsgotoSanitario"))
	strEsgotoSanitarioRedePublica						= Trim(Request.Form("cmbEsgotoSanitarioRedePublica"))
	strEsgotoSanitarioFossa								= Trim(Request.Form("cmbEsgotoSanitarioFossa"))
	strEsgotoSanitarioInexistente						= Trim(Request.Form("cmbEsgotoSanitarioInexistente"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	strDestinacaoLixo									= Trim(Request.Form("cmbDestinacaoLixo"))
	strDestinacaoLixoColetaPeriodica					= Trim(Request.Form("cmbDestinacaoLixoColetaPeriodica"))
	strDestinacaoLixoQueima								= Trim(Request.Form("cmbDestinacaoLixoQueima"))
	strDestinacaoLixoJogaOutraArea						= Trim(Request.Form("cmbDestinacaoLixoJogaOutraArea"))
	strDestinacaoLixoRecicla							= Trim(Request.Form("cmbDestinacaoLixoRecicla"))
	strDestinacaoLixoEnterra							= Trim(Request.Form("cmbDestinacaoLixoEnterra"))
	strDestinacaoLixoOutros								= Trim(Request.Form("cmbDestinacaoLixoOutros"))
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
	strEtapasNormalMagisterio 										= Trim(Request.Form("cmbEtapasMedioIntegrado"))
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
	strLinguaIndigina 												= Trim(Request.Form("cmbLinguaIndigina"))
	strLinguaPortuguesa 											= Trim(Request.Form("cmbLinguaPortuguesa"))
	strCodigoLinguaIndigina 										= Trim(Request.Form("txtCodigoLinguaIndigina"))
	strEscolaEspecialTurmasAlfabetizado 							= Trim(Request.Form("cmbEscolaEspecialTurmasAlfabetizado"))
	strEscolaAbreFinaisSemanaComunidade 							= Trim(Request.Form("cmbEscolaAbreFinaisSemanaComunidade"))
	strEscolaAlternancia 											= Trim(Request.Form("cmbEscolaAlternancia"))


	if trim(intCodEmpresa) <> "" then
	     
		sql = "SELECT Cod_empresa, TipoRegistro, CodInep, NumeroCPFGestorEscola, NomeGestorEscola, CargoGestorEscola, EmailGestorEscolar, "
		sql = sql & " LocalFuncionamentoEscolaPredioEscolar, LocalFuncionamentoEscolaTemploIgreja, LocalFuncionamentoEscolaSalaEmpresa, "
		sql = sql & " LocalFuncionamentoEscolaCasaProfessor, LocalFuncionamentoEscolaSalasOutraEscola,LocalFuncionamentoEscolaGalpaoRachoPaiolBarracao, "
		sql = sql & " LocalFuncionamentoEscolaSocioeducativo, LocalFuncionamentoEscolaUnidadePrisional, LocalFuncionamentoEscolaOutros,  "
		sql = sql & " FormaOcupacaoPredio, PredioCompartiladoComOutraEscola, "
		sql = sql & " CodEscolaCompartilha1, CodEscolaCompartilha2, CodEscolaCompartilha3, CodEscolaCompartilha4, CodEscolaCompartilha5, CodEscolaCompartilha6, "
		sql = sql & " AguaConsumidaPelosAlunos, AbastecimentoAgua, AbastecimentoAguaRedePublica, AbastecimentoAguaPocoArtesiano, AbastecimentoAguaCacimbaCusternaPoco," 
		sql = sql & " AbastecimentoAguaFonteRioIgarapeCorrego, AbastecimentoAguaInexistente,  "
		sql = sql & " AbastecimentoEnergiaRedePublica, AbastecimentoEnergiaGerador, AbastecimentoEnergiaAlternativa, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " EsgotoSanitario, EsgotoSanitarioRedePublica, EsgotoSanitarioFossa, EsgotoSanitarioInexistente, "
		sql = sql & " DestinacaoLixo, DestinacaoLixoColetaPeriodica, DestinacaoLixoQueima, DestinacaoLixoJogaOutraArea, DestinacaoLixoRecicla, "
		sql = sql & " DestinacaoLixoEnterra, DestinacaoLixoOutros, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " DependenciaExistentesEscola, DependenciaExistentesEscolaSalaDiretoria, DependenciaExistentesEscolaSalaProfessores, "
		sql = sql & " DependenciaExistentesEscolaSalaSecrestaria, DependenciaExistentesEscolaLaboratorioInformatica, DependenciaExistentesEscolaLaboratorioCiencia, "
		sql = sql & " DependenciaExistentesEscolaSalaAEE, DependenciaExistentesEscolaQuadroEsporteCoberta, DependenciaExistentesEscolaQuadroEsporteDescoberta, "
		sql = sql & " DependenciaExistentesEscolaCozinha, DependenciaExistentesEscolaBoblioteca ,"
		sql = sql & " DependenciaExistentesEscolaSalaLeitura, DependenciaExistentesEscolaParqueInfantil, DependenciaExistentesEscolaBercario, " 
		sql = sql & " DependenciaExistentesEscolaBanheiroForaPredio, DependenciaExistentesEscolaBanheiroDentroPredio,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " DependenciaExistentesEscolaBanheiroAdequadoinfantil, DependenciaExistentesEscolaBanheiroMobilidadeReduzida, DependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida, "
		sql = sql & " DependenciaExistentesEscolaBanheiroComChuveiro, DependenciaExistentesEscolaRefeitorio, DependenciaExistentesEscolaDespensa, DependenciaExistentesEscolaAlmoxarifado, "
		sql = sql & " DependenciaExistentesEscolaAuditorio, DependenciaExistentesEscolaPatioCoberto, DependenciaExistentesEscolaPatioDescoberto, DependenciaExistentesEscolaAlojamentoAluno, DependenciaExistentesEscolaAlojamentoProfessor, "
		sql = sql & " DependenciaExistentesEscolaAreaVerde, DependenciaExistentesEscolaLavanderia, DependenciaExistentesEscolaNenhumaRelacionadas, NumeroSalasAulaExistenteEscola, NumeroSalasAulaDentroEForaPredio, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " EquipamentosAparelhoTelevisao, EquipamentosVideocassete, EquipamentosAparelhoDVD, EquipamentosAtenaParabolica, EquipamentosCopiadora, "
		sql = sql & " EquipamentosRetroprojetor, EquipamentosImpresssora, EquipamentosAparelhoSom, EquipamentosDataShow, EquipamentosFax, EquipamentosFilmadora, "
		sql = sql & " EquipamentosComputadores, QuantidadeComputadoresAdministrativo, QuantidadeComputadoresAlunos, "
		sql = sql & " TotalFuncionarioEscola, AlimentacaoEscolaPNAE, AlimentacaoEscolaAlunos, 	"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " AlimentacaoEducacionalAEE, AtividadeComplementar, ModalidadeEnsinoRegular, ModalidadeEducacional,  "
		sql = sql & " EspecialModalidadeSubstitutiva,  ModalidadeEducacionalJovensAdultos, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " Etapas0a3Anos ,  Etapas4a5Anos , Etapas8Anos, Etapas9Anos, EtapasMedio, EtapasMedioIntegrado, "
		sql = sql & " EtapasNormalMagisterio,  EtapasEnsinoRegularEducacaoProfissional , EtapasCreche0a3Anos, EtapasCreche4a5Anos, EnsinoFundamental8anos, "
		sql = sql & " EnsinoFundamental9anos,  EnsinoMedioMedio ,EnsinoMedioIntegrado, EtapasEducacaoMagisterio, EtapasEducacaoProfissional, "
		sql = sql & " EtapasEducacaoEspecialEJAEnsinoFundametal,  EtapasEJAEnsinoFundametal ,"
		sql = sql & " EtapasEJAEnsinoFundametalProjovem,  EtapasEJAEnsinoMedio ,"
		sql = sql & " EnsinoFudamentalOrganizadoCiclos,  LocalizacaoDiferenciadaEscola,"
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " MateriasUltiza,  MateriasQuilombola, MateriasIndigina,  EducacaoIndigina, "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " LinguaIndigina,  LinguaPortuguesa, CodigoLinguaIndigina , "
		sql = sql & " EscolaEspecialTurmasAlfabetizado,  EscolaAbreFinaisSemanaComunidade, EscolaAlternancia "
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		sql = sql & " FROM REGISTRO10"
		sql = sql & " WHERE Cod_empresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEscola									= rs("Cod_empresa")
			strTipoRegistro									= rs("TipoRegistro")
			intCodInep	 									= rs("CodInep")
			strNumeroCPFGestorEscola						= rs("NumeroCPFGestorEscola")
			strNomeGestorEscola 							= rs("NomeGestorEscola")
			strCargoGestorEscola							= rs("CargoGestorEscola")
			strEmailGestorEscolar							= rs("EmailGestorEscolar")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strLocalFuncionamentoEscolaPredioEscolar			= rs("LocalFuncionamentoEscolaPredioEscolar")
			strLocalFuncionamentoEscolaTemploIgreja				= rs("LocalFuncionamentoEscolaTemploIgreja")
			strLocalFuncionamentoEscolaSalaEmpresa				= rs("LocalFuncionamentoEscolaSalaEmpresa")
			strLocalFuncionamentoEscolaCasaProfessor			= rs("LocalFuncionamentoEscolaCasaProfessor")
			strLocalFuncionamentoEscolaSalasOutraEscola			= rs("LocalFuncionamentoEscolaSalasOutraEscola")
			strLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao	= rs("LocalFuncionamentoEscolaGalpaoRachoPaiolBarracao")
			strLocalFuncionamentoEscolaSocioeducativo			= rs("LocalFuncionamentoEscolaSocioeducativo")
			strLocalFuncionamentoEscolaUnidadePrisional			= rs("LocalFuncionamentoEscolaUnidadePrisional")
			strLocalFuncionamentoEscolaOutros					= rs("LocalFuncionamentoEscolaOutros")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strFormaOcupacaoPredio 								= rs("FormaOcupacaoPredio")
			strPredioCompartiladoComOutraEscola 				= rs("PredioCompartiladoComOutraEscola")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strCodEscolaCompartilha1							= rs("CodEscolaCompartilha1")
			strCodEscolaCompartilha2							= rs("CodEscolaCompartilha2")
			strCodEscolaCompartilha3							= rs("CodEscolaCompartilha3")
			strCodEscolaCompartilha4							= rs("CodEscolaCompartilha4")
			strCodEscolaCompartilha5							= rs("CodEscolaCompartilha5")
			strCodEscolaCompartilha6							= rs("CodEscolaCompartilha6")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strAguaConsumidaPelosAlunos							= rs("AguaConsumidaPelosAlunos")
			strAbastecimentoAgua								= rs("AbastecimentoAgua")
			strAbastecimentoAguaRedePublica						= rs("AbastecimentoAguaRedePublica")
			strAbastecimentoAguaPocoArtesiano					= rs("AbastecimentoAguaPocoArtesiano")
			strAbastecimentoAguaCacimbaCusternaPoco				= rs("AbastecimentoAguaCacimbaCusternaPoco")
			strAbastecimentoAguaFonteRioIgarapeCorrego			= rs("AbastecimentoAguaFonteRioIgarapeCorrego")
			strAbastecimentoAguaInexistente						= rs("AbastecimentoAguaInexistente")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strAbastecimentoEnergiaRedePublica					= rs("AbastecimentoEnergiaRedePublica")
			strAbastecimentoEnergiaGerador						= rs("AbastecimentoEnergiaGerador")
			strAbastecimentoEnergiaAlternativa					= rs("AbastecimentoEnergiaAlternativa")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strEsgotoSanitario									= trim(rs("EsgotoSanitario"))
			strEsgotoSanitarioRedePublica						= trim(rs("EsgotoSanitarioRedePublica"))
			strEsgotoSanitarioFossa								= trim(rs("EsgotoSanitarioFossa"))
			strEsgotoSanitarioInexistente						= trim(rs("EsgotoSanitarioInexistente"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strDestinacaoLixo									= rs("DestinacaoLixo")
			strDestinacaoLixoColetaPeriodica					= rs("DestinacaoLixoColetaPeriodica")
			strDestinacaoLixoQueima								= rs("DestinacaoLixoQueima")
			strDestinacaoLixoJogaOutraArea						= trim(rs("DestinacaoLixoJogaOutraArea"))
			strDestinacaoLixoRecicla							= rs("DestinacaoLixoRecicla")
			strDestinacaoLixoEnterra							= rs("DestinacaoLixoEnterra")
			strDestinacaoLixoOutros								= rs("DestinacaoLixoOutros")
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strDependenciaExistentesEscola							= trim(rs("DependenciaExistentesEscola"))
			strDependenciaExistentesEscolaSalaDiretoria				= trim(rs("DependenciaExistentesEscolaSalaDiretoria"))
			strDependenciaExistentesEscolaSalaProfessores 			= trim(rs("DependenciaExistentesEscolaSalaProfessores"))
			strDependenciaExistentesEscolaSalaSecrestaria			= trim(rs("DependenciaExistentesEscolaSalaSecrestaria"))
			strDependenciaExistentesEscolaLaboratorioInformatica 	= trim(rs("DependenciaExistentesEscolaLaboratorioInformatica"))
			strDependenciaExistentesEscolaLaboratorioCiencia	 	= trim(rs("DependenciaExistentesEscolaLaboratorioCiencia"))
			strDependenciaExistentesEscolaSalaAEE	 				= trim(rs("DependenciaExistentesEscolaSalaAEE"))
			strDependenciaExistentesEscolaQuadroEsporteCoberta		= trim(rs("DependenciaExistentesEscolaQuadroEsporteCoberta"))
			strDependenciaExistentesEscolaQuadroEsporteDescoberta	= trim(rs("DependenciaExistentesEscolaQuadroEsporteDescoberta"))
			strDependenciaExistentesEscolaCozinha	 				= trim(rs("DependenciaExistentesEscolaCozinha"))
			strDependenciaExistentesEscolaBoblioteca	 			= trim(rs("DependenciaExistentesEscolaBoblioteca"))
			strDependenciaExistentesEscolaSalaLeitura	 			= trim(rs("DependenciaExistentesEscolaSalaLeitura"))
			strDependenciaExistentesEscolaParqueInfantil	 		= trim(rs("DependenciaExistentesEscolaParqueInfantil"))
			strDependenciaExistentesEscolaBercario	 				= trim(rs("DependenciaExistentesEscolaBercario"))
			strDependenciaExistentesEscolaBanheiroForaPredio	 	= trim(rs("DependenciaExistentesEscolaBanheiroForaPredio"))
			strDependenciaExistentesEscolaBanheiroDentroPredio	 	= trim(rs("DependenciaExistentesEscolaBanheiroDentroPredio"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strDependenciaExistentesEscolaBanheiroAdequadoinfantil	 							= trim(rs("DependenciaExistentesEscolaBanheiroAdequadoinfantil"))
			strDependenciaExistentesEscolaBanheiroMobilidadeReduzida	 						= trim(rs("DependenciaExistentesEscolaBanheiroMobilidadeReduzida"))
			strDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida	 	= trim(rs("DependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida"))
			strDependenciaExistentesEscolaBanheiroComChuveiro	 								= trim(rs("DependenciaExistentesEscolaBanheiroComChuveiro"))
			strDependenciaExistentesEscolaRefeitorio	 										= trim(rs("DependenciaExistentesEscolaRefeitorio"))
			strDependenciaExistentesEscolaDespensa	 											= trim(rs("DependenciaExistentesEscolaDespensa"))
			strDependenciaExistentesEscolaAlmoxarifado	 										= trim(rs("DependenciaExistentesEscolaAlmoxarifado"))
			strDependenciaExistentesEscolaAuditorio	 											= trim(rs("DependenciaExistentesEscolaAuditorio"))
			strDependenciaExistentesEscolaPatioCoberto	 										= trim(rs("DependenciaExistentesEscolaPatioCoberto"))
			strDependenciaExistentesEscolaPatioDescoberto	 									= trim(rs("DependenciaExistentesEscolaPatioDescoberto"))
			strDependenciaExistentesEscolaAlojamentoAluno	 									= trim(rs("DependenciaExistentesEscolaAlojamentoAluno"))
			strDependenciaExistentesEscolaAlojamentoProfessor	 								= trim(rs("DependenciaExistentesEscolaAlojamentoProfessor"))
			strDependenciaExistentesEscolaAreaVerde	 											= trim(rs("DependenciaExistentesEscolaAreaVerde"))
			strDependenciaExistentesEscolaLavanderia	 										= trim(rs("DependenciaExistentesEscolaLavanderia"))
			strDependenciaExistentesEscolaNenhumaRelacionadas	 								= trim(rs("DependenciaExistentesEscolaNenhumaRelacionadas"))
			strNumeroSalasAulaExistenteEscola	 												= trim(rs("NumeroSalasAulaExistenteEscola"))
			strNumeroSalasAulaDentroEForaPredio	 												= trim(rs("NumeroSalasAulaDentroEForaPredio"))

			strEquipamentosAparelhoTelevisao						= trim(rs("EquipamentosAparelhoTelevisao"))
			strEquipamentosVideocassete								= trim(rs("EquipamentosVideocassete"))
			strEquipamentosAparelhoDVD								= trim(rs("EquipamentosAparelhoDVD"))
			strEquipamentosAtenaParabolica							= trim(rs("EquipamentosAtenaParabolica"))
			strEquipamentosCopiadora								= trim(rs("EquipamentosCopiadora"))
			strEquipamentosRetroprojetor							= trim(rs("EquipamentosRetroprojetor"))
			strEquipamentosImpresssora								= trim(rs("EquipamentosImpresssora"))
			strEquipamentosAparelhoSom								= trim(rs("EquipamentosAparelhoSom"))
			strEquipamentosDataShow									= trim(rs("EquipamentosDataShow"))
			strEquipamentosFax										= trim(rs("EquipamentosFax"))
			strEquipamentosFilmadora								= trim(rs("EquipamentosFilmadora"))
			strEquipamentosComputadores								= trim(rs("EquipamentosComputadores"))
			strQuantidadeComputadoresAdministrativo					= trim(rs("QuantidadeComputadoresAdministrativo"))
			strQuantidadeComputadoresAlunos							= trim(rs("QuantidadeComputadoresAlunos"))
		
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strTotalFuncionarioEscola								= trim(rs("TotalFuncionarioEscola"))
			strAlimentacaoEscolaPNAE								= trim(rs("AlimentacaoEscolaPNAE"))
			strAlimentacaoEscolaAlunos								= trim(rs("AlimentacaoEscolaAlunos"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strAlimentacaoEducacionalAEE							= trim(rs("AlimentacaoEducacionalAEE"))
			strAtividadeComplementar								= trim(rs("AtividadeComplementar"))
			strModalidadeEnsinoRegular								= trim(rs("ModalidadeEnsinoRegular"))
			strModalidadeEducacional								= trim(rs("ModalidadeEducacional"))
			strEspecialModalidadeSubstitutiva						= trim(rs("EspecialModalidadeSubstitutiva"))
			strModalidadeEducacionalJovensAdultos					= trim(rs("ModalidadeEducacionalJovensAdultos"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strEtapas0a3Anos 												= trim(rs("Etapas0a3Anos"))
			strEtapas4a5Anos 												= trim(rs("Etapas4a5Anos"))
			strEtapas8Anos 													= trim(rs("Etapas8Anos"))
			strEtapas9Anos 													= trim(rs("Etapas9Anos"))
			strEtapasMedio 													= trim(rs("EtapasMedio"))
			strEtapasMedioIntegrado 										= trim(rs("EtapasMedioIntegrado"))
			strEtapasNormalMagisterio 										= trim(rs("EtapasNormalMagisterio"))
			strEtapasEnsinoRegularEducacaoProfissional 						= trim(rs("EtapasEnsinoRegularEducacaoProfissional"))
			strEtapasCreche0a3Anos 											= trim(rs("EtapasCreche0a3Anos"))
			strEtapasCreche4a5Anos 											= trim(rs("EtapasCreche4a5Anos"))
			strEnsinoFundamental8anos 										= trim(rs("EnsinoFundamental8anos"))
			strEnsinoFundamental9anos										= trim(rs("EnsinoFundamental9anos"))
			strEnsinoMedioMedio 											= trim(rs("EnsinoMedioMedio"))
			strEnsinoMedioIntegrado 										= trim(rs("EnsinoMedioIntegrado"))
			strEtapasEducacaoMagisterio 									= trim(rs("EtapasEducacaoMagisterio"))
			strEtapasEducacaoProfissional 									= trim(rs("EtapasEducacaoProfissional"))
			strEtapasEducacaoEspecialEJAEnsinoFundametal 					= trim(rs("EtapasEducacaoEspecialEJAEnsinoFundametal"))
			strEtapasEJAEnsinoFundametal 									= trim(rs("EtapasEJAEnsinoFundametal"))
			strEtapasEJAEnsinoFundametalProjovem 							= trim(rs("EtapasEJAEnsinoFundametalProjovem"))
			strEtapasEJAEnsinoMedio 										= trim(rs("EtapasEJAEnsinoMedio"))
			strEnsinoFudamentalOrganizadoCiclos 							= trim(rs("EnsinoFudamentalOrganizadoCiclos"))
			strLocalizacaoDiferenciadaEscola 								= trim(rs("LocalizacaoDiferenciadaEscola"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strMateriasUltiza 												= trim(rs("MateriasUltiza"))
			strMateriasQuilombola 											= trim(rs("MateriasQuilombola"))
			strMateriasIndigina 											= trim(rs("MateriasIndigina"))
			strEducacaoIndigina 											= trim(rs("EducacaoIndigina"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
			strLinguaIndigina 												= trim(rs("LinguaIndigina"))
			strLinguaPortuguesa 											= trim(rs("LinguaPortuguesa"))
			strCodigoLinguaIndigina 										= trim(rs("CodigoLinguaIndigina"))
			strEscolaEspecialTurmasAlfabetizado 							= trim(rs("EscolaEspecialTurmasAlfabetizado"))
			strEscolaAbreFinaisSemanaComunidade 							= trim(rs("EscolaAbreFinaisSemanaComunidade"))
			strEscolaAlternancia 											= trim(rs("EscolaAlternancia"))
			'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
			strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
			
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Escola - Caracteriza&ccedil;&atilde;o e Infraestrutura - Registro 10</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
  					
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="98%" align="center" class="tituloSistema"><%=strPaginaTitulo%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="25" class="form-controlo1">Empresa:</td>
            <td><input style="width:100pt" name="txtCodEmpresa" type="text" class="form-control" id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
          </tr>
          <tr>
            <td width="491" height="25" class="form-controlo1">Tipo Registro : </td>
            <td width="790"><input style="width:100pt" name="txtTipoRegistro" type="text" class="form-control" id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Cod. Escola - Inep :</td>
            <td>
              <input style="width:100pt" name="txtCodInep" type="text"  onKeyPress="return formataCampo(this,2,10)" class="form-control" id="txtCodInep" size="8" maxlength="8" value="<%=trim(intCodInep)%>">            </td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Autentica&ccedil;&atilde;o</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Numero do CPF do Gestor Escola</td>
            <td><input style="width:100pt" name="txtNumeroCPFGestorEscola" type="text" class="form-control" onKeyPress="return formataCampo(this, 5, 14)" onBlur="return validaCPF(this)"  id="txtNumeroCPFGestorEscola" size="15" maxlength="15" value="<%=strNumeroCPFGestorEscola%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Nome do Gestor Escolar</td>
            <td><input style="width:100pt" name="txtNomeGestorEscola" type="text" class="form-control" id="txtNomeGestorEscola" size="50" maxlength="50" value="<%=trim(strNomeGestorEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Cargo do Gestor Escolar</td>
            <td><input style="width:100pt" name="txtCargoGestorEscola" type="text" class="form-control" id="txtCargoGestorEscola" size="50" maxlength="50" value="<%=trim(strCargoGestorEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Endere&ccedil;o eletr&ocirc;nico (e-mail) do Gestor Escolar</td>
            <td>
              <input style="width:100pt" name="txtEmailGestorEscolar" type="text" class="form-control" id="txtEmailGestorEscolar" size="50" maxlength="50" value="<%=trim(strEmailGestorEscolar)%>"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Caracteriza&ccedil;&atilde;o e Infraestrutura</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Pr&eacute;dio escolar</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaPredioEscolar" type="text" class="form-control" id="txtLocalFuncionamentoEscolaPredioEscolar" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaPredioEscolar)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - templo/Igreja:</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaTemploIgreja" type="text" class="form-control" id="txtLocalFuncionamentoEscolaTemploIgreja" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaTemploIgreja)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Salas de Empresa</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaSalaEmpresa" type="text" class="form-control" id="txtLocalFuncionamentoEscolaSalaEmpresa" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaSalaEmpresa)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Casa Professor</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaCasaProfessor" type="text" class="form-control" id="txtLocalFuncionamentoEscolaCasaProfessor" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaCasaProfessor)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Salas em outra Escola</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaSalasOutraEscola" type="text" class="form-control" id="txtLocalFuncionamentoEscolaSalasOutraEscola" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaSalasOutraEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Galp&atilde;o/ Rancho / Paiol / Barra&ccedil;&atilde;o</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao" type="text" class="form-control" id="txtLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaGalpaoRachoPaiolBarracao)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Unidade de Atencimento Socioeducativo</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaSocioeducativo" type="text" class="form-control" id="txtLocalFuncionamentoEscolaSocioeducativo" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaSocioeducativo)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Unidade Prisional</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaUnidadePrisional" type="text" class="form-control" id="txtLocalFuncionamentoEscolaUnidadePrisional" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaUnidadePrisional)%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Local de Funcionamento da Escola - Outros</td>
            <td><input style="width:100pt" name="txtLocalFuncionamentoEscolaOutros" type="text" class="form-control" id="txtLocalFuncionamentoEscolaOutros" size="50" maxlength="50" value="<%=trim(strLocalFuncionamentoEscolaOutros)%>"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Forma de Ocupa&ccedil;&atilde;o do Pr&eacute;dio</td>
            <td><select name="cmbFormaOcupacaoPredio" id="cmbFormaOcupacaoPredio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strFormaOcupacaoPredio = "1" then%> selected <%end if%> value="1">Próprio</option>
              <option <%if strFormaOcupacaoPredio = "2" then%> selected <%end if%> value="2">Alugado</option>
              <option <%if strFormaOcupacaoPredio = "3" then%> selected <%end if%> value="3">Cedido</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Pr&eacute;dio compartilado com outra escola</td>
            <td><select name="cmbPredioCompartiladoComOutraEscola" id="cmbPredioCompartiladoComOutraEscola" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strPredioCompartiladoComOutraEscola = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strPredioCompartiladoComOutraEscola = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da ecola a compartilha(1)</td>
            <td><input style="width:100pt" name="txtCodEscolaCompartilha1"  onKeyPress="return formataCampo(this,2,10)" type="text" class="form-control" id="txtCodEscolaCompartilha1" size="8" maxlength="8" value="<%=strCodEscolaCompartilha1%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da ecola a compartilha(2)</td>
            <td><input style="width:100pt" name="txtCodEscolaCompartilha2"  onKeyPress="return formataCampo(this,2,10)" type="text" class="form-control" id="txtCodEscolaCompartilha2" size="8" maxlength="8" value="<%=strCodEscolaCompartilha2%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da ecola a compartilha(3)</td>
            <td><input style="width:100pt" name="txtCodEscolaCompartilha3"  onKeyPress="return formataCampo(this,2,10)" type="text" class="form-control" id="txtCodEscolaCompartilha3" size="8" maxlength="8" value="<%=strCodEscolaCompartilha3%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da ecola a compartilha(4)</td>
            <td><input style="width:100pt" name="txtCodEscolaCompartilha4"  onKeyPress="return formataCampo(this,2,10)" type="text" class="form-control" id="txtCodEscolaCompartilha4" size="8" maxlength="8" value="<%=strCodEscolaCompartilha4%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da ecola a compartilha(5)</td>
            <td><input style="width:100pt" name="txtCodEscolaCompartilha5"  onKeyPress="return formataCampo(this,2,10)" type="text" class="form-control" id="txtCodEscolaCompartilha5" size="8" maxlength="8" value="<%=strCodEscolaCompartilha5%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da ecola a compartilha(6)</td>
            <td><input style="width:100pt" name="txtCodEscolaCompartilha6"  onKeyPress="return formataCampo(this,2,10)" type="text" class="form-control" id="txtCodEscolaCompartilha6" size="8" maxlength="8" value="<%=strCodEscolaCompartilha6%>"></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">&Aacute;gua consumida pelos alunos</td>
            <td><select name="cmbAguaConsumidaPelosAlunos" id="cmbAguaConsumidaPelosAlunos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAguaConsumidaPelosAlunos = "1" then%> selected <%end if%> value="1">N&atilde;o Filtrada</option>
              <option <%if strAguaConsumidaPelosAlunos = "2" then%> selected <%end if%> value="2">Filtrada</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de &Aacute;gua</td>
            <td><select name="cmbAbastecimentoAgua" id="cmbAbastecimentoAgua" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoAgua = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoAgua = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de &Aacute;gua - Rede p&uacute;blica</td>
            <td><select name="cmbAbastecimentoAguaRedePublica" id="cmbAbastecimentoAguaRedePublica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoAguaRedePublica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoAguaRedePublica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de &Aacute;gua - Po&ccedil;o artesiano</td>
            <td><select name="cmbAbastecimentoAguaPocoArtesiano" id="cmbAbastecimentoAguaPocoArtesiano" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoAguaPocoArtesiano = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoAguaPocoArtesiano = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de &Aacute;gua - Cacimba / cisterna / po&ccedil;o</td>
            <td><select name="cmbAbastecimentoAguaCacimbaCusternaPoco" id="cmbAbastecimentoAguaCacimbaCusternaPoco" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoAguaCacimbaCusternaPoco = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoAguaCacimbaCusternaPoco = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de &Aacute;gua - Fonte/ rio/ igarap&eacute;/ riacho/ c&oacute;rrego</td>
            <td><select name="cmbAbastecimentoAguaFonteRioIgarapeCorrego" id="cmbAbastecimentoAguaFonteRioIgarapeCorrego" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoAguaFonteRioIgarapeCorrego = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoAguaFonteRioIgarapeCorrego = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de &Aacute;gua - Inexistente</td>
            <td><select name="cmbAbastecimentoAguaInexistente" id="cmbAbastecimentoAguaInexistente" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoAguaInexistente = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoAguaInexistente = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="21" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="21" class="form-controlo1">Abastecimento de Enegrica El&eacute;trica - Rede p&uacute;blica</td>
            <td><select name="cmbAbastecimentoEnergiaRedePublica" id="cmbAbastecimentoEnergiaRedePublica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoEnergiaRedePublica = "0" then%> selected <%end if%> value="0">N&atilde;o</option >
              <option <%if strAbastecimentoEnergiaRedePublica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de Enegrica El&eacute;trica - Gerador</td>
            <td><select name="cmbAbastecimentoEnergiaGerador" id="cmbAbastecimentoEnergiaGerador" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoEnergiaGerador = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoEnergiaGerador = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Abastecimento de Enegrica El&eacute;trica - Outros ( energia alternativa). Ex: e&oacute;lica, Solar etc.</td>
            <td><select name="cmbAbastecimentoEnergiaAlternativa" id="cmbAbastecimentoEnergiaAlternativa" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAbastecimentoEnergiaAlternativa = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAbastecimentoEnergiaAlternativa = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Esgoto Snait&aacute;rio </td>
            <td><select name="cmbEsgotoSanitario" id="cmbEsgotoSanitario" class="form-control" style="width:100pt" > <%=strEsgotoSanitario%>
              <option value="0">Selecione...</option>
              <option <%if strEsgotoSanitario = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEsgotoSanitario = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Esgoto Snait&aacute;rio - Rede p&uacute;blica</td>
            <td><select name="cmbEsgotoSanitarioRedePublica" id="cmbEsgotoSanitarioRedePublica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEsgotoSanitarioRedePublica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEsgotoSanitarioRedePublica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Esgoto Snait&aacute;rio - Fossa</td>
            <td><select name="cmbEsgotoSanitarioFossa" id="cmbEsgotoSanitarioFossa" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEsgotoSanitarioFossa = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEsgotoSanitarioFossa = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Esgoto Snait&aacute;rio - Inexistente</td>
            <td><select name="cmbEsgotoSanitarioInexistente" id="cmbEsgotoSanitarioInexistente" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEsgotoSanitarioInexistente = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEsgotoSanitarioInexistente = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo</td>
            <td><select name="cmbDestinacaoLixo" id="cmbDestinacaoLixo" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixo = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo - Coleta peri&oacute;dica</td>
            <td><select name="cmbDestinacaoLixoColetaPeriodica" id="cmbDestinacaoLixoColetaPeriodica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixoColetaPeriodica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixoColetaPeriodica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo - Queima</td>
            <td><select name="cmbDestinacaoLixoQueima" id="cmbDestinacaoLixoQueima" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixoQueima = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixoQueima = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo - Joga em outra &aacute;rea</td>
            <td><select name="cmbDestinacaoLixoJogaOutraArea" id="cmbDestinacaoLixoJogaOutraArea" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixoJogaOutraArea = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixoJogaOutraArea = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo - Recicla</td>
            <td><select name="cmbDestinacaoLixoRecicla" id="cmbDestinacaoLixoRecicla" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixoRecicla = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixoRecicla = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo - Enterra</td>
            <td><select name="cmbDestinacaoLixoEnterra" id="cmbDestinacaoLixoEnterra" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixoEnterra = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixoEnterra = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Destina&ccedil;&atilde;o do Lixo - Outros</td>
            <td><select name="cmbDestinacaoLixoOutros" id="cmbDestinacaoLixoOutros" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDestinacaoLixoOutros = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDestinacaoLixoOutros = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola</td>
            <td><select name="cmbDependenciaExistentesEscola" id="cmbDependenciaExistentesEscola" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscola = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscola = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Sala de diretoria</td>
            <td><select name="cmbDependenciaExistentesEscolaSalaDiretoria" id="cmbDependenciaExistentesEscolaSalaDiretoria" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaSalaDiretoria = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaSalaDiretoria = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Sala de professores</td>
            <td><select name="cmbDependenciaExistentesEscolaSalaProfessores" id="cmbDependenciaExistentesEscolaSalaProfessores" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaSalaProfessores = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaSalaProfessores = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Sala de Secrestaria</td>
            <td><select name="cmbDependenciaExistentesEscolaSalaSecrestaria" id="cmbDependenciaExistentesEscolaSalaSecrestaria" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaSalaSecrestaria = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaSalaSecrestaria = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Laborat&oacute;rio de informatica</td>
            <td><select name="cmbDependenciaExistentesEscolaLaboratorioInformatica" id="cmbDependenciaExistentesEscolaLaboratorioInformatica" class="form-control" style="width:100pt" > 
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaLaboratorioInformatica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaLaboratorioInformatica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Laborat&oacute;rio de Ci&ecirc;ncias</td>
            <td><select name="cmbDependenciaExistentesEscolaLaboratorioCiencia" id="cmbDependenciaExistentesEscolaLaboratorioCiencia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaLaboratorioCiencia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaLaboratorioCiencia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Sala de recursos multifuncionais educacional especializado - AEE</td>
            <td><select name="cmbDependenciaExistentesEscolaSalaAEE" id="cmbDependenciaExistentesEscolaSalaAEE" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaSalaAEE = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaSalaAEE = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Quadro de Esportes Coberta</td>
            <td><select name="cmbDependenciaExistentesEscolaQuadroEsporteCoberta" id="cmbDependenciaExistentesEscolaQuadroEsporteCoberta" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaQuadroEsporteCoberta = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaQuadroEsporteCoberta = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Quadro de Esportes Descoberta</td>
            <td><select name="cmbDependenciaExistentesEscolaQuadroEsporteDescoberta" id="cmbDependenciaExistentesEscolaQuadroEsporteDescoberta" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaQuadroEsporteDescoberta = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaQuadroEsporteDescoberta = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Cozinha</td>
            <td><select name="cmbDependenciaExistentesEscolaCozinha" id="cmbDependenciaExistentesEscolaCozinha" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaCozinha = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaCozinha = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Boblioteca</td>
            <td><select name="cmbDependenciaExistentesEscolaBoblioteca" id="cmbDependenciaExistentesEscolaBoblioteca" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBoblioteca = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBoblioteca = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Sala de Leitura</td>
            <td><select name="cmbDependenciaExistentesEscolaSalaLeitura" id="cmbDependenciaExistentesEscolaSalaLeitura" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaSalaLeitura = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaSalaLeitura = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Parque Infantil</td>
            <td><select name="cmbDependenciaExistentesEscolaParqueInfantil" id="cmbDependenciaExistentesEscolaParqueInfantil" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaParqueInfantil = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaParqueInfantil = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Ber&ccedil;ario</td>
            <td><select name="cmbDependenciaExistentesEscolaBercario" id="cmbDependenciaExistentesEscolaBercario" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBercario = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBercario = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Banheiro fora do pr&eacute;dio</td>
            <td><select name="cmbDependenciaExistentesEscolaBanheiroForaPredio" id="cmbDependenciaExistentesEscolaBanheiroForaPredio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBanheiroForaPredio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBanheiroForaPredio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Banheiro dentro do pr&eacute;dio</td>
            <td><select name="cmbDependenciaExistentesEscolaBanheiroDentroPredio" id="cmbDependenciaExistentesEscolaBanheiroDentroPredio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBanheiroDentroPredio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBanheiroDentroPredio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#CCCCCC" class="form-controlo1">&nbsp;</td>
            <td bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Banheiro adequado &agrave; educa&ccedil;&atilde;o infantil</td>
            <td><select name="cmbDependenciaExistentesEscolaBanheiroAdequadoinfantil" id="cmbDependenciaExistentesEscolaBanheiroAdequadoinfantil" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBanheiroAdequadoinfantil = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBanheiroAdequadoinfantil = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Banheiro adequado a alunos com defici&ecirc;ncia ou mobilidade reduzida</td>
            <td><select name="cmbDependenciaExistentesEscolaBanheiroMobilidadeReduzida" id="cmbDependenciaExistentesEscolaBanheiroMobilidadeReduzida" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBanheiroMobilidadeReduzida = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBanheiroMobilidadeReduzida = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Depend&ecirc;ncia e vias adequadas a alunos com defici&ecirc;ncia ou mobilidade reduzida</td>
            <td><select name="cmbDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida" id="cmbDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBanheiroDependenciaAdequadasMobilidadeReduzida = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Banheiro com Chuveiro</td>
            <td><select name="cmbDependenciaExistentesEscolaBanheiroComChuveiro" id="cmbDependenciaExistentesEscolaBanheiroComChuveiro" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaBanheiroComChuveiro = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaBanheiroComChuveiro = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Refeit&oacute;rio</td>
            <td><select name="cmbDependenciaExistentesEscolaRefeitorio" id="cmbDependenciaExistentesEscolaRefeitorio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaRefeitorio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaRefeitorio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Despensa</td>
            <td><select name="cmbDependenciaExistentesEscolaDespensa" id="cmbDependenciaExistentesEscolaDespensa" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaDespensa = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaDespensa = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Almoxarifado</td>
            <td><select name="cmbDependenciaExistentesEscolaAlmoxarifado" id="cmbDependenciaExistentesEscolaAlmoxarifado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaAlmoxarifado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaAlmoxarifado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Audit&oacute;rio</td>
            <td><select name="cmbDependenciaExistentesEscolaAuditorio" id="cmbDependenciaExistentesEscolaAuditorio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaAuditorio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaAuditorio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - P&aacute;tio coberto</td>
            <td><select name="cmbDependenciaExistentesEscolaPatioCoberto" id="cmbDependenciaExistentesEscolaPatioCoberto" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaPatioCoberto = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaPatioCoberto = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - P&aacute;tio descoberto</td>
            <td><select name="cmbDependenciaExistentesEscolaPatioDescoberto" id="cmbDependenciaExistentesEscolaPatioDescoberto" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaPatioDescoberto = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaPatioDescoberto = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Alojamento de aluno</td>
            <td><select name="cmbDependenciaExistentesEscolaAlojamentoAluno" id="cmbDependenciaExistentesEscolaAlojamentoAluno" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaAlojamentoAluno = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaAlojamentoAluno = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Alojamento de professor</td>
            <td><select name="cmbDependenciaExistentesEscolaAlojamentoProfessor" id="cmbDependenciaExistentesEscolaAlojamentoProfessor" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaAlojamentoProfessor = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaAlojamentoProfessor = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Area verde</td>
            <td><select name="cmbDependenciaExistentesEscolaAreaVerde" id="cmbDependenciaExistentesEscolaAreaVerde" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaAreaVerde = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaAreaVerde = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Lavanderia</td>
            <td><select name="cmbDependenciaExistentesEscolaLavanderia" id="cmbDependenciaExistentesEscolaLavanderia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaLavanderia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaLavanderia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Depend&ecirc;ncia Existentes na Escola - Nenhuma das relacionadas</td>
            <td><select name="cmbDependenciaExistentesEscolaNenhumaRelacionadas" id="cmbDependenciaExistentesEscolaNenhumaRelacionadas" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDependenciaExistentesEscolaNenhumaRelacionadas = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDependenciaExistentesEscolaNenhumaRelacionadas = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">N&uacute;mero de salas de aula existentes na escola</td>
            <td><input style="width:100pt"  name="txtNumeroSalasAulaExistenteEscola" type="text" class="form-control" id="txtNumeroSalasAulaExistenteEscola" size="8" maxlength="8" value="<%=strNumeroSalasAulaExistenteEscola%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">N&uacute;mero de salas ultilizadas como sala de aula - Dentro e fora do pr&eacute;dio</td>
            <td><input style="width:100pt" name="txtNumeroSalasAulaDentroEForaPredio" type="text" class="form-control" id="txtNumeroSalasAulaDentroEForaPredio" size="8" maxlength="8" value="<%=strNumeroSalasAulaDentroEForaPredio%>"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Equipamentos</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Aparelho de Televis&atilde;o</td>
            <td><select name="cmbEquipamentosAparelhoTelevisao" id="cmbEquipamentosAparelhoTelevisao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosAparelhoTelevisao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosAparelhoTelevisao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Videocassete</td>
            <td><select name="cmbEquipamentosVideocassete" id="cmbEquipamentosVideocassete" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosVideocassete = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosVideocassete = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Aparelho de DVD</td>
            <td><select name="cmbEquipamentosAparelhoDVD" id="cmbEquipamentosAparelhoDVD" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosAparelhoDVD = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosAparelhoDVD = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Atena parab&oacute;lica</td>
            <td><select name="cmbEquipamentosAtenaParabolica" id="cmbEquipamentosAtenaParabolica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosAtenaParabolica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosAtenaParabolica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Copiadora</td>
            <td><select name="cmbEquipamentosCopiadora" id="cmbEquipamentosCopiadora" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosCopiadora = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosCopiadora = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Retroprojetor</td>
            <td><select name="cmbEquipamentosRetroprojetor" id="cmbEquipamentosRetroprojetor" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosRetroprojetor = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosRetroprojetor = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Impresssora</td>
            <td><select name="cmbEquipamentosImpresssora" id="cmbEquipamentosImpresssora" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosImpresssora = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosImpresssora = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Aparelho de som</td>
            <td><select name="cmbEquipamentosAparelhoSom" id="cmbEquipamentosAparelhoSom" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosAparelhoSom = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosAparelhoSom = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Projetor Multim&iacute;dia ( Data Show)</td>
            <td><select name="cmbEquipamentosDataShow" id="cmbEquipamentosDataShow" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosDataShow = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosDataShow = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Fax</td>
            <td><select name="cmbEquipamentosFax" id="cmbEquipamentosFax" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosFax = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosFax = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - M&aacute;quina Fotogr&aacute;fica/Filmadora</td>
            <td><select name="cmbEquipamentosFilmadora" id="cmbEquipamentosFilmadora" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosAparelhoSom = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosAparelhoSom = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Equipamentos Existentes na escola  - Computadores</td>
            <td><select name="cmbEquipamentosComputadores" id="cmbEquipamentosComputadores" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEquipamentosComputadores = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEquipamentosComputadores = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Quantidade de Computadores de uso administrativo</td>
            <td><input style="width:100pt" name="txtQuantidadeComputadoresAdministrativo" type="text" class="form-control" id="txtQuantidadeComputadoresAdministrativo" size="8" maxlength="8" value="<%=strQuantidadeComputadoresAdministrativo%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Quantidade de Computadores de uso dos Alunos</td>
            <td><input style="width:100pt" name="txtQuantidadeComputadoresAlunos" type="text" class="form-control" id="txtQuantidadeComputadoresAlunos" size="8" maxlength="8" value="<%=strQuantidadeComputadoresAlunos%>"></td>
          </tr>
          <tr>
            <td height="25" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Recuroso Humanos</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Total de Funcion&aacute;rios da escola ( inclusive professores, auxiliares/assistentes educacionais,<br>
profissionais/monitores de atividade complementar e int&eacute;rpretes de libras)</td>
            <td><input style="width:100pt" name="txtTotalFuncionarioEscola" type="text" class="form-control" id="txtTotalFuncionarioEscola" size="8" maxlength="8" value="<%=strTotalFuncionarioEscola%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Alimenta&ccedil;&atilde;o Escola - PNAE / FNDE</td>
            <td><select name="cmbAlimentacaoEscolaPNAE" id="cmbAlimentacaoEscolaPNAE" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAlimentacaoEscolaPNAE = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAlimentacaoEscolaPNAE = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Alimenta&ccedil;&atilde;o escolar para os alunos</td>
            <td><select name="cmbAlimentacaoEscolaAlunos" id="cmbAlimentacaoEscolaAlunos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAlimentacaoEscolaAlunos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAlimentacaoEscolaAlunos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">              Dados Educacionais<br></td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Atendimento educacional especializado - AEE</td>
            <td><select name="cmbAlimentacaoEducacionalAEE" id="cmbAlimentacaoEducacionalAEE" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAlimentacaoEducacionalAEE = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAlimentacaoEducacionalAEE = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Atividade Complementar </td>
            <td><select name="cmbAtividadeComplementar" id="cmbAtividadeComplementar" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAtividadeComplementar = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAtividadeComplementar = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Modalidade</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Modalidade - Ensino regular</td>
            <td><select name="cmbModalidadeEnsinoRegular" id="cmbModalidadeEnsinoRegular" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strModalidadeEnsinoRegular = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strModalidadeEnsinoRegular = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Modalidade - Educa&ccedil;&atilde;o</td>
            <td><select name="cmbModalidadeEducacional" id="cmbModalidadeEducacional" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strModalidadeEducacional = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strModalidadeEducacional = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Especial - Modalidade Substitutiva</td>
            <td><select name="cmbEspecialModalidadeSubstitutiva" id="cmbEspecialModalidadeSubstitutiva" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecialModalidadeSubstitutiva = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecialModalidadeSubstitutiva = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Modalidade - Educa&ccedil;&atilde;o de jovens e adultos</td>
            <td><select name="cmbModalidadeEducacionalJovensAdultos" id="cmbModalidadeEducacionalJovensAdultos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strModalidadeEducacionalJovensAdultos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strModalidadeEducacionalJovensAdultos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Etapas</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular Educa&ccedil;&atilde;o infantil - Creche ( 0 a 3 anos)</td>
            <td><select name="cmbEtapas0a3Anos" id="cmbEtapas0a3Anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapas0a3Anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapas0a3Anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular Pr&eacute;-Escola ( 4 a 5 anos)</td>
            <td><select name="cmbEtapas4a5Anos" id="cmbEtapas4a5Anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapas4a5Anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapas4a5Anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular Ensino fundamental 8 anos</td>
            <td><select name="cmbEtapas8Anos" id="cmbEtapas8Anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapas8Anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapas8Anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular Ensino fundamental 9 anos</td>
            <td><select name="cmbEtapas9Anos" id="cmbEtapas9Anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapas9Anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapas9Anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular m&eacute;dio - M&eacute;dio </td>
            <td><select name="cmbEtapasMedio" id="cmbEtapasMedio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasMedio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasMedio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular m&eacute;dio - Integrado</td>
            <td><select name="cmbEtapasMedioIntegrado" id="cmbEtapasMedioIntegrado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasMedioIntegrado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasMedioIntegrado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular Ensino m&eacute;dio - Normal/Magisterio</td>
            <td><select name="cmbEtapasNormalMagisterio" id="txtEtapasNormalMagisterio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasNormalMagisterio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasNormalMagisterio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Ensino regular Ensino m&eacute;dio - Educa&ccedil;&atilde;o Profissional</td>
            <td><select name="cmbEtapasEnsinoRegularEducacaoProfissional" id="cmbEtapasEnsinoRegularEducacaoProfissional" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEnsinoRegularEducacaoProfissional = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEnsinoRegularEducacaoProfissional = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Educa&ccedil;&atilde;o infantil - Creche(0 a 3 anos)</td>
            <td><select name="cmbEtapasCreche0a3Anos" id="cmbEtapasCreche0a3Anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasCreche0a3Anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasCreche0a3Anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Educa&ccedil;&atilde;o infantil - Pr&eacute;-escola (4 a 5 anos)</td>
            <td><select name="cmbEtapasCreche4a5Anos" id="cmbEtapasCreche4a5Anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasCreche4a5Anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasCreche4a5Anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Ensino Fundamental 8 anos</td>
            <td><select name="cmbEnsinoFundamental8anos" id="cmbEnsinoFundamental8anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoFundamental8anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoFundamental8anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Ensino Fundamental 9 anos</td>
            <td><select name="cmbEnsinoFundamental9anos" id="cmbEnsinoFundamental9anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoFundamental9anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoFundamental9anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Ensino m&eacute;dio - m&eacute;dio</td>
            <td><select name="cmbEnsinoMedioMedio" id="cmbEnsinoMedioMedio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoMedioMedio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoMedioMedio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Ensino m&eacute;dio - Integrado</td>
            <td><select name="cmbEnsinoMedioIntegrado" id="cmbEnsinoMedioIntegrado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoMedioIntegrado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoMedioIntegrado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Ensino m&eacute;dio - Normal/Magist&eacute;rio</td>
            <td><select name="cmbEtapasEducacaoMagisterio" id="cmbEtapasEducacaoMagisterio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEducacaoMagisterio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEducacaoMagisterio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - Ensino m&eacute;dio - Educa&ccedil;&atilde;o Profissional</td>
            <td><select name="cmbEtapasEducacaoProfissional" id="cmbEtapasEducacaoProfissional" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEducacaoProfissional = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEducacaoProfissional = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - Educa&ccedil;&atilde;o especial - EJA ensino fundametal</td>
            <td><select name="cmbEtapasEducacaoEspecialEJAEnsinoFundametal" id="cmbEtapasEducacaoEspecialEJAEnsinoFundametal" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEducacaoEspecialEJAEnsinoFundametal = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEducacaoEspecialEJAEnsinoFundametal = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - EJA ensino fundametal</td>
            <td><select name="cmbEtapasEJAEnsinoFundametal" id="cmbEtapasEJAEnsinoFundametal" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEJAEnsinoFundametal = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEJAEnsinoFundametal = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - EJA ensino fundametal - Projovem (urbano)</td>
            <td><select name="cmbEtapasEJAEnsinoFundametalProjovem" id="cmbEtapasEJAEnsinoFundametalProjovem" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEJAEnsinoFundametalProjovem = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEJAEnsinoFundametalProjovem = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Etapas - EJA ensino m&eacute;dio</td>
            <td><select name="cmbEtapasEJAEnsinoMedio" id="cmbEtapasEJAEnsinoMedio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapasEJAEnsinoMedio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapasEJAEnsinoMedio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Ensino fundamental organizado em ciclos</td>
            <td><select name="cmbEnsinoFudamentalOrganizadoCiclos" id="cmbEnsinoFudamentalOrganizadoCiclos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoFudamentalOrganizadoCiclos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoFudamentalOrganizadoCiclos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Localiza&ccedil;&atilde;o diferenciada da escola</td>
            <td><select name="cmbLocalizacaoDiferenciadaEscola" id="cmbLocalizacaoDiferenciadaEscola" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strLocalizacaoDiferenciadaEscola = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strLocalizacaoDiferenciadaEscola = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">Materias did&aacute;tivos</td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">Materias did&aacute;ticos espec&iacute;ficos para atendimento &agrave; diversidade s&oacute;cio-cultural - n&atilde;o ultiza</td>
            <td><select name="cmbMateriasUltiza" id="cmbMateriasUltiza" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strMateriasUltiza = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strMateriasUltiza = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Materias did&aacute;ticos espec&iacute;ficos para atendimento &agrave; diversidade s&oacute;cio-cultural - Quilombola</td>
            <td><select name="cmbMateriasQuilombola" id="cmbMateriasQuilombola" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strMateriasQuilombola = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strMateriasQuilombola = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Materias did&aacute;ticos espec&iacute;ficos para atendimento &agrave; diversidade s&oacute;cio-cultural - Ind&iacute;gena</td>
            <td><select name="cmbMateriasIndigina" id="cmbMateriasIndigina" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strMateriasIndigina = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strMateriasIndigina = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Educa&ccedil;&atilde;o ind&iacute;gena</td>
            <td><select name="cmbEducacaoIndigina" id="cmbEducacaoIndigina" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEducacaoIndigina = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEducacaoIndigina = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" colspan="2" bgcolor="#CCCCCC" class="form-controlo1">L&iacute;ngua em que o ensino &eacute; Ministrado </td>
            </tr>
          <tr>
            <td height="25" class="form-controlo1">L&iacute;ngua em que o ensino &eacute; Ministrado - L&iacute;ngua ind&iacute;gena</td>
            <td><select name="cmbLinguaIndigina" id="cmbLinguaIndigina" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strLinguaIndigina = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strLinguaIndigina = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">L&iacute;ngua em que o ensino &eacute; Ministrado - L&iacute;ngua portuguesa</td>
            <td><select name="cmbLinguaPortuguesa" id="cmbLinguaPortuguesa" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strLinguaPortuguesa = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strLinguaPortuguesa = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">C&oacute;digo da l&iacute;ngua ind&iacute;gina</td>
            <td><input style="width:100pt" name="txtCodigoLinguaIndigina" type="text" class="form-control" id="txtCodigoLinguaIndigina" size="8" maxlength="8" value="<%=strCodigoLinguaIndigina%>"></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Escola cede espa&ccedil;o para turmas do Brasil Alfabetizado</td>
            <td><select name="cmbEscolaEspecialTurmasAlfabetizado" id="cmbEscolaEspecialTurmasAlfabetizado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEscolaEspecialTurmasAlfabetizado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEscolaEspecialTurmasAlfabetizado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Escola abre aos finais de semana para a comunidade</td>
            <td><select name="cmbEscolaAbreFinaisSemanaComunidade" id="cmbEscolaAbreFinaisSemanaComunidade" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEscolaAbreFinaisSemanaComunidade = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEscolaAbreFinaisSemanaComunidade = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="form-controlo1">Escola com proposta pedag&oacute;gica de forma&ccedil;&atilde;o por altern&acirc;ncia</td>
            <td><select name="cmbEscolaAlternancia" id="cmbEscolaAlternancia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEscolaAlternancia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEscolaAlternancia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td colspan="2" class="form-controlo1">&nbsp;</td>
            </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
	       </table>
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		frm.action="Registro10_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 