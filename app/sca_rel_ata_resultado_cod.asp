<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 

response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/02/2022
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_replaceRequest.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%

	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	vetAluno			= split(Trim(Request.form("chkAluno")),",")

	strAnoLetivo 			= request("txtAnoLetivo")
	intSemestre 			= Trim(Request("cmbSemestre"))
	
	'carregando variavel
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodTurno		 		= Trim(Request("cmbTurno"))
	
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	strSemestre 		= Trim(Request.Form("cmbSemestre"))
	if strSemestre = "" then 	strSemestre  = session("strSemestre")
	
	
	'insere na tabela de controle
	SQL = "delete from SCA_ALUNO_APROVADO_CONSELHO "
	SQL = SQL & " where cod_turma = " & intCodTurma
	cnn.execute sql
	GravarLog sql
	
	for i=0 to uBound(vetAluno)	
	
		intCodAluno = vetAluno(i)

		'insere na tabela de controle
		SQL = "INSERT INTO SCA_ALUNO_APROVADO_CONSELHO (cod_aluno, cod_empresa, ano_letivo, semestre, cod_turma, "
		SQL = SQL & "usuario_incl, data_hora_incl) VALUES ("
		SQL = SQL & "" & intCodAluno & ","
		SQL = SQL & "" & intCodEmp & ","
		SQL = SQL & "" & strAnoLetivo & ","
		SQL = SQL & "" & strSemestre & ","
		SQL = SQL & "" & intCodTurma & ","
		sql = sql & "'" & trim(session("usuarioWeb")) & "',getdate())"
		'response.write sql
		cnn.execute sql
		GravarLog sql
		
		'Gera Ocorrencia Automatica de troca de situação
		'parametros:
		'	intCodEmp
		'	intCodDepartamento
		'	intCodAluno
		'	intCodTaxa
		'	intCodBebitoAluno
		'	strDataOcorrencia
		'	strDataValidade
		'	strOcorrencia
		'	strUsuarioIncl
	
		intCodEmp			= intCodEmp
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodAluno			= intCodAluno
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		strOcorrencia		= "Aluno reprovado por falta foi aprovado pelo conselho."
		%>
		<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%
		
		
	next
				
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("Registro(s) atualizado com sucesso!");
			window.location='sca_rel_ata_resultado.asp?cmbCurso=<%=intCodCurso%>&cmbPeriodo=<%=intCodPeriodo%>&cmbTurma=<%=intCodTurma%>&cmbTurno=<%=intCodTurno%>&txtAnoLetivo=<%=strAnoLetivo%>&cmbSemestre=<%=intSemestre%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>