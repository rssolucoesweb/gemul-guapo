<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Grade Disciplina
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%

	strBloqueiaInclusaoDisciplinar = ""
	sql = " SELECT top 1 isnull(Bloqueia_Inclusao_Disciplinar,'N') as Bloqueia_Inclusao_Disciplinar "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueiaInclusaoDisciplinar  = trim(rs("Bloqueia_Inclusao_Disciplinar"))
	end if
	rs.close
	if strBloqueiaInclusaoDisciplinar = "S" then
		%>
		<script>
			alert("Atividade Bloqueada Temporariamente, procure a Secretaria Geral.");
			window.location.href = '../principal.asp'
		</script>
		<%
		response.end
	end if

	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	
	intCodigo						= Trim(Request.Form("txtCodigo"))
	cod_excluirDisc					= Trim(Request.Form("cod_excluirDisc"))
	
	intCodEmpresa					= session("CodEmpresa")
	strSemestre 					= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 					= Trim(Request.Form("txtAnoLetivo"))
	
	' Dados Aluno
	strCodAluno						= Trim(Request.Form("txtCodAluno"))
	strMatricula 					= Trim(Request.Form("txtMatricula"))
	intCodTurma 					= Trim(Request.Form("cmbTurmaGradeRemanejamento"))
	intCodDisciplina				= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodGradeCurricularDisciplina = Trim(Request.Form("txtCodGrade"))
	strSituacaoDisciplina 			= Trim(Request.Form("cmbSituacaoDisciplina"))
    strSituacaoPromocao 			= Trim(Request.form("cmbSituacaoPromocao")) 
	strSituacaoPromocaoTodos		= Trim(Request("txtSituacaoPromocaoTodos"))
	intCodCurso	 					= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 					= Trim(Request.Form("cmbPeriodo"))
	intSemestre 					= Trim(Request.Form("cmbSemestre"))
	intCodTurno		 				= Trim(Request.Form("cmbTurno"))

	' Dados Remanejamento
	intCodTurmaRemejamento 							= Trim(Request.Form("cmbTurmaRem"))
	intCodDisciplinaRemanejamento 					= Trim(Request.Form("cmbDisciplinaRemanejamento"))
	intCodGradeCurricularDisciplinaRemanejamento 	= Trim(Request.Form("txtCodGradeRemanejamento"))

    if acao <> "ED" then 

		NomeDisciplina = ""	
		sql=" select DESC_DISCIPLINA from SCA_DISCIPLINA "
		sql=sql & " WHERE COD_DISCIPLINA = " & intCodDisciplina
		rs1.open sql, cnn
		if not rs1.eof then
		   NomeDisciplina			= rs1("DESC_DISCIPLINA")
		end if
		rs1.close	
 
		NomeTurma = ""	
		sql=" select NOMETURMA from SCA_TURMA "
		sql=sql & " WHERE COD_TURMA = " & intCodTurmaRemejamento
		rs1.open sql, cnn
		if not rs1.eof then
		   NomeTurma				= rs1("NOMETURMA")
		end if
		rs1.close	

		JaExiste = "no" 
		sql=" select CODIGO from SCA_ALUNO_DISCIPLINA "
		sql=sql & " WHERE COD_DISCIPLINA = " & intCodDisciplina
		sql=sql & " AND COD_ALUNO = " & strCodAluno
		rs1.open sql, cnn
		if not rs1.eof then
		   JaExiste = "ok"
		end if
		rs1.close	
	end if	

	if acao = "I" then 'incluir disciplinas
	
		if JaExiste = "ok" then
			%>
			<script>
				//alert("Disciplina já pertence a grade do aluno. Verifique!");
				//window.navigate('AlunoDisciplinas_cad.asp');
			</script>
			<%
			'cnn.rollbackTrans
			'response.end
		end if	
	
	
		strMensagem = "Disciplina do aluno incluída com sucesso..."
		
		sql = "INSERT SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, "
		sql = sql & " COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, "
		sql = sql & " COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO, COD_SITUACAO_ACADEMICA)"
		sql = sql & " VALUES ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & strCodAluno & ","
		sql = sql & "" & intCodTurma & ","
		sql = sql & "" & intCodTurmaRemejamento & ","
		sql = sql & "" & intCodGradeCurricularDisciplinaRemanejamento & ","
		sql = sql & "" & intCodGradeCurricularDisciplina & ","
		sql = sql & "" & intCodDisciplina & ","
		sql = sql & "'" & strSituacaoDisciplina & "',"
		if strSituacaoPromocao <> "" and strSituacaoPromocao <> "0" then
			sql = sql & "" & strSituacaoPromocao & ")"
		else
			sql = sql & " null)"
		end if	
		cnn.execute sql
		GravarLog sql

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
		strOcorrencia		= "INCLUSAO DA DISCIPLINA: " & NomeDisciplina & " para a Turma: " & NomeTurma
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%		
		
		
	elseif acao="A" then 'Altera disciplinas
		
		strMensagem = "Disciplina Alterada com sucesso..."
		
		sql = "Update SCA_ALUNO_DISCIPLINA Set"
		sql = sql & " COD_ALUNO = " & strCodAluno & ","
		sql = sql & " COD_TURMA = " & intCodTurma & ","
		sql = sql & " COD_TURMA_REMANEJAMENTO = " & intCodTurmaRemejamento & ","
		sql = sql & " COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO = " & intCodGradeCurricularDisciplinaRemanejamento & ","
		sql = sql & " COD_GRADECURRICULARDISCIPLINA = " & intCodGradeCurricularDisciplina & ","
		sql = sql & " COD_DISCIPLINA = " & intCodDisciplina & ","
		sql = sql & " SITUACAO = '" & strSituacaoDisciplina & "',"
		if strSituacaoPromocao <> "" and strSituacaoPromocao <> "0" then
			sql = sql & " COD_SITUACAO_ACADEMICA = '" & strSituacaoPromocao & "'"
		else
			sql = sql & " COD_SITUACAO_ACADEMICA = null"
		end if
		sql = sql & " Where CODIGO = " & intCodigo
		sql = sql & " and COD_EMPRESA = " & intCodEmpresa
		cnn.execute sql
		GravarLog sql
		
		if strSituacaoPromocaoTodos = "S" then
		
			sql = "Update SCA_ALUNO_DISCIPLINA Set"
			if strSituacaoPromocao <> "" and strSituacaoPromocao <> "0" then
				sql = sql & " COD_SITUACAO_ACADEMICA = '" & strSituacaoPromocao & "'"
			else
				sql = sql & " COD_SITUACAO_ACADEMICA = null"
			end if
			sql = sql & " Where COD_EMPRESA = " & intCodEmpresa
			sql = sql & " and COD_DISCIPLINA = " & intCodDisciplina
			sql = sql & " and COD_TURMA_REMANEJAMENTO = " & intCodTurma
			cnn.execute sql
			GravarLog sql

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
		strOcorrencia		= "ALTERACAO DA DISCIPLINA: " & NomeDisciplina & " para a Turma: " & NomeTurma
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%		
			
	elseif acao="ED" then 'Excluir Disciplina

		NomeDisciplina = ""	
		NomeTurma = ""	
		sql=" select DESC_DISCIPLINA, T.NOMETURMA from SCA_ALUNO_DISCIPLINA AD "
		sql=sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = AD.COD_DISCIPLINA "
		sql=sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = AD.COD_TURMA_REMANEJAMENTO "
		sql=sql & " WHERE AD.CODIGO in (" & cod_excluirDisc & ")"
		rs1.open sql, cnn
		if not rs1.eof then
			while not rs1.eof
				if NomeDisciplina = "" then
					NomeDisciplina			= rs1("DESC_DISCIPLINA") 
					NomeTurma				= rs1("NOMETURMA") 
				else
					NomeDisciplina			= rs1("DESC_DISCIPLINA") & " | " & NomeDisciplina
					NomeTurma				= rs1("NOMETURMA") & " | " & NomeTurma
				end if
				rs1.movenext		   	
			wend
		end if
		rs1.close	
	
		strMensagem = "Disciplina do aluno excluida com sucesso..."

		sql = "Delete From sca_faltas_diaria"
		sql = sql & " where cod_aluno_disciplina in (" & cod_excluirDisc & ")"
		cnn.execute sql
		GravarLog sql


		sql = "Delete From SCA_NOTAS_FALTAS"
		sql = sql & " where cod_aluno_disciplina in (" & cod_excluirDisc & ")"
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete From SCA_ALUNO_DISCIPLINA "
		sql = sql & " where Codigo in (" & cod_excluirDisc & ")"
		cnn.execute sql
		GravarLog sql

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
		strOcorrencia		= "EXCLUSAO DA DISCIPLINA(S): " & NomeDisciplina & " - Turma(s): " & NomeTurma
		%>
		<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%		
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = 'AlunoDisciplinas_cad.asp?txtMatricula=<%=strMatricula%>'
		</script>
		<%
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