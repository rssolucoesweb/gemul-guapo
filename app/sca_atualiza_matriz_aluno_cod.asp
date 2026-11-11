<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 

response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/02/2022
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_replaceRequest.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	vetAluno			=	split(Trim(Request.form("chkAluno")),",")
	strParametro 		= "AtualizaGradeAluno_cad.asp"

	'carregando variavel
	'chave
	strCod_empresa 			= Session("CodEmpresa")
	strCodTurma 			= Trim(Request.Form("cmbTurma"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strAtualizaGrade    	= Trim(Request.Form("cmbAtualizaGrade"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	strSemestre 		= Trim(Request.Form("cmbSemestre"))
	if strSemestre = "" then 	strSemestre  = session("strSemestre")
	if strCodTurma = "" then strCodTurma = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	' Consulto o Nome da Turma
	if strCodTurma <> "0" then
		sql = "select COD_SEMESTRE from SCA_TURMA"
		sql = sql & " Where Cod_Empresa = " & strCod_empresa
		sql = sql & " And Cod_Turma = " & strCodTurma
		rs.open sql, cnn
		if rs.eof = false then
			strSemestre = RS("COD_SEMESTRE")
		end if
		rs.close	

		'copia o espelho da grade da turma e inclui ao aluno
		codCursoModulacao = "0"
		strTipoModulacao = "0"
		sql = "select P.Cod_Curso, ISNULL(C.Tipo_Modulacao,'P') as Tipo_Modulacao, T.NOMETURMA from SCA_TURMA T "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao='A' "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
		sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
		sql = sql & " WHERE T.COD_TURMA = " & strCodTurma 
		rsaux.open sql, cnn,3,3
		if not rsaux.EOF then
		   codCursoModulacao = rsaux("Cod_Curso")
		   strTipoModulacao = rsaux("Tipo_Modulacao")
		   strNomeTurmaModulacao = rsaux("NOMETURMA")
		end if
		rsaux.close		
	end if

	for i=0 to uBound(vetAluno)

 		if strAtualizaGrade = "D" then 
			' tira o aluno da turma e das disciplinas
			sql = "DELETE " 
			sql = sql & " FROM 	SCA_FALTAS_DIARIA "
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND 	COD_ALUNO = " & vetAluno(i)
			if strAtualizaGrade = "D" and intCodDisciplinaTurma <> "0" then
				sql = sql & " AND 	COD_DISCIPLINA = " & intCodDisciplinaTurma
			end if
			cnn.execute sql
	
			' limpa a tabela de notas
			sql = "DELETE "
			sql = sql & " from 	SCA_NOTAS_FALTAS "
			sql = sql & " where	COD_EMPRESA = " & strCod_empresa
			sql = sql & " and	COD_ALUNO = " & vetAluno(i)
			if strAtualizaGrade = "D" and intCodDisciplinaTurma <> "0" then
				sql = sql & " AND 	COD_DISCIPLINA = " & intCodDisciplinaTurma
			end if
			cnn.execute sql
	
			' tira o aluno da turma e das disciplinas
			sql = "DELETE "
			sql = sql & " from SCA_ALUNO_DISCIPLINA "
			sql = sql & " where	COD_EMPRESA = " & strCod_empresa
			sql = sql & " and	COD_ALUNO = " & vetAluno(i)
			if strAtualizaGrade = "D" and intCodDisciplinaTurma <> "0" then
				sql = sql & " AND 	COD_DISCIPLINA = " & intCodDisciplinaTurma
			end if
			cnn.execute sql
		end if
		
        if strAtualizaGrade = "A" then
			'verifica se o aluno já esta na tabela aluno turma com a situação ativo
			sql = "SELECT CODIGO"
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " WHERE	COD_TURMA 	= " & strCodTurma
			sql = sql & " AND	COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	COD_ALUNO 	= " & vetAluno(i)
			sql = sql & " AND	ANO_LETIVO 	= " & strAnoLetivo
			sql = sql & " AND	SEMESTRE 	= " & strSemestre
			sql = sql & " AND	SITUACAO 	= 'A'"'GRADE ATIVA
			rs.open sql, cnn,3,3
			if RS.EOF then
				RS.CLOSE
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
				
				strSituacaoNaTurma = "A" 'ativo na turma
				sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCod_empresa & "," 
				sql = sql & "" & vetAluno(i) & "," 
				sql = sql & "" & strCodTurma & "," 
				sql = sql & "" & intSequencia & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
				sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
				GravarLog sql
			else
				RS.CLOSE
			end if
		
		
			if strTipoModulacao <> "T" then 'Testa Modulacao Total ou parcial  - aqui e se for igual P
			
				'copia o espelho da grade da turma e inclui ao aluno
				sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
				sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
				sql = sql & " AND T.COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND G.SITUACAO = 'A'"'GRADE ATIVA
				if intCodDisciplinaTurma <> "0" and intCodDisciplinaTurma <> "0" then
					sql = sql & " AND GD.COD_DISCIPLINA = " & intCodDisciplinaTurma
				end if
				rs.open sql, cnn,3,3
				if not RS.EOF then
					while not rs.eof
					
						sql = " SELECT COD_GRADECURRICULARDISCIPLINA FROM SCA_ALUNO_DISCIPLINA "
						sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
						sql = sql & " AND COD_ALUNO = " & vetAluno(i)
						sql = sql & " AND COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")
						rsAux.open sql, cnn, 3, 3
						if not rsAux.eof then
							strIncluirGrade = "N"
						else
							strIncluirGrade = "S"
						end if
						rsAux.close

						sql = "SELECT HD.SITUACAO"
						sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
						sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
						sql = sql & " WHERE	H.COD_ALUNO = " & vetAluno(i)
						sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
						sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
						sql = sql & " AND	H.ANO_LETIVO = " & strAnoLetivo
						sql = sql & " AND	H.SEMESTRE = " & strSemestre
						Rs1.open sql, cnn,3,3
						if Rs1.EOF then				
					
							if strIncluirGrade = "S" then 
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & vetAluno(i) & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql
							end if		
											
						else
							IF ISNULL(Rs1("SITUACAO")) THEN
								
								if strIncluirGrade = "S" then 
									sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
									sql = sql & "" & strCod_empresa & "," 
									sql = sql & "" & vetAluno(i) & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & strCodTurma & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
									sql = sql & "" & rs("COD_DISCIPLINA") & "," 
									sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
									cnn.execute sql
									GravarLog sql
								end if	
							ELSE
								IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
								
									if strIncluirGrade = "S" then 
										sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
										sql = sql & "" & strCod_empresa & "," 
										sql = sql & "" & vetAluno(i) & "," 
										sql = sql & "" & strCodTurma & "," 
										sql = sql & "" & strCodTurma & "," 
										sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
										sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
										sql = sql & "" & rs("COD_DISCIPLINA") & "," 
										sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
										cnn.execute sql
										GravarLog sql	
									end if	
								
								END IF
							END IF
						end if
						Rs1.Close							
					
						rs.movenext
					wend
				end if
				rs.close	
			else

				sql = " select Cod_Turma from SCA_TURMA T "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao = 'A' "
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE T.cod_empresa = " & strCod_empresa 
				sql = sql & " AND T.Cod_Semestre = " & strSemestre 
				sql = sql & " AND T.AnoLetivo = " & strAnoLetivo 
				sql = sql & " and P.Cod_curso = " & codCursoModulacao 
				sql = sql & " and RIGHT(nometurma,6) = '" & right(strNomeTurmaModulacao,6) & "'"
				sql = sql & " AND (T.Situacao = 'A' or T.Situacao = 'S')"
				rsAux1.open sql, cnn, 3, 3
				if not rsAux1.eof then
					vetAux1 = rsAux1.getRows
				end if
				rsAux1.close
			
				if isArray(vetAux1) then
					for j=0 to ubound(vetAux1,2)
	
						strCodTurmaModulacao = vetAux1(0,j) 
			
						sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
						sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
						sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
						sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
						sql = sql & " WHERE	T.COD_TURMA = " & strCodTurmaModulacao
						sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
						sql = sql & " AND	G.SITUACAO = 'A'" 'GRADE ATIVA
						rsAux1.open sql, cnn,3,3
						if not rsAux1.EOF then
							while not rsAux1.eof

								sql = " SELECT COD_GRADECURRICULARDISCIPLINA FROM SCA_ALUNO_DISCIPLINA "
								sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
								sql = sql & " AND COD_ALUNO = " & vetAluno(i)
								sql = sql & " AND COD_GRADECURRICULARDISCIPLINA = " & rsAux1("COD_GRADECURRICULARDISCIPLINA")
								rsAux.open sql, cnn, 3, 3
								if not rsAux.eof then
									strIncluirGrade = "N"
								else
									strIncluirGrade = "S"
								end if
								rsAux.close
							
								if strCriarGradeChecandoHistorico = "" or strCriarGradeChecandoHistorico = "S" then
					
									sql = "SELECT HD.SITUACAO"
									sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
									sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
									sql = sql & " WHERE	H.COD_ALUNO = " & vetAluno(i)
									sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rsAux1("COD_GRADECURRICULARDISCIPLINA")				
									sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
									Rs1.open sql, cnn,3,3
									if Rs1.EOF then				
										
										if strIncluirGrade = "S" then 
											sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA,  COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
											sql = sql & "" & strCod_empresa & "," 
											sql = sql & "" & vetAluno(i) & "," 
											sql = sql & "" & strCodTurmaModulacao & "," 
											sql = sql & "" & strCodTurmaModulacao & "," 
											sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
											sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
											sql = sql & "" & rsAux1("COD_DISCIPLINA") & "," 
											sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
											cnn.execute sql
											GravarLog sql
										end if			
														
									else
										IF ISNULL(Rs1("SITUACAO")) THEN
											if strIncluirGrade = "S" then 
												sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
												sql = sql & "" & strCod_empresa & "," 
												sql = sql & "" & vetAluno(i) & "," 
												sql = sql & "" & strCodTurmaModulacao & "," 
												sql = sql & "" & strCodTurmaModulacao & "," 
												sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
												sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
												sql = sql & "" & rsAux1("COD_DISCIPLINA") & "," 
												sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
												cnn.execute sql
												GravarLog sql	
											end if	
										ELSE
										IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" and Rs1("SITUACAO") <> "AC" then
												if strIncluirGrade = "S" then 
													sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
													sql = sql & "" & strCod_empresa & "," 
													sql = sql & "" & vetAluno(i) & "," 
													sql = sql & "" & strCodTurmaModulacao & "," 
													sql = sql & "" & strCodTurmaModulacao & "," 
													sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
													sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
													sql = sql & "" & rsAux1("COD_DISCIPLINA") & "," 
													sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
													cnn.execute sql
													GravarLog sql
												end if			
											
											END IF
										END IF
			
									end if
									Rs1.Close	
								else
								 	if strIncluirGrade = "S" then 
										sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA,  COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
										sql = sql & "" & strCod_empresa & "," 
										sql = sql & "" & vetAluno(i) & "," 
										sql = sql & "" & strCodTurmaModulacao & "," 
										sql = sql & "" & strCodTurmaModulacao & "," 
										sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
										sql = sql & "" & rsAux1("COD_GRADECURRICULARDISCIPLINA") & "," 
										sql = sql & "" & rsAux1("COD_DISCIPLINA") & "," 
										sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
										cnn.execute sql
										GravarLog sql		
									end if
								end if			
								rsAux1.movenext
							wend
						else
							rsaux1.close	
							cnn.rollbackTrans
							%>
							<script>
								alert("ATENÇÃO! Grade Curricular da turma <%=strNomeTurmaModulacao%> não esta cadastrada. \nFavor ajustar e retornar para executar esse procedimento novamente!");
								window.location.href = '<%=strParametro%>'
							</script>
							<%
							response.End()
						end if
						rsAux1.close
					next
				end if	

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
	
		intCodEmp			= strCod_empresa
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodAluno			= vetAluno(i)
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
        if strAtualizaGrade = "A" then
		   strOcorrencia		= "Atualização da Grade do Aluno."
		else   
		   strOcorrencia		= "Exclusão da Grade do Aluno pela Atualização."
        end if
		%>
		<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%					
		
		strMensagem = "Atualização finalizada com sucesso..."

	next

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		strParametro = "sca_atualiza_matriz_alunoCon.asp"
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