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
	inttCodEscolaInep	 							= Trim(Request.Form("txtCodEscolaInep"))
	strCodTurmaInep									= Trim(Request.Form("txtCodTurmaInep"))
	strCodTurmaEntidadeEscola						= Trim(Request.Form("txtCodTurmaEntidadeEscola"))
	strNomeTurma									= Trim(Request.Form("txtNomeTurma"))
	
	strHorarioTurmaHorarioInicialHora				= Trim(Request.Form("txtHorarioTurmaHorarioInicialHora"))
	strHorarioTurmaHorarioInicialMinuto				= Trim(Request.Form("txtHorarioTurmaHorarioInicialMinuto"))
	strHorarioTurmaHorarioFinalHora					= Trim(Request.Form("txtHorarioTurmaHorarioFinalHora"))
	strHorarioTurmaHorarioFinalMinuto				= Trim(Request.Form("txtHorarioTurmaHorarioFinalMinuto"))
	strDomingo										= Trim(Request.Form("cmbDomingo"))
	strSegunda										= Trim(Request.Form("cmbSegunda"))
	strTerca										= Trim(Request.Form("cmbTerca"))
	strQuarta										= Trim(Request.Form("cmbQuarta"))
	strQuinta										= Trim(Request.Form("cmbQuinta"))
	strSexta										= Trim(Request.Form("cmbSexta"))
	strSabado										= Trim(Request.Form("cmbSabado"))
	strTipoAtendimento								= Trim(Request.Form("cmbTipoAtendimento"))
	strTurmaParticipanteMaisEducacao				= Trim(Request.Form("cmbTurmaParticipanteMaisEducacao"))
	strCodigoTipoAtividadeComplementar				= Trim(Request.Form("cmbCodigoTipoAtividadeComplementar"))
	strCodigoTipoAtividade1							= Trim(Request.Form("cmbCodigoTipoAtividade1"))
	strCodigoTipoAtividade2							= Trim(Request.Form("cmbCodigoTipoAtividade2"))
	strCodigoTipoAtividade3							= Trim(Request.Form("cmbCodigoTipoAtividade3"))
	strCodigoTipoAtividade4							= Trim(Request.Form("cmbCodigoTipoAtividade4"))
	strCodigoTipoAtividade5							= Trim(Request.Form("cmbCodigoTipoAtividade5"))
	strCodigoTipoAtividade6							= Trim(Request.Form("cmbCodigoTipoAtividade6"))
	
	strAtividadeAtendimentoAEE						= Trim(Request.Form("cmbAtividadeAtendimentoAEE"))
	strEnsinoSistemaBraille							= Trim(Request.Form("cmbEnsinoSistemaBraille"))
	strEnsinoOpticoseNaoOpticos						= Trim(Request.Form("cmbEnsinoOpticoseNaoOpticos"))
	strEstragiasDesenvolvimentoMetais				= Trim(Request.Form("cmbEstragiasDesenvolvimentoMetais"))
	strTecnicasOrientacaoMobilidade					= Trim(Request.Form("cmbTecnicasOrientacaoMobilidade"))
	strEnsinoLinguaLibras							= Trim(Request.Form("cmbEnsinoLinguaLibras"))
	strEnsinoAlteranativaAumentativaCAA				= Trim(Request.Form("cmbEnsinoAlteranativaAumentativaCAA"))
	strEstragiasEriquecimentoCurricular				= Trim(Request.Form("cmbEstragiasEriquecimentoCurricular"))
	strEnsinoUsoSoroban								= Trim(Request.Form("cmbEnsinoUsoSoroban"))
	strEnsinoUsabilidadeFuncionalidades				= Trim(Request.Form("cmbEnsinoUsabilidadeFuncionalidades"))
	strEnsinoPortuguesaModalidade					= Trim(Request.Form("cmbEnsinoPortuguesaModalidade"))
	strEstrategiasAutonomiaAmbienteEscolhar			= Trim(Request.Form("cmbEstrategiasAutonomiaAmbienteEscolhar"))
	strModalidade									= Trim(Request.Form("cmbModalidade"))
	strEtapaEnsino									= Trim(Request.Form("cmbEtapaEnsino"))
	strCodigoCursoEducacaoProfissional				= Trim(Request.Form("txtCodigoCursoEducacaoProfissional"))
	strQuimica										= Trim(Request.Form("cmbQuimica"))
	strFisica										= Trim(Request.Form("cmbFisica"))
	strMatematica									= Trim(Request.Form("cmbMatematica"))
	strBiologia										= Trim(Request.Form("cmbBiologia"))
	strCiencia										= Trim(Request.Form("cmbCiencia"))
	strPortuguesa									= Trim(Request.Form("cmbPortuguesa"))
	strDisciplinasLinguaIngles						= Trim(Request.Form("cmbDisciplinasLinguaIngles"))
	strEspanhol										= Trim(Request.Form("cmbEspanhol"))
	strFrances										= Trim(Request.Form("cmbFrances"))
	strEstrangeiraOutra								= Trim(Request.Form("cmbEstrangeiraOutra"))
	strArtes										= Trim(Request.Form("cmbArtes"))
	strEducacaoFisica								= Trim(Request.Form("cmbEducacaoFisica"))
	strHistoria										= Trim(Request.Form("cmbHistoria"))
	strGeografica									= Trim(Request.Form("cmbGeografica"))
	strFilosofia									= Trim(Request.Form("cmbFilosofia"))
	strEstudosSociais								= Trim(Request.Form("cmbEstudosSociais"))
	strSociologia									= Trim(Request.Form("cmbSociologia"))
	strDisciplinasInformatica						= Trim(Request.Form("cmbDisciplinasInformatica"))
	strDisciplinasProfissionalizantes				= Trim(Request.Form("cmbDisciplinasProfissionalizantes"))
	strDisciplinasInclusivas						= Trim(Request.Form("cmbDisciplinasInclusivas"))
	strDisciplinasVoltadasPedagogicas				= Trim(Request.Form("cmbDisciplinasVoltadasPedagogicas"))
	strDisciplinasLIBRAS							= Trim(Request.Form("cmbDisciplinasLIBRAS"))
	strDisciplinasPedagogicas						= Trim(Request.Form("cmbDisciplinasPedagogicas"))
	strDisciplinasEnsinoReligioso					= Trim(Request.Form("cmbDisciplinasEnsinoReligioso"))
	strDisciplinasLinguaIndigina					= Trim(Request.Form("cmbDisciplinasLinguaIndigina"))
	strDisciplinasOutrasDisciplinas					= Trim(Request.Form("cmbDisciplinasOutrasDisciplinas"))
	strTurmaProfissionalSalaAula					= Trim(Request.Form("cmbTurmaProfissionalSalaAula"))
	'-----------------------------------------------------------------------------------------------------------------------------------------------------
	
	if acao="I" then
		
		strMensagem = "Turma Salva com sucesso..."
		
		sql = "Delete From REGISTRO20 "
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		cnn.execute sql
		
		sql = "Insert Into REGISTRO20( CodEmpresa, TipoRegistro, CodEscolaInep, CodTurmaInep, CodTurmaEntidadeEscola, NomeTurma, HorarioTurmaHorarioInicialHora, "
		sql = sql & " HorarioTurmaHorarioInicialMinuto, HorarioTurmaHorarioFinalHora, HorarioTurmaHorarioFinalMinuto, "
		sql = sql & " Domingo, Segunda,Terca, Quarta, Quinta, Sexta, Sabado, "
		sql = sql & " TipoAtendimento, TurmaParticipanteMaisEducacao, CodigoTipoAtividadeComplementar,  "
		sql = sql & " CodigoTipoAtividade1	, CodigoTipoAtividade2, CodigoTipoAtividade3, CodigoTipoAtividade4, CodigoTipoAtividade5, CodigoTipoAtividade6, "
		sql = sql & " AtividadeAtendimentoAEE, EnsinoSistemaBraille, EnsinoOpticoseNaoOpticos, EstragiasDesenvolvimentoMetais, TecnicasOrientacaoMobilidade, EnsinoLinguaLibras, "
		sql = sql & " EnsinoAlteranativaAumentativaCAA, EstragiasEriquecimentoCurricular, EnsinoUsoSoroban, EnsinoUsabilidadeFuncionalidades, EnsinoPortuguesaModalidade," 
		sql = sql & " EstrategiasAutonomiaAmbienteEscolhar, Modalidade, EtapaEnsino, "
		sql = sql & " CodigoCursoEducacaoProfissional, Quimica, Fisica, Matematica, Biologia, Ciencia, Portuguesa, DisciplinasLinguaIngles, Espanhol, Frances, "
		sql = sql & " EstrangeiraOutra, Artes, EducacaoFisica, Historia, Geografica,  Filosofia, EstudosSociais, Sociologia, DisciplinasInformatica, DisciplinasProfissionalizantes, "
		sql = sql & " DisciplinasInclusivas, DisciplinasVoltadasPedagogicas, DisciplinasLIBRAS, DisciplinasPedagogicas,  DisciplinasEnsinoReligioso, DisciplinasLinguaIndigina,   "
		sql = sql & " DisciplinasOutrasDisciplinas, TurmaProfissionalSalaAula )"
		
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strTipoRegistro & "',"
		sql = sql & "'" & inttCodEscolaInep & "',"
		sql = sql & "'" & strCodTurmaInep & "',"
		sql = sql & "'" & strCodTurmaEntidadeEscola & "',"
		sql = sql & "'" & strNomeTurma & "',"
		sql = sql & "'" & strHorarioTurmaHorarioInicialHora & "',"
		sql = sql & "'" & strHorarioTurmaHorarioInicialMinuto & "',"
		sql = sql & "'" & strHorarioTurmaHorarioFinalHora & "',"
		sql = sql & "'" & strHorarioTurmaHorarioFinalMinuto & "',"
		sql = sql & "'" & strDomingo & "',"
		sql = sql & "'" & strSegunda & "',"
		sql = sql & "'" & strTerca & "',"
		sql = sql & "'" & strQuarta & "',"
		sql = sql & "'" & strQuinta & "',"
		sql = sql & "'" & strSexta & "',"
		sql = sql & "'" & strSabado & "',"
		sql = sql & "'" & strTipoAtendimento & "',"
		sql = sql & "'" & strTurmaParticipanteMaisEducacao & "',"
		sql = sql & "'" & strCodigoTipoAtividadeComplementar & "',"
		sql = sql & "'" & strCodigoTipoAtividade1 & "',"
		sql = sql & "'" & strCodigoTipoAtividade2 & "',"
		sql = sql & "'" & strCodigoTipoAtividade3 & "',"
		sql = sql & "'" & strCodigoTipoAtividade4 & "',"
		sql = sql & "'" & strCodigoTipoAtividade5 & "',"
		sql = sql & "'" & strCodigoTipoAtividade6 & "',"
		sql = sql & "'" & strAtividadeAtendimentoAEE & "',"
		sql = sql & "'" & strEnsinoSistemaBraille & "',"
		sql = sql & "'" & strEnsinoOpticoseNaoOpticos & "',"
		sql = sql & "'" & strEstragiasDesenvolvimentoMetais & "',"
		sql = sql & "'" & strTecnicasOrientacaoMobilidade & "',"
		sql = sql & "'" & strEnsinoLinguaLibras & "',"
		sql = sql & "'" & strEnsinoAlteranativaAumentativaCAA & "',"
		sql = sql & "'" & strEstragiasEriquecimentoCurricular & "',"
		sql = sql & "'" & strEnsinoUsoSoroban & "',"
		sql = sql & "'" & strEnsinoUsabilidadeFuncionalidades & "',"
		sql = sql & "'" & strEnsinoPortuguesaModalidade & "',"
		sql = sql & "'" & strEstrategiasAutonomiaAmbienteEscolhar & "',"
		sql = sql & "'" & strModalidade & "',"
		sql = sql & "'" & strEtapaEnsino & "',"
		sql = sql & "'" & strCodigoCursoEducacaoProfissional & "',"
		sql = sql & "'" & strQuimica & "',"
		sql = sql & "'" & strFisica & "',"
		sql = sql & "'" & strMatematica & "',"
		sql = sql & "'" & strBiologia & "',"
		sql = sql & "'" & strCiencia & "',"
		sql = sql & "'" & strPortuguesa & "',"
		sql = sql & "'" & strDisciplinasLinguaIngles & "',"
		sql = sql & "'" & strEspanhol & "',"
		sql = sql & "'" & strFrances & "',"
		sql = sql & "'" & strEstrangeiraOutra & "',"
		sql = sql & "'" & strArtes & "',"
		sql = sql & "'" & strEducacaoFisica & "',"
		sql = sql & "'" & strHistoria & "',"
		sql = sql & "'" & strGeografica & "',"
		sql = sql & "'" & strFilosofia & "',"
		sql = sql & "'" & strEstudosSociais & "',"
		sql = sql & "'" & strSociologia & "',"
		sql = sql & "'" & strDisciplinasInformatica & "',"
		sql = sql & "'" & strDisciplinasProfissionalizantes & "',"
		sql = sql & "'" & strDisciplinasInclusivas & "',"
		sql = sql & "'" & strDisciplinasVoltadasPedagogicas & "',"
		sql = sql & "'" & strDisciplinasLIBRAS & "',"
		sql = sql & "'" & strDisciplinasPedagogicas & "',"
		sql = sql & "'" & strDisciplinasEnsinoReligioso & "',"
		sql = sql & "'" & strDisciplinasLinguaIndigina & "',"
		sql = sql & "'" & strDisciplinasOutrasDisciplinas & "',"
		sql = sql & "'" & strTurmaProfissionalSalaAula & "')"
		cnn.execute sql
	
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From REGISTRO20 "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		cnn.execute sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		
		<script>
			alert("<%=strMensagem%>");
			window.location='Registro20_con.asp';
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