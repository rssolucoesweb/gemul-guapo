<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/08/2007
	::	Desenvolvedores...: Sergio Borges- sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Turma
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"

	strAcao 				= Trim(Request("acao2"))
	intCodEmpresaUsuario 	= Trim(Request("cmdEmpresaUsuario"))
	strAnoLetivo 			= Trim(Request("txtAnoLetivo")) 
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlano				= Trim(Request.Form("cmbPlano"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	
	if intSemestre = "" then 	intSemestre  = session("strSemestre")	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo") + 1
		
	cont =0
	if intSemestre = "" then intSemestre = 0
	if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = 0


	sql = "SELECT T.Cod_Turma, T.Cod_GradeCurricular, T.Cod_Semestre, T.Cod_Turno, sca_Turno.Desc_Turno, isnull(T.Capacidade,'0') as Capacidade,"
	sql = sql & " T.Cod_PlanoPagamento, T.Cod_ContaCorrente, T.nomeTurma, T.Sala, T.Ano, T.AnoLetivo, T.TurmaAluno, isnull(T.VagasMatriculas,0) as VagasMatriculas, isnull(T.VagasMatriculasUtilizadas,0) as VagasMatriculasUtilizadas, "
	sql = sql & " isnull(T.VagasReservadas,0) as VagasReservadas" 
	sql = sql & " FROM SCA_TURMA T"
	sql = sql & " Inner join sca_Turno on sca_Turno.Cod_Turno = T.Cod_Turno "
	sql = sql & " where T.Cod_empresa = " & intCodEmpresaUsuario		
	sql = sql & " and T.AnoLetivo = " & intAnoLetivo
	if intSemestre <> "0" then
		sql = sql & " and  T.Cod_Semestre = " & intSemestre
	end if
	sql = sql & " Order by AnoLetivo, Cod_Turno, Nometurma"
	rs.open sql, cnn
					
	if rs.eof = false then
		while not rs.eof

			if trim(strAcao) = "PERIODICA" then
				strMensagem = "Vagas Atualizadas conforme turmas do ano corrente."

				intOcupada = 0
				sql = "SELECT  DISTINCT SCA_ALUNO.CODIGO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
				sql = sql & " where SCA_TURMA.cod_empresa = " & intCodEmpresaUsuario
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and   SCA_TURMA.COD_TURMA = " & trim(rs("Cod_Turma"))  
				sql = sql & " AND (SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO' OR SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') "
				RSAUX.OPEN SQL, CNN, 3, 1
				IF NOT RSAUX.EOF THEN
					intOcupada = RSAUX.RECORDCOUNT
				END IF
				RSAUX.CLOSE
	
				sql = "Update SCA_TURMA Set "
				sql = sql & " VagasMatriculasUtilizadas = " & intOcupada 
				sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
				cnn.execute sql

				'sql = "Update SCA_TURMA Set "
				'sql = sql & " VagasReservadas = 0 "
				'sql = sql & " VagasReservadas = Capacidade - VagasMatriculasUtilizadas "
				'sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
				'cnn.execute sql
				
				'sql = "Update SCA_TURMA Set "
				'sql = sql & " VagasMatriculas = isnull(Capacidade,'0'),"
				'sql = sql & " VagasMatriculaInicial = (case when isnull(VagasMatriculaInicial,'0')= '0' then isnull(Capacidade,'0') - isnull(VagasMatriculasUtilizadas,'0') - isnull(VagasReservadas,'0') else VagasMatriculaInicial end ) " 
				'sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
				'cnn.execute sql

				sql = "Update SCA_TURMA Set "
				sql = sql & " VagasMatriculas = isnull(Capacidade,'0')"
				'sql = sql & " VagasMatriculaInicial = (case when isnull(VagasMatriculaInicial,'0')= '0' then isnull(Capacidade,'0') - isnull(VagasMatriculasUtilizadas,'0') - isnull(VagasReservadas,'0') else VagasMatriculaInicial end ) " 
				sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
				cnn.execute sql
				
			elseif strAcao = "INICIAL" then
				strMensagem = "Vagas Atualizadas conforme turmas do ano anterior."
				TurmasVagas = ""
				Vagas = rs("VagasMatriculas")
				AnoVagas = rs("AnoLetivo") - 1
				
				if mid(rs("NomeTurma"),3,1) <> "1" then
					TurmasVagas = left(rs("NomeTurma"),2) & (mid(rs("NomeTurma"),3,1)-1) & right(rs("NomeTurma"),6)
				end if	
				
				if trim(TurmasVagas) <> "" then
					intOcupada = 0
					sql = "SELECT  DISTINCT SCA_ALUNO.CODIGO"
					sql = sql & " FROM SCA_ALUNO_TURMA "
					sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
					SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO and SCA_SITUACAOALUNO.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
					sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
					sql = sql & " where SCA_TURMA.cod_empresa = " & intCodEmpresaUsuario	
					sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & AnoVagas
					sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
					sql = sql & " and   SCA_TURMA.NOMETURMA = '" & trim(TurmasVagas) & "'"
					SQL = SQL & " and   SCA_SITUACAOALUNO.Desc_SituacaoAluno IN ('ATIVO')"
					RSAUX.OPEN SQL, CNN, 3, 1
					IF NOT RSAUX.EOF THEN
						intOcupada = RSAUX.RECORDCOUNT
					END IF
					RSAUX.CLOSE
					sql = "Update SCA_TURMA Set "
					sql = sql & " VagasMatriculasUtilizadas = " & intOcupada
					sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
					cnn.execute sql

					'sql = "Update SCA_TURMA Set "
					'sql = sql & " VagasReservadas = 0 "
					'sql = sql & " VagasReservadas = Capacidade - VagasMatriculasUtilizadas "
					'sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
					'cnn.execute sql
						
					sql = "Update SCA_TURMA Set "
					sql = sql & " VagasMatriculas = Capacidade, "
					sql = sql & " VagasMatriculaInicial = (case when isnull(VagasMatriculaInicial,'0')= '0'  then Capacidade - VagasMatriculasUtilizadas - VagasReservadas else VagasMatriculaInicial end ) " 
					sql = sql & " Where COD_TURMA = " & trim(rs("Cod_Turma")) 
					cnn.execute sql
				end if	 
			end if	
			rs.movenext
		wend
	end if
	rs.close
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TurmasVagasMatricula_cad.asp?txtAnoLetivo=<%=strAnoLetivo%>&cmdEmpresaUsuario=<%=intCodEmpresaUsuario%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>			  