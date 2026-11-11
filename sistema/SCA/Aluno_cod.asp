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
	
	strFolha			= ReplaceRequest(Trim(Request.Form("txtFolha")))
	strLivro			= ReplaceRequest(Trim(Request.Form("txtLivro")))
	strTermo			= ReplaceRequest(Trim(Request.Form("txtTermo")))
	strNomeCartorio		= ReplaceRequest(Trim(Request.Form("txtNomeCartorio")))
	strbolsaFamilia 	= ReplaceRequest(TRIM(request("txtBolsaFamilia")))

	strSexoaluno 					= ReplaceRequest(Trim(Request.Form("cmbSexo")))
	strDatanascimento 				= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatanascimento"))))
	strDataEmissaoCertidaoNasc 		= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDataEmissaoCertidaoNascimento")))) 
	strSenha 						= FormatCripto(replace(formatadataAP(Request.Form("txtDatanascimento")),"/",""),True)
	
	strCidadenascimento = ReplaceRequest(Trim(Request.Form("txtCidadenascimento")))
	strUfnascimento 	= ReplaceRequest(Trim(Request.Form("cmbUfnascimento")))
	if strUfnascimento = "" then strUfnascimento = "0"

	strNacionalidade 	= Trim(Request.Form("cmbNacionalidade"))
	strTipoNacionalidade= Trim(Request.Form("cmbTipoNacionalidade"))
	strCod_estadocivil 	= ReplaceRequest(Trim(Request.Form("cmbEstadoCivil")))
	strCod_profissao 	= ReplaceRequest(Trim(Request.Form("cmbProfissao")))
	strCod_religiao 	= ReplaceRequest(Trim(Request.Form("cmbReligiao")))
	intCodEtnia 		= Trim(Request.Form("cmbEtnia"))
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
	strUfEnsinoMedio			= Trim(Request.Form("cmbUFEnsinoMedio"))
	
	strSemconclusao 			= ReplaceRequest(Trim(Request.Form("txtSemconclusao")))
	strDataConclusao 			= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDataConclusao"))))
	strDatacertificado 			= formataDataBD(ReplaceRequest(Trim(Request.Form("txtDatacertificado"))))
	intCodDisciplinaVestibular 	= Trim(Request.Form("cmbDisciplinaVestibular"))

	intViaCarterinha 	= ReplaceRequest(Trim(Request.Form("cmbViaCarterinha")))
	if intViaCarterinha = "" then intViaCarterinha = "0"
	strSetransp 		= ReplaceRequest(Trim(Request.Form("txtSetransp")))

	'dados finaceiro
	strCod_planoturma 	= "0"

	strLogradouro_cobranca 		= ReplaceRequest(Trim(Request.Form("txtLogradouro_cobranca")))
	strNumero_endereco_cobranca	= ReplaceRequest(Trim(Request.Form("txtNumero_endereco_cobranca")))
	strComp_endereco_cobranca 	= ReplaceRequest(Trim(Request.Form("txtComp_endereco_cobranca")))	

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
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and Desc_SituacaoAluno = 'ATIVO'"
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
		sql = sql & " where COD_EMPRESA = " & strCod_empresa
		sql = sql & " and Desc_SituacaoAluno = 'ATIVO'"
		rsAux.open sql, cnn, 3, 3
		if not rsAux.EOF then	
			intCodSituacaoAluno = trim(rsAux("Cod_SituacaoAluno"))
		end if
		rsAux.close	
	end if
	
	if acao = "A" then
		
		'' Verifica se a data de afastamento foi informada corretamente conforme a situacao do aluno
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
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
	 
		if trim(strDescSituacaoAluno) = "ATIVO" then
			if trim(strDatafastamento) <> "" then
				cnn.rollbackTrans
				if trim(Session("MatriculaInformatizada")) =  "SIM" then
					strParametro = "AlunoMatricula_con.asp?txtCodAluno=" & intCodigo
				else
					strParametro = "Aluno_cad.asp?txtCodAluno=" & intCodigo
				end if
				%>
				<script>
					alert("ATENÇÃO: A Data de Afastamento informada não confere com a Situação de Vínculo do Aluno. Verifique!");
					window.location='<%=strParametro%>';
				</script>
				<%
				response.end
			end if
		end if		
	end if
			
	if acao="I" then
	
		'Teste de Duplicação de cadastro
	
		vetnomealuno = split(strNomealuno, " ")
		sql = " SELECT nomealuno "
		sql = sql & " FROM sca_aluno "
		sql = sql & " WHERE SOUNDEX(substring(nomealuno,1,len( '" & vetnomealuno(O) & "'))) = SOUNDEX('" & vetnomealuno(O) & "')" 
		sql = sql & " and datanascimento = '" & strDatanascimento & "'"
		sql = sql & " AND COD_EMPRESA IN (SELECT CODIGO FROM SEG_EMPRESA WHERE COD_GRUPO = " & Session("CodGrupo") & ")"
		rs.open sql, cnn
		if not RS.EOF then
			%>
			<script>
				alert("ATENÇÃO: Já existe um cadastro com o(a) aluno(a): <%=vetnomealuno(O)%>, onde sua data de nascimento confere com a data informada.\n O Registro será incluso, mesmo assim verifique na consulta a possibilidade de uma Duplicidade.");
			</script>
			<%
		end if
		rs.close
		
		strMensagem = "Registro Salvo com sucesso..."

		'regra da tabela de configurações do sistema
		if Session("strChecarFinanceiro") = "S" then
			strCod_situacaoaluno = "0"
		end if
		
		SQL = "SET NoCount ON INSERT INTO MAT_INSCRICAO_CONTROLE_MATRICULA (DATA) VALUES(GETDATE()) ;SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
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
					if isnull(strSequenciaMatricula) or strSequenciaMatricula = "" then
					   strSequenciaMatricula = "0"
					end if
					strSequenciaMatricula = cInt(strSequenciaMatricula) + 1
					strMatricula = strAnoLetivoMatricula & strSemestreMatricula & ZeroLeft(strSequenciaMatricula,4)
				end if
			else
			   strMatricula = strAnoLetivo & strSemestre & "0000"
			end if 
			rs.close 
			
			if bolMatriculaDiferenteDaUltima then
				sql = "SELECT Max(Matricula)+1 as MaiorMatricula" 
				sql = sql & " FROM SCA_ALUNO"
				sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND LEFT(MATRICULA,5)='" & strUltimaSequenciaAnoSemestreAtual&"'"
				rs.open sql, cnn,3 ,3
				if not RS.EOF then
				   if isnull(rs("MaiorMatricula")) then
				   		strMatricula = strAnoLetivo & strSemestre & "0000"
				   else
				        
				  	 	strMatricula = rs("MaiorMatricula")
				   end if
				else
				   strMatricula = strAnoLetivo & strSemestre & "0000"
				end if 
				rs.close 
			end if 
		else
			sql = "SELECT CODIGO" 
			sql = sql & " FROM SCA_ALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND MATRICULA='" & strMatricula & "'"
			rs.open sql, cnn,3 ,3
			if not RS.EOF then
				%>
				<script>
					alert("ATENÇÃO: \n\nMatrícula informada já existente. Verifique!");
					window.history.back();
				</script>
				<%
				response.end
			end if 
			rs.close 
		end if

		sql = "Insert Into SCA_ALUNO (COD_EMPRESA, CODIGO, MATRICULA, NOMEALUNO, DATAMATRICULA, "
		sql = sql & " COD_SITUACAOALUNO, SEXOALUNO, DATAFASTAMENTO, DATANASCIMENTO, DATAEMISSAOCERTIDAONASCIMENTO, NUMREGISTRONASC, FOLHA, LIVRO, TERMO, NOMECARTORIO, "
		sql = sql & " CIDADENASCIMENTO, UFNASCIMENTO, LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
 		sql = sql & " BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, COD_ESTADOCIVIL, "
		sql = sql & " COD_PROFISSAO, COD_RELIGIAO, COD_ETNIA, COD_NECESPECIAL, ATENDIMENTOESPECIAL, PAI, PAIFALECIDO, "
		sql = sql & " PAIFONE, PAIDATANASCIMENTO, PAI_COD_PROFISSAO, PAI_COD_GRAUINSTRUCAO, MAE, MAEFALECIDA, "
		sql = sql & " MAEFONE, MAEDATANASCIMENTO, MAE_COD_PROFISSAO, MAE_COD_GRAUINSTRUCAO, RESPONSAVEL, CPFRESPONSAVEL, "
		sql = sql & " RESPONSAVELFONE, RESPONSAVELDATANASCIMENTO, RESPONSAVEL_COD_PROFISSAO, RESPONSAVEL_COD_GRAUINSTRUCAO, QTDE_IRMAO, "
		sql = sql & " QTDE_IRMAO_ESCOLA, FONERESIDENCIAL, FONECOMERCIAL, FONECELULAR, NACIONALIDADE, COD_TIPONACIONALIDADE, IDENTIDADE, IdentidadeOrgao, IdentidadeUF, "
		sql = sql & " TITULOELEITOR, TITULOZONA, TITULOSECAO, REGMILITAR, CPFALUNO, COD_FORMAINGRESSO, OBSAFASTAMENTO, COD_PLANOTURMA, "
		sql = sql & " COD_GRADEVESTIBULAR, MESANOVESTIBULAR, DATACOLACAO, ANOCONCLUSAO, SEMCONCLUSAO, DATACONCLUSAO,"
		sql = sql & " DATACERTIFICADO, EMAIL, CTRVIACE, DATAINGRESSO, "
		sql = sql & " SETRANSP, COD_MOTIVOAFASTAMENTO, LOGRADOURO_COBRANCA, NUMERO_ENDERECO_COBRANCA, COMP_ENDERECO_COBRANCA, "
		sql = sql & " ESCOLA_ENSINOMEDIO, ESCOLA_ORIGEM, CODIGOINEP, CIDADE_ENSINOMEDIO, ANO_ENSINOMEDIO, SEMESTRE_ENSINOMEDIO, UF_ENSINOMEDIO, Disciplina_Processo_Seletivo, SENHA, bolsa_familia)"

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
		if 	strUfEnsinoMedio	 = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strUfEnsinoMedio & ","
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
			sql = sql & "NULL)"
		else
			sql = sql & "'" & strbolsaFamilia & "')"
		end if

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
		strOcorrencia		= "Incluído pela ficha do aluno"
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%

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
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
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
			
		end if
	elseif acao="A" then
		
		if trim(Session("MatriculaInformatizada")) =  "SIM" then

			strMensagem = "Aluno Efetivado com sucesso..."

			sql = "Update SCA_ALUNO Set "
			
			if 	strNomealuno 	 = "" then
				sql = sql & "NOMEALUNO=NULL,"
			else
				sql = sql & "NOMEALUNO='" & strNomealuno & "',"
			end if
			if 	intCodSituacaoAluno = "" then
				sql = sql & " COD_SITUACAOALUNO=NULL"
			else
				sql = sql & " COD_SITUACAOALUNO = " & intCodSituacaoAluno & ""
			end if
			sql = sql & " Where Cod_Empresa = " & session("codEmpresa")
			sql = sql & " And CODIGO = " & intCodigo
'response.write sql & "<hr>"				
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
				sql = sql & " left join SCA_SITUACAOALUNO sa on sa.Cod_SituacaoAluno = a.Cod_SituacaoAluno and sa.Cod_Empresa = a.Cod_Empresa "
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
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
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
			'abadia
			strUsuarioLiberadoParaAlterarNomeDireto = "SIM"
		end if
		strOcorrenciaAlteracaoNome = ""	
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
		if 	intCodDisciplinaVestibular	 = "0" then
			sql = sql & "Disciplina_Processo_Seletivo = NULL,"
		else
			sql = sql & "Disciplina_Processo_Seletivo = " & intCodDisciplinaVestibular & ","
		end if
		if 	strbolsaFamilia	 = "" then
			sql = sql & "bolsa_Familia = NULL,"
		else
			sql = sql & "bolsa_Familia = " & strbolsaFamilia & ","
		end if
		
		if 	strUfEnsinoMedio	 = "0" then
			sql = sql & "UF_ENSINOMEDIO = NULL"
		else
			sql = sql & "UF_ENSINOMEDIO = " & strUfEnsinoMedio & ""
		end if

		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And CODIGO = " & intCodigo
'response.Write(sql)
		cnn.execute sql
		GravarLog sql
		
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
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%					
		end if
		
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
			
			if trim(strCOD_GRADECURRICULARAnterior) <> trim(strCOD_GRADECURRICULARAtual) then

                
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
				alert("ATENÇÃO: Aluno não pode ser excluído.");
				window.history.back();
			</script>
			<%
			response.end
		end if

		' tira o aluno faltas diarias
		sql = "DELETE " 
		sql = sql & " FROM 	SCA_FALTAS_DIARIA "
		sql = sql & " WHERE COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql	

		' limpa a tabela de notas
		sql = "DELETE "
		sql = sql & " from SCA_NOTAS_FALTAS "
		sql = sql & " where	COD_ALUNO = " & intCodigo
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

		'EXCLUI aluno na turma
		sql = "delete from SCA_ALUNO_TURMA"
		sql = sql & " where COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql

		'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
		sql = "DELETE FROM SCA_SITUACAO_ACADEMICA_ALUNO "
		sql = sql & " where COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql

		'EXCLUI aluno na documentos
		sql = "delete from SCA_ALUNO_DOCUMENTACOES"
		sql = sql & " WHERE COD_ALUNO = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SCA_CONTROLE_SITUACAO_ALUNO"
		sql = sql & " Where cod_aluno = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
		sql = sql & " And 	A.codigo = " & intCodigo
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
		end if
		rsAux.close
		
			
		if trim(strDescSituacaoAluno) = "ATIVO" or trim(strDescSituacaoAluno) = "PRÉ-MATRÍCULA"  then 
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql	
		end if

		if Session("CodGrupo") = 7 then 'aparecida
			sql = "update MAT_inscricao set excluido='S', usuario_exc_cadastro='" & trim(session("usuarioWeb")) & "', data_exc_cadastro=getdate()"
			sql = sql & " Where Cod_Empresa = " & strCod_empresa
			sql = sql & " And cod_aluno = " & intCodigo
			cnn.execute sql
			GravarLog sql
		end if
				
		sql = "Delete from SCA_ALUNO"
		sql = sql & " Where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql

	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="E" then	
			strParametro = "Aluno_cad.asp"
		else
			
			if trim(Session("MatriculaInformatizada")) =  "SIM" then
				strParametro = "AlunoMatricula_con.asp?txtCodAluno=" & intCodigo
			else
				strParametro = "Aluno_cad.asp?txtCodAluno=" & intCodigo
			end if
	
		end if
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strParametro%>';
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