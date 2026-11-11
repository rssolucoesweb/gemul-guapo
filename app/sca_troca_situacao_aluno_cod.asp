
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strSituacaoAluno	= Trim(Request.Form("cmbSituacaoAluno"))
	intCodAluno			= Trim(Request.Form("chkAluno"))
	strDatafastamento	= formatadataBD(Trim(Request("txtDatafastamento")))
	strDataMatricula	= formatadataBD(Trim(Request("txtDatamatricula")))


	if intCodAluno = "" then
		%>
		<script>
			alert("ATENÇÃO: \n\nDeve ser selecionado os alunos para troca de situação.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if	


	strDescSituacaoAnterior = ""
	strDescSituacao 		= ""
	
	
	
	'REGRA PARA SITUACAO ATUAL DO ALUNO
	sql = "select REPLACE(REPLACE(Desc_SituacaoAluno,'É','E'),'Í','I') AS Desc_SituacaoAluno "
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " where Cod_SituacaoAluno = " & strSituacaoAluno
	rs.open sql, cnn
	if not RS.EOF then
		strDescSituacao = trim(ucase(rs("Desc_SituacaoAluno")))
	end if
	rs.close
	if isnull(strDescSituacao) then strDescSituacao = ""

	IF TRIM(strDescSituacao) = "ATIVO" AND strDataMatricula = "" THEN 
		%>
		<script>
			alert("A data da matrícula não será alterada.");
		</script>
		<%
	END IF
	
	cnn.begintrans
	
	vetAluno = split(intCodAluno,",")
	for i=0 to ubound(vetAluno)
		intCodAluno			= vetAluno(i)
		
		strDescSituacaoAnterior=""
		'BUSCA SITUACAO ATUAL DO ALUNO
		sql = "select s.Desc_SituacaoAluno"
		sql = sql & " from sca_aluno a"
		sql = sql & " inner join sca_situacaoaluno s on s.Cod_SituacaoAluno = a.Cod_SituacaoAluno"
		sql = sql & " where	a.codigo = " & intCodAluno
		rs.open sql, cnn
		if not RS.EOF then
			strDescSituacaoAnterior = ucase(rs("Desc_SituacaoAluno"))
		end if
		rs.close

		'busca turma do aluno
		sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo"
		sql = sql & " where AT.COD_EMPRESA = " &  intCodEmp
		sql = sql & " and AT.COD_ALUNO = " &  intCodAluno
		sql = sql & " and AT.ANO_LETIVO = " &  strAnoLetivo
		sql = sql & " order by codigo desc "
		rs.open sql, cnn
		if not rs.eof then
			strCodTurma = rs("cod_Turma")
		end if
		rs.close
	
		if 	strCodTurma = "" then strCodTurma = "0"
		' Consulto o Nome da Turma
		if strCodTurma <> "0" then
			
			sql = "select COD_SEMESTRE from SCA_TURMA"
			sql = sql & " Where Cod_Empresa = " & intCodEmp
			sql = sql & " And Cod_Turma = " & strCodTurma
			rs.open sql, cnn
			if rs.eof = false then
				strSemestre = RS("COD_SEMESTRE")
			end if
			rs.close
			
			' atualiza semestre na aluno turma
			sql = " update SCA_ALUNO_TURMA set SEMESTRE = " & strSemestre
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			sql = sql & " and 	Cod_Aluno = " & intCodAluno
			cnn.execute sql
			GravarLog sql	
				
		else
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: O Aluno ainda não alocado para o período letivo, verifique!");
				window.history.back();
			</script>
			<%
			response.end
		end if

		if trim(strDescSituacao) <> "ATIVO" then    '' Atualizar vagas matrícula informatizada
			sql = "SELECT S.Desc_SituacaoAluno "
			sql = sql & " FROM SCA_ALUNO A"
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
			sql = sql & " Where A.codigo = " & intCodAluno
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
			end if
			rsAux.close	
			
			if trim(strDescSituacao) <> trim(strAntigaDescSituacaoAluno) then
				'atualiza vagas
				sql = "update SCA_TURMA "
				sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-1 "
				sql = sql & " where COD_EMPRESA = " & intCodEmp
				sql = sql & " and 	Cod_Turma = " & strCodTurma
				cnn.execute sql
				GravarLog sql	
			    
				sql = "Delete from MAT_inscricao"
				sql = sql & " Where Cod_Empresa = " & intCodEmp
				sql = sql & " And cod_aluno = " & intCodAluno
				cnn.execute sql
				GravarLog sql

			end if
		end if	

		if trim(strDescSituacao) = "ATIVO" then    '' Atualizar vagas matrícula informatizada
			sql = "SELECT S.Desc_SituacaoAluno "
			sql = sql & " FROM SCA_ALUNO A"
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
			sql = sql & " Where A.codigo = " & intCodAluno
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
			end if
			rsAux.close	
			
			if trim(strDescSituacao) <> trim(strAntigaDescSituacaoAluno) then
				'atualiza vagas
				sql = "update SCA_TURMA "
				sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+1 "
				sql = sql & " where COD_EMPRESA = " & intCodEmp
				sql = sql & " and 	Cod_Turma = " & strCodTurma
				cnn.execute sql
				GravarLog sql
				
				'sql = "Delete from MAT_inscricao"
				'sql = sql & " Where Cod_Empresa = " & intCodEmp
				'sql = sql & " And cod_aluno = " & intCodAluno
				'cnn.execute sql
				'GravarLog sql
	
			end if
		end if	

	
		' atualiza situação aluno
		sql = " update SCA_ALUNO set COD_SITUACAOALUNO = " & strSituacaoAluno
		IF TRIM(strDescSituacao) <> "ATIVO" AND strDatafastamento = "" THEN 
			strDatafastamento 	= FORMATADATABD(DATE)
			strDataMatricula 	= ""
		END IF
	
		IF TRIM(strDescSituacao) = "ATIVO" THEN 
			strDatafastamento 	= ""
		END IF
	
		if trim(strDatafastamento) <> "" then
			sql = sql & ",DATAFASTAMENTO = '" & strDatafastamento & "'"
		else
			sql = sql & ",DATAFASTAMENTO = null"
		end if
	
		if trim(strDataMatricula) <> "" then
			sql = sql & ",DATAMATRICULA = '" & strDataMatricula & "'"
		end if
		sql = sql & " Where codigo = " & intCodAluno
		cnn.execute sql
		GravarLog sql	
		
		'Verifico se existe histórico de situações para o aluno
		sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
		sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
		sql = sql & " AND COD_ALUNO = " & intCodAluno
		sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
		sql = sql & " AND SEMESTRE = " & strSemestre
		rs.open sql, cnn
		if rs.eof = false then
		   existeSituacao = "OK"
		else
		   existeSituacao = "NO"
		end if
		rs.close	
	
		if existeSituacao = "OK" then
			'ATUALIZO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
			sql = "UPDATE SCA_SITUACAO_ACADEMICA_ALUNO "
			sql = sql & " SET COD_SITUACAOALUNO = " & strSituacaoAluno & ", DATA_SITUACAO = '" & FORMATADATABD(DATE) & "'"
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	COD_ALUNO = " & intCodAluno
			sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
			sql = sql & " and 	SEMESTRE = " & strSemestre
			cnn.execute sql
			GravarLog sql
		else   
			'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
			sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "" & intCodAluno & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & strSituacaoAluno & "," 
			sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql
		end if	
		
		'GRAVA NO CONTROLE SITUACAO ALUNO
		sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & intCodAluno & "," 
		sql = sql & "" & strAnoLetivo & "," 
		sql = sql & "" & strSemestre & "," 
		sql = sql & "" & strSituacaoAluno & "," 
		sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
		cnn.execute sql
		GravarLog sql		
	
		sql = " update SCA_ALUNO_ANO_LETIVO set "
		IF TRIM(strDescSituacao) = "ATIVO" OR TRIM(strDescSituacao) = "PRÉ-MATRÍCULA" THEN 
			sql = sql & " SITUACAO = 'A'"
		ELSE
			sql = sql & " SITUACAO = 'I'"
		END IF
		sql = sql & " Where cod_ALUNO = " & intCodAluno
		sql = sql & " And cod_empresa = " & intCodEmp
		sql = sql & " And ANO_LETIVO = " & strAnoLetivo
		cnn.execute sql
		GravarLog sql
		
		IF TRIM(strSituacaoAluno) = "1" THEN 
			sql = " update SCA_ALUNO_TURMA set "
			sql = sql & " SITUACAO = 'A', DATA_SITUACAO = GETDATE()"
			sql = sql & " Where cod_ALUNO = " & intCodAluno
			sql = sql & " And cod_empresa = " & intCodEmp
			sql = sql & " And ANO_LETIVO = " & strAnoLetivo
			sql = sql & " And CODIGO IN (SELECT MAX(CODIGO) FROM SCA_ALUNO_TURMA WHERE cod_ALUNO = " & intCodAluno & " And cod_empresa = " & intCodEmp & " And ANO_LETIVO = " & strAnoLetivo & ")"
			cnn.execute sql
			GravarLog sql		
			
			sql = " update sca_aluno_turma_situacao set "
			sql = sql & " SITUACAO = 'A', "
			sql = sql & " cod_situacaoaluno=" & strSituacaoAluno & ""
			sql = sql & " Where cod_ALUNO = " & intCodAluno
			sql = sql & " And cod_empresa = " & intCodEmp
			sql = sql & " And ANO_LETIVO = " & strAnoLetivo
			cnn.execute sql
			GravarLog sql	
		END IF
		
		IF TRIM(strSituacaoAluno) <> "1" THEN 
			'1	ATIVO
			'3	CANCELADO
			'4	DESISTENTE
			'5	TRANSFERIDO
		
			sql = " update SCA_ALUNO_TURMA set "
			IF TRIM(strSituacaoAluno) = "3" THEN 
				sql = sql & " SITUACAO = 'C', "
			END IF
			IF TRIM(strSituacaoAluno) = "4" THEN 
				sql = sql & " SITUACAO = 'D', "
			END IF
			IF TRIM(strSituacaoAluno) = "5" THEN 
				sql = sql & " SITUACAO = 'T', "
			END IF
			
			sql = sql & " DATA_SITUACAO = GETDATE()"
			sql = sql & " Where cod_ALUNO = " & intCodAluno
			sql = sql & " And cod_empresa = " & intCodEmp
			sql = sql & " And ANO_LETIVO = " & strAnoLetivo
			sql = sql & " And SITUACAO = 'A'"
			cnn.execute sql
			GravarLog sql			
			
			sql = " update sca_aluno_turma_situacao set "
			IF TRIM(strSituacaoAluno) = "3" THEN 
				sql = sql & " SITUACAO = 'C', "
			END IF
			IF TRIM(strSituacaoAluno) = "4" THEN 
				sql = sql & " SITUACAO = 'D', "
			END IF
			IF TRIM(strSituacaoAluno) = "5" THEN 
				sql = sql & " SITUACAO = 'T', "
			END IF
			sql = sql & " cod_situacaoaluno=" & strSituacaoAluno & ""
			sql = sql & " Where cod_ALUNO = " & intCodAluno
			sql = sql & " And cod_empresa = " & intCodEmp
			sql = sql & " And ANO_LETIVO = " & strAnoLetivo
			sql = sql & " And SITUACAO = 'A'"
			cnn.execute sql
			GravarLog sql	
		END IF		
		
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
	
		intCodEmp			= intCodEmp
		intCodDepartamento	= Session("CodDeptoUsuario")
		intCodTaxa			= ""
		intCodBebitoAluno	= ""
		strDataOcorrencia	= formatadataBD(date)
		strUsuarioIncl		= trim(session("usuarioWeb"))
		strDataValidade		= ""
		strOcorrencia		= "Alteração da Situação por turma do Aluno de " & strDescSituacaoAnterior & " para " & strDescSituacao & "."
		%>
		<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
		<%	
	next
	
	
	'ATUALIZA SITUACAO_ALUNO
	sql = "EXEC [dbo].[SP_SCA_ATUALIZA_SITUACAO_ALUNO] " & strAnoLetivo
	cnn.execute sql
	
	strMensagem = "Situação do Aluno foi Atualizado com sucesso..."
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_troca_situacao_aluno.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>