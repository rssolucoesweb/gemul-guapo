<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 15/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Frequência - Período de Modulação
-->
<% Response.Charset=" UTF-8" %>
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
	strAno	 				= Trim(Request("txtAno"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	strMes		 			= Trim(Request("cmbMes"))
	strDadaInicial			= formataDataBD(Trim(Request.Form("txtDataInicial")))  
	strFinalFinal			= formataDataBD(Trim(Request.Form("txtDataFinal"))) 
	
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	if acao="I" then

		sql = "SELECT Codigo"
		sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
		sql = sql & " where Cod_grupo = " & intCodGrupo			
		sql = sql & " AND ANOREFERENCIA = " & strAno	
		sql = sql & " AND MESREFERENCIA = " & strMes	
		rs.open sql, cnn
		if rs.eof = false then
			cnn.rollbackTrans
			%>
			<script>
				alert("<% Response.Charset="UTF-8" %>ATENÇÃO: Período de Modulação já incluso. Verifique!");
				window.history.back();
			</script>
			<%
	        response.End()
		end if	

	end if		

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_MODULACAO_REFERENCIA ( Cod_Grupo, AnoReferencia, SemestreReferencia ,MesReferencia,Data_BLOQUEIO, Data_Inicial, Data_Final, Situacao )"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & strAno & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & strMes & ","
		sql = sql & "'" & FORMATADATABD(DateAdd("d",3,strFinalFinal)) & "',"
		sql = sql & "'" & strDadaInicial & "',"
		sql = sql & "'" & strFinalFinal & "',"
		sql = sql & "'" & strSituacao & "')"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_MODULACAO_REFERENCIA Set"
		sql = sql & " Cod_Grupo = " & intCodGrupo & ","
		sql = sql & " AnoReferencia = " & strAno & ","
		sql = sql & " SemestreReferencia = " & intSemestre & ","
		sql = sql & " MesReferencia = " & strMes & ","
		sql = sql & " Data_BLOQUEIO = '" & FORMATADATABD(DateAdd("d",3,strFinalFinal)) & "',"
		sql = sql & " Data_Inicial = '" & strDadaInicial & "',"
		sql = sql & " Data_Final = '" & strFinalFinal & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_MODULACAO_REFERENCIA "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & intCodGrupo

	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ModulacaoReferencia_cad.asp';
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