<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")

	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodSequenciaAula	 	= Trim(Request.Form("cmbSequenciaAula"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	intCodDisciplina		= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodTempoAula			= Trim(Request.Form("cmbTempoAula"))
	intCodProfessor			= Trim(Request.Form("cmbProfessor"))
	intCodHorario			= Trim(Request.Form("cmbHorario"))
	intCodTurmaJuncao 		= Trim(Request.Form("cmbTurmaJuncao"))
 	strData         		= formatadataBD(Trim(Request.Form("txtData")))
	
	IF intCodTurma <> "0" THEN
		sql = "SELECT COD_SEMESTRE" 
		sql = sql & " FROM SCA_TURMA"
		sql = sql & " WHERE COD_TURMA = " & intCodTurma
		sql = sql & " AND COD_EMPRESA = " & intCodEmp
		rs.open sql, cnn
		if not RS.EOF then
			strSemestre = RS("COD_SEMESTRE")
		end if
		rs.close
	END IF
	
	
			
	if acao="I" then
		'CHAVE   para controle de choque  - ano.semestre.turma.empresa.diadasemana.sequencia.tempo.disciplina
		strMensagem = "Registro Salvo com sucesso..."
		sql = "select codigo from SCA_HORARIO_AULA_EXTRA"
		sql = sql & " WHERE	COD_EMPRESA		= " & Session("CodEmpresa")	
		sql = sql & " AND	ANOLETIVO		= " & strAnoLetivo
		sql = sql & " AND	SEMESTRE		= " & strSemestre
		sql = sql & " AND	Cod_turma		= " & intCodTurma
		sql = sql & " AND	DIASEMANA		= " & intCodDiaSemana
		sql = sql & " AND	SEQUENCIA		= " & intCodSequenciaAula
		sql = sql & " AND	TEMPO			= " & intCodTempoAula
		sql = sql & " AND	Cod_Disciplina	= " & intCodDisciplina
		rs.open sql, cnn
		if not rs.eof then
			%>
			<script>
				alert("ATENÇÃO: Já existe uma Disciplina cadastrada para esse horário, verifique o choque.");
			</script>
			<%
		end if
		rs.close	
			
		sql = "Insert Into SCA_horario_aula_extra(COD_EMPRESA, AnoLetivo, Semestre, Cod_turma, Cod_disciplina, diaSemana, Sequencia, tempo, cod_Colaborador, cod_horario, Turma_Juncao, Data)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & "" & intCodTurma & ","
		IF intCodDisciplina = "0" THEN
			sql = sql & "NULL, "
		ELSE
			sql = sql & "" & intCodDisciplina & ","
		END IF
		sql = sql & "" & intCodDiaSemana & ","
		sql = sql & "" & intCodSequenciaAula & ","
		sql = sql & "" & intCodTempoAula & ","
		IF intCodProfessor = "0" THEN
			sql = sql & "NULL, "
		ELSE
			sql = sql & "" & intCodProfessor & ","
		END IF
		sql = sql & "" & intCodHorario & ","
		IF intCodTurmaJuncao <> "0" THEN
		   sql = sql & "" & intCodTurmaJuncao & ","
		ELSE   
		   sql = sql & "NULL,"
		END IF   
		sql = sql & "'" & strdata & "')"

	elseif acao="A" then
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_horario_aula_extra set " 
		sql = sql & " cod_horario = " & intCodHorario & ","
        sql = sql & " Cod_turma = " & intCodTurma & ","
        sql = sql & " Cod_disciplina = " & intCodDisciplina & ","
        sql = sql & " diaSemana = " & intCodDiaSemana & ","
        sql = sql & " Sequencia = " & intCodSequenciaAula & ","
        sql = sql & " tempo = " & intCodTempoAula & ","
  		IF intCodProfessor = "0" THEN
			sql = sql & " cod_Colaborador = NULL, "
		ELSE
			sql = sql & " cod_Colaborador = " & intCodProfessor & ","
		END IF
		if intCodTurmaJuncao <> "0" then
		   sql = sql & " Turma_Juncao = " & intCodTurmaJuncao & ","
		else
		   sql = sql & " Turma_Juncao = null" & ","
		end if   
		sql = sql & " data = '" & strdata & "'"

		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and	COD_EMPRESA	= " & intCodEmp
		
	elseif acao="E" then
		
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_horario_aula_extra "
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and	COD_EMPRESA	= " & intCodEmp
		
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='HorarioAulaExtra_cad.asp?cmbCurso=<%=intCodCurso%>';
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