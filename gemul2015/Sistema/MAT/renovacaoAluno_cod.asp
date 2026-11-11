<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: historico escolar
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
'
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodEmpresa		= Session("CodEmpresa")
	strSemestre 		= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	intCodAluno			= Trim(Request.Form("chkAluno"))
	intCodTurmaAtual	= Trim(Request.Form("cmbTurma"))
	
	strAnoLetivoRenovacao = request("txtAnoLetivoRenovacao")
	cnn.begintrans
	
	if acao = "C" then
		intCodAluno			= Trim(Request("codAluno"))
		codTurmaRenovacao	= Trim(Request("codTurmaRenovacao"))
		if intCodAluno = "" then
			%>
			<script>
				alert("ATENÇÃO: \n\nDeve ser selecionado os alunos para  a confirmação.");
				window.history.back();
			</script>
			<%	
			response.End()
		end if	
		
		sql = " delete from SCA_ALUNO_RENOVACAO"
		sql = sql & " where COD_ALUNO = "& intCodAluno
		sql = sql & " and ANO_LETIVO = " & strAnoLetivo
		cnn.execute sql
		GravarLog sql	
		
		
		'Gera Ocorrencia 
		strOcorrencia		= "Confirmada Matrícula de Veteranos foi CANCELADA"

		sql = " Insert Into SCA_OCORRENCIA(COD_EMPRESA, COD_DEPARTAMENTO, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL)"	
		sql = sql & " select "
		sql = sql & "" & intCodEmp & ",null,"
		sql = sql & " codigo,"
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & " getdate(),"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & trim(session("usuarioWeb")) & "' from sca_aluno where codigo in (" & intCodAluno & ")"
		cnn.execute sql
		
		strMensagem = "Renovação do aluno foi CANCELADA com sucesso..."
	else
		if intCodAluno = "" then
			%>
			<script>
				alert("ATENÇÃO: \n\nDeve ser selecionado os alunos para  a confirmação.");
				window.history.back();
			</script>
			<%	
			response.End()
		end if	
		
		if intCodAluno <> "" then   
			vetAlunos	= split(intCodAluno,",")				 
		end if
		
		strMensagem=""
		for intContador = 0 to ubound(vetAlunos)
		
			intCodAluno = trim(vetAlunos(intContador))
			
			intCodCurso 	= request.form("cmbCurso" & intCodAluno)
			intCodPeriodo 	= request.form("cmbPeriodo" & intCodAluno)
			intCodTurno 	= request.form("cmbTurno" & intCodAluno)
			intCodTurma 	= request.form("cmbTurma" & intCodAluno)
	
			if intCodCurso<>"0" and intCodPeriodo <> "0" and intCodTurno<>"0" then
				strMensagem = "Confirmado(s) com sucesso..."
				
				sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
				sql = sql & " FROM SCA_ALUNO_TURMA"
				sql = sql & " where COD_TURMA = " & intCodTurma
				sql = sql & " and COD_EMPRESA = " & strCodEmpresa
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
				'sql = "update SCA_ALUNO_TURMA "
				'sql = sql & " SET SITUACAO = 'R'," 
				'sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
				'sql = sql & " where COD_EMPRESA = " & strCodEmpresa
				'sql = sql & " and 	COD_ALUNO = " & intCodAluno
				'sql = sql & " and 	SITUACAO = 'A'" 'ATIVA
				'cnn.execute sql
				
				'atualiza vagas nova
				sql = "update SCA_TURMA "
				sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
				sql = sql & " where Cod_Turma = " & intCodTurma
				'response.write sql & "<hr>"
				cnn.execute sql

				strSituacaoNaTurma = "A" 'ativo na turma
				sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCodEmpresa & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & intCodTurma & "," 
				sql = sql & "" & intSequencia & "," 
				sql = sql & "" & strAnoLetivoRenovacao & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
				sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
					
				'QUARDA HISTORICO DE SITUACAO DA TURMO POR ANO/SEMESTRE
				sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & strCodEmpresa & "," 
				sql = sql & "" & strAnoLetivoRenovacao & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & intCodTurma & "," 
				sql = sql & "NULL,"
				sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
				cnn.execute sql
				
				intCodEmp			= strCodEmpresa
				intCodDepartamento	= Session("CodDeptoUsuario")
				intCodAluno			= intCodAluno
				intCodTaxa			= ""
				intCodBebitoAluno	= ""
				strDataOcorrencia	= formatadataBD(date)
				strUsuarioIncl		= trim(session("usuarioWeb"))
				strDataValidade		= ""
				strOcorrencia		= "Renovação de matrícula"
				%>
				<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
				<%
				sql = "	INSERT INTO SCA_ALUNO_DISCIPLINA"
				sql = sql & " ("
				sql = sql & " 	COD_EMPRESA,"
				sql = sql & " 	COD_ALUNO,"
				sql = sql & " 	COD_TURMA,"
				sql = sql & " 	COD_TURMA_REMANEJAMENTO,"
				sql = sql & " 	COD_GRADECURRICULARDISCIPLINA,"
				sql = sql & " 	COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO,"
				sql = sql & " 	COD_DISCIPLINA,"
				sql = sql & " 	SITUACAO"
				sql = sql & " )"
				sql = sql & " SELECT"
				sql = sql & " 	T.COD_EMPRESA,"
				sql = sql & " 	" & intCodAluno & " AS COD_ALUNO,"
				sql = sql & " 	T.COD_TURMA,"
				sql = sql & " 	T.COD_TURMA,"
				sql = sql & " 	GD.COD_GRADECURRICULARDISCIPLINA,"
				sql = sql & " 	GD.COD_GRADECURRICULARDISCIPLINA,"
				sql = sql & " 	GD.COD_DISCIPLINA,"
				sql = sql & " 	'CR'"
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
				sql = sql & " JOIN SCA_GRADECURRICULAR G"
				sql = sql & " 	ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
				sql = sql & " JOIN SCA_TURMA T"
				sql = sql & " 	ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
				sql = sql & " WHERE T.COD_TURMA = " & intCodTurma
				sql = sql & "   AND T.COD_EMPRESA = " & strCodEmpresa
				sql = sql & "   AND G.SITUACAO = 'A'"
				'sql = sql & "   AND	GD.Omitir_Documentacao='N'"
				sql = sql & "   AND NOT EXISTS ("
				sql = sql & " 		SELECT 1"
				sql = sql & " 		FROM SCA_ALUNO_DISCIPLINA AD"
				sql = sql & " 		WHERE AD.COD_ALUNO = " & intCodAluno
				sql = sql & " 		  AND AD.COD_TURMA = T.COD_TURMA"
				sql = sql & " 		  AND AD.COD_DISCIPLINA = GD.COD_DISCIPLINA"
				sql = sql & "   );"
				cnn.execute sql	
				
				acao_grade = "I" 

				sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_ALUNO, COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO, USUARIO_INCL) VALUES ("
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strCodEmpresa & "," 
				sql = sql & "" & strAnoLetivoRenovacao & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "1," 
				sql = sql & "getdate()," 
				sql = sql & "'" & strUsuarioIncl & "')" 
				cnn.execute sql
				
				sql = "insert into SCA_ALUNO_RENOVACAO ("
				sql = sql & " COD_EMPRESA"
				sql = sql & ",COD_ALUNO"
				sql = sql & ",ANO_LETIVO"
				sql = sql & ",SEMESTRE"
				sql = sql & ",COD_CURSO"
				sql = sql & ",COD_PERIODO"
				sql = sql & ",COD_TURNO"
				sql = sql & ",COD_TURMA"
				sql = sql & ",COD_TURMA_RENOVACAO"
				sql = sql & ",ANO_LETIVO_RENOVACAO"
				sql = sql & ",USUARIO_INCL"
				sql = sql & ",DATA_HORA_INCL"
				sql = sql & ",EFETIVADO"
				sql = sql & ",USUARIO_EFETIVACAO"
				sql = sql & ",DATA_HORA_EFETIVACAO) VALUES ("
				sql = sql & "" & strCodEmpresa & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & intCodCurso & "," 
				sql = sql & "" & intCodPeriodo & "," 
				sql = sql & "" & intCodTurno & "," 
				sql = sql & "" & intCodTurmaAtual & ","
				sql = sql & "" & intCodTurma & "," 
				sql = sql & "" & strAnoLetivoRenovacao & "," 
				sql = sql & "'" & strUsuarioIncl & "',"
				sql = sql & "getdate()," 
				sql = sql & "'S'," 
				sql = sql & "'" & strUsuarioIncl & "',"
				sql = sql & "getdate())" 
				cnn.execute sql
				
				sql = "SELECT isnull(Logradouro,'') as Logradouro, isnull(Numero_endereco,'')  as Numero_endereco, isnull(Comp_endereco,'') as Comp_endereco, isnull(Bairroaluno,'') as Bairroaluno, isnull(Cidaderesidencia,'') as Cidaderesidencia, isnull(Ufresidencia,'') as Ufresidencia, isnull(Cepresidencia,'') as Cepresidencia"
				sql = sql & " FROM SCA_ALUNO A"
				sql = sql & " Where codigo = " & intCodAluno
				rs.open sql, cnn
				if rs.eof = false then
					'endereço
					strLogradouro 					= replace(TRIM(rs("Logradouro")),"'","")
					strNumero_endereco 				= replace(TRIM(rs("Numero_endereco")),"'","")
					strComp_endereco 				= replace(TRIM(rs("Comp_endereco")),"'","")
					strBairroaluno 					= replace(TRIM(rs("Bairroaluno")),"'","")
					strCidaderesidencia				= replace(TRIM(rs("Cidaderesidencia")),"'","")
					strUfresidencia 				= replace(TRIM(rs("Ufresidencia")),"'","")
					strCepresidencia 				= replace(TRIM(rs("Cepresidencia")),"'","")
				end if
				rs.close
				
				'gera linha ano letivo
				sql = "insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,COD_SITUACAOALUNO,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
				sql = sql & "" & strCodEmpresa & ","
				sql = sql & "" & intCodAluno & ","
				sql = sql & "" & strAnoLetivoRenovacao & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & "1,'A',getdate(),"
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
				
				sql = "update SCA_ALUNO "
				sql = sql & " SET COD_SITUACAOALUNO = 1" 
				sql = sql & " where CODIGO = " & intCodAluno
				cnn.execute sql
			end if
		next
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		if strMensagem="" then
			cnn.rollbackTrans
			%>
			<script>
				alert("Aluno não foi renovado, verifique se foi informado o curso, período e turno.");
				window.location='renovacaoAluno_cad.asp?cmbTurma=<%=intCodTurmaAtual%>';
			</script>
			<%
			response.end
		else
			cnn.commitTrans
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='renovacaoAluno_cad.asp?cmbTurma=<%=intCodTurmaAtual%>';
			</script>
			<%
			response.end
		end if
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