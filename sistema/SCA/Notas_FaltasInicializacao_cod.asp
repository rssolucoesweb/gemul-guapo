<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
server.ScriptTimeout = 6000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas e media
-->
<!--include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	strPaginaRetorno		= Trim(Request.Form("txtPaginaRetorno"))
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo			= Trim(Request.form("txtAnoLetivo"))
	intSemestre 			= Trim(Request("cmbSemestre"))

	strAlunos 				= Trim(Request("chkAluno"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodDisciplinaTurma	= trim(request("cmbDisciplinaTurma"))
	intCodDisciplina	   	= trim(request("cmbDisciplinaTurma"))
	intCodTurmaProfessor	= intCodTurma
	strSituacaoDisciplina 	= Trim(Request("cmbSituacaoDisciplina"))
	strAtivos               = trim(request("cmbativos"))
 	strInicializaNotas	   	= trim(request("InicializaNotas"))
 	strInicializaFaltas	   	= trim(request("InicializaFaltas"))
	strVerificaHistorico    = Trim(Request("optVerificaHistorico"))

	strSituacaoTurmaCad = ""
	sql = "SELECT SCA_TURMA.SITUACAO"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
	RS.OPEN sql, CNN
	IF not RS.EOF THEN
		strSituacaoTurmaCad = rs("Situacao")
	END IF
	rs.close
	
	buscaHistorico = "N"
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
		  buscaHistorico = "S"
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
	   end if	   
	end if

	if strSituacaoTurmaCad = "S" then buscaHistorico = "N"  'Turmas sem fechamento
	if strVerificaHistorico = "S" then buscaHistorico = "S" 'Turmas já fechada com opcao de busca pelo histórico
	if strVerificaHistorico = "N" then buscaHistorico = "N" 'Turmas já fechada com opcao de busca pelo histórico

	if buscaHistorico = "N" then
		sql = " SELECT distinct "
		sql = sql & " AD.COD_ALUNO AS CODIGO, " 
		sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, D.DESC_DISCIPLINA,"
		sql = sql & " A.NOMEALUNO, "
		sql = sql & " A.MATRICULA, "
		sql = sql & " '' AS SEQUENCIA, "
		sql = sql & " AD.SITUACAO AS SITUACAO_DISCIPLINA, "
		sql = sql & " SA.DESC_SITUACAOALUNO "
		sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
		sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
		sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN"
		sql = sql & " SCA_DISCIPLINA D ON D.Cod_Disciplina = AD.COD_DISCIPLINA "
		sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
		sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
		sql = sql & " AND  AD.COD_DISCIPLINA = " & intCodDisciplina
		if strSituacaoDisciplina <> "0" then 
			sql = sql & " and AD.SITUACAO = '" & strSituacaoDisciplina & "'"
		end if	
		sql = sql & " ORDER BY A.NOMEALUNO "
	else   
	   'seleciona os alunos pelo ano e semestres do histórico 			
	   sql = " select DISTINCT A.CODIGO, HED.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, "
	   sql = sql & " HED.SITUACAO_DISCIPLINAR AS SITUACAO_DISCIPLINA, D.DESC_DISCIPLINA "
	   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
	   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
	   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
	   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
	   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
	   sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HED.COD_DISCIPLINA " 
	   
	   sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
	   sql = sql & " AND HED.COD_TURMA = " & intCodTurma	
	   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
	   sql = sql & " AND HE.COD_ALUNO in (" & strAlunos & ") "
	   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
	   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
	   if strSituacaoDisciplina <> "0" then 
	 		sql = sql & " and HED.situacao_disciplinar = '" & strSituacaoDisciplina & "'"
	   end if	
	   sql = sql & " ORDER BY NOMEALUNO "
	end if
	rs.open sql, cnn
	while not rs.eof

		strCodAluno = rs("CODIGO")
		NomeDisciplina	= rs("DESC_DISCIPLINA")

		if strInicializaFaltas = "S" then
			sql = "delete"
			sql = sql & " from SCA_FALTAS_DIARIA"
			sql = sql & " where ano_Letivo = " & strAnoLetivo
			sql = sql & " and semestre = " & intSemestre
			sql = sql & " and cod_aluno = " & strCodAluno
			sql = sql & " and cod_disciplina = " & intCodDisciplina
			cnn.execute SQL
	
			SQL = "UPDATE SCA_NOTAS_FALTAS SET "
			SQL = SQL & " falta01 = null, "
			SQL = SQL & " falta02 = null, "
			SQL = SQL & " falta03 = null, "
			SQL = SQL & " falta04 = null, "
			SQL = SQL & " falta05 = null, "
			SQL = SQL & " falta06 = null, "
			SQL = SQL & " falta07 = null, "
			SQL = SQL & " falta08 = null, "
			SQL = SQL & " falta09 = null, "
			SQL = SQL & " falta10 = null, "
			SQL = SQL & " falta11 = null, "
			SQL = SQL & " falta12 = null, "
			SQL = SQL & " falta13 = null, "
			SQL = SQL & " falta14 = null, "
			SQL = SQL & " falta15 = null  "
			sql = sql & " where ano_Letivo = " & strAnoLetivo
			sql = sql & " and semestre = " & intSemestre
			sql = sql & " and cod_aluno = " & strCodAluno
			sql = sql & " and cod_disciplina = " & intCodDisciplina
			cnn.execute SQL
			
			if buscaHistorico = "S" then
	
				SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				SQL = SQL & " falta01 = null, "
				SQL = SQL & " falta02 = null, "
				SQL = SQL & " falta03 = null, "
				SQL = SQL & " falta04 = null, "
				SQL = SQL & " falta05 = null, "
				SQL = SQL & " falta06 = null, "
				SQL = SQL & " falta07 = null, "
				SQL = SQL & " falta08 = null, "
				SQL = SQL & " falta09 = null, "
				SQL = SQL & " falta10 = null, "
				SQL = SQL & " falta11 = null, "
				SQL = SQL & " falta12 = null, "
				SQL = SQL & " falta13 = null, "
				SQL = SQL & " falta14 = null, "
				SQL = SQL & " falta15 = null  "
				SQL = SQL & " from SCA_HISTORICO_ESCOLAR H "
				SQL = SQL & " inner join SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.codigo "
				sql = sql & " where HD.ano_letivo = " & strAnoLetivo
				sql = sql & " and HD.semestre = " & intSemestre
				sql = sql & " and cod_aluno = " & strCodAluno
				sql = sql & " and  HD.cod_disciplina = " & intCodDisciplina
				cnn.execute SQL
			
			end if
		end if

		if strInicializaNotas = "S" then
		
			' limpa a tabela de notas
			sql = "DELETE "
			sql = sql & " from 	SCA_NOTAS_FALTAS "
			sql = sql & " where cod_aluno = " & strCodAluno
			sql = sql & " and cod_disciplina = " & intCodDisciplina
			cnn.execute sql
			
			if buscaHistorico = "S" then
	
				SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				SQL = SQL & " nota01 = null, "
				SQL = SQL & " nota02 = null, "
				SQL = SQL & " nota03 = null, "
				SQL = SQL & " nota04 = null, "
				SQL = SQL & " nota05 = null, "
				SQL = SQL & " nota06 = null, "
				SQL = SQL & " nota07 = null, "
				SQL = SQL & " nota08 = null, "
				SQL = SQL & " nota09 = null, "
				SQL = SQL & " nota10 = null, "
				SQL = SQL & " nota11 = null, "
				SQL = SQL & " nota12 = null, "
				SQL = SQL & " nota13 = null, "
				SQL = SQL & " nota14 = null, "
				SQL = SQL & " nota15 = null,  "
				SQL = SQL & " Media = null,  "
				SQL = SQL & " Situacao = null  "
				SQL = SQL & " from SCA_HISTORICO_ESCOLAR H "
				SQL = SQL & " inner join SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.codigo "
				sql = sql & " where HD.ano_letivo = " & strAnoLetivo
				sql = sql & " and HD.semestre = " & intSemestre
				sql = sql & " and cod_aluno = " & strCodAluno
				sql = sql & " and  HD.cod_disciplina = " & intCodDisciplina
				cnn.execute SQL
			
			end if
		end if
		
				'Gera Ocorrencia Automatica do tipo Protesto
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
	
		intCodEmp			= Session("CodEmpresa")
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodAluno			= strCodAluno
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strDataValidade		= formatadataBD(date)
		if strInicializaNotas = "S" then 
			strOcorrencia		= "Notas Inicializada: " & NomeDisciplina 
		end if
		if strInicializaFaltas = "S" then 
			strOcorrencia		= "Faltas Inicializada: " & NomeDisciplina 
		end if
		if strInicializaNotas = "S"  and strInicializaFaltas = "S" then 
			strOcorrencia		= "Notas e Faltas Inicializada: " & NomeDisciplina 
		end if
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%		
		
		rs.movenext
	wend
	rs.close
	strMensagem = "Registro Inicializado com sucesso..."

	strParametro = "Notas_FaltasInicializacao_con.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
	strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplinaTurma
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbSituacaoDisciplina="&strSituacaoDisciplina
	strParametro = strParametro & "&cmbAcompanhamento="&strAcompanhamento
	strParametro = strParametro & "&cmbCurso="&intCodCurso	

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("<%=strMensagem%>");
			window.location="<%=strParametro%>";
		</script>
		<%
		response.end
	else
		'cnn.rollbackTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>