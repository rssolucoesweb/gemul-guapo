<%
'******************IMPORTANTE*****************************
'DBCC CHECKIDENT('MAT_INSCRICAO_RESERVA_MATRICULA', RESEED, 0)
'DBCC CHECKIDENT('MAT_INSCRICAO_CONTROLE_MATRICULA', RESEED, 0)
'colocar o max da tabela sca_aluno o inicio da matrícula
'DECLARE @MAXTB INT
'SET @MAXTB = (SELECT MAX(CODIGO)+1 FROM SCA_ALUNO)
'DBCC CHECKIDENT('MAT_INSCRICAO_CONTROLE_MATRICULA', RESEED, @MAXTB)
'*********************************************************
response.Expires = 60
response.Expiresabsolute = Now() - 1
response.AddHeader "pragma","no-cache"
response.AddHeader "cache-control","private"
response.CacheControl = "no-cache"

response.Expires=0
Server.ScriptTimeOut = 5000
%>
<!--#include file="../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_formataCPF.asp"-->
<!--#include file="../includes/inc_replaceRequest.asp"-->
<%
function completaString(varInicial, caracter, tamanhoFinal, posicao)
	'varInicial   - variavel inicial
	'caracter 	  - indica o caracter a ser preenchido até que a varInicial fique do mesmo tamanho que tamanhoFinal
	'tamanhoCampo - indica o tamanho total que o campo deve ter
	'posicao 	  - preencher a esquerda (E) ou a direita (D) da variavel inicial
	dim strAux, strFinal, tamanhoInicial
	if isnull(varInicial) then varInicial = ""
	strAux = ""
	strFinal = ""
	tamanhoInicial = len(varInicial)
	if tamanhoInicial<tamanhoFinal then
		strAux = string( (cint(tamanhoFinal)-tamanhoInicial), caracter )
		if posicao = "E" then
			strFinal = strAux & varInicial
		else
			strFinal = varInicial & strAux
		end if
	else
		strFinal = varInicial
	end if
	completaString = strFinal
end function

Function RemoverEspacosDuplicados(texto)
    texto = Trim(texto)

    Do While InStr(texto, "  ") > 0
        texto = Replace(texto, "  ", " ")
    Loop

    RemoverEspacosDuplicados = texto
End Function

%>
<!--#include file="../includes/inc_cnn.asp"-->
<%
	acao 				= Trim(Request.QueryString("acao"))
	strUsuarioCallcenter		= Trim(Request.Form("txtUsuarioCallcenter"))
	
	if strUsuarioCallcenter = "" then strUsuarioCallcenter = "INTERNET"
	
	intAno						= strAnoLetivo
	strReserva					= request.Form("cadastro_reserva")
	strTipo						= Trim(Request.Form("optTipo"))
	
	strNomealuno				= ReplaceRequest(left(Request.Form("Aluno"),100))
	strNomealuno                = RemoverEspacosDuplicados(strNomealuno)
	strCPF						= formataCpfBD(ReplaceRequest(Request.Form("CPFAluno")))
	strDatanascimento			= right(Request.Form("DataNascimento"),4) & mid(Request.Form("DataNascimento"),3,4) & left(Request.Form("DataNascimento"),2)
'	strDatanascimento			= formataDataBD(Trim(Request.Form("DataNascimento")))
	strSexo						= Trim(Request.Form("sexo"))
	strMae						= ReplaceRequest(left(Request.Form("Mae"),100))
	strMae                      = RemoverEspacosDuplicados(strMae)
	strCep						= Trim(Request.Form("CEP"))
	strLogradouro				= ReplaceRequest(left(Request.Form("Endereco"),100))
	strNumeroEndereco			= Trim(LEFT(Request.Form("Numero"),5))
	strComplementoEndereco		= ReplaceRequest(LEFT(Request.Form("Complemento"),100))
	strBairro   				= ReplaceRequest(LEFT(Request.Form("Bairro"),100))
	strCidade   				= ReplaceRequest(LEFT(Request.Form("Municipio"),100))
	strUF		   				= ReplaceRequest(LEFT(Request.Form("UF"),2))
	strEmail   					= ReplaceRequest(LEFT(Request.Form("Email"),100))
	
	strContato   				= Trim(Request.Form("TelefoneContato"))
	strCelular   				= Trim(Request.Form("FoneResponsavel"))
	strFonePai   				= Trim(Request.Form("FonePai"))
	strFoneMae   				= Trim(Request.Form("FoneMae"))
	
	strPeriodo		   			= Trim(Request.Form("codigo_serie"))
	strTurno		   			= Trim(Request.Form("codigo_turno"))
	strRenda		   			= Trim(Request.Form("codigo_renda"))

	'strCurso   					= Trim(Request.Form("descricao_curso"))
	strCurso 					= "EDUCACAO_INFANTIL"
	
	intCod_empresa				= Trim(Request.Form("codigo_escola"))
	strbolsaFamilia 			= TRIM(request.Form("numero_bolsa_familia"))
	intCodEmpresaReserva		= 110 'Trim(Request("cmbEmpresaReserva"))

	if strCurso="EDUCACAO_INFANTIL" 	then strCurso = "EDUCAÇÃO INFANTIL"
	if strCurso="ENSINO_FUNDAMENTAL" 	then strCurso = "ENSINO FUNDAMENTAL"
	
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	'VERIFICA DATA
	SQL = "select CODIGO"
	SQL = SQL & " from MAT_periodo_valido_matricula "
	SQL = SQL & " WHERE '" & strDatanascimento & "' between DT_INICIAL AND DT_FINAL"
	SQL = SQL & " AND curso = 'EDUCAÇÃO INFANTIL'"
	RS.OPEN SQL, CNN
	IF RS.EOF THEN
		RS.CLOSE
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: A idade não é permitida para EDUCAÇÃO INFANTIL, a idade mínima é de 6 meses!.");
			window.location='Inscricao.html';
		</script>
		<%
		RESPONSE.End()
	ELSE
		RS.CLOSE
	END IF
	
	'PARA CADASTRO DE RESERVA
	if trim(strReserva) = "S" then
	
		SQL = "SELECT inscricao,chave "
		SQL = SQL & " FROM MAT_reserva"
		SQL = SQL & " WHERE nome = '" & strNomealuno & "' COLLATE SQL_Latin1_General_CP1_CI_AI "
		SQL = SQL & " AND data_nascimento = '" & strDatanascimento & "'"
		SQL = SQL & " AND mae = '" & strMae & "' COLLATE SQL_Latin1_General_CP1_CI_AI "
		SQL = SQL & " AND atualizado is null"
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strReserva = rs("inscricao")
			strChave = rs("chave")
			RS.CLOSE
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Já existe uma cadastro de reserva para este aluno com o número <%=strReserva%>.");
				window.location='comprovante_reserva.asp?cv=<%=strChave%>';
			</script>
			<%
			RESPONSE.End()
		END IF
		RS.CLOSE
		
		strSituacao = "R"
		
		SQL = "SET NoCount ON INSERT INTO MAT_RESERVA_CONTROLE_MATRICULA (DATA) VALUES(GETDATE()) ;SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		intCodigoProximaReserva = rs(0)
		rs.close

		'regra de preenchimento da inscricao ano + 6 digitos ex: 201700001
		strInscricao = strAnoLetivo & completaString (intCodigoProximaReserva,"0",5,"E") 

		sql = "select NEWID()"
		Set rs = cnn.Execute(sql)
		chave = rs(0)
		rs.close
		
		sql = "SET NoCount ON Insert Into MAT_reserva( Inscricao, chave, CodEmpresa, Ano, nome, cpf, data_nascimento, "
		sql = sql & " mae, sexo, cep, Logradouro, NumeroEndereco,  ComplementoEndereco, bairro, "
		sql = sql & " cidade, uf, email, Contato, Celular, FonePai, FoneMae, curso,"
		sql = sql & " periodo, turno, Situacao, bolsa_Familia, codigo_renda, codigo_regiao, usuario_incl, data_hora_incl)"
		sql = sql & " Values ("
		
		sql = sql & "'" & strInscricao & "',"
		sql = sql & "'" & chave & "',"
		sql = sql & "'" & intCodEmpresaReserva & "',"
		sql = sql & "'" & intAno & "',"
		sql = sql & "'" & strNomealuno & "',"
		sql = sql & "'" & strCPF & "',"
		sql = sql & "'" & strDatanascimento & "',"
		sql = sql & "'" & strMae & "',"
		sql = sql & "'" & strSexo & "',"
		sql = sql & "'" & strCep & "',"
		sql = sql & "'" & strLogradouro & "',"
		
		if 	strNumeroEndereco 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNumeroEndereco & "',"
		end if
		
		sql = sql & "'" & strComplementoEndereco & "',"
		sql = sql & "'" & strBairro & "',"
		sql = sql & "'" & strCidade & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & strEmail & "',"
		
		if 	strContato 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strContato & "',"
		end if
		
		if 	strCelular 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCelular & "',"
		end if
		
		if 	strFonePai 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFonePai & "',"
		end if
		
		if 	strFoneMae 	 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strFoneMae & "',"
		end if
		sql = sql & "'" & strCurso & "',"
		sql = sql & "'" & strPeriodo & "',"
		sql = sql & "'" & strTurno & "',"
		sql = sql & "'" & strSituacao & "',"
		if strbolsaFamilia="" then
			sql = sql & "'',"
		else
			sql = sql & "'" & strbolsaFamilia & "',"
		end if
		sql = sql & "'" & strRenda & "',"
		if intCodRegiao = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodRegiao & ","
		end if
		sql = sql & "'" & strUsuarioCallcenter & "',GETDATE()); SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		intCodigoReserva = rs(0)
		rs.close
		
		deficiencias = request.form("chkDeficiencia")
		if trim(deficiencias) <> "" then
			sql = "insert into mat_reserva_deficiencia"
			sql = sql & " select " & intCodigoReserva& ",Cod_NecEspecial,'" & strUsuarioCallcenter & "',GETDATE()"
			sql = sql & " from sca_necessidadeespecial"
			sql = sql & " where Cod_NecEspecial in (" & deficiencias & ")"
			cnn.Execute(sql)
		end if
		
		if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
			cnn.commitTrans
			strMensagem = "Cadastro de reserva processado com sucesso!"
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='comprovante_reserva.asp?cv=<%=chave%>';
			</script>
			<%
			response.end
		else
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar finalizar o processamento, tente novamente!");
				window.history.back();
			</script>
			<%
			response.end
		end if	
		
	else
		'--------------------------
		'inscricao normal
		'--------------------------
		
		intCodPeriodo	= ""
		intCodTurno		= ""
		intCodCurso		= ""
	
		'busca codigo do curso na empresa
		sql = "select cod_curso"
		sql = sql & " from SCA_CURSO"
		sql = sql & " where Situacao = 'A' and left(Descricao,18) = '" & strCurso & "'"
'response.write sql & "<hr>"		
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso = RS("cod_curso")
		END IF
		RS.CLOSE	
		
		if trim(left(strPeriodo,1))<>"A" then
			if cInt(left(strPeriodo,1)) >= 6 and cInt(left(strPeriodo,1)) <= 9 then
				sql = "select cod_curso"
				sql = sql & " from SCA_CURSO"
				sql = sql & " where descricao = 'ENSINO FUNDAMENTAL 2ª FASE'"
'response.write sql & "<hr>"		
				RS.OPEN SQL, CNN
				IF not RS.EOF THEN
					intCodCurso = RS("cod_curso")
				END IF
				RS.CLOSE	
			end if
		end if
		
		'busca codigo do periodo na empresa
		sql = "select cod_periodo"
		sql = sql & " from SCA_PERIODO"
		sql = sql & " where Cod_Curso = " & intCodCurso
		sql = sql & " and Descricao = '" & strPeriodo & "'"
'response.write sql & "<hr>"		
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodPeriodo = RS("cod_periodo")
		END IF
		RS.CLOSE		
		
		'busca codigo do turno na empresa
		sql = "select cod_turno"
		sql = sql & " from SCA_TURNO"
		sql = sql & " where Desc_Turno = '" & strTurno & "'"
'response.write sql & "<hr>"		
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodTurno = RS("cod_turno")
		END IF
		RS.CLOSE	
			
		intQtdeVagas			= 1
		strCodTurma				= 0
		strSituacao 			= "S" ' S - Solicitação
		
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
		'SQL = SQL & " and SA.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"	
'response.write sql & "<hr>"		
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
			SQL = SQL & " in (select codigo from SEG_EMPRESA where COD_GRUPO="&intCodGrupo&")" 
			SQL = SQL & " 		AND A.nome  = '"&strNomealuno&"'"
			SQL = SQL & " 		AND A.mae   = '"&strMae&"'"
			SQL = SQL & " 		AND A.data_nascimento    = '"&strDatanascimento&"'"
			'SQL = SQL & " 		AND SA.Desc_SituacaoAluno IN ('ATIVO', 'PRÉ-MATRÍCULA')"
'response.write sql & "<hr>"		
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

		strMensagem = "Registro processado com sucesso..."
		
		intCodSituacaoAluno = 2 'pre matricula
		
		if strEncontradoNaBaseParaAnoLetivoAtivo <> "N" then
			'--------------------------------------------------------------------------------------------------------------------
			' Cadastro o Aluno no Cadastro de Aluno
			'SQL = "SET NoCount ON INSERT INTO MAT_INSCRICAO_CONTROLE_MATRICULA (DATA) VALUES(GETDATE()) ;SELECT @@IDENTITY "
			'response.write sql & "<hr>"		
			'Set rs = cnn.Execute(sql)
			'intCodigo = rs(0)
			'rs.close

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
		end if
		
		
	
		''---------------------------------------------------''
		'' INICIO - BUSCA TURMA DISPONIVEL PARA A ESCOLA SELECIONADA
		''---------------------------------------------------''
		strCodTurma = "0"
		sql = "select tu.cod_turma, isnull(TU.Capacidade,0) - isnull(TU.VagasReservadas,0) -  isnull(TU.VagasMatriculasUtilizadas,0) as vagas"
		sql = sql & " from SCA_TURMA TU"
		sql = sql & " left join SCA_GRADECURRICULAR GD on GD.Cod_GradeCurricular = TU.Cod_GradeCurricular "
		sql = sql & " where TU.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO="&intCodGrupo&")"
		sql = sql & " and TU.Situacao = 'A'"
		sql = sql & " and tu.AnoLetivo = " & session("strAnoLetivo")
		sql = sql & " and GD.Cod_Periodo = " & intCodPeriodo
		sql = sql & " and TU.Cod_Turno = " & intCodTurno
		sql = sql & " and tu.Cod_Empresa = " & intCod_empresa
		SQL = SQL & " and isnull(TU.Capacidade,0) - isnull(TU.VagasReservadas,0) -  isnull(TU.VagasMatriculasUtilizadas,0) > 0"	
		sql = sql & " order by 2"
'response.write sql & "<hr>"		
		
		rs.open sql, cnn,3,3
		if not RS.EOF then
			if not isnull(rs("cod_turma")) then
				strCodTurma = rs("cod_turma")
			end if
		end if
		rs.close
		''---------------------------------------------------''
		'' FIM - BUSCA TURMA DISPONIVEL PARA A ESCOLA SELECIONADA
		''---------------------------------------------------''
		
		'incluir aluno na turma
		if strCodTurma = "0" then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Não foi encontrada nenhuma turma disponível nesta escola, favor tentar novamente!");
				window.location='Inscricao.html';
			</script>
			<%
			response.end
		else
			if strEncontradoNaBaseParaAnoLetivoAtivo = "N" then
				'atualiza dados
				sql = "update SCA_ALUNO set COD_SITUACAOALUNO = " & intCodSituacaoAluno
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
			else
				sql = "SET NoCount ON Insert Into SCA_ALUNO (MATRICULA, NOMEALUNO, CPF, COD_SITUACAOALUNO, DATANASCIMENTO, "
				sql = sql & " MAE, CEPRESIDENCIA, LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, BAIRROALUNO, Cidaderesidencia, UFRESIDENCIA, "
				sql = sql & " EMAIL, FONERESIDENCIAL, FONECELULAR, PAIFONE, MAEFONE, sexoaluno, bolsa_Familia )"
				sql = sql & " Values ("
				sql = sql & "'" & strMatricula & "',"
				sql = sql & "'" & strNomealuno & "',"
				sql = sql & "'" & strCPF & "',"
				sql = sql & "" & intCodSituacaoAluno & ","
				sql = sql & "'" & strDatanascimento & "',"
				sql = sql & "'" & strMae & "',"
				sql = sql & "'" & strCep & "',"
				sql = sql & "'" & strLogradouro & "',"
				if strNumeroEndereco = "" then
					sql = sql & "NULL,"
				else
					sql = sql & "'" & strNumeroEndereco & "',"
				end if
				sql = sql & "'" & strComplementoEndereco & "',"
				sql = sql & "'" & strBairro & "',"
				sql = sql & "'" & strCidade & "',"
				sql = sql & "'" & strUF & "',"				
				sql = sql & "'" & strEmail & "',"	
				
				if strContato = "" then
					sql = sql & "NULL,"
				else
					sql = sql & "'" & strContato & "',"
				end if
				
				if strCelular = "" then
					sql = sql & "NULL,"
				else
					sql = sql & "'" & strCelular & "',"
				end if
				
				if strFonePai = "" then
					sql = sql & " NULL,"
				else
					sql = sql & "'" & strFonePai & "',"
				end if
				
				if strFoneMae = "" then
					sql = sql & " NULL,"
				else
					sql = sql & "'" & strFoneMae & "',"
				end if
				sql = sql & "'" & strSexo & "',"
				if 	strbolsaFamilia = "" then
					sql = sql & "'')"
				else
					sql = sql & "'" & strbolsaFamilia & "') "
				end if
				sql = sql & " ;SELECT @@IDENTITY "
	'response.write sql & "<hr>"		
				Set rs = cnn.Execute(sql)
				intCodigo = rs(0)
				rs.close
			end if
			
			deficiencias = request.form("chkDeficiencia")
			if trim(deficiencias) <> "" then
				sql = "delete SCA_ALUNO_NECESSIDADEESPECIAL"
				sql = sql & " where COD_NECESSIDADEESPECIAL in (" & deficiencias & ")"
				sql = sql & " and cod_aluno = " & intCodigo
				cnn.Execute(sql)
				
				sql = "insert into SCA_ALUNO_NECESSIDADEESPECIAL"
				sql = sql & " select " & intCodigo & ",Cod_NecEspecial,'" & strUsuarioCallcenter & "',GETDATE()"
				sql = sql & " from sca_necessidadeespecial"
				sql = sql & " where Cod_NecEspecial in (" & deficiencias & ")"
				cnn.Execute(sql)
			end if

			sql = "select NEWID()"
			Set rs = cnn.Execute(sql)
			chave = rs(0)
			rs.close
			
			if strCod_situacaoaluno = "" then strCod_situacaoaluno = "2"
		
			'GRAVA NO CONTROLE SITUACAO ALUNO
			sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & intCod_empresa & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & SESSION("strAnoLetivo") & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & strCod_situacaoaluno & "," 
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
			cnn.execute sql
						
			'gera linha ano letivo
			sql = "SET NoCount ON insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,COD_SITUACAOALUNO,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
			sql = sql & "" & intCod_empresa & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & SESSION("strAnoLetivo") & ","
			sql = sql & "" & strSemestre & ","
			sql = sql & "" & strCod_situacaoaluno & "," 
			sql = sql & "'A',getdate(),"
			if 	strLogradouro 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strLogradouro & "',"
			end if
			if 	strNumeroEndereco 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strNumeroEndereco & "',"
			end if
			if 	strComplementoEndereco 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strComplementoEndereco & "',"
			end if
			if 	strBairro 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strBairro & "',"
			end if
			if 	strCidade 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strCidade & "',"
			end if
			if 	strUF 	 = "0" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strUF & "',"
			end if
			if 	strCep 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strCep & "',"
			end if
			
			sql = sql & "'" & trim(session("usuarioWeb")) & "',getdate())"
			sql = sql & ";SELECT @@IDENTITY "
			'response.write sql & "<hr>"
			Set rs = cnn.Execute(sql)
			intCodigoAnoLetivo = rs(0)
			rs.close

			intCodEmp			= 0
			intCodDepartamento	= 0
			intCodAluno			= intCodigo
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Incluído pela matrícula online"
			%>
			<!--#include file="../../app/includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%
			
			sql = "SET NoCount ON Insert Into MAT_inscricao( chave, matricula, cod_aluno, nome, cpf, data_nascimento, mae, cep, Logradouro, NumeroEndereco,  ComplementoEndereco, bairro, "
			sql = sql & " cidade, uf, email, Contato, Celular, FonePai, FoneMae, bolsa_Familia, "
			sql = sql & " Cod_periodo, Cod_turno, Cod_empresa, Cod_turma, Situacao, codigo_renda, usuario_incl, data_hora_incl)"
			sql = sql & " Values ("
			sql = sql & "'" & chave & "',"
			if 	strMatricula 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "" & strMatricula & ","
			end if
			sql = sql & "" & intCodigo & ","
			sql = sql & "'" & strNomealuno & "',"
			sql = sql & "'" & strCPF & "',"
			sql = sql & "'" & strDatanascimento & "',"
			sql = sql & "'" & strMae & "',"
			sql = sql & "'" & strCep & "',"
			sql = sql & "'" & strLogradouro & "',"
			
			if 	strNumeroEndereco 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strNumeroEndereco & "',"
			end if
			
			sql = sql & "'" & strComplementoEndereco & "',"
			sql = sql & "'" & strBairro & "',"
			sql = sql & "'" & strCidade & "',"
			sql = sql & "'" & strUF & "',"
			sql = sql & "'" & strEmail & "',"
			
			if 	strContato 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strContato & "',"
			end if
			
			if 	strCelular 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strCelular & "',"
			end if
			
			if 	strFonePai 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strFonePai & "',"
			end if
			
			if 	strFoneMae 	 = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strFoneMae & "',"
			end if
			
			if 	strbolsaFamilia = "" then
				sql = sql & "NULL,"
			else
				sql = sql & "'" & strbolsaFamilia & "',"
			end if
			
			sql = sql & "" & intCodPeriodo & ","
			sql = sql & "" & intCodTurno & ","
			sql = sql & "" & intCod_empresa & ","
			sql = sql & "" & strCodTurma & ","
			sql = sql & "'" & strSituacao & "',"
			sql = sql & "'" & strRenda & "',"
			sql = sql & "'" & strUsuarioCallcenter & "',GETDATE()); SELECT @@IDENTITY "
			Set rs = cnn.Execute(sql)
			intCodInscricao = rs(0)
			rs.close

			deficiencias = request.form("chkDeficiencia")
			if trim(deficiencias) <> "" then
				sql = "insert into mat_inscricao_deficiencia"
				sql = sql & " select " & intCodInscricao & ",Cod_NecEspecial,'" & strUsuarioCallcenter & "',GETDATE()"
				sql = sql & " from sca_necessidadeespecial"
				sql = sql & " where Cod_NecEspecial in (" & deficiencias & ")"
				cnn.Execute(sql)
			end if
			
			sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " where COD_TURMA = " & strCodTurma
			sql = sql & " and COD_EMPRESA = " & intCod_empresa
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
			sql = sql & " where COD_ALUNO = " & intCodigo
			sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
'response.write sql & "<hr>"		
			cnn.execute sql			

			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1"
			sql = sql & " where COD_EMPRESA = " & intCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurma
'response.write sql & "<hr>"		
			cnn.execute sql			

			strSituacaoNaTurma = "A" 'ativo na turma
			
			sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & intCod_empresa & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intSequencia & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
'response.write sql & "<hr>"		
			cnn.execute sql
		end if
		
		if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
			cnn.commitTrans
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='comprovante.asp?cv=<%=chave%>';
			</script>
			<%
			response.end
		else
			cnn.rollbackTrans
			%>
			<script>
				alert("Por favor tente novamente!\nClicando no OK.\nEm seguida clique em atualizar página ou F5.");
			</script>
			<%
			response.write "<br><br><div align='center'><strong>Clique em atualizar página ou F5.</strong></div>"
		end if	

	end if
%>