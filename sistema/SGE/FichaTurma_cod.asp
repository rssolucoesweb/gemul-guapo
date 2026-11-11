	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Eventos do Dossiê
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno				= "FichaTurma_cad.asp"
	strAcao 					= Request.QueryString("acao")
	
	intCodEmp					= Session("CodEmpresa")
	strAnoLetivo 				= session("strAnoLetivo")
	intSemestre 				= session("strSemestre")
	intCodEmpresa				= trim(Request.Form("cmbEmpresaGrupo"))
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	intCodFichaDescritiva		= Trim(Request.form("cmbFichaDescritiva"))
	intCodTurma 				= Trim(Request.Form("chkCodTurma"))
	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		if intCodTurma <> "" then 
		
			strMensagem = "Registro Alterado com sucesso!"
			
			sql = "Update SCA_TURMA Set"
			sql = sql & " Cod_FichaDescritiva = " & intCodFichaDescritiva & ""
			sql = sql & " Where Cod_Turma in(" & intCodTurma & ")"
			cnn.execute sql
			GravarLog sql
	
		end if 
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FichaTurma_cad.asp';
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