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
	cnn.begintrans

	vetAluno			= split(Trim(Request.form("chkAluno")),",")
	strCodTurma 		= Trim(Request.Form("cmbTurma"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	strSemestre 		= Trim(Request.Form("cmbSemestre"))
	if strSemestre = "" then 	strSemestre  = session("strSemestre")
	if strCodTurma = "" then strCodTurma = "0"
	strSituacaoAluno  = trim(request("cmbSituacaoAluno"))

	sql = "select t.COD_SEMESTRE, p.cod_curso, t.anoletivo from SCA_TURMA t inner join sca_periodo p on p.cod_periodo = t.cod_periodo"
	sql = sql & " Where t.Cod_Empresa = " & Session("CodEmpresa") 
	sql = sql & " And t.Cod_Turma = " & strCodTurma
	rs.open sql, cnn,3,3
	if rs.eof = false then
		strSemestre = RS("COD_SEMESTRE")
		intCodCurso = rs("cod_curso")
		strAnoLetivo = rs("anoletivo")
	end if
	rs.close	
	
	intRegistrosAgendado = 0

	for i=0 to uBound(vetAluno)	
	
		intCodAluno = trim(vetAluno(i))
		resultado_final_aluno = request.form("resultado_final_aluno" & intCodAluno)
	
		SQL = "INSERT INTO SCA_FECHAMENTO_AGENDAMENTO (COD_EMPRESA, COD_ALUNO, COD_TURMA, ANO_LETIVO, SEMESTRE, COD_SITUACAO_ALUNO_DESTINO, RESULTADO_FINAL, SITUACAO, usuario_incl, data_hora_incl) VALUES ("
		SQL = SQL & "" & Session("CodEmpresa") & ","
		SQL = SQL & "" & intCodAluno & ","
		SQL = SQL & "" & strCodTurma & ","
		SQL = SQL & "" & strAnoLetivo & ","
		SQL = SQL & "" & strSemestre & ","
		SQL = SQL & "" & strSituacaoAluno & ","
		SQL = SQL & "'" & resultado_final_aluno & "',"
		SQL = SQL & "'A'," 'AGENDADO
		SQL = SQL & "'" & trim(session("usuarioWeb")) & "',"
		SQL = SQL & "getdate())"
		cnn.execute sql
		
		'Gera Ocorrencia Automatica de troca de situação
		'parametros:
		intCodEmp			= Session("CodEmpresa")
		intCodAluno			= intCodAluno
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		strOcorrencia		= "Fechamento anual agendado."

		%>
		<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%
		
		intRegistrosAgendado = intRegistrosAgendado + 1

		strAtualizado=false
		sql = "select COD_TURMA from SCA_CONTROLE_FECHAMENTO"
		sql = sql & " Where COD_ALUNO = " & intCodAluno
		sql = sql & " And Cod_Turma = " & strCodTurma
		rs1.open sql, cnn,3,3
		if rs1.eof = false then
			  strAtualizado = true
		end if
		rs1.close	

		if strAtualizado = false then
			sql = "insert into SCA_CONTROLE_FECHAMENTO (COD_TURMA, COD_ALUNO) VALUES ("
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intCodAluno & ")" 
			cnn.execute sql
			GravarLog sql
		end if			
	next
    
	strMensagem = "Agendamento finalizado com sucesso!\nAgendados: " & intRegistrosAgendado & " aluno(s)"
				
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.rollbackTrans
		'response.end
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_fechamento_AnualCon.asp?cmbCurso=<%=intCodCurso%>&txtAnoLetivo=<%=strAnoLetivo%>&cmbTurma=<%=strCodTurma%>';
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