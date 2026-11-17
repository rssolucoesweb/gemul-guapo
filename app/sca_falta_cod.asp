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
	::	Data de Criação...: 19/01/2021
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strTipoLancamento	= trim(request("txtTipoLancamento"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))	
	intSemestre 		= Trim(Request.Form("txtSemestre"))
	intCodAvaliacao		= Trim(Request.Form("txtAvaliacao"))
	intCodCriterio		= Trim(Request.Form("txtCodCriterio"))
	strPosicao			= Trim(Request.Form("txtPosicao"))
	strDataInicio		= Trim(Request.Form("txtDataInicio"))
	strDataFim			= Trim(Request.Form("txtDataFim"))
	strBimestre			= trim(request("txtBimestre"))
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	strAlunos 			= Trim(Request("chkAluno"))
	
	qtdeDiasMes	 		= Trim(Request.Form("txtQtdeDias"))
	strQuinzena	 		= Trim(Request.Form("txtQuinzena"))
	strMes		 		= Trim(Request("cmbMes"))	
	strDataLancamento	= trim(request("txtDataLancamento"))
	intCodTipoNota		= Trim(Request("chkTipoNota"))
	
	if strQuinzena = "1" then 
	   qtdeDiasMes = 15
	   intMarcaQuinzena = 1	
	else   
	   intMarcaQuinzena = 16
	end if 
	if strQuinzena = "3" then ' So quando for por dia
		intMarcaQuinzena = day(strDataLancamento)
		qtdeDiasMes = day(strDataLancamento)		
	end if
	 		
	sql = " SELECT distinct "
	sql = sql & " AD.COD_ALUNO AS CODIGO, " 
	sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
	sql = sql & " A.NOMEALUNO, "
	sql = sql & " A.MATRICULA, "
	sql = sql & " SA.DESC_SITUACAOALUNO "
	sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
	sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
	sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
	sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND AD.COD_TURMA = " & intCodTurma	
	sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
	if intCodDisciplinaTurma <> "0" then
		sql = sql & " AND  AD.COD_DISCIPLINA = " & intCodDisciplinaTurma
	end if	
	'sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
	sql = sql & " ORDER BY A.NOMEALUNO "
	rs.open sql, cnn
	while not rs.eof
		strCodAluno = rs("CODIGO")
		AlunoAtualizado = ""

		sql = "delete FD1 "
		sql = sql & " FROM SCA_FALTAS_DIARIA FD1 "
		if strTipoLancamento = "D" then
			sql = sql & " inner join SCA_ALUNO_DISCIPLINA ad1 on ad1.codigo = FD1.cod_aluno_disciplina "
		end if	
		sql = sql & " where FD1.cod_aluno = " & strCodAluno
		sql = sql & " and FD1.cod_empresa = " & Session("CodEmpresa")
		if strTipoLancamento = "D" then
			sql = sql & " and ad1.COD_TURMA = " & intCodTurma
			sql = sql & " AND FD1.COD_DISCIPLINA = " & intCodDisciplinaTurma
		end if	
		sql = sql & " and month(FD1.data) = " & strMes
		sql = sql & " and year(FD1.data) = " & strAnoLetivo
		if strQuinzena = "1" then 
		   sql = sql & " and day(FD1.data) >= 1 and day(FD1.data) <= 15 "
		elseif strQuinzena = "3" then ' So quando for por dia
			sql = sql & " and day(FD1.data) = " & day(strDataLancamento)
		else   
		   sql = sql & " and day(FD1.data) >= 16 and day(FD1.data) <= " & qtdeDiasMes
		end if
		'if session("usuarioweb") = "SERGIO" then
		'response.write sql
		'response.end
		'end if
		cnn.execute sql
		strMensagemDelete = "Faltas foram retiradas!!!"
		
		for i=intMarcaQuinzena to qtdeDiasMes
		
			strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
			strDataComFalta = trim(Request("txtFaltas_"& strCodAluno & "_" & strData))

			if trim(strDataComFalta)<>"" then
			
				strQtdeFaltas = "0"
				if strTipoLancamento = "I" then
				
					sql = " select distinct cod_disciplina, 1 as total_aulas "
					sql = sql & " from SCA_HORARIO_AULA "
					sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
					sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & year(strDataComFalta)
					sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
					sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & WeekDay(strDataComFalta)	
					sql = sql & " union "
					sql = sql & " select distinct cod_disciplina, 1 total_aulas "
					sql = sql & " from SCA_HORARIO_AULA_EXTRA"
					sql = sql & " where cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and anoletivo = " & year(strDataComFalta)
					sql = sql & " and cod_turma= " & intCodTurma
					sql = sql & " and DataLancamento = '" & strDataComFalta & "'"
				
				else
					sql = " select SCA_HORARIO_AULA.cod_disciplina, isnull(SCA_HORARIO.numero_aula,1), isnull(SCA_HORARIO.numero_aula,1) * isnull(COUNT(SCA_HORARIO_AULA.cod_disciplina),0) as total_aulas "
					sql = sql & " from SCA_HORARIO_AULA "
					sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
					sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & year(strDataComFalta)
					sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
					'será usada o dia da semana no horario somente quando for lançada a grade completa sem a disciplina
					if intCodDisciplinaTurma = "0" then
						sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & WeekDay(strDataComFalta)	
					else
						sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & WeekDay(strDataComFalta)	
						sql = sql & " and SCA_HORARIO_AULA.cod_disciplina = " & intCodDisciplinaTurma
					end if
					sql = sql & " group by SCA_HORARIO_AULA.cod_disciplina, SCA_HORARIO.numero_aula "
					sql = sql & " union "
					sql = sql & " select cod_disciplina, 1, 1 * isnull(COUNT(cod_disciplina),0) as total_aulas "
					sql = sql & " from SCA_HORARIO_AULA_EXTRA"
					sql = sql & " where cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and anoletivo = " & year(strDataComFalta)
					sql = sql & " and cod_turma= " & intCodTurma
					if intCodDisciplinaTurma = "0" then
						sql = sql & " and DataLancamento = '" & strDataComFalta & "'"
					else
						sql = sql & " and DataLancamento = '" & strDataComFalta & "'"
						sql = sql & " and cod_disciplina = " & intCodDisciplinaTurma
					end if
					sql = sql & " group by cod_disciplina"
				end if
				
				rsAux.open sql, cnn
				if not rsAux.eof then
					while not rsAux.eof
					
						'busca o cod do aluno disciplina
						sql = "select codigo as codAlunoDisciplina"
						sql = sql & " from sca_aluno_disciplina"
						sql = sql & " where cod_aluno = " & strCodAluno
						sql = sql & " and cod_disciplina = " & rsAux("cod_disciplina")
						sql = sql & " and cod_turma = " & intCodTurma
						sql = sql & " and cod_empresa = " & Session("CodEmpresa")
						if ucase(session("usuarioweb")) = "SERGIO" then
							'response.write sql & "<hr>"
							'response.end
						end if
						rsAux1.open sql, cnn
						if not rsAux1.eof then
							strAlunoDisciplina = rsAux1("codAlunoDisciplina")
						else
							strAlunoDisciplina = "0"
						end if
						rsAux1.close	
						
						intCodDisciplina	= rsAux("cod_disciplina")
						strQtdeFaltas		= cInt(rsAux("total_aulas"))
						
						bolNotasfaltas = true
						

						'alterar
						if cInt(strQtdeFaltas) > 0 then
							if strTipoLancamento = "D" then
								SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
								SQL = SQL & " WHERE cod_empresa="&Session("CodEmpresa")
								SQL = SQL & " AND cod_aluno="&strCodAluno
								SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
								SQL = SQL & " AND cod_periodo="&intCodPeriodo
								SQL = SQL & " AND ano_letivo="&strAnoLetivo
								SQL = SQL & " AND semestre="&intSemestre
								SQL = SQL & " AND cod_disciplina="&intCodDisciplina
								SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
								rsAux1.open sql, cnn
								if rsAux1.eof then
									
									SQL = "INSERT INTO SCA_FALTAS_DIARIA (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
									SQL = SQL & "ano_letivo, semestre, cod_disciplina, data, falta) VALUES ("
									SQL = SQL & "" & Session("CodEmpresa") & ","
									SQL = SQL & "" & strCodAluno & ","
									SQL = SQL & "" & strAlunoDisciplina & ","
									SQL = SQL & "" & intCodPeriodo & ","
									SQL = SQL & "" & strAnoLetivo & ","
									SQL = SQL & "" & intSemestre & ","
									SQL = SQL & "" & intCodDisciplina & ","
									SQL = SQL & "'"&formatadataBD(strData) & "',"
									SQL = SQL & "" & strQtdeFaltas & ")"
									cnn.execute SQL
									strMensagem = "Falta diária atualizada com sucesso..."
									strMensagemDelete=""
									'GravarLog(sql)
									
								end if
								rsAux1.CLOSE
								
								'ATUALIZA ACUMULADO DE NOTAS POR DISCIPLINA
								sql = "UPDATE SCA_NOTAS_FALTAS SET falta0" & strPosicao & " = ("
								sql = sql & " select COUNT(*) AS FALTAS"
								sql = sql & " from SCA_FALTAS_DIARIA"
								sql = sql & " where COD_ALUNO = " & strCodAluno
								sql = sql & " and cod_empresa = " & Session("CodEmpresa")
								sql = sql & " AND cod_disciplina = " & intCodDisciplina
								sql = sql & " and data between '" & formatadataBD(strDataInicio) & "' and '" & formatadataBD(strDataFim) & "'"
								sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
								sql = sql & " )"
								sql = sql & " where cod_ALUNO = " & strCodAluno
								sql = sql & " AND COD_DISCIPLINA = " & intCodDisciplina
								sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
								sql = sql & " and cod_empresa = " & Session("CodEmpresa")	
								'response.write sql
								cnn.execute SQL
								acumuladoAtualizado = "S"
								AlunoAtualizado = "S"
							else
								SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
								SQL = SQL & " WHERE cod_empresa="&Session("CodEmpresa")
								SQL = SQL & " AND cod_aluno="&strCodAluno
								SQL = SQL & " AND cod_periodo="&intCodPeriodo
								SQL = SQL & " AND ano_letivo="&strAnoLetivo
								SQL = SQL & " AND semestre="&intSemestre
								SQL = SQL & " AND cod_disciplina= " & intCodDisciplina
								SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
								rsAux1.open sql, cnn
								if rsAux1.eof then
									SQL = "INSERT INTO SCA_FALTAS_DIARIA (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_disciplina, cod_periodo, "
									SQL = SQL & "ano_letivo, semestre, data, falta) VALUES ("
									SQL = SQL & "" & Session("CodEmpresa") & ","
									SQL = SQL & "" & strCodAluno & ","
									SQL = SQL & "" & strAlunoDisciplina & ","
									SQL = SQL & "" & intCodDisciplina & ","
									SQL = SQL & "" & intCodPeriodo & ","
									SQL = SQL & "" & strAnoLetivo & ","
									SQL = SQL & "" & intSemestre & ","
									SQL = SQL & "'"&formatadataBD(strData) & "',"
									SQL = SQL & "" & strQtdeFaltas & ")"
									'response.write sql
									cnn.execute SQL
									strMensagem = "Falta diária atualizada com sucesso..."
									strMensagemDelete=""
								end if
								rsAux1.CLOSE
							end if
						end if				
				
						rsAux.movenext
					wend
					
				else
					strMensagemAluno = "\nHorário de aula não encontrado para o aluno com codigo: " & strCodAluno
					strMensagemAluno = "S"
					strMensagemDelete = ""
				end if
				rsAux.close
			end if
		next	
		rs.movenext
		
		'usado somente para quando for desmarcar as faltas
		'if AlunoAtualizado = "" then
		'	sql = "exec SP_AtualizaFaltaAluno " & Session("CodEmpresa") & "," & strAnoLetivo & "," & intCodTurma & "," & strCodAluno & ",'" & data_inicial & "','" & data_final & "','" & strPosicao & "'"
		'	
		'	cnn.execute SQL
		'end if
		'
		'AlunoAtualizado = ""
		
	wend
	rs.close
	
	if acumuladoAtualizado = "S" then
		strMensagem = strMensagem & "\nAcumulado de falta foi atualizado entre o período de " & formatadataAP(strDataInicio) & " até " & formatadataAP(strDataFim) & " para " & strBimestre &"!"
	end if
		
	strParametro = "sca_faltaCon.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
	strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplinaTurma
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
	strParametro = strParametro & "&cmbCurso="&intCodCurso	
	strParametro = strParametro & "&cmbMes="&strMes
	strParametro = strParametro & "&cmbQtdeFaltas="&strQtdeFaltas
	
	if strMensagemAluno = "S" then
		strMensagem = strMensagem & "\n\nAlunos com horário de aula não encontrado FALTAS NÃO FORAM SALVAS!!!"
	end if 
	if strMensagemDelete <> "" and strMensagem="" then
		strMensagem = strMensagemDelete
	end if
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