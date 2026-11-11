<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 19/02/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Genero
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intCodAreaConhecimento 	= Trim(Request.Form("cmbAreaConhecimento"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
				
		sql = "Insert Into SCB_CDU(Cod_Empresa, Cod_cdu, Nome_cdu, Cod_AreaConhecimento)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & intCodigo & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodAreaConhecimento & ")"
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCB_CDU Set"
		sql = sql & " Nome_cdu = '" & strDescricao & "',"
		sql = sql & " Cod_AreaConhecimento = " & intCodAreaConhecimento & ""
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Cod_cdu = '" & intCodigo & "'"
				
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCB_CDU "
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And Cod_cdu = '" & intCodigo & "'"
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='cdu_cad.asp';
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