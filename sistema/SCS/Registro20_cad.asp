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
	strPaginaTitulo 								= "Cadastro de Turma - Registro 20"
	intCodEmpresa									= Trim(Request("CodEscola"))
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

	if trim(intCodEmpresa) <> "" then
	     
		sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, CodTurmaInep, CodTurmaEntidadeEscola, NomeTurma, HorarioTurmaHorarioInicialHora, "
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
		sql = sql & " DisciplinasOutrasDisciplinas, TurmaProfissionalSalaAula "
		sql = sql & " FROM REGISTRO20"
		sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEmpresa									= rs("CodEmpresa")
			strTipoRegistro									= rs("TipoRegistro")
			intCodEscolaInep	 							= rs("CodEscolaInep")
			strCodTurmaInep									= rs("CodTurmaInep")
			strCodTurmaEntidadeEscola						= rs("CodTurmaEntidadeEscola")
			
			strNomeTurma									= rs("NomeTurma")
			strHorarioTurmaHorarioInicialHora				= rs("HorarioTurmaHorarioInicialHora")
			strHorarioTurmaHorarioInicialMinuto				= rs("HorarioTurmaHorarioInicialMinuto")
			strHorarioTurmaHorarioFinalHora					= rs("HorarioTurmaHorarioFinalHora")
			strHorarioTurmaHorarioFinalMinuto				= rs("HorarioTurmaHorarioFinalMinuto")
			strDomingo										= rs("Domingo")
			strSegunda										= rs("Segunda")
			strTerca										= rs("Terca")
			strQuarta										= rs("Quarta")
			strQuinta										= rs("Quinta")
			strSexta										= rs("Sexta")
			strSabado										= rs("Sabado")
			strTipoAtendimento								= rs("TipoAtendimento")
			strTurmaParticipanteMaisEducacao				= rs("TurmaParticipanteMaisEducacao")
			strCodigoTipoAtividadeComplementar				= rs("CodigoTipoAtividadeComplementar")
			strCodigoTipoAtividade1							= rs("CodigoTipoAtividade1")
			strCodigoTipoAtividade2							= rs("CodigoTipoAtividade2")
			strCodigoTipoAtividade3							= rs("CodigoTipoAtividade3")
			strCodigoTipoAtividade4							= rs("CodigoTipoAtividade4")
			strCodigoTipoAtividade5							= rs("CodigoTipoAtividade5")
			strCodigoTipoAtividade6 						= rs("CodigoTipoAtividade6")
			strAtividadeAtendimentoAEE						= rs("AtividadeAtendimentoAEE")
			strEnsinoSistemaBraille							= rs("EnsinoSistemaBraille")
			strEnsinoOpticoseNaoOpticos						= rs("EnsinoOpticoseNaoOpticos")
			strEstragiasDesenvolvimentoMetais				= rs("EstragiasDesenvolvimentoMetais")
			strTecnicasOrientacaoMobilidade					= rs("TecnicasOrientacaoMobilidade")
			strEnsinoLinguaLibras							= rs("EnsinoLinguaLibras")
			strEnsinoAlteranativaAumentativaCAA				= rs("EnsinoAlteranativaAumentativaCAA")
			strEstragiasEriquecimentoCurricular				= rs("EstragiasEriquecimentoCurricular")
			strEnsinoUsoSoroban								= rs("EnsinoUsoSoroban")
			strEnsinoUsabilidadeFuncionalidades				= rs("EnsinoUsabilidadeFuncionalidades")
			strEnsinoPortuguesaModalidade					= rs("EnsinoPortuguesaModalidade")
			strEstrategiasAutonomiaAmbienteEscolhar			= rs("EstrategiasAutonomiaAmbienteEscolhar")
			strModalidade									= rs("Modalidade")
			strEtapaEnsino									= rs("EtapaEnsino")
			strCodigoCursoEducacaoProfissional				= rs("CodigoCursoEducacaoProfissional")
			strQuimica										= rs("Quimica")
			strFisica										= rs("Fisica")
			strMatematica									= rs("Matematica")
			strBiologia										= rs("Biologia")
			strCiencia										= rs("Ciencia")
			strPortuguesa									= rs("Portuguesa")
			strDisciplinasLinguaIngles						= rs("DisciplinasLinguaIngles")
			strEspanhol										= rs("Espanhol")
			strFrances										= rs("Frances")
			strEstrangeiraOutra								= rs("EstrangeiraOutra")
			strArtes										= rs("Artes")
			strEducacaoFisica								= rs("EducacaoFisica")
			strHistoria										= rs("Historia")
			strGeografica									= rs("Geografica")
			strFilosofia									= rs("Filosofia")
			strEstudosSociais								= rs("EstudosSociais")
			strSociologia									= rs("Sociologia")
			strDisciplinasInformatica						= rs("DisciplinasInformatica")
			strDisciplinasProfissionalizantes				= rs("DisciplinasProfissionalizantes")
			strDisciplinasInclusivas						= rs("DisciplinasInclusivas")
			strDisciplinasVoltadasPedagogicas				= rs("DisciplinasVoltadasPedagogicas")
			strDisciplinasLIBRAS							= rs("DisciplinasLIBRAS")
			strDisciplinasPedagogicas						= rs("DisciplinasPedagogicas")
			strDisciplinasEnsinoReligioso					= rs("DisciplinasEnsinoReligioso")
			strDisciplinasLinguaIndigina					= rs("DisciplinasLinguaIndigina")
			strDisciplinasOutrasDisciplinas					= rs("DisciplinasOutrasDisciplinas")
			strTurmaProfissionalSalaAula					= rs("TurmaProfissionalSalaAula")
	
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Turma - Registro 20</h3>
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
            <td height="25" class="texto1">Empresa:</td>
            <td><input style="width:100pt" name="txtCodEmpresa" type="text"  class="form-control" id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
          </tr>
          <tr>
            <td width="685" height="25" class="texto1">Tipo de Registro</td>
            <td width="596"><input style="width:100pt" name="txtTipoRegistro" type="text"  class="form-control" id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo de escola - Inep</td>
            <td><input style="width:100pt" name="txtCodEscolaInep" type="text"  onKeyPress="return formataCampo(this,2,10)"  class="form-control" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo da Turma - Inep</td>
            <td><input style="width:100pt" name="txtCodTurmaInep" type="text"  onKeyPress="return formataCampo(this,2,10)"  class="form-control" id="txtCodTurmaInep" size="8" maxlength="8" value="<%=trim(strCodTurmaInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo da Turma na Entidade/Escola</td>
            <td><input style="width:100pt" name="txtCodTurmaEntidadeEscola" type="text"  onKeyPress="return formataCampo(this,2,10)"  class="form-control" id="txtCodTurmaEntidadeEscola" size="8" maxlength="8" value="<%=trim(strCodTurmaEntidadeEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nome da Turma</td>
            <td><input style="width:100pt" name="txtNomeTurma" type="text"  class="form-control" id="txtNomeTurma" size="50" maxlength="50" value="<%=trim(strNomeTurma)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Hor&aacute;rio da Turma - Hor&aacute;rio Inicial - Hora</td>
            <td><input style="width:100pt" name="txtHorarioTurmaHorarioInicialHora" type="text"  class="form-control" id="txtHorarioTurmaHorarioInicialHora" size="8" maxlength="8" value="<%=trim(strHorarioTurmaHorarioInicialHora)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Hor&aacute;rio da Turma - Hor&aacute;rio Inicial - Minuto</td>
            <td><input style="width:100pt" name="txtHorarioTurmaHorarioInicialMinuto" type="text"  class="form-control" id="txtHorarioTurmaHorarioInicialMinuto" size="8" maxlength="8" value="<%=trim(strHorarioTurmaHorarioInicialMinuto)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Hor&aacute;rio da Turma - Hor&aacute;rio Final - Hora</td>
            <td><input style="width:100pt" name="txtHorarioTurmaHorarioFinalHora" type="text"  class="form-control" id="txtHorarioTurmaHorarioFinalHora" size="8" maxlength="8" value="<%=trim(strHorarioTurmaHorarioFinalHora)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Hor&aacute;rio da Turma - Hor&aacute;rio Final - Minuto</td>
            <td><input style="width:100pt" name="txtHorarioTurmaHorarioFinalMinuto" type="text"  class="form-control" id="txtHorarioTurmaHorarioFinalMinuto" size="8" maxlength="8" value="<%=trim(strHorarioTurmaHorarioFinalMinuto)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Domingo</td>
            <td><select name="cmbDomingo" id="cmbDomingo" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDomingo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDomingo = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Segunda -Feira</td>
            <td><select name="cmbSegunda" id="cmbSegunda" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSegunda = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSegunda = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ter&ccedil;a	-Feira</td>
            <td><select name="cmbTerca" id="cmbTerca" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTerca = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTerca = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Quarta	-Feira</td>
            <td><select name="cmbQuarta" id="cmbQuarta" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strQuarta = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strQuarta = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Quinta 	-Feira</td>
            <td><select name="cmbQuinta" id="cmbAbastecimentoAgua5" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strQuinta = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strQuinta = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Sexta	-Feira</td>
            <td><select name="cmbSexta" id="cmbAbastecimentoAgua6" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSexta = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSexta = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">S&aacute;bado</td>
            <td><select name="cmbSabado" id="cmbSabado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSabado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSabado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipo de Atendimento</td>
            <td><select name="cmbTipoAtendimento" id="cmbAbastecimentoAgua8" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTipoAtendimento = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTipoAtendimento = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Turma participante do Programa Mais Educa&ccedil;&atilde;o/Ensino M&eacute;dio Inovador</td>
            <td><select name="cmbTurmaParticipanteMaisEducacao" id="cmbTurmaParticipanteMaisEducacao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTurmaParticipanteMaisEducacao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTurmaParticipanteMaisEducacao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade Complementar</td>
            <td><select name="cmbCodigoTipoAtividadeComplementar" id="cmbCodigoTipoAtividadeComplementar" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividadeComplementar = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividadeComplementar = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade 1</td>
            <td><select name="cmbCodigoTipoAtividade1" id="cmbCodigoTipoAtividade1" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividade1 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividade1 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade 2</td>
            <td><select name="cmbCodigoTipoAtividade2" id="cmbCodigoTipoAtividade2" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividade2 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividade2 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade 3</td>
            <td><select name="cmbCodigoTipoAtividade3" id="cmbCodigoTipoAtividade3" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividade3 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividade3 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade 4</td>
            <td><select name="cmbCodigoTipoAtividade4" id="cmbCodigoTipoAtividade4" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividade4 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividade4 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade 5</td>
            <td><select name="cmbCodigoTipoAtividade5" id="cmbCodigoTipoAtividade5" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividade5 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividade5 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Tipo de Atividade 6</td>
            <td><select name="cmbCodigoTipoAtividade6" id="cmbCodigoTipoAtividade6" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCodigoTipoAtividade6 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCodigoTipoAtividade6 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Atividades do Atendimento Educacional Especializado - AEE</td>
            <td><select name="cmbAtividadeAtendimentoAEE" id="cmbAtividadeAtendimentoAEE" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAtividadeAtendimentoAEE = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAtividadeAtendimentoAEE = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino do Sistema Braille</td>
            <td><select name="cmbEnsinoSistemaBraille" id="cmbEnsinoSistemaBraille" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoSistemaBraille = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoSistemaBraille = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino do uso de recursos &oacute;pitcos e n&atilde;o &oacute;pitcos </td>
            <td><select name="cmbEnsinoOpticoseNaoOpticos" id="cmbEnsinoOpticoseNaoOpticos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoOpticoseNaoOpticos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoOpticoseNaoOpticos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Estrat&eacute;gias para Desenvolvimento de processos metais</td>
            <td><select name="cmbEstragiasDesenvolvimentoMetais" id="cmbEstragiasDesenvolvimentoMetais" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEstragiasDesenvolvimentoMetais = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEstragiasDesenvolvimentoMetais = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">T&eacute;cnica de orienta&ccedil;&atilde;o e mobilidade</td>
            <td><select name="cmbTecnicasOrientacaoMobilidade" id="cmbTecnicasOrientacaoMobilidade" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTecnicasOrientacaoMobilidade = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTecnicasOrientacaoMobilidade = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino da L&iacute;ngua Brasileira de Sinais - Libras</td>
            <td><select name="cmbEnsinoLinguaLibras" id="cmbEnsinoLinguaLibras" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoLinguaLibras = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoLinguaLibras = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino de uso da Comunica&ccedil;&atilde;o Alteranativa e Aumentativa - CAA</td>
            <td><select name="cmbEnsinoAlteranativaAumentativaCAA" id="cmbEnsinoAlteranativaAumentativaCAA" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoAlteranativaAumentativaCAA = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoAlteranativaAumentativaCAA = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Estrag&eacute;gias para Eriquecimento curricular</td>
            <td><select name="cmbEstragiasEriquecimentoCurricular" id="cmbEstragiasEriquecimentoCurricular" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEstragiasEriquecimentoCurricular = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEstragiasEriquecimentoCurricular = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino do uso do Soroban</td>
            <td><select name="cmbEnsinoUsoSoroban" id="cmbEnsinoUsoSoroban" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoUsoSoroban = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoUsoSoroban = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino da Usabilidade e das Funcionalidades da inform&aacute;tica acess&iacute;vel</td>
            <td><select name="cmbEnsinoUsabilidadeFuncionalidades" id="cmbEnsinoUsabilidadeFuncionalidades" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoUsabilidadeFuncionalidades = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoUsabilidadeFuncionalidades = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ensino da L&iacute;ngua Portuguesa na modalidade escrita</td>
            <td><select name="cmbEnsinoPortuguesaModalidade" id="cmbEnsinoPortuguesaModalidade" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEnsinoPortuguesaModalidade = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEnsinoPortuguesaModalidade = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Estrat&eacute;gias para autonomia no ambiente escolhar</td>
            <td><select name="cmbEstrategiasAutonomiaAmbienteEscolhar" id="cmbEstrategiasAutonomiaAmbienteEscolhar" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEstrategiasAutonomiaAmbienteEscolhar = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEstrategiasAutonomiaAmbienteEscolhar = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Modalidade</td>
            <td><select name="cmbModalidade" id="cmbModalidade" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strModalidade = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strModalidade = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Etapa de Ensino</td>
            <td><select name="cmbEtapaEnsino" id="cmbEtapaEnsino" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEtapaEnsino = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEtapaEnsino = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo Curso Educa&ccedil;&atilde;o Profissional</td>
            <td><input style="width:100pt" name="txtCodigoCursoEducacaoProfissional" type="text"  class="form-control" id="txtCodigoCursoEducacaoProfissional" size="8" maxlength="8" value="<%=trim(strCodigoCursoEducacaoProfissional)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 1 - Qu&iacute;mica</td>
            <td><select name="cmbQuimica" id="cmbQuimica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strQuimica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strQuimica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 2 - F&iacute;sica</td>
            <td><select name="cmbFisica" id="cmbFisica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strFisica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strFisica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 3 - Matematica</td>
            <td><select name="cmbMatematica" id="cmbMatematica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strMatematica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strMatematica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 4 - Biologia</td>
            <td><select name="cmbBiologia" id="cmbBiologia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strBiologia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strBiologia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 5 - Ci&ecirc;ncias</td>
            <td><select name="cmbCiencia" id="cmbCiencia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCiencia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCiencia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 6 - l&iacute;ngua / Literatura Portuguesa</td>
            <td><select name="cmbPortuguesa" id="cmbPortuguesa" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strPortuguesa = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strPortuguesa = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 7 - l&iacute;ngua / Literatira Estrangeira - Ingl&ecirc;s</td>
            <td><select name="cmbDisciplinasLinguaIngles" id="cmbDisciplinasLinguaIngles" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasLinguaIngles = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasLinguaIngles = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 8 - l&iacute;ngua / Literatira Estrangeira - Espanhol</td>
            <td><select name="cmbEspanhol" id="cmbEspanhol" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspanhol = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspanhol = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 30 - l&iacute;ngua / Literatira Estrangeira - Franc&ecirc;s</td>
            <td><select name="cmbFrances" id="cmbFrances" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strFrances = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strFrances = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 9 - l&iacute;ngua / Literatira Estrangeira - Outra</td>
            <td><select name="cmbEstrangeiraOutra" id="cmbEstrangeiraOutra" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEstrangeiraOutra = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEstrangeiraOutra = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 10 - Artes (educa&ccedil;&atilde;o art&iacute;stica, teatro, dan&ccedil;a, m&uacute;sica, artes pl&aacute;sticas e outras)</td>
            <td><select name="cmbArtes" id="cmbArtes" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strArtes = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strArtes = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 11 - Educa&ccedil;&atilde;o f&iacute;sica</td>
            <td><select name="cmbEducacaoFisica" id="cmbEducacaoFisica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEducacaoFisica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEducacaoFisica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 12 - Hist&oacute;ria</td>
            <td><select name="cmbHistoria" id="cmbHistoria" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strHistoria = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strHistoria = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 13 - Geografica</td>
            <td><select name="cmbGeografica" id="cmbGeografica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strGeografica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strGeografica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 14 - Filosofia</td>
            <td><select name="cmbFilosofia" id="cmbFilosofia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strFilosofia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strFilosofia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 28 - Estudos sociais</td>
            <td><select name="cmbEstudosSociais" id="cmbEstudosSociais" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEstudosSociais = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEstudosSociais = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 29 - Sociologia</td>
            <td><select name="cmbSociologia" id="cmbSociologia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSociologia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSociologia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 16 - Inform&aacute;tica/Computa&ccedil;&atilde;o</td>
            <td><select name="cmbDisciplinasInformatica" id="cmbDisciplinasInformatica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasInformatica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasInformatica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 17 - Disciplinas profissionalizantes</td>
            <td><select name="cmbDisciplinasProfissionalizantes" id="cmbDisciplinasProfissionalizantes" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasProfissionalizantes = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasProfissionalizantes = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 20 - Disciplinas voltadas ao atendimento &aacute;s necessidades educacionais espec&iacute;ficas dos alunos que s&atilde;o<br>
              p&uacute;blico alvo da educa&ccedil;&atilde;o especial e as pr&aacute;ticas educacionais inclusivas.</td>
            <td><select name="cmbDisciplinasInclusivas" id="cmbDisciplinasInclusivas" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasInclusivas = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasInclusivas = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 21 - Disciplinas  voltadas &agrave; diversidade sociocultural ( Disciplinas pedag&oacute;gicas )</td>
            <td><select name="cmbDisciplinasVoltadasPedagogicas" id="cmbDisciplinasVoltadasPedagogicas" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasVoltadasPedagogicas = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasVoltadasPedagogicas = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 23 - LIBRAS</td>
            <td><select name="cmbDisciplinasLIBRAS" id="cmbDisciplinasLIBRAS" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasLIBRAS = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasLIBRAS = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 25 - Disciplinas pedag&oacute;gicas</td>
            <td><select name="cmbDisciplinasPedagogicas" id="cmbDisciplinasPedagogicas" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasPedagogicas = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasPedagogicas = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 26 - Ensino religioso</td>
            <td><select name="cmbDisciplinasEnsinoReligioso" id="cmbDisciplinasEnsinoReligioso" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasEnsinoReligioso = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasEnsinoReligioso = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 27 - L&iacute;ngua ind&iacute;gena </td>
            <td><select name="cmbDisciplinasLinguaIndigina" id="cmbDisciplinasLinguaIndigina" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasLinguaIndigina = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasLinguaIndigina = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Disciplinas - 99 - Outras Disciplinas </td>
            <td><select name="cmbDisciplinasOutrasDisciplinas" id="cmbDisciplinasOutrasDisciplinas" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDisciplinasOutrasDisciplinas = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDisciplinasOutrasDisciplinas = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Turma Sem Profissional Escola em Sala de Aula</td>
            <td><select name="cmbTurmaProfissionalSalaAula" id="cmbTurmaProfissionalSalaAula" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTurmaProfissionalSalaAula = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTurmaProfissionalSalaAula = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
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
		frm.action="Registro20_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 