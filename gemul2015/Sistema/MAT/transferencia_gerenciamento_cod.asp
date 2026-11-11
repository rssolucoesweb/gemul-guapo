<%  
response.Charset = "ISO-8859-1" 
response.ContentType = "text/html" 

response.Expires = 60
response.Expiresabsolute = Now() - 1
response.AddHeader "pragma","no-cache"
response.AddHeader "cache-control","private"
response.CacheControl = "no-cache"

Server.ScriptTimeOut = 5000
%> 
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%

	strAnoLetivo 			= year(date)
	
	sql = "select ano_letivo from MAT_configura_transferencia"
	rsAux.open sql, cnn
	if not rsAux.eof then
		strAnoLetivo = rsAux("ano_letivo")
	end if
	rsAux.close	
	
	strSemestre				= 3 
	strAlunoEncontrado		= ""
	pagina					= "transferencia_gerenciamento_con.asp"
	
	cod_transferencia	= Trim(Request.Form("cod_transferencia"))
	cod_empresa_atual	= Trim(Request.Form("cod_empresa_atual"))
	
	
	'response.write intCodAluno
	'response.write "<br>intCodIrmaos:" & intCodIrmaos
	'response.write "<br>strTurnoOpcaoMarcada:" & strTurnoOpcaoMarcada
	'response.write "<br>strPeriodoOpcaoMarcada:" & strPeriodoOpcaoMarcada
	'response.write "<br>intCodEmpresaOpcaoMarcada:" & intCodEmpresaOpcaoMarcada
	'response.write "<br>opcao_marcada_aluno:" & opcao_marcada_aluno
	
	acao = request("acao")
	if acao = "T"	 then
		
		intCodAluno			= Trim(Request.Form("txtCodAluno"))
		
		'busca codigo do turno na empresa
		sql = "select codigo, cod_turma"
		sql = sql & " from sca_aluno_turma"
		sql = sql & " where cod_aluno = " & intCodAluno
		sql = sql & " and ano_letivo = " & strAnoLetivo
		sql = sql & " and cod_empresa = " & cod_empresa_atual
		sql = sql & " order by codigo desc"
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strCodTurmaAnterior = RS("cod_turma")
		END IF
		RS.CLOSE
		
		
		cnn.begintrans
		
		
		intCodIrmaos		= Trim(Request.Form("cod_irmaos"))
		if intCodIrmaos  = "" then
			codigosAlunos = intCodAluno
		else
			codigosAlunos = intCodAluno & "," & intCodIrmaos
		end if
		
		IF codigosAlunos = "" THEN codigosAlunos = "0"
		if codigosAlunos = "0" then
			cnn.RollbackTrans
			%>
			<script>
				alert("Opção do aluno não foi marcada!");
				window.location='transferencia_gerenciamento_cad.asp?cod_transferencia=<%=cod_transferencia%>';
			</script>
			<%
			response.end
		end if
		
		'SQL = "EXEC SP_transferencia_historico_escolar_identificador "
		'cnn.execute SQL
		
		vetAlunos = split(codigosAlunos,",")
		'response.write codigosAlunos
		
		for i = 0 to ubound(vetAlunos)
			intCodAluno 		= TRIM(vetAlunos(i))
		
			opcao_marcada_aluno				= Trim(Request.Form("opcao_marcada_" & intCodAluno))
		
			intCodEmpresaOpcaoMarcada 	= cInt(left(opcao_marcada_aluno,5))
			strTurnoOpcaoMarcada 		= replace(Mid(opcao_marcada_aluno, 7, 10),"_","")
			strPeriodoOpcaoMarcada 		= trim(replace(Mid(opcao_marcada_aluno, 17, 30),"_"," "))
		
			codSituacaoPreMatricula = ""
			sql = "select Cod_SituacaoAluno from sca_situacaoaluno where Desc_SituacaoAluno = 'PRÉ-MATRÍCULA' AND STATUS = 'A'" 
			rsAux.open sql, cnn
			if not rsAux.eof then
				codSituacaoPreMatricula = rsAux("Cod_SituacaoAluno")
			end if
			rsAux.close	

			if codSituacaoPreMatricula = "" then
				cnn.RollbackTrans
				%>
				<script>
					alert("Para a unidade escolhida não tem a opção PRÉ-MATRÍCULA cadastrada, acesso o cadastro de situação do aluno e inclua essa situação!");
					window.location='transferencia_gerenciamento_cad.asp?cod_transferencia=<%=cod_transferencia%>';
				</script>
				<%
				response.end
			end if
		
			SQL = "select NOMEALUNO, MAE, DATANASCIMENTO"
			SQL = SQL & " from SCA_ALUNO "
			SQL = SQL & " where codigo = " & intCodAluno
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
				strNomealuno 		= rs("NOMEALUNO")
				strMae 		 		= rs("MAE")
				strDatanascimento 	= formataDataBD(rs("DATANASCIMENTO"))
			end if
			rs.close	
			
			strAlunoFoiEncontrado = "N"
			strMatriculaEncontrada = ""
			SQL = "select a.codigo, a.matricula, a.nomealuno"
			SQL = SQL & " from SCA_ALUNO A"
			SQL = SQL & " inner join SCA_ALUNO_ANO_LETIVO AA ON AA.COD_ALUNO = A.CODIGO AND AA.COD_EMPRESA = " & intCodEmpresaOpcaoMarcada & " AND AA.ANO_LETIVO=" & strAnoLetivo
			SQL = SQL & " inner join SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO"
			SQL = SQL & " where A.NOMEALUNO = '"&strNomealuno&"'  COLLATE SQL_Latin1_General_CP1_CI_AI "
			SQL = SQL & " and A.MAE = '"&strMae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
			SQL = SQL & " and A.DATANASCIMENTO = '"&strDatanascimento&"'"
			SQL = SQL & " and SA.Desc_SituacaoAluno IN ('ATIVO', 'PRÉ-MATRÍCULA')"
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
				strAlunoFoiEncontrado = "S"
				strMatriculaEncontrada = rs("matricula")
				strAlunoEncontrada = rs("nomealuno")
			end if
			rs.close
			
			if strAlunoFoiEncontrado = "S" then
				cnn.RollbackTrans
				%>
				<script>
					alert("Aluno existente na unidade com a matricula: <%=strMatriculaEncontrada%> - <%=strAlunoEncontrada%>!");
					window.location='transferencia_gerenciamento_cad.asp?cod_transferencia=<%=cod_transferencia%>';
				</script>
				<%
				response.end
			end if
			
			intCodPeriodo	= ""
			intCodTurno		= ""
			intCodCurso		= ""
			intCodSituacaoAlunoAtivo = 1 'ATIVO
			
			'busca codigo do periodo na empresa
			sql = "select cod_periodo"
			sql = sql & " from SCA_PERIODO P INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO"
			sql = sql & " where P.Descricao = '" & strPeriodoOpcaoMarcada & "'"	
			sql = sql & " and C.SITUACAO = 'A' AND p.Matricula='S' "
			RS.OPEN SQL, CNN
			IF not RS.EOF THEN
				intCodPeriodo = RS("cod_periodo")
			END IF
			RS.CLOSE		
			
			'busca codigo do turno na empresa
			sql = "select cod_turno"
			sql = sql & " from SCA_TURNO"
			sql = sql & " where Desc_Turno = '" & strTurnoOpcaoMarcada & "'"
			RS.OPEN SQL, CNN
			IF not RS.EOF THEN
				intCodTurno = RS("cod_turno")
			END IF
			RS.CLOSE
			
			intCodEmp			= intCodEmpresaOpcaoMarcada
			intCodDepartamento	= Session("CodDeptoUsuario")
			'intCodAluno			= intCodigoAlunoNovo
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Incluído pela transferencia - módulo matrícula"
			%>
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%
			
			'DOCUMENTACAO DO ALUNO
			sql = "INSERT SCA_ALUNO_DOCUMENTACOES"
			sql = sql & " SELECT " & intCodAluno & ", CODIGO, NULL, 'R'" 
			sql = sql & " FROM SCA_DOCUMENTACOES"
			cnn.execute sql
			GravarLog sql

			''---------------------------------------------------''
			'' BUSCA TURMA DISPONIVEL PARA A ESCOLA SELECIONADA
			''---------------------------------------------------''
			intCodTurma = "0"

			sql = "select  top 1 tu.cod_turma, tu.NomeTurma, tu.TurmaAluno"
			sql = sql & " from SCA_TURMA TU "
			sql = sql & " where TU.Cod_Empresa = " & intCodEmpresaOpcaoMarcada
			sql = sql & " and TU.Situacao = 'A' "
			sql = sql & " and tu.AnoLetivo = " & strAnoLetivo  
			sql = sql & " and tu.Cod_Semestre = " & strSemestre 
			sql = sql & " and tu.Cod_Periodo = " & intCodPeriodo 
			sql = sql & " and TU.Cod_Turno = " & intCodTurno 
			sql = sql & " and "
			sql = sql & " 	case "
			sql = sql & " 		when isnull(tu.capacidade,0) <  isnull(tu.vagasReservadas,0) then "
			sql = sql & " 			isnull(tu.capacidade,0) - "
			sql = sql & " 			( "
			sql = sql & " 			select COUNT(AT1.CODIGO) "
			sql = sql & " 			from SCA_ALUNO_TURMA AT1 "
			sql = sql & " 			INNER JOIN SCA_ALUNO A1 ON AT1.COD_ALUNO = A1.CODIGO "
			sql = sql & " 			inner join SCA_SITUACAOALUNO sa1 on sa1.Cod_SituacaoAluno = a1.Cod_SituacaoAluno "
			sql = sql & " 			where AT1.Situacao = 'A' "
			sql = sql & " 			and AT1.Ano_Letivo = " & strAnoLetivo
			sql = sql & " 			and AT1.Semestre = " & strSemestre 
			sql = sql & " 			and AT1.cod_turma = tu.cod_turma "
			sql = sql & " 			and desc_situacaoaluno = 'ATIVO' "
			sql = sql & " 			)"
			sql = sql & " 		else "
			sql = sql & " 			isnull(tu.capacidade,0) -  isnull(tu.vagasReservadas,0) -"
			sql = sql & " 			( "
			sql = sql & " 			select COUNT(AT1.CODIGO) "
			sql = sql & " 			from SCA_ALUNO_TURMA AT1 "
			sql = sql & " 			INNER JOIN SCA_ALUNO A1 ON AT1.COD_ALUNO = A1.CODIGO "
			sql = sql & " 			inner join SCA_SITUACAOALUNO sa1 on sa1.Cod_SituacaoAluno = a1.Cod_SituacaoAluno "
			sql = sql & " 			where AT1.Situacao = 'A' "
			sql = sql & " 			and AT1.Ano_Letivo = " & strAnoLetivo
			sql = sql & " 			and AT1.Semestre = " & strSemestre 
			sql = sql & " 			and AT1.cod_turma = tu.cod_turma "
			sql = sql & " 			and desc_situacaoaluno = 'ATIVO' "
			sql = sql & " 			)"
			sql = sql & " 	end"
			sql = sql & " 	> 0"
			sql = sql & " order by tu.turmaAluno"
			rs.open sql, cnn,3,3
			if not RS.EOF then
				if not isnull(rs("cod_turma")) then
					intCodTurma = rs("cod_turma")
				end if
			end if
			rs.close
			
			if intCodTurma = "0" then
				sql = "select  top 1 tu.cod_turma, tu.NomeTurma, tu.TurmaAluno"
				sql = sql & " from SCA_TURMA TU "
				sql = sql & " where TU.Cod_Empresa = " & intCodEmpresaOpcaoMarcada
				sql = sql & " and TU.Situacao = 'A' "
				sql = sql & " and tu.AnoLetivo = " & strAnoLetivo  
				sql = sql & " and tu.Cod_Semestre = " & strSemestre 
				sql = sql & " and tu.Cod_Periodo = " & intCodPeriodo 
				sql = sql & " and TU.Cod_Turno = " & intCodTurno 
				sql = sql & " order by tu.turmaAluno"
				rs.open sql, cnn,3,3
				if not RS.EOF then
					if not isnull(rs("cod_turma")) then
						intCodTurma = rs("cod_turma")
					end if
				end if
				rs.close
			end if
			
			'incluir aluno na turma
			if intCodTurma = "0" then
				cnn.RollbackTrans
				%>
				<script>
					alert("ATENÇÃO: \n\nNão foi encontrada nenhuma turma!");
					window.location='transferencia_gerenciamento_cad.asp?cod_transferencia=<%=cod_transferencia%>';
				</script>
				<%
				response.end
			end if
			
			strCodTurma = intCodTurma
			'-------------codigo novo ------------------
			sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " WHERE COD_TURMA = " & strCodTurma
			rs.open sql, cnn, 3, 3
			
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
			sql = sql & "" & intCodEmpresaOpcaoMarcada & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intSequencia & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "'" & strSituacaoNaTurma & "'," 
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			
			' tira o aluno da turma e das disciplinas
			sql = "DELETE " 
			sql = sql & " FROM 	SCA_FALTAS_DIARIA "
			sql = sql & " WHERE COD_ALUNO = " & intCodAluno
			sql = sql & " and COD_EMPRESA = " & intCodEmpresaOpcaoMarcada
			cnn.execute sql

			'--SP para fazer o aproveitamento das notas da unidade e turma anterior
			sql = "exec SP_SCA_aproveitamento_notas_por_transferencia " & strAnoLetivo & "," & intCodAluno & "," & cod_empresa_atual & "," & intCodEmpresaOpcaoMarcada & "," & strCodTurmaAnterior & "," &  strCodTurma & ",'" &  session("usuarioWeb") & "'"
			response.write sql
			
			cnn.execute sql
			
			'-----atualiza vaga na turma
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
			sql = sql & " where COD_EMPRESA = " & intCodEmpresaOpcaoMarcada
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql
			
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
			sql = sql & " where COD_EMPRESA = " & intCodEmpresaOpcaoMarcada
			sql = sql & " and 	Cod_Turma = " & strCodTurmaAnterior
			cnn.execute sql
			GravarLog sql
				
			'----------------------
			
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
			
			intCodEmp			= intCodEmpresaOpcaoMarcada
			intCodDepartamento	= Session("CodDeptoUsuario")
			'intCodAluno			= intCodigo
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			
			codEmpresaOrigem 	= Trim(Request("txtCodEmpresa"))
			
			'atualiza ano letivo anterior
			sql = "update SCA_ALUNO_ANO_LETIVO set SITUACAO = 'T', cod_situacaoaluno=5, data_situacao=getdate(), datafastamento=getdate()" 'transferido
			sql = sql & " where COD_ALUNO = " & intCodAluno
			sql = sql & " and ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and COD_EMPRESA = " & cod_empresa_atual
			'response.write sql & "<hr>"
			cnn.execute sql
			
			
			strCod_situacaoaluno = "1"
			'gera linha ano letivo
			sql = "SET NoCount ON insert into SCA_ALUNO_ANO_LETIVO (COD_EMPRESA,COD_ALUNO,cod_situacaoaluno,DATAMATRICULA,DATAFASTAMENTO,ANO_LETIVO,SEMESTRE,SITUACAO,DATA_SITUACAO,LOGRADOURO,NUMERO_ENDERECO,COMP_ENDERECO,BAIRROALUNO,CIDADERESIDENCIA,UFRESIDENCIA,CEPRESIDENCIA,USUARIO_INCL,DATA_HORA_INCL) values ("
			sql = sql & "" & intCodEmpresaOpcaoMarcada & ","
			sql = sql & "" & intCodAluno & ","
			sql = sql & "" & strCod_situacaoaluno & ","
			sql = sql & "'" & strDatamatricula & "',"
			sql = sql & "null,"
			sql = sql & "" & strAnoLetivo & ","
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
			sql = sql & ";SELECT @@IDENTITY "
			'response.write sql & "<hr>"
			Set rs = cnn.Execute(sql)
			intCodigoAnoLetivo = rs(0)
			rs.close
			
			
			strCod_situacaoalunoAtivo = 1
			
			'GRAVA NO CONTROLE SITUACAO ALUNO
			sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO,USUARIO_INCL) VALUES ("
			sql = sql & "" & intCodEmpresaOpcaoMarcada & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & strCod_situacaoalunoAtivo & "," 
			sql = sql & "'"&formataDataBD(date)& " " &time& "','transferencia_gerenciamento_cod.asp linha 449')" 			
			cnn.execute sql
			GravarLog sql
			
			'busca a unidade de ultima movimentação do aluno
			sql = "select top 1 COD_EMPRESA"
			sql = sql & " from SCA_ALUNO_TURMA"
			sql = sql & " where COD_ALUNO = " & intCodAluno
			sql = sql & " AND COD_EMPRESA <> " & intCodEmpresaOpcaoMarcada
			sql = sql & " order by codigo desc"
			rs.open sql, cnn
			if not rs.eof then
				intCodEmpresaUltimaMovimentacao = rs("cod_empresa")
			end if 
			rs.close
			
			if intCodEmpresaUltimaMovimentacao = "" then intCodEmpresaUltimaMovimentacao = 0
			'busca historico escolar
			sql = "select *"
			sql = sql & " from SCA_HISTORICO_ESCOLAR"
			sql = sql & " where cod_aluno=" & intCodAluno
			sql = sql & " and cod_empresa = "& intCodEmpresaUltimaMovimentacao
			'response.write sql & "<hr>"
			'if session("usuarioWeb") = "SERGIO" THEN
				RESPONSE.WRITE sql & "<hr>"
			'end if	
			vetHist = null
			rs.open sql, cnn
			if not rs.eof then
				vetHist = rs.getRows
			end if
			rs.close
			
			if isArray(vetHist) then
				controle = 0
				for j=0 to ubound(vetHist,2)
					codigo_historico= vetHist(0,j) 
					cod_aluno  		= vetHist(1,j) 
					cod_empresa  	= intCodEmpresaOpcaoMarcada
					ano_letivo  	= vetHist(3,j) 
					semestre  		= vetHist(4,j) 
					escola  		= vetHist(5,j) 
					cidade  		= vetHist(6,j) 
					uf  			= vetHist(7,j) 
					curso  			= vetHist(8,j) 
					serie  			= vetHist(9,j) 
					Cod_Curso  		= vetHist(10,j) 
					Cod_Periodo  	= vetHist(11,j) 
					observacao  	= vetHist(12,j) 
					mostrar_historico_rel  	= vetHist(13,j) 
					ch_total  		= vetHist(14,j) 
					
					sql = "SET NoCount ON insert into SCA_HISTORICO_ESCOLAR (cod_aluno,cod_empresa,ano_letivo,semestre,escola,cidade,uf,curso,serie,Cod_Curso,Cod_Periodo,observacao,mostrar_historico_rel,ch_total) values ("
					sql = sql & "" & cod_aluno & ","
					sql = sql & "" & cod_empresa & ","
					sql = sql & "" & ano_letivo & ","
					sql = sql & "" & semestre & ","
					sql = sql & "'" & escola & "',"
					sql = sql & "'" & cidade & "',"
					sql = sql & "" & uf & ","
					sql = sql & "'" & curso & "',"
					sql = sql & "'" & serie & "',"
					sql = sql & "" & Cod_Curso & ","
					sql = sql & "" & Cod_Periodo & ","
					sql = sql & "'" & observacao & "',"
					sql = sql & "'" & mostrar_historico_rel & "',"
					IF TRIM(ch_total) = "" OR ISNULL(ch_total) THEN
						sql = sql & "NULL)"
					ELSE
						sql = sql & "" & ch_total & ")"
					END IF
					sql = sql & ";SELECT @@IDENTITY "
					'if session("usuarioWeb") = "SERGIO" THEN
					'	RESPONSE.WRITE sql & "<hr>"
					'end if
					Set rs = cnn.Execute(sql)
					intCodigoHistoricoNovo = rs(0)
					rs.close
					
					
					sql = "insert SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar,ano_letivo,cod_curso,cod_periodo,semestre,cod_disciplina,cod_turma,cod_gradecurriculardisciplina"
					sql = sql & ",nota01,falta01,nota02,falta02,nota03,falta03,nota04,falta04,nota05,falta05,nota06,falta06,nota07,falta07,nota08,falta08,nota09,falta09,nota10,falta10,nota11,falta11"
					sql = sql & ",nota12,falta12,nota13,falta13,nota14,falta14,nota15,falta15,media,carga_horaria,situacao,observacao,mostraNota)"
					sql = sql & "SELECT " & intCodigoHistoricoNovo & ",ano_letivo,cod_curso,cod_periodo,semestre,cod_disciplina,cod_turma,cod_gradecurriculardisciplina"
					sql = sql & ",nota01,falta01,nota02,falta02,nota03,falta03,nota04,falta04,nota05,falta05,nota06,falta06,nota07,falta07,nota08,falta08,nota09,falta09,nota10,falta10,nota11,falta11"
					sql = sql & ",nota12,falta12,nota13,falta13,nota14,falta14,nota15,falta15,media,carga_horaria,situacao,observacao,mostraNota FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					sql = sql & "  WHERE cod_historico_escolar = " & codigo_historico
					'if session("usuarioWeb") = "SERGIO" THEN
					'	RESPONSE.WRITE sql & "<hr>"
					'end if
					cnn.Execute(sql)
					
					sql = "insert [SCA_HISTORICO_OBSERVACOES] (Cod_empresa,ano,semestre,cod_curso,cod_turma,cod_aluno,observacoes)"
					sql = sql & " select " & cod_empresa & ",ano,semestre,cod_curso,cod_turma,cod_aluno,observacoes"
					sql = sql & " from [SCA_HISTORICO_OBSERVACOES]"
					sql = sql & " where cod_aluno = " & cod_aluno
					'if session("usuarioWeb") = "SERGIO" THEN
						'RESPONSE.WRITE sql & "<hr>"
					'end if
					cnn.Execute(sql)
				next
			end if
			
			
			'INSERINDO HISTORICO DE SITUACAO ATIVANDO O ALUNO
			sql = "insert into SCA_OCORRENCIA (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL, TIPO_OCORRENCIA, INCLUSAO) "
			sql = sql & " select COD_EMPRESA,COD_ALUNO,ANO_LETIVO,SEMESTRE,DATAOCORRENCIA,OCORRENCIA,USUARIO_INCL,TIPO_OCORRENCIA,INCLUSAO"
			sql = sql & " from SCA_OCORRENCIA"
			sql = sql & " where TIPO_OCORRENCIA in ('A','D')"
			sql = sql & " and INCLUSAO = 'USUARIO'"
			sql = sql & " and COD_ALUNO = " & intCodAluno
			cnn.execute sql
			GravarLog sql
			
			
			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " WHERE	T.COD_TURMA = " & intCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & intCodEmpresaOpcaoMarcada
			sql = sql & " AND	G.SITUACAO = 'A'"'GRADE ATIVA
			rs.open sql, cnn,3,3
			if not RS.EOF then
				while not rs.eof
					sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA,  COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, COD_DISCIPLINA, SITUACAO) VALUES ("
					sql = sql & "" & intCodEmpresaOpcaoMarcada & "," 
					sql = sql & "" & intCodAluno & "," 
					sql = sql & "" & intCodTurma & "," 
					sql = sql & "" & intCodTurma & "," 
					sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
					sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
					sql = sql & "" & rs("COD_DISCIPLINA") & "," 
					sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
					
					cnn.execute sql

					rs.movenext
				wend
			end if
			rs.close		
			
			intCodSituacaoAlunoTransferido = 5
			
			'Verifico se existe histórico de situações para o aluno
			sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & cod_empresa_atual
			sql = sql & " AND COD_ALUNO = " & intCodAluno
			sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND SEMESTRE = " & strSemestre
			rs.open sql, cnn
			if rs.eof = false then
			   existeSituacao = "OK"
			else
			   existeSituacao = "NO"
			end if
			rs.close	
		
			if existeSituacao = "OK" then
				'ATUALIZO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
				sql = "UPDATE SCA_SITUACAO_ACADEMICA_ALUNO "
				sql = sql & " SET COD_SITUACAOALUNO = " & intCodSituacaoAlunoTransferido & ", DATA_SITUACAO = '" & FORMATADATABD(DATE) & "'"
				sql = sql & " where COD_EMPRESA = " & cod_empresa_atual
				sql = sql & " and 	COD_ALUNO = " & intCodAluno
				sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
				sql = sql & " and 	SEMESTRE = " & strSemestre
				
				cnn.execute sql
				GravarLog sql
			else   
				'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
				sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
				sql = sql & "" & cod_empresa_atual & ","
				sql = sql & "" & strAnoLetivo & "," 
				sql = sql & "" & strSemestre & "," 
				sql = sql & "" & intCodAluno & "," 
				sql = sql & "" & intCodTurmaAnterior & "," 
				sql = sql & "" & intCodSituacaoAlunoTransferido & "," 
				sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
				
				cnn.execute sql
				GravarLog sql
			end if	
			
			sql = "update SCA_CONTROLE_SITUACAO_ALUNO set COD_SITUACAOALUNO=5, USUARIO_INCL='transferencia_gerenciamento_cod.asp linha 434 update'" 'transferido
			sql = sql & " where COD_ALUNO = " & intCodAluno
			sql = sql & " and ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and COD_EMPRESA = " & cod_empresa_atual
			cnn.execute sql
			
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
		
			intCodEmp			= cod_empresa_atual
			intCodDepartamento	= Session("CodDeptoUsuario")
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= trim(session("usuarioWeb"))
			strDataValidade		= ""
			strOcorrencia		= "Aluno foi transferido para outra unidade"
			%>
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
			<%	
			
			'TROCA SITUACAO DA TRANSFERENCIA
			sql = "UPDATE MAT_TRANSFERENCIA SET cod_empresa_transferencia = " & intCodEmpresaOpcaoMarcada
			sql = sql & " ,turno_transferencia = '" & strTurnoOpcaoMarcada & "'"
			sql = sql & " ,periodo_transferencia = '" & strPeriodoOpcaoMarcada & "'"
			sql = sql & " ,cod_aluno_transferencia = '" & intCodigoAlunoNovo & "'"
			sql = sql & " ,matricula_transferencia = '" & strMatricula & "'"
			sql = sql & " WHERE codigo = " & cod_transferencia
			sql = sql & " and cod_aluno = " & intCodAluno
			cnn.execute sql
			GravarLog sql
			
			'TROCA SITUACAO DA TRANSFERENCIA
			sql = "UPDATE mat_transferencia_irmao_escola SET cod_empresa_transferencia = " & intCodEmpresaOpcaoMarcada
			sql = sql & " ,turno_transferencia = '" & strTurnoOpcaoMarcada & "'"
			sql = sql & " ,periodo_transferencia = '" & strPeriodoOpcaoMarcada & "'"
			sql = sql & " ,cod_aluno_transferencia = '" & intCodigoAlunoNovo & "'"
			sql = sql & " ,matricula_transferencia = '" & strMatricula & "'"
			sql = sql & " WHERE cod_transferencia = " & cod_transferencia
			sql = sql & " and cod_aluno = " & intCodAluno
			cnn.execute sql
			GravarLog sql
			
			'gerar tabela para caso precise cancelar a transferencia
			
		next
		
		'TROCA SITUACAO DA TRANSFERENCIA
		sql = "UPDATE MAT_TRANSFERENCIA SET SITUACAO = 'F'" 'finalizada
		sql = sql & " ,usuario_situacao = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " ,data_situacao = getdate()"
		sql = sql & " WHERE codigo = " & cod_transferencia
		cnn.execute sql
		GravarLog sql
		
		
		'TROCA SITUACAO DA TRANSFERENCIA
		sql = "UPDATE SCA_TURMA SET VagasMatriculasUtilizadas = VagasMatriculasUtilizadas + 1"
		sql = sql & " WHERE cod_turma = " & intCodTurma
		cnn.execute sql
		GravarLog sql
		cnn.CommitTrans
		%>
		<script>
			alert("Transferência CONCLUIDA com sucesso!");
			window.location="transferencia_gerenciamento_con.asp";
		</script>
		<%
	elseif acao = "C" then
		
		'TROCA SITUACAO DA TRANSFERENCIA
		sql = "UPDATE MAT_TRANSFERENCIA SET SITUACAO = 'C'" 'finalizada
		sql = sql & " ,usuario_situacao = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " ,data_situacao = getdate()"
		sql = sql & " WHERE codigo = " & cod_transferencia
		cnn.execute sql
		GravarLog sql
		
		%>
		<script>
			alert("Transferência CANCELADA com sucesso!");
			window.location="transferencia_gerenciamento_con.asp";
		</script>
		<%
	end if
	%>