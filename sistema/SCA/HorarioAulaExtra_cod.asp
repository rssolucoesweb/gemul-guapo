<!--
	::	DESENVOLVIDO POR ASCED
	::	Data de Criação...: 05/11/2014
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
	::	Objetivo Pagina...: Horario de Aula Extra
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strDataLancamento 		= formataDataBD(Trim(Request.Form("txtDataLancamento")))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodGrade 			= Trim(Request.Form("cmbGrade"))
	intCodDisciplina		= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodProfessorGeral	= Trim(Request.Form("cmbProfessorGeral"))
	intCodTurmaJuncao 		= "Null"
	intCodTurnoRH 			= Trim(Request.Form("cmbTurnoHorario"))
	intDiaSemana 			= Trim(Request.Form("chkDiaSemana"))
	vetDiaSemana 			= split(intDiaSemana,",")
	
	strTestaProfessorGeral = "N" 
	if intCodProfessorGeral <> "" and intCodProfessorGeral <> "0" then
	    strTestaProfessorGeral = "S" 
		intCodProfessor = intCodProfessorGeral
	end if

	strIngnoraChoqueHorario = "N"
	
	sql = " SELECT top 1 isnull(Ingnora_Choque_Horario,'N') as Ingnora_Choque_Horario "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strIngnoraChoqueHorario = rs("Ingnora_Choque_Horario")
	end if
	rs.close
	
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
	
	'BUSCA SE A TURMA POSSUI MATRIZ CADASTRADA
	Matriz = "NÃO"
	sql = " SELECT "
	sql = sql & " SUM(GD.Ch_Semanal) as total "
	sql = sql & " FROM SCA_TURMA T "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.SITUACAO = 'A' "
	sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
	sql = sql & " WHERE T.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND COD_TURMA = " & intCodTurma
	sql = sql & " and Cod_Disciplina = " & intCodDisciplina
	RSAUX.OPEN SQL, CNN
	IF NOT RSAUX.EOF THEN
		TotalMatriz = RSAUX("total")
		if isnull(RSAUX("total")) then
		   TotalMatriz = "0"
		end if   
	END IF
	RSAUX.CLOSE

	if acao="I" then
		
		sql = "Delete E From SCA_HORARIO_AULA_EXTRA E "
		sql = sql & " inner join SCA_HORARIO H on H.CODIGO = E.cod_horario"
		sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = H.CODTURNO"
		sql = sql & " INNER JOIN SRH_TURNO T_RH ON LEFT(T_RH.Desc_Turno,3) = LEFT(T.Desc_Turno,3) AND T_RH.COD_GRUPO="&SESSION("CODGRUPO")
		sql = sql & " where E.COD_EMPRESA		= " & intCodEmp
		sql = sql & " AND	E.ANOLETIVO			= " & strAnoLetivo
		sql = sql & " AND	E.SEMESTRE			= " & strSemestre
		sql = sql & " AND	E.Cod_turma			= " & intCodTurma
		sql = sql & " AND	E.Cod_Disciplina	= " & intCodDisciplina
		sql = sql & " AND   E.DataLancamento 	= '" &  formataDataBD(Trim(strDataLancamento)) & "'"
		sql = sql & " AND T_RH.COD_TURNO 		= " & intCodTurnoRH
		cnn.execute sql
		GravarLog sql
		
		SaldoAulas = 0
		
		for i = 0 to ubound(vetDiaSemana)

			intCodDiaSemana 	= trim(vetDiaSemana(i))
			intSequenciaAula	= Trim(Request.Form("chkSequenciaAula"&intCodDiaSemana))
			vetSequenciaAula	= split(intSequenciaAula,",")
			
			for ii = 0 to ubound(vetSequenciaAula)
			
				intCodHorario = vetSequenciaAula(ii) 
				
				sql = "SELECT Codigo, cod_empresa, anoLetivo, semestre, horario, Sequencia_Aulas, Tempo "
				sql = sql & " FROM SCA_HORARIO"
				sql = sql & " where cod_empresa = " & Session("CodEmpresa")
				sql = sql & " and Codigo = " & intCodHorario
				RSAUX.OPEN SQL, CNN
				IF NOT RSAUX.EOF THEN
					intCodSequenciaAula 	= RSAUX("Sequencia_Aulas")
					intCodTempoAula 		= RSAUX("Tempo")
				END IF
				RSAUX.CLOSE
						
				if trim(intCodSequenciaAula) <> "0" then 
			
					'CHAVE   para controle de choque  - ano.semestre.turma.empresa.diadasemana.sequencia.tempo.disciplina
					strMensagem = "Horario de Aula EXTRA Salvo com sucesso..."
					
					sql = "Insert Into SCA_HORARIO_AULA_EXTRA(COD_EMPRESA, AnoLetivo, Semestre, Cod_turma, Cod_disciplina, DataLancamento, "
					sql = sql & " Sequencia, tempo, cod_Colaborador, Colaborador_Outras_Unidades ,cod_horario, Turma_Juncao)"
					sql = sql & " Values ("
					sql = sql & "" & intCodEmp & ","
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & strSemestre & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "" & intCodDisciplina & ","
					sql = sql & "'" & strDataLancamento & "',"
					sql = sql & "" & intCodSequenciaAula & ","
					sql = sql & "" & intCodTempoAula & ","
					sql = sql & "" & intCodProfessor & ","
					
					IF strTestaProfessorGeral = "0" THEN
						sql = sql & "NULL, "
					ELSE
						sql = sql & "'" & strTestaProfessorGeral & "',"
					END IF
				
					sql = sql & "" & intCodHorario & ","
					
					IF intCodTurmaJuncao <> "0" THEN
					   sql = sql & "" & intCodTurmaJuncao & ")"
					ELSE   
					   sql = sql & "NULL)"
					END IF  
				
					cnn.execute sql
					GravarLog sql
			
				end if
		
			next
			
		next
		
		'Volta a Data 
		strDataLancamento 		= formataDataAP(Trim(Request.Form("txtDataLancamento")))

		
	elseif acao="E" then
		
		strMensagem = "Horario de Aula EXTRA Excluido com sucesso..."
		
		sql = "Delete E From SCA_HORARIO_AULA_EXTRA E "
		sql = sql & " inner join SCA_HORARIO H on H.CODIGO = E.cod_horario"
		sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = H.CODTURNO"
		sql = sql & " INNER JOIN SRH_TURNO T_RH ON LEFT(T_RH.Desc_Turno,3) = LEFT(T.Desc_Turno,3) AND T_RH.COD_GRUPO="&SESSION("CODGRUPO")
		sql = sql & " where E.COD_EMPRESA		= " & intCodEmp
		sql = sql & " AND	E.ANOLETIVO			= " & strAnoLetivo
		sql = sql & " AND	E.SEMESTRE			= " & strSemestre
		sql = sql & " AND	E.Cod_turma			= " & intCodTurma
		sql = sql & " AND	E.Cod_Disciplina	= " & intCodDisciplina
		sql = sql & " AND   E.DataLancamento 	= '" &  formataDataBD(Trim(strDataLancamento)) & "'"
		sql = sql & " AND 	T_RH.COD_TURNO 		= " & intCodTurnoRH
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location.href ='HorarioAulaExtra_cad.asp?cmbTurnoHorario=<%=intCodTurnoRH%>&cmbTurma=<%=intCodTurma%>&cmbGrade=<%=intCodGrade%>&txtDataLancamento=<%=strDataLancamento%>'
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