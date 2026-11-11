	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro Avaliacao Institucional
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno		= "AvaliacaoInstitucional_cad.asp"
	strAcao 			= Request.QueryString("acao")
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	intAnoLetivo		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("txtSemestre"))
	intCodTipoAvaliacao = Trim(Request.Form("cmbTipoAvaliacao"))
	strSimouNao         = Trim(Request.Form("cmbSimouNao"))
	intCodTipoConsulta	= Trim(Request.Form("cmbTipoConsultaAvaliacao"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	strObservacao	    = Trim(Request.Form("txtObservacao"))
    strRodape	        = Trim(Request.Form("txtRodape"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SAV_AVALIACAO_INSTITUCIONAL(Cod_Empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta, Situacao, observacoes, rodape, publicar)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodTipoAvaliacao & ","
		sql = sql & "" & intCodTipoConsulta & ","
		sql = sql & "'" & strSituacao & "',"
	    sql = sql & "'" & strObservacao & "',"
		sql = sql & "'" & strRodape & "',"
		sql = sql & "'" & strSimouNao & "')"

		cnn.execute sql
		GravarLog sql
		
		
	elseif strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SAV_AVALIACAO_INSTITUCIONAL Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Ano_Letivo = " & intAnoLetivo & ","
		sql = sql & " Semestre = " & intSemestre & ","
		sql = sql & " Tipo_Avaliacao = " & intCodTipoAvaliacao & ","
		sql = sql & " Tipo_Consulta = " & intCodTipoConsulta & ","
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " Observacoes = '" & strObservacao & "',"
		sql = sql & " Rodape = '" & strRodape & "',"
		sql = sql & " Publicar = '" & strSimouNao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		
		cnn.execute sql
		GravarLog sql
			
	elseif strAcao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SAV_AVALIACAO_INSTITUCIONAL "
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
			window.location='AvaliacaoInstitucional_cad.asp';
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