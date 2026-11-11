<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Rubricas Fixas
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodGrupo				= Session("CodGrupo")
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intCodConvenio 			= Trim(Request.Form("cmbConvenios"))
	strTipoRubrica 			= Trim(Request.Form("cmbTipoRubrica"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
	strValor				= replace(replace(trim(request.form("txtValor")),".",""),",",".") 
	strTipoCalculo 			= Trim(Request.Form("cmbTipoCalculo"))
	strPeriodicidadeInicial	= formataDataBD(ReplaceRequest(Trim(Request.Form("txtPeriodicidadeInicial"))))  
	strPeriodicidadeFinal	= formataDataBD(ReplaceRequest(Trim(Request.Form("txtPeriodicidadeFinal"))))   
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SRH_RUBRICA"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SRH_RUBRICA (Codigo, Cod_grupo, Descricao,"
		sql = sql & " Cod_convenio, Tipo_rubrica, Situacao_rubrica, Valor_rubrica, "
		sql = sql & " Tipo_Calculo, Periodicidade_inicial, Periodicidade_final)"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodConvenio & ","
		sql = sql & "'" & strTipoRubrica & "',"
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "" & strValor & ","
		sql = sql & "'" & strTipoCalculo & "',"
		sql = sql & "'" & strPeriodicidadeInicial & "',"
		sql = sql & "'" & strPeriodicidadeFinal & "')"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_RUBRICA Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Cod_convenio = " & intCodConvenio & ","
		sql = sql & " Tipo_rubrica = '" & strTipoRubrica & "',"
		sql = sql & " Situacao_rubrica = '" & strSituacao & "',"
		sql = sql & " Valor_rubrica = " & strValor & ","
		sql = sql & " Tipo_Calculo = '" & strTipoCalculo & "',"
		sql = sql & " Periodicidade_inicial = '" & strPeriodicidadeInicial & "',"
		sql = sql & " Periodicidade_final = '" & strPeriodicidadeFinal & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_RUBRICA "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo

	end if
	
	cnn.execute sql
	'GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Rubricas_cad.asp';
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