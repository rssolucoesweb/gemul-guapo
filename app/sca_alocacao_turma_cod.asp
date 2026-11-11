<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strSemestre 		= Trim(Request("cmbSemestreAlocacao"))
	if trim(request("txtAnoLetivoLocacao")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivoLocacao")
	end if
	
	intCodAluno				= Trim(Request.Form("chkAluno"))
	intCodTurmaAlocacao 	= Trim(Request.Form("cmbTurmaAlocacao"))
	strTipoAlocacao 		= Trim(Request.Form("cmbTipoAlocacao"))
	intCodTurmaAnterior		= Trim(Request.Form("cmbTurma"))
	
	strAnoLetivoNovo			= Trim(Request.Form("txtAnoLetivoLocacao"))
	strAnoLetivoAtual			= Trim(Request.Form("txtAnoLetivo"))
	
	
	vetAluno = split(intCodAluno,",")
	
	'copia o espelho da grade da turma e inclui ao aluno
	codCursoModulacao = "0"
	strTipoModulacao = "0"
	sql = "select P.Cod_Curso, ISNULL(C.Tipo_Modulacao,'P') as Tipo_Modulacao, T.NOMETURMA, T.Cod_Semestre, P.Cod_Periodo "
	sql = sql & " from SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao='A' "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
	sql = sql & " WHERE T.COD_TURMA = " & intCodTurmaAnterior 
	rsaux.open sql, cnn,3,3
	if not rsaux.EOF then
	   intCodPeriodoAnterior	= rsaux("Cod_Periodo")
	end if
	rsaux.close	
	
	sql = "select P.Cod_Curso, ISNULL(C.Tipo_Modulacao,'P') as Tipo_Modulacao, T.NOMETURMA, T.Cod_Semestre, P.Cod_Periodo "
	sql = sql & " from SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao='A' "
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
	sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
	sql = sql & " WHERE T.COD_TURMA = " & intCodTurmaAlocacao 
	rsaux.open sql, cnn,3,3
	if not rsaux.EOF then
	   codCursoModulacao 		= rsaux("Cod_Curso")
	   strTipoModulacao 		= rsaux("Tipo_Modulacao")
	   strNomeTurmaModulacao 	= rsaux("NOMETURMA")
	   strSemestre 				= rsaux("COD_SEMESTRE")
	   intCodPeriodoAlocacao	= rsaux("Cod_Periodo")
	end if
	rsaux.close	
	
	strCOD_GRADECURRICULARAnterior = 0
	strNomeTurmaAnterior = ""
	sql = "SELECT COD_GRADECURRICULAR, NomeTurma, TurmaAluno  FROM SCA_TURMA"
	sql = sql & " WHERE	COD_TURMA = " & intCodTurmaAnterior
	rs.open sql, cnn
	IF not RS.EOF then		
		strCOD_GRADECURRICULARAnterior = rs("COD_GRADECURRICULAR")
		strNomeTurmaAnterior = rs("TurmaAluno") & " " & rs("NomeTurma")
	END IF		
	Rs.close
	
	strCOD_GRADECURRICULARAtual = 0
	strNomeTurmaAtual=""
	sql = "SELECT COD_GRADECURRICULAR, NomeTurma, TurmaAluno FROM SCA_TURMA"
	sql = sql & " WHERE	COD_TURMA = " & intCodTurmaAlocacao
	rs.open sql, cnn
	IF not RS.EOF then		
		strCOD_GRADECURRICULARAtual = rs("COD_GRADECURRICULAR")
		strNomeTurmaAtual = rs("TurmaAluno") & " " & rs("NomeTurma")
	END IF		
	Rs.close				

	
	for i=0 to ubound(vetAluno)

		intCodAluno	 = vetAluno(i)
		
		sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
		sql = sql & " FROM SCA_ALUNO_TURMA"
		sql = sql & " where COD_TURMA = " & intCodTurmaAlocacao
		sql = sql & " and COD_EMPRESA = " & intCodEmp
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
		sql = sql & " where COD_EMPRESA = " & intCodEmp
		sql = sql & " and 	COD_ALUNO = " & intCodAluno
		sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
		cnn.execute sql
		GravarLog sql		
		
		'atualiza vagas antiga
		sql = "update SCA_TURMA "
		sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
		sql = sql & " where Cod_Turma = " & intCodTurmaAnterior
		'response.write sql & "<hr>"
		cnn.execute sql
		GravarLog sql
			
		'atualiza vagas nova
		sql = "update SCA_TURMA "
		sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
		sql = sql & " where Cod_Turma = " & intCodTurmaAlocacao
		'response.write sql & "<hr>"
		cnn.execute sql
		GravarLog sql	

		strSituacaoNaTurma = "A" 'ativo na turma
		sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & intCodAluno & "," 
		sql = sql & "" & intCodTurmaAlocacao & "," 
		sql = sql & "" & intSequencia & "," 
		sql = sql & "" & strAnoLetivo & "," 
		sql = sql & "" & strSemestre & "," 
		sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
		sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
		cnn.execute sql
		GravarLog sql
			
		'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
		sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & strAnoLetivo & "," 
		sql = sql & "" & strSemestre & "," 
		sql = sql & "" & intCodAluno & "," 
		sql = sql & "" & intCodTurmaAlocacao & "," 
		sql = sql & "NULL,"
		sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
		cnn.execute sql
		GravarLog sql
		
		
		'-------------------------------------------------------
		'------ INICIO - TROCA A FICHA DESCRITIVA DE TURMA -----
		'-------------------------------------------------------
		sql = "select cod_turno"
		sql = sql & " from SCA_TURMA"
		sql = sql & " where cod_turma = " & intCodTurmaAlocacao
		rs.open sql, cnn
		if not RS.EOF then
			intCodTurno = rs("cod_turno")
		end if
		rs.close
		
		intcodTurmaVerificacaoCadastro = intCodTurmaAlocacao
		
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
		
		if  trim(strCOD_GRADECURRICULARAnterior) = trim(strCOD_GRADECURRICULARAtual) then
			'atualiza vagas nova
			sql = "update SCA_ALUNO_DISCIPLINA "
			sql = sql & " SET cod_turma = " & intCodTurmaAlocacao & ", COD_TURMA_REMANEJAMENTO = " & intCodTurmaAlocacao
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	Cod_Turma = " & intCodTurmaAnterior
			sql = sql & " and 	Cod_aluno = " & intCodAluno
			'response.write sql & "<hr>"
			cnn.execute sql
			GravarLog sql
			
			
			'atualiza turma da ficha
			sql = "select top 1 cod_turno "
			sql = sql & " from srh_turno "
			sql = sql & " where cod_grupo=" & session("codGrupo")& " and desc_turno in ("
			sql = sql & " select t.desc_turno"
			sql = sql & " from sca_turma tu inner join sca_turno t on t.cod_turno = tu.cod_turno"
			sql = sql & " where tu.cod_turma = " & intCodTurmaAlocacao
			sql = sql & " )"
			rs.open sql, cnn
			if not RS.EOF then
				intCodTurnoNovoRH = rs("cod_turno")
			end if
			rs.close
			
			'atualiza turma da ficha
			sql = "update SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA "
			sql = sql & " SET cod_turma = " & intCodTurmaAlocacao & ",cod_turno_RH=" & intCodTurnoNovoRH
			sql = sql & " where cod_aluno = " & intCodAluno
			sql = sql & " and Cod_Turma = " & intCodTurmaAnterior
			'response.write sql & "<hr>"
			'response.end
			cnn.execute sql
			GravarLog sql
			
			acao_grade = "A" 
		else
			acao_grade = "I" 
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

			' tira o aluno da turma e das disciplinas
			sql = "DELETE "
			sql = sql & " from SCA_ALUNO_DISCIPLINA "
			sql = sql & " where	COD_ALUNO = " & intCodAluno
			cnn.execute sql
			' Fim da Limpeza de Grades do aluno
			
			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT distinct GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
			sql = sql & " WHERE	T.COD_TURMA = " & intCodTurmaAlocacao
			rsAux1.open sql, cnn, 3, 3
			if not rsAux1.eof then
				vetAux1 = rsAux1.getRows
			end if
			rsAux1.close
		
			if isArray(vetAux1) then
				for j=0 to ubound(vetAux1,2)

					COD_GRADECURRICULARDISCIPLINA = vetAux1(0,j) 
					COD_DISCIPLINA = vetAux1(1,j) 
			
					sql = "SELECT HD.SITUACAO"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
					sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
					sql = sql & " WHERE	H.COD_ALUNO = " & intCodAluno
					sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & COD_GRADECURRICULARDISCIPLINA				
					sql = sql & " AND	H.ANO_LETIVO = " & strAnoLetivo
					sql = sql & " AND	H.SEMESTRE = " & strSemestre
					Rs1.open sql, cnn,3,3
					if Rs1.EOF then				
				
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & intCodEmp & "," 
						sql = sql & "" & intCodAluno & "," 
						sql = sql & "" & intCodTurmaAlocacao & "," 
						sql = sql & "" & intCodTurmaAlocacao & "," 
						sql = sql & "" & COD_GRADECURRICULARDISCIPLINA & "," 
						sql = sql & "" & COD_GRADECURRICULARDISCIPLINA & "," 
						sql = sql & "" & COD_DISCIPLINA & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
							
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & intCodEmp & "," 
							sql = sql & "" & intCodAluno & "," 
							sql = sql & "" & intCodTurmaAlocacao & "," 
							sql = sql & "" & intCodTurmaAlocacao & "," 
							sql = sql & "" & COD_GRADECURRICULARDISCIPLINA & "," 
							sql = sql & "" & COD_GRADECURRICULARDISCIPLINA & "," 
							sql = sql & "" & COD_DISCIPLINA & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql
							
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
							
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & intCodEmp & "," 
								sql = sql & "" & intCodAluno & "," 
								sql = sql & "" & intCodTurmaAlocacao & "," 
								sql = sql & "" & intCodTurmaAlocacao & "," 
								sql = sql & "" & COD_GRADECURRICULARDISCIPLINA & "," 
								sql = sql & "" & COD_GRADECURRICULARDISCIPLINA & "," 
								sql = sql & "" & COD_DISCIPLINA & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql	
							
							END IF
						END IF
					end if
					Rs1.Close							
				
				next
			end if
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
	
		intCodEmp			= intCodEmp
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		if acao_grade = "A" then
			strOcorrencia	= "Alocação de aluno (alteração de turma). " & strNomeTurmaAnterior & " -> " & strNomeTurmaAtual
		elseif acao_grade = "I" then
			strOcorrencia 	= "Alocação de aluno (alteração de turma com remoção/inclusão de grade). " & strNomeTurmaAnterior & " -> " & strNomeTurmaAtual
		end if
		%>
		<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%	
		
		insereControleSituacao = "S"
		sql = "SELECT codigo "
		sql = sql & " FROM SCA_CONTROLE_SITUACAO_ALUNO"
		sql = sql & " where COD_ALUNO = " & intCodAluno
		sql = sql & " AND	ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND	SEMESTRE = " & strSemestre		
		Rs1.open sql, cnn
		if not Rs1.EOF then	
			insereControleSituacao = "N"
		end if
		rs1.close
		
		if insereControleSituacao = "S" then
		
			sql = "SELECT top 1 COD_SITUACAOALUNO "
			sql = sql & " FROM SCA_CONTROLE_SITUACAO_ALUNO"
			sql = sql & " where COD_ALUNO = " & intCodAluno
			sql = sql & " order by 1 desc"
			Rs1.open sql, cnn
			if not Rs1.EOF then	
				COD_SITUACAOALUNO = rs1("COD_SITUACAOALUNO")
			end if
			rs1.close
			
			sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL) VALUES ("
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & intCodEmp & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & COD_SITUACAOALUNO & "," 
			sql = sql & "getdate()," 
			sql = sql & "'" & strUsuarioIncl & "')" 
			cnn.execute sql
			GravarLog sql
			
		end if
	next
	
	strMensagem = "Registro atualizado com sucesso...\n\n" & strOcorrencia
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_alocacao_turma.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>