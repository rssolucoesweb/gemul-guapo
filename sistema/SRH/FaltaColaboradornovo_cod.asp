<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma transação--------------
	'cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	enviarFalta									= Trim(Request.QueryString("enviarFalta"))
	CodRegistroMestre							= Trim(Request.QueryString("CodRegistroMestre"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodProfessor	         	 				= Trim(Request("cmbColaboradorFrequencia")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	intCodTurnoFaltas 							= Trim(Request.form("cmbTurnoFaltas"))

	
	if intCodProfessor <> "" and intCodProfessor <> "0"  then
		sql = " select distinct Situacao_disciplinar, tipoModulacao, M.Ano_Letivo, M.Semestre "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M " 
		sql = sql & " INNER JOIN SRH_TURNO TRH	ON TRH.Cod_Turno = M.Cod_Turno"
		sql = sql & " INNER JOIN SCA_TURNO TU		ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)"
		sql = sql & " where M.Cod_Colaborador = " & intCodProfessor 
		sql = sql & " and M.Cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " and M.Status = 'A' "
		IF intCodTurnoFaltas <> "0" THEN
			sql = sql & " and TU.COD_TURNO=" & intCodTurnoFaltas
		END IF
		rs.open sql, cnn
		if rs.eof = false then
		    if trim(rs("tipoModulacao")) = "PROFESSOR" then
				strOptTipoColaborador 	= "1"
			else
				strOptTipoColaborador 	= "0"
			end if
			strTipoLancamento 		= rs("Situacao_disciplinar")
			strAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if	
		rs.close
	end if


	if strSimouNao = "" then
	   strSimouNao = "N"
	end if 
	  
	if acao="I" then

		sql = " select * from SRH_COLABORADOR_FREQUENCIA " 
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")  
		sql = sql & " and cod_colaborador = " & intCodProfessor 
		sql = sql & " and convert(datetime,convert(varchar, DataFalta, 103),103) >= convert(datetime, ' " & formatadataAP(strDataLancamento) & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, DataFalta, 103),103) <= convert(datetime, ' " & formatadataAP(strDataLancamentoFinal) & " ',103) "
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("ATENÇÃO: Falta já lancada para esse Colaborador. Verifique!");
				window.location='FaltaColaboradorNovo_Cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
	
		strMensagem = "Registro Incluido com sucesso..."
	
		'Salvar as faltas interdisciplinar
		if strTipoLancamento = "I" then 
		
			sql = " SELECT DISTINCT "
			sql = sql & " HA.cod_turma, " 
			sql = sql & " T.NomeTurma, "
			sql = sql & " TRH.Cod_Turno, "
			sql = sql & " '0' as CodColaboradorSubstituido "
			sql = sql & " FROM  SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")
			sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
			sql = sql & " and T.Situacao = 'A' " 
			sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and HA.anoletivo = " & strAnoLetivo
			sql = sql & " and HA.semestre in (" & intSemestre & ")"
			if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
				'sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
				sql = sql & " and (CASE WHEN SUBSTRING(T.NomeTurma,6,1) <> 'I' then t.cod_turno else " & intCodTurnoFaltas & " END) = " & intCodTurnoFaltas
			end if
	
			sql = sql & " UNION "
			
			sql = sql & " SELECT " 
			sql = sql & " (SELECT DISTINCT top 1 HA.cod_turma " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo") 
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
			
			sql = sql & " (SELECT DISTINCT top 1 NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
			
			sql = sql & " isnull(CS.CodColaboradorSubstituido,'0') as CodColaboradorSubstituido, "
			
			sql = sql & " (SELECT DISTINCT top 1 TRH.Cod_Turno " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS Cod_Turno "
			
			sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
			sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.CodColaboradorSubstituto = MD.Cod_Colaborador AND CS.Situacao = 'A' "  
			sql = sql & " LEFT JOIN SRH_TURNO TRH ON TRH.Cod_Turno = MD.Cod_Turno "   
			sql = sql & " LEFT JOIN SCA_TURNO TU ON SUBSTRING(TU.Desc_Turno,1,3) = SUBSTRING(TRH.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")
			sql = sql & " WHERE MD.Cod_Colaborador = " & intCodProfessor
			sql = sql & " and MD.Ano_Letivo = " & strAnoLetivo
			sql = sql & " and MD.Semestre in (" & intSemestre & ")"
			sql = sql & " AND MD.Status = 'A' "
			sql = sql & " and ISNULL((SELECT DISTINCT top 1 NOMETURMA "   
			sql = sql & " FROM SCA_HORARIO_AULA HA "  
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "    
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")   
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular "   
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "    
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "   
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "  
			sql = sql & " AND HA.Semestre = MD.Semestre "  
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "  
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "  
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "  
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),'0')<>'0' "  
			if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
				'sql = sql & " and tu.cod_turno = " & intCodTurnoFaltas
				sql = sql & " and (CASE WHEN SUBSTRING( "
				sql = sql & " (SELECT DISTINCT top 1 NOMETURMA " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")  
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),6,1) <> 'I' then tu.cod_turno else " & intCodTurnoFaltas & " END) = " & intCodTurnoFaltas
			end if
	'if ucase(session("usuarioWeb")) = "CLEOVIS"  THEN
	'	response.write "<hr>" & sql
	'	response.write "<hr>"
	'	response.end	
	'end if			
			rs.open sql, cnn
			if rs.eof = false then
			
				 while not rs.eof
			
					strDataLancamentoCompara 		= strDataLancamento
					strDataLancamentoFinalCompara 	= strDataLancamentoFinal
					TotalFaltaTurma 				= 0
					strTurmaLocalizada 				= ""
					
					do while true


						sql = " SELECT DISTINCT "
						sql = sql & " HA.cod_turma, " 
						sql = sql & " T.NomeTurma, "
						sql = sql & " HA.DiaSemana "
						sql = sql & " FROM  SCA_HORARIO_AULA HA "
						sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
						sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
						sql = sql & " and T.Situacao = 'A' " 
						sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
						sql = sql & " and HA.anoletivo = " & strAnoLetivo
						sql = sql & " and HA.semestre in (" & intSemestre & ")"
						sql = sql & " and HA.diasemana = " & weekday(strDataLancamentoCompara) 
						sql = sql & " union"
						sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, '0' as DiaSemana "
						sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
						sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
						sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
						sql = sql & " and T.Situacao = 'A' "
						sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
						sql = sql & " and HA.anoletivo = " & strAnoLetivo
						sql = sql & " and HA.semestre in (" & intSemestre & ")"
						rsAux.open sql, cnn
						IF rsAux.EOF = false THEN
							TotalFaltaTurma = TotalFaltaTurma + 1
						end if
						rsAux.close 
						if ucase(session("usuarioWeb")) = "SERGIO"  THEN
							'response.write "<hr>" & sql
							'response.write "<hr>"
							'response.end	
						end if	
						 
						 
						if TotalFaltaTurma > 0 then
	
							sql = "Insert Into SRH_COLABORADOR_FREQUENCIA(cod_empresa, Cod_JustificativaFaltas, CodReferencia, ano_letivo, semestre_letivo, DATAFALTA, Datalancamento, DataLancamentoFinal, DataDiaLancamento, "
							sql = sql & " tipo_colaborador, cod_turma, cod_colaborador, cod_disciplina, numero_falta, "
							sql = sql & " justificativa, numero_aula, "
							sql = sql & " situacao, justificativa_abono, fechamento, tipoLancamento, cod_turno )"
							sql = sql & " Values ("
							sql = sql & "" & intCodEmp & ","
							sql = sql & "" & intCodJustificativaFaltas & ","
							sql = sql & "" & intCodModulacaoReferencia & ","
							sql = sql & "" & strAnoLetivo & ","
							sql = sql & "" & intSemestre & ","
							sql = sql & "'" & formatadataBD(strDataLancamentoCompara) & "',"
							sql = sql & "'" & formatadataBD(strDataLancamento) & "',"
							sql = sql & "'" & formatadataBD(strDataLancamentoFinal) & "',"
							sql = sql & "'" & formatadataBD(date) & "',"
							sql = sql & "'" & strOptTipoColaborador & "',"
							sql = sql & "" & trim(rs("cod_turma")) & ","
							sql = sql & "" & intCodProfessor & ","
							sql = sql & " null ," 'intCodDisciplina - Neste caso nao tenho a disciplina
							sql = sql & "" & TotalFaltaTurma & ","
							if strJustificativa <> "" then
								sql = sql & "'" & strJustificativa & "',"
							else 
								sql = sql &" null ,"
							end if
							if intQtdeAula <> "" then
								sql = sql & "" & intQtdeAula & ","
							else 
								sql = sql &" null ,"
							end if
							if strSimouNao <> "" then
								sql = sql & "'" & strSimouNao & "',"
							else 
								sql = sql &" null ,"
							end if
							if strJustificativaAbono <> "" then
								sql = sql & "'" & strJustificativaAbono & "',"
							else 
								sql = sql &" null ,"
							end if
							if strFechamento <> "" then
								sql = sql & "'" & strFechamento & "',"
							else 
								sql = sql &" null,"
							end if
							sql = sql & "'" & strTipoLancamento & "',"
							if trim(rs("Cod_Turno")) <> "0" and trim(rs("Cod_Turno")) <> "" then
								sql = sql & "'" & trim(rs("Cod_Turno")) & "')"
							else
								sql = sql & "null)"
							end if
							cnn.execute sql
							GravarLog sql
							
							TotalFaltaTurma = 0
							
						end if
						
						strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
						
						if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
							exit do
						end if
						
					loop
					
					rs.movenext
					
				wend
			end if	
			rs.close
		end if
		
		'Salvar as faltas Disciplinares
		if strTipoLancamento = "D" then 
			
			strTurmaLocalizada  = ""
			
			if strDataLancamento = strDataLancamentoFinal then 
				sql = " SELECT DISTINCT HA.cod_turma, T.NomeTurma, D.Cod_Disciplina, D.Desc_Disciplina, HA.diasemana, HA.Sequencia, '0' as CodColaboradorSubstituido, TRH.Cod_Turno "
			else
				sql = " SELECT DISTINCT HA.cod_turma, T.NomeTurma, D.Cod_Disciplina, D.Desc_Disciplina, '0' as CodColaboradorSubstituido, TRH.Cod_Turno "
			end if
			sql = sql & " FROM SCA_HORARIO_AULA HA " 
		'	sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			
			'----------------------------------------------------------------------------------
			'11/11/2016 - sergio borges
			'foi alterado por não estava pegando o turno do horario de aula da unidade e sim da turma
			sql = sql & " inner join SCA_HORARIO o on o.codigo = ha.cod_horario"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = o.CodTurno "
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")
			'----------------------------------------------------------------------------------	


			'sql = sql & " FROM SCA_HORARIO_AULA HA " 
			'sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma " 
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HA.Cod_Disciplina " 
			sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
			sql = sql & " and T.Situacao = 'A' " 
			sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
				sql = sql & " and HA.anoletivo = " & strAnoLetivo
			sql = sql & " and HA.semestre in (" & intSemestre & ")"
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
				sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
			end if
			'-
			sql = sql & " UNION "
			'-
			sql = sql & " SELECT "
			'
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " (SELECT DISTINCT top 1 HA.COD_TURMA " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")  
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
				'
				sql = sql & " (SELECT DISTINCT top 1 T.NOMETURMA " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")  
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
				'
				sql = sql & " MD.Cod_Disciplina, "
				'
				sql = sql & " D.Desc_Disciplina, "
				'
				sql = sql & " (SELECT DISTINCT top 1 HA.diasemana " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)  AND TRH.COD_GRUPO = " & session("codGrupo") 
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno) AS diasemana, "
				'
				sql = sql & " (SELECT DISTINCT top 1 HA.Sequencia " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)  AND TRH.COD_GRUPO = " & session("codGrupo") 
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular  " 
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno) AS Sequencia, "
				'
				sql = sql & " CS.CodColaboradorSubstituido, "
				'
				sql = sql & " (SELECT DISTINCT top 1 TRH.Cod_Turno " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)  AND TRH.COD_GRUPO = " & session("codGrupo")
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS Cod_Turno "
				'
			else
				sql = sql & " (SELECT DISTINCT top 1 HA.COD_TURMA " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)  AND TRH.COD_GRUPO = " & session("codGrupo")
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
				'
				sql = sql & " (SELECT DISTINCT top 1 T.NOMETURMA " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)  AND TRH.COD_GRUPO = " & session("codGrupo")
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
				'
				sql = sql & " MD.Cod_Disciplina, "
				'
				sql = sql & " D.Desc_Disciplina, "
				'
				sql = sql & " CS.CodColaboradorSubstituido, "
				'
				sql = sql & " (SELECT DISTINCT top 1 T.Cod_Turno " 
				sql = sql & " FROM SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
				sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo") 
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
				sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
				sql = sql & " AND HA.Semestre = MD.Semestre "
				sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
				sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
				sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
				sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
				if strDataLancamento = strDataLancamentoFinal then 
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
				end if
				sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS Cod_Turno "
				'
			end if
			sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
			sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.CodColaboradorSubstituto = MD.Cod_Colaborador AND CS.Situacao = 'A' " 
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = MD.Cod_Disciplina " 
			sql = sql & " WHERE MD.Cod_Colaborador = " & intCodProfessor
			sql = sql & " and MD.Ano_Letivo = " & strAnoLetivo
			sql = sql & " and MD.Semestre in (" & intSemestre & ")"
			sql = sql & " AND MD.Status = 'A' "
			sql = sql & " and ISNULL((SELECT DISTINCT top 1 NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3)  AND TRH.COD_GRUPO = " & session("codGrupo")
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
				sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),'0')<>'0' "
			rs.open sql, cnn
			if rs.eof = false then
			
				 while not rs.eof
				 
					TotalFaltaTurmaDisciplina 		= 0
					intCodHorario 					= 0
					strDataLancamentoCompara 		= strDataLancamento
					strDataLancamentoFinalCompara 	= strDataLancamentoFinal
					
					do while true
		
						sql = " SELECT HA.CODIGO, HA.cod_turma, T.NomeTurma, HA.DiaSemana "
						sql = sql & " FROM SCA_HORARIO_AULA HA " 
						sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma " 
						sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
						sql = sql & " and T.Situacao = 'A' " 
						sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
						sql = sql & " and HA.anoletivo = " & strAnoLetivo
						sql = sql & " and HA.semestre in (" & intSemestre & ")"
						sql = sql & " and HA.diasemana = " & weekday(strDataLancamentoCompara) 
						sql = sql & " and HA.cod_turma = " & trim(rs("cod_turma"))
						sql = sql & " and HA.Cod_Disciplina = " & trim(rs("Cod_Disciplina"))
						if strDataLancamento = strDataLancamentoFinal then 
							sql = sql & " and HA.Sequencia = " & trim(rs("Sequencia"))
						end if
						'response.write sql & "<br><br><br><br>"  
						rsAux.open sql, cnn
						IF rsAux.EOF = false THEN
							intCodHorario = trim(rsAux("CODIGO"))
							 while not rsAux.eof
								TotalFaltaTurmaDisciplina = TotalFaltaTurmaDisciplina + 1
								rsAux.movenext
							 wend
						end if
						rsAux.close  

						if TotalFaltaTurmaDisciplina > 0 then
	
							sql = "Insert Into SRH_COLABORADOR_FREQUENCIA(cod_empresa, Cod_JustificativaFaltas, CodReferencia, ano_letivo, semestre_letivo, DATAFALTA, Datalancamento, DataLancamentoFinal, DataDiaLancamento, "
							sql = sql & " tipo_colaborador, cod_turma, cod_colaborador, cod_disciplina, numero_falta, "
							sql = sql & " justificativa, numero_aula, "
							sql = sql & " situacao, justificativa_abono, fechamento, tipoLancamento, cod_turno )"
							sql = sql & " Values ("
							sql = sql & "" & intCodEmp & ","
							sql = sql & "" & intCodJustificativaFaltas & ","
							sql = sql & "" & intCodModulacaoReferencia & ","
							sql = sql & "" & strAnoLetivo & ","
							sql = sql & "" & intSemestre & ","
							sql = sql & "'" & formatadataBD(strDataLancamentoCompara) & "',"
							sql = sql & "'" & formatadataBD(strDataLancamento) & "',"
							sql = sql & "'" & formatadataBD(strDataLancamentoFinal) & "',"
							sql = sql & "'" & formatadataBD(date) & "',"
							sql = sql & "'" & strOptTipoColaborador & "',"
							sql = sql & "" & trim(rs("cod_turma")) & ","
							sql = sql & "" & intCodProfessor & ","
							sql = sql & "" &trim(rs("Cod_Disciplina"))& "," 'intCodDisciplina - Neste caso nao tenho a disciplina
							sql = sql & "" & TotalFaltaTurmaDisciplina & ","
							if strJustificativa <> "" then
								sql = sql & "'" & strJustificativa & "',"
							else 
								sql = sql &" null ,"
							end if
							if intQtdeAula <> "" then
								sql = sql & "" & intQtdeAula & ","
							else 
								sql = sql &" null ,"
							end if
							if strSimouNao <> "" then
								sql = sql & "'" & strSimouNao & "',"
							else 
								sql = sql &" null ,"
							end if
							if strJustificativaAbono <> "" then
								sql = sql & "'" & strJustificativaAbono & "',"
							else 
								sql = sql &" null ,"
							end if
							if strFechamento <> "" then
								sql = sql & "'" & strFechamento & "',"
							else 
								sql = sql &" null,"
							end if
							sql = sql & "'" & strTipoLancamento & "',"
							if trim(rs("Cod_Turno")) <> "0" and trim(rs("Cod_Turno")) <> "" then
								sql = sql & "'" & trim(rs("Cod_Turno")) & "')"
							else
								sql = sql & "null)"
							end if
							cnn.execute sql
							GravarLog sql
							
							TotalFaltaTurmaDisciplina = 0
							
						end if

						strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
						
						if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
							exit do
						end if
						
					loop
					
					rs.movenext
					
				wend
			end if	
			rs.close
		
		end if	
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
	elseif acao = "E" then
		
		strMensagem = "Registro Excluido com sucesso..."

		sql = " SELECT F.CODIGO, "
		sql = sql & " F.ANO_LETIVO, "
		sql = sql & " F.SEMESTRE_LETIVO, "
		sql = sql & " F.Cod_JustificativaFaltas, "
		sql = sql & " F.codReferencia, "
		sql = sql & " F.DATALANCAMENTO, "
		sql = sql & " F.DATALANCAMENTOFINAL, "
		sql = sql & " F.DataDiaLancamento, "
		sql = sql & " F.COD_COLABORADOR, "
		sql = sql & " F.COD_TURMA, "
		sql = sql & " F.COD_DISCIPLINA, "
		sql = sql & " F.COD_TURNO "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA F "
		sql = sql & " WHERE CODIGO = " & intCodigo
		rs.open sql, cnn		
		if rs.eof = false then
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			strDataLancamento         					= formataDataBD(trim(rs("DATALANCAMENTO")))
			strDataLancamentoFinal        				= formataDataBD(trim(rs("DATALANCAMENTOFINAL")))
			strDataDiaLancamento         				= formataDataBD(trim(rs("DataDiaLancamento")))
			intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
			intCodTurma	         	 					= Trim(rs("COD_TURMA"))
			intCodDisciplina	         	 			= Trim(rs("COD_DISCIPLINA"))
			intCodTurno	         	 					= Trim(rs("COD_TURNO"))
		end if 
		rs.close
		
		sql = "Delete from SRH_COLABORADOR_FREQUENCIA "
		sql = sql & " where ANO_LETIVO = " & strAnoLetivo
		sql = sql & " and SEMESTRE_LETIVO = " & intSemestre
		sql = sql & " and Cod_JustificativaFaltas = " & intCodJustificativaFaltas
		sql = sql & " and codReferencia = " & intCodModulacaoReferencia
		sql = sql & " and DATALANCAMENTO = '" & strDataLancamento & "'"
		sql = sql & " and DATALANCAMENTOFINAL = '" & strDataLancamentoFinal & "'"
		sql = sql & " and DataDiaLancamento = '" & strDataDiaLancamento & "'"
		sql = sql & " and COD_COLABORADOR = " & intCodProfessor
		if intCodTurnoFaltas <> "" and intCodTurnoFaltas <> "0" then
			sql = sql & " and cod_turno = " & intCodTurno
		end if
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if enviarFalta = "S" and acao="ENVIAR" then

		sql = " SELECT CODIGO, "
		sql = sql & " ANO_LETIVO, "
		sql = sql & " SEMESTRE_LETIVO, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " codReferencia, "
		sql = sql & " DATALANCAMENTO, "
		sql = sql & " DATALANCAMENTOFINAL, "
		sql = sql & " DataDiaLancamento, "
		sql = sql & " COD_COLABORADOR, "
		sql = sql & " COD_TURMA, "
		sql = sql & " COD_DISCIPLINA, "
		sql = sql & " COD_TURNO "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA "
		sql = sql & " WHERE CODIGO = " & CodRegistroMestre
		rs.open sql, cnn		
		if rs.eof = false then
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			strDataLancamento         					= formataDataBD(trim(rs("DATALANCAMENTO")))
			strDataLancamentoFinal        				= formataDataBD(trim(rs("DATALANCAMENTOFINAL")))
			strDataDiaLancamento         				= formataDataBD(trim(rs("DataDiaLancamento")))
			intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
			intCodTurma	         	 					= Trim(rs("COD_TURMA"))
			intCodDisciplina	         	 			= Trim(rs("COD_DISCIPLINA"))
			intCodTurno	         	 					= Trim(rs("COD_TURNO"))
		end if 
		rs.close

		sql = "UPDATE SRH_COLABORADOR_FREQUENCIA SET FECHAMENTO = 'S' "
		sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
		sql = sql & " AND (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') "
		sql = sql & " and Cod_JustificativaFaltas = " & intCodJustificativaFaltas
		sql = sql & " and codReferencia = " & intCodModulacaoReferencia
		sql = sql & " and DATALANCAMENTO = '" & strDataLancamento & "'"
		sql = sql & " and DATALANCAMENTOFINAL = '" & strDataLancamentoFinal & "'"
		sql = sql & " and DataDiaLancamento = '" & strDataDiaLancamento & "'"
		sql = sql & " and COD_COLABORADOR = " & intCodProfessor
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registros enviado com sucesso..."
	end if   

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FaltaColaboradorNovo_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		'cnn.rollbacktrans
	end if
%>