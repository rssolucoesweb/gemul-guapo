<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: troca situacao aluno
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	
	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")
		
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodAluno			= Trim(Request("txtCodAluno"))
	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))

	if Session("NivelPermissao") <> "A" then 
		%>
		<script>
			alert("ATENÇÃO: \nA equivalência só poderá ser gerada pelo Gestor de Processos.");
			window.history.back();
		</script>
		<%	
		response.End()
    end if
	
	cnn.begintrans
	
	sql = " SELECT H.CODIGO, GD.COD_GRADECURRICULARDISCIPLINA_EQUIVALENTE, GD.COD_DISCIPLINA_EQUIVALENTE "
	sql = sql & " FROM SCA_HISTORICO_ESCOLAR E "
	sql = sql & " inner JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA H ON H.cod_historico_escolar = E.CODIGO "
	sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA GD ON GD.COD_GRADECURRICULARDISCIPLINA = H.COD_GRADECURRICULARDISCIPLINA "
	sql = sql & " WHERE H.COD_PERIODO = " & intCodPeriodo 
	sql = sql & " AND E.COD_EMPRESA = " & intCodEmp 
	sql = sql & " AND E.COD_ALUNO = " & strCodAluno 
	sql = sql & " AND H.situacao <> 'AC' "
	sql = sql & " AND ISNULL(GD.COD_GRADECURRICULARDISCIPLINA_EQUIVALENTE,'0') <> '0' "
	sql = sql & " AND ISNULL(GD.COD_GRADECURRICULAR_EQUIVALENTE,'0') <> '0' "
	rs.open sql, cnn
	if not rs.eof then	
		while not rs.eof 
            
			intCodHistoricoDisciplina = rs("CODIGO")
			intCodGradeCurricularDisciplinaEquivalente =  rs("COD_DISCIPLINA_EQUIVALENTE")
			if isnull(intCodGradeCurricularDisciplinaEquivalente) or intCodGradeCurricularDisciplinaEquivalente = "" then intCodGradeCurricularDisciplinaEquivalente="0"
			 
		    intPeriodoEquivalencia = ""
		    intDisciplinaEquivalencia = ""
		    intChAnualEquivalencia = 0

			sql = " SELECT "
			sql = sql & " SCA_PERIODO.Descricao as PERIODO, "
			sql = sql & " SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA, "
			sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
			sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Anual "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
			sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodGradeCurricularDisciplinaEquivalente
			rs1.open sql, cnn
	        if not rs1.eof then 
			   intPeriodoEquivalencia = rs1("PERIODO")
			   intDisciplinaEquivalencia = rs1("COD_DISCIPLINA")
			   intChAnualEquivalencia = rs1("Ch_Anual")
			end if
            rs1.close


			' atualiza a equivalencia do aluno
			sql = " update SCA_HISTORICO_ESCOLAR_DISCIPLINA set " 
			if trim(intPeriodoEquivalencia) <> "" then
				sql = sql & ",COD_PERIODO = " & intPeriodoEquivalencia & ","
			else
				sql = sql & ",COD_PERIODO = null,"
			end if
			if trim(intDisciplinaEquivalencia) <> "" then
				sql = sql & ",COD_DISCIPLINA = " & intDisciplinaEquivalencia & ","
			else
				sql = sql & ",COD_DISCIPLINA = null,"
			end if
			if trim(intChAnualEquivalencia) <> "" then
				sql = sql & ",CARGA_HORARIA = " & intChAnualEquivalencia & ","
			else
				sql = sql & ",CARGA_HORARIA = null,"
			end if
			sql = sql & ",SITUACAO = 'AP',"
			sql = sql & ",MOSTRANOTA = 'N'"
			sql = sql & " Where codigo = " & intCodHistoricoDisciplina
			'cnn.execute sql
			'GravarLog sql		

			rs.movenext

		wend
	 else
	    cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \nFalta informação na Grade Equivalente. Verifique!");
			window.history.back();
		</script>
		<%	
		response.End()

	 end if

	strMensagem = "Registro atualizado com sucesso..."

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
	intCodAluno			= strCodAluno
	intCodTaxa			= ""
	intCodBebitoAluno	= ""
	strDataOcorrencia	= formatadataBD(date)
	strUsuarioIncl		= trim(session("usuarioWeb"))
	strDataValidade		= ""
	strOcorrencia		= "Intervenção Curricular no Histórico, existe equivalência para esse aluno."
	%>
	<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%						

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TrocaSituacaoAluno_cad.asp?txtMatricula=<%=strMatricula%>';
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