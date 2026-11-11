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
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	'strQtdeFaltas 		= request("cmbQtdeFaltas")
	
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
	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))	
	strPosicao	 		= Trim(Request.Form("txtPosicao"))
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
	sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
	sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
	if intCodDisciplinaTurma <> "0" then
		sql = sql & " AND  AD.COD_DISCIPLINA = " & intCodDisciplinaTurma
	end if	
	sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
	sql = sql & " ORDER BY A.NOMEALUNO "
	rs.open sql, cnn
	while not rs.eof
		strCodAluno = rs("CODIGO")
		'limpa falta do aluno
		sql = "select NF.codigo AS COD_NOTA, isnull(FD.falta,'0') as TOTAL "
		sql = sql & " from SCA_FALTAS_DIARIA FD "
		sql = sql & " INNER JOIN SCA_NOTAS_FALTAS NF ON FD.COD_ALUNO_DISCIPLINA = NF.COD_ALUNO_DISCIPLINA AND FD.ano_letivo = NF.ano_letivo AND FD.semestre = NF.semestre "
		sql = sql & " where FD.COD_ALUNO = " & strCodAluno
		sql = sql & " and FD.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and MONTH(FD.DATA) = " & strMes
		if intCodDisciplinaTurma <> "0" then
			sql = sql & " and FD.cod_disciplina = " & intCodDisciplinaTurma
		end if	
		if strQuinzena = "1" then 
		   sql = sql & " and day(data) >= 1 and day(data) <= 15 "
		else   
		   sql = sql & " and day(data) >= 16 and day(data) <= " & qtdeDiasMes
		end if
		sql = sql & " order by FD.CODIGO desc "
		rsaux.open sql, cnn
		if not rsaux.eof then
			while not rsaux.eof
				SQL = "UPDATE SCA_NOTAS_FALTAS SET "
				SQL = SQL & "falta"&strPosicao&"= falta"&strPosicao&"-" & rsaux("TOTAL") & ""
				SQL = SQL & " where codigo = " & rsaux("COD_NOTA")
				cnn.execute SQL
				'
				SQL = " select codigo, falta"&strPosicao&" as faltaBim FROM SCA_NOTAS_FALTAS "
				SQL = SQL & "where CODIGO = " & rsaux("COD_NOTA")
				rs1.open sql, cnn
				if not rs1.eof then
					if rs1("faltaBim") < "0" then
						SQL = "UPDATE SCA_NOTAS_FALTAS SET "
						SQL = SQL & "falta"&strPosicao&"= 0"
						SQL = SQL & " where codigo = " & rsaux("COD_NOTA")
						cnn.execute SQL
					end if
				end if
				rs1.close	
				rsaux.movenext
			wend
		end if	
		rsaux.close	

		sql = "delete from SCA_FALTAS_DIARIA "
		sql = sql & " FROM SCA_FALTAS_DIARIA FD1 "
		sql = sql & " inner join SCA_ALUNO_DISCIPLINA ad1 on ad1.codigo = FD1.cod_aluno_disciplina "
		sql = sql & " where FD1.cod_aluno = " & strCodAluno
		sql = sql & " and FD1.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and ad1.COD_TURMA_REMANEJAMENTO = " & intCodTurma
		if intCodDisciplinaTurma <> "0" then
			sql = sql & " AND FD1.COD_DISCIPLINA = " & intCodDisciplinaTurma
		end if	
		sql = sql & " and month(FD1.data) = " & strMes
		if strQuinzena = "1" then 
		   sql = sql & " and day(FD1.data) >= 1 and day(FD1.data) <= 15 "
		else   
		   sql = sql & " and day(FD1.data) >= 16 and day(FD1.data) <= " & qtdeDiasMes
		end if
		cnn.execute sql
		
		for i=intMarcaQuinzena to qtdeDiasMes
		
			strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
			strDataComFalta = trim(Request("txtFaltas_"& strCodAluno & "_" & strData))
	
	
			if trim(strDataComFalta)<>"" then
			
			    strQtdeFaltas = "0"
			    sql = " select SCA_HORARIO_AULA.cod_disciplina, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA.cod_disciplina) as total_aulas "
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
				rsAux.open sql, cnn
				while not rsAux.eof
				
					'busca o cod do aluno disciplina
					sql = "select codigo as codAlunoDisciplina"
					sql = sql & " from sca_aluno_disciplina"
					sql = sql & " where cod_aluno = " & strCodAluno
					sql = sql & " and cod_disciplina = " & rsAux("cod_disciplina")
					sql = sql & " and cod_turma_remanejamento = " & intCodTurma
					sql = sql & " and cod_empresa = " & Session("CodEmpresa")
					rs1.open sql, cnn
					if not rs1.eof then
						strAlunoDisciplina = rs1("codAlunoDisciplina")
					else
						strAlunoDisciplina = "0"
					end if
					rs1.close	
					
					sql2 = sql
					
					
					intCodDisciplina	= rsAux("cod_disciplina")
					strQtdeFaltas		= rsAux("total_aulas")
					
					bolNotasfaltas = true
					strCodNota = ""
					SQL = "SELECT codigo FROM SCA_NOTAS_FALTAS "
					SQL = SQL & " WHERE cod_empresa="&Session("CodEmpresa")
					SQL = SQL & " AND cod_aluno="&strCodAluno
					SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
					SQL = SQL & " AND cod_periodo="&intCodPeriodo
					SQL = SQL & " AND ano_letivo="&strAnoLetivo
					SQL = SQL & " AND semestre="&intSemestre
					SQL = SQL & " AND cod_disciplina="&intCodDisciplina
					rs1.open sql, cnn
					if not rs1.eof then
						bolNotasfaltas = false
						strCodNota = rs1("codigo")
					end if
					rs1.close			
					
					if isnull(strCodNota) or trim(strCodNota) = "" then
						'incluir
						if trim(strQtdeFaltas) <> "" and  trim(strQtdeFaltas) <> "0" and  trim(intCodDisciplina) <> "0" then
			
							SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
							SQL = SQL & " WHERE cod_empresa="&Session("CodEmpresa")
							SQL = SQL & " AND cod_aluno=" & strCodAluno
							SQL = SQL & " AND cod_aluno_disciplina="& strAlunoDisciplina
							SQL = SQL & " AND cod_periodo="& intCodPeriodo
							SQL = SQL & " AND ano_letivo="& strAnoLetivo
							SQL = SQL & " AND semestre="& intSemestre
							SQL = SQL & " AND cod_disciplina="& intCodDisciplina
							SQL = SQL & " AND data='"&strDataComFalta& "'"
							rs1.open sql, cnn
							if rs1.eof then
			
								if bolNotasfaltas then
								
									if strAlunoDisciplina <> "0" and strAlunoDisciplina <> "" then 
									
										SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
										SQL = SQL & "ano_letivo, semestre, cod_disciplina, falta"&strPosicao&") VALUES ("
										SQL = SQL & "" & Session("CodEmpresa") & ","
										SQL = SQL & "" & strCodAluno & ","
										SQL = SQL & "" & strAlunoDisciplina & ","
										SQL = SQL & "" & intCodPeriodo & ","
										SQL = SQL & "" & strAnoLetivo & ","
										SQL = SQL & "" & intSemestre & ","
										SQL = SQL & "" & intCodDisciplina & ","
										SQL = SQL & "" & strQtdeFaltas & ")"
										'response.Write("Atenção: Verificar no grade de Disciplina o Aluno " + strCodAluno)
										cnn.execute SQL
										
									end if
								else
									
									'alterar falta
									SQL = "UPDATE SCA_NOTAS_FALTAS SET "
									SQL = SQL & "falta"&strPosicao&"= 0"
									SQL = SQL & " where codigo = " & strCodNota
									SQL = SQL & " and falta"&strPosicao&" is null"
									cnn.execute SQL
			
									'alterar falta
									SQL = "UPDATE SCA_NOTAS_FALTAS SET "
									SQL = SQL & "falta"&strPosicao&"= falta"&strPosicao&"+" & strQtdeFaltas & ""
									SQL = SQL & " where codigo = " & strCodNota
									cnn.execute SQL
								end if
														
								SQL = "INSERT INTO SCA_FALTAS_DIARIA (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
								SQL = SQL & "ano_letivo, semestre, cod_disciplina, data, falta) VALUES ("
								SQL = SQL & "" & Session("CodEmpresa") & ","
								SQL = SQL & "" & strCodAluno & ","
								SQL = SQL & "" & strAlunoDisciplina & ","
								SQL = SQL & "" & intCodPeriodo & ","
								SQL = SQL & "" & strAnoLetivo & ","
								SQL = SQL & "" & intSemestre & ","
								SQL = SQL & "" & intCodDisciplina & ","
								SQL = SQL & "'"& strData & "',"
								SQL = SQL & "" & strQtdeFaltas & ")"
								cnn.execute SQL
							end if
							RS1.CLOSE
			
						end if
					else
						if  trim(strQtdeFaltas) <> "" and  trim(strQtdeFaltas) <> "0" then
							SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
							SQL = SQL & " WHERE cod_empresa="&Session("CodEmpresa")
							SQL = SQL & " AND cod_aluno="&strCodAluno
							SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
							SQL = SQL & " AND cod_periodo="&intCodPeriodo
							SQL = SQL & " AND ano_letivo="&strAnoLetivo
							SQL = SQL & " AND semestre="&intSemestre
							SQL = SQL & " AND cod_disciplina="&intCodDisciplina
							SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
							rs1.open sql, cnn
							if rs1.eof then
								
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
			
								'alterar falta
								SQL = "UPDATE SCA_NOTAS_FALTAS SET "
								SQL = SQL & "falta"&strPosicao&"= 0"
								SQL = SQL & " where codigo = " & strCodNota
								SQL = SQL & " and falta"&strPosicao&" is null"
								cnn.execute SQL
								
								SQL = "UPDATE SCA_NOTAS_FALTAS SET "
								SQL = SQL & "falta"&strPosicao&"= falta"&strPosicao&"+" & strQtdeFaltas & ""
								SQL = SQL & " where codigo = " & strCodNota
								cnn.execute SQL
			
							end if
							rs1.CLOSE
						end if				
			
					end if		
					rsAux.movenext
				wend
				rsAux.close
			end if
		next	
		rs.movenext
	wend
	rs.close
	strMensagem = "Registro salvo com sucesso..."
		
	strParametro = "sca_falta_interdisciplinarCon.asp?cmbPeriodo="&intCodPeriodo
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