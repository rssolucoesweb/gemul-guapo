<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Regencia
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodigo					= Trim(Request.Form("txtCodigo"))
	intCodEmpresa 				= session("codEmpresa")
	intCodGrupo					= Session("CodGrupo")
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	strRegencia 				= replace(replace(trim(request.form("txtRegencia")),".",""),",",".")
	strDescricao 				= Trim(Request.Form("txtDescricao"))

	if acao="I" then
		
		strMensagem = "Regencia Salva com sucesso..."

		sql = "Insert Into SRH_REGENCIACOLABORADOR(Cod_Empresa, Cod_Grupo, Cod_Curso, Periodo, Regencia, Descricao) "
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "" & intCodPeriodo & ","
		sql = sql & "" & strRegencia & ","
		sql = sql & "'" & strDescricao & "')"
		
	elseif acao="A" then
		
		strMensagem = "Regencia Alterada com sucesso..."
		
		sql = "Update SRH_REGENCIACOLABORADOR Set"
		sql = sql & " Cod_Curso = " & intCodCurso & ","
		sql = sql & " Periodo = " & intCodPeriodo & ","
		sql = sql & " Regencia = " & strRegencia & ","
		sql = sql & " Descricao = '" & strDescricao & "'"
		
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa
		sql = sql & " And Cod_Grupo = " & intCodGrupo

	else
	
		strMensagem = "Regencia Excluida com sucesso..."
		
		sql = "Delete from SRH_REGENCIACOLABORADOR "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa
		sql = sql & " And Cod_Grupo = " & intCodGrupo

	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Regencia_cad.asp';
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