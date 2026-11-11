	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
    
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmpresaUsuario 	= Trim(Request.Form("cmdEmpresaUsuario"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	
	sql = "SELECT T.Cod_Turma, T.Cod_GradeCurricular, T.Cod_Semestre, T.Cod_Turno, sca_Turno.Desc_Turno, isnull(T.Capacidade,'0') as Capacidade, "
	sql = sql & " T.Cod_PlanoPagamento, T.Cod_ContaCorrente, T.nomeTurma, T.Sala, T.Ano, T.AnoLetivo, T.TurmaAluno, T.VagasMatriculas, T.VagasMatriculasUtilizadas"
	sql = sql & " FROM SCA_TURMA T"
	sql = sql & " Inner join sca_Turno on sca_Turno.Cod_Turno = T.Cod_Turno "
	sql = sql & " where T.Cod_empresa = " & intCodEmpresaUsuario		
	sql = sql & " and T.AnoLetivo = " & strAnoLetivo
	
	if intSemestre <> "0" then
		sql = sql & " and  T.Cod_Semestre = " & intSemestre
	end if
	
	sql = sql & " Order by AnoLetivo, Cod_Turno, Nometurma"
	rs.open sql, cnn,3,3
	if not rs.eof then

		strMensagem = "Registro Alterado com sucesso..."

		while not rs.eof
			
			'intVagasMatriculas 	= Trim(Request.Form("txtVagasMatriculas_" & rs("Cod_Turma")))
			intVagasReservadas 	= Trim(Request.Form("txtVagasMatriculasReservadas_" & rs("Cod_Turma")))
			sql = "insert sca_turma_log "
			sql = sql & " select Cod_Turma, Cod_Empresa, cod_GradeCurricular, Cod_Turno, Cod_ContaCorrente, Cod_PlanoPagamento, Cod_Semestre, Cod_SemestreCriacao, Sala, Ano, AnoLetivo, TurmaAluno, NomeTurma, Capacidade, "
			sql = sql & " Cod_FichaDescritiva, DisponibilizaIntegralizacao, DesvincularCriterioAvaliacao, Situacao, VagasMatriculas, VagasMatriculasUtilizadas, 'antes', getdate() from sca_turma "
			sql = sql & " where Cod_turma = " & rs("Cod_Turma")
			sql = sql & " and Cod_empresa = " & intCodEmpresaUsuario		
			cnn.execute sql

			sql = "Update SCA_TURMA Set "
			'if 	intVagasMatriculas  = "" then
			'	sql = sql & "VagasMatriculas = NULL,"
			'else
			'	sql = sql & "VagasMatriculas = " & intVagasMatriculas & ","
			'end if	
			if 	intVagasReservadas  = "" then
				sql = sql & "VagasReservadas = NULL"
			else
				sql = sql & "VagasReservadas = " & intVagasReservadas & ""
			end if	
			sql = sql & " where Cod_Turma = " & trim(rs("Cod_Turma"))
			sql = sql & " and Cod_Empresa = " & intCodEmpresaUsuario
			cnn.execute sql
			GravarLog sql

			sql = "insert sca_turma_log "
			sql = sql & " select Cod_Turma, Cod_Empresa, cod_GradeCurricular, Cod_Turno, Cod_ContaCorrente, Cod_PlanoPagamento, Cod_Semestre, Cod_SemestreCriacao, Sala, Ano, AnoLetivo, TurmaAluno, NomeTurma, Capacidade, "
			sql = sql & " Cod_FichaDescritiva, DisponibilizaIntegralizacao, DesvincularCriterioAvaliacao, Situacao, VagasMatriculas, VagasMatriculasUtilizadas, '" &trim(Session("UsuarioWeb"))& "', getdate() from sca_turma "
			sql = sql & " where Cod_turma = " & rs("Cod_Turma")
			sql = sql & " and Cod_empresa = " & intCodEmpresaUsuario		
			cnn.execute sql

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