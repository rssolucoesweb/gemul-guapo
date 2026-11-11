<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Ocorrencia 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")

	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
	
	if intCodCurso = "" then intCodCurso = "0"
	if intCodTurma = "" then intCodTurma = "0"
	
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_HISTORICO_OBSERVACOES(COD_EMPRESA, ANO, SEMESTRE, COD_CURSO, COD_TURMA, COD_ALUNO, OBSERVACOES)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		if 	intCodCurso <> "0"  then
			sql = sql & "" & intCodCurso & ","
		else	
			sql = sql & "null,"
		end if	
		if 	intCodTurma <> "0" then
			sql = sql & "" & intCodTurma & ","
		else
			sql = sql & "null,"
		end if	
		if 	intCodAluno <> "" then
			sql = sql & "" & intCodAluno & ","
		else
			sql = sql & "null,"
		end if	
		sql = sql & "'" & strOcorrencia & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_HISTORICO_OBSERVACOES Set"
		sql = sql & " ANO = " & intAnoLetivo & ","
		sql = sql & " SEMESTRE = " & intSemestre & ","
		if 	intCodCurso <> "0" then
			sql = sql & " COD_CURSO = " & intCodCurso & ","
		else
			sql = sql & " COD_CURSO = null,"
		end if	
		if 	intCodTurma <> "0" then
			sql = sql & " COD_TURMA = " & intCodTurma & ","
		else
			sql = sql & " COD_TURMA = null,"
		end if	
		if 	intCodAluno <> "" then
			sql = sql & " COD_ALUNO = " & intCodAluno & ","
		else
			sql = sql & " COD_ALUNO = null,"
		end if	
		sql = sql & " OBSERVACOES = '" & strOcorrencia & "'"
		sql = sql & " where CODIGO = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SCA_HISTORICO_OBSERVACOES "
		sql = sql & " where CODIGO = " & intCodigo
		
	end if
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then

	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('Historico_Observacoes_cad.asp');
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