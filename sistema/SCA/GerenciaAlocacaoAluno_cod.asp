<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Grade Disciplina
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo				= Trim(Request.QueryString("Codigo"))
	strMatricula 			= Trim(Request("txtMatricula"))

	intCodigo1 							= Trim(Request("txtCodigo"))
	strAnoLetivoAlocacao 				= Trim(Request("txtAnoLetivoAlocacao"))
	strSemestreAlocacao 				= Trim(Request("cmbSemestreAlocacao"))
	strSituacaoAlocacao 				= Trim(Request("cmbSituacaoAlocacao"))

	if strMatricula <> "" then
	
		sql = " SELECT "
		sql = sql & " A.CODIGO"	
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " WHERE A.MATRICULA = " & strMatricula
		sql = sql & " AND A.cod_empresa = " & Session("CodEmpresa")	
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno				= Trim(rs("CODIGO"))
		end if
		rs.close	
		
	end if
	

	if acao="ED"  then

	    strMensagem = "Alocação Excluída com sucesso..."
		sql = "Delete From SCA_ALUNO_TURMA"
		sql = sql & " where codigo = " & intCodigo

	elseif acao="A" then
		
		strMensagem = "Alocação Alterada com sucesso..."
		sql = "Update SCA_ALUNO_TURMA Set"
		sql = sql & " ANO_LETIVO = " & strAnoLetivoAlocacao & ","
		sql = sql & " SEMESTRE = " & strSemestreAlocacao & ","
		sql = sql & " SITUACAO =  '" & strSituacaoAlocacao & "'"
		sql = sql & " where codigo = " & intCodigo1
		
	end if
	
	cnn.execute sql
	GravarLog sql

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

	intCodEmp			= Session("CodEmpresa")
	intCodDepartamento	= Session("CodDeptoUsuario")
	intCodAluno			= strCodAluno
	intCodTaxa			= ""
	intCodBebitoAluno	= ""
	strDataOcorrencia	= formatadataBD(date)
	strDataValidade		= formatadataBD(date)
	strOcorrencia		= "ALOCAÇÃO N. " & intCodigo & " Excluída."
	%>
	<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%		
		
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="ED" then 'Excluir Disciplina
			%>
			<script>
				alert("<%=strMensagem%>");
				window.opener.frm.submit();
				window.close();
			</script>
			<%
			response.end
		else
			%>
			<script>
				alert("<%=strMensagem%>");
				window.navigate('GerenciaAlocacaoAluno_cad.asp?txtMatricula=<%=strMatricula%>');
			</script>
			<%
		end if
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