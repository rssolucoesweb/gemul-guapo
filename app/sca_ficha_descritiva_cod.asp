<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formataData.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
    intCodEmp          				= Session("CodEmpresa")	
	intCodGrupo						= Session("CodGrupo")
	intCodigo						= Trim(Request.Form("txtCodigo"))
	intAnoLetivo					= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 					= Trim(Request.Form("cmbSemestre"))
	strDescricao 					= replace(Trim(Request.Form("txtDescricao")),"'","")
	strDescricaoAbreviada			= replace(Trim(Request.Form("txtDescricaoAbreviada")),"'","")
	strSituacao						= Trim(Request.Form("cmbSituacao"))
	intCodTipoEmpresa 				= Trim(Request.Form("cmbTipoEmpresa"))
    strObservacao	                = Trim(Request.Form("txtObservacao"))
    strRodape	                    = Trim(Request.Form("txtRodape"))
	strSimouNao         			= Trim(Request.Form("cmbSimouNao"))
	strUtilizacao					= "AC"
	intCodCurso	 					= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 					= Trim(Request.Form("cmbPeriodo"))
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_FICHA_DESCRITIVA(Cod_Empresa, Cod_Grupo, Descricao, descricao_abreviada, Ano_Letivo, Semestre, cod_curso, cod_periodo, Situacao, CodTipoEmpresa, observacoes, rodape, Publicar, Utilizacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDescricaoAbreviada & "',"
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & intCodCurso & "',"
		sql = sql & "'" & intCodPeriodo & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "" & intCodTipoEmpresa & ","
	    sql = sql & "'" & strObservacao & "',"
		sql = sql & "'" & strRodape & "',"
		sql = sql & "'" & strSimouNao & "',"
		sql = sql & "'" & strUtilizacao & "')"
		cnn.execute sql
		GravarLog sql

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_FICHA_DESCRITIVA Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Descricao_abreviada = '" & strDescricaoAbreviada & "',"
		sql = sql & " Ano_Letivo = " & intAnoLetivo & ","
		sql = sql & " Semestre = " & intSemestre & ","
		sql = sql & " cod_curso = '" & intCodCurso & "',"
		sql = sql & " cod_periodo = '" & intCodPeriodo & "',"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " CodTipoEmpresa = " & intCodTipoEmpresa & ","
		sql = sql & " Observacoes = '" & strObservacao & "',"
		sql = sql & " Rodape = '" & strRodape & "',"
		sql = sql & " Publicar = '" & strSimouNao & "',"
		sql = sql & " Utilizacao = '" & strUtilizacao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
		
		strMensagem = "Registro Excluido com sucesso..."
		
		' Ficha Descritiva - Perguntas
		sql = "Delete from SCA_FICHA_DESCRITIVA_PERGUNTA "
		sql = sql & " Where cod_ficha_descritiva = " & intCodigo
		cnn.execute sql
		GravarLog sql

		'Ficha Descritiva
		sql = "Delete from SCA_FICHA_DESCRITIVA "
		sql = sql & " where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_ficha_descritiva.asp';
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