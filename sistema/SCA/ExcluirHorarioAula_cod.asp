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
	intCodEmpresa				= Session("CodEmpresa")
	strAnoLetivo 				= session("strAnoLetivo")
	intSemestre 			 	= session("strSemestre")
	intCodCurso					= Trim(Request("cmbCurso"))
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaGrade		= Trim(Request.Form("cmbDisciplinaGrade"))
			
	if acao="E" then
	
		strMensagem = "Horário de Aula Excluido com sucesso..."
		
		sql = "Delete from SCA_HORARIO_AULA "
		sql = sql & " Where Cod_Empresa = " & intCodEmpresa
		sql = sql & " And AnoLetivo = " & strAnoLetivo
		sql = sql & " And Semestre = " & intSemestre
		sql = sql & " And Cod_turma = " & intCodTurma
		sql = sql & " And Cod_Disciplina = " & intCodDisciplinaGrade
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ExcluirHorarioAula_cad.asp';
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