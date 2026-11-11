<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true
server.ScriptTimeout = 5000
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%

on error resume next
'----------Inicia uma tranzação--------------
cnn.begintrans

intCodEmp			   		= Session("CodEmpresa")
strCodParcelaInicial		= Trim(Request.Form("cmbParcelaInicial"))
strAnoInicial				= Trim(Request.Form("cmbAnoInicial"))
intCodTipoParcela			= Trim(Request.Form("cmbTipoParcela"))
intCodSituacaoAlunoFiltro	= Trim(Request.Form("cmbSituacaoAluno"))
strSiglaCursoPreMatricula	= Trim(Request.Form("cmbSiglaCursoPreMatricula"))

intRegistrosAtualizados = 0

sql = " SELECT COD_SITUACAOALUNO FROM SCA_SITUACAOALUNO"
sql = sql & " WHERE COD_EMPRESA = " & intCodEmp 
sql = sql & " AND DESC_SITUACAOALUNO='ATIVO' "
rs.open sql, cnn, 3, 3
if not rs.EOF then	
   intCodSituacaoaluno = rs("COD_SITUACAOALUNO")
else
   %>
	<script>
		alert("ATENÇÃO! Situação ATIVO não cadastrada. Verifique!");
		window.location='AtivaFinanceiro_cad.asp';
	</script>
	<%
end if
rs.close
			
sql = " SELECT A.CODIGO AS COD_ALUNO, A.MATRICULA, A.NOMEALUNO, T.NOMETURMA, DA.PARCELA, DA.ANO, DA.DATAPAGAMENTO, DA.COD_TURMA, T.ANOLETIVO, T.COD_SEMESTRE "
sql = sql & " FROM SCF_DEBITOALUNO DA "
sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = DA.COD_ALUNO AND A.Cod_Empresa = DA.Cod_Empresa"
sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = DA.COD_TURMA AND T.COD_EMPRESA = DA.COD_EMPRESA "
sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA=A.COD_EMPRESA "
sql = sql & " WHERE DA.COD_EMPRESA = " & intCodEmp
sql = sql & " AND DA.PARCELA = " & strCodParcelaInicial
sql = sql & " AND DA.ANO = " & strAnoInicial
sql = sql & " AND SA.COD_SITUACAOALUNO = " & intCodSituacaoAlunoFiltro
sql = sql & " AND cod_tipoParcela = " & intCodTipoParcela
if strSiglaCursoPreMatricula <> "0" then
   sql = sql & " AND SUBSTRING(T.NOMETURMA,1,2) = '" & trim(strSiglaCursoPreMatricula) & "'"
end if  
sql = sql & " AND cod_situacao_pagamento in (2,3,4)"
sql = sql & " order by T.NOMETURMA, A.NOMEALUNO "
rs.open sql, cnn, 3 ,3
if not rs.EOF then
	strSituacaoAluno = "A"'ativo
	while not rs.eof	  

	   	intCodAluno      = rs("COD_ALUNO")
	   	strCodTurma      = rs("COD_TURMA")
	   	strNomeTurma	 = rs("NOMETURMA")
	   	strMatricula	 = rs("MATRICULA")
	   	strDataPagamento = trim(rs("DATAPAGAMENTO"))
		if isnull(strDataPagamento) then strDataPagamento = date
	  	strDataMatricula = FORMATADATABD(strDataPagamento)

	 	'DA TURMA
		intSemestre   = rs("COD_SEMESTRE")
	  	strAnoLetivo  = rs("ANOLETIVO")
		
		if trim(intSemestre) <> trim(session("strSemestre")) or trim(strAnoLetivo) <> trim(session("strAnoLetivo")) then
		   %>
			<script>
				alert("ATENÇÃO! O Ano e Semestre da Nova Turma, não Confere com o Ano e Semestre Letivo. Verifique!");
				window.navigate('AtivaFinanceiro_cad.asp');
			</script>
			<%
			response.End()
		end if	

		'Verifico se o aluno já esta em turma para esse mesmo ano e semestre
		naoexisteativacao = "OK"
		sql = "SELECT TOP 1 COD_ALUNO, ANO_LETIVO, SEMESTRE, SITUACAO "
		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " WHERE COD_ALUNO = " & intCodAluno
		sql = sql & " Order BY CODIGO DESC "
		rsaux.open sql, cnn,3,3
		if not rsaux.EOF then
			semestreturmaexistente   = rs("COD_SEMESTRE")
			Anoturmaexistente 		 = rs("ANOLETIVO")
		end if
		rsaux.close
			
		
		' atualiza situação aluno
		sql = " UPDATE SCA_ALUNO SET " 
		sql = sql & " COD_SITUACAOALUNO = " & intCodSituacaoaluno & ","
		sql = sql & " DATAFASTAMENTO = NULL, "
		if isnull(strDataMatricula) or strDataMatricula = "" then
		   sql = sql & " DATAMATRICULA = " & formatadaBD(date) & ","
		else   
		   sql = sql & " DATAMATRICULA = '" & strDataMatricula & "',"
		end if   
		sql = sql & " SETRANSP = NULL"
		sql = sql & " Where codigo = " & intCodAluno
		sql = sql & " and	cod_empresa = " &  intCodEmp

		cnn.execute sql
		GravarLog sql	
		
		'GRAVA NO CONTROLE SITUACAO ALUNO
		sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & intCodAluno & "," 
		sql = sql & "" & strAnoLetivo & "," 
		sql = sql & "" & intSemestre & "," 
		sql = sql & "" & intCodSituacaoaluno & "," 
		sql = sql & "'"& formataDataBD(date)& " " &time& "')" 			
		cnn.execute sql
		GravarLog sql		
	
		'incluir aluno na nova turma
		sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
		sql = sql & " FROM SCA_ALUNO_TURMA"
		sql = sql & " where COD_TURMA = " & strCodTurma
		sql = sql & " and COD_EMPRESA = " & intCodEmp
		rsaux.open sql, cnn,3,3
		if not rsaux.EOF then
			if rsaux("MaiorSeq") <> "" then
				intSequencia = cstr(rsaux("MaiorSeq")) + 1
			else
				intSequencia = 1	
			end if
		end if
		rsaux.close		

		'inativa a turma anterior
		sql = "update SCA_ALUNO_TURMA "
		sql = sql & " SET SITUACAO = 'R'," 
		sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
		sql = sql & " where COD_EMPRESA = " & intCodEmp
		sql = sql & " and 	COD_ALUNO = " & intCodAluno
		sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
		cnn.execute sql
		GravarLog sql			

		strSituacaoNaTurma = "A" 'ativo na turma
		sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & intCodAluno & "," 
		sql = sql & "" & strCodTurma & "," 
		sql = sql & "" & intSequencia & "," 
		sql = sql & "" & strAnoLetivo & "," 
		sql = sql & "" & intSemestre & "," 
		sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
		sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
		cnn.execute sql
		GravarLog sql

		'Verifico se existe histórico de situações para o aluno
		sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
		sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
		sql = sql & " AND COD_ALUNO = " & intCodAluno
		sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND SEMESTRE = " & intSemestre
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
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	COD_ALUNO = " & intCodAluno
			sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and 	SEMESTRE = " & intSemestre
			cnn.execute sql
			GravarLog sql
		else   
			'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & intCodEmp & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & intSemestre & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intCodSituacaoaluno & ","
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql
		end if	
		
		if naoexisteativacao = "OK" then
		
			'Limpa a Tabela de Faltas Diárias
			sql = "DELETE " 
			sql = sql & " FROM 	SCA_FALTAS_DIARIA "
			sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
			sql = sql & " AND 	COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql	
	
			'Limpa a Tabela Notas e Faltas
			sql = "DELETE " 
			sql = sql & " FROM 	SCA_NOTAS_FALTAS "
			sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
			sql = sql & " AND 	COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql	
	
			'Limpa a Tabela de grade curricular do aluno
			sql = "DELETE " 
			sql = sql & " FROM 	sca_aluno_disciplina "
			sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
			sql = sql & " AND 	COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql	
			
			' Zera o lançamento de desconto existente no cadastro do aluno
			sql = "UPDATE SCA_ALUNO set"
			sql = sql & " cod_categoria_desconto=null, perc_desconto=null, perc_desconto2=null, perc_desconto3=null, perc_desconto4=null "
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	CODIGO = " & intCodAluno
			cnn.execute sql
			GravarLog sql

			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & intCodEmp
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
					sql = sql & " AND	H.COD_EMPRESA = " & intCodEmp
					Rs1.open sql, cnn,3,3
					if Rs1.EOF then				
				
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & intCodEmp & "," 
						sql = sql & "" & intCodAluno & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rsaux("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql		
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & intCodEmp & "," 
							sql = sql & "" & intCodAluno & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						    sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rsaux("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
		
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO, COD_GRADECURRICULARDISCIPLINA, COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & intCodEmp & "," 
								sql = sql & "" & intCodAluno & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
						        sql = sql & "" & rsaux("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rsaux("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							
							END IF
						END IF
					end if
					Rs1.Close	
					
					rsaux.movenext
				wend
			else
				rsaux.close	
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO! Grade Curricular da turma <%=strNomeTurma%> não esta cadastrada. \nFavor ajustar e retornar para executar esse procedimento novamente!");
					window.location='AtivaFinanceiro_cad.asp';
				</script>
				<%
				response.End()
			end if
			rsaux.close	
		end if
		
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

		intCodEmp			= intCodEmp
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodAluno			= intCodAluno
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		strOcorrencia		= "Ativado conforme pagamento da matrícula"
	
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
	
		intRegistrosAtualizados = intRegistrosAtualizados + 1
		
		rs.movenext	
		
   wend	

else
	rs.close	
	cnn.rollbackTrans
	%>
	<script>
		alert("ATENÇÃO! Não foram encontrada informações para executar esse procedimento. Favor verifique!");
		window.location='AtivaFinanceiro_cad.asp';
	</script>
	<%
	response.End()
end if	
rs.close

strMensagem = "Procedimento finalizado com sucesso!!!\nTotal de Aluno Ativados: " & intRegistrosAtualizados

if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
	cnn.commitTrans
	%>
	<script>
		alert("<%=strMensagem%>");
		window.location='AtivaFinanceiro_cad.asp';
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