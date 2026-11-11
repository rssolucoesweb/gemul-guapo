<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: inclui inscricao para o cadastro do aluno
	::  Data de Alteração.: 27/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
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

	'carregando variavel
	'chave
	acao 					= Trim(Request.QueryString("acao"))
	strCod_empresa 			= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strInscricao 			= Trim(Request.Form("txtInscricao"))
	strCodTurma				= ReplaceRequest(Trim(Request.Form("cmbTurma")))
		

	if 	strCodTurma = "" then strCodTurma = "0"
	
	' Consulto o Nome da Turma
	if strCodTurma <> 0 then
		
		sql = "select COD_SEMESTRE, Cod_Turma, NomeTurma, AnoLetivo from SCA_TURMA"
		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And Cod_Turma = " & strCodTurma
		rs.open sql, cnn
		if rs.eof = false then
			strNomeTurma = rs("NomeTurma")
			strSemestre  = rs("Cod_Semestre")
			strAnoLetivo = rs("AnoLetivo")
		end if
		rs.close	

	end if

	'Consulta Situacao do Aluno -  pre
	strCod_situacaoaluno = 2
	
	' Pega os dados da Inscrição do Vestibular
	sql = "SELECT R.*, U.CODIGO AS UF_ FROM MAT_RESERVA R LEFT JOIN SCF_UF U ON U.SIGLA = R.UF"
	sql = sql & " WHERE R.codigo = " & strInscricao
	rs.open sql, cnn
	if rs.eof = false then
		 strSexoaluno 					= trim(rs("SEXO"))
		 strNomealuno 					= trim(rs("Nome"))
		 strDatanascimento 				= FORMATADATABD(trim(rs("Data_Nascimento")))
		 strMae							= trim(rs("mae"))
		 strNacionalidade 				= "BRASILEIRA"
		 strFoneResidencial 			= trim(rs("Contato"))
		 strEmail 						= trim(rs("email"))
		 strLogradouro 					= trim(rs("LOGRADOURO"))
		 strNumero_endereco 			= trim(rs("NUMEROENDERECO"))
		 strComp_endereco 				= trim(rs("COMPLEMENTOENDERECO"))
		 strBairroaluno	 				= trim(rs("BAIRRO"))
		 strCidaderesidencia			= trim(rs("CIDADE"))
		 strUfresidencia				= rs("UF_")
		 strCepresidencia	 			= replace(rs("CEP"),"-","")
		 strSenha 						= FormatCripto(replace(formatadataAP(rs("Data_Nascimento")),"/",""),True)
		 strDatamatricula               = FORMATADATABD(date)
		 strDataingresso                = FORMATADATABD(date)
	     strLogradouro_cobranca         = rs("LOGRADOURO")
		 strNumero_endereco_cobranca	= rs("NUMEROENDERECO")
		 strCPF                         = rs("cpf")
		 strComp_endereco_cobranca 		= rs("COMPLEMENTOENDERECO")
		 if strUfresidencia = "" then strUfresidencia = "0"

		 if isnull(strDatanascimento) then strDatanascimento = ""
		 if isnull(strNacionalidade) then strNacionalidade = ""
		 if isnull(strFoneResidencial) then strFoneResidencial = ""
		 if isnull(strEmail) then strEmail = ""
		 if isnull(strLogradouro) then strLogradouro = ""
		 if isnull(strBairroaluno) then strBairroaluno = ""
		 if isnull(strCidaderesidencia) then strCidaderesidencia = ""
		 if isnull(strUfresidencia) then strUfresidencia = ""
		 if isnull(strCepresidencia) then strCepresidencia = ""
		 if isnull(strSenha) then strSenha = ""
		 if isnull(strDatamatricula) then strDatamatricula = ""
		 if isnull(strDataingresso) then strDataingresso = ""
		 if isnull(strLogradouro_cobranca) then strLogradouro_cobranca = ""
		 if isnull(strNumero_endereco_cobranca) then strNumero_endereco_cobranca = ""
		 if isnull(strComp_endereco_cobranca) then strComp_endereco_cobranca = ""
		
	end if
	rs.close
	
	'-------------------------------------------------
	' VALIDA SE JÁ EXISTE O ALUNO CADASTRADA
	'-------------------------------------------------
	SQL = "select A.CODIGO, A.MATRICULA, AA.COD_EMPRESA, em.RAZAOSOCIAL AS ESCOLA "
	SQL = SQL & " from SCA_ALUNO A"
	SQL = SQL & " inner join SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO"
	SQL = SQL & " inner join SCA_ALUNO_ANO_LETIVO AA ON AA.COD_ALUNO = A.CODIGO"
	SQL = SQL & " LEFT JOIN SEG_EMPRESA EM ON EM.codigo = AA.COD_EMPRESA "
	SQL = SQL & " where A.NOMEALUNO = '"&strNomealuno&"'"
	SQL = SQL & " and A.MAE = '"&strMae&"'"
	SQL = SQL & " and A.DATANASCIMENTO = '"&strDatanascimento&"'"
	rs.open sql, cnn, 3, 3
	if rs.eof = false then
		strEncontrado = "S"
		msgCodigo = rs("CODIGO")
		msgMatricula = rs("MATRICULA")
		msgESCOLA = rs("ESCOLA")
		strEncontrado = "S"
	else		
		strEncontrado = "N"
	end if
	rs.close	

	
	if strEncontrado = "N" then
		
		SQL = " SELECT A.COD_ALUNO, A.MATRICULA, A.NOME, A.DATA_NASCIMENTO, A.MAE, A.COD_EMPRESA, SA.DESC_SITUACAOALUNO, em.RAZAOSOCIAL AS ESCOLA" 
		SQL = SQL & " FROM MAT_INSCRICAO A "
		SQL = SQL & " LEFT JOIN SCA_ALUNO AL ON AL.CODIGO = A.COD_ALUNO "
		SQL = SQL & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = AL.COD_SITUACAOALUNO "
		SQL = SQL & " inner join SCA_ALUNO_ANO_LETIVO AA ON AA.COD_ALUNO = A.CODIGO"
		SQL = SQL & " LEFT JOIN SEG_EMPRESA EM ON EM.codigo = AA.COD_EMPRESA "
		SQL = SQL & " where AA.Cod_Empresa "
		SQL = SQL & " in (select codigo from SEG_EMPRESA where COD_GRUPO=" & Session("CodGrupo") & ")" 
		SQL = SQL & " 		AND A.nome  = '"&strNomealuno&"'"
		SQL = SQL & " 		AND A.mae   = '"&strMae&"'"
		SQL = SQL & " 		AND A.data_nascimento    = '"&strDatanascimento&"'"
		
		'if ucase(session("usuarioWeb"))="SERGIO" then
		'	response.write sql
		'end if
		
		rs.open sql, cnn, 3, 3
		if rs.eof = false then
			msgCodigo = rs("COD_ALUNO")
			msgMatricula = rs("MATRICULA")
			msgESCOLA = rs("ESCOLA")
			strEncontrado = "S"
		else		
			strEncontrado = "N"
		end if
		rs.close			
	end if
	
	if strEncontrado = "S" then
		strEncontradoNaBase = "S"
		'verificar se já tem matricula para o ano da matricula
		SQL = "SELECT A.CODIGO, A.MATRICULA, A.NOMEALUNO, CC.COD_EMPRESA, A.DATAMATRICULA, SA.DESC_SITUACAOALUNO, A.DATAFASTAMENTO, CC.UNIDADE "
		SQL = SQL & " FROM SCA_ALUNO A "
		SQL = SQL & " OUTER APPLY ( "
		SQL = SQL & " SELECT TOP 1 C.COD_EMPRESA, C.COD_SITUACAOALUNO, E.RAZAOSOCIAL AS UNIDADE "
		SQL = SQL & " FROM SCA_CONTROLE_SITUACAO_ALUNO C "
		SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA "
		SQL = SQL & " WHERE C.COD_ALUNO = A.CODIGO "
		SQL = SQL & " AND C.ANO_LETIVO = " & strAnoLetivo 
		SQL = SQL & " ORDER BY C.CODIGO DESC "
		SQL = SQL & " ) CC "
		SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO "
		SQL = SQL & " where A.CODIGO=" & msgCodigo
		SQL = SQL & " and SA.DESC_SITUACAOALUNO = 'ATIVO'"
		rs.open sql, cnn, 3, 3
		if rs.eof = false then
			msgCodigo = rs("CODIGO")
			msgMatricula = rs("MATRICULA")
			msgESCOLA = rs("UNIDADE")
			strEncontradoNaBaseParaAnoLetivoAtivo = "S"
		else	
			'já existe na base mais não tem registro de ativo no ano da matricula
			strEncontradoNaBaseParaAnoLetivoAtivo = "N"
		end if
		rs.close
	
		if strEncontradoNaBaseParaAnoLetivo = "S" then
			cnn.rollbackTrans
			%>
			<script>
				alert("Aluno(a) já possui uma matrícula ATIVA cadastrada para o ano <%=strAnoLetivo%> sob o número <%=msgMatricula%>. Você deverá comparecer a Escola <%=msgESCOLA%>.");
				window.location='Inscricao.html';
			</script>
			<%
			response.End()
		else
			'já existe aproveitar os dados e insere em uma turma para proximo ano letivo
			strMatricula = msgMatricula
			intCodigo = msgCodigo
		end if
	end if
	
	
	if strEncontradoNaBaseParaAnoLetivoAtivo = "N" then
		'atualiza dados
		sql = "update SCA_ALUNO set COD_SITUACAOALUNO = 1"
		sql = sql & " ,CEPRESIDENCIA = '" & strCep & "'"
		sql = sql & " ,LOGRADOURO = '" & strLogradouro & "'"
		sql = sql & " ,NUMERO_ENDERECO = '" & strNumeroEndereco & "'"
		sql = sql & " ,COMP_ENDERECO = '" & strComplementoEndereco & "'"
		sql = sql & " ,BAIRROALUNO = '" & strBairro & "'"
		sql = sql & " ,Cidaderesidencia = '" & strCidade & "'"
		sql = sql & " ,UFRESIDENCIA = '" & strUFAlunoResidencia & "'"
		sql = sql & " ,EMAIL = '" & strEmail & "'"
		if strContato = "" then
			sql = sql & " ,FONERESIDENCIAL = '" & strContato & "'"
		end if
		if strCelular = "" then
			sql = sql & " ,FONECELULAR = '" & strCelular & "'"
		end if
		if strFonePai = "" then
			sql = sql & " ,PAIFONE = '" & strCep & "'"
		end if
		if strFoneMae = "" then
			sql = sql & " ,MAEFONE = '" & strCep & "'"
		end if
		if 	strbolsaFamilia = "" then
			sql = sql & " ,bolsa_Familia = null"
		else
			sql = sql & " ,bolsa_Familia = '" & strbolsaFamilia & "'"
		end if
		sql = sql & " where codigo = " & intCodigo
		cnn.Execute(sql)
		
		sql = "update SCA_ALUNO_TURMA set situacao = 'R'"
		sql = sql & " WHERE COD_ALUNO = " & intCodigo
		sql = sql & " and ano_letivo in (" & strAnoLetivo & "," & strAnoLetivo-1 & ")"
		cnn.execute sql
		
	else
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
		
		strSequenciaMatricula = right(strMatricula,4)
		strSequenciaMatricula = cInt(strSequenciaMatricula) + 1
		strMatricula = strAnoLetivoMatricula & strSemestreMatricula & ZeroLeft(strSequenciaMatricula,4)
		
		
		sql = "SET NoCount ON Insert Into SCA_ALUNO (MATRICULA, NOMEALUNO,MAE, DATAMATRICULA, "
		sql = sql & " COD_SITUACAOALUNO, SEXOALUNO, DATAFASTAMENTO, DATANASCIMENTO, NUMREGISTRONASC, "
		sql = sql & " CIDADENASCIMENTO, UFNASCIMENTO, LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
		sql = sql & " BAIRROALUNO, CIDADERESIDENCIA, UFRESIDENCIA, CEPRESIDENCIA, COD_ESTADOCIVIL, "
		sql = sql & " COD_PROFISSAO, COD_RELIGIAO, COD_NECESPECIAL, ATENDIMENTOESPECIAL, PAI, PAIFALECIDO, "
		sql = sql & " PAIFONE, PAIDATANASCIMENTO, PAI_COD_PROFISSAO, PAI_COD_GRAUINSTRUCAO, MAEFALECIDA, "
		sql = sql & " MAEFONE, MAEDATANASCIMENTO, MAE_COD_PROFISSAO, MAE_COD_GRAUINSTRUCAO, RESPONSAVEL, "
		sql = sql & " RESPONSAVELFONE, RESPONSAVELDATANASCIMENTO, RESPONSAVEL_COD_PROFISSAO, RESPONSAVEL_COD_GRAUINSTRUCAO, QTDE_IRMAO, "
		sql = sql & " QTDE_IRMAO_ESCOLA, FONERESIDENCIAL, FONECOMERCIAL, FONECELULAR, NACIONALIDADE, IDENTIDADE, IdentidadeOrgao, IdentidadeUF, "
		sql = sql & " TITULOELEITOR, TITULOZONA, TITULOSECAO, REGMILITAR, CPF, CPFALUNO, COD_FORMAINGRESSO, OBSAFASTAMENTO, COD_PLANOTURMA, "
		sql = sql & " COD_GRADEVESTIBULAR, MESANOVESTIBULAR, DATACOLACAO, ANOCONCLUSAO, SEMCONCLUSAO, "
		sql = sql & " DATACERTIFICADO, EMAIL, CTRVIACE, DATAINGRESSO, "
		sql = sql & " SETRANSP, COD_MOTIVOAFASTAMENTO, LOGRADOURO_COBRANCA, NUMERO_ENDERECO_COBRANCA, COMP_ENDERECO_COBRANCA, "
		sql = sql & " ESCOLA_ENSINOMEDIO, ESCOLA_ORIGEM, CIDADE_ENSINOMEDIO, ANO_ENSINOMEDIO, UF_ENSINOMEDIO,SENHA)"
		sql = sql & " Values ("
		
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
		if 	strMae 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMae & "',"
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
		sql = sql & "9,"
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
		if 	strComp_endereco  = "" then
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
		
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
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
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		if strCPF <> "" then
			sql = sql & "'" & strCPF & "',"
		else
			sql = sql & "NULL,"
		end if
		
		if strCPF <> "" then
			sql = sql & "'" & strCPF & "',"
		else
			sql = sql & "NULL,"
		end if
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		if strEmail = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEmail & "',"
		end if
		sql = sql & "NULL,"
		if 	strDataingresso 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDataingresso & "',"
		end if
		sql = sql & "NULL,"
		sql = sql & "NULL,"
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
		
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"
		sql = sql & "NULL,"

		if 	strSenha	 = "0" then
			sql = sql & "NULL)"
		else
			sql = sql & "'" & strSenha & "')"
		end if
		
		sql = sql & " ;SELECT @@IDENTITY "

		'if ucase(session("usuarioWeb"))="SERGIO" then
		'	response.write sql
		'end if
		
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		
		'DOCUMENTACAO DO ALUNO
		sql = "INSERT SCA_ALUNO_DOCUMENTACOES"
		sql = sql & " SELECT " & intCodigo & ", CODIGO, NULL, 'R'" 
		sql = sql & " FROM SCA_DOCUMENTACOES"
		cnn.execute sql
		
	end if
	
	sql = "update MAT_RESERVA set ATUALIZADO='S', cod_aluno = " & intCodigo & ",usuario_efetivacao='" & trim(session("usuarioWeb")) & "',data_efetivacao=getdate()"
	sql = sql & " WHERE codigo = " & strInscricao
	cnn.execute sql
	GravarLog sql

	

	'incluir aluno na turma
	if strCodTurma <> "0" then
	
	'-------------------
	
		'GRAVA NO CONTROLE SITUACAO ALUNO
		sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & strCod_empresa & "," 
		sql = sql & "" & intCodigo & "," 
		sql = sql & "" & SESSION("strAnoLetivo") & "," 
		sql = sql & "" & strSemestre & "," 
		sql = sql & "1," 
		sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
		cnn.execute sql
		GravarLog sql
					
		
		'gera linha ano letivo
		sql = "insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
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
		cnn.execute sql
		GravarLog sql
	
	'-------------------
	
	
	
		sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
		sql = sql & " FROM SCA_ALUNO_TURMA"
		sql = sql & " where COD_TURMA = " & strCodTurma
		rs.open sql, cnn,3,3
		
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

				rs.movenext
			wend
		end if
		rs.close		
		
	end if
	
	if err.number = 0 then

		'Gera Ocorrencia Automatica de troca de situação
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
		strOcorrencia		= "Inclusao por valida de Reserva." 
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%						

	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		
		strMensagem = "ATENÇÃO: \n\nValidação de Incrição realizada com sucesso.\nA Nova Matricula do Aluno é :" & strMatricula & "\nSua Nova Turma é : " & strNomeTurma
		strParametro = "ValidaReserva_con.asp"
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