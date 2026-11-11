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
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurnoRH			= Trim(Request.Form("cmbTurnoHorario"))
	intCodGrade 			= Trim(Request.Form("cmbGrade"))
	intCodDisciplina		= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodProfessorGeral	= Trim(Request.Form("cmbProfessorGeral"))
	strHiddenNomeTurno	= Trim(Request.Form("txtHiddenNomeTurno"))
	intCodTurmaJuncao 		= "Null"
	intDiaSemana 			= Trim(Request.Form("chkDiaSemana"))
	vetDiaSemana 			= split(intDiaSemana,",")
	strTestaProfessorGeral = "N" 
	if intCodProfessorGeral <> "" and intCodProfessorGeral <> "0" then
	    strTestaProfessorGeral = "S" 
		intCodProfessor = intCodProfessorGeral
	end if
	
	if session("codGrupo") = "2" then
		intCodTurnoAca = Trim(Request.Form("cmbTurnoAca")) 'turno academico
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
		if session("codGrupo") = "2" then
			sql = "Delete h from SCA_horario_aula h "
			sql = sql & " inner join SCA_HORARIO f on f.codigo = h.cod_horario "
			sql = sql & " where h.COD_EMPRESA	= " & intCodEmp
			sql = sql & " AND	h.ANOLETIVO		= " & strAnoLetivo
			sql = sql & " AND	h.SEMESTRE		= " & strSemestre
			sql = sql & " AND	h.Cod_turma		= " & intCodTurma
			sql = sql & " AND	h.Cod_Disciplina= " & intCodDisciplina
			if strHiddenNomeTurno = "INTEGRAL" then
				sql = sql & " AND 	f.CodTurno	= " & intCodTurnoAca
			end if
		else
		
			sql = "Delete h from SCA_horario_aula h "
			sql = sql & " inner join SCA_HORARIO f on f.codigo = h.cod_horario "
			sql = sql & " inner join SCA_turno t on t.Cod_Turno = f.CodTurno"
			sql = sql & " inner join SRH_turno tr on left(tr.Desc_Turno,3) = left(t.Desc_Turno,3) and tr.cod_grupo = " & session("codGrupo")
			sql = sql & " where h.COD_EMPRESA	= " & intCodEmp
			sql = sql & " AND	h.ANOLETIVO		= " & strAnoLetivo
			sql = sql & " AND	h.SEMESTRE		= " & strSemestre
			sql = sql & " AND	h.Cod_turma		= " & intCodTurma
			sql = sql & " AND	h.Cod_Disciplina= " & intCodDisciplina
			if strHiddenNomeTurno = "INTEGRAL" then
				sql = sql & " AND 	tr.Cod_Turno	= " & intCodTurnoRH
			end if
		end if
					
		'if ucase(session("usuarioWeb")) = "SERGIO" then
			'response.write sql
			'response.end
		'end if
		
		cnn.execute sql
		GravarLog sql
		
		MostrarMensagem = "S"
		'Pega a Quantidade Selecionada de semana
		for i = 0 to ubound(vetDiaSemana)		
			
			intCodDiaSemana 	= trim(vetDiaSemana(i))
			intSequenciaAula	= Trim(Request.Form("chkSequenciaAula"&intCodDiaSemana))
			
			if trim(intSequenciaAula) <> "" then MostrarMensagem = "N"
			
			vetSequenciaAula	= split(intSequenciaAula,",")
			
			for j = 0 to ubound(vetSequenciaAula)		
				TotalSequenciaSelecionada = TotalSequenciaSelecionada + 1
			next
		
		next
		
		if MostrarMensagem = "S" then
			%> 
			<script>
				alert("Carga Horaria incompleta!");
				window.history.back();
			</script>
			<%
			response.end
		end if
	
		SaldoAulas = 0
		
		for i = 0 to ubound(vetDiaSemana)

			intCodDiaSemana 	= trim(vetDiaSemana(i))
			intSequenciaAula	= Trim(Request.Form("chkSequenciaAula"&intCodDiaSemana))
			vetSequenciaAula	= split(intSequenciaAula,",")
			
			for ii = 0 to ubound(vetSequenciaAula)
			
				if intCodDisciplina = "0" then
				else
			
					if TotalSequenciaSelecionada  > TotalMatriz then 
						StatusSaldo = "** Carga Horaria Excedida, Total Carga Horario: " & TotalMatriz & ", Verifique! **"
					end if
					
					if TotalSequenciaSelecionada  < TotalMatriz then 
						StatusSaldo = "** Carga Horaria incompleta, Total Carga Horario: " & TotalMatriz & ", Verifique! **"
					end if
				
					if strIngnoraChoqueHorario = "N" then 
						if clng(TotalSequenciaSelecionada) > clng(TotalMatriz) or clng(TotalSequenciaSelecionada ) < clng(TotalMatriz) then
							'cnn.rollbackTrans
							%>
							<script>
								alert("<%=StatusSaldo%>");
								window.history.back();
							</script>
							<%
							response.end
						end if	
					end if
					
				end if	
			
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
					strMensagem = "Registro Salvo com sucesso..."
					
					sql = "Insert Into SCA_horario_aula(COD_EMPRESA, AnoLetivo, Semestre, Cod_turma, Cod_disciplina, diaSemana, "
					sql = sql & " Sequencia, tempo, cod_Colaborador, Colaborador_Outras_Unidades ,cod_horario, Turma_Juncao)"
					sql = sql & " Values ("
					sql = sql & "" & intCodEmp & ","
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & strSemestre & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "" & intCodDisciplina & ","
					sql = sql & "" & intCodDiaSemana & ","
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
					
					if session("codGrupo")="7" then
						'ATUALIZA PONTO - FAIXA 
						sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodProfessor
						cnn.execute sql
					
						'ATUALIZA PONTO - LOTACAO
						sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodProfessor
						cnn.execute sql
					end if
				end if
		
			next
			
		next
		
	elseif acao="E" then
		
		strMensagem = "Registro Excluido com sucesso..."
	
		sql = "Delete h from SCA_horario_aula h "
		sql = sql & " inner join SCA_HORARIO f on f.codigo = h.cod_horario "
		sql = sql & " inner join SCA_turno t on t.Cod_Turno = f.CodTurno"
		sql = sql & " where h.COD_EMPRESA	= " & intCodEmp
		sql = sql & " AND	h.ANOLETIVO		= " & strAnoLetivo
		sql = sql & " AND	h.SEMESTRE		= " & strSemestre
		sql = sql & " AND	h.Cod_turma		= " & intCodTurma
		if intDiaSemana<>"" then
		sql = sql & " AND	h.diaSemana in (" & intDiaSemana & ")"
		end if
		if intCodDisciplina<>"0" then
			sql = sql & " AND	h.Cod_Disciplina= " & intCodDisciplina
		end if
		if strHiddenNomeTurno = "INTEGRAL" then
			sql = sql & " AND 	t.Cod_Turno	= " & intCodTurnoRH
		end if
		if intCodProfessor <> "" and intCodProfessor <> "0" then
			sql = sql & " AND 	h.Cod_Colaborador	= " & intCodProfessor
		end if

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location.href ='sca_horario_aula.asp?cmbTurma=<%=intCodTurma%>&cmbGrade=<%=intCodGrade%>'
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