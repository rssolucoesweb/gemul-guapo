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
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	vetAluno			=	split(Trim(Request.form("chkAluno")),",")

	'carregando variavel
	'chave
	strCod_empresa 			= Session("CodEmpresa")
	strCodTurma 			= Trim(Request.Form("cmbTurma"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strAtualizaGrade    	= Trim(Request.Form("cmbAtualizaGrade"))
	if strAtualizaGrade = "D" then
	   intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	end if   

	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	strSemestre 		= Trim(Request.Form("cmbSemestre"))
	if strSemestre = "" then 	strSemestre  = session("strSemestre")
	if strCodTurma = "" then strCodTurma = "0"
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
	end if

	for i=0 to uBound(vetAluno)
	
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
		end if		

 		' tira o aluno da turma e das disciplinas
		sql = "DELETE " 
		sql = sql & " FROM 	SCA_FALTAS_DIARIA "
		sql = sql & " WHERE COD_ALUNO = " & vetAluno(i)
		if strAtualizaGrade = "D" and intCodDisciplinaTurma <> "0" then
			sql = sql & " AND 	COD_DISCIPLINA = " & intCodDisciplinaTurma
		end if
		cnn.execute sql
		GravarLog sql	

    	' limpa a tabela de notas
		sql = "DELETE "
		sql = sql & " from 	SCA_NOTAS_FALTAS "
		sql = sql & " where	COD_ALUNO = " & vetAluno(i)
		if strAtualizaGrade = "D" and intCodDisciplinaTurma <> "0" then
			sql = sql & " AND 	COD_DISCIPLINA = " & intCodDisciplinaTurma
		end if
		cnn.execute sql
		GravarLog sql	

		' tira o aluno da turma e das disciplinas
		sql = "DELETE "
		sql = sql & " from SCA_ALUNO_DISCIPLINA "
		sql = sql & " where	COD_ALUNO = " & vetAluno(i)
		if strAtualizaGrade = "D" and intCodDisciplinaTurma <> "0" then
			sql = sql & " AND 	COD_DISCIPLINA = " & intCodDisciplinaTurma
		end if
		cnn.execute sql
		GravarLog sql	
		
        if strAtualizaGrade = "A" then
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
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
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
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
		
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
							
							END IF
						END IF
					end if
					Rs1.Close							
				
					rs.movenext
				wend
			end if
			rs.close	
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
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%					
		
		strMensagem = "Atualização finalizada com sucesso..."

	next
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		strParametro = "AtualizaGradeAluno_cad.asp"
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