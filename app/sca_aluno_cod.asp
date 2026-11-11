<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_log_aluno.asp"-->
<!--#include file="includes/inc_replaceRequest.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	if Session("CodGrupo") = "7" then
	strUsuarioLiberadoParaMatricularDireto = ""
	sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
	sql = sql & " Where cod_grupo = " & Session("CodGrupo")
	sql = sql & " and SEG_ITENS_SISTEMA_ITEM_CODG = 26" 'ficha
	sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
	'response.write sql
	rs.open sql, cnn
	if rs.eof = false then
		strUsuarioLiberadoParaMatricularDireto = ucase(trim(session("usuarioWeb")))
	end if 
	rs.close
	end if
	
	'response.write strUsuarioLiberadoParaMatricularDireto
	acao 					= Request("acao")
	AlunoNovo 				= Request("AlunoNovo") 				'aluno novo
	receberTransferencia 	= Request("receberTransferencia") 	'aluno novo que vem de outra unidade
	
	'response.write "<br>AlunoNovo:" & AlunoNovo
	'response.write "<br>receberTransferencia:" & receberTransferencia
	'response.write "<br>acao:" & acao
	'response.end
	'
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

	strAnoLetivoAnterior = Request("txtAnoLetivoAnterior")
	

	'dados pessoais
	strMatricula 					= ReplaceRequest(Trim(Request.Form("txtMatricula")))
	strNomealuno 					= ReplaceRequest(Trim(Request.Form("txtNomealuno")))
	strNomeAnt 						= ReplaceRequest(Trim(Request.Form("txtNomeAnt")))
	
	strDatamatricula 				= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatamatricula"))))
	strNumeroRegistroNascimento 	= ReplaceRequest(Trim(Request.Form("txtNumeroRegistroNascimento")))
	
	strCPF						= formataCPFbd(Trim(Request.Form("txtcpf")))
	
	strFotoAluno        = request("txtFotoAlunoHidden")

	strFolha			= ReplaceRequest(Trim(Request.Form("txtFolha")))
	strLivro			= ReplaceRequest(Trim(Request.Form("txtLivro")))
	strTermo			= ReplaceRequest(Trim(Request.Form("txtTermo")))
	strNomeCartorio		= ReplaceRequest(Trim(Request.Form("txtNomeCartorio")))
	strbolsaFamilia 	= ReplaceRequest(TRIM(request("txtBolsaFamilia")))
	strCartaoSUS	 	= ReplaceRequest(TRIM(request("txtCartaoSUS")))

	strSexoaluno 					= ReplaceRequest(Trim(Request.Form("cmbSexo")))
	strDatanascimento 				= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatanascimento"))))
	strDataEmissaoCertidaoNasc 		= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDataEmissaoCertidaoNascimento")))) 
	strSenha 						= replace(formatadataAP(Request.Form("txtDatanascimento")),"/","")
	
	strCidadenascimento = ReplaceRequest(Trim(Request.Form("txtCidadenascimento")))
	strUfnascimento 	= ReplaceRequest(Trim(Request.Form("cmbUfnascimento")))
	if strUfnascimento = "" then strUfnascimento = "0"

	strNacionalidade 	= Trim(Request.Form("cmbNacionalidade"))
	strTipoNacionalidade= Trim(Request.Form("cmbTipoNacionalidade"))
	strCod_estadocivil 	= ReplaceRequest(Trim(Request.Form("cmbEstadoCivil")))
	strCod_profissao 	= ReplaceRequest(Trim(Request.Form("cmbProfissao")))
	strCod_religiao 	= ReplaceRequest(Trim(Request.Form("cmbReligiao")))
	intCodEtnia 		= Trim(Request.Form("cmbEtnia"))
	strCod_necespecial 	= ReplaceRequest(Trim(Request.Form("cmbNecessidadeEspecial"))) 'CAMPO FOI TROCADO AGORA ESTÁ EM UMA TABELA
	strCod_necespecial	= 0 'CAMPO FOI TROCADO AGORA ESTÁ EM UMA TABELA
	strAtendimentoespecial = ReplaceRequest(Trim(Request.Form("txtAtendimentoespecial")))
	strSalaAEE 			= ReplaceRequest(Trim(Request.Form("cmbSalaAEE")))
	strFoneResidencial 	= ReplaceRequest(Trim(Request.Form("txtFoneResidencial")))
	strFonecomercial 	= ReplaceRequest(Trim(Request.Form("txtFonecomercial")))
	strFoneCelular	 	= ReplaceRequest(Trim(Request.Form("txtFonecelular")))
	strEmail 			= ReplaceRequest(Trim(Request.Form("txtEmail")))
	
	intCodCodicaoEspecial 		= ReplaceRequest(Trim(Request.Form("cmbCondicaoEspecial")))
	

	strCondicaoEspecialOutro 	= ReplaceRequest(Trim(Request.Form("txtCondicaoEspecialOutro")))
	
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
	strCPFResponsavel 			= replace(replace(ReplaceRequest(Trim(Request.Form("txtCPFResponsavel"))),".",""),"-","")
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
	strEscola					= Trim(Request.Form("txtEscola"))
	strEscolaOrigem				= Trim(Request.Form("txtEscolaOrigem"))
	strCodigoInep				= Trim(Request.Form("txtCodigoInep"))
	strCidade				 	= Trim(Request.Form("txtCidade"))
	strAnoconclusaoEnsinoMedio 	= Trim(Request.Form("txtAnoconclusaoEnsinoMedio"))
	strSemestreconclusaoEnsinoMedio = Trim(Request.Form("txtSemestreconclusaoEnsinoMedio"))
	
	strSemconclusao 			= ReplaceRequest(Trim(Request.Form("txtSemconclusao")))
	strDataConclusao 			= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDataConclusao"))))
	strDatacertificado 			= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatacertificado"))))
	intCodDisciplinaVestibular 	= Trim(Request.Form("cmbDisciplinaVestibular"))
	if intCodDisciplinaVestibular = "" then intCodDisciplinaVestibular ="0"

	intViaCarterinha 	= ReplaceRequest(Trim(Request.Form("cmbViaCarterinha")))
	if intViaCarterinha = "" then intViaCarterinha = "0"
	strSetransp 		= ReplaceRequest(Trim(Request.Form("txtSetransp")))

	'dados finaceiro
	strCod_planoturma 	= "0"

	strLogradouro_cobranca 		= ReplaceRequest(Trim(Request.Form("txtLogradouro_cobranca")))
	strNumero_endereco_cobranca	= ReplaceRequest(Trim(Request.Form("txtNumero_endereco_cobranca")))
	strComp_endereco_cobranca 	= ReplaceRequest(Trim(Request.Form("txtComp_endereco_cobranca")))	

	RESPOSAVEL_POSSUI_DOCUMENTACAO= Trim(Request.Form("RESPOSAVEL_POSSUI_DOCUMENTACAO"))
	RESPONSAVEL_GRAU_PARESTESCO			= Trim(Request.Form("RESPONSAVEL_GRAU_PARESTESCO"))
	RESPONSAVEL_QUEM			= Trim(Request.Form("RESPONSAVEL_QUEM"))
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
	ID_CENSO 					= Trim(Request.Form("ID_CENSO"))
	
	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
		if trim(Session("MatriculaInformatizada"))  =  "SIM" then
			'turma
			strCodTurma				= Trim(Request.Form("cmbTurma"))
			strCodTurmaTroca		= Trim(Request.Form("cmbTurmaTroca"))
		else
			'turma
			strCodTurma		= cLng(left(ReplaceRequest(Trim(Request.Form("cmbTurma"))),8))
		end if
	else
		strCodTurma		= cLng(left(ReplaceRequest(Trim(Request.Form("cmbTurma"))),8))
	end if
	
	if 	strCodTurma = "" then strCodTurma = "0"
	
	'turma anterior
	strCodTurmaAnterior		= left(ReplaceRequest(Trim(Request.Form("txtCodTurmaAtual"))),8)
	if 	strCodTurmaAnterior = "" then strCodTurmaAnterior = "0"
	strCodTurmaAnterior = cLng(strCodTurmaAnterior)

    strCriarGradeChecandoHistorico = ""
	sql = " SELECT top 1 CriarGrade_ChecandoHistorico "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strCriarGradeChecandoHistorico	 = trim(rs("CriarGrade_ChecandoHistorico"))
		if isnull(strCriarGradeChecandoHistorico) then strCriarGradeChecandoHistorico = ""
	end if
	rs.close

	IF strCodTurma <> "0" THEN
		sql = "SELECT COD_SEMESTRE, AnoLetivo" 
		sql = sql & " FROM SCA_TURMA"
		sql = sql & " WHERE COD_TURMA = " & strCodTurma
		sql = sql & " AND COD_EMPRESA = " & strCod_empresa
		'response.Write(sql)
		rs.open sql, cnn
		if not RS.EOF then
			strSemestre = RS("COD_SEMESTRE")
			strAnoLetivo = RS("AnoLetivo")
		end if
		rs.close
	END IF
	
	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
		if trim(Session("MatriculaInformatizada"))  =  "SIM" then
		
			' Busca o Cod_SituacaoAluno Situação de ATIVO
			sql = " select Cod_SituacaoAluno " 
			sql = sql & " FROM sca_SITUACAOALUNO"
			sql = sql & " where Desc_SituacaoAluno = 'ATIVO'"
			rsAux.open sql, cnn, 3, 3
			if not rsAux.EOF then	
				intCodSituacaoAluno = trim(rsAux("Cod_SituacaoAluno"))
			end if
			rsAux.close	
		
		end if
	else
		' Busca o Cod_SituacaoAluno Situação de ATIVO
		sql = " select Cod_SituacaoAluno " 
		sql = sql & " FROM sca_SITUACAOALUNO"
		sql = sql & " where Desc_SituacaoAluno = 'ATIVO'"
		rsAux.open sql, cnn, 3, 3
		if not rsAux.EOF then	
			intCodSituacaoAluno = trim(rsAux("Cod_SituacaoAluno"))
		end if
		rsAux.close	
	end if
	
	if acao="I" and AlunoNovo = "S" then
		strMensagem = "Registro incluido com sucesso..."

		if trim(strMatricula) = "" then
			'regra para criação da matricula
			bolMatriculaDiferenteDaUltima = false
			sql = "SELECT Max(Matricula) as MaiorMatricula" 
			sql = sql & " FROM SCA_ALUNO"
			rs.open sql, cnn,3 ,3
			if not RS.EOF then
				strUltimaMatriculaCadastrada = rs("MaiorMatricula")
				strUltimaSequenciaAnoSemestreAtual = trim(strAnoLetivo)
				
				if trim(strAnoLetivo) <> left(strUltimaMatriculaCadastrada,4)  then
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
					
					strSequenciaMatricula = right(strUltimaMatriculaCadastrada,5)
					if isnull(strSequenciaMatricula) or strSequenciaMatricula = "" then
					   strSequenciaMatricula = "0"
					end if
					strSequenciaMatricula = cInt(strSequenciaMatricula) + 1
					strMatricula = strAnoLetivoMatricula & ZeroLeft(strSequenciaMatricula,5)
				end if
			else
			   strMatricula = strAnoLetivo & "00000"
			end if 
			rs.close 
			
			if bolMatriculaDiferenteDaUltima then
				sql = "SELECT Max(Matricula)+1 as MaiorMatricula" 
				sql = sql & " FROM SCA_ALUNO"
				sql = sql & " WHERE LEFT(MATRICULA,5)='" & strUltimaSequenciaAnoSemestreAtual&"'"
				rs.open sql, cnn,3 ,3
				if not RS.EOF then
				   if isnull(rs("MaiorMatricula")) then
				   		strMatricula = strAnoLetivo & "00000"
				   else
				        
				  	 	strMatricula = rs("MaiorMatricula")
				   end if
				else
				   strMatricula = strAnoLetivo & "00000"
				end if 
				rs.close 
			end if 
		else
			sql = "SELECT CODIGO" 
			sql = sql & " FROM SCA_ALUNO"
			sql = sql & " WHERE MATRICULA='" & strMatricula & "'"
			rs.open sql, cnn,3 ,3
			if not RS.EOF then
				rs.close
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: \nMatrícula informada já existente. Verifique!");
					window.history.back();
				</script>
				<%
				response.end
			end if 
			rs.close 
		end if
		
		sql = "SET NoCount ON Insert Into SCA_ALUNO (MATRICULA, NOMEALUNO, DATAMATRICULA, "
		sql = sql & " COD_SITUACAOALUNO, SEXOALUNO, DATAFASTAMENTO, DATANASCIMENTO, DATAEMISSAOCERTIDAONASCIMENTO, NUMREGISTRONASC, FOLHA, LIVRO, TERMO, NOMECARTORIO, "
		sql = sql & " CIDADENASCIMENTO, UFNASCIMENTO, LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
		sql = sql & " BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, COD_ESTADOCIVIL, "
		sql = sql & " COD_PROFISSAO, COD_RELIGIAO, COD_ETNIA, COD_NECESPECIAL, cod_condicao_especial, condicao_especial_outro, ATENDIMENTOESPECIAL, SALA_AEE, PAI, PAIFALECIDO, "
		sql = sql & " PAIFONE, PAIDATANASCIMENTO, PAI_COD_PROFISSAO, PAI_COD_GRAUINSTRUCAO, MAE, MAEFALECIDA, "
		sql = sql & " MAEFONE, MAEDATANASCIMENTO, MAE_COD_PROFISSAO, MAE_COD_GRAUINSTRUCAO, RESPONSAVEL, CPFRESPONSAVEL, "
		sql = sql & " RESPONSAVELFONE, RESPONSAVELDATANASCIMENTO, RESPONSAVEL_COD_PROFISSAO, RESPONSAVEL_COD_GRAUINSTRUCAO, QTDE_IRMAO, "
		sql = sql & " QTDE_IRMAO_ESCOLA, FONERESIDENCIAL, FONECOMERCIAL, FONECELULAR, NACIONALIDADE, COD_TIPONACIONALIDADE, IDENTIDADE, IdentidadeOrgao, IdentidadeUF, "
		sql = sql & " TITULOELEITOR, TITULOZONA, TITULOSECAO, REGMILITAR, CPFALUNO, COD_FORMAINGRESSO, OBSAFASTAMENTO, COD_PLANOTURMA, "
		sql = sql & " COD_GRADEVESTIBULAR, MESANOVESTIBULAR, DATACOLACAO, ANOCONCLUSAO, SEMCONCLUSAO, DATACONCLUSAO,"
		sql = sql & " DATACERTIFICADO, EMAIL, CTRVIACE, DATAINGRESSO, "
		sql = sql & " SETRANSP, COD_MOTIVOAFASTAMENTO, LOGRADOURO_COBRANCA, NUMERO_ENDERECO_COBRANCA, COMP_ENDERECO_COBRANCA, "
		sql = sql & " ESCOLA_ENSINOMEDIO, ESCOLA_ORIGEM, CODIGOINEP, CIDADE_ENSINOMEDIO, ANO_ENSINOMEDIO, SEMESTRE_ENSINOMEDIO, Disciplina_Processo_Seletivo, SENHA, bolsa_familia, CARTAOSUS, CPF, usuario_incl, data_hora_incl,"

		sql = sql & " RESPONSAVEL_QUEM, "
		sql = sql & " RESPONSAVEL_GRAU_PARESTESCO, "
		sql = sql & " RESPOSAVEL_POSSUI_DOCUMENTACAO, "
		sql = sql & " MEDICAMENTO_CONTROLADO, "
		sql = sql & " MEDICAMENTO_CONTROLADO_QUAL,"
		sql = sql & " TRANSPORTE_ESCOLAR,"
		sql = sql & " AUTORIZA_USO_IMAGEM,"
		sql = sql & " RESTRICAO_ALIMENTAR, "
		sql = sql & " RESTRICAO_ALIMENTAR_QUAL,"
		sql = sql & " ALERGIA, "
		sql = sql & " ALERGIA_QUAL,"
		sql = sql & " cod_tamanho_roupa, cod_tamanho_calcado,"
		sql = sql & " ID_CENSO)"
		
		sql = sql & " Values ("
		sql = sql & "" & strMatricula & ","
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
		if strCod_situacaoaluno = "" then strCod_situacaoaluno = "1"
		if isnull(strCod_situacaoaluno) then strCod_situacaoaluno = "1"
		if 	strCod_situacaoaluno = "0" then
			sql = sql & "1,"
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
		
		if 	strDataEmissaoCertidaoNasc 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDataEmissaoCertidaoNasc & "',"
		end if
		
		if 	strNumeroRegistroNascimento 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNumeroRegistroNascimento & "',"
		end if	
		
		if 	strFolha 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFolha & "',"
		end if	
		
		if 	strLivro 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLivro & "',"
		end if	
		
		if 	strTermo 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strTermo & "',"
		end if	
		
		if 	strNomeCartorio 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNomeCartorio & "',"
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
		if 	intCodEtnia 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodEtnia & ","
		end if
		if 	strCod_necespecial 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCod_necespecial & ","
		end if

		if 	intCodCodicaoEspecial 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodCodicaoEspecial & ","
		end if
		if 	strCondicaoEspecialOutro 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCondicaoEspecialOutro & "',"
		end if
		
		
		if 	strAtendimentoespecial 	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strAtendimentoespecial & "',"
		end if
		if 	strSalaAEE 	 = "0" then
			sql = sql & "'N',"
		else
			sql = sql & "'" & strSalaAEE & "',"
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
		
		if 	strCPFResponsavel 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCPFResponsavel & "',"
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
		if 	strTipoNacionalidade 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strTipoNacionalidade & ","
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
		if 	strDataConclusao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDataConclusao & "',"
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
		
		if 	strCodigoInep	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCodigoInep & "',"
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
		if 	strSemestreconclusaoEnsinoMedio	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strSemestreconclusaoEnsinoMedio & ","
		end if
		if 	intCodDisciplinaVestibular	= "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodDisciplinaVestibular & ","
		end if
		if 	strSenha	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSenha & "',"
		end if
		
		if 	strbolsaFamilia	 = "" then
			sql = sql & "'',"
		else
			sql = sql & "'" & strbolsaFamilia & "',"
		end if
		if 	strCartaoSUS	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCartaoSUS & "',"
		end if
		if 	strCPF	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCPF & "',"
		end if
		sql = sql & "'" & trim(session("usuarioWeb")) & "',getdate(), "
		sql = sql & "'" & RESPONSAVEL_QUEM & "', "
		sql = sql & "'" & RESPONSAVEL_GRAU_PARESTESCO & "', "
		sql = sql & "'" & RESPOSAVEL_POSSUI_DOCUMENTACAO & "', "
		sql = sql & "'" & MEDICAMENTO_CONTROLADO & "', "
		sql = sql & "'" & MEDICAMENTO_CONTROLADO_QUAL & "',"
		sql = sql & "'" & TRANSPORTE_ESCOLAR & "',"
		sql = sql & "'" & AUTORIZA_USO_IMAGEM & "',"
		sql = sql & "'" & RESTRICAO_ALIMENTAR & "', "
		sql = sql & "'" & RESTRICAO_ALIMENTAR_QUAL & "',"
		sql = sql & "'" & ALERGIA & "', "
		sql = sql & "'" & ALERGIA_QUAL & "', "
		
		if 	intCodTamanhoRoupa	 = "0" or intCodTamanhoRoupa	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodTamanhoRoupa & ","
		end if
		if 	intCodTamanhoCalcado	 = "0" or intCodTamanhoCalcado	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodTamanhoCalcado & ","
		end if
		
		sql = sql & "'" & ID_CENSO & "');SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		GravarLog REPLACE(REPLACE(sql,"SET NoCount ON ",""),";SELECT @@IDENTITY ","")
		
		GravarLogAluno REPLACE(REPLACE(sql,"SET NoCount ON ",""),";SELECT @@IDENTITY ","")
		
		if strCod_situacaoaluno = "" then strCod_situacaoaluno = "1"
		
		'GRAVA NO CONTROLE SITUACAO ALUNO
		sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & strCod_empresa & "," 
		sql = sql & "" & intCodigo & "," 
		sql = sql & "" & SESSION("strAnoLetivo") & "," 
		sql = sql & "" & strSemestre & "," 
		sql = sql & "" & strCod_situacaoaluno & "," 
		sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
		cnn.execute sql
		GravarLog sql
					
		
		'gera linha ano letivo
		sql = "SET NoCount ON insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
		sql = sql & "" & strCod_empresa & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & SESSION("strAnoLetivo") & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & "'A',getdate(),"
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
		
		sql = sql & "'" & trim(session("usuarioWeb")) & "',getdate())"
		sql = sql & ";SELECT @@IDENTITY "
		'response.write sql & "<hr>"
		Set rs = cnn.Execute(sql)
		intCodigoAnoLetivo = rs(0)
		rs.close

		intCodEmp			= strCod_empresa
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodAluno			= intCodigo
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		strOcorrencia		= "Incluído pela ficha do aluno"
		%>
		<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%

		'DOCUMENTACAO DO ALUNO
		sql = "INSERT SCA_ALUNO_DOCUMENTACOES"
		sql = sql & " SELECT " & intCodigo & ", CODIGO, NULL, 'R'" 
		sql = sql & " FROM SCA_DOCUMENTACOES"
		cnn.execute sql
		GravarLog sql
		
		'DEPENDENCIAS ESPECIAIS
		deficiencias = request.form("chkDeficiencia")
		if trim(deficiencias) <> "" then
			sql = "insert into SCA_ALUNO_NECESSIDADEESPECIAL"
			sql = sql & " select " & intCodigo & ",Cod_NecEspecial,'" & trim(session("usuarioWeb")) & "',GETDATE()"
			sql = sql & " from sca_necessidadeespecial"
			sql = sql & " where Cod_NecEspecial in (" & deficiencias & ")"
			cnn.Execute(sql)
		end if
		

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
			
			
			'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			IF strCod_situacaoaluno = "0" THEN
				sql = sql & "NULL,"
			ELSE
				sql = sql & "" & strCod_situacaoaluno & ","
			END IF
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql
			
			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	G.SITUACAO = 'A'"'GRADE ATIVA

			rs.open sql, cnn,3,3
			if not RS.EOF then
				while not rs.eof
				
					if strCriarGradeChecandoHistorico = "" or strCriarGradeChecandoHistorico = "S" then
		
						sql = "SELECT HD.SITUACAO"
						sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
						sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
						sql = sql & " WHERE	H.COD_ALUNO = " & intCodigo
						sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
						sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
						Rs1.open sql, cnn,3,3
						if Rs1.EOF then				
					
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA,  COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCod_empresa & "," 
							sql = sql & "" & intCodigo & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
											
						else
							IF ISNULL(Rs1("SITUACAO")) THEN
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & intCodigo & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							ELSE
								IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
			
									sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
									sql = sql & "" & strCod_empresa & "," 
									sql = sql & "" & intCodigo & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_DISCIPLINA") & "," 
									sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
									cnn.execute sql
									GravarLog sql		
								
								END IF
							END IF

						end if
						Rs1.Close	
					else
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA,  COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & strCod_empresa & "," 
						sql = sql & "" & intCodigo & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql		

					end if			
					rs.movenext
				wend
			end if
			rs.close		
			
			'INSERINDO HISTORICO DE SITUACAO ATIVANDO O ALUNO
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "1," 'ATIVO
			sql = sql & "GETDATE())" 
			cnn.execute sql
			GravarLog sql
		end if
		
		
	elseif acao="I" and receberTransferencia = "S" then
		'response.write "entrou aqui..."
		strNomeAnt = request.Form("txtNomeAnt")
		if ucase(strNomealuno) <> ucase(strNomeAnt) then
			strOcorrenciaAlteracaoNome = "Nome do Aluno foi alterado de " & strNomeAnt & " para " & strNomealuno 
		end if
		
		sql = "Update SCA_ALUNO Set "
		sql = sql & " COD_SITUACAOALUNO=1,"
		sql = sql & " DATAFASTAMENTO=NULL,"
		
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
		
		if 	strFolha 	 = "" then
			sql = sql & "FOLHA=NULL,"
		else
			sql = sql & "FOLHA ='" & strFolha & "',"
		end if	
		
		if 	strLivro 	 = "" then
			sql = sql & "LIVRO=NULL,"
		else
			sql = sql & "LIVRO ='" & strLivro & "',"
		end if	
		
		if 	strTermo 	 = "" then
			sql = sql & "TERMO=NULL,"
		else
			sql = sql & "TERMO ='" & strTermo & "',"
		end if	
		
		if 	strNomeCartorio 	 = "" then
			sql = sql & "NOMECARTORIO=NULL,"
		else
			sql = sql & "NOMECARTORIO ='" & strNomeCartorio & "',"
		end if	

		if 	strSexoaluno 	 = "0" then
			sql = sql & "SEXOALUNO=NULL,"
		else
			sql = sql & "SEXOALUNO='" & strSexoaluno & "',"
		end if
		
		if 	strDatanascimento 	 = "" then
			sql = sql & "DATANASCIMENTO=NULL,"
		else
			sql = sql & "DATANASCIMENTO='" & strDatanascimento & "',"
		end if
		
		if 	strDataEmissaoCertidaoNasc 	 = "" then
			sql = sql & "DATAEMISSAOCERTIDAONASCIMENTO = NULL,"
		else
			sql = sql & "DATAEMISSAOCERTIDAONASCIMENTO = '" & strDataEmissaoCertidaoNasc & "',"
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
		if 	intCodEtnia	 = "0" then
			sql = sql & "COD_ETNIA=NULL,"
		else
			sql = sql & "COD_ETNIA=" & intCodEtnia & ","
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
		if 	strSalaAEE 	 = "0" then
			sql = sql & "SALA_AEE='N',"
		else
			sql = sql & "SALA_AEE='" & strSalaAEE & "',"
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
		
		if 	strCPFResponsavel 	 = "" then
			sql = sql & " CPFResponsavel = NULL,"
		else
			sql = sql & " CPFResponsavel = '" & strCPFResponsavel & "',"
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
		if 	strTipoNacionalidade 	 = "0" then
			sql = sql & "COD_TIPONACIONALIDADE=NULL,"
		else
			sql = sql & "COD_TIPONACIONALIDADE=" & strTipoNacionalidade & ","
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
		if 	strDataConclusao 	 = "" then
			sql = sql & "DATACONCLUSAO=NULL,"
		else
			sql = sql & "DATACONCLUSAO='" & strDataConclusao & "',"
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
		
		if 	strCodigoInep	 = "" then
			sql = sql & "CODIGOINEP = NULL,"
		else
			sql = sql & "CODIGOINEP = '" & strCodigoInep & "',"
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
		if 	strSemestreconclusaoEnsinoMedio	 = "" then
			sql = sql & "SEMESTRE_ENSINOMEDIO = NULL,"
		else
			sql = sql & "SEMESTRE_ENSINOMEDIO = " & strSemestreconclusaoEnsinoMedio & ","
		end if
		if 	strbolsaFamilia	 = "" then
			sql = sql & "bolsa_Familia = '',"
		else
			sql = sql & "bolsa_Familia = " & strbolsaFamilia & ","
		end if
		if 	strCartaoSUS = "" then
			sql = sql & "CartaoSUS = NULL,"
		else
			sql = sql & "CartaoSUS = " & strCartaoSUS & ","
		end if

		if 	strCPF	 = "" then
			sql = sql & "CPF = NULL,"
		else
			sql = sql & "CPF = '" & strCPF & "',"
		end if
		sql = sql & "RESPONSAVEL_QUEM = '" & RESPONSAVEL_QUEM & "', "
		sql = sql & "RESPONSAVEL_GRAU_PARESTESCO = '" & RESPONSAVEL_GRAU_PARESTESCO & "', "
		sql = sql & "RESPOSAVEL_POSSUI_DOCUMENTACAO = '" & RESPOSAVEL_POSSUI_DOCUMENTACAO & "', "
		sql = sql & "MEDICAMENTO_CONTROLADO = '" & MEDICAMENTO_CONTROLADO & "', "
		sql = sql & "MEDICAMENTO_CONTROLADO_QUAL = '" & MEDICAMENTO_CONTROLADO_QUAL & "',"
		sql = sql & "TRANSPORTE_ESCOLAR = '" & TRANSPORTE_ESCOLAR & "',"
		sql = sql & "AUTORIZA_USO_IMAGEM = '" & AUTORIZA_USO_IMAGEM & "',"
		sql = sql & "RESTRICAO_ALIMENTAR = '" & RESTRICAO_ALIMENTAR & "', "
		sql = sql & "RESTRICAO_ALIMENTAR_QUAL = '" & RESTRICAO_ALIMENTAR_QUAL & "',"
		sql = sql & "ALERGIA = '" & ALERGIA & "', "
		sql = sql & "ALERGIA_QUAL = '" & ALERGIA_QUAL & "',"
		if 	intCodTamanhoRoupa	 = "0" or intCodTamanhoRoupa	 = "" then
			sql = sql & "cod_tamanho_roupa = NULL,"
		else
			sql = sql & "cod_tamanho_roupa = " & intCodTamanhoRoupa & ","
		end if
		if 	intCodTamanhoCalcado	 = "0" or intCodTamanhoCalcado	 = "" then
			sql = sql & "cod_tamanho_calcado = NULL,"
		else
			sql = sql & "cod_tamanho_calcado = " & intCodTamanhoCalcado & ","
		end if
		IF ID_CENSO="" THEN
			sql = sql & "ID_CENSO = NULL,"
		ELSE
			sql = sql & "ID_CENSO = '" & ID_CENSO & "',"
		END IF
		if 	intCodCodicaoEspecial 	 = "0" then
			sql = sql & "COD_CONDICAO_ESPECIAL = NULL,"
		else
			sql = sql & "COD_CONDICAO_ESPECIAL = " & intCodCodicaoEspecial & ","
		end if
		if 	strCondicaoEspecialOutro 	 = "" then
			sql = sql & "condicao_especial_outro = NULL,"
		else
			sql = sql & "condicao_especial_outro = '" & strCondicaoEspecialOutro & "',"
		end if
		sql = sql & " usuario_altr = '" & trim(session("usuarioWeb")) & "',data_hora_altr = getdate() "
		sql = sql & " Where CODIGO = " & intCodigo
		

		
		cnn.execute sql
		GravarLog sql
		GravarLogAluno sql
		
		if strOcorrenciaAlteracaoNome <> "" then
			'Gera Ocorrencia Automatica quando for alterado o nome
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
			strOcorrencia		= strOcorrenciaAlteracaoNome
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		
		
		'response.write "<br>turma anterior:" & strCodTurmaAnterior
		'response.write "<br>turma :" & strCodTurma
		'response.end
		
		'verifica se a turma do aluno foi alterada
		if (trim(strCodTurma) <> trim(strCodTurmaAnterior)) or (receberTransferencia = "S") then
			
			strCOD_GRADECURRICULARAnterior = 0
			sql = "SELECT COD_GRADECURRICULAR, anoletivo FROM SCA_TURMA"
			sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_TURMA = " & strCodTurmaAnterior
			rs.open sql, cnn
			IF not RS.EOF then		
				strCOD_GRADECURRICULARAnterior = rs("COD_GRADECURRICULAR")
				strAnoLetivoDaTurmaAnterior = rs("anoletivo") 
			END IF		
			Rs.close
			
			strCOD_GRADECURRICULARAtual = 0
			sql = "SELECT COD_GRADECURRICULAR, anoletivo FROM SCA_TURMA"
			sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_TURMA = " & strCodTurma
			rs.open sql, cnn
			IF not RS.EOF then		
				strCOD_GRADECURRICULARAtual = rs("COD_GRADECURRICULAR")
				strAnoLetivoDaTurmaAtual = rs("anoletivo") 
			END IF		
			Rs.close			
			
			'Verifico se existe histórico de situações para o aluno
			sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND COD_ALUNO = " & intCodigo
			sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND SEMESTRE = " & strSemestre
			rs.open sql, cnn
			if rs.eof = false then
			   existeSituacao = "OK"
			else
			   existeSituacao = "NO"
			end if
			rs.close	

		    if existeSituacao = "OK" then
				'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
				sql = "UPDATE SCA_SITUACAO_ACADEMICA_ALUNO "
				sql = sql & " SET COD_TURMA = " & strCodTurma
				sql = sql & " where COD_EMPRESA = " & strCod_empresa
				sql = sql & " and 	COD_ALUNO = " & intCodigo
				sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
				sql = sql & " and 	SEMESTRE = " & strSemestre
				sql = sql & " and 	COD_TURMA = " & strCodTurmaAnterior
				cnn.execute sql
				GravarLog sql
			else
				'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
				sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCod_empresa & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & intCodigo & "," 
				sql = sql & "" & strCodTurma & "," 
				IF strCod_situacaoaluno = "0" or strCod_situacaoaluno = "" THEN
					sql = sql & "NULL,"
				ELSE
					sql = sql & "" & strCod_situacaoaluno & ","
				END IF
				sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
				GravarLog sql
			end if	

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
			
			' tira o aluno da turma e das disciplinas
			sql = "DELETE " 
			sql = sql & " FROM 	SCA_FALTAS_DIARIA "
			sql = sql & " WHERE COD_ALUNO = " & intCodigo
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			cnn.execute sql
			GravarLog sql	

			' limpa a tabela de notas
			sql = "DELETE from SCA_NOTAS_FALTAS "
			sql = sql & " where	COD_ALUNO = " & intCodigo
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			cnn.execute sql
			GravarLog sql	

			' limpa a tabela de notas
			sql = "DELETE "
			sql = sql & " from SCA_NOTAS_PLANILHA "
			sql = sql & " where	COD_ALUNO = " & intCodigo
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			cnn.execute sql
			GravarLog sql			

			' tira o aluno da turma e das disciplinas
			sql = "DELETE "
			sql = sql & " from SCA_ALUNO_DISCIPLINA "
			sql = sql & " where	COD_ALUNO = " & intCodigo
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			cnn.execute sql
			GravarLog sql	
			
			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
			rs.open sql, cnn,3,3
			if not RS.EOF then
				while not rs.eof
									
					if strCriarGradeChecandoHistorico = "" or strCriarGradeChecandoHistorico = "S" then

						sql = "SELECT HD.SITUACAO"
						sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
						sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
						sql = sql & " WHERE	H.COD_ALUNO = " & intCodigo
						sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
						sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
						Rs1.open sql, cnn,3,3
						if Rs1.EOF then				
					
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCod_empresa & "," 
							sql = sql & "" & intCodigo & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
											
						else
							IF ISNULL(Rs1("SITUACAO")) THEN
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & intCodigo & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							ELSE
								IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
			
									sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
									sql = sql & "" & strCod_empresa & "," 
									sql = sql & "" & intCodigo & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_DISCIPLINA") & "," 
									sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
									cnn.execute sql
									GravarLog sql		
								
								END IF
							END IF
						end if
						Rs1.Close							
					
					else

						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & strCod_empresa & "," 
						sql = sql & "" & intCodigo & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql		
	
					end if
					
					rs.movenext
				wend
			end if
			rs.close
			
			'-----atualiza vaga na turma
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql
			
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurmaAnterior
			cnn.execute sql
			GravarLog sql
				
			'----------------------
			
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
			
			codEmpresaOrigem 	= Trim(Request("txtCodEmpresa"))
			
			'atualiza ano letivo anterior
			sql = "update SCA_ALUNO_ANO_LETIVO set SITUACAO = 'T'"
			sql = sql & " where COD_ALUNO = " & intCodAluno
			sql = sql & " and ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and SEMESTRE = " & strSemestre
			sql = sql & " and COD_EMPRESA = " & codEmpresaOrigem
			'response.write sql & "<hr>"
			cnn.execute sql
			
			
			if strCod_situacaoaluno = "" then strCod_situacaoaluno = "1"
			'gera linha ano letivo
			sql = "SET NoCount ON insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
			sql = sql & "" & strCod_empresa & ","
			sql = sql & "" & intCodAluno & ","
			sql = sql & "" & strAnoLetivo & ","
			sql = sql & "" & strSemestre & ","
			sql = sql & "'A',getdate(),"
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
			
			sql = sql & "'" & trim(session("usuarioWeb")) & "',getdate())"
			sql = sql & ";SELECT @@IDENTITY "
			'response.write sql & "<hr>"
			Set rs = cnn.Execute(sql)
			intCodigoAnoLetivo = rs(0)
			rs.close
		
			'gera historico de transferencia
			sql = "insert into SCA_ALUNO_RECEBIDO_TRANSFERENCIA (COD_EMPRESA_ORIGEM,COD_EMPRESA_DESTINO,COD_ALUNO_ANO_LETIVO,COD_ALUNO,USUARIO_INCL,DATA_HORA_INCL) values ("
			sql = sql & "" & codEmpresaOrigem & ","
			sql = sql & "" & strCod_empresa & ","
			sql = sql & "" & intCodigoAnoLetivo & ","
			sql = sql & "" & intCodAluno & ","
			sql = sql & "'" & session("usuarioWeb") & "',getdate())"
			'response.write sql & "<hr>"
			cnn.execute sql
			
			strCod_situacaoalunoAtivo = 1
			
			'GRAVA NO CONTROLE SITUACAO ALUNO
			sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & strCod_situacaoalunoAtivo & "," 
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
			cnn.execute sql
			GravarLog sql
			
			'busca a unidade de ultima movimentação do aluno
			sql = "select top 1 COD_EMPRESA"
			sql = sql & " from SCA_ALUNO_TURMA"
			sql = sql & " where COD_ALUNO = " & intCodAluno
			sql = sql & " AND COD_EMPRESA <> " & strCod_empresa
			sql = sql & " order by codigo desc"
			rs.open sql, cnn
			if not rs.eof then
				intCodEmpresaUltimaMovimentacao = rs("cod_empresa")
			end if 
			rs.close
			
			'if session("usuarioWeb") = "SERGIO" THEN
			'	RESPONSE.WRITE "ultima mov:" & intCodEmpresaUltimaMovimentacao & "<hr>"
			'end if			
			
			'limpa historico da unidade onde está sendo alocado
			sql = "delete"
			sql = sql & " from SCA_HISTORICO_OBSERVACOES"
			sql = sql & " where cod_aluno=" & intCodAluno
			sql = sql & " and cod_empresa = " & strCod_empresa
			'if session("usuarioWeb") = "SERGIO" THEN
			'	RESPONSE.WRITE sql & "<hr>"
			'end if			
			cnn.execute sql
			
			sql = "delete SCA_HISTORICO_ESCOLAR_DISCIPLINA where cod_historico_escolar in ("
			sql = sql & " select codigo"
			sql = sql & " from SCA_HISTORICO_ESCOLAR"
			sql = sql & " where cod_aluno=" & intCodAluno
			sql = sql & " and cod_empresa = " & strCod_empresa
			sql = sql & " )"
			'if session("usuarioWeb") = "SERGIO" THEN
			'	RESPONSE.WRITE sql & "<hr>"
			'end if			
			cnn.execute sql
			
			sql = "delete"
			sql = sql & " from SCA_HISTORICO_ESCOLAR"
			sql = sql & " where cod_aluno=" & intCodAluno
			sql = sql & " and cod_empresa = " & strCod_empresa
			'if session("usuarioWeb") = "SERGIO" THEN
			'	RESPONSE.WRITE sql & "<hr>"
			'end if			
			cnn.execute sql
			
			if intCodEmpresaUltimaMovimentacao = "" then intCodEmpresaUltimaMovimentacao = 0
			'busca historico escolar
			sql = "select *"
			sql = sql & " from SCA_HISTORICO_ESCOLAR"
			sql = sql & " where cod_aluno=" & intCodAluno
			sql = sql & " and cod_empresa = "& intCodEmpresaUltimaMovimentacao
			'response.write sql & "<hr>"
			'if session("usuarioWeb") = "SERGIO" THEN
			'	RESPONSE.WRITE sql & "<hr>"
			'end if	
			vetHist = null
			rs.open sql, cnn
			if not rs.eof then
				vetHist = rs.getRows
			end if
			rs.close
			
			if isArray(vetHist) then
				controle = 0
				for i=0 to ubound(vetHist,2)
					codigo_historico= vetHist(0,i) 
					cod_aluno  		= vetHist(1,i) 
					cod_empresa  	= strCod_empresa
					ano_letivo  	= vetHist(3,i) 
					semestre  		= vetHist(4,i) 
					escola  		= vetHist(5,i) 
					cidade  		= vetHist(6,i) 
					uf  			= vetHist(7,i) 
					curso  			= vetHist(8,i) 
					serie  			= vetHist(9,i) 
					Cod_Curso  		= vetHist(10,i) 
					Cod_Periodo  	= vetHist(11,i) 
					observacao  	= vetHist(12,i) 
					mostrar_historico_rel  	= vetHist(13,i) 
					ch_total  		= vetHist(14,i) 
					
					sql = "SET NoCount ON insert into SCA_HISTORICO_ESCOLAR (cod_aluno,cod_empresa,ano_letivo,semestre,escola,cidade,uf,curso,serie,Cod_Curso,Cod_Periodo,observacao,mostrar_historico_rel,ch_total) values ("
					sql = sql & "" & cod_aluno & ","
					sql = sql & "" & cod_empresa & ","
					sql = sql & "" & ano_letivo & ","
					sql = sql & "" & semestre & ","
					sql = sql & "'" & escola & "',"
					sql = sql & "'" & cidade & "',"
					sql = sql & "" & uf & ","
					sql = sql & "'" & curso & "',"
					sql = sql & "'" & serie & "',"
					sql = sql & "" & Cod_Curso & ","
					sql = sql & "" & Cod_Periodo & ","
					sql = sql & "'" & observacao & "',"
					sql = sql & "'" & mostrar_historico_rel & "',"
					IF TRIM(ch_total) = "" OR ISNULL(ch_total) THEN
						sql = sql & "NULL)"
					ELSE
						sql = sql & "" & ch_total & ")"
					END IF
					sql = sql & ";SELECT @@IDENTITY "
					'if session("usuarioWeb") = "SERGIO" THEN
					'	RESPONSE.WRITE sql & "<hr>"
					'end if
					Set rs = cnn.Execute(sql)
					intCodigoHistoricoNovo = rs(0)
					rs.close
					
					
					sql = "insert SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar,ano_letivo,cod_curso,cod_periodo,semestre,cod_disciplina,cod_turma,cod_gradecurriculardisciplina"
					sql = sql & ",nota01,falta01,nota02,falta02,nota03,falta03,nota04,falta04,nota05,falta05,nota06,falta06,nota07,falta07,nota08,falta08,nota09,falta09,nota10,falta10,nota11,falta11"
					sql = sql & ",nota12,falta12,nota13,falta13,nota14,falta14,nota15,falta15,media,carga_horaria,situacao,observacao,mostraNota)"
					sql = sql & "SELECT " & intCodigoHistoricoNovo & ",ano_letivo,cod_curso,cod_periodo,semestre,cod_disciplina,cod_turma,cod_gradecurriculardisciplina"
					sql = sql & ",nota01,falta01,nota02,falta02,nota03,falta03,nota04,falta04,nota05,falta05,nota06,falta06,nota07,falta07,nota08,falta08,nota09,falta09,nota10,falta10,nota11,falta11"
					sql = sql & ",nota12,falta12,nota13,falta13,nota14,falta14,nota15,falta15,media,carga_horaria,situacao,observacao,mostraNota FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					sql = sql & "  WHERE cod_historico_escolar = " & codigo_historico
					'if session("usuarioWeb") = "SERGIO" THEN
					'	RESPONSE.WRITE sql & "<hr>"
					'end if
					cnn.Execute(sql)
					
					sql = "insert [SCA_HISTORICO_OBSERVACOES] (Cod_empresa,ano,semestre,cod_curso,cod_turma,cod_aluno,observacoes)"
					sql = sql & " select " & cod_empresa & ",ano,semestre,cod_curso,cod_turma,cod_aluno,observacoes"
					sql = sql & " from [SCA_HISTORICO_OBSERVACOES]"
					sql = sql & " where cod_aluno = " & cod_aluno
					'if session("usuarioWeb") = "SERGIO" THEN
						'RESPONSE.WRITE sql & "<hr>"
					'end if
					cnn.Execute(sql)
				next
			end if
			
			strOcorrencia		= "Aluno recebido de outra unidade por transferência."
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%

			'INSERINDO HISTORICO DE SITUACAO ATIVANDO O ALUNO
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "1," 'ATIVO
			sql = sql & "GETDATE())" 
			cnn.execute sql
			GravarLog sql			

			'INSERINDO HISTORICO DE SITUACAO ATIVANDO O ALUNO
			sql = "insert into SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL, TIPO_OCORRENCIA, INCLUSAO) "
			sql = sql & " select COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,DATAOCORRENCIA,OCORRENCIA,USUARIO_INCL,TIPO_OCORRENCIA,INCLUSAO"
			sql = sql & " from SCA_OCORRENCIA"
			sql = sql & " where TIPO_OCORRENCIA in ('A','D')"
			sql = sql & " and INCLUSAO = 'USUARIO'"
			sql = sql & " and COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql

		end if	
		
	elseif acao="A" then
		
		
		
		if 	intCodCodicaoEspecial 	 = "0" then
			sql = sql & "COD_CONDICAO_ESPECIAL = NULL,"
		else
			sql = sql & "COD_CONDICAO_ESPECIAL = " & intCodCodicaoEspecial & ","
		end if
		if 	strCondicaoEspecialOutro 	 = "" then
			sql = sql & "condicao_especial_outro = NULL,"
		else
			sql = sql & "condicao_especial_outro = '" & strCondicaoEspecialOutro & "',"
		end if		
		'' Verifica se a data de afastamento foi informada corretamente conforme a situacao do aluno
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.Cod_ALUNO = A.CODIGO "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
		sql = sql & " Where AA.COD_EMPRESA = " & strCod_empresa
		if intCodigo <> "" then
			sql = sql & " And 	A.codigo = " & intCodigo
		else
			sql = sql & " And 	A.matricula = " & strMatricula
		end if
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
		end if
		rsAux.close	
	 
		if trim(Session("MatriculaInformatizada")) =  "SIM" then

			strMensagem = "Aluno Efetivado com sucesso..."

			sql = "Update SCA_ALUNO Set "
			
			if 	strNomealuno 	 = "" then
				sql = sql & "NOMEALUNO=NULL,"
			else
				sql = sql & "NOMEALUNO='" & strNomealuno & "',"
			end if
			sql = sql & " COD_SITUACAOALUNO=1"
			sql = sql & " Where CODIGO = " & intCodigo
			cnn.execute sql		
			
			' Atualiza a Mat Inscricao
			sql = " UPDATE MAT_inscricao SET " 
			sql = sql & " Efetivacao = 'S'"
			sql = sql & " Where Cod_Empresa = " & strCod_empresa
			sql = sql & " and cod_aluno = " &  intCodigo
			cnn.execute sql
			
'			response.write "<hr>" & strCodTurma & "-" & strCodTurmaTroca
			
			if trim(strCodTurma) <> trim(strCodTurmaTroca) and strCodTurmaTroca <> "" then
			
				' Atualiza a turma do aluno
				sql = " UPDATE sca_aluno_turma SET " 
				sql = sql & " COD_TURMA = " & strCodTurma
				sql = sql & " Where Cod_Empresa = " & strCod_empresa
				sql = sql & " and cod_aluno = " &  intCodigo
				sql = sql & " and COD_TURMA = " &  strCodTurmaTroca
'response.write sql & "<hr>"				
				cnn.execute sql

				''---------------------------------------------------''
				sql = "select tu.cod_turno, tu.cod_periodo"
				sql = sql & " from SCA_TURMA TU"
				sql = sql & " where TU.Cod_Empresa  = " & session("codEmpresa")
				sql = sql & " and TU.cod_turma = " & strCodTurma
'response.write sql & "<hr>"				
				rs.open sql, cnn,3,3
				if not RS.EOF then
					intCodTurno = rs("cod_turno")
					intCodPeriodo = rs("cod_periodo")
				end if
				rs.close
				
				' Atualiza a turma do aluno
				sql = " UPDATE sca_aluno_turma SET " 
				sql = sql & " COD_TURMA = " & strCodTurma
				sql = sql & " Where Cod_Empresa = " & strCod_empresa
				sql = sql & " and cod_aluno = " &  intCodigo
				sql = sql & " and COD_TURMA = " &  strCodTurmaTroca
'response.write sql & "<hr>"				
				cnn.execute sql
				
				' Atualiza a turma do aluno em Aluno Disciplina
				sql = " UPDATE SCA_ALUNO_DISCIPLINA SET " 
				sql = sql & " COD_TURMA = " & strCodTurma & ","
				sql = sql & " COD_TURMA_REMANEJAMENTO = " & strCodTurma
				sql = sql & " Where Cod_Empresa = " & strCod_empresa
				sql = sql & " and cod_aluno = " &  intCodigo
'response.write sql & "<hr>"				
				cnn.execute sql
				
				' Atualiza a turma do aluno que está em pre-matricula para não furar as vagas
				sql = " UPDATE sca_aluno_turma SET " 
				sql = sql & " COD_TURMA = " & strCodTurmaTroca
				sql = sql & " Where Cod_Empresa = " & strCod_empresa
				sql = sql & " and cod_aluno in "
				sql = sql & " ("
				sql = sql & " select top 1 at.cod_aluno"
				sql = sql & " from SCA_TURMA TU "
				sql = sql & " inner join SCA_ALUNO_TURMA at on at.cod_Turma = tu.cod_turma "
				sql = sql & " inner join SCA_ALUNO a on a.codigo = at.cod_aluno "
				sql = sql & " left join SCA_SITUACAOALUNO sa on sa.Cod_SituacaoAluno = a.Cod_SituacaoAluno "
				sql = sql & " where TU.Cod_Empresa = " & strCod_empresa
				sql = sql & " and TU.Situacao = 'A' "
				sql = sql & " and tu.AnoLetivo = " & strAnoLetivo
				sql = sql & " and tu.Cod_Semestre = " & strSemestre
				sql = sql & " and tu.Cod_Periodo = " & intCodPeriodo 
				sql = sql & " and TU.Cod_Turno = "& intCodTurno
				sql = sql & " and tu.cod_turma = " & strCodTurma
				sql = sql & " and SA.desc_situacaoaluno = 'PRÉ-MATRÍCULA' "
				sql = sql & " order by tu.sala desc, at.cod_aluno desc"				
				sql = sql & " ) "
'response.write sql & "<hr>"				
				cnn.execute sql
				'cnn.rollbackTrans
'response.end				
			end if
			
			sql = "INSERT INTO SCA_CONTROLE_SITUACAO_ALUNO "
			sql = sql & "(COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL) "
			sql = sql & "SELECT "
			sql = sql & intCodigo & ","
			sql = sql & strCod_empresa & ","
			sql = sql & strAnoLetivo & ","
			sql = sql & strSemestre & ","
			sql = sql & "1,"
			sql = sql & "GETDATE(),"
			sql = sql & "'" & trim(session("usuarioWeb")) & "' "
			sql = sql & "WHERE NOT EXISTS ("
			sql = sql & "SELECT 1 FROM SCA_CONTROLE_SITUACAO_ALUNO "
			sql = sql & "WHERE COD_ALUNO = " & intCodigo
			sql = sql & " AND COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND SEMESTRE = " & strSemestre
			sql = sql & " AND COD_SITUACAOALUNO = 1"
			sql = sql & ")"

			cnn.Execute sql
			
			' tira o aluno da turma e das disciplinas
			sql = "DELETE "
			sql = sql & " from SCA_ALUNO_DISCIPLINA "
			sql = sql & " where	COD_ALUNO = " & intCodigo
			sql = sql & " and	COD_EMPRESA = " & strCod_empresa
			cnn.execute sql
			GravarLog sql	
			
			' Copia o espelho da grade da turma para o aluno
			sql = "INSERT INTO SCA_ALUNO_DISCIPLINA ("
			sql = sql & "COD_EMPRESA, COD_ALUNO, COD_TURMA, "
			sql = sql & "COD_TURMA_REMANEJAMENTO, "
			sql = sql & "COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, "
			sql = sql & "COD_GRADECURRICULARDISCIPLINA, "
			sql = sql & "COD_DISCIPLINA, SITUACAO) "

			sql = sql & "SELECT "
			sql = sql & strCod_empresa & ", "
			sql = sql & intCodigo & ", "
			sql = sql & strCodTurma & ", "
			sql = sql & strCodTurma & ", "
			sql = sql & "GD.COD_GRADECURRICULARDISCIPLINA, "
			sql = sql & "GD.COD_GRADECURRICULARDISCIPLINA, "
			sql = sql & "GD.COD_DISCIPLINA, "
			sql = sql & "'CR' "

			sql = sql & "FROM SCA_GRADECURRICULARDISCIPLINA GD "
			sql = sql & "INNER JOIN SCA_GRADECURRICULAR G "
			sql = sql & " ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
			sql = sql & "INNER JOIN SCA_TURMA T "
			sql = sql & " ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "

			sql = sql & "WHERE T.COD_TURMA = " & strCodTurma
			sql = sql & " AND T.COD_EMPRESA = " & strCod_empresa

			' Evita duplicidade em SCA_ALUNO_DISCIPLINA
			sql = sql & " AND NOT EXISTS ("
			sql = sql & "     SELECT 1 "
			sql = sql & "     FROM SCA_ALUNO_DISCIPLINA AD "
			sql = sql & "     WHERE AD.COD_EMPRESA = " & strCod_empresa
			sql = sql & "       AND AD.COD_ALUNO = " & intCodigo
			sql = sql & "       AND AD.COD_TURMA = " & strCodTurma
			sql = sql & "       AND AD.COD_GRADECURRICULARDISCIPLINA = GD.COD_GRADECURRICULARDISCIPLINA"
			sql = sql & " )"

			cnn.Execute sql
			
			
			' tira o aluno da turma e das disciplinas
			sql = "DELETE "
			sql = sql & " from SCA_NOTAS_FALTAS "
			sql = sql & " where	COD_ALUNO = " & intCodigo
			sql = sql & " and	COD_EMPRESA = " & strCod_empresa
			cnn.execute sql
			GravarLog sql	
			
			' Copia o espelho da grade da turma para o aluno
			sql = "INSERT INTO SCA_NOTAS_FALTAS ("
			sql = sql & "cod_empresa, cod_aluno, cod_aluno_disciplina, ano_letivo, semestre, cod_periodo, cod_disciplina, data_inclusao) "
			sql = sql & "SELECT "
			sql = sql & "COD_EMPRESA, "
			sql = sql & "COD_ALUNO, "
			sql = sql & "CODIGO, "
			sql = sql & strAnoLetivo & ", "
			sql = sql & strSemestre & ", "
			sql = sql & intCodPeriodo & ", "
			sql = sql & "COD_DISCIPLINA, "
			sql = sql & "GETDATE() "
			sql = sql & "     FROM SCA_ALUNO_DISCIPLINA "
			sql = sql & "     WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & "       AND COD_ALUNO = " & intCodigo
			sql = sql & "       AND COD_TURMA = " & strCodTurma
			cnn.Execute sql

			
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
			strOcorrencia		= "Efetivação do aluno"
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%						

		else
			strMensagem = "Registro Alterado com sucesso..."
		end if
		
		'validação para não alterar o nome, somente quando tiver permissãoS
		strUsuarioLiberadoParaAlterarNomeDireto = "NAO"
		if session("codGrupo") = "7" then
			if session("NivelPermissao") = "A" then
				strUsuarioLiberadoParaAlterarNomeDireto = "SIM"
			else
				sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
				sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
				sql = sql & " Where cod_grupo = " & Session("CodGrupo")
				sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
				rs.open sql, cnn
				if rs.eof = false then
					strUsuarioLiberadoParaAlterarNomeDireto = "SIM"
				end if 
				rs.close
			end if
		else
			'demais municipios
			strUsuarioLiberadoParaAlterarNomeDireto = "SIM"
		end if
		strOcorrenciaAlteracaoNome = ""	
		
		''verifica se já existe o aluno com mesma trinca
		if ucase(strNomealuno) <> ucase(strNomeAnt) then
			sql = "select E.RAZAOSOCIAL, S.DESC_SITUACAOALUNO, A.MATRICULA"
			sql = sql & " from sca_aluno A"
			sql = sql & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.COD_ALUNO = A.CODIGO"
			sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = AA.COD_EMPRESA"
			sql = sql & " INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = AA.COD_SITUACAOALUNO"
			sql = sql & " where	NOMEALUNO = '" & ucase(strNomealuno)& "'"
			sql = sql & " AND	DATANASCIMENTO = '" & strDatanascimento & "'"
			sql = sql & " AND	MAE = '" & strMae & "'"
			IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
				'response.write sql & "<hr>"
				'response.end
			END IF
			rs.open sql, cnn
			if not rs.eof then
				matricula_atual = rs("matricula")
				unidade_atual = rs("RAZAOSOCIAL")
				situacao_atual = rs("DESC_SITUACAOALUNO")
				rs.close
				cnn.rollbackTrans
				%>
				<script>
					alert("Aluno foi encontrado com os mesmos dados: nome, data nascimento e mãe com a matrícula <%=matricula_atual%> na unidade <%=unidade_atual%> com a situação <%=situacao_atual%>!");
					window.history.back();
				</script>
				<%
				response.end
			end if
			rs.close
		end if
		
		sql = "Update SCA_ALUNO Set "
		if strUsuarioLiberadoParaAlterarNomeDireto = "SIM" then
			sql = sql & "NOMEALUNO='" & strNomealuno & "',"
			strNomeAnt = request.Form("txtNomeAnt")
			if ucase(strNomealuno) <> ucase(strNomeAnt) then
				strOcorrenciaAlteracaoNome = "Nome do Aluno foi alterado de " & strNomeAnt & " para " & strNomealuno 
			end if
		end if
		
		' Ativa o aluno dentro do processo de Matricula informatizada
		if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
			if trim(Session("MatriculaInformatizada")) =  "SIM" then
			
				if 	intCodSituacaoAluno = "" then
					sql = sql & " COD_SITUACAOALUNO=NULL,"
				else
					sql = sql & " COD_SITUACAOALUNO = " & intCodSituacaoAluno & ","
				end if
			
			end if
		else
			sql = sql & " COD_SITUACAOALUNO = " & intCodSituacaoAluno & ","
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
		
		if 	strFolha 	 = "" then
			sql = sql & "FOLHA=NULL,"
		else
			sql = sql & "FOLHA ='" & strFolha & "',"
		end if	
		
		if 	strLivro 	 = "" then
			sql = sql & "LIVRO=NULL,"
		else
			sql = sql & "LIVRO ='" & strLivro & "',"
		end if	
		
		if 	strTermo 	 = "" then
			sql = sql & "TERMO=NULL,"
		else
			sql = sql & "TERMO ='" & strTermo & "',"
		end if	
		
		if 	strNomeCartorio 	 = "" then
			sql = sql & "NOMECARTORIO=NULL,"
		else
			sql = sql & "NOMECARTORIO ='" & strNomeCartorio & "',"
		end if	

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
		
		if 	strDataEmissaoCertidaoNasc 	 = "" then
			sql = sql & "DATAEMISSAOCERTIDAONASCIMENTO = NULL,"
		else
			sql = sql & "DATAEMISSAOCERTIDAONASCIMENTO = '" & strDataEmissaoCertidaoNasc & "',"
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
		if 	intCodEtnia	 = "0" then
			sql = sql & "COD_ETNIA=NULL,"
		else
			sql = sql & "COD_ETNIA=" & intCodEtnia & ","
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
		if 	strSalaAEE 	 = "0" then
			sql = sql & "SALA_AEE='N',"
		else
			sql = sql & "SALA_AEE='" & strSalaAEE & "',"
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
		
		if 	strCPFResponsavel 	 = "" then
			sql = sql & " CPFResponsavel = NULL,"
		else
			sql = sql & " CPFResponsavel = '" & strCPFResponsavel & "',"
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
		if 	strTipoNacionalidade 	 = "0" then
			sql = sql & "COD_TIPONACIONALIDADE=NULL,"
		else
			sql = sql & "COD_TIPONACIONALIDADE=" & strTipoNacionalidade & ","
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
		if 	strDataConclusao 	 = "" then
			sql = sql & "DATACONCLUSAO=NULL,"
		else
			sql = sql & "DATACONCLUSAO='" & strDataConclusao & "',"
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
		
		if 	strCodigoInep	 = "" then
			sql = sql & "CODIGOINEP = NULL,"
		else
			sql = sql & "CODIGOINEP = '" & strCodigoInep & "',"
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
		if 	strSemestreconclusaoEnsinoMedio	 = "" then
			sql = sql & "SEMESTRE_ENSINOMEDIO = NULL,"
		else
			sql = sql & "SEMESTRE_ENSINOMEDIO = " & strSemestreconclusaoEnsinoMedio & ","
		end if
		if 	strbolsaFamilia	 = "" then
			sql = sql & "bolsa_Familia = '',"
		else
			sql = sql & "bolsa_Familia = " & strbolsaFamilia & ","
		end if
		if 	strCartaoSUS = "" then
			sql = sql & "CartaoSUS = NULL,"
		else
			sql = sql & "CartaoSUS = " & strCartaoSUS & ","
		end if

		if 	strCPF	 = "" then
			sql = sql & "CPF = NULL,"
		else
			sql = sql & "CPF = '" & strCPF & "',"
		end if
		sql = sql & "RESPONSAVEL_QUEM = '" & RESPONSAVEL_QUEM & "', "
		sql = sql & "RESPONSAVEL_GRAU_PARESTESCO = '" & RESPONSAVEL_GRAU_PARESTESCO & "', "
		sql = sql & "RESPOSAVEL_POSSUI_DOCUMENTACAO = '" & RESPOSAVEL_POSSUI_DOCUMENTACAO & "', "
		sql = sql & "MEDICAMENTO_CONTROLADO = '" & MEDICAMENTO_CONTROLADO & "', "
		sql = sql & "MEDICAMENTO_CONTROLADO_QUAL = '" & MEDICAMENTO_CONTROLADO_QUAL & "',"
		sql = sql & "TRANSPORTE_ESCOLAR = '" & TRANSPORTE_ESCOLAR & "',"
		sql = sql & "AUTORIZA_USO_IMAGEM = '" & AUTORIZA_USO_IMAGEM & "',"
		sql = sql & "RESTRICAO_ALIMENTAR = '" & RESTRICAO_ALIMENTAR & "', "
		sql = sql & "RESTRICAO_ALIMENTAR_QUAL = '" & RESTRICAO_ALIMENTAR_QUAL & "',"
		sql = sql & "ALERGIA = '" & ALERGIA & "', "
		sql = sql & "ALERGIA_QUAL = '" & ALERGIA_QUAL & "',"
		if 	intCodTamanhoRoupa	 = "0" or intCodTamanhoRoupa	 = "" then
			sql = sql & "cod_tamanho_roupa = NULL,"
		else
			sql = sql & "cod_tamanho_roupa = " & intCodTamanhoRoupa & ","
		end if
		if 	intCodTamanhoCalcado	 = "0" or intCodTamanhoCalcado	 = "" then
			sql = sql & "cod_tamanho_calcado = NULL,"
		else
			sql = sql & "cod_tamanho_calcado = " & intCodTamanhoCalcado & ","
		end if
		if 	intCodCodicaoEspecial 	 = "0" then
			sql = sql & "COD_CONDICAO_ESPECIAL = NULL,"
		else
			sql = sql & "COD_CONDICAO_ESPECIAL = " & intCodCodicaoEspecial & ","
		end if
		if 	strCondicaoEspecialOutro 	 = "" then
			sql = sql & "condicao_especial_outro = NULL,"
		else
			sql = sql & "condicao_especial_outro = '" & strCondicaoEspecialOutro & "',"
		end if
		IF ID_CENSO="" THEN
			sql = sql & "ID_CENSO = NULL,"
		ELSE
			sql = sql & "ID_CENSO = '" & ID_CENSO & "',"
		END IF
		sql = sql & " usuario_altr = '" & trim(session("usuarioWeb")) & "',data_hora_altr = getdate() "
		sql = sql & " Where CODIGO = " & intCodigo
				
		cnn.execute sql
		GravarLog sql
		
		
		'DEPENDENCIAS ESPECIAIS
		sql = "delete SCA_ALUNO_NECESSIDADEESPECIAL where cod_aluno = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		deficiencias = request.form("chkDeficiencia")
		if trim(deficiencias) <> "" then
			sql = "insert into SCA_ALUNO_NECESSIDADEESPECIAL"
			sql = sql & " select " & intCodigo & ",Cod_NecEspecial,'" & trim(session("usuarioWeb")) & "',GETDATE()"
			sql = sql & " from sca_necessidadeespecial"
			sql = sql & " where Cod_NecEspecial in (" & deficiencias & ")"
			cnn.Execute(sql)
		end if

		
		if strOcorrenciaAlteracaoNome <> "" then
			'Gera Ocorrencia Automatica quando for alterado o nome
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
			strOcorrencia		= strOcorrenciaAlteracaoNome
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		'VERIFICA SE O NOME DA MAE FOI ALTERADO		
		strNomeMaeAnt = request.Form("txtNomeMaeAnt")
		if ucase(strMae) <> ucase(strNomeMaeAnt) then
			strOcorrenciaAlteracaoNomeMae = "Nome da mãe foi alterado de " & strNomeMaeAnt & " para " & strMae 
		end if
		if strOcorrenciaAlteracaoNomeMae <> "" then
			'Gera Ocorrencia Automatica quando for alterado o nome
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
			strOcorrencia		= strOcorrenciaAlteracaoNomeMae
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		'VERIFICA SE O NOME DA PAI FOI ALTERADO		
		strNomePaiAnt = request.Form("txtNomePaiAnt")
		if ucase(strPai) <> ucase(strNomePaiAnt) then
			strOcorrenciaAlteracaoNomePai = "Nome do pai foi alterado de " & strNomePaiAnt & " para " & strPai 
		end if
		if strOcorrenciaAlteracaoNomePai <> "" then
			'Gera Ocorrencia Automatica quando for alterado o nome
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
			strOcorrencia		= strOcorrenciaAlteracaoNomePai
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		'VERIFICA SE O NOME DA RESPOSAVEL FOI ALTERADO		
		strNomeResponsavelAnt = request.Form("txtNomeResponsavelAnt")
		if ucase(strResponsavel) <> ucase(strNomeResponsavelAnt) then
			strOcorrenciaAlteracaoNomeResponsavel = "Nome do responsavel foi alterado de " & strNomeResponsavelAnt & " para " & strResponsavel 
		end if
		if strOcorrenciaAlteracaoNomeResponsavel <> "" then
			'Gera Ocorrencia Automatica quando for alterado o nome
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
			strOcorrencia		= strOcorrenciaAlteracaoNomeResponsavel
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		
		intCodAluno			= intCodigo
		strCod_situacaoaluno = request.form("txtCodSituacaoAluno")
		if strCod_situacaoaluno = "2" then
			sql = " update sca_aluno set COD_SITUACAOALUNO=1"
			sql = sql & " Where CODIGO = " & intCodAluno
			cnn.execute sql
			strCod_situacaoaluno = 1
			
			'GRAVA NO CONTROLE SITUACAO ALUNO
			sql = "INSERT INTO SCA_CONTROLE_SITUACAO_ALUNO "
			sql = sql & "(COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL) "
			sql = sql & "SELECT "
			sql = sql & intCodigo & ","
			sql = sql & strCod_empresa & ","
			sql = sql & strAnoLetivo & ","
			sql = sql & strSemestre & ","
			sql = sql & "" & strCod_situacaoaluno & ","
			sql = sql & "GETDATE(),"
			sql = sql & "'" & strUsuarioIncl & "' "
			sql = sql & "WHERE NOT EXISTS ("
			sql = sql & "SELECT 1 FROM SCA_CONTROLE_SITUACAO_ALUNO "
			sql = sql & "WHERE COD_ALUNO = " & intCodigo
			sql = sql & " AND COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND SEMESTRE = " & strSemestre
			sql = sql & " AND COD_SITUACAOALUNO = " & strCod_situacaoaluno
			sql = sql & ")"

			cnn.Execute sql
			
			sql = " update sca_aluno set senha = '" & strSenha & "'"
			sql = sql & " Where CODIGO = " & intCodAluno
			sql = sql & " And senha is null"
			cnn.execute sql
		else
			sql = " update sca_aluno set senha = '" & strSenha & "'"
			sql = sql & " Where CODIGO = " & intCodAluno
			sql = sql & " And senha is null"
			cnn.execute sql
		end if
		
		'verifica se a turma do aluno foi alterada
		if trim(strCodTurma) <> trim(strCodTurmaAnterior) then
			strCOD_GRADECURRICULARAnterior = 0
			strNomeTurmaAnterior = ""
			sql = "SELECT COD_GRADECURRICULAR, NomeTurma, TurmaAluno  FROM SCA_TURMA"
			sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_TURMA = " & strCodTurmaAnterior
			rs.open sql, cnn
			IF not RS.EOF then		
				strCOD_GRADECURRICULARAnterior = rs("COD_GRADECURRICULAR")
				strNomeTurmaAnterior = rs("TurmaAluno") & " " & rs("NomeTurma")
			END IF		
			Rs.close
			
			strCOD_GRADECURRICULARAtual = 0
			strNomeTurmaAtual=""
			sql = "SELECT COD_GRADECURRICULAR, NomeTurma, TurmaAluno FROM SCA_TURMA"
			sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_TURMA = " & strCodTurma
			rs.open sql, cnn
			IF not RS.EOF then		
				strCOD_GRADECURRICULARAtual = rs("COD_GRADECURRICULAR")
				strNomeTurmaAtual = rs("TurmaAluno") & " " & rs("NomeTurma")
			END IF		
			Rs.close				
			
			'-------------------------------------------------------
			'------ INICIO - TROCA A FICHA DESCRITIVA DE TURMA -----
			'-------------------------------------------------------
			sql = "select cod_turno"
			sql = sql & " from SCA_TURMA"
			sql = sql & " where cod_turma = " & strCodTurma
			rs.open sql, cnn
			if not RS.EOF then
				intCodTurno = rs("cod_turno")
			end if
			rs.close
			
			intcodTurmaVerificacaoCadastro = strCodTurma
			
			sql = " select DISTINCT TOP 1 FDPN.Codigo, FDPN.COD_TURMA, T.Cod_GradeCurricular, FDPN.Cod_Turno_Rh, FDP.cod_ficha_descritiva "
			sql = sql & " from SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA FDPN "
			sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA_PERGUNTA FDP ON FDP.codigo = FDPN.Cod_Ficha_Descritiva_Pergunta " 
			sql = sql & " INNER JOIN SCA_FICHA_DESCRITIVA FD ON FD.codigo = FDP.cod_ficha_descritiva "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = FDPN.Cod_Turma "
			sql = sql & " where FDPN.Cod_aluno = " & intCodAluno
			sql = sql & " AND T.AnoLetivo = " & strAnoLetivo
			sql = sql & " AND T.Cod_Semestre = " & strSemestre
			sql = sql & " ORDER BY FDPN.Codigo DESC "
			rs.open sql, cnn
			if rs.eof = false then
				intcodTurmaVerificacaoFicha = rs("COD_TURMA")
			else
				intcodTurmaVerificacaoFicha = "0"
			end if 
			rs.close

			if intcodTurmaVerificacaoFicha <> intcodTurmaVerificacaoCadastro then

				sql = "  UPDATE SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA SET Cod_Turno_Rh = " & intCodTurno & ",Cod_Turma = " & intcodTurmaVerificacaoCadastro
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " AND Cod_Turma = " & intcodTurmaVerificacaoFicha
				'if session("usuarioWeb") = "SERGIO" THEN
				'		RESPONSE.WRITE SQL & "<hr>"
				'end if
				cnn.execute SQL
			end if
			'-------------------------------------------------------
			'------ FIM - TROCA A FICHA DESCRITIVA DE TURMA --------
			'-------------------------------------------------------
			
			'inativa a turma anterior
			sql = "update SCA_ALUNO_TURMA "
			sql = sql & " SET SITUACAO = 'R'," 
			sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	COD_ALUNO = " & intCodigo
   		    sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
			'response.write sql
			cnn.execute sql
			GravarLog sql			
	
	
			'Verifico se existe histórico de situações para o aluno
			sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND COD_ALUNO = " & intCodigo
			sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND SEMESTRE = " & strSemestre
			rs.open sql, cnn
			if rs.eof = false then
			   existeSituacao = "OK"
			else
			   existeSituacao = "NO"
			end if
			rs.close	

		    if existeSituacao = "OK" then
				'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
				sql = "UPDATE SCA_SITUACAO_ACADEMICA_ALUNO "
				sql = sql & " SET COD_TURMA = " & strCodTurma
				sql = sql & " where COD_EMPRESA = " & strCod_empresa
				sql = sql & " and 	COD_ALUNO = " & intCodigo
				sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
				sql = sql & " and 	SEMESTRE = " & strSemestre
				sql = sql & " and 	COD_TURMA = " & strCodTurmaAnterior
				cnn.execute sql
				GravarLog sql
			else
				'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
				sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCod_empresa & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & intCodigo & "," 
				sql = sql & "" & strCodTurma & "," 
				IF strCod_situacaoaluno = "0" or strCod_situacaoaluno = "" THEN
					sql = sql & "NULL,"
				ELSE
					sql = sql & "" & strCod_situacaoaluno & ","
				END IF
				sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
				GravarLog sql
			end if	

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


			strRemoveGrade=""
			if (trim(strCOD_GRADECURRICULARAnterior) <> trim(strCOD_GRADECURRICULARAtual)) then
				strRemoveGrade = " (remoção/inclusão de grade)"
				' tira o aluno da turma e das disciplinas
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_FALTAS_DIARIA "
				sql = sql & " WHERE COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql	

				' limpa a tabela de notas
				sql = "DELETE N"
				sql = sql & " from SCA_NOTAS_FALTAS N"
				sql = sql & " where	N.COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql	

				' limpa a tabela de notas
				sql = "DELETE "
				sql = sql & " from SCA_NOTAS_PLANILHA "
				sql = sql & " where	COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql			

				' tira o aluno da turma e das disciplinas
				sql = "DELETE "
				sql = sql & " from SCA_ALUNO_DISCIPLINA "
				sql = sql & " where	COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql	
				
				' Copia o espelho da grade da turma para o aluno
				sql = "INSERT INTO SCA_ALUNO_DISCIPLINA ("
				sql = sql & "COD_EMPRESA, COD_ALUNO, COD_TURMA, "
				sql = sql & "COD_TURMA_REMANEJAMENTO, "
				sql = sql & "COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, "
				sql = sql & "COD_GRADECURRICULARDISCIPLINA, "
				sql = sql & "COD_DISCIPLINA, SITUACAO) "

				sql = sql & "SELECT "
				sql = sql & strCod_empresa & ", "
				sql = sql & intCodigo & ", "
				sql = sql & strCodTurma & ", "
				sql = sql & strCodTurma & ", "
				sql = sql & "GD.COD_GRADECURRICULARDISCIPLINA, "
				sql = sql & "GD.COD_GRADECURRICULARDISCIPLINA, "
				sql = sql & "GD.COD_DISCIPLINA, "
				sql = sql & "'CR' "

				sql = sql & "FROM SCA_GRADECURRICULARDISCIPLINA GD "
				sql = sql & "INNER JOIN SCA_GRADECURRICULAR G "
				sql = sql & " ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
				sql = sql & "INNER JOIN SCA_TURMA T "
				sql = sql & " ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "

				sql = sql & "WHERE T.COD_TURMA = " & strCodTurma
				sql = sql & " AND T.COD_EMPRESA = " & strCod_empresa

				' Evita duplicidade em SCA_ALUNO_DISCIPLINA
				sql = sql & " AND NOT EXISTS ("
				sql = sql & "     SELECT 1 "
				sql = sql & "     FROM SCA_ALUNO_DISCIPLINA AD "
				sql = sql & "     WHERE AD.COD_EMPRESA = " & strCod_empresa
				sql = sql & "       AND AD.COD_ALUNO = " & intCodigo
				sql = sql & "       AND AD.COD_TURMA = " & strCodTurma
				sql = sql & "       AND AD.COD_GRADECURRICULARDISCIPLINA = GD.COD_GRADECURRICULARDISCIPLINA"
				sql = sql & " )"

				' Verifica histórico somente quando configurado
				If strCriarGradeChecandoHistorico = "" Or strCriarGradeChecandoHistorico = "S" Then

					sql = sql & " AND NOT EXISTS ("
					sql = sql & "     SELECT 1 "
					sql = sql & "     FROM SCA_HISTORICO_ESCOLAR H "
					sql = sql & "     INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD "
					sql = sql & "       ON HD.COD_HISTORICO_ESCOLAR = H.CODIGO "
					sql = sql & "     WHERE H.COD_ALUNO = " & intCodigo
					sql = sql & "       AND H.COD_EMPRESA = " & strCod_empresa
					sql = sql & "       AND HD.COD_GRADECURRICULARDISCIPLINA = GD.COD_GRADECURRICULARDISCIPLINA"
					sql = sql & "       AND HD.SITUACAO IN ('AP','DI')"
					sql = sql & " )"

				End If

				cnn.Execute sql
				
				
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
				
				' Copia o espelho da grade da turma para o aluno
				sql = "INSERT INTO SCA_ALUNO_DISCIPLINA ("
				sql = sql & "COD_EMPRESA, COD_ALUNO, COD_TURMA, "
				sql = sql & "COD_TURMA_REMANEJAMENTO, "
				sql = sql & "COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, "
				sql = sql & "COD_GRADECURRICULARDISCIPLINA, "
				sql = sql & "COD_DISCIPLINA, SITUACAO) "

				sql = sql & "SELECT "
				sql = sql & strCod_empresa & ", "
				sql = sql & intCodigo & ", "
				sql = sql & strCodTurma & ", "
				sql = sql & strCodTurma & ", "
				sql = sql & "GD.COD_GRADECURRICULARDISCIPLINA, "
				sql = sql & "GD.COD_GRADECURRICULARDISCIPLINA, "
				sql = sql & "GD.COD_DISCIPLINA, "
				sql = sql & "'CR' "

				sql = sql & "FROM SCA_GRADECURRICULARDISCIPLINA GD "
				sql = sql & "INNER JOIN SCA_GRADECURRICULAR G "
				sql = sql & " ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
				sql = sql & "INNER JOIN SCA_TURMA T "
				sql = sql & " ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "

				sql = sql & "WHERE T.COD_TURMA = " & strCodTurma
				sql = sql & " AND T.COD_EMPRESA = " & strCod_empresa

				' Evita duplicidade em SCA_ALUNO_DISCIPLINA
				sql = sql & " AND NOT EXISTS ("
				sql = sql & "     SELECT 1 "
				sql = sql & "     FROM SCA_ALUNO_DISCIPLINA AD "
				sql = sql & "     WHERE AD.COD_EMPRESA = " & strCod_empresa
				sql = sql & "       AND AD.COD_ALUNO = " & intCodigo
				sql = sql & "       AND AD.COD_TURMA = " & strCodTurma
				sql = sql & "       AND AD.COD_GRADECURRICULARDISCIPLINA = GD.COD_GRADECURRICULARDISCIPLINA"
				sql = sql & " )"

				' Verifica histórico somente quando configurado
				If strCriarGradeChecandoHistorico = "" Or strCriarGradeChecandoHistorico = "S" Then

					sql = sql & " AND NOT EXISTS ("
					sql = sql & "     SELECT 1 "
					sql = sql & "     FROM SCA_HISTORICO_ESCOLAR H "
					sql = sql & "     INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD "
					sql = sql & "       ON HD.COD_HISTORICO_ESCOLAR = H.CODIGO "
					sql = sql & "     WHERE H.COD_ALUNO = " & intCodigo
					sql = sql & "       AND H.COD_EMPRESA = " & strCod_empresa
					sql = sql & "       AND HD.COD_GRADECURRICULARDISCIPLINA = GD.COD_GRADECURRICULARDISCIPLINA"
					sql = sql & "       AND HD.SITUACAO IN ('AP','DI')"
					sql = sql & " )"

				End If

				cnn.Execute sql

			end if
			
			'-----atualiza vaga na turma
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql
			
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurmaAnterior
			cnn.execute sql
			GravarLog sql
				
			'----------------------
			
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
			
			
			if trim(receberTransferencia) = "S" then
				
				codEmpresaOrigem 	= Trim(Request("txtCodEmpresa"))
				'atualiza situacao do aluno
				sql = "update SCA_ALUNO set COD_SITUACAOALUNO = 1"
				sql = sql & " where CODIGO = " & intCodAluno
				'response.write sql & "<hr>"
				cnn.execute sql
				
				'atualiza ano letivo anterior
				sql = "update SCA_ALUNO_ANO_LETIVO set SITUACAO = 'T'"
				sql = sql & " where COD_ALUNO = " & intCodAluno
				sql = sql & " and ANO_LETIVO = " & strAnoLetivo
				sql = sql & " and SEMESTRE = " & strSemestre
				sql = sql & " and COD_EMPRESA = " & codEmpresaOrigem
				'response.write sql & "<hr>"
				cnn.execute sql
				
				'atualiza ano letivo anterior
				sql = "update SCA_ALUNO_TURMA set SITUACAO = 'I'"
				sql = sql & " where SITUACAO = 'A' and COD_ALUNO = " & intCodAluno
				sql = sql & " and ANO_LETIVO = " & strAnoLetivo
				sql = sql & " and COD_EMPRESA = " & codEmpresaOrigem
				'response.write sql & "<hr>"
				cnn.execute sql
				
				if strCod_situacaoaluno = "" then strCod_situacaoaluno = "1"
				'gera linha ano letivo
				sql = "SET NoCount ON insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,SITUACAO,DATA_SITUACAO,USUARIO_INCL,DATA_HORA_INCL) values ("
				sql = sql & "" & strCod_empresa & ","
				sql = sql & "" & intCodAluno & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & "'A',getdate(),'" & trim(session("usuarioWeb")) & "',getdate())"
				sql = sql & ";SELECT @@IDENTITY "
				'response.write sql & "<hr>"
				Set rs = cnn.Execute(sql)
				intCodigoAnoLetivo = rs(0)
				rs.close
				
				'GRAVA NO CONTROLE SITUACAO ALUNO
				sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCod_empresa & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & strCod_situacaoaluno & "," 
				sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
				cnn.execute sql
			
				'gera historico de transferencia
				sql = "insert into SCA_ALUNO_RECEBIDO_TRANSFERENCIA (COD_EMPRESA_ORIGEM,COD_EMPRESA_DESTINO,COD_ALUNO_ANO_LETIVO,COD_ALUNO,USUARIO_INCL,DATA_HORA_INCL) values ("
				sql = sql & "" & codEmpresaOrigem & ","
				sql = sql & "" & strCod_empresa & ","
				sql = sql & "" & intCodigoAnoLetivo & ","
				sql = sql & "" & intCodAluno & ","
				sql = sql & "'" & session("usuarioWeb") & "',getdate())"
				'response.write sql & "<hr>"
				cnn.execute sql
				
				'busca historico escolar
				sql = "select *"
				sql = sql & " from SCA_HISTORICO_ESCOLAR"
				sql = sql & " where cod_aluno=" & intCodAluno
				'response.write sql & "<hr>"
				vetHist = null
				rs.open sql, cnn
				if not rs.eof then
					vetHist = rs.getRows
				end if
				rs.close
					
				if isArray(vetHist) then
					controle = 0
					for i=0 to ubound(vetHist,2)
						codigo_historico= vetHist(0,i) 
						cod_aluno  		= vetHist(1,i) 
						cod_empresa  	= strCod_empresa
						ano_letivo  	= vetHist(3,i) 
						semestre  		= vetHist(4,i) 
						escola  		= vetHist(5,i) 
						cidade  		= vetHist(6,i) 
						uf  			= vetHist(7,i) 
						curso  			= vetHist(8,i) 
						serie  			= vetHist(9,i) 
						Cod_Curso  		= vetHist(10,i) 
						Cod_Periodo  	= vetHist(11,i) 
						observacao  	= vetHist(12,i) 
						mostrar_historico_rel  	= vetHist(13,i) 
						ch_total  		= vetHist(14,i) 
						
						sql = "SET NoCount ON insert into SCA_HISTORICO_ESCOLAR (cod_aluno,cod_empresa,ano_letivo,semestre,escola,cidade,uf,curso,serie,Cod_Curso,Cod_Periodo,observacao,mostrar_historico_rel,ch_total) values ("
						sql = sql & "" & cod_aluno & ","
						sql = sql & "" & cod_empresa & ","
						sql = sql & "" & ano_letivo & ","
						sql = sql & "" & semestre & ","
						sql = sql & "'" & escola & "',"
						sql = sql & "'" & cidade & "',"
						sql = sql & "" & uf & ","
						sql = sql & "'" & curso & "',"
						sql = sql & "'" & serie & "',"
						sql = sql & "" & Cod_Curso & ","
						sql = sql & "" & Cod_Periodo & ","
						sql = sql & "'" & observacao & "',"
						sql = sql & "'" & mostrar_historico_rel & "',"
						IF TRIM(ch_total) = "" OR ISNULL(ch_total) THEN
							sql = sql & "NULL)"
						ELSE
							sql = sql & "" & ch_total & ")"
						END IF
						sql = sql & ";SELECT @@IDENTITY "
						'response.write sql & "<hr>"
						Set rs = cnn.Execute(sql)
						intCodigoHistoricoNovo = rs(0)
						rs.close
						
						
						sql = "insert SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar,ano_letivo,cod_curso,cod_periodo,semestre,cod_disciplina,cod_turma,cod_gradecurriculardisciplina"
						sql = sql & ",nota01,falta01,nota02,falta02,nota03,falta03,nota04,falta04,nota05,falta05,nota06,falta06,nota07,falta07,nota08,falta08,nota09,falta09,nota10,falta10,nota11,falta11"
						sql = sql & ",nota12,falta12,nota13,falta13,nota14,falta14,nota15,falta15,media,carga_horaria,situacao,observacao,mostraNota)"
						sql = sql & "SELECT " & intCodigoHistoricoNovo & ",ano_letivo,cod_curso,cod_periodo,semestre,cod_disciplina,cod_turma,cod_gradecurriculardisciplina"
						sql = sql & ",nota01,falta01,nota02,falta02,nota03,falta03,nota04,falta04,nota05,falta05,nota06,falta06,nota07,falta07,nota08,falta08,nota09,falta09,nota10,falta10,nota11,falta11"
						sql = sql & ",nota12,falta12,nota13,falta13,nota14,falta14,nota15,falta15,media,carga_horaria,situacao,observacao,mostraNota FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA"
						sql = sql & "  WHERE cod_historico_escolar = " & codigo_historico
						'response.write sql & "<hr>"
						cnn.Execute(sql)
						
						sql = "insert [SCA_HISTORICO_OBSERVACOES] (Cod_empresa,ano,semestre,cod_curso,cod_turma,cod_aluno,observacoes)"
						sql = sql & " select " & cod_empresa & ",ano,semestre,cod_curso,cod_turma,cod_aluno,observacoes"
						sql = sql & " from [SCA_HISTORICO_OBSERVACOES]"
						sql = sql & " where cod_aluno = " & cod_aluno
						'response.write sql & "<hr>"
						cnn.Execute(sql)
					next
				end if
				
				strOcorrencia		= "Aluno recebido de outra unidade"
				%>
				<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
				<%	
			else
				strOcorrencia		= "Alteração de turma na ficha do aluno" & strRemoveGrade& ". " & strNomeTurmaAnterior & " -> " & strNomeTurmaAtual
				%>
				<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
				<%
			end if
		end if
		
		'Verifico se existe o aluno no ano letivo
		sql = "SELECT COD_ALUNO FROM SCA_ALUNO_ANO_LETIVO"
		sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
		sql = sql & " AND COD_ALUNO = " & intCodAluno
		sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND SEMESTRE = " & strSemestre
		
		rs.open sql, cnn
		if rs.eof = false then
		   existeAlunoAnoLetivo = "SIM"
		else
		   existeAlunoAnoLetivo = "NAO"
		end if
		rs.close	
		
		IF existeAlunoAnoLetivo = "SIM" then
			sql = " update SCA_ALUNO_ANO_LETIVO set "
			sql = sql & " SITUACAO = 'A', COD_SITUACAOALUNO=1"
			sql = sql & " Where cod_ALUNO = " & intCodAluno
			sql = sql & " And cod_empresa = " & strCod_empresa
			sql = sql & " And ANO_LETIVO = " & strAnoLetivo
			sql = sql & " And COD_SITUACAOALUNO = 2"
			
			cnn.execute sql
			GravarLog sql
		else
			'gera linha ano letivo para aluno que não tem
			sql = "insert into SCA_ALUNO_ANO_LETIVO ("
			sql = sql & " COD_EMPRESA"
			sql = sql & " ,COD_ALUNO"
			sql = sql & " ,ANO_LETIVO"
			sql = sql & " ,SEMESTRE"
			sql = sql & " ,SITUACAO"
			sql = sql & " ,DATA_SITUACAO"
			sql = sql & " ,COD_SITUACAOALUNO"
			sql = sql & " ,LOGRADOURO"
			sql = sql & " ,NUMERO_ENDERECO"
			sql = sql & " ,COMP_ENDERECO"
			sql = sql & " ,BAIRROALUNO"
			sql = sql & " ,CIDADERESIDENCIA"
			sql = sql & " ,UFRESIDENCIA"
			sql = sql & " ,CEPRESIDENCIA"
			sql = sql & " ,USUARIO_INCL"
			sql = sql & " ,DATA_HORA_INCL"
			sql = sql & " ,USUARIO_ALTR"
			sql = sql & " ,DATA_HORA_ALTR) "
			sql = sql & " select distinct "
			sql = sql & " t.COD_EMPRESA"
			sql = sql & " ,t.COD_ALUNO"
			sql = sql & " ,t.ANO_LETIVO"
			sql = sql & " ,t.SEMESTRE"
			sql = sql & " ,t.SITUACAO"
			sql = sql & " ,t.DATA_SITUACAO"
			sql = sql & " ,1 as COD_SITUACAOALUNO"
			sql = sql & " ,a.LOGRADOURO"
			sql = sql & " ,a.NUMERO_ENDERECO"
			sql = sql & " ,a.COMP_ENDERECO"
			sql = sql & " ,a.BAIRROALUNO"
			sql = sql & " ,a.CIDADERESIDENCIA"
			sql = sql & " ,uf.sigla as UFRESIDENCIA"
			sql = sql & " ,a.CEPRESIDENCIA"
			sql = sql & " ,a.USUARIO_INCL"
			sql = sql & " ,a.DATA_HORA_INCL"
			sql = sql & " ,a.USUARIO_ALTR"
			sql = sql & " ,a.DATA_HORA_ALTR"
			sql = sql & " from SCA_ALUNO_TURMA t"
			sql = sql & " inner join SCA_ALUNO a on a.codigo = t.COD_ALUNO "
			sql = sql & " left join SCA_ALUNO_ANO_LETIVO aa on aa.COD_ALUNO = t.COD_ALUNO and aa.ANO_LETIVO = t.ANO_LETIVO"
			sql = sql & " left join SCF_UF uf on uf.codigo = a.UFRESIDENCIA"
			sql = sql & " where t.ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and t.cod_aluno = " & intCodAluno 
			sql = sql & " and t.situacao = 'A'"
			sql = sql & " and aa.COD_ALUNO is null "
			cnn.Execute(sql)
			
		end if

	elseif acao = "E" then
		cod_empresa = strCod_empresa
		strMensagem = "Registro Excluido com sucesso..."

		' tira o aluno faltas diarias
		sql = "DELETE " 
		sql = sql & " FROM 	SCA_FALTAS_DIARIA "
		sql = sql & " WHERE COD_ALUNO = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
		cnn.execute sql
		GravarLog sql	

		' limpa a tabela de notas
		sql = "DELETE "
		sql = sql & " from SCA_NOTAS_FALTAS "
		sql = sql & " where	COD_ALUNO = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
		cnn.execute sql
		GravarLog sql

		' limpa a tabela de notas
		sql = "DELETE "
		sql = sql & " from SCA_NOTAS_PLANILHA "
		sql = sql & " where	COD_ALUNO = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
		cnn.execute sql
		GravarLog sql			

		' tira o aluno da turma e das disciplinas
		sql = "DELETE "
		sql = sql & " from SCA_ALUNO_DISCIPLINA "
		sql = sql & " where	COD_ALUNO = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
		cnn.execute sql
		GravarLog sql	
		
		sql = "Delete from SCA_CONTROLE_SITUACAO_ALUNO"
		sql = sql & " Where cod_aluno = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
'response.write sql & "<br>"
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from SCA_ALUNO_TURMA_SITUACAO"
		sql = sql & " Where cod_aluno = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
		cnn.execute sql
		GravarLog sql
			
		
		'EXCLUI aluno na turma
		sql = "delete from SCA_ALUNO_TURMA"
		sql = sql & " where COD_ALUNO = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
'response.write sql
		cnn.execute sql
		GravarLog sql

		'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
		sql = "DELETE FROM SCA_SITUACAO_ACADEMICA_ALUNO "
		sql = sql & " where COD_ALUNO = " & intCodigo
		sql = sql & " and cod_empresa = " & cod_empresa
		cnn.execute sql
		GravarLog sql

		
		if trim(strCod_situacaoaluno) = "1" or trim(strCod_situacaoaluno) = "2"  then 
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql	
		end if

		sql = "update MAT_inscricao set excluido='S', usuario_exc_cadastro='" & trim(session("usuarioWeb")) & "', data_exc_cadastro=getdate()"
		sql = sql & " Where cod_aluno = " & intCodigo
		cnn.execute sql
		GravarLog sql

		
		sql = "update MAT_reserva set usuario_exc_cadastro='" & trim(session("usuarioWeb")) & "', data_exc_cadastro=getdate()"
		sql = sql & " Where cod_aluno = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		quant = 1
		sql = "SELECT COUNT(*) AS QUANT from SCA_ALUNO_ANO_LETIVO"
		sql = sql & " Where cod_aluno = " & intCodigo
		rs.open sql, cnn
		if not rs.eof then
			quant = rs("quant")
		end if
		rs.close
		
		sql = "Delete from SCA_ALUNO_ANO_LETIVO"
		sql = sql & " Where cod_aluno = " & intCodigo
		sql = sql & " and cod_empresa = " & strCod_empresa
		cnn.execute sql
		GravarLog sql
		GravarLogAluno sql
		strTipoExclusao = "EXCLUIDO DA UNIDADE"
		if cINT(quant) = 1 then
	
			'EXCLUI aluno na documentos
			sql = "delete from SCA_ALUNO_DOCUMENTACOES"
			sql = sql & " WHERE COD_ALUNO = " & intCodigo
			cnn.execute sql
			GravarLog sql

			sql = "Delete from SCA_ALUNO"
			sql = sql & " Where CODIGO = " & intCodigo
			cnn.execute sql
			GravarLog sql
			GravarLogAluno sql
			
			strTipoExclusao = "EXCLUSAO TOTAL"
		end if
		
		
		sql = "insert into SCA_ALUNO_EXCLUIDO_FICHA (cod_aluno,matricula,cpf,nome,data_nascimento,mae,cod_empresa,cod_turma,usuario,data_hora,tipo) values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & strMatricula & ","
		sql = sql & "'" & strCPF & "',"
		sql = sql & "'" & strNomealuno & "',"
		sql = sql & "'" & strDatanascimento & "',"
		sql = sql & "'" & strMae & "',"
		sql = sql & "" & strCod_empresa & ","
		sql = sql & "" & strCodTurma & ","
		sql = sql & "'" & SESSION("usuarioWeb") & "',"
		sql = sql & "GETDATE(),"
		sql = sql & "'" & strTipoExclusao & "')"
		cnn.execute sql
	end if

	
	strFotoAluno       	 = request("txtFotoAlunoHidden")
	strFotoAlunoAnterior = request("txtFotoAlunoAnteriorHidden")
	if trim(strFotoAluno)<>trim(strFotoAlunoAnterior) then
	
		'-------- Apaga a foto do aluno
		sql="DELETE"
		sql = sql & " FROM 	SCA_ALUNO_FOTO "
		sql = sql & " WHERE COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		intCodEmp			= strCod_empresa
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodAluno			= intCodigo
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		
		
		'if ucase(session("usuarioweb")) = "SERGIO" then 
		'	response.write "acao:" & acao & "<hr>"
		'	response.write "strFotoAluno:" & strFotoAluno & "<hr>"
		'	response.end
		'end if
		'
		
		if acao = "I" or acao = "A" then
			if trim(strFotoAluno) = "" then
				strOcorrencia		= "Foto do aluno excluída."
			else
				'--------- INSERE A FOTO DO ALUNO
				sql="INSERT INTO SCA_ALUNO_FOTO (cod_aluno, base64) values (" & intCodigo & ",'" & strFotoAluno & "')"
				cnn.execute sql
				
				if strFotoAlunoAnterior = "img/aluno-sem-foto.jpg" then
					strOcorrencia		= "Foto do aluno incluída."
				else
					strOcorrencia		= "Foto do aluno alterada."
				end if
			end if
			%>
			<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%
		end if	
	end if
	
	'ATUALIZA SITUACAO_ALUNO
	sql = "EXEC [dbo].[SP_SCA_ATUALIZA_SITUACAO_ALUNO] " & strAnoLetivo & "," & intCodigo
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.rollbackTrans
		cnn.commitTrans
		if acao="E" then	
			strParametro = "sca_aluno.asp"
		else
			
			if trim(Session("MatriculaInformatizada")) =  "SIM" then
				strParametro = "sca_rel_ficha_individual_rel.asp?mat=s&txtCodAluno=" & intCodigo
			else
				strParametro = "sca_aluno.asp?txtCodAluno=" & intCodigo
			end if
	
		end if
		
		if receberTransferencia = "S" then
			strMensagem = "Inclusão EFETIVADA, transferência Finalizada com sucesso!!!"
			strParametro = "sca_aluno.asp?txtCodAluno=" & intCodigo
		end if
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strParametro%>';
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