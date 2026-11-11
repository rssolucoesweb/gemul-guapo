	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 20/02/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Publicação Curso
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	strAcao							= Trim(Request.QueryString("acao"))
	intCodEmpresa					= session("codEmpresa")
	intCodPublicacao				= Trim(Request.Form("txtCodigo"))
	strCodCurso						= Trim(Request.form("chkCurso"))
	
	if strCodCurso <> "" then   
		vetCodCurso = split(strCodCurso,",")			 
	end if

	'on error resume next
	cnn.begintrans
	
	if strAcao = "I" then  
		
		strMensagem = "Publicacao Curso Salva com sucesso."
		
		sql = " Delete From SCB_PublicacaoCurso"
		sql = sql & " WHERE Cod_Empresa = " & intCodEmpresa
		sql = sql & " AND Cod_Publicacao = " & intCodPublicacao
		cnn.execute sql
		GravarLog sql
		
		for intContador = 0 to ubound(vetCodCurso)
				
			intCodCurso			= vetCodCurso(intContador)
			strClassificao		= Trim(Request.form("txtClassificao_" & intContador))
			
			SQL = "INSERT INTO SCB_PublicacaoCurso (Cod_Empresa, Cod_Publicacao, Cod_Curso, Classificacao )"
			SQL = SQL & " VALUES ("
			SQL = SQL & "" & intCodEmpresa & ","
			SQL = SQL & "" & intCodPublicacao & ","
			SQL = SQL & "" & intCodCurso & ","
			SQL = SQL & "'" & strClassificao & "')"
			cnn.execute SQL
			GravarLog sql
		 	
		next
		
	end if 

	if strAcao = "E" then  
		
		strMensagem = "Publicacao Curso Excluida com sucesso."
		sql = " Delete From SCB_PublicacaoCurso"
		sql = sql & " WHERE Cod_Empresa = " & intCodEmpresa
		sql = sql & " AND Cod_Publicacao = " & intCodPublicacao
		cnn.execute sql
		GravarLog sql
	
	end if	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PublicacaoCurso_cad.asp';
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