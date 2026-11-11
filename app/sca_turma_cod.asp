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
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	
	intCodigo 				= Trim(Request.Form("txtCodigo"))
	intCapacidade 			= Trim(Request.Form("txtCapacidade"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	
	IF trim(intSemestre) = "A" THEN intSemestre = "3"'ANUAL
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strNomeTurma 			= replace(Trim(Request.Form("txtNomeTurma")),"'","")
	strTurmaAluno 			= replace(Trim(Request.Form("txtTurmaAluno")),"'","")
	strPeriodo 				= replace(Trim(Request.Form("strPeriodo")),"'","")
	
	strTurmaAluno			= strPeriodo & " " & strTurmaAluno
	
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intSemestreCriacao		= Trim(Request.Form("cmbSemestreCriacao"))

	intAnoLetivo 					= Trim(Request.Form("txtAnoLetivo"))
	intAnoSemestre					= intAno & intSemestre
	intAnoSemestreSession			= Session("strAnoLetivo") & Session("strSemestre")
	intCodFichaDescritiva			= Trim(Request.form("cmbFichaDescritiva"))
	strSimouNaoIntegralizacao		= Trim(Request.form("cmbSimouNaoIntegralizacao"))
	strDesvincularCriterioAvaliacao	= Trim(Request.form("cmbDesvincularCriterioAvaliacao"))
	strSituacaoTurma				= Trim(Request.form("cmbSituacaoTurma"))
	strSituacaoTurmaAnterior		= Trim(Request.form("cmbSituacaoTurmaAnterior"))
	intVagasMatriculas				= Trim(Request.form("txtVagasMatriculas"))
	intVagasMatriculasUtilizadas	= Trim(Request.form("txtVagasMatriculasUtilizadas"))

	if intCodFichaDescritiva = "" then intCodFichaDescritiva = "0"
	if strSimouNaoIntegralizacao = "" then strSimouNaoIntegralizacao = "N"
	if strDesvincularCriterioAvaliacao = "" then strDesvincularCriterioAvaliacao = "N"
	if intVagasMatriculas = "" then intVagasMatriculas = "0"
	if intVagasMatriculasUtilizadas = "" then intVagasMatriculasUtilizadas = "0"
	
	if acao <> "E" then
	
		intCH_curso = 0
		sql = "select CH_exigida "
		sql = sql & " from SCA_CURSO"
		sql = sql & " where cod_curso = " & intCurso
		sql = sql & " and CH_exigida is not null"
		rs.open sql, cnn,3,3	
		if not rs.eof then
			intCH_curso = rs("CH_exigida")
		end if
		rs.close
		
		intCH_grade = 0
		sql = "select sum(SCA_GRADECURRICULARDISCIPLINA.ch_anual) as ch_total "
		sql = sql & " from SCA_GRADECURRICULARDISCIPLINA "
		sql = sql & " inner join SCA_GRADECURRICULAR on SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular"
		sql = sql & " and SCA_GRADECURRICULAR.situacao = 'A'"
		sql = sql & " inner join SCA_periodo on SCA_periodo.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo"
		sql = sql & " where SCA_periodo.Cod_curso =  " & intCurso
		rs.open sql, cnn,3,3
		if not rs.eof then
			intCH_grade = rs("ch_total")
		end if
		rs.close

		if isnull(intCH_curso) or intCH_curso=""  then intCH_curso = 0
		if isnull(intCH_grade) or intCH_curso="" then intCH_grade = 0

		if intCH_curso <> intCH_grade then
			%>
			<script>
				alert("ATENÇÃO: \nA carga horária total exigida no curso está diferente da grade de disciplinas.\n\n- Carga Horária do Curso: <%=intCH_curso%>\n- Carga Horária da Grade: <%=intCH_grade%>");
				
			</script>
			<%	
			'window.history.back();
			'response.End()	
		end if

		'REGRA ANO/SEMESTRE CRIAÇÃO NÃO PODE SER INFERIOR DA SESSION
		if cInt(intAnoSemestre) < Cint(intAnoSemestreSession) then
			'cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Ano/Semestre de criação não pode ser inferior ao ano ativo no sistema.");
			</script>
			<%
			'response.End()
		end if
	end if

	if acao="I" then

		sql = "select NomeTurma, Cod_Semestre, AnoLetivo"
		sql = sql & " from SCA_TURMA "
		sql = sql & " WHERE cod_empresa = " & intCodEmp
		sql = sql & " AND NomeTurma = '" & strNomeTurma & "'"
		sql = sql & " AND Cod_Semestre = " & intSemestre
		sql = sql & " AND AnoLetivo = " & intAnoLetivo
		rs.open sql, cnn,3,3
		if not rs.eof then
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: \nEssa turma já está cadastrada, verifique!");
				window.history.back();
			</script>
			<%	
			response.End()	
		end if
		rs.close
		
		sql = "SELECT Max(Cod_Turma) as MaiorCodigo" 
		sql = sql & " FROM SCA_TURMA"
		rs.open sql, cnn
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodTurma = intCodNovo
			else
				intCodTurma = 1	
			end if
		
		end if
		rs.close

		strMensagem = "Registro Salvo com sucesso..."
	
		sql = " Insert Into SCA_TURMA ( Cod_Empresa, Cod_GradeCurricular, Cod_Semestre, Cod_Turno, Cod_periodo, " 
		sql = sql & " NomeTurma, TurmaAluno, Sala, Ano, AnoLetivo, capacidade, Cod_SemestreCriacao, Cod_FichaDescritiva, DisponibilizaIntegralizacao, DesvincularCriterioAvaliacao, situacao, VagasMatriculas, VagasMatriculasUtilizadas)"
		sql = sql & " Values ("
		'sql = sql & "" & intCodTurma & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrade & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodTurno & ","
		sql = sql & "" & intCodPeriodo & ","
		sql = sql & "'" & strNomeTurma & "',"
		sql = sql & "'" & strTurmaAluno & "',"
		sql = sql & "" & strSala & ","
		sql = sql & "" & intAno & ","
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intCapacidade & ","
		sql = sql & "" & intSemestreCriacao & ","
		if	intCodFichaDescritiva = "0" then
			sql = sql & " Null,"
		else
			sql = sql & "" & intCodFichaDescritiva & ","
		end if
		sql = sql & "'" & strSimouNaoIntegralizacao & "',"
		sql = sql & "'" & strDesvincularCriterioAvaliacao & "',"
		sql = sql & "'" & strSituacaoTurma & "',"
		sql = sql & "" & intVagasMatriculas & ","
		sql = sql & "" & intVagasMatriculasUtilizadas & ")"
		cnn.execute sql
		if trim(request.ServerVariables("SERVER_NAME")) <> "www.smeduc.com.br" then
			GravarLog sql
		end if

		'*********************************************
		'verifica se a situação da turma foi incluida
		'*********************************************
		sql=" SELECT RAZAOSOCIAL FROM SEG_EMPRESA "
		sql=sql & " WHERE CODIGO = " & Session("CodEmpresa")  
		rs1.open sql, cnn
		if not rs1.eof then
		   unidadeEscolar       = rs1("RAZAOSOCIAL")
		end if
		rs1.close	

		sql = "SELECT SCA_CURSO.Desc_Abreviada AS curso, SCA_PERIODO.Descricao AS periodo"
		sql = sql & " FROM SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
		sql = sql & " WHERE SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo 
		sql = sql & " AND SCA_GRADECURRICULAR.Situacao = 'A'"
		rs.open sql, cnn
		if not rs.eof then
			grade = rs("curso") & " - " & rs("periodo")
		end if
		rs.close
		
		'Para envio da notificacao de devolucao ao professor
		strDe						= session("UsuarioWeb")
		'strPara                    = Valor recebido select colaborador
		if strSituacaoTurma = "A" then sit = "ATIVO"
		if strSituacaoTurma = "I" then sit = "INATIVO"
		
		strAssunto  				= unidadeEscolar & " -> Foi INCLUIDA uma nova turma"
		strRecado	 				= unidadeEscolar & " - " & strNomeTurma & " - " & grade
		strData			 			= formataDataBD(date)
		strHora			 			= time
		strStatus					= 1

		sql = "select distinct upper(a.ACES_USUA_CODG) as codigo_usuario"
		sql = sql & " from SEG_ACESSOS_USUARIO a"
		sql = sql & " inner join SEG_USUARIOS_EMPRESA e on e.CODIGO_SEG_USUARIOS_SISTEMA = a.ACES_USUA_CODG"
		sql = sql & " inner join SEG_USUARIOS_SISTEMA u ON u.USUA_CODG = e.CODIGO_SEG_USUARIOS_SISTEMA"
		sql = sql & " inner join SEG_EMPRESA ee on ee.codigo = e.cod_empresa"
		sql = sql & " where a.aces_perf_codg in (24)"
		sql = sql & " and ee.cod_grupo = " & Session("CodGrupo")
		sql = sql & " and u.usua_stat = 'A'"
		vetRecado = null
		rs.open sql, cnn
		if not rs.eof then
			vetRecado = rs.getRows
		end if
		rs.close
	
		if isArray(vetRecado) then
		
			for i=0 to ubound(vetRecado,2)

				strPara  	= vetRecado(0,i)
				
				sql = "Insert Into SEG_Recados(De, Para, Assunto, recado, data, hora, status, envio_sistema )"
				sql = sql & " Values ("
				sql = sql & "'" & strDe & "',"
				sql = sql & "'" & strPara & "',"
				sql = sql & "'" & strAssunto & "',"
				sql = sql & "'" & strRecado & "',"
				sql = sql & "'" & strData & "',"
				sql = sql & "'" & strHora & "',"
				sql = sql & "" & strStatus & ",'SRH')"
				cnn.execute sql
				GravarLog sql
				
			next		
		end if
			
				
	elseif acao="A" then
	     %>
		 <script>
			alert("ATENÇÃO: \nSomente será alterado o campo CAPACIDADE e GRADE CURRICULAR, \npara outras alterações excluir e cadastrar novamente.");
		</script>
		<%	

        GradeDiferente = false
		sql = "select Cod_GradeCurricular "
		sql = sql & " from sca_turma"
		sql = sql & " where Cod_Turma = "& intCodigo
		rs.open sql, cnn,3,3
		if not rs.eof then
			ComparaGrade = trim(rs("Cod_GradeCurricular"))
			if intCodGrade <> ComparaGrade then
			   GradeDiferente = true
			end if   
		end if
		rs.close

		if GradeDiferente = true then
			sql = "select codigo "
			sql = sql & " from sca_aluno_disciplina"
			sql = sql & " where Cod_Turma = "& intCodigo
			rs.open sql, cnn,3,3
			if not rs.eof then
				rs.close
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: \nEssa Grade não pode ser Altera, existe alunos vinculada a ela.");
					window.history.back();
				</script>
				<%	
				response.End()
			end if
			rs.close		
		end if
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_TURMA Set"
		
		if 	intCodFichaDescritiva = "0" then
			sql = sql & " Cod_FichaDescritiva = Null,"
		else
			sql = sql & " Cod_FichaDescritiva = " & intCodFichaDescritiva & ","
		end if
		sql = sql & " turmaAluno = '" & strTurmaAluno & "',"
		sql = sql & " Cod_periodo = " & intCodPeriodo & ","
		sql = sql & " Capacidade = " & intCapacidade & ","
		sql = sql & " Cod_GradeCurricular = " & intCodGrade & ","
		sql = sql & " DisponibilizaIntegralizacao = '" & strSimouNaoIntegralizacao & "',"
		sql = sql & " DesvincularCriterioAvaliacao = '" & strDesvincularCriterioAvaliacao & "',"
		sql = sql & " situacao = '" & strSituacaoTurma & "',"
		sql = sql & " VagasMatriculas = " & intVagasMatriculas & ","
		sql = sql & " VagasMatriculasUtilizadas = " & intVagasMatriculasUtilizadas
		sql = sql & " where Cod_Turma = " & intCodigo
		
		 if session("usuarioWeb") = "SERGIO" then
		 	response.write sql & "<hr>"
			response.end
		 end if
		cnn.execute sql
		GravarLog sql
		
		'*********************************************
		'verifica se a situação da turma foi alterada
		'*********************************************
		if trim(strSituacaoTurmaAnterior) <> trim(strSituacaoTurma) then 
			sql=" SELECT RAZAOSOCIAL FROM SEG_EMPRESA "
			sql=sql & " WHERE CODIGO = " & Session("CodEmpresa")  
			rs1.open sql, cnn
			if not rs1.eof then
			   unidadeEscolar       = rs1("RAZAOSOCIAL")
			end if
			rs1.close	

			sql = "SELECT SCA_CURSO.Desc_Abreviada AS curso, SCA_PERIODO.Descricao AS periodo"
			sql = sql & " FROM SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
			sql = sql & " WHERE SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo 
			sql = sql & " AND SCA_GRADECURRICULAR.Situacao = 'A'"
			rs.open sql, cnn
			if not rs.eof then
				grade = rs("curso") & " - " & rs("periodo")
			end if
			rs.close
			
			'Para envio da notificacao de devolucao ao professor
			strDe						= session("UsuarioWeb")
			'strPara                    = Valor recebido select colaborador
			if strSituacaoTurma = "A" then sit = "ATIVO"
			if strSituacaoTurma = "I" then sit = "INATIVO"
			
			strAssunto  				= unidadeEscolar & " -> Foi ALTERADA a situação da turma para " & sit
			strRecado	 				= unidadeEscolar & " - " & strNomeTurma & " - " & grade
			strData			 			= formataDataBD(date)
			strHora			 			= time
			strStatus					= 1

			sql = "select distinct upper(a.ACES_USUA_CODG) as codigo_usuario"
			sql = sql & " from SEG_ACESSOS_USUARIO a"
			sql = sql & " inner join SEG_USUARIOS_EMPRESA e on e.CODIGO_SEG_USUARIOS_SISTEMA = a.ACES_USUA_CODG"
			sql = sql & " inner join SEG_USUARIOS_SISTEMA u ON u.USUA_CODG = e.CODIGO_SEG_USUARIOS_SISTEMA"
			sql = sql & " inner join SEG_EMPRESA ee on ee.codigo = e.cod_empresa"
			sql = sql & " where a.aces_perf_codg in (24)"
			sql = sql & " and ee.cod_grupo = " & Session("CodGrupo")
			sql = sql & " and u.usua_stat = 'A'"
			vetRecado = null
			rs.open sql, cnn
			if not rs.eof then
				vetRecado = rs.getRows
			end if
			rs.close
		
			if isArray(vetRecado) then
			
				for i=0 to ubound(vetRecado,2)

					strPara  	= vetRecado(0,i)
					
					sql = "Insert Into SEG_Recados(De, Para, Assunto, recado, data, hora, status, envio_sistema )"
					sql = sql & " Values ("
					sql = sql & "'" & strDe & "',"
					sql = sql & "'" & strPara & "',"
					sql = sql & "'" & strAssunto & "',"
					sql = sql & "'" & strRecado & "',"
					sql = sql & "'" & strData & "',"
					sql = sql & "'" & strHora & "',"
					sql = sql & "" & strStatus & ",'SRH')"
					cnn.execute sql
					GravarLog sql
					
				next		
			end if
			
		end if	
		
	else
	
		strAlunos = "" 
		contAlunos = 0
		mostraMensagem = ""
		sql = " Select SCA_Aluno.MATRICULA, SCA_Aluno.NOMEALUNO"
		sql = sql & " from sca_aluno_turma"
		sql = sql & " INNER JOIN SCA_Aluno ON SCA_Aluno.CODIGO = sca_aluno_turma.COD_ALUNO "
		sql = sql & " where sca_aluno_turma.situacao = 'A' and sca_aluno_turma.Cod_Turma = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				strAlunos = strAlunos & rs("MATRICULA") & " - " & rs("NOMEALUNO") & "\n" 
				mostraMensagem = "S"
				contAlunos = contAlunos + 1
				
				rs.movenext
			wend
		end if
		rs.close
		if mostraMensagem = "S"		 then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: \nEssa TURMA não pode ser excluida, existe(m) <%=contAlunos%> aluno(s) vinculada a ela.\n<%=strAlunos%>");
				window.history.back();
			</script>
			<%	
			response.End()
		end if
		
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SCA_HISTORICO_ESCOLAR_DISCIPLINA "
		sql = sql & " where Cod_Turma = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SCA_HORARIO_AULA "
		sql = sql & " where Cod_Turma = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SCA_SITUACAO_ACADEMICA_ALUNO "
		sql = sql & " where Cod_Turma = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from sca_aluno_turma "
		sql = sql & " where Cod_Turma = " & intCodigo
		cnn.execute sql
		GravarLog sql

		
		sql = "Delete from sca_notas_faltas "
		sql = sql & " where cod_aluno_disciplina  in ("
		sql = sql & " 							select codigo from sca_aluno_disciplina "
		sql = sql & " 							where Cod_Turma = " & intCodigo
		sql = sql & ")"
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete from sca_aluno_disciplina "
		sql = sql & " where Cod_Turma = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from sca_aluno_disciplina "
		sql = sql & " where Cod_Turma_Remanejamento = " & intCodigo
		cnn.execute sql
		GravarLog sql

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_ALUNO_RENOVACAO "
		sql = sql & " where Cod_Turma = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_TURMA "
		sql = sql & " where Cod_Turma = " & intCodigo
		
		cnn.execute sql
		GravarLog sql

		'*********************************************
		'verifica se a situação da turma foi incluida
		'*********************************************
		sql=" SELECT RAZAOSOCIAL FROM SEG_EMPRESA "
		sql=sql & " WHERE CODIGO = " & Session("CodEmpresa")  
		rs1.open sql, cnn
		if not rs1.eof then
		   unidadeEscolar       = rs1("RAZAOSOCIAL")
		end if
		rs1.close	

		sql = "SELECT SCA_CURSO.Desc_Abreviada AS curso, SCA_PERIODO.Descricao AS periodo"
		sql = sql & " FROM SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso"
		sql = sql & " WHERE SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo 
		sql = sql & " AND SCA_GRADECURRICULAR.Situacao = 'A'"
		rs.open sql, cnn
		if not rs.eof then
			grade = rs("curso") & " - " & rs("periodo")
		end if
		rs.close
		
		'Para envio da notificacao de devolucao ao professor
		strDe						= session("UsuarioWeb")
		'strPara                    = Valor recebido select colaborador
		if strSituacaoTurma = "A" then sit = "ATIVO"
		if strSituacaoTurma = "I" then sit = "INATIVO"
		
		strAssunto  				= unidadeEscolar & " -> Turma EXCLUIDA"
		strRecado	 				= unidadeEscolar & " - " & strNomeTurma & " - " & grade
		strData			 			= formataDataBD(date)
		strHora			 			= time
		strStatus					= 1

		sql = "select distinct upper(a.ACES_USUA_CODG) as codigo_usuario"
		sql = sql & " from SEG_ACESSOS_USUARIO a"
		sql = sql & " inner join SEG_USUARIOS_EMPRESA e on e.CODIGO_SEG_USUARIOS_SISTEMA = a.ACES_USUA_CODG"
		sql = sql & " inner join SEG_USUARIOS_SISTEMA u ON u.USUA_CODG = e.CODIGO_SEG_USUARIOS_SISTEMA"
		sql = sql & " inner join SEG_EMPRESA ee on ee.codigo = e.cod_empresa"
		sql = sql & " where a.aces_perf_codg in (24)"
		sql = sql & " and ee.cod_grupo = " & Session("CodGrupo")
		sql = sql & " and u.usua_stat = 'A'"
		vetRecado = null
		rs.open sql, cnn
		if not rs.eof then
			vetRecado = rs.getRows
		end if
		rs.close
	
		if isArray(vetRecado) then
		
			for i=0 to ubound(vetRecado,2)

				strPara  	= vetRecado(0,i)
				
				sql = "Insert Into SEG_Recados(De, Para, Assunto, recado, data, hora, status, envio_sistema )"
				sql = sql & " Values ("
				sql = sql & "'" & strDe & "',"
				sql = sql & "'" & strPara & "',"
				sql = sql & "'" & strAssunto & "',"
				sql = sql & "'" & strRecado & "',"
				sql = sql & "'" & strData & "',"
				sql = sql & "'" & strHora & "',"
				sql = sql & "" & strStatus & ",'SRH')"
				cnn.execute sql
				GravarLog sql
				
			next		
		end if	
	end if
	
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_turma.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>