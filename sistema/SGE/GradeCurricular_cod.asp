	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Situação
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	paginaRetorno			= "Situacao_cad.asp"
	strAcao 				= Request.QueryString("acao")
	
	intCodEmpOrigem			= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodPeriodo			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno					= Trim(Request.Form("txtAno"))

	sql = "SELECT P.Sequencia, C.Descricao as NomeCurso, P.descricao as Periodo "
	sql = sql & " FROM SCA_PERIODO P "
	sql = sql & " INNER	 JOIN SCA_CURSO C ON  C.Cod_curso = P.Cod_Curso "
	sql = sql & " where p.Cod_empresa = " & intCodEmpOrigem
	sql = sql & " and P.Cod_periodo = " & intCodPeriodo	
	rs.open sql, cnn
	if not RS.EOF then
	   intnovaSequencia						= rs("Sequencia")
	   strnovoNomecursoCurso				= rs("NomeCurso")
	else
		rs.close
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: Não Existem Informações Consistentes para replicar essa grade, Verifique seu cadastro de Curso/Período.");
			window.history.back();
		</script>
		<%
		response.End()
	end if
	rs.close

	'*****************************************************************
	unidades = trim(request.Form("chkEmpresa"))
				
	'todas unidades
	vetCodTodasEmpresa	= split(unidades,",")
	on error resume next

	if strAcao = "I" then  
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
		intCodEmpDestino = trim(vetCodTodasEmpresa(i))
		bolExiste = false
		if intCodEmpOrigem <> intCodEmpDestino then ' teste
		
			' Verifico se a empresa a ser incluída possui periodo
			sql = "SELECT COD_PERIODO FROM SCA_PERIODO P "
			sql = sql & " INNER JOIN SCA_CURSO C ON  C.Cod_curso = P.Cod_Curso "
			sql = sql & " where p.Cod_empresa = " & intCodEmpDestino 
			sql = sql & " and P.sequencia = " & intnovaSequencia
			sql = sql & " and C.DESCRICAO = '" & strnovoNomecursoCurso & "'"
			rs.open sql, cnn
			if not rs.EOF then
				intnovoPeriodo					= rs("COD_PERIODO")
			else
				rs.close
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: Período inexistente, impossível incluir grade para empresa n. <%=intCodEmp & "/ Período:" & intnovaSequencia%>");
					window.history.back();
				</script>
				<%
				response.End()
			end if
			rs.close
		
		
			sql = "select GC.AnoReferencia, GC.SemestreReferencia, P.Sequencia, C.Descricao as NomeCurso, P.descricao as Periodo, GC.Cod_GradeCurricular "
			sql = sql & " from SCA_GRADECURRICULAR GC "
			sql = sql & " INNER JOIN SCA_PERIODO  P ON P.Cod_Periodo = GC.Cod_Periodo "
			sql = sql & " INNER JOIN SCA_CURSO C ON  C.Cod_curso = P.Cod_Curso "
			sql = sql & " where GC.Cod_empresa = " & intCodEmpDestino
			sql = sql & " and GC.AnoReferencia = " & intAno
			sql = sql & " and GC.SemestreReferencia = " & intSemestre
			sql = sql & " and P.sequencia = " & intnovaSequencia
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
				intNovaGradeCurricular = rs("Cod_GradeCurricular")
			end if
			rs.close
			
			if bolExiste=false then
			
				strMensagem = "Grade replicada para a(s) unidade(s) com sucesso..."
				sql = "insert SCA_GRADECURRICULAR"
				sql = sql & " select "
				sql = sql & " 	(select max(Cod_GradeCurricular)+1 from SCA_GRADECURRICULAR) as cod_grade_nova,"
				sql = sql & " 	"&intCodEmpDestino&" as Cod_Empresa_destino,"
				sql = sql & " 	(SELECT top 1 COD_PERIODO FROM SCA_PERIODO P INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso where p.Cod_empresa = "&intCodEmpDestino&" and P.sequencia = "&intnovaSequencia&" and C.DESCRICAO = '"&strnovoNomecursoCurso&"'  COLLATE SQL_Latin1_General_CP1_CI_AI ) as cod_periodo,"
				sql = sql & " 	CodCursoResolucao,"
				sql = sql & " 	AnoReferencia,"
				sql = sql & " 	SemestreReferencia,"
				sql = sql & " 	Situacao,"
				sql = sql & " 	dataInicioVigencia,"
				sql = sql & " 	dataFimVigencia,"
				sql = sql & " 	Cod_Agrupamento "
				sql = sql & " from SCA_GRADECURRICULAR"
				sql = sql & " where Cod_Empresa = " & intCodEmpOrigem
				sql = sql & " and Cod_GradeCurricular = " & intCodigo
				
				response.Write(sql)
				response.End()
				
				cnn.execute sql
				
				sql = "insert SCA_GRADECURRICULARDISCIPLINA"
				sql = sql & " select "
				sql = sql & " 	(select max(Cod_GradeCurricular) from SCA_GRADECURRICULAR) as cod_grade_nova,"
				sql = sql & " 	(select Cod_Disciplina from sca_disciplina where Desc_Disciplina = _d.Desc_Disciplina and Cod_Empresa = "&intCodEmpDestino&") as cod_disciplina_destino,"
				sql = sql & " 	_gd.Ch_Semanal,"
				sql = sql & " 	_gd.Ch_Mensal,"
				sql = sql & " 	_gd.Ch_Anual,"
				sql = sql & " 	_gd.Ch_Pratica,"
				sql = sql & " 	_gd.Ch_Teorica,"
				sql = sql & " 	_gd.Cod_GradeCurricularDisciplina_Equivalente,"
				sql = sql & " 	_gd.Cod_GradeCurricular_Equivalente,"
				sql = sql & " 	_gd.Cod_Disciplina_Equivalente"
				sql = sql & " from SCA_GRADECURRICULARDISCIPLINA _gd"
				sql = sql & " inner join SCA_DISCIPLINA _d on _d.Cod_Disciplina = _gd.Cod_Disciplina"
				sql = sql & " where Cod_GradeCurricular = "& intCodigo
				sql = sql & " and _d.Cod_Empresa = " & intCodEmpOrigem
				
				response.Write(sql)
				response.End()
				
				cnn.execute sql
			end if
		end if
		next
			
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='GradeCurricular_cad.asp';
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