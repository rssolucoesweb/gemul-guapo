<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Eventos 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("txtSemestre"))
	intCargaHoraria			= Trim(Request.Form("txtCargaHoraria"))
	strEvento			 	= ReplaceRequest(Trim(Request.Form("txtEvento")))
	strDataInicial			= formataDataBD(Trim(Request.Form("txtDataInicial")))
	strDataFinal			= formataDataBD(Trim(Request.Form("txtDataFinal")))
	strSituacao				= Trim(Request.Form("cmbSituacao"))

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_SEMINARIO_EVENTO(Cod_Empresa, Cod_Curso, Ano_Letivo, Semestre, "
		sql = sql & " CargaHoraria, Evento, DataInicial, DataFinal, Situacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCargaHoraria & ","
		sql = sql & "'" & strEvento & "',"
		sql = sql & "'" & strDataInicial & "',"
		sql = sql & "'" & strDataFinal & "',"
		sql = sql & "'" & strSituacao & "')"
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_SEMINARIO_EVENTO Set"
		sql = sql & " Cod_Curso = " & intCodCurso & ","
		sql = sql & " Ano_Letivo = " & intAnoLetivo & ","
		sql = sql & " Semestre = " & intSemestre & ","
		sql = sql & " CargaHoraria = " & intCargaHoraria & ","
		sql = sql & " Evento = '" & strEvento & "',"
		sql = sql & " DataInicial = '" & strDataInicial & "',"
		sql = sql & " DataFinal = '" & strDataFinal & "',"
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_SEMINARIO_EVENTO "
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
	
	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Eventos_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>