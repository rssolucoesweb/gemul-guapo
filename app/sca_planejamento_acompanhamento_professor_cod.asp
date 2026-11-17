<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>

<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next

	acao 					= Trim(Request("acao"))
	intCodEmp				= Session("CodEmpresa")

	strAnoLetivo			= Trim(Request("txtAnoLetivo"))
	if strAnoLetivo="" then strAnoLetivo = Trim(Request.Form("txtHiddenAnoLetivo"))

	strSemestre             = Trim(Request("txtSemestre"))

	intCodTurno				= Trim(Request("txtCodTurno"))
	strTurno				= Trim(Request("txtTurno"))
	numeroAula              = Trim(Request("aula"))
	dataAula           		= Trim(Request("dataAula"))
	dataAulaDestino          = Trim(Request("dataAulaDestino"))
	intCodTurma             = trim(Request("codTurma"))
	
	intCodPeriodo           = trim(Request("codPeriodo"))
	intCodProfessor	        = Trim(Request("txtCodProfessor"))
	strProfessor	        = Trim(Request("txtProfessor"))
	strMes					= Trim(Request("cmbMes"))
	intCodDisciplina		= Trim(Request("cod_disciplina"))
	codigoPlanejamentoProf  = Trim(Request("codigoPlanejamentoProf"))
	aulas                   = Trim(Request("aulas"))

	bolAulaExtra  = Trim(Request("bolAulaExtra"))

	if acao="VT" then	

		cnn.begintrans

		strMensagem = "Registro validado com sucesso..."

		'Valida as aulas da turma
		'sql = "update SCA_PLANEJAMENTO_PROFESSOR set validado = 'S', usuario_validado = '" & session("usuarioWeb") & "', data_hora_validado = getdate() "
		'sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		'sql = sql & " AND ANOLETIVO = " & strAnoLetivo 
		'sql = sql & " AND SEMESTRE in (" & strSemestre & ") "
		'sql = sql & " AND Cod_Turno = " & intCodTurno
		'sql = sql & " AND cod_turma =" & intCodTurma
		'sql = sql & " AND Cod_Colaborador = " & intCodProfessor 
		'sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
		'sql = sql & " AND validado = 'N'"
		'sql = sql & " AND numero_aula IN(" & aulas & ")"
		
		sql = "update pp set validado = 'S', usuario_validado = '" & session("usuarioWeb") & "', data_hora_validado = getdate() "
		sql = sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
		sql = sql & " inner join SCA_ITEM_PLANEJAMENTO_PROFESSOR item on pp.cod_planejamento_professor = item.cod_planejamento_professor"
		sql = sql & " WHERE pp.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND pp.ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND pp.SEMESTRE in (" & strSemestre & ") "
		sql = sql & " AND pp.Cod_Turno = " & intCodTurno
		sql = sql & " AND pp.cod_turma =" & intCodTurma
		'sql = sql & " AND Cod_Colaborador = " & intCodProfessor 
		sql = sql & " AND pp.Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND pp.validado = 'N'"
		sql = sql & " AND pp.numero_aula IN(" & aulas & ")"
		sql = sql & " AND pp.desc_metodologia is not null"
		sql = sql & " AND pp.desc_avaliacao is not null"
		sql = sql & " and item.cod_tipo_planejamento = 2"		

		cnn.execute SQL
		GravarLog sql


		'sql = "update SCA_PLANEJAMENTO_PROFESSOR set validado = 'S', usuario_validado = '" & session("usuarioWeb") & "', data_hora_validado = getdate() "
		'sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		'sql = sql & " AND ANOLETIVO = " & strAnoLetivo 
		'sql = sql & " AND SEMESTRE in (" & strSemestre & ") "
		'sql = sql & " AND Cod_Turno = " & intCodTurno
		'sql = sql & " AND cod_turma =" & intCodTurma
		'sql = sql & " AND Cod_Colaborador = " & intCodProfessor 
		'sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
		'sql = sql & " AND validado = 'N'"
		'sql = sql & " AND numero_aula is null"
		'sql = sql & " AND month(data_aula_extra)=" & strMes
		'sql = sql & " and year(data_aula_extra)=" & strAnoLetivo
		sql = "update pp set validado = 'S', usuario_validado = '" & session("usuarioWeb") & "', data_hora_validado = getdate() "
		sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
		sql=sql & " inner join SCA_ITEM_PLANEJAMENTO_PROFESSOR item on pp.cod_planejamento_professor = item.cod_planejamento_professor"		
		sql = sql & " WHERE pp.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND pp.ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND pp.SEMESTRE in (" & strSemestre & ") "
		sql = sql & " AND pp.Cod_Turno = " & intCodTurno
		sql = sql & " AND pp.cod_turma =" & intCodTurma
		'sql = sql & " AND Cod_Colaborador = " & intCodProfessor 
		sql = sql & " AND pp.Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND pp.validado = 'N'"
		sql = sql & " AND pp.numero_aula is null"
		sql = sql & " AND month(pp.data_aula_extra)=" & strMes
		sql = sql & " and year(pp.data_aula_extra)=" & strAnoLetivo
		sql = sql & " and item.cod_tipo_planejamento = 2"		
		cnn.execute SQL
		GravarLog sql

		if err.number <> 0 then
			cnn.RollbackTrans  
		else
			cnn.CommitTrans 
		end if		

	elseif acao="DT" then
		
		cnn.begintrans

		strMensagem = "Registro desvalidado com sucesso..."

		'Valida as aulas da turma
		sql = "update SCA_PLANEJAMENTO_PROFESSOR set validado = 'N', usuario_validado = null, data_hora_validado = null "
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND SEMESTRE in (" & strSemestre & ") "
		sql = sql & " AND Cod_Turno = " & intCodTurno
		sql = sql & " AND cod_turma =" & intCodTurma
'		sql = sql & " AND Cod_Colaborador = " & intCodProfessor 
		sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND validado = 'S'"
		sql = sql & " AND numero_aula IN(" & aulas & ")"
		cnn.execute SQL
		GravarLog sql


		sql = "update SCA_PLANEJAMENTO_PROFESSOR set validado = 'N', usuario_validado = null, data_hora_validado = null "
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND SEMESTRE in (" & strSemestre & ") "
		sql = sql & " AND Cod_Turno = " & intCodTurno
		sql = sql & " AND cod_turma =" & intCodTurma
'		sql = sql & " AND Cod_Colaborador = " & intCodProfessor 
		sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND validado = 'S'"
		sql = sql & " AND numero_aula is null"
		sql = sql & " AND month(data_aula_extra)=" & strMes
		sql = sql & " and year(data_aula_extra)=" & strAnoLetivo
		cnn.execute SQL
		GravarLog sql

		if err.number <> 0 then
			cnn.RollbackTrans  
		else
			cnn.CommitTrans 
		end if	
	elseif acao="R" then
		cnn.begintrans

		turmas = request.form("chkTurma")
		'response.write turmas

		Dim arrayTurma()
		ReDim arrayTurma(-1)

		if inStr(turmas,",") > 0 then
			vetTurmas = split(turmas,",")
			for i = 0 to ubound(vetTurmas)
				ReDim Preserve arrayTurma(UBound(arrayTurma) + 1)
				arrayTurma(i) = trim(vetTurmas(i))	
			next
		else
			ReDim Preserve arrayTurma(UBound(arrayTurma) + 1)
			arrayTurma(0) = trim(turmas)
		end if

		for i = 0 to ubound(arrayTurma)
			vetCodigo = split(arrayTurma(i),"|")
			turma = vetCodigo(0)
			professor = vetCodigo(1)
			turno = vetCodigo(2)
			sql="exec SP_SCA_ReplicarAulaPlanejamentoProfessor " & codigoPlanejamentoProf & "," & turma & "," & turno & "," & professor & ",'" & session("usuarioWeb") & "'"
			'response.write SQL
			'response.end
			'if session("usuarioWeb") = "SERGIO" THEN
			'	RESPONSE.WRITE SQL & "<hr>"
			'	response.end
			'end if
			
			cnn.execute SQL
			GravarLog sql
		next

		if err.number <> 0 then
			cnn.RollbackTrans  
		else
			cnn.CommitTrans 
		end if			

	elseif acao = "replicarSemana" then

		' A replicação semanal é executada via AJAX e retorna:
		' OK|aulas_encontradas|aulas_replicadas|aulas_ignoradas
		Response.ContentType = "text/plain"

		if codigoPlanejamentoProf = "" or not IsNumeric(codigoPlanejamentoProf) then
			Response.Write "ERRO|Código do planejamento inválido."
			Response.End
		end if

		if dataAula = "" then
			Response.Write "ERRO|Data da aula não informada."
			Response.End
		end if

		strUsuarioReplicaSemana = Replace(Session("usuarioWeb"), "'", "''")

		' dataAula chega da tela no formato dd/mm/aaaa.
		' Montamos DATEFROMPARTS para não depender de formatação/regionalização do SQL Server.
		vetDataReplicaSemana = Split(dataAula, "/")
		if UBound(vetDataReplicaSemana) <> 2 then
			Response.Write "ERRO|Data da aula inválida: " & dataAula
			Response.End
		end if

		intDiaReplicaSemana = CInt(vetDataReplicaSemana(0))
		intMesReplicaSemana = CInt(vetDataReplicaSemana(1))
		intAnoReplicaSemana = CInt(vetDataReplicaSemana(2))

		' Usa ADODB.Command parametrizado para evitar qualquer dependência
		' de formato regional de data e problemas de sintaxe com dd/mm/aaaa.
		set cmdSemana = Server.CreateObject("ADODB.Command")
		set cmdSemana.ActiveConnection = cnn
		cmdSemana.CommandType = 4 ' adCmdStoredProc
		cmdSemana.CommandText = "SP_SCA_ReplicarAulaPlanejamentoProfessorSemana"

		cmdSemana.Parameters.Append cmdSemana.CreateParameter("@codigoPlanejamentoOrigem", 3, 1, , CLng(codigoPlanejamentoProf)) ' adInteger
		cmdSemana.Parameters.Append cmdSemana.CreateParameter("@dataAulaOrigem", 133, 1, , DateSerial(intAnoReplicaSemana, intMesReplicaSemana, intDiaReplicaSemana)) ' adDBDate
		cmdSemana.Parameters.Append cmdSemana.CreateParameter("@usuario", 200, 1, 50, Left(strUsuarioReplicaSemana, 50)) ' adVarChar

		GravarLog "SP_SCA_ReplicarAulaPlanejamentoProfessorSemana | planejamento=" & CLng(codigoPlanejamentoProf) & " | data=" & Right("0" & intDiaReplicaSemana, 2) & "/" & Right("0" & intMesReplicaSemana, 2) & "/" & intAnoReplicaSemana & " | usuario=" & strUsuarioReplicaSemana

		on error resume next
		set rsSemana = cmdSemana.Execute

		if err.number <> 0 then
			strErroReplicaSemana = Replace(err.description, "|", "-")
			if rsSemana.state = 1 then rsSemana.close
			set rsSemana = nothing
			set cmdSemana = nothing
			err.clear
			on error goto 0
			Response.Write "ERRO|" & strErroReplicaSemana
			Response.End
		end if
		on error goto 0

		if not rsSemana.eof then
			Response.Write "OK|" & rsSemana("aulas_encontradas") & "|" & rsSemana("aulas_replicadas") & "|" & rsSemana("aulas_ignoradas")
		else
			Response.Write "ERRO|A procedure não retornou o resultado da replicação."
		end if

		if rsSemana.state = 1 then rsSemana.close
		set rsSemana = nothing
		set cmdSemana = nothing
		Response.End

	elseif acao = "replicarDia" then

		' A replicação por dia é executada via AJAX e retorna:
		' OK|numero_aula_destino|data_aula_destino
		Response.ContentType = "text/plain"

		if codigoPlanejamentoProf = "" or not IsNumeric(codigoPlanejamentoProf) then
			Response.Write "ERRO|Código do planejamento inválido."
			Response.End
		end if

		if dataAula = "" or dataAulaDestino = "" then
			Response.Write "ERRO|Informe a data da aula de origem e a data de destino."
			Response.End
		end if

		' A origem chega como dd/mm/aaaa.
		vetDataOrigemDia = Split(dataAula, "/")
		if UBound(vetDataOrigemDia) <> 2 then
			Response.Write "ERRO|Data da aula de origem inválida: " & dataAula
			Response.End
		end if

		if not IsNumeric(vetDataOrigemDia(0)) or not IsNumeric(vetDataOrigemDia(1)) or not IsNumeric(vetDataOrigemDia(2)) then
			Response.Write "ERRO|Data da aula de origem inválida: " & dataAula
			Response.End
		end if

		intDiaOrigemDia = CInt(vetDataOrigemDia(0))
		intMesOrigemDia = CInt(vetDataOrigemDia(1))
		intAnoOrigemDia = CInt(vetDataOrigemDia(2))

		' O input type=date envia o destino como aaaa-mm-dd.
		vetDataDestinoDia = Split(dataAulaDestino, "-")
		if UBound(vetDataDestinoDia) <> 2 then
			Response.Write "ERRO|Data de destino inválida: " & dataAulaDestino
			Response.End
		end if

		if not IsNumeric(vetDataDestinoDia(0)) or not IsNumeric(vetDataDestinoDia(1)) or not IsNumeric(vetDataDestinoDia(2)) then
			Response.Write "ERRO|Data de destino inválida: " & dataAulaDestino
			Response.End
		end if

		intAnoDestinoDia = CInt(vetDataDestinoDia(0))
		intMesDestinoDia = CInt(vetDataDestinoDia(1))
		intDiaDestinoDia = CInt(vetDataDestinoDia(2))
		strUsuarioReplicaDia = Replace(Session("usuarioWeb"), "'", "''")

		set cmdDia = Server.CreateObject("ADODB.Command")
		set cmdDia.ActiveConnection = cnn
		cmdDia.CommandType = 4 ' adCmdStoredProc
		cmdDia.CommandText = "SP_SCA_ReplicarAulaPlanejamentoProfessorDia"

		cmdDia.Parameters.Append cmdDia.CreateParameter("@codigoPlanejamentoOrigem", 3, 1, , CLng(codigoPlanejamentoProf)) ' adInteger
		cmdDia.Parameters.Append cmdDia.CreateParameter("@dataAulaOrigem", 133, 1, , DateSerial(intAnoOrigemDia, intMesOrigemDia, intDiaOrigemDia)) ' adDBDate
		cmdDia.Parameters.Append cmdDia.CreateParameter("@dataAulaDestino", 133, 1, , DateSerial(intAnoDestinoDia, intMesDestinoDia, intDiaDestinoDia)) ' adDBDate
		cmdDia.Parameters.Append cmdDia.CreateParameter("@usuario", 200, 1, 50, Left(strUsuarioReplicaDia, 50)) ' adVarChar

		GravarLog "SP_SCA_ReplicarAulaPlanejamentoProfessorDia | planejamento=" & CLng(codigoPlanejamentoProf) & " | origem=" & dataAula & " | destino=" & dataAulaDestino & " | usuario=" & strUsuarioReplicaDia

		on error resume next
		set rsDia = cmdDia.Execute

		if err.number <> 0 then
			strErroReplicaDia = Replace(err.description, "|", "-")
			set rsDia = nothing
			set cmdDia = nothing
			err.clear
			on error goto 0
			Response.Write "ERRO|" & strErroReplicaDia
			Response.End
		end if
		on error goto 0

		if not rsDia.eof then
			Response.Write "OK|" & rsDia("numero_aula_destino") & "|" & Right("0" & Day(rsDia("data_aula_destino")), 2) & "/" & Right("0" & Month(rsDia("data_aula_destino")), 2) & "/" & Year(rsDia("data_aula_destino"))
		else
			Response.Write "ERRO|A procedure não retornou o resultado da replicação."
		end if

		if rsDia.state = 1 then rsDia.close
		set rsDia = nothing
		set cmdDia = nothing
		Response.End

	elseif acao = "listarTurmasDisciplinaProfessor" then
		intCodTurno = trim(Request("cod_turno")) 'turno da tela
		strTurnoTurma=""
		sql = " SELECT DISTINCT TU.DESC_TURNO"
		sql=sql & " FROM SCA_TURMA T" 
		sql=sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno" 
		sql=sql & " WHERE T.COD_TURMA = " & intCodTurma
		rs.open sql, cnn,3,1
		if rs.eof = false then
			strTurnoTurma = rs("DESC_TURNO")
		end if
		rs.close
		
		sql = "select codigo, CodCategoria "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " and (CodCategoria = 1 OR CodCategoria = 8)"'professor
		sql = sql & " and Situacao = 'A'"'ativo
		rs.open sql, cnn
		if rs.eof then
			strTipoAcessoTurmas = "ADM"
		else
			if (Session("Seg_CodCategoria") = "1") then
				strTipoAcessoTurmas = "PROF"
			ELSE
				if rs("CodCategoria") = "1" then
					strTipoAcessoTurmas = "PROF"
				else
					strTipoAcessoTurmas = "ADM"
				end if
			END IF	
		end if
		rs.close
		
		sql = " SELECT distinct "
		sql=sql & " 		t.Cod_Empresa,"
		sql=sql & " 		HA.AnoLetivo,"
		sql=sql & " 		HA.Semestre,"
		sql=sql & " 		P.Cod_Periodo,"
		sql=sql & " 		P.descricao as periodo,"
		sql=sql & " 		HA.Cod_Colaborador as codProfessor," 
		sql=sql & " 		DI.Cod_Disciplina,"
		sql=sql & " 		TU.Cod_Turno,"
		sql=sql & " 		T.Cod_Turma," 
		sql=sql & " 		T.TurmaAluno" 
		if not bolAulaExtra then
			sql=sql & " FROM SCA_HORARIO_AULA HA" 
		else
			sql=sql & " FROM SCA_HORARIO_AULA_extra HA" 
		end if
		sql=sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO" 
		sql=sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador" 
		sql=sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA" 
		sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR" 
		sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO" 
		sql=sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO" 
		sql=sql & " INNER JOIN SRH_TURNO TU ON TU.Cod_Turno = H.CodTurno" 
		sql=sql & " INNER JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = HA.Cod_Disciplina"
		sql=sql & " WHERE HA.COD_EMPRESA =" & Session("CodEmpresa") 
		sql=sql & " AND HA.ANOLETIVO =" & strAnoLetivo 
		sql=sql & " AND HA.SEMESTRE in (" & strSemestre & ")" 
		sql=sql & " AND P.COD_PERIODO =" & intCodPeriodo
		'sql=sql & " AND HA.Cod_Colaborador =" & intCodProfessor
		if strTipoAcessoTurmas = "PROF" THEN
			sql=sql & " AND HA.Cod_Colaborador in (select codigo from SRH_COLABORADOR where cpf in  (select cpf from SRH_COLABORADOR where codigo =" & intCodProfessor & "))"
		end if
		sql=sql & " AND DI.Cod_Disciplina =" & intCodDisciplina
		if strTurnoTurma<>"INTEGRAL" then
			sql=sql & " AND T.COD_TURMA <>" & intCodTurma
		end if
		if strTurnoTurma="INTEGRAL" then
			sql=sql & " AND T.COD_TURMA <>" & intCodTurma
		end if
		if bolAulaExtra then
			sql=sql & " AND HA.dataLancamento='" & formataDataBd(numeroAula) & "'"
		end if
		
		rs.open sql, cnn,3,1
		if rs.eof = false then
			response.write "<ul style='padding-top: 15px ;'>"
			while not rs.eof 
				' Verifica se a turma já possui planejamento
				
				strObsTurma = ""
				if cint(rs("codProfessor")) <> cint(intCodProfessor) then
					strObsTurma = "&nbsp;<span style='font-size: 11px; color: orange; font-style: italic;'>(turma de outro contrato)</span>"
				end if
				
				sql="select cod_turma from sca_PLANEJAMENTO_PROFESSOR" 
				sql=sql & " where cod_empresa =" &  Session("CodEmpresa") 
				sql=sql & " and anoLetivo =" & strAnoLetivo
				sql=sql & " and semestre =" & strSemestre
				sql=sql & " and cod_periodo =" & intCodPeriodo
				sql=sql & " and cod_disciplina =" & intCodDisciplina
				sql=sql & " and cod_turma =" & rs("Cod_Turma")
				'sql=sql & " and cod_colaborador =" & rs("codProfessor")
				if not bolAulaExtra then
					sql=sql & " and numero_aula =" & numeroAula
				else
					sql=sql & " and data_aula_extra ='" & formataDataBD(numeroAula) & "'"
				end if
				if strTurnoTurma="INTEGRAL" and trim(rs("Cod_Turma")) = trim(intCodTurma) and cInt(intQtdeTurnoTurma) >= 2 then
					if intCodTurno = "1" then 
						intCodTurno = "2"
					else
						intCodTurno = "1"
					end if
					sql=sql & " AND cod_turno = " & intCodTurno
				else
					sql=sql & " AND cod_turno = " & rs("Cod_Turno")
					intCodTurno = rs("Cod_Turno")
				end if
				
				'if session("usuarioWeb") = "SERGIO" THEN
				'	RESPONSE.WRITE SQL & "<hr>"
				'	response.write "<br>strTurnoTurma:" & trim(strTurnoTurma)
				'	response.write "<br>CodTurma banco:" & trim(rs("Cod_Turma"))
				'	response.write "<br>CodTurma tela:" & trim(intCodTurma)
				'end if	
				
				
				'response.write "<br>:" & sql
				rsAux.open sql,cnn
				if rsAux.eof = false then
					strDesabilitaTurma = "S"
					strObsTurma = "&nbsp;<span style='font-size: 11px; color: red; font-style: italic;'>(já existe planejamento)</span>"
				else
					strDesabilitaTurma = "N"
				end if
				rsAux.close
				
				

				%>
					<li><input type="checkbox" value="<%=rs("Cod_Turma") & "|" & rs("codProfessor") & "|" & intCodTurno%>" name="chkTurma" id="chkTurma<%=rs("Cod_Turma")%>" <%if strDesabilitaTurma="S" then response.write "disabled"%>> <%=rs("Periodo")%>&nbsp;<%=rs("TurmaAluno")%> <%=strObsTurma%></li>
				<%
				rs.movenext
			wend
			response.write "</ul>"
		else
			response.write "Não é possível replicar"
		end if
		rs.close

	end if

	if len(acao) <= 2 then
		if err.number = 0 then
			%>
			<script>
				window.location='sca_planejamento_acompanhamento_professor.asp?txtAnoLetivo=<%=strAnoLetivo%>&txtSemestre=<%=strSemestre%>&txtCodTurno=<%=intCodTurno%>&txtTurno=<%=strTurno%>&txtCodProfessor=<%=intCodProfessor%>&txtProfessor=<%=strProfessor%>&cmbMes=<%=strMes%>';
			</script>
			<%
			response.end
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end if
	end if
%>
