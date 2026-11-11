<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	if Session("MatriculaInformatizadaAnoEfetivacao") = "" then 
		Session("MatriculaInformatizadaAnoEfetivacao") = year(date)+1
	end if
	
	strAnoLetivo 			= Trim(Request.form("txtAnoLetivo"))
	strSemestre				= 3 
	strAlunoEncontrado		= ""
	pagina					= "EfetivacaoAluno_con.asp"
	Session("MatriculaInformatizada") 	=  "SIM"
	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
	strDatanascimento 	= formataDataBD(Trim(Request.Form("txtDatanascimento")))
	strDataMatricula 	= formataDataBD(date)
	strMae 				= Trim(Request.Form("txtMae"))
	strCPFAluno			= Trim(Request.Form("txtCPFAluno"))
	msn 				= ""
	strCodInscricao		= Trim(Request.form("txtCodigoInscricao"))
	strCodTurma			= Trim(Request.form("txtCodigoTurma"))
	strCodEmpresa		= Trim(Request.form("txtCodigoEmpresa"))
	
	acao = request("acao")
	if acao = "I"	 then
		
		cnn.begintrans
		
		IF intCodAluno = "" THEN intCodAluno = "0"

		SQL = "SELECT "
		SQL = SQL & "      A.CODIGO,"
		SQL = SQL & "      A.MATRICULA,"
		SQL = SQL & "      A.NOMEALUNO,"
		SQL = SQL & "      CC.COD_EMPRESA,"
		SQL = SQL & "      A.DATAMATRICULA,"
		SQL = SQL & "      SA.DESC_SITUACAOALUNO,"
		SQL = SQL & "      A.DATAFASTAMENTO,"
		SQL = SQL & "      CC.UNIDADE"
		SQL = SQL & "  FROM SCA_ALUNO A"
		SQL = SQL & "  OUTER APPLY ("
		SQL = SQL & "      SELECT TOP 1"
		SQL = SQL & "          C.COD_EMPRESA,"
		SQL = SQL & "          C.COD_SITUACAOALUNO,"
		SQL = SQL & "          E.RAZAOSOCIAL AS UNIDADE"
		SQL = SQL & "      FROM SCA_CONTROLE_SITUACAO_ALUNO C"
		SQL = SQL & "      INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
		SQL = SQL & "      WHERE "
		SQL = SQL & "          C.COD_ALUNO = A.CODIGO"
		SQL = SQL & "          AND C.ANO_LETIVO = " & strAnoLetivo
		SQL = SQL & "      ORDER BY C.CODIGO DESC"
		SQL = SQL & "  ) CC"
		SQL = SQL & "  INNER JOIN SCA_SITUACAOALUNO SA "
		SQL = SQL & "      ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
		SQL = SQL & "  WHERE A.NOMEALUNO = '"&strNomealuno&"'  COLLATE SQL_Latin1_General_CP1_CI_AI "
		SQL = SQL & " and A.MAE = '"&strMae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
		SQL = SQL & " and A.DATANASCIMENTO = '"&strDatanascimento&"'"
		SQL = SQL & " and SA.Desc_SituacaoAluno = 'ATIVO'"
		rs.open sql, cnn, 3, 3
		if rs.eof = false then
			if trim(rs("cod_empresa")) <> trim(strCodEmpresa) then
				msn = "EFETIVAÇÃO NEGADA!\n\nAluno(a) já esta matriculado(a) no " & rs("UNIDADE") & " com a matrícula " & rs("matricula") & "."
			end if
		end if
		rs.close	
	
		
		if trim(msn) = "" then
			existeNaBaseComOsMesmoDados = ""
			'verifica se já exite com a mesma trinca se existe deve aproveitar a matricula
			SQL = "SELECT CODIGO, replace(replace(cpf,'.',''),'-','') AS CPF FROM SCA_ALUNO"
			SQL = SQL & "  WHERE NOMEALUNO = '"&strNomealuno&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
			SQL = SQL & " and MAE = '"&strMae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
			SQL = SQL & " and DATANASCIMENTO = '"&strDatanascimento&"'"
			SQL = SQL & " ORDER BY 1"
			rs.open sql, cnn
			if not RS.EOF then
			
				IF TRIM(RS("CPF")) = TRIM(replace(replace(strCPFAluno,".",""),"-","")) THEN
					existeNaBaseComOsMesmoDados = "S"
					intCodAlunoAnterior		= intCodAluno
					intCodAluno				= RS("CODIGO")
					
					if trim(intCodAlunoAnterior) = trim(intCodAluno) then
						existeNaBaseComOsMesmoDados = ""
					end if
				ELSE
					existeNaBaseComOsMesmoDados = "N"
				END IF
			end if
			rs.close
	
			'verifica se já exite com a mesma trinca se existe deve aproveitar a matricula
			if existeNaBaseComOsMesmoDados = "N" then
				SQL = "SELECT top 1 e.razaosocial "
				SQL = SQL & "  FROM SCA_CONTROLE_SITUACAO_ALUNO c"
				SQL = SQL & "  inner join SEG_EMPRESA e on e.codigo = c.cod_empresa"
				SQL = SQL & "  WHERE c.COD_ALUNO = " & intCodAluno
				SQL = SQL & "  order by c.codigo desc"
				rs.open sql, cnn
				if not RS.EOF then
					unidade				= RS("razaosocial")
				end if
				rs.close
				cnn.rollbacktrans
				%>
				<script>
					alert("Existe um aluno cadastrado com o mesmo CPF, porém com divergência no nome do aluno, na data de nascimento e no nome da mãe, na unidade <%=unidade%>, favor verificar!");
					window.history.back();
				</script>
				<%
				response.End()
			end if
			
			if existeNaBaseComOsMesmoDados = "S" then
				
				strOcorrencia		= "Efetivação da matrícula com aproveitamente de dados - cod_aluno matricula: " & intCodAlunoAnterior & " | cod_aluno cadastro aproveitado: " & intCodAluno
				
				intCodEmp			= strCodEmpresa
				intCodDepartamento	= Session("CodDeptoUsuario")
				intCodAluno			= intCodAluno
				intCodTaxa			= ""
				intCodBebitoAluno	= ""
				strDataOcorrencia	= formatadataBD(date)
				strUsuarioIncl		= trim(session("usuarioWeb"))
				strDataValidade		= ""
				strOcorrencia		= "Efetivação da matrícula com troca alteração do nome do aluno e aproveitamento de matrícula"
				%>
				<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
				<%
				strUsuarioIncl		= trim(session("usuarioWeb"))
				%>
				<!--#include file="../includes/inc_lancamentoDeOcorrenciaMatricula.asp"-->	
				<%
				intSequencia = "1"
				SQL = "SELECT max(SEQUENCIA)+1 as SEQUENCIA "
				SQL = SQL & "  FROM SCA_ALUNO_TURMA where COD_TURMA = " & strCodTurma
				rs.open sql, cnn
				if not RS.EOF then
					intSequencia				= RS("SEQUENCIA")
				end if
				rs.close
				
				sql = "delete "
				sql = sql & " FROM 	SCA_ALUNO_TURMA_situacao"
				sql = sql & " where COD_ALUNO_TURMA in ("
				sql = sql & " select codigo " 
				sql = sql & " FROM 	SCA_ALUNO_TURMA "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " and COD_TURMA = " & strCodTurma
				sql = sql & " and ano_letivo = " & strAnoLetivo
				sql = sql & " )"
				cnn.execute sql
				
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_ALUNO_TURMA "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " and COD_TURMA = " & strCodTurma
				sql = sql & " and ano_letivo = " & strAnoLetivo
				cnn.execute sql
				
				strSituacaoNaTurma = "A" 'ativo na turma
				sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCodEmpresa & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strCodTurma & "," 
				sql = sql & "" & intSequencia & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "'A'," ' A - ATIVA | R - REMANEJADA
				sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
				
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_CONTROLE_SITUACAO_ALUNO "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " and COD_EMPRESA = " & strCodEmpresa
				sql = sql & " and ANO_LETIVO = " & strAnoLetivo
				cnn.execute sql
				
				
				'GRAVA NO CONTROLE SITUACAO ALUNO
				sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCodEmpresa & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "1," 
				sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
				cnn.execute sql
				
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_ALUNO_ANO_LETIVO "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " and COD_EMPRESA = " & strCodEmpresa
				sql = sql & " and ANO_LETIVO = " & strAnoLetivo
				cnn.execute sql
				
				
				sql = "SELECT Logradouro, Numero_endereco, Comp_endereco, Bairroaluno, Cidaderesidencia, Ufresidencia, Cepresidencia"
				sql = sql & " FROM SCA_ALUNO A"
				sql = sql & " Where codigo = " & intCodAluno
				rs.open sql, cnn
				if rs.eof = false then
					'endereço
					strLogradouro 					= TRIM(rs("Logradouro"))
					strNumero_endereco 				= TRIM(rs("Numero_endereco"))
					strComp_endereco 				= TRIM(rs("Comp_endereco"))
					strBairroaluno 					= TRIM(rs("Bairroaluno"))
					strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
					strUfresidencia 				= TRIM(rs("Ufresidencia"))
					strCepresidencia 				= TRIM(rs("Cepresidencia"))
				end if
				rs.close
				
				'gera linha ano letivo
				sql = "insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,COD_SITUACAOALUNO,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
				sql = sql & "" & strCodEmpresa & ","
				sql = sql & "" & intCodAluno & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & "2,'A',getdate(),"
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
				cnn.Execute(sql)
				
			else
				sql = "update SCA_ALUNO set"
				'gravar default para facilitar o preenchimento da tela
				sql = sql & " UFNASCIMENTO = 9,"
				sql = sql & " UFRESIDENCIA = 9,"
				sql = sql & " COD_ESTADOCIVIL = 1,"
				sql = sql & " COD_PROFISSAO = 157,"
				sql = sql & " COD_RELIGIAO = 5,"
				sql = sql & " COD_ETNIA = 6,"	
				sql = sql & " DATAMATRICULA = '" & strDataMatricula & "',"
				sql = sql & " cpf = '" & strCPFAluno & "',"
				'-----------------------------------------------------------			
				sql = sql & " nomeAluno = '" & ucase(strNomealuno) & "',"
				sql = sql & " dataNascimento = '" & strDatanascimento & "',"
				sql = sql & " mae = '" & ucase(strMae) & "'"
				sql = sql & " where codigo = "& intCodAluno
				cnn.execute sql
				
				sql = "SELECT NOME, MAE, DATA_NASCIMENTO, CODIGO" 
				sql = sql & " FROM MAT_INSCRICAO"
				sql = sql & " where COD_ALUNO = " & intCodAluno
				rs.open sql, cnn
				if not RS.EOF then
					strNomealunoMatricula 		= RS("NOME")
					strDatanascimentoMatricula 	= FORMATADATABD(RS("DATA_NASCIMENTO"))
					strMaeMatricula 			= RS("MAE")
					strCodInscricao				= RS("CODIGO")
				end if
				rs.close	
				strOcorrencia		= "Efetivação da matrícula"
				strUsuarioIncl		= trim(session("usuarioWeb"))
				%>
				<!--#include file="../includes/inc_lancamentoDeOcorrenciaMatricula.asp"-->	
				<%
				
				intSequencia = "1"
				SQL = "SELECT max(SEQUENCIA)+1 as SEQUENCIA "
				SQL = SQL & "  FROM SCA_ALUNO_TURMA where COD_TURMA = " & strCodTurma
				rs.open sql, cnn
				if not RS.EOF then
					intSequencia				= RS("SEQUENCIA")
				end if
				rs.close				
				
				strSituacaoNaTurma = "A" 'ativo na turma
				
				sql = "INSERT INTO SCA_ALUNO_TURMA "
				sql = sql & "(COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) "
				sql = sql & "SELECT "
				sql = sql & strCodEmpresa & ","
				sql = sql & intCodAluno & ","
				sql = sql & strCodTurma & ","
				sql = sql & intSequencia & ","
				sql = sql & strAnoLetivo & ","
				sql = sql & strSemestre & ","
				sql = sql & "'" & strSituacaoNaTurma & "',"
				sql = sql & "'" & formataDataBD(date) & " " & time & "' "
				sql = sql & "WHERE NOT EXISTS ("
				sql = sql & "    SELECT 1 FROM SCA_ALUNO_TURMA "
				sql = sql & "    WHERE COD_ALUNO = " & intCodAluno
				sql = sql & "    AND COD_TURMA = " & strCodTurma
				sql = sql & "    AND ANO_LETIVO = " & strAnoLetivo
				sql = sql & "    AND SEMESTRE = " & strSemestre
				sql = sql & "    AND SITUACAO = '" & strSituacaoNaTurma & "'"
				sql = sql & ")"

				cnn.Execute sql

				'--------------------------------------------------------------------------------------------
				'DOCUMENTACAO DO ALUNO
				sql = "INSERT SCA_ALUNO_DOCUMENTACOES"
				sql = sql & " SELECT " & intCodAluno & ", CODIGO, NULL, 'R'" 
				sql = sql & " FROM SCA_DOCUMENTACOES"
				cnn.execute sql		
				
				sql = "INSERT INTO SCA_CONTROLE_SITUACAO_ALUNO "
				sql = sql & "(COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL) "
				sql = sql & "SELECT "
				sql = sql & intCodAluno & ","
				sql = sql & strCodEmpresa & ","
				sql = sql & strAnoLetivo & ","
				sql = sql & strSemestre & ","
				sql = sql & "2,"
				sql = sql & "GETDATE(),"
				sql = sql & "'" & strUsuarioIncl & "' "
				sql = sql & "WHERE NOT EXISTS ("
				sql = sql & "    SELECT 1 "
				sql = sql & "    FROM SCA_CONTROLE_SITUACAO_ALUNO "
				sql = sql & "    WHERE COD_ALUNO = " & intCodAluno
				sql = sql & "    AND COD_EMPRESA = " & strCodEmpresa
				sql = sql & "    AND ANO_LETIVO = " & strAnoLetivo
				sql = sql & "    AND SEMESTRE = " & strSemestre
				sql = sql & "    AND COD_SITUACAOALUNO = 2"
				sql = sql & ")"

				cnn.Execute sql
			end if
			

			'busca situacao do aluno
			strCod_situacaoaluno = "2" 'PRE-MATRICULA
		
			'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCodEmpresa & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & strCod_situacaoaluno & ","
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
'response.write sql & "<hr>"		
			cnn.execute sql
			
			if existeNaBaseComOsMesmoDados = "S" then
				' tira o aluno da turma e das disciplinas
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_FALTAS_DIARIA "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				sql = sql & " and ano_letivo = " & strAnoLetivo
				cnn.execute sql
		
				' limpa a tabela de notas
				sql = "DELETE "
				sql = sql & " from 	SCA_NOTAS_FALTAS "
				sql = sql & " where	COD_ALUNO = " & intCodAluno
				cnn.execute sql
		
				' limpa a tabela de notas PLANILHA
				sql = "DELETE "
				sql = sql & " from SCA_NOTAS_PLANILHA "
				sql = sql & " where	COD_ALUNO = " & intCodAluno
				cnn.execute sql
				
				'limpa dados
				sql = "exec [SP_ExcluiAluno] " & intCodAlunoAnterior
				cnn.execute sql
				
				
				sql = "update mat_inscricao set cod_aluno = " & intCodAluno
				sql = sql & " WHERE COD_ALUNO = " & intCodAlunoAnterior
				cnn.execute sql
				
				sql = "update SCA_ALUNO set"
				sql = sql & " DATAMATRICULA = '" & strDataMatricula & "',"
				sql = sql & " cpf = '" & strCPFAluno & "',"
				'-----------------------------------------------------------			
				sql = sql & " nomeAluno = '" & ucase(strNomealuno) & "',"
				sql = sql & " dataNascimento = '" & strDatanascimento & "',"
				sql = sql & " mae = '" & ucase(strMae) & "'"
				sql = sql & " where codigo = "& intCodAluno
				cnn.execute sql
			else
			
				' tira o aluno da turma e das disciplinas
				sql = "DELETE " 
				sql = sql & " FROM 	SCA_FALTAS_DIARIA "
				sql = sql & " WHERE COD_ALUNO = " & intCodAluno
				cnn.execute sql
		
				' limpa a tabela de notas
				sql = "DELETE "
				sql = sql & " from 	SCA_NOTAS_FALTAS "
				sql = sql & " where	COD_ALUNO = " & intCodAluno
				cnn.execute sql
		
				' limpa a tabela de notas PLANILHA
				sql = "DELETE "
				sql = sql & " from SCA_NOTAS_PLANILHA "
				sql = sql & " where	COD_ALUNO = " & intCodAluno
				cnn.execute sql

			end if

		'	response.write "<br>existeNaBaseComOsMesmoDados:" & existeNaBaseComOsMesmoDados

			' tira o aluno da turma e das disciplinas
			sql = "DELETE "
			sql = sql & " from SCA_ALUNO_DISCIPLINA "
			sql = sql & " where	COD_ALUNO = " & intCodAluno
			'response.write "<br>:" & sql
			cnn.execute sql
			
			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & strCodEmpresa
			sql = sql & " AND	G.SITUACAO = 'A'"'GRADE ATIVA
			'response.write sql
			rs.open sql, cnn,3,3
			if not RS.EOF then
				while not rs.eof
				
					sql = "SELECT HD.SITUACAO"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
					sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
					sql = sql & " WHERE	H.COD_ALUNO = " & intCodAluno
					sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
					sql = sql & " AND	H.COD_EMPRESA = " & strCodEmpresa
'response.write sql & "<hr>"		
					Rs1.open sql, cnn,3,3
					if Rs1.EOF then				
				
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA,  COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & strCodEmpresa & "," 
						sql = sql & "" & intCodAluno & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
'response.write sql & "<hr>"		
						'cnn.execute sql		
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCodEmpresa & "," 
							sql = sql & "" & intCodAluno & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
'response.write sql & "<hr>"		
							cnn.execute sql		
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
		
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCodEmpresa & "," 
								sql = sql & "" & intCodAluno & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
'response.write sql & "<hr>"		
								cnn.execute sql		
							
							END IF
						END IF

					end if
					Rs1.Close	

					rs.movenext
				wend
			end if
			rs.close	
			
		'	response.end
			
			' Atualiza a Mat Inscricao
			sql = " UPDATE MAT_inscricao SET " 
			sql = sql & " Efetivacao = 'S'"
			sql = sql & " Where Cod_Empresa = " & strCodEmpresa
			sql = sql & " and cod_aluno = " &  intCodAluno
			cnn.execute sql			
			
			cnn.committrans		
			%>
			<script>
				alert("Aluno efetivado com sucesso! \n\nVocê será direcionado para a ficha para concluir a efetivação. Não saia da ficha sem preencher todas as informações e finalize clicando em 'Alterar'.");
				window.location="/app/sca_aluno.asp?txtCodAluno=<%=intCodAluno%>";
			</script>
			<%
			response.End()
		else
			%>
			<script>
				alert("<%=msn%>");
				window.location="EfetivacaoAluno_con.asp";;
			</script>
			<%
			response.End()
		end if
	elseif acao = "C" then
		intSemestre  = session("strSemestre")	

		strUsuarioWeb				= Session("UsuarioWeb")	
		if strCodInscricao <> "" then
			sql = "execute SP_CancelaInscricaoMatricula " & strCodInscricao & "," & strCodEmpresa & ",'" & strUsuarioWeb & "','" & strAnoLetivo & "','" & intSemestre & "'"
			'response.write sql
			'response.end
			cnn.execute sql	
			
			if err.number = 0 then
				sql = "select codigo, cod_aluno, cod_periodo, cod_turno, cod_empresa from MAT_inscricao where codigo = " & strCodInscricao
				'response.write sql
				rs.open sql, cnn
				if not rs.eof then
					intCodAluno = rs("cod_aluno")
				end if
				rs.close
				
				intCodEmp			= strCodEmpresa
				intCodDepartamento	= Session("CodDeptoUsuario")
				intCodTaxa			= ""
				intCodBebitoAluno	= ""
				strDataOcorrencia	= formatadataBD(date)
				strUsuarioIncl		= strUsuarioWeb
				strDataValidade		= ""
				strOcorrencia		= "Cancelado pela matrícula/efetivação"
				%>
				<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
				<script>
					alert("Aluno cancelado com sucesso.");
					window.location='EfetivacaoAluno_con.asp';
				</script>
				<%
			else
				%>
				<script>
					alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
					window.history.back();
				</script>
				<%
			end if	
		else
			%>
			<script>
				alert("ATENÇÃO: Codigo não informado.");
				window.history.back();
			</script>
			<%
		end if	
	end if
	%>