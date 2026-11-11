<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 09/10/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Vestibular Dados
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 						= Trim(Request.QueryString("acao"))
	strCod_empresa 				= Session("CodEmpresa")
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	
	strCodTurmaDestino 			= Trim(Request.Form("txtCodTurmaDestino"))
	strNomeTurmaDestino 		= Trim(Request.Form("txtNomeTurmaDestino"))
	
	'strAnoLetivoDestino			= Trim(Request.Form("txtAnoLetivoDestino"))
	'strSemestreDestino 			= Trim(Request.Form("txtSemestreDestino"))
	
	strAluno      				= Trim(Request.Form("chkAluno"))
	vetAluno					= split(strAluno,",")
	
	
	if Trim(Request.Form("chkAluno")) = "" then
	   %>
		<script>
			alert("ATENÇÃO! Nenhuma Marcação válida. Verifique!");
			window.location='PromocaoAutomatica_cad.asp';
		</script>
		<%
	end if

	sql = " SELECT COD_SITUACAOALUNO FROM SCA_SITUACAOALUNO"
	sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa 
	sql = sql & " AND DESC_SITUACAOALUNO='ATIVO' "
	rs.open sql, cnn, 3, 3
	if not rs.EOF then	
	   intCodSituacaoaluno = rs("COD_SITUACAOALUNO")
	else
	   %>
		<script>
			alert("ATENÇÃO! Situação ATIVO não cadastrada. Verifique!");
			window.location='PromocaoAutomatica_cad.asp';
		</script>
		<%
	end if
	rs.close

	sql = "SELECT AnoLetivo, Cod_Semestre FROM SCA_TURMA"
	sql = sql & " WHERE	COD_EMPRESA = " & strCod_empresa
	sql = sql & " AND	COD_TURMA = " & strCodTurmaDestino
	rs.open sql, cnn
	IF not RS.EOF then		
		strAnoLetivoDestino         = rs("AnoLetivo")
		strSemestreDestino          = rs("Cod_Semestre")
	else
	   %>
		<script>
			alert("ATENÇÃO! Turma não cadastrada. Verifique!");
			window.location='PromocaoAutomatica_cad.asp';
		</script>
		<%
	end if
	Rs.close	
	
	if acao="I" then
	
	   strMensagem = "Promoção Automatica realizada com sucesso..."
	   
	   for i=0 to ubound(vetAluno)
	   	
			intCodALuno = vetAluno(i)

			' atualiza situação aluno
			sql = " UPDATE SCA_ALUNO SET " 
			sql = sql & " COD_SITUACAOALUNO = " & intCodSituacaoaluno & ","
			sql = sql & " DATAFASTAMENTO = NULL, "
			sql = sql & " DATAMATRICULA = '"& formataDataBD(date)& " " &time& "',"
			sql = sql & " SETRANSP = NULL"
			sql = sql & " Where codigo = " & intCodAluno
			sql = sql & " and cod_empresa = " & strCod_empresa
			cnn.execute sql
			GravarLog sql	
		
			'GRAVA NO CONTROLE SITUACAO ALUNO
			sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strAnoLetivoDestino & "," 
			sql = sql & "" & strSemestreDestino & "," 
			sql = sql & "" & intCodSituacaoaluno & "," 
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 			
			cnn.execute sql
			GravarLog sql		
	
			'incluir aluno na nova turma
			sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " where COD_TURMA = " & strCodTurmaDestino
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			rsaux.open sql, cnn,3,3
			if not rsaux.EOF then
				if rsaux("MaiorSeq") <> "" then
					intSequencia = cstr(rsaux("MaiorSeq")) + 1
				else
					intSequencia = 1	
				end if
			end if
			rsaux.close		
			
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	Cod_Turma = " & strCodTurmaDestino
			cnn.execute sql
			GravarLog sql	

			'inativa a turma anterior
			sql = "update SCA_ALUNO_TURMA "
			sql = sql & " SET SITUACAO = 'R'," 
			sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	COD_ALUNO = " & intCodAluno
			sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
			cnn.execute sql
			GravarLog sql			

			strSituacaoNaTurma = "A" 'ativo na turma
			sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strCodTurmaDestino & "," 
			sql = sql & "" & intSequencia & "," 
			sql = sql & "" & strAnoLetivoDestino & "," 
			sql = sql & "" & strSemestreDestino & "," 
			sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql

			'Verifico se existe histórico de situações para o aluno
			sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND COD_ALUNO = " & intCodAluno
			sql = sql & " AND ANO_LETIVO = " & strAnoLetivoDestino
			sql = sql & " AND SEMESTRE = " & strSemestreDestino
			rsaux.open sql, cnn,3,3
			if not rsaux.EOF then
			   existeSituacao = "OK"
			else
			   existeSituacao = "NO"
			end if
			rsaux.close	

			if existeSituacao = "OK" then
				'ATUALIZO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
				sql = "UPDATE SCA_SITUACAO_ACADEMICA_ALUNO "
				sql = sql & " SET COD_SITUACAOALUNO = " & intCodSituacaoaluno & ", DATA_SITUACAO = '" & FORMATADATABD(DATE) & "'"
				sql = sql & " where COD_EMPRESA = " & strCod_empresa
				sql = sql & " and 	COD_ALUNO = " & intCodAluno
				sql = sql & " and 	ANO_LETIVO = " & strAnoLetivoDestino
				sql = sql & " and 	SEMESTRE = " & strSemestreDestino
				cnn.execute sql
				GravarLog sql
			else   
				'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
				sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCod_empresa & "," 
				sql = sql & "" & strAnoLetivoDestino & "," 
				sql = sql & "" & strSemestreDestino & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strCodTurmaDestino & "," 
				sql = sql & "" & intCodSituacaoaluno & ","
				sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
				GravarLog sql
			end if	
		
			' APAGANDO OS LANÇAMENTOS DE NOTAS 
			sql = " DELETE " 
			sql = sql & " FROM 	SCA_NOTAS_FALTAS "
			sql = sql & " WHERE COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql	

			' APAGANDO OS LANÇAMENTOS DE NOTAS - Verificando resíduo
			sql = " DELETE FROM SCA_NOTAS_FALTAS "
			sql = sql & " WHERE cod_aluno_disciplina IN(SELECT CODIGO FROM sca_aluno_disciplina WHERE COD_ALUNO = " & intCodAluno & ")"
			cnn.execute sql
			GravarLog sql	

			' APAGANDO A GRADE DO ALUNO
			sql = " DELETE " 
			sql = sql & " FROM 	sca_aluno_disciplina "
			sql = sql & " WHERE COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql
			
			' Zera o lançamento de desconto existente no cadastro do aluno
			sql = "UPDATE SCA_ALUNO set"
			sql = sql & " cod_categoria_desconto=null, perc_desconto=null, perc_desconto2=null, perc_desconto3=null, perc_desconto4=null "
			sql = sql & " where COD_EMPRESA = " & strCod_empresa
			sql = sql & " and 	CODIGO = " & intCodAluno
			cnn.execute sql
			GravarLog sql

			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurmaDestino
			sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	G.SITUACAO = 'A'"'GRADE ATIVA
			rsaux.open sql, cnn,3 ,3
			if not rsaux.EOF then
				while not rsaux.eof
					
					'gera grade para o aluno 
					sql = "SELECT HD.SITUACAO"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
					sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
					sql = sql & " WHERE	H.COD_ALUNO = " & intCodAluno
					sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rsaux("COD_GRADECURRICULARDISCIPLINA")				
					sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
					Rs1.open sql, cnn,3,3
					if Rs1.EOF then				
				
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & strCod_empresa & "," 
						sql = sql & "" & intCodAluno & "," 
						sql = sql & "" & strCodTurmaDestino & "," 
						sql = sql & "" & strCodTurmaDestino & "," 
						sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rsaux("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql		
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCod_empresa & "," 
							sql = sql & "" & intCodAluno & "," 
							sql = sql & "" & strCodTurmaDestino & "," 
							sql = sql & "" & strCodTurmaDestino & "," 
							sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						    sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rsaux("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
		
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & intCodAluno & "," 
								sql = sql & "" & strCodTurmaDestino & "," 
								sql = sql & "" & strCodTurmaDestino & "," 
								sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						        sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rsaux("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							
							END IF
						END IF
					end if

					rs1.Close	
					
					rsaux.movenext
				wend
			else
				rsaux.close	
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO! Grade Curricular da turma <%=strNomeTurma%> não esta cadastrada. \nFavor ajustar e retornar para executar esse procedimento novamente!");
					window.location='PromocaoAutomatica_cad.asp';
				</script>
				<%
				response.End()
			end if
			rsaux.close	
		
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
			intCodAluno			= intCodAluno
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Ativado pela Promoção Automática."
		
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		
			intRegistrosAtualizados = intRegistrosAtualizados + 1

		next
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PromocaoAutomatica_cad.asp';
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