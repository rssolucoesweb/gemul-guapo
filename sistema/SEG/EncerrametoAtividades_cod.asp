	<!--
		::	DESENVOLVIDO POR Asced"
		::	Data de Criação...: 26/12/2015
		::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
		::	Objetivo Pagina...: Clonar Acesso
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
    <!--#include file="../../includes/inc_formataData.asp"-->
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 								= Trim(Request.QueryString("acao"))
	intCodEmp							= Session("CodEmpresa")
	intCodigo	 						= Trim(Request.Form("txtCodigo"))
	intAno								= Trim(Request.Form("txtAno"))
	intSemestre							= Trim(Request.Form("cmbSemestre"))
	strDataEncerramento					= formataDataBD(Trim(Request.Form("txtDataEncerramento")))
	strSimouNaoDocente					= Trim(Request.Form("cmbSimouNaoDocente"))
	intCodAvaliacaoAgrupamento			= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
    strSimouNaoSecretaria    			= Trim(Request.Form("cmbSimouNaoSecretaria"))
    strSimouNaoCampoAcumuladaFalta 		= Trim(Request.Form("cmbSimouNaoCampoAcumuladaFalta"))
    strSimouNaoDocumentacaoColaboradores= Trim(Request.Form("cmbSimouNaoDocumentacaoColaboradores"))
    strSimouNaoHabilitaPlanoEnsino      = Trim(Request.Form("cmbSimouNaoHabilitaPlanoEnsino"))
    strSimouNaoPreMatricula      		= Trim(Request.Form("cmbSimouNaoPreMatricula"))
    strCriarGradeChecandoHistorico 		= Trim(Request.Form("cmbCriarGradeChecandoHistorico"))
	strMes								= Trim(Request("cmbMes"))
	strNotificacao1						= Trim(Request.Form("txtNotificacao1"))
	strNotificacao2						= Trim(Request.Form("txtNotificacao2"))
		
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SEG_ENCERRAMENTOATIVIDADES(COD_EMPRESA, Ano_letivo, Semestre, data_encerramento, Bloqueia_NotasDocente, Permitir_AlteracaoNotaDocente ,Bloqueia_NotasSecretaria, Bloqueia_CampoAcumuladaFalta, Bloqueia_ConteudoProgramatico, Notificacao1, Notificacao2, Habilitar_PlanoEnsino, Habilitar_PreMatricula, CriarGrade_ChecandoHistorico, DocumentacaoColaboradores)"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intAno & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDataEncerramento & "',"
    	sql = sql & "'" & strSimouNaoDocente & "',"
    	sql = sql & "" & intCodAvaliacaoAgrupamento & ","
		sql = sql & "'" & strSimouNaoSecretaria & "',"
		sql = sql & "'" & strSimouNaoCampoAcumuladaFalta & "',"
		sql = sql & "" &  strMes & ","
		sql = sql & "'" & strNotificacao1 & "',"
		sql = sql & "'" & strNotificacao2 & "',"
		sql = sql & "'" &  strSimouNaoHabilitaPlanoEnsino & "',"
		sql = sql & "'" &  strSimouNaoPreMatricula & "',"
		sql = sql & "'" &  strCriarGradeChecandoHistorico & "',"
		sql = sql & "'" &  strSimouNaoDocumentacaoColaboradores & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SEG_ENCERRAMENTOATIVIDADES Set"
		
		sql = sql & " ano_letivo = " & intAno & ","
		sql = sql & " semestre = " & intSemestre & ","
		sql = sql & " data_encerramento = '" & strDataEncerramento & "',"
		sql = sql & " Bloqueia_NotasDocente = '" & strSimouNaoDocente & "',"
		sql = sql & " Permitir_AlteracaoNotaDocente = " & intCodAvaliacaoAgrupamento & ","
		sql = sql & " Bloqueia_NotasSecretaria = '" & strSimouNaoSecretaria & "',"
		sql = sql & " Bloqueia_CampoAcumuladaFalta = '" & strSimouNaoCampoAcumuladaFalta & "',"
		sql = sql & " Bloqueia_ConteudoProgramatico = " & strMes & "," 
		sql = sql & " Habilitar_PlanoEnsino = '" & strSimouNaoHabilitaPlanoEnsino & "',"
		sql = sql & " Habilitar_PreMatricula = '" & strSimouNaoPreMatricula & "',"
		sql = sql & " CriarGrade_ChecandoHistorico = '" & strCriarGradeChecandoHistorico & "',"
		sql = sql & " DocumentacaoColaboradores = '" & strSimouNaoDocumentacaoColaboradores & "',"
		sql = sql & " Notificacao1 = '" & strNotificacao1 & "',"
		sql = sql & " Notificacao2 = '" & strNotificacao2 & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp

	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SEG_ENCERRAMENTOATIVIDADES "
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp
		
	end if
	
	cnn.execute sql
	GravarLog sql

	'busca informações ano e semestre letivo
	sql = " SELECT top 1 ano_letivo, semestre "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & intCodEmp
	sql = sql & " order by ano_letivo desc"
	RS1.Open SQL, cnn
	if RS1.EOF = false then								
		Session("strAnoLetivo")			= RS1("ano_letivo")
		Session("strSemestre")			= RS1("semestre")
	end if
	rs1.close

	'busca regime da escola
	sql = " SELECT tipo_seriacao "
	sql = sql & " FROM sca_regime "
	sql = sql & " Where cod_empresa = " & intCodEmp
	sql = sql & " order by Cod_Regime desc"
	RS1.Open SQL, cnn
	if RS1.EOF = false then		
		strTipoSeriacao	= trim(rs1("tipo_seriacao"))
		if strTipoSeriacao	= "A" then 
			Session("strSemestre") = "3"
			Session("strDescSemestre") = "Anual"
			Session("strTodosSemestre") = "3"
		elseif strTipoSeriacao	= "S" then 
			Session("strTodosSemestre") = "1,2"
			Session("strDescSemestre") = Session("strSemestre") & "º Semestre"
		elseif strTipoSeriacao	= "AS" then 
			if Session("strSemestre") = 1 then Session("strSemestre") = "1,3"
			if Session("strSemestre") = 2 then Session("strSemestre") = "2,3"
			Session("strTodosSemestre") = "1,2,3"
			Session("strDescSemestre") = "Anual/" & Session("strSemestre") & "º Semestre"
		end if
	end if
	RS1.close

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='EncerrametoAtividades_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='EncerrametoAtividades_cad.asp';
		</script>
		<%
	end if
%>