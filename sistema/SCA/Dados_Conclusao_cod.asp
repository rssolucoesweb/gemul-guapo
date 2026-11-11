<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 23/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Projetos Sociais
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
	intCodAluno				= Trim(Request.QueryString("CodAluno"))
	
	strCod_empresa 			= Session("CodEmpresa")
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intAnoLetivoSession		= session("strAnoLetivo")	
	intCodProjetoSociais	= Trim(Request.Form("cmbProjetoSociais"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strDataVinculo			= formatadataBD(date) 
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	if acao="I" then
		
		sql = " Delete From SCA_PROJETOSOCIAIS_VINCULO"
		sql = sql & " Where CodProjetoSociais = " & intCodProjetoSociais
		sql = sql & " and ano_letivo = " & intAnoLetivoSession
		sql = sql & " and codTurma = " & intCodTurma
		sql = sql & " and semestre = " & intSemestreAtual
		sql = sql & " and cod_empresa = " & strCod_empresa
		cnn.execute sql
		GravarLog sql

		strMensagem = "Alunos Vinculados com sucesso..."
	
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
		
			strCodAluno			= trim(vetCodAluno(intContador))
			strBeneficio		= request.Form("txtBeneficio" &trim(vetCodAluno(intContador)))

			sql = " Insert into SCA_PROJETOSOCIAIS_VINCULO (cod_empresa, cod_aluno, codTurma, ano_letivo, semestre, CodProjetoSociais, DataVinculo, NumeroBeneficio)"
			sql = sql & " VALUES ("
			sql = sql & " " & strCod_empresa & ","
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & " " & intAnoLetivoSession & ","
			sql = sql & " " & intSemestreAtual & ","
			sql = sql & " " & intCodProjetoSociais & ","
			sql = sql & " '" & strDataVinculo & "',"
			sql = sql & " '" & strBeneficio & "')"
			
			cnn.execute sql
			GravarLog sql

		next
			
	elseif acao="E" then
		
		strMensagem = "Alunos Desvinculado com sucesso..."
		
		sql = " Delete from SCA_PROJETOSOCIAIS_VINCULO"
		sql = sql & " Where CodProjetoSociais = " & intCodProjetoSociais
		''sql = sql & " and ano_letivo = " & intAnoLetivoSession
		'sql = sql & " and codTurma = " & intCodTurma
		''sql = sql & " and semestre = " & intSemestreAtual
		sql = sql & " and cod_empresa = " & strCod_empresa
		sql = sql & " and cod_aluno = " & intCodAluno
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ProjetoSociais_Vincula_Aluno_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>