<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>
            Gemul Portal do Aluno - Ficha do aluno 
        </title>
        <meta name="description" content="Basic Tables">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no, minimal-ui">
        <!-- Call App Mode on ios devices -->
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <!-- Remove Tap Highlight on Windows Phone IE -->
        <meta name="msapplication-tap-highlight" content="no">
        <!-- base css -->
        <link rel="stylesheet" media="screen, print" href="css/vendors.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/app.bundle.css">
        <!-- Place favicon.ico in the root directory -->
        <link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
        <link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg" color="#5bbad5">
		<link id="myskin" rel="stylesheet" media="screen, print" href="css/themes/cust-theme-4.css">
    </head>
    <body class="mod-bg-1 ">
        <!-- DOC: script to save and load page settings -->
        <script>
            /**
             *	This script should be placed right after the body tag for fast execution 
             *	Note: the script is written in pure javascript and does not depend on thirdparty library
             **/
            'use strict';

            var classHolder = document.getElementsByTagName("BODY")[0],
                /** 
                 * Load from localstorage
                 **/
                themeSettings = (localStorage.getItem('themeSettings')) ? JSON.parse(localStorage.getItem('themeSettings')) :
                {},
                themeURL = themeSettings.themeURL || '',
                themeOptions = themeSettings.themeOptions || '';
            /** 
             * Load theme options
             **/
            if (themeSettings.themeOptions)
            {
                classHolder.className = themeSettings.themeOptions;
                console.log("%c? Theme settings loaded", "color: #148f32");
            }
            else
            {
                console.log("Heads up! Theme settings is empty or does not exist, loading default settings...");
            }
            if (themeSettings.themeURL && !document.getElementById('mytheme'))
            {
                var cssfile = document.createElement('link');
                cssfile.id = 'mytheme';
                cssfile.rel = 'stylesheet';
                cssfile.href = themeURL;
                document.getElementsByTagName('head')[0].appendChild(cssfile);
            }
            /** 
             * Save to localstorage 
             **/
            var saveSettings = function()
            {
                themeSettings.themeOptions = String(classHolder.className).split(/[^\w-]+/).filter(function(item)
                {
                    return /^(nav|header|mod|display)-/i.test(item);
                }).join(' ');
                if (document.getElementById('mytheme'))
                {
                    themeSettings.themeURL = document.getElementById('mytheme').getAttribute("href");
                };
                localStorage.setItem('themeSettings', JSON.stringify(themeSettings));
            }
            /** 
             * Reset settings
             **/
            var resetSettings = function()
            {
                localStorage.setItem("themeSettings", "");
            }

        </script>
        <!-- BEGIN Page Wrapper -->
        <div class="page-wrapper">
            <div class="page-inner">
			<%item_ativo_ficha		= " class='active' "%>
			
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
				
					<!--#include file="inc_cabecalho_pagina.asp"-->
				
                    
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL</a></li>
                            <li class="breadcrumb-item">Ficha</li>
                            <li class="breadcrumb-item active">Aluno</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon ni ni-bag'></i> Ficha do aluno <sup class='badge badge-primary fw-500'><%=Session("Periodo_GemulEad")%></sup>
                                <small>
                                    Ficha cadastral do aluno
                                </small>
                            </h1>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
<%


	strCod_empresa = Session("CodEmpresaAluno_GemulEad")
	strCodAluno = trim(Session("CodAluno_GemulEad"))
				
	sql = "SELECT S.Desc_SituacaoAluno, "
	sql = sql & " P.Desc_Profissao AS profissao,"
	sql = sql & " EC.Desc_EstadoCivil AS EstadoCivil,"
	sql = sql & " R.Desc_Religiao	AS Religiao,"
	sql = sql & " NE.Desc_NecEspecial AS NececidadeEspecial,"
	sql = sql & " PP.Desc_Profissao AS profissaoPai,"
	sql = sql & " PM.Desc_Profissao AS profissaoMae,"
	sql = sql & " GIP.Descricao AS GrauInstrucaoPai,"
	sql = sql & " GIM.Descricao AS GrauInstrucaoMae,"
	sql = sql & " PR.Desc_Profissao AS profissaoResp,"
	sql = sql & " GIR.Descricao AS GrauInstrucaoResp,"
	sql = sql & " UFI.Sigla AS descUFIDENTIDADE,"
	sql = sql & " UFN.Sigla AS descUFNASCIMENTO,"
	sql = sql & " UFR.Sigla AS descUfresidencia,"
	sql = sql & " O.DESCRICAO AS FORMAINGRESSO,"
	sql = sql & " A.* "
	sql = sql & " FROM SCA_ALUNO A "
	sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S	ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
	sql = sql & " LEFT JOIN SCA_PROFISSAO P		ON P.COD_PROFISSAO = A.COD_PROFISSAO "
	sql = sql & " LEFT JOIN SCA_ESTADOCIVIL EC	ON EC.COD_EstadoCivil = A.COD_EstadoCivil"
	sql = sql & " LEFT JOIN SCA_RELIGIAO R		ON R.COD_RELIGIAO = A.COD_RELIGIAO"
	sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.COD_NECESPECIAL = A.COD_NECESPECIAL"
	sql = sql & " LEFT JOIN SCA_PROFISSAO PP		ON PP.COD_PROFISSAO = A.PAI_COD_PROFISSAO "
	sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIP ON GIP.CODIGO = A.PAI_COD_GRAUINSTRUCAO "
	sql = sql & " LEFT JOIN SCA_PROFISSAO PM		ON PM.COD_PROFISSAO = A.MAE_COD_PROFISSAO "
	sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIM ON GIM.CODIGO = A.MAE_COD_GRAUINSTRUCAO "
	sql = sql & " LEFT JOIN SCA_PROFISSAO PR		ON PR.COD_PROFISSAO = A.RESPONSAVEL_COD_PROFISSAO "
	sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIR ON GIR.CODIGO = A.RESPONSAVEL_COD_GRAUINSTRUCAO "
	sql = sql & " LEFT JOIN SCF_UF UFI				ON UFI.CODIGO = A.IdentidadeUF "
	sql = sql & " LEFT JOIN SCF_UF UFN				ON UFN.CODIGO = A.UFNASCIMENTO "
	sql = sql & " LEFT JOIN SCF_UF UFR				ON UFR.CODIGO = A.UFRESIDENCIA "
	sql = sql & " LEFT JOIN SCA_FORMAINGRESSO O		ON O.CODIGO = A.COD_FORMAINGRESSO "
	sql = sql & " Where A.codigo = " & strCodAluno
	rs.open sql, cnn
	if rs.eof = false then
		strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
		'dados pessoais
		strCodigo			= TRIM(rs("Codigo"))
		strMatricula 		= TRIM(rs("Matricula"))
		strNomealuno 		= TRIM(rs("Nomealuno"))
		strDatamatricula 	= formataDataAP(TRIM(rs("Datamatricula")))
		strNumeroRegistroNascimento  = TRIM(rs("NUMREGISTRONASC"))
		strSexo		 		= TRIM(rs("SexoAluno"))
		if strSexo = "M" then strSexo = "Masculino"
		if strSexo = "F" then strSexo = "Feminino"
		
		strDatanascimento 	= formataDataAP(TRIM(rs("Datanascimento")))
		strCidadenascimento = TRIM(rs("Cidadenascimento"))
		strUfnascimento 	= TRIM(rs("descUfnascimento"))
		strNacionalidade 	= TRIM(rs("Nacionalidade"))
		strEstadocivil 		= TRIM(rs("EstadoCivil"))
		strProfissao 		= TRIM(rs("Profissao"))
		strReligiao 		= TRIM(rs("Religiao"))
		strNecessidadeEspecial 	= TRIM(rs("NececidadeEspecial"))
		strAtendimentoespecial 	= TRIM(rs("Atendimentoespecial"))
		if strAtendimentoespecial = "S" then strAtendimentoespecial = "Sim"
		if strAtendimentoespecial = "N" then strAtendimentoespecial = "Não"
		strFoneResidencial 	= TRIM(rs("FoneResidencial"))
		strFonecomercial 	= TRIM(rs("Fonecomercial"))
		strFoneCelular	 	= TRIM(rs("Fonecelular"))
		strEmail 			= TRIM(rs("Email"))
		
		'endereço
		strLogradouro 		= TRIM(rs("Logradouro"))
		strNumero_endereco 	= TRIM(rs("Numero_endereco"))
		strComp_endereco 	= TRIM(rs("Comp_endereco"))
		strBairroaluno 		= TRIM(rs("Bairroaluno"))
		strCidaderesidencia	= TRIM(rs("Cidaderesidencia"))
		strUfresidencia 	= TRIM(rs("descUfresidencia"))
		strCepresidencia 	= TRIM(rs("Cepresidencia"))
		
		'dados familiares
		strPai 				= TRIM(rs("Pai"))
		strPaifalecido 		= TRIM(rs("Paifalecido"))
		if strPaifalecido = "S" then strPaifalecido = "Sim"
		if strPaifalecido = "N" then strPaifalecido = "Não"
		
		
		strPaifone 			= TRIM(rs("Paifone"))
		strPaidatanascimento= formataDataAP(TRIM(rs("Paidatanascimento")))
		strProfissaoPai= TRIM(rs("profissaoPai"))
		strGrauInstrucaoPai= TRIM(rs("grauinstrucaoPai"))

		strMae 				= TRIM(rs("Mae"))
		strMaefalecida 		= TRIM(rs("Maefalecida"))
		if strMaefalecida = "S" then strMaefalecida = "Sim"
		if strMaefalecida = "N" then strMaefalecida = "Não"
		
		
		strMaefone 			= TRIM(rs("Maefone"))
		strMaedatanascimento= formataDataAP(TRIM(rs("Maedatanascimento")))
		strProfissaoMae= TRIM(rs("profissaoMae"))
		strGrauInstrucaoMae= TRIM(rs("grauinstrucaoMae"))

		strResponsavel 				= TRIM(rs("Responsavel"))
		strResponsavelfone 			= TRIM(rs("Responsavelfone"))
		strResponsaveldatanascimento= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
		strProfissaoResponsavel= TRIM(rs("profissaoResp"))
		strGrauInstrucaoResponsavel= TRIM(rs("grauinstrucaoResp"))

		intQtdeIrmao 		= TRIM(rs("Qtde_irmao"))
		intQtdeIrmaoEscola	= TRIM(rs("Qtde_irmao_escola"))

		'documentos
		strIdentidade 		= TRIM(rs("Identidade"))
		strIdentidadeOrgao	= TRIM(rs("IdentidadeOrgao"))
		strIdentidadeUF		= TRIM(rs("descUFIDENTIDADE"))
		
		strTituloNumero 	= TRIM(rs("TituloEleitor"))
		strTituloZona	 	= TRIM(rs("TituloZona"))
		strTituloSecao	 	= TRIM(rs("TituloSecao"))
		
		strRegmilitar 		= TRIM(rs("Regmilitar"))
		strCpfaluno 		= formataCpfAP(TRIM(rs("Cpf")))
		
		'dados escolares
		'intCodGradeCompleta	= TRIM(rs("Cod_gradevestibular"))
		strMesanovestibular = TRIM(rs("Mesanovestibular"))
	
		strFormaIngresso 		= TRIM(rs("FormaIngresso"))
		strDataingresso 	= formataDataAP(TRIM(rs("Dataingresso")))
		strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
	
		strDatafastamento 	= formataDataAP(TRIM(rs("Datafastamento")))
		strCod_motivoafastamento	= TRIM(rs("Cod_motivoafastamento"))
		strObsafastamento 	= TRIM(rs("Obsafastamento"))
	
		strDatacolacao 		= formataDataAP(TRIM(rs("Datacolacao")))
		strAnoconclusao 	= TRIM(rs("Anoconclusao"))
		strSemconclusao 	= TRIM(rs("Semconclusao"))
		strDatacertificado 	= formataDataAP(TRIM(rs("Datacertificado")))
	
		intViaCarterinha 	= TRIM(rs("Ctrviace"))
		strSetransp 		= TRIM(rs("Setransp"))
	
		'dados finaceiro
		'intCodPlanoPagamento 	= TRIM(rs("cod_PlanoTurma"))
		strDesconto 		= TRIM(rs("Desconto"))
	
		strLogradouro_cobranca 		= TRIM(rs("Logradouro_cobranca"))
		strNumero_endereco_cobranca	= TRIM(rs("Numero_endereco_cobranca"))
		strComp_endereco_cobranca 	= TRIM(rs("Comp_endereco_cobranca"))
	
		RESPONSAVEL_QUEM 				= Trim(rs("RESPONSAVEL_QUEM"))
		RESPOSAVEL_POSSUI_DOCUMENTACAO 	= Trim(rs("RESPOSAVEL_POSSUI_DOCUMENTACAO"))
		if RESPOSAVEL_POSSUI_DOCUMENTACAO = "S" then RESPOSAVEL_POSSUI_DOCUMENTACAO = "Sim"
		if RESPOSAVEL_POSSUI_DOCUMENTACAO = "N" then RESPOSAVEL_POSSUI_DOCUMENTACAO = "Não"
		RESPONSAVEL_GRAU_PARESTESCO= Trim(rs("RESPONSAVEL_GRAU_PARESTESCO"))
		MEDICAMENTO_CONTROLADO 		= Trim(rs("MEDICAMENTO_CONTROLADO"))
		MEDICAMENTO_CONTROLADO_QUAL = Trim(rs("MEDICAMENTO_CONTROLADO_QUAL"))
		TRANSPORTE_ESCOLAR 			= Trim(rs("TRANSPORTE_ESCOLAR"))
		AUTORIZA_USO_IMAGEM 		= Trim(rs("AUTORIZA_USO_IMAGEM"))
		RESTRICAO_ALIMENTAR 		= Trim(rs("RESTRICAO_ALIMENTAR"))
		RESTRICAO_ALIMENTAR_QUAL 	= Trim(rs("RESTRICAO_ALIMENTAR_QUAL"))
		
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir


		
		strTurma = Session("Turma_GemulEad")
	
				%>
				
				<!--Table hover-->
                                <div id="panel-5" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            Ficha do Aluno
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
                                            <div class="frame-wrap">
											
											<div class="table-responsive-lg">
				
				
				
					<table class="table table-bordered table-hover m-0">
					  <tr valign="top">
						<td colspan="2" align="center">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="457" height="20" bgcolor="#EEEEEE"><li><strong>Dados Pessoais</strong></li></td>
							<td width="246" height="20" bgcolor="#EEEEEE" align="right">Situa&ccedil;&atilde;o: <strong><%=strSituacaoAluno%></strong>&nbsp;&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS PESSOAIS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td >&nbsp;Matr&iacute;cula: </td>
									<td  colspan="2"><strong><%=strMatricula%></strong></td>
									<td rowspan="4" align="center"><img src="<%=session("strFotoAluno")%>" alt="<%=Session("NomeAluno_GemulEad")%>"></td>
								  </tr>
								  <tr>
									<td width="18%">&nbsp;Nome Completo: </td>
									<td  colspan="3" width="36%"><strong><%=strNomealuno%></strong></td>
									
								  </tr>
								  
								  <tr>
								    <td width="16%">&nbsp;Data Nascimento: </td>
									<td  colspan="3" width="36%"><strong><%=strDatanascimento%></strong></td>
							      </tr>
								  <tr>
								    <td>&nbsp;Data Matr&iacute;cula: </td>
								    <td  colspan="3"><strong><%=strDatamatricula%></strong></td>
							      </tr>
								  <tr>
								    <td>&nbsp;N. Reg. Nasc.: </td>
								    <td><strong><%=strNumeroRegistroNascimento%></strong></td>
									<td>&nbsp;Naturalidade: </td>
									<td><strong><%=strCidadenascimento%></strong></td>
								  </tr>
								  <tr>
								    <td>&nbsp;Nacionalidade:</td>
								    <td><strong><%=strNacionalidade%></strong></td>
									<td>&nbsp;CPF:</td>
								    <td><strong><%=strCpfaluno%></strong></td>
							      </tr>
								  <tr>
									<td>&nbsp;Profiss&atilde;o: </td>
									<td><strong><%=strProfissao%></strong></td>
									<td>&nbsp;Sexo: </td>
								    <td><strong><%=strSexo%></strong></td>

								  </tr>
								  <tr>
									<td>&nbsp;Est. Civil:</td>
									<td><strong><%=strEstadoCivil%></strong></td>
									<td>&nbsp;Religi&atilde;o: </td>
									<td><strong><%=strReligiao%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Fone Residencial: </td>
									<td><strong><%=strFoneResidencial%></strong></td>
									<td>&nbsp;Celular: </td>
									<td><strong><%=strFonecelular%></strong></td>
								  </tr>
								  
								  <tr>
									<td>&nbsp;Nec. Especiais: </td>
									<td><strong><%=strNecessidadeEspecial%></strong></td>
									<td>&nbsp;Atend. Especial : </td>
									<td><strong><%=strAtendimentoespecial%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;E-mail: </td>
									<td colspan="3"><strong><%=strEmail%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" ><li><strong>Endereço</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS ENDEREÇO-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosEndereco">
								  <tr>
									<td width="7%">&nbsp;Logradouro: </td>
									<td colspan="3" width="36%"><strong><%=strLogradouro%></strong></td>
									
								  </tr>
								  <tr>
									<td> &nbsp;Complemento:</td>
									<td><strong><%=strComp_endereco%></strong></td>
									<td>&nbsp;CEP:</td>
									<td><strong><%=strCepresidencia%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Bairro:</td>
									<td><strong><%=strBairroaluno%></strong></td>
									<td>&nbsp;N&uacute;mero:</td>
									<td><strong><%=strNumero_endereco%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Munic&iacute;pio:</td>
									<td><strong><%=strCidaderesidencia%></strong></td>
									<td>&nbsp;UF:</td>
									<td><strong><%=strUFResidencia%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ENDEREÇO-->			</td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE" ><li><strong>Dados Familiares</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS FAMILIARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosFamiliares">
								  <tr>
									<td width="18%">&nbsp;Pai: </td>
									<td width="36%"><strong><%=strPai%></strong></td>
									<td width="16%">&nbsp;Falecido:</td>
									<td width="36%"><strong><%=strPaifalecido%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Data Nascimento: </td>
									<td><strong><%=strPaidatanascimento%></strong></td>
									<td>&nbsp;Telefone:</td>
									<td><strong><%=strPaifone%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Profiss&atilde;o: </td>
									<td><strong><%=strProfissaoPai%></strong></td>
									<td>&nbsp;Grau Instru&ccedil;&atilde;o: </td>
									<td><strong><%=strGrauInstrucaoPai%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;M&atilde;e: </td>
									<td><strong><%=strMae%></strong></td>
									<td>&nbsp;Falecida:</td>
									<td><strong><%=strMaefalecida%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Data Nascimento:</td>
									<td><strong><%=strMaedatanascimento%></strong></td>
									<td>&nbsp;Telefone:</td>
									<td><strong><%=strMaefone%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Profiss&atilde;o: </td>
									<td><strong><%=strProfissaoMae%></strong></td>
									<td>&nbsp;Grau Instru&ccedil;&atilde;o: </td>
									<td><strong><%=strGrauInstrucaoMae%></strong></td>
								  </tr>
								  
								  
								  <tr>
									<td>&nbsp;Respons&aacute;vel é: </td>
									<td><strong><%=RESPONSAVEL_QUEM%> <%if RESPONSAVEL_QUEM = "OUTRO" then%>(<%=RESPONSAVEL_GRAU_PARESTESCO%>)<%end if%></strong></td>
									<td>&nbsp;Possui documento legal que atesta a tutela (guarda):</td>
									<td><strong><%=RESPOSAVEL_POSSUI_DOCUMENTACAO%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Respons&aacute;vel: </td>
									<td><strong><%=strResponsavel%></strong></td>
									<td>&nbsp;Telefone:</td>
									<td><strong><%=strResponsavelfone%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Data Nascimento:</td>
									<td><strong><%=strResponsaveldatanascimento%></strong></td>
									<td>&nbsp;Grau Instru&ccedil;&atilde;o: </td>
									<td><strong><%=strGrauInstrucaoResponsavel%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Profiss&atilde;o: </td>
									<td><strong><%=strProfissaoResponsavel%></strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								  </tr>
								  <tr>
									<td>&nbsp;Qtde. Irm&atilde;os: </td>
									<td><strong><%=strQtdeIrmao%></strong></td>
									<td>&nbsp;Na mesma Escola:</td>
									<td><strong><%=strQtdeIrmaoEscola%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS FAMILIARES-->			</td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE"  onClick="return dadosDocumentos()"><li><strong>Documentação</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="mostraDadosDocumentos">
								  <tr>
									<td width="18%">&nbsp;Identidade: </td>
									<td width="36%"><strong><%=strIdentidade%>&nbsp;</strong>&Oacute;rg&atilde;o :<strong> <%=strIdentidadeOrgao%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;UF :<strong> <%=strUFIdentidade%></strong></td>
									<td width="16%">&nbsp;</td>
									<td width="36%"><strong></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Registro Militar  : </td>
									<td><strong><%=strRegmilitar%></strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								  </tr>
								  <tr>
									<td>&nbsp;T&iacute;tulo:</td>
								<td colspan="2">Num&eacute;ro :<strong><%=strTituloNumero%>&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Zona :<strong><%=strTituloZona%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>Se&ccedil;&atilde;o :<strong><%=strTituloSecao%></strong></td>
									<td>&nbsp;</td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE"><li><strong>Dados Escolares</strong></li></td>
							</tr>
						  <tr>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%">&nbsp;Turma:</td>
									<td width="36%"><strong><%=strTurma%></strong></td>
									<td width="16%">&nbsp;M&ecirc;s/Ano Entrevista.:</td>
									<td width="36%"><strong><%=strMesanovestibular%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Forma Ingresso: </td>
									<td><strong><%=strFormaIngresso%></strong></td>
									<td>&nbsp;Data Ingresso: </td>
									<td><strong><%=strDataingresso%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Situa&ccedil;&atilde;o:</td>
									<td><strong><%=strSituacaoAluno%></strong></td>
									<td>&nbsp;Dt. Afastamento: </td>
									<td><strong><%=strDatafastamento%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Obs:</td>
									<td><strong><%=strObsafastamento%></strong></td>
									<td>&nbsp;Cod. Motivo:</td>
									<td><strong><%=strCod_motivoafastamento%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Via Carteirinha:</td>
									<td><strong><%=strViaCarterinha%></strong></td>
									<td>&nbsp;Setransp:</td>
									<td><strong><%=strSetransp%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
						  </tr>
						  <tr>
							<td height="20" colspan="2" bgcolor="#EEEEEE"><li><strong>Informações Adicionais</strong></li></td>
							</tr>
						  <tr>
							<%
							MEDICAMENTO_CONTROLADO_resultado = ""
							if MEDICAMENTO_CONTROLADO = "N" then MEDICAMENTO_CONTROLADO_resultado = "Não"
							if MEDICAMENTO_CONTROLADO = "S" then MEDICAMENTO_CONTROLADO_resultado = "Sim"
							
							RESTRICAO_ALIMENTAR_resultado = ""
							if RESTRICAO_ALIMENTAR = "N" then RESTRICAO_ALIMENTAR_resultado = "Não"
							if RESTRICAO_ALIMENTAR = "S" then RESTRICAO_ALIMENTAR_resultado = "Sim"
							
							AUTORIZA_USO_IMAGEM_resultado = ""
							if AUTORIZA_USO_IMAGEM = "N" then AUTORIZA_USO_IMAGEM_resultado = "Não"
							if AUTORIZA_USO_IMAGEM = "S" then AUTORIZA_USO_IMAGEM_resultado = "Sim"
							
							TRANSPORTE_ESCOLAR_resultado = ""
							if TRANSPORTE_ESCOLAR = "N" then TRANSPORTE_ESCOLAR_resultado = "Não"
							if TRANSPORTE_ESCOLAR = "S" then TRANSPORTE_ESCOLAR_resultado = "Sim"
							%>
							<td colspan="2" >
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="18%">&nbsp;Faz uso de medicamento controlado:</td>
									<td width="36%"><strong><%=MEDICAMENTO_CONTROLADO_resultado%> <%if MEDICAMENTO_CONTROLADO = "S" then%>&nbsp;(<%=MEDICAMENTO_CONTROLADO_QUAL%>)<%end if%></strong></td>
									<td width="16%">&nbsp;Transporte escolar municipal:</td>
									<td width="36%"><strong><%=TRANSPORTE_ESCOLAR_resultado%></strong></td>
								  </tr>
								  <tr>
									<td>&nbsp;Autoriza o uso da imagem do filho(a) em eventos da SEMEC/ESCOLA: </td>
									<td><strong><%=AUTORIZA_USO_IMAGEM_resultado%></strong></td>
									<td>&nbsp;Possui restrição alimentar: </td>
									<td><strong><%=RESTRICAO_ALIMENTAR_resultado%> <%if RESTRICAO_ALIMENTAR = "S" then%>&nbsp;(<%=RESTRICAO_ALIMENTAR_QUAL%>)<%end if%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
						  </tr>
						</table>
											
			<%
			end if
			rs.close
			%>								
											<br>
											<br>
											<br>
											<br>
											<br>
											</div>
                                            
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </main>
                    <!-- this overlay is activated only when mobile menu is triggered -->
                    <div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div> <!-- END Page Content -->
                    
					<!--#include file="inc_rodape.asp"-->
					
					<!--#include file="inc_acesso_top.asp"-->
                </div>
            </div>
        </div>
        <!-- END Page Wrapper -->
        
		<!--#include file="inc_menu_impressao.asp"-->
		
        <!-- base vendor bundle: 
			 DOC: if you remove pace.js from core please note on Internet Explorer some CSS animations may execute before a page is fully loaded, resulting 'jump' animations 
						+ pace.js (recommended)
						+ jquery.js (core)
						+ jquery-ui-cust.js (core)
						+ popper.js (core)
						+ bootstrap.js (core)
						+ slimscroll.js (extension)
						+ app.navigation.js (core)
						+ ba-throttle-debounce.js (core)
						+ waves.js (extension)
						+ smartpanels.js (extension)
						+ src/../jquery-snippets.js (core) -->
        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
    </body>
</html>
