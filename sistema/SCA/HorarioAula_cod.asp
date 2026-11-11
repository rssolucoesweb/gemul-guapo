<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	strSemestre 		= Trim(Request.Form("cmbSemestre"))

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodSequenciaAula	 	= Trim(Request.Form("cmbSequenciaAula"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	intCodDisciplina		= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodTempoAula			= Trim(Request.Form("cmbTempoAula"))
	intSequeciaAulaMes		= Trim(Request.Form("cmbSequeciaAulaMes"))
	intCodProfessorGeral	= Trim(Request.Form("cmbProfessorGeral"))
	intCodHorario			= Trim(Request.Form("cmbHorario"))
	strData	 				= Trim(Request.Form("txtData"))
	intCodTurmaJuncao 		= Trim(Request.Form("cmbTurmaJuncao"))
	
	if intCodTurmaJuncao = "" then intCodTurmaJuncao = "0"
	if intSequeciaAulaMes = "" then intSequeciaAulaMes = "0"
	if intCodProfessor = "" then intCodProfessor = "0"
	
	strHorarioData = "N"
	sql = " SELECT top 1 Horario_Aula_Diario"
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strHorarioData = rs("Horario_Aula_Diario")
		if isnull(strHorarioData) then strHorarioData = "N"
	end if
	rs.close

	strTestaProfessorGeral = "N" 
	if intCodProfessorGeral <> "" and intCodProfessorGeral <> "0" then
	    strTestaProfessorGeral = "S" 
		intCodProfessor = intCodProfessorGeral
	end if
	
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
	
	sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
	sql = sql & " where cod_empresa = " & intCodEmp
	sql = sql & " and cod_turma = " & intCodTurma
	sql = sql & " and anoLetivo = " & strAnoLetivo
	sql = sql & " and semestre = " & strSemestre
	sql = sql & " GROUP BY cod_turma "
	RSAUX.OPEN SQL, CNN
	IF NOT RSAUX.EOF THEN
		Horario = "SIM - "& RSAUX("total") & " Aula(s)" 
		if isnull(RSAUX("total")) then
		   Horario = "NÃO"
		end if   
	END IF
	RSAUX.CLOSE
	
	'BUSCA SE A TURMA POSSUI MATRIZ CADASTRADA
	Matriz = "NÃO"
	sql = " SELECT "
	sql = sql & " SUM(GD.Ch_Semanal) as total "
	sql = sql & " FROM SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
	sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
	sql = sql & " WHERE T.COD_EMPRESA = " & intCodEmp
	sql = sql & " AND COD_TURMA = " & intCodTurma
	RSAUX.OPEN SQL, CNN
	IF NOT RSAUX.EOF THEN
		Matriz = "SIM - "& RSAUX("total") & " Aula(s)" 
		if isnull(RSAUX("total")) then
		   Matriz = "NÃO"
		end if   
	END IF
	RSAUX.CLOSE
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."

		' Checando choque de disciplina
		sql = "select codigo from SCA_HORARIO_AULA"
		sql = sql & " WHERE	COD_EMPRESA		= " & Session("CodEmpresa")	
		sql = sql & " AND	ANOLETIVO		= " & strAnoLetivo
		sql = sql & " AND	SEMESTRE		= " & strSemestre
		sql = sql & " AND	Cod_turma		= " & intCodTurma
		if strHorarioData = "N" then
			sql = sql & " AND	DIASEMANA		= " & intCodDiaSemana
		else
			sql = sql & " AND	DATA		= '" & formatadataBD(strData) & "'"
		end if	
		sql = sql & " AND	SEQUENCIA		= " & intCodSequenciaAula
		sql = sql & " AND	TEMPO			= " & intCodTempoAula
		rs.open sql, cnn
		if not rs.eof then
			%>
			<script>
				alert("ATENÇÃO: Já existe uma Disciplina cadastrada para esse horário, verifique o choque.");
				//window.history.back();
			</script>
			<%
			'response.end
		end if
		rs.close	
		
		' Checando Duplicidade de lançamento
		sql = "select codigo from SCA_HORARIO_AULA"
		sql = sql & " WHERE	COD_EMPRESA		= " & intCodEmp
		sql = sql & " AND	ANOLETIVO		= " & strAnoLetivo
		sql = sql & " AND	SEMESTRE		= " & strSemestre
		sql = sql & " AND	Cod_turma		= " & intCodTurma
		sql = sql & " AND	DIASEMANA		= " & intCodDiaSemana
		sql = sql & " AND	SEQUENCIA		= " & intCodSequenciaAula
		sql = sql & " AND	TEMPO			= " & intCodTempoAula
		sql = sql & " AND	Cod_Disciplina	= " & intCodDisciplina
		rs.open sql, cnn
		if not rs.eof then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Lançamento realizado em Duplicidade. Verifique!");
				window.location='HorarioAula_cad.asp';
			</script>
			<%
			response.end
		end if
		rs.close		
	
		'CHAVE   para controle de choque  - ano.semestre.turma.empresa.diadasemana.sequencia.tempo.disciplina
		sql = "Insert Into SCA_horario_aula(COD_EMPRESA, AnoLetivo, Semestre, Cod_turma, Cod_disciplina, Data, diaSemana, Sequencia, tempo, TipoAula, cod_Colaborador, Colaborador_Outras_Unidades ,cod_horario, Turma_Juncao)"
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
		if strData <> "" then
			intCodDiaSemana = weekday(Trim(strData))
			sql = sql & "'" & formatadataBD(Trim(strData)) & "',"
			sql = sql & "" & intCodDiaSemana & ","
		else
			sql = sql & "NULL, "
			sql = sql & "" & intCodDiaSemana & ","
		end if	
		sql = sql & "" & intCodSequenciaAula & ","
		sql = sql & "" & intCodTempoAula & ","
		sql = sql & "" & intSequeciaAulaMes & ","
		sql = sql & "" & intCodProfessor & ","
		sql = sql & "'" & strTestaProfessorGeral & "',"
		sql = sql & "" & intCodHorario & ","
		IF intCodTurmaJuncao <> "0" THEN
		   sql = sql & "" & intCodTurmaJuncao & ")"
		ELSE   
		   sql = sql & "NULL)"
		END IF   

	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_horario_aula set cod_Colaborador = " & intCodProfessor & ","
		sql = sql & " Colaborador_Outras_Unidades = '" & strTestaProfessorGeral & "',"
		sql = sql & " Cod_disciplina = " & intCodDisciplina & ","
		if strData <> "" then
			intCodDiaSemana = weekday(Trim(strData))
			sql = sql & " data = '" & formatadataBD(Trim(strData)) & "',"
			sql = sql & " diaSemana = " & intCodDiaSemana & ","
		else
		   	sql = sql & " data = null, "
			sql = sql & " diaSemana = " & intCodDiaSemana & ","
		end if   
		sql = sql & " Sequencia = " & intCodSequenciaAula & ","
		if intSequeciaAulaMes <> "0" then
		  sql = sql & " TipoAula = " & intSequeciaAulaMes & ","
		else
		   sql = sql & " TipoAula = null, "
		end if   
		
		sql = sql & " tempo = " & intCodTempoAula & ","
		sql = sql & " cod_horario = " & intCodHorario & ","
		
		if intCodTurmaJuncao <> "0" then
		   sql = sql & " Turma_Juncao = " & intCodTurmaJuncao
		else
		   sql = sql & " Turma_Juncao = null"
		end if 
		  
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and	COD_EMPRESA	= " & intCodEmp
	elseif acao="E" then
		
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_horario_aula "
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
			window.location='HorarioAula_cad.asp?cmbCurso=<%=intCodCurso%>';
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