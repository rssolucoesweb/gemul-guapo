<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: inclui inscricao para o cadastro do aluno
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
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

	'Consulta Situacao do Aluno
	sql = "SELECT Cod_SituacaoAluno, Desc_SituacaoAluno" 
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " where Desc_SituacaoAluno = 'PRÉ-MATRÍCULA'" 
	sql = sql & " AND COD_EMPRESA = " & strCod_empresa
	rs.open sql, cnn
	if not RS.EOF then
		strCod_situacaoaluno = rs("Cod_SituacaoAluno")
	end if
	rs.close
	
	' Pega os dados da Inscrição do Vestibular
	sql = "SELECT * FROM MAT_RESERVA"
	sql = sql & " WHERE codigo = " & strInscricao
	rs.open sql, cnn
	if rs.eof = false then
		 strNomealuno 					= trim(rs("Nome"))
		 strDatanascimento 				= FORMATADATABD(trim(rs("Data_Nascimento")))
		 strNacionalidade 				= "BRASILEIRA"
		 strFoneResidencial 			= trim(rs("Contato"))
		 strEmail 						= trim(rs("email"))
		 strLogradouro 					= trim(rs("LOGRADOURO"))
		 strNumero_endereco 			= trim(rs("NUMEROENDERECO"))
		 strComp_endereco 				= trim(rs("COMPLEMENTOENDERECO"))
		 strBairroaluno	 				= trim(rs("BAIRRO"))
		 strCidaderesidencia			= trim(rs("CIDADE"))
		 strUfresidencia				= rs("UF")
		 strCepresidencia	 			= replace(rs("CEP"),"-","")
		 strSenha 						= replace(formatadataAP(rs("Data_Nascimento")),"/","")
		 strDatamatricula               = FORMATADATABD(date)
		 strDataingresso                = FORMATADATABD(date)
	     strLogradouro_cobranca         = rs("LOGRADOURO")
		 strNumero_endereco_cobranca	= rs("NUMEROENDERECO")
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
	
	'Pega o novo codigo do Aluno 
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
		
	'regra para criação da matricula
	sql = "SELECT Max(Matricula) as MaiorMatricula" 
	sql = sql & " FROM SCA_ALUNO"
	sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
	rs.open sql, cnn,3 ,3
	if not RS.EOF then
	   strMatricula = rs("MaiorMatricula")
	   if trim(strAnoLetivo) & trim(strSemestre) <> left(strMatricula,5)  then
	      strMatricula = strAnoLetivo & strSemestre & "0000"
	   end if	  
	else
	   strMatricula = strAnoLetivo & strSemestre & "0000"
	end if 
    rs.close  
 
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

	sql = "update MAT_RESERVA set ATUALIZADO='S', cod_aluno = " & intCodigo
	sql = sql & " WHERE codigo = " & strInscricao
	cnn.execute sql
	GravarLog sql
	
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