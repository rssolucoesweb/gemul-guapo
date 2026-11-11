<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de aluno
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/cripto.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	'carregando variavel
	'chave
	strCod_empresa 		= Session("CodEmpresa")
	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")
	
	intCodigo 			= Trim(Request.Form("txtCodAluno"))

	'dados pessoais
	strMatricula 					= ReplaceRequest(Trim(Request.Form("txtMatricula")))
	strNomealuno 					= ReplaceRequest(Trim(Request.Form("txtNomealuno")))
	strDatamatricula 				= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatamatricula"))))
	strNumeroRegistroNascimento 	= ReplaceRequest(Trim(Request.Form("txtNumeroRegistroNascimento")))
	strSexoaluno 					= ReplaceRequest(Trim(Request.Form("cmbSexo")))
	strDatanascimento 				= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatanascimento"))))

	strSenha 						= FormatCripto(replace(Request.Form("txtDatanascimento"),"/",""),True)	
	
	strCidadenascimento = ReplaceRequest(Trim(Request.Form("txtCidadenascimento")))
	strUfnascimento 	= ReplaceRequest(Trim(Request.Form("cmbUfnascimento")))
	if strUfnascimento = "" then strUfnascimento = "0"
	strNacionalidade 	= ReplaceRequest(Trim(Request.Form("txtNacionalidade")))
	strCod_estadocivil 	= ReplaceRequest(Trim(Request.Form("cmbEstadoCivil")))
	strCod_profissao 	= ReplaceRequest(Trim(Request.Form("cmbProfissao")))
	strCod_religiao 	= ReplaceRequest(Trim(Request.Form("cmbReligiao")))
	strCod_necespecial 	= ReplaceRequest(Trim(Request.Form("cmbNecessidadeEspecial")))
	strAtendimentoespecial = ReplaceRequest(Trim(Request.Form("txtAtendimentoespecial")))
	strFoneResidencial 	= ReplaceRequest(Trim(Request.Form("txtFoneResidencial")))
	strFonecomercial 	= ReplaceRequest(Trim(Request.Form("txtFonecomercial")))
	strFoneCelular	 	= ReplaceRequest(Trim(Request.Form("txtFonecelular")))
	strEmail 			= ReplaceRequest(Trim(Request.Form("txtEmail")))
	
	'endereço
	strLogradouro 		= ReplaceRequest(Trim(Request.Form("txtLogradouro")))
	strNumero_endereco 	= ReplaceRequest(Trim(Request.Form("txtNumero_endereco")))
	strComp_endereco 	= ReplaceRequest(Trim(Request.Form("txtComp_endereco")))
	strBairroaluno 		= ReplaceRequest(Trim(Request.Form("txtBairroaluno")))
	strCidaderesidencia	= ReplaceRequest(Trim(Request.Form("txtCidaderesidencia")))
	strUfresidencia 	= ReplaceRequest(Trim(Request.Form("cmbUfresidencia")))
	if strUfresidencia = "" then strUfresidencia = "0"
	strCepresidencia 	= ReplaceRequest(Trim(Request.Form("txtCepresidencia")))
	strCepresidencia 	= replace(strCepresidencia,"-","")
	
	'dados familiares
	strPai 				= ReplaceRequest(Trim(Request.Form("txtPai")))
	strPaifalecido 		= ReplaceRequest(Trim(Request.Form("txtPaifalecido")))
	strPaifone 			= ReplaceRequest(Trim(Request.Form("txtPaifone")))
	strPaidatanascimento= formataDataBD(ReplaceRequest(Trim(Request.Form("txtPaidatanascimento"))))
	strPai_cod_profissao= ReplaceRequest(Trim(Request.Form("cmbProfissaoPai")))
	strPai_cod_grauinstrucao= ReplaceRequest(Trim(Request.Form("cmbGrauInstrucaoPai")))

	strMae 				= ReplaceRequest(Trim(Request.Form("txtMae")))
	strMaefalecida 		= ReplaceRequest(Trim(Request.Form("txtMaefalecida")))
	strMaefone 			= ReplaceRequest(Trim(Request.Form("txtMaefone")))
	strMaedatanascimento= formataDataBD(ReplaceRequest(Trim(Request.Form("txtMaedatanascimento"))))
	strMae_cod_profissao= ReplaceRequest(Trim(Request.Form("cmbProfissaoMae")))
	strMae_cod_grauinstrucao= ReplaceRequest(Trim(Request.Form("cmbGrauInstrucaoMae")))
	
	strResponsavel 				= ReplaceRequest(Trim(Request.Form("txtResponsavel")))
	strResponsavelfone 			= ReplaceRequest(Trim(Request.Form("txtResponsavelfone")))
	strResponsaveldatanascimento= formataDataBD(ReplaceRequest(Trim(Request.Form("txtResponsaveldatanascimento"))))
	strResponsavel_cod_profissao= ReplaceRequest(Trim(Request.Form("cmbProfissaoResponsavel")))
	strResponsavel_cod_grauinstrucao= ReplaceRequest(Trim(Request.Form("cmbGrauInstrucaoResponsavel")))

	strQtde_irmao 		= ReplaceRequest(Trim(Request.Form("cmbQtdeIrmao")))
	strQtde_irmao_escola= ReplaceRequest(Trim(Request.Form("cmbQtdeIrmaoEscola")))
	
	'documentos
	strIdentidade 		= ReplaceRequest(Trim(Request.Form("txtIdentidade")))
	strIdentidadeOrgao	= ReplaceRequest(Trim(Request.Form("txtIdentidadeOrgao")))
	strIdentidadeUF		= ReplaceRequest(Trim(Request.Form("cmbUFIdentidade")))
	if strIdentidadeUF = "" then strIdentidadeUF = "0"

	strTituloNumero 	= ReplaceRequest(Trim(Request.Form("txtTituloNumero")))
	strTituloZona 		= ReplaceRequest(Trim(Request.Form("txtTituloZona")))
	strTituloSecao 		= ReplaceRequest(Trim(Request.Form("txtTituloSecao")))


	strRegmilitar 		= ReplaceRequest(Trim(Request.Form("txtRegmilitar")))
	strCpfaluno 		= replace(replace(ReplaceRequest(Trim(Request.Form("txtCpfaluno"))),".",""),"-","")
	
	'dados escolares
	'strCod_gradevestibular 	= ReplaceRequest(Trim(Request.Form("cmbGradeCompleta")))
	strMesanovestibular = ReplaceRequest(Trim(Request.Form("txtMesanovestibular")))

	strCod_formaingresso 		= ReplaceRequest(Trim(Request.Form("cmbFormaIngresso")))
	strDataingresso 	= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDataingresso"))))
	strCod_situacaoaluno= ReplaceRequest(Trim(Request.Form("cmbSituacaoAluno")))

	strDatafastamento 	= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatafastamento"))))
	intCodMotivoAfastamento	= Trim(Request.Form("cmbMotivoAfastamento"))

	strObsafastamento 	= left(ReplaceRequest(Trim(Request.Form("txtObsafastamento"))),2000)

	strDatacolacao 		= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatacolacao"))))
	strAnoconclusao 	= ReplaceRequest(Trim(Request.Form("txtAnoconclusao")))
	
	'novos campos
	strEscola				= Trim(Request.Form("txtEscola"))
	strEscolaOrigem				= Trim(Request.Form("txtEscolaOrigem"))
	strCidade				 	= Trim(Request.Form("txtCidade"))
	strAnoconclusaoEnsinoMedio 	= Trim(Request.Form("txtAnoconclusaoEnsinoMedio"))
	strUfEnsinoMedio		= Trim(Request.Form("cmbUFEnsinoMedio"))
	
	
	strSemconclusao 	= ReplaceRequest(Trim(Request.Form("txtSemconclusao")))
	strDatacertificado 	= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatacertificado"))))

	intViaCarterinha 	= ReplaceRequest(Trim(Request.Form("cmbViaCarterinha")))
	if intViaCarterinha = "" then intViaCarterinha = "0"
	strSetransp 		= ReplaceRequest(Trim(Request.Form("txtSetransp")))

	'dados finaceiro
	strCod_planoturma 	= "0"

	strLogradouro_cobranca 		= ReplaceRequest(Trim(Request.Form("txtLogradouro_cobranca")))
	strNumero_endereco_cobranca	= ReplaceRequest(Trim(Request.Form("txtNumero_endereco_cobranca")))
	strComp_endereco_cobranca 	= ReplaceRequest(Trim(Request.Form("txtComp_endereco_cobranca")))	
	
	'turma
	strCodTurma		= cLng(left(ReplaceRequest(Trim(Request.Form("cmbTurma"))),8))
	if 	strCodTurma = "" then strCodTurma = "0"
	
	'turma anterior
	strCodTurmaAnterior		= left(ReplaceRequest(Trim(Request.Form("txtCodTurmaAtual"))),8)
	if 	strCodTurmaAnterior = "" then strCodTurmaAnterior = "0"
	strCodTurmaAnterior = cLng(strCodTurmaAnterior)
	
	IF strCodTurma <> "0" THEN
		sql = "SELECT COD_SEMESTRE, AnoLetivo" 
		sql = sql & " FROM SCA_TURMA"
		sql = sql & " WHERE COD_TURMA = " & strCodTurma
		sql = sql & " AND COD_EMPRESA = " & strCod_empresa
		rs.open sql, cnn
		if not RS.EOF then
			strSemestre = RS("COD_SEMESTRE")
			strAnoLetivo = RS("AnoLetivo")
		end if
		rs.close
	END IF
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."

		'regra da tabela de configurações do sistema
		if Session("strChecarFinanceiro") = "S" then
			strCod_situacaoaluno = "0"
		end if
		
		sql = "SELECT Max(CODIGO) as MaiorCodigo" 
		sql = sql & " FROM SCA_ALUNO"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		if trim(strMatricula) = "" then
			'regra para criação da matricula
			bolMatriculaDiferenteDaUltima = false
			sql = "SELECT Max(Matricula) as MaiorMatricula" 
			sql = sql & " FROM SCA_ALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			rs.open sql, cnn,3 ,3
			if not RS.EOF then
				strUltimaMatriculaCadastrada = rs("MaiorMatricula")
				strUltimaSequenciaAnoSemestreAtual = trim(strAnoLetivo) & trim(strSemestre)
				
				if trim(strAnoLetivo) & trim(strSemestre) <> left(strUltimaMatriculaCadastrada,5)  then
				  	bolMatriculaDiferenteDaUltima = true
				else
					if strAnoLetivo = "" then
						strAnoLetivoMatricula = Session("strAnoLetivo")
					else 	 	
					   strAnoLetivoMatricula = strAnoLetivo
					end if	 
					if strSemestre = "" then
					   strSemestreMatricula = session("strSemestre")
					else	 
					   strSemestreMatricula = strSemestre
					end if	
					
					strSequenciaMatricula = right(strUltimaMatriculaCadastrada,4)
					strSequenciaMatricula = cInt(strSequenciaMatricula) + 1
					strMatricula = strAnoLetivoMatricula & strSemestreMatricula & ZeroLeft(strSequenciaMatricula,4)
				end if
			else
			   strMatricula = strAnoLetivo & strSemestre & "0000"
			end if 
			rs.close 
			
			if bolMatriculaDiferenteDaUltima then
				sql = "SELECT Max(Matricula) as MaiorMatricula" 
				sql = sql & " FROM SCA_ALUNO"
				sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND LEFT(MATRICULA,5)='" & strUltimaSequenciaAnoSemestreAtual&"'"
				rs.open sql, cnn,3 ,3
				if not RS.EOF then
				   if isnull(rs("MaiorMatricula")) then
				   		strMatricula = strAnoLetivo & strSemestre & "0000"
				   else
				  	 	strMatricula = rs("MaiorMatricula")+1
				   end if
				else
				   strMatricula = strAnoLetivo & strSemestre & "0000"
				end if 
				rs.close 
			end if 
		end if

		sql = "Insert Into SCA_ALUNO (COD_EMPRESA, CODIGO, MATRICULA, NOMEALUNO, DATAMATRICULA, "
		sql = sql & " COD_SITUACAOALUNO, SEXOALUNO, DATAFASTAMENTO, DATANASCIMENTO, NUMREGISTRONASC, "
		sql = sql & " CIDADENASCIMENTO, UFNASCIMENTO, LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
 		sql = sql & " BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, COD_ESTADOCIVIL, "
		sql = sql & " COD_PROFISSAO, COD_RELIGIAO, COD_NECESPECIAL, ATENDIMENTOESPECIAL, PAI, PAIFALECIDO, "
		sql = sql & " PAIFONE, PAIDATANASCIMENTO, PAI_COD_PROFISSAO, PAI_COD_GRAUINSTRUCAO, MAE, MAEFALECIDA, "
		sql = sql & " MAEFONE, MAEDATANASCIMENTO, MAE_COD_PROFISSAO, MAE_COD_GRAUINSTRUCAO, RESPONSAVEL, "
		sql = sql & " RESPONSAVELFONE, RESPONSAVELDATANASCIMENTO, RESPONSAVEL_COD_PROFISSAO, RESPONSAVEL_COD_GRAUINSTRUCAO, QTDE_IRMAO, "
		sql = sql & " QTDE_IRMAO_ESCOLA, FONERESIDENCIAL, FONECOMERCIAL, FONECELULAR, NACIONALIDADE, IDENTIDADE, IdentidadeOrgao, IdentidadeUF, "
		sql = sql & " TITULOELEITOR, TITULOZONA, TITULOSECAO, REGMILITAR, CPFALUNO, COD_FORMAINGRESSO, OBSAFASTAMENTO, COD_PLANOTURMA, "
		sql = sql & " COD_GRADEVESTIBULAR, MESANOVESTIBULAR, DATACOLACAO, ANOCONCLUSAO, SEMCONCLUSAO, "
		sql = sql & " DATACERTIFICADO, EMAIL, CTRVIACE, DATAINGRESSO, "
		sql = sql & " SETRANSP, COD_MOTIVOAFASTAMENTO, LOGRADOURO_COBRANCA, NUMERO_ENDERECO_COBRANCA, COMP_ENDERECO_COBRANCA, "
		sql = sql & " ESCOLA_ENSINOMEDIO, ESCOLA_ORIGEM, CIDADE_ENSINOMEDIO, ANO_ENSINOMEDIO, UF_ENSINOMEDIO,SENHA)"

		sql = sql & " Values ("
		sql = sql & "" & strCod_empresa & ","
		sql = sql & "" & intCodigo & ","

		if 	strMatricula 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strMatricula & ","
		end if
		if 	strNomealuno 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNomealuno & "',"
		end if
		if 	trim(strDatamatricula) = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDatamatricula & "',"
		end if
		if strCod_situacaoaluno = "" then strCod_situacaoaluno = "0"
		if 	strCod_situacaoaluno = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_situacaoaluno & ","
		end if
		if 	strSexoaluno 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSexoaluno & "',"
		end if
		if 	strDatafastamento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDatafastamento & "',"
		end if
		if 	strDatanascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDatanascimento & "',"
		end if
		if 	strNumeroRegistroNascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNumeroRegistroNascimento & "',"
		end if		
		if 	strCidadenascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCidadenascimento & "',"
		end if
		if 	strUfnascimento 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strUfnascimento & "',"
		end if
		if 	strLogradouro 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLogradouro & "',"
		end if
		if 	strNumero_endereco 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNumero_endereco & "',"
		end if
		if 	strComp_endereco 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strComp_endereco & "',"
		end if
		if 	strBairroaluno 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strBairroaluno & "',"
		end if
		if 	strCidaderesidencia 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCidaderesidencia & "',"
		end if
		if 	strUfresidencia 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strUfresidencia & "',"
		end if
		if 	strCepresidencia 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCepresidencia & "',"
		end if
		if 	strCod_estadocivil 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_estadocivil & ","
		end if
		if 	strCod_profissao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_profissao & ","
		end if
		if 	strCod_religiao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_religiao & ","
		end if
		if 	strCod_necespecial 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_necespecial & ","
		end if
		if 	strAtendimentoespecial 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strAtendimentoespecial & "',"
		end if
		if 	strPai 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strPai & "',"
		end if
		if 	strPaifalecido 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strPaifalecido & "',"
		end if 
		if 	strPaifone 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strPaifone & "',"
		end if
		if 	strPaidatanascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strPaidatanascimento & "',"
		end if
		if 	strPai_cod_profissao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strPai_cod_profissao & ","
		end if
		if 	strPai_cod_grauinstrucao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strPai_cod_grauinstrucao & ","
		end if	
					
		if 	strMae 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMae & "',"
		end if
		if 	strMaefalecida 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMaefalecida & "',"
		end if 
		if 	strMaefone 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMaefone & "',"
		end if
		if 	strMaedatanascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMaedatanascimento & "',"
		end if
		if 	strMae_cod_profissao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strMae_cod_profissao & ","
		end if
		if 	strMae_cod_grauinstrucao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strMae_cod_grauinstrucao & ","
		end if	
		
		if 	strResponsavel 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strResponsavel & "',"
		end if
		if 	strResponsavelfone 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strResponsavelfone & "',"
		end if
		if 	strResponsaveldatanascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strResponsaveldatanascimento & "',"
		end if
		if 	strResponsavel_cod_profissao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strResponsavel_cod_profissao & ","
		end if
		if 	strResponsavel_cod_grauinstrucao 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strResponsavel_cod_grauinstrucao & ","
		end if	
							
		if 	strQtde_irmao 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strQtde_irmao & ","
		end if
		if 	strQtde_irmao_escola 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strQtde_irmao_escola & ","
		end if
		if 	strFoneResidencial 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFoneResidencial & "',"
		end if		
		if 	strFonecomercial 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFonecomercial & "',"
		end if
		if 	strFoneCelular 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFoneCelular & "',"
		end if		
		if 	strNacionalidade 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNacionalidade & "',"
		end if
		if 	strIdentidade 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strIdentidade & "',"
		end if
		if 	strIdentidadeOrgao 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strIdentidadeOrgao & "',"
		end if
		if 	strIdentidadeUF 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strIdentidadeUF & "',"
		end if
		
		if 	strTituloNumero 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strTituloNumero & ","
		end if
		
		if 	strTituloZona 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strTituloZona & "',"
		end if
		
		if 	strTituloSecao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strTituloSecao & "',"
		end if

		if 	strRegmilitar 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strRegmilitar & "',"
		end if
		if 	strCpfaluno 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCpfaluno & "',"
		end if
		if 	strCod_formaingresso 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_formaingresso & ","
		end if
		if 	strObsafastamento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strObsafastamento & "',"
		end if
		if 	strCod_planoturma 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_planoturma & ","
		end if
'		if 	strCod_gradevestibular 	 = "0" then
		sql = sql & "NULL,"
'		else
'			sql = sql & "" & strCod_gradevestibular & ","
'		end if
		if 	strMesanovestibular 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMesanovestibular & "',"
		end if
		if 	strDatacolacao 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDatacolacao & "',"
		end if
		if 	strAnoconclusao 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strAnoconclusao & "',"
		end if
		if 	strSemconclusao 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSemconclusao & "',"
		end if
		if 	strDatacertificado 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDatacertificado & "',"
		end if
		if 	strEmail 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEmail & "',"
		end if
		if 	intViaCarterinha 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intViaCarterinha & ","
		end if
		if 	strDataingresso 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDataingresso & "',"
		end if
		if 	strSetransp 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSetransp & "',"
		end if
		if 	intCodMotivoAfastamento	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodMotivoAfastamento & ","
		end if
		if 	strLogradouro_cobranca 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLogradouro_cobranca & "',"
		end if
		if 	strNumero_endereco_cobranca 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNumero_endereco_cobranca & "',"
		end if
		if 	strComp_endereco_cobranca	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strComp_endereco_cobranca & "',"
		end if

		if 	strEscola	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEscola & "',"
		end if
		if 	strEscolaOrigem	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEscolaOrigem & "',"
		end if
		if 	strCidade	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCidade & "',"
		end if
		if 	strAnoconclusaoEnsinoMedio	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strAnoconclusaoEnsinoMedio & ","
		end if
		if 	strUfEnsinoMedio	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strUfEnsinoMedio & ","
		end if
		if 	strSenha	 = "0" then
			sql = sql & "NULL)"
		else
			sql = sql & "'" & strSenha & "')"
		end if

		cnn.execute sql
		GravarLog sql

		'DOCUMENTACAO DO ALUNO
		sql = "INSERT SCA_ALUNO_DOCUMENTACOES"
		sql = sql & " SELECT " & intCodigo & ", CODIGO, NULL, 'R'" 
		sql = sql & " FROM SCA_DOCUMENTACOES"
		sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
		cnn.execute sql
		GravarLog sql

		'incluir aluno na turma
		if strCodTurma <> "0" then
		
			sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " where COD_TURMA = " & strCodTurma
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			rs.open sql, cnn,3,3
			
			if not RS.EOF then
			
				if rs("MaiorSeq") <> "" then
					intSequencia = cstr(rs("MaiorSeq")) + 1
				else
					intSequencia = 1	
				end if
			
			end if
			rs.close		

			'inativa a turma anterior
			sql = "update SCA_ALUNO_TURMA "
			sql = sql & " SET SITUACAO = 'R'," 
			sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	COD_ALUNO = " & intCodigo
			sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
			cnn.execute sql
			GravarLog sql			

			strSituacaoNaTurma = "A" 'ativo na turma
			sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intSequencia & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql
			
			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	G.SITUACAO = 'A'"'GRADE ATIVA

			rs.open sql, cnn,3,3
			if not RS.EOF then
				while not rs.eof
					sql = "SELECT HD.SITUACAO"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
					sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
					sql = sql & " WHERE	H.COD_ALUNO = " & intCodigo
					sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
					sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
					Rs1.open sql, cnn,3,3
					if Rs1.EOF then				
				
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & strCod_empresa & "," 
						sql = sql & "" & intCodigo & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql		
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCod_empresa & "," 
							sql = sql & "" & intCodigo & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
		
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & intCodigo & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							
							END IF
						END IF
					end if
					Rs1.Close	
								
					rs.movenext
				wend
			end if
			rs.close		
			
		end if
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_ALUNO Set "
		if 	strNomealuno 	 = "" then
			sql = sql & "NOMEALUNO=NULL,"
		else
			sql = sql & "NOMEALUNO='" & strNomealuno & "',"
		end if
		if 	strDatamatricula 	 = "" then
			sql = sql & "DATAMATRICULA=NULL,"
		else
			sql = sql & "DATAMATRICULA='" & strDatamatricula & "',"
		end if
		if 	strNumeroRegistroNascimento 	 = "" then
			sql = sql & "NUMREGISTRONASC=NULL,"
		else
			sql = sql & "NUMREGISTRONASC='" & strNumeroRegistroNascimento & "',"
		end if		
		'if 	strCod_situacaoaluno 	 = "0" OR strCod_situacaoaluno 	 = "" then
		'	sql = sql & "COD_SITUACAOALUNO=NULL,"
		'else
		'	sql = sql & "COD_SITUACAOALUNO=" & strCod_situacaoaluno & ","
		'end if
		if 	strSexoaluno 	 = "0" then
			sql = sql & "SEXOALUNO=NULL,"
		else
			sql = sql & "SEXOALUNO='" & strSexoaluno & "',"
		end if
		if 	strDatafastamento 	 = "" then
			sql = sql & "DATAFASTAMENTO=NULL,"
		else
			sql = sql & "DATAFASTAMENTO='" & strDatafastamento & "',"
		end if
		if 	strDatanascimento 	 = "" then
			sql = sql & "DATANASCIMENTO=NULL,"
		else
			sql = sql & "DATANASCIMENTO='" & strDatanascimento & "',"
		end if
		if 	strCidadenascimento 	 = "" then
			sql = sql & "CIDADENASCIMENTO=NULL,"
		else
			sql = sql & "CIDADENASCIMENTO='" & strCidadenascimento & "',"
		end if
		if 	strUfnascimento 	 = "0" then
			sql = sql & "UFNASCIMENTO=NULL,"
		else
			sql = sql & "UFNASCIMENTO='" & strUfnascimento & "',"
		end if
		if 	strLogradouro 	 = "" then
			sql = sql & "LOGRADOURO=NULL,"
		else
			sql = sql & "LOGRADOURO='" & strLogradouro & "',"
		end if
		if 	strNumero_endereco 	 = "" then
			sql = sql & "NUMERO_ENDERECO=NULL,"
		else
			sql = sql & "NUMERO_ENDERECO='" & strNumero_endereco & "',"
		end if
		if 	strComp_endereco 	 = "" then
			sql = sql & "COMP_ENDERECO=NULL,"
		else
			sql = sql & "COMP_ENDERECO='" & strComp_endereco & "',"
		end if
		if 	strBairroaluno 	 = "" then
			sql = sql & "BAIRROALUNO=NULL,"
		else
			sql = sql & "BAIRROALUNO='" & strBairroaluno & "',"
		end if
		if 	strCidaderesidencia 	 = "" then
			sql = sql & "CIDADERESIDENCIA=NULL,"
		else
			sql = sql & "CIDADERESIDENCIA='" & strCidaderesidencia & "',"
		end if
		if 	strUfresidencia 	 = "0" then
			sql = sql & "UFRESIDENCIA=NULL,"
		else
			sql = sql & "UFRESIDENCIA='" & strUfresidencia & "',"
		end if
		if 	strCepresidencia 	 = "" then
			sql = sql & "CEPRESIDENCIA=NULL,"
		else
			sql = sql & "CEPRESIDENCIA='" & strCepresidencia & "',"
		end if
		if 	strCod_estadocivil 	 = "0" then
			sql = sql & "COD_ESTADOCIVIL=NULL,"
		else
			sql = sql & "COD_ESTADOCIVIL=" & strCod_estadocivil & ","
		end if
		if 	strCod_profissao 	 = "0" then
			sql = sql & "COD_PROFISSAO=NULL,"
		else
			sql = sql & "COD_PROFISSAO=" & strCod_profissao & ","
		end if
		if 	strCod_religiao 	 = "0" then
			sql = sql & "COD_RELIGIAO=NULL,"
		else
			sql = sql & "COD_RELIGIAO=" & strCod_religiao & ","
		end if
		if 	strCod_necespecial 	 = "0" then
			sql = sql & "COD_NECESPECIAL=NULL,"
		else
			sql = sql & "COD_NECESPECIAL=" & strCod_necespecial & ","
		end if
		if 	strAtendimentoespecial 	 = "0" then
			sql = sql & "ATENDIMENTOESPECIAL=NULL,"
		else
			sql = sql & "ATENDIMENTOESPECIAL='" & strAtendimentoespecial & "',"
		end if
		if 	strPai 	 = "" then
			sql = sql & "PAI=NULL,"
		else
			sql = sql & "PAI='" & strPai & "',"
		end if
		if 	strPaifalecido 	 = "0" then
			sql = sql & "PAIFALECIDO=NULL,"
		else
			sql = sql & "PAIFALECIDO='" & strPaifalecido & "',"
		end if 
		if 	strPaifone 	 = "" then
			sql = sql & "PAIFONE=NULL,"
		else
			sql = sql & "PAIFONE='" & strPaifone & "',"
		end if
		if 	strPaidatanascimento 	 = "" then
			sql = sql & "PAIDATANASCIMENTO=NULL,"
		else
			sql = sql & "PAIDATANASCIMENTO='" & strPaidatanascimento & "',"
		end if
		if 	strPai_cod_profissao 	 = "0" then
			sql = sql & "PAI_COD_PROFISSAO=NULL,"
		else
			sql = sql & "PAI_COD_PROFISSAO=" & strPai_cod_profissao & ","
		end if
		if 	strPai_cod_grauinstrucao 	 = "0" then
			sql = sql & "PAI_COD_GRAUINSTRUCAO=NULL,"
		else
			sql = sql & "PAI_COD_GRAUINSTRUCAO=" & strPai_cod_grauinstrucao & ","
		end if				
		if 	strMae 	 = "" then
			sql = sql & "MAE=NULL,"
		else
			sql = sql & "MAE='" & strMae & "',"
		end if
		if 	strMaefalecida 	 = "0" then
			sql = sql & "MAEFALECIDA=NULL,"
		else
			sql = sql & "MAEFALECIDA='" & strMaefalecida & "',"
		end if 
		if 	strMaefone 	 = "" then
			sql = sql & "MAEFONE=NULL,"
		else
			sql = sql & "MAEFONE='" & strMaefone & "',"
		end if
		if 	strMaedatanascimento 	 = "" then
			sql = sql & "MAEDATANASCIMENTO=NULL,"
		else
			sql = sql & "MAEDATANASCIMENTO='" & strMaedatanascimento & "',"
		end if
		if 	strMae_cod_profissao 	 = "0" then
			sql = sql & "MAE_COD_PROFISSAO=NULL,"
		else
			sql = sql & "MAE_COD_PROFISSAO=" & strMae_cod_profissao & ","
		end if
		if 	strMae_cod_grauinstrucao 	 = "0" then
			sql = sql & "MAE_COD_GRAUINSTRUCAO=NULL,"
		else
			sql = sql & "MAE_COD_GRAUINSTRUCAO=" & strMae_cod_grauinstrucao & ","
		end if	

		if 	strResponsavel 	 = "" then
			sql = sql & "RESPONSAVEL=NULL,"
		else
			sql = sql & "RESPONSAVEL='" & strResponsavel & "',"
		end if
		if 	strResponsavelfone 	 = "" then
			sql = sql & "RESPONSAVELFONE=NULL,"
		else
			sql = sql & "RESPONSAVELFONE='" & strResponsavelfone & "',"
		end if
		if 	strResponsaveldatanascimento 	 = "" then
			sql = sql & "RESPONSAVELDATANASCIMENTO=NULL,"
		else
			sql = sql & "RESPONSAVELDATANASCIMENTO='" & strResponsaveldatanascimento & "',"
		end if
		if 	strResponsavel_cod_profissao 	 = "0" then
			sql = sql & "RESPONSAVEL_COD_PROFISSAO=NULL,"
		else
			sql = sql & "RESPONSAVEL_COD_PROFISSAO=" & strResponsavel_cod_profissao & ","
		end if
		if 	strResponsavel_cod_grauinstrucao 	 = "0" then
			sql = sql & "RESPONSAVEL_COD_GRAUINSTRUCAO=NULL,"
		else
			sql = sql & "RESPONSAVEL_COD_GRAUINSTRUCAO=" & strResponsavel_cod_grauinstrucao & ","
		end if	
					
		if 	strQtde_irmao 	 = "" then
			sql = sql & "QTDE_IRMAO=NULL,"
		else
			sql = sql & "QTDE_IRMAO=" & strQtde_irmao & ","
		end if
		if 	strQtde_irmao_escola 	 = "" then
			sql = sql & "QTDE_IRMAO_ESCOLA=NULL,"
		else
			sql = sql & "QTDE_IRMAO_ESCOLA=" & strQtde_irmao_escola & ","
		end if
		if 	strFoneResidencial 	 = "" then
			sql = sql & "FONERESIDENCIAL=NULL,"
		else
			sql = sql & "FONERESIDENCIAL='" & strFoneResidencial & "',"
		end if		
		if 	strFonecomercial 	 = "" then
			sql = sql & "FONECOMERCIAL=NULL,"
		else
			sql = sql & "FONECOMERCIAL='" & strFonecomercial & "',"
		end if
		if 	strFoneCelular 	 = "" then
			sql = sql & "FONECELULAR=NULL,"
		else
			sql = sql & "FONECELULAR='" & strFoneCelular & "',"
		end if		
		if 	strNacionalidade 	 = "" then
			sql = sql & "NACIONALIDADE=NULL,"
		else
			sql = sql & "NACIONALIDADE='" & strNacionalidade & "',"
		end if
		if 	strIdentidade 	 = "" then
			sql = sql & "IDENTIDADE=NULL,"
		else
			sql = sql & "IDENTIDADE='" & strIdentidade & "',"
		end if

		if 	strIdentidadeOrgao 	 = "" then
			sql = sql & "IdentidadeOrgao=NULL,"
		else
			sql = sql & "IdentidadeOrgao='" & strIdentidadeOrgao & "',"
		end if
		
		if 	strIdentidadeUF 	 = "0" then
			sql = sql & "IdentidadeUF=NULL,"
		else
			sql = sql & "IdentidadeUF='" & strIdentidadeUF & "',"
		end if
		
		if 	strTituloNumero 	 = "" then
			sql = sql & "TITULOELEITOR=NULL,"
		else
			sql = sql & "TITULOELEITOR='" & strTituloNumero & "',"
		end if
		
		if 	strTituloZona 	 = "" then
			sql = sql & "TITULOZONA=NULL,"
		else
			sql = sql & "TITULOZONA='" & strTituloZona & "',"
		end if
		
		if 	strTituloSecao 	 = "" then
			sql = sql & "TITULOSECAO=NULL,"
		else
			sql = sql & "TITULOSECAO='" & strTituloSecao & "',"
		end if
		
		if 	strRegmilitar 	 = "" then
			sql = sql & "REGMILITAR=NULL,"
		else
			sql = sql & "REGMILITAR='" & strRegmilitar & "',"
		end if
		if 	strCpfaluno 	 = "" then
			sql = sql & "CPFALUNO=NULL,"
		else
			sql = sql & "CPFALUNO='" & strCpfaluno & "',"
		end if
		if 	strCod_formaingresso 	 = "0" then
			sql = sql & "COD_FORMAINGRESSO=NULL,"
		else
			sql = sql & "COD_FORMAINGRESSO=" & strCod_formaingresso & ","
		end if
		if 	strObsafastamento 	 = "" then
			sql = sql & "OBSAFASTAMENTO=NULL,"
		else
			sql = sql & "OBSAFASTAMENTO='" & strObsafastamento & "',"
		end if
		if 	strCod_planoturma 	 = "0" then
			sql = sql & "COD_PLANOTURMA=NULL,"
		else
			sql = sql & "COD_PLANOTURMA=" & strCod_planoturma & ","
		end if
'		if 	strCod_gradevestibular 	 = "0" then
'			sql = sql & "COD_GRADEVESTIBULAR=NULL,"
'		else
'			sql = sql & "COD_GRADEVESTIBULAR=" & strCod_gradevestibular & ","
'		end if
		if 	strMesanovestibular 	 = "" then
			sql = sql & "MESANOVESTIBULAR=NULL,"
		else
			sql = sql & "MESANOVESTIBULAR='" & strMesanovestibular & "',"
		end if
		if 	strDatacolacao 	 = "" then
			sql = sql & "DATACOLACAO=NULL,"
		else
			sql = sql & "DATACOLACAO='" & strDatacolacao & "',"
		end if
		if 	strAnoconclusao 	 = "" then
			sql = sql & "ANOCONCLUSAO=NULL,"
		else
			sql = sql & "ANOCONCLUSAO='" & strAnoconclusao & "',"
		end if
		if 	strSemconclusao 	 = "" then
			sql = sql & "SEMCONCLUSAO=NULL,"
		else
			sql = sql & "SEMCONCLUSAO='" & strSemconclusao & "',"
		end if
		if 	strDatacertificado 	 = "" then
			sql = sql & "DATACERTIFICADO=NULL,"
		else
			sql = sql & "DATACERTIFICADO='" & strDatacertificado & "',"
		end if
		if 	strEmail 	 = "" then
			sql = sql & "EMAIL=NULL,"
		else
			sql = sql & "EMAIL='" & strEmail & "',"
		end if
		if 	intViaCarterinha 	 = "0" then
			sql = sql & "CTRVIACE=NULL,"
		else
			sql = sql & "CTRVIACE=" & intViaCarterinha & ","
		end if
		if 	strDataingresso 	 = "" then
			sql = sql & "DATAINGRESSO=NULL,"
		else
			sql = sql & "DATAINGRESSO='" & strDataingresso & "',"
		end if
		if 	strSetransp 	 = "" then
			sql = sql & "SETRANSP=NULL,"
		else
			sql = sql & "SETRANSP='" & strSetransp & "',"
		end if
		if 	intCodMotivoAfastamento 	 = "0" then
			sql = sql & "COD_MOTIVOAFASTAMENTO=NULL,"
		else
			sql = sql & "COD_MOTIVOAFASTAMENTO=" & intCodMotivoAfastamento & ","
		end if
		if 	strLogradouro_cobranca 	 = "" then
			sql = sql & "LOGRADOURO_COBRANCA=NULL,"
		else
			sql = sql & "LOGRADOURO_COBRANCA='" & strLogradouro_cobranca & "',"
		end if
		if 	strNumero_endereco_cobranca 	 = "" then
			sql = sql & "NUMERO_ENDERECO_COBRANCA=NULL,"
		else
			sql = sql & "NUMERO_ENDERECO_COBRANCA='" & strNumero_endereco_cobranca & "',"
		end if
		if 	strComp_endereco_cobranca	 = "" then
			sql = sql & "COMP_ENDERECO_COBRANCA=NULL,"
		else
			sql = sql & "COMP_ENDERECO_COBRANCA='" & strComp_endereco_cobranca & "',"
		end if
		
		if 	strEscola	 = "" then
			sql = sql & "ESCOLA_ENSINOMEDIO = NULL,"
		else
			sql = sql & "ESCOLA_ENSINOMEDIO = '" & strEscola & "',"
		end if
		if 	strEscolaOrigem	 = "" then
			sql = sql & "ESCOLA_ORIGEM = NULL,"
		else
			sql = sql & "ESCOLA_ORIGEM = '" & strEscolaOrigem & "',"
		end if
		
		if 	strCidade	 = "" then
			sql = sql & "CIDADE_ENSINOMEDIO = NULL,"
		else
			sql = sql & "CIDADE_ENSINOMEDIO = '" & strCidade & "',"
		end if
		if 	strAnoconclusaoEnsinoMedio	 = "" then
			sql = sql & "ANO_ENSINOMEDIO = NULL,"
		else
			sql = sql & "ANO_ENSINOMEDIO = " & strAnoconclusaoEnsinoMedio & ","
		end if
		if 	strUfEnsinoMedio	 = "0" then
			sql = sql & "UF_ENSINOMEDIO = NULL"
		else
			sql = sql & "UF_ENSINOMEDIO = " & strUfEnsinoMedio & ""
		end if

		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = " update sca_aluno set senha = '" & strSenha & "'"
		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And CODIGO = " & intCodigo
		sql = sql & " And senha is null"
		cnn.execute sql
		GravarLog sql
		
		'verifica se a turma do aluno foi alterada
		if trim(strCodTurma) <> trim(strCodTurmaAnterior) then
			strCOD_GRADECURRICULARAnterior = 0
			sql = "SELECT COD_GRADECURRICULAR FROM SCA_TURMA"
			sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_TURMA = " & strCodTurmaAnterior
			rs.open sql, cnn
			IF not RS.EOF then		
				strCOD_GRADECURRICULARAnterior = rs("COD_GRADECURRICULAR")
			END IF		
			Rs.close
			
			strCOD_GRADECURRICULARAtual = 0
			sql = "SELECT COD_GRADECURRICULAR FROM SCA_TURMA"
			sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_TURMA = " & strCodTurma
			rs.open sql, cnn
			IF not RS.EOF then		
				strCOD_GRADECURRICULARAtual = rs("COD_GRADECURRICULAR")
			END IF		
			Rs.close				
			
			'inativa a turma anterior
			sql = "update SCA_ALUNO_TURMA "
			sql = sql & " SET SITUACAO = 'R'," 
			sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	COD_ALUNO = " & intCodigo
   		    sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
			cnn.execute sql
			GravarLog sql			
	
			
			sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " WHERE COD_TURMA = " & strCodTurma
			rs.open sql, cnn, 3, 3
			
			if not RS.EOF then
			
				if rs("MaiorSeq") <> "" then
					intSequencia = cstr(rs("MaiorSeq")) + 1
				else
					intSequencia = 1	
				end if
			
			end if
			rs.close	
			
			strSituacaoNaTurma = "A" 'ativo na turma
			sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intSequencia & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "'" & strSituacaoNaTurma & "'," 
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql
			
			if trim(strCOD_GRADECURRICULARAnterior) <> trim(strCOD_GRADECURRICULARAtual) then

                
				' tira o aluno da turma e das disciplinas
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_FALTAS_DIARIA "
				sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND 	COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql	

				' limpa a tabela de notas
				sql = "DELETE N"
				sql = sql & " from SCA_NOTAS_FALTAS N"
				sql = sql & " where	N.COD_EMPRESA = " & strCod_empresa
				sql = sql & " and	N.COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql	

				' tira o aluno da turma e das disciplinas
				sql = "DELETE "
				sql = sql & " from SCA_ALUNO_DISCIPLINA "
				sql = sql & " where	COD_EMPRESA = " & strCod_empresa
				sql = sql & " and	COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql	
				
				'copia o espelho da grade da turma e inclui ao aluno
				sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
				sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
				sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
				rs.open sql, cnn,3,3
				if not RS.EOF then
					while not rs.eof
					
						sql = "SELECT HD.SITUACAO"
						sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
						sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
						sql = sql & " WHERE	H.COD_ALUNO = " & intCodigo
						sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
						sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
						Rs1.open sql, cnn,3,3
						if Rs1.EOF then				
					
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCod_empresa & "," 
							sql = sql & "" & intCodigo & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
											
						else
							IF ISNULL(Rs1("SITUACAO")) THEN
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & intCodigo & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							ELSE
								IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
			
									sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
									sql = sql & "" & strCod_empresa & "," 
									sql = sql & "" & intCodigo & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_DISCIPLINA") & "," 
									sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
									cnn.execute sql
									GravarLog sql		
								
								END IF
							END IF
						end if
						Rs1.Close							
					
						rs.movenext
					wend
				end if
				rs.close						
				
			else
				
				' atualiza turma atual
				sql = "update SCA_ALUNO_DISCIPLINA "
				sql = sql & " set 	COD_TURMA = " & strCodTurma & ","
				sql = sql & " 		COD_TURMA_REMANEJAMENTO = " & strCodTurma
				sql = sql & " from SCA_ALUNO_DISCIPLINA "
				sql = sql & " where	COD_EMPRESA = " & strCod_empresa
				sql = sql & " and	COD_ALUNO = " & intCodigo
				sql = sql & " AND	COD_TURMA = " & strCodTurmaAnterior
				cnn.execute sql
				GravarLog sql	

			end if
			
			'Gera Ocorrencia Automatica do tipo Protesto
			'parametros:
			'	intCodEmp
			'	intCodDepartamento
			'	intCodAluno
			'	intCodTaxa
			'	intCodBebitoAluno
			'	strDataOcorrencia
			'	strDataValidade
			'	strOcorrencia
			'	strUsuarioIncl
		
			intCodEmp			= strCod_empresa
			intCodDepartamento	= Session("CodDeptoUsuario")
			intCodAluno			= intCodigo
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Alteração de turma na ficha do aluno"
			%>
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		

	else
	
		strMensagem = "Registro Excluido com sucesso..."

		bolComDebito = false
		sql = "SELECT codigo FROM SCF_DEBITOALUNO"
		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And cod_aluno = " & intCodigo
		rs.open sql, cnn
		IF not RS.EOF then		
			bolComDebito = true
		END IF		
		Rs.close
		
		if bolComDebito then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Aluno não pode ser excluído, existem registros financeiros.");
				window.history.back();
			</script>
			<%
			response.end
		end if

		' tira o aluno faltas diarias
		sql = "DELETE " 
		sql = sql & " FROM 	SCA_FALTAS_DIARIA "
		sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
		sql = sql & " AND 	COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql	

		' limpa a tabela de notas
		sql = "DELETE "
		sql = sql & " from SCA_NOTAS_FALTAS "
		sql = sql & " where	COD_EMPRESA = " & strCod_empresa
		sql = sql & " and	COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql	

		' tira o aluno da turma e das disciplinas
		sql = "DELETE "
		sql = sql & " from SCA_ALUNO_DISCIPLINA "
		sql = sql & " where	COD_EMPRESA = " & strCod_empresa
		sql = sql & " and	COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql	

		'EXCLUI aluno na turma
		sql = "delete from SCA_ALUNO_TURMA"
		sql = sql & " where COD_EMPRESA = " & strCod_empresa
		sql = sql & " and COD_ALUNO = " & intCodigo
		sql = sql & " and COD_TURMA = " & strCodTurma
		cnn.execute sql
		GravarLog sql

		'EXCLUI aluno na documentos
		sql = "delete from SCA_ALUNO_DOCUMENTACOES"
		sql = sql & " WHERE COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		
		sql = "Delete from SCA_ALUNO"
		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql

	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="E" then	
			strParametro = "Aluno_cad.asp"
		else
			strParametro = "Aluno_cad.asp?txtCodAluno=" & intCodigo
		end if
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate("<%=strParametro%>");
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>