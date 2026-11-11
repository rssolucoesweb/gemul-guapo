<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Vicula Aluno a Rota
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	strCod_empresa 			= Session("CodEmpresa")
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intAnoLetivoSession		= session("strAnoLetivo")	
	intCodRota 				= Trim(Request.Form("cmbRota"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strDataVinculo			= formatadataBD(date) 
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	if acao="I" then
		
		sql = " Delete from SCA_ROTA_VICULA_ALUNO"
		sql = sql & " Where CodRota = " & intCodRota
		sql = sql & " and ano_letivo = " & intAnoLetivoSession
		sql = sql & " and codTurma = " & intCodTurma
		sql = sql & " and semestre = " & intSemestreAtual
		cnn.execute sql
		
		GravarLog sql

		strMensagem = "Alunos Vinculados com sucesso..."
	
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
		
			strCodAluno			= trim(vetCodAluno(intContador))
			
			sql = " Insert into SCA_ROTA_VICULA_ALUNO (cod_aluno, codTurma, ano_letivo, semestre, CodRota, DataVinculo)"
			sql = sql & " VALUES ("
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & " " & intAnoLetivoSession & ","
			sql = sql & " " & intSemestreAtual & ","
			sql = sql & " " & intCodRota & ","
			sql = sql & " '" & strDataVinculo & "')"
			
			cnn.execute sql
			GravarLog sql

		next
	
	elseif acao="A" then
		
		sql = " Delete from SCA_ROTA_VICULA_ALUNO"
		sql = sql & " Where CodRota = " & intCodRota
		sql = sql & " and ano_letivo = " & intAnoLetivoSession
		sql = sql & " and codTurma = " & intCodTurma
		sql = sql & " and semestre = " & intSemestreAtual
		cnn.execute sql
		
		GravarLog sql

		strMensagem = "Vinculo Alterado com sucesso..."
	
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
		
			strCodAluno			= trim(vetCodAluno(intContador))
			
			sql = " Insert into SCA_ROTA_VICULA_ALUNO (cod_aluno, codTurma, ano_letivo, semestre, CodRota, DataVinculo)"
			sql = sql & " VALUES ("
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & " " & intAnoLetivoSession & ","
			sql = sql & " " & intSemestreAtual & ","
			sql = sql & " " & intCodRota & ","
			sql = sql & " '" & strDataVinculo & "')"
			
			cnn.execute sql
			GravarLog sql

		next
			
	elseif acao="E" then
		
		strMensagem = "Alunos Desvinculado com sucesso..."
		
		sql = " Delete from SCA_ROTA_VICULA_ALUNO"
		sql = sql & " Where CodRota = " & intCodRota
		sql = sql & " and ano_letivo = " & intAnoLetivoSession
		sql = sql & " and codTurma = " & intCodTurma
		sql = sql & " and semestre = " & intSemestreAtual
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Rota_Vincula_Aluno_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>