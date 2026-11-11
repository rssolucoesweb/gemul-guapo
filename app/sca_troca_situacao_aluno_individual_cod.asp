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
	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")
		
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula		= Trim(Request("txtMatricula"))	
	strDatafastamento	= formatadataBD(Trim(Request("txtDatafastamento")))
	strDataMatricula	= formatadataBD(Trim(Request("txtDatamatricula")))
	
	strSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))	
	strSituacaoAlunoAtual	= Trim(Request.Form("txtSituacaoAlunoAnterior"))	
	strDescSituacaoAnterior = ""
	strDescSituacao 		= ""
	
	'REGRA PARA SITUACAO ATUAL DO ALUNO
	sql = "select REPLACE(REPLACE(Desc_SituacaoAluno,'É','E'),'Í','I') AS Desc_SituacaoAluno "
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " where Cod_SituacaoAluno = " & strSituacaoAluno
	rs.open sql, cnn
	if not RS.EOF then
		strSituacaoAlunoNova = trim(ucase(rs("Desc_SituacaoAluno")))
	end if
	rs.close
	if isnull(strSituacaoAlunoNova) then strSituacaoAlunoNova = ""

	if trim(ucase(strDescSituacao)) = "PRE-MATRICULA" then
		%>
		<script>
			alert("ATENÇÃO: Esse aluno não poderá trocar a situação para PRÉ-MATRÍCULA.\nAlteração para PRÉ-MATRÍCULA só é permitida na renovação/matrícula.");
			window.location='sca_troca_situacao_aluno_individual.asp?txtMatricula=<%=strMatricula%>';
		</script>
		<%
		response.End()
	end if
	if TRIM(UCASE(strSituacaoAlunoAtual)) = "ATIVO" and strSituacaoAlunoNova = "ATIVO" then
		%>
		<script>
			alert("ATENÇÃO: O aluno não poderá ser ativado nessa opção, porque ele já esta ATIVO.");
			window.history.back();
		</script>
		<%
		response.End()
	end if		

	bolDocumentacao = false

    if Session("NivelPermissao") <> "A" then 
		'REGRA PARA VERIFICAR SE A DOCUMENTAÇÃO DO ALUNO ESTA EM DIAS
		sql = "select d.descricao as docs, ad.data_prorrogacao "
		sql = sql & " from SCA_ALUNO_DOCUMENTACOES ad"
		sql = sql & " inner join sca_documentacoes d on d.codigo=ad.cod_documentacoes"
		sql = sql & " where ad.cod_aluno = " & strCodAluno
		sql = sql & " and ad.situacao = 'I'"
		strDocs = ""
		strMsn = false
		rs.open sql, cnn,3,3
		if not rs.eof then	
			while not rs.eof
				if not isnull(rs("data_prorrogacao")) then
					if rs("data_prorrogacao")<date then
						strMsn = true
						strDocs	= strDocs & "- " & rs("Docs") & "\n"
					end if
				else
					strMsn = true
					strDocs	= strDocs & "- " & rs("Docs") & "\n"
				end if
				rs.movenext
			wend
	
			if strMsn then
				%>
				<script>
					alert("ATENÇÃO: \nEsse aluno esta com a documentação irregular, favor verificar os documentos:\n\n<%=strDocs%>");
				</script>
				<%	
			end if
		end if
		rs.close
    end if
	 
	strMensagem = "Registro atualizado com sucesso..."

	'busca turma do aluno
	sql = "select TOP 1 AT.COD_TURMA, AT.CODIGO, T.Cod_GradeCurricular, T.Cod_Semestre"
	sql = sql & " from SCA_ALUNO_TURMA AT"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
	sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
	sql = sql & " where AT.COD_EMPRESA = " &  intCodEmp
	sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
	sql = sql & " ORDER BY AT.CODIGO"
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
	else
		strSemestre = "3"
		%>
        <script>
			alert("ATENÇÃO: O Aluno ainda não alocado para o período letivo, verifique!");
		</script>
        <%
	end if

	cnn.begintrans

	if trim(strSituacaoAlunoNova) <> "ATIVO" then    '' Atualizar vagas matrícula informatizada
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO "
		sql = sql & " Where A.codigo = " & strCodAluno
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
		end if
		rsAux.close	
		
		if trim(strSituacaoAlunoNova) <> trim(strSituacaoAlunoAtual) then
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-0"
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql	
		end if
	else
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO"
		sql = sql & " Where A.codigo = " & strCodAluno
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
		end if
		rsAux.close	
		
		if trim(strSituacaoAlunoNova) <> trim(strSituacaoAlunoAtual) then
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)+0"
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql	
		end if
	end if	

	' atualiza situação aluno
	sql = " update SCA_ALUNO set COD_SITUACAOALUNO = " & strSituacaoAluno
	IF TRIM(strSituacaoAlunoNova) <> "ATIVO" AND strDatafastamento = "" THEN 
		strDatafastamento 	= FORMATADATABD(DATE)
		strDataMatricula 	= ""
	END IF

	IF TRIM(strSituacaoAlunoNova) = "ATIVO" THEN 
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
	sql = sql & " Where codigo = " & strCodAluno
	cnn.execute sql
	GravarLog sql		

	
	'Verifico se existe histórico de situações para o aluno
    sql = "SELECT COD_ALUNO FROM SCA_SITUACAO_ACADEMICA_ALUNO"
	sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
	sql = sql & " AND COD_ALUNO = " & strCodAluno
	sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
	sql = sql & " AND Semestre in (" & strSemestre & ")"
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
		sql = sql & " and 	COD_ALUNO = " & strCodAluno
		sql = sql & " and 	ANO_LETIVO = " & strAnoLetivo
		sql = sql & " and 	Semestre in (" & strSemestre & ")"
		cnn.execute sql
	
	else   
		'INSERINDO HISTORICO DE SITUACAO DA TURMA POR ANO/SEMESTRE
		sql = "insert into SCA_SITUACAO_ACADEMICA_ALUNO (COD_EMPRESA, ANO_LETIVO, SEMESTRE, COD_ALUNO, COD_TURMA, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
		sql = sql & "" & intCodEmp & "," 
		sql = sql & "" & strAnoLetivo & "," 
		sql = sql & "" & strSemestre & "," 
		sql = sql & "" & strCodAluno & "," 
		sql = sql & "" & strCodTurma & "," 
		sql = sql & "" & strSituacaoAluno & ","
		sql = sql & "'"& formataDataBD(date)& " " &time& "')" 
		cnn.execute sql
	
	end if	

	'GRAVA NO CONTROLE SITUACAO ALUNO
	sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO,USUARIO_INCL) VALUES ("
	sql = sql & "" & intCodEmp & "," 
	sql = sql & "" & strCodAluno & "," 
	sql = sql & "" & strAnoLetivo & "," 
	sql = sql & "" & strSemestre & "," 
	sql = sql & "" & strSituacaoAluno & "," 
	sql = sql & "'"&formataDataBD(date)& " " &time& "','sca_troca_situacao_aluno_individual_cod.asp linha 246')" 			
	cnn.execute sql
	

	sql = " update SCA_ALUNO_ANO_LETIVO set "
	IF TRIM(strSituacaoAluno) = "1" OR TRIM(strSituacaoAluno) = "2" THEN 
		sql = sql & " SITUACAO = 'A'"
	ELSE
		sql = sql & " SITUACAO = 'I'"
	END IF
	sql = sql & " Where cod_ALUNO = " & strCodAluno
	sql = sql & " And cod_empresa = " & intCodEmp
	sql = sql & " And ANO_LETIVO = " & strAnoLetivo
	sql = sql & " And SITUACAO = 'A'"
	cnn.execute sql
	
	
	IF TRIM(strSituacaoAluno) = "1" THEN 
		sql = " update SCA_ALUNO_TURMA set "
		sql = sql & " SITUACAO = 'A', DATA_SITUACAO = GETDATE()"
		sql = sql & " Where cod_ALUNO = " & strCodAluno
		sql = sql & " And cod_empresa = " & intCodEmp
		sql = sql & " And ANO_LETIVO = " & strAnoLetivo
		sql = sql & " And CODIGO IN (SELECT MAX(CODIGO) FROM SCA_ALUNO_TURMA WHERE cod_ALUNO = " & strCodAluno & " And cod_empresa = " & intCodEmp & " And ANO_LETIVO = " & strAnoLetivo & ")"
		cnn.execute sql
		GravarLog sql			
	END IF
	
	IF TRIM(strSituacaoAluno) <> "1" and  TRIM(strSituacaoAluno)<>"2" THEN 'CANCELA NA MATRICULA
		'	Cod_SituacaoAluno	Desc_SituacaoAluno
		'1	ATIVO
		'2	PRÉ-MATRÍCULA
		'3	CANCELADO
		'4	DESISTENTE
		'5	TRANSFERIDO
		'7	NÃO ALOCADO
		'8	FALECIDO
		sit = "cancelado"
		if strSituacaoAluno="3" then
			sit = "cancelado"
		elseif strSituacaoAluno="4" then
			sit = "desistente"
		elseif strSituacaoAluno="5" then
			sit = "transferido"
		elseif strSituacaoAluno="8" then
			sit = "falecido"
		end if
		
		sql = "update MAT_reserva SET usuario_exc_cadastro = '" & SESSION("USUARIOWEB") & "', data_exc_cadastro = getdate(), ocorrencia = 'Aluno " & sit & " pela troca de situação no academico'"
		sql = sql & " WHERE cod_aluno = " & strCodAluno
		sql = sql & " AND usuario_exc_cadastro IS NULL"
		cnn.execute sql

		sql = "update MAT_inscricao SET usuario_exc = '" & SESSION("USUARIOWEB") & "', data_exc = getdate(), Ocorrencia='Aluno " & sit & " pela troca de situação no academico'"
		sql = sql & " WHERE cod_aluno = " & strCodAluno
		sql = sql & " AND data_exc_cadastro IS NULL and data_exc is null"
		cnn.execute sql
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
		sql = sql & " Where cod_ALUNO = " & strCodAluno
		sql = sql & " And cod_empresa = " & intCodEmp
		sql = sql & " And ANO_LETIVO = " & strAnoLetivo
		sql = sql & " And SITUACAO = 'A'"
		cnn.execute sql
		GravarLog sql			
	END IF
	
	'Gera Ocorrencia Automatica de troca de situação
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
	intCodAluno			= strCodAluno
	intCodTaxa			= ""
	intCodBebitoAluno	= ""
	strDataOcorrencia	= formatadataBD(date)
	strUsuarioIncl		= trim(session("usuarioWeb"))
	strDataValidade		= ""
	strOcorrencia		= "Alteração da Situação do Aluno de " & strSituacaoAlunoAtual & " para " & strSituacaoAlunoNova & "."
	%>
	<!--#include file="includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%	
	
	'ATUALIZA SITUACAO_ALUNO
	sql = "EXEC [dbo].[SP_SCA_ATUALIZA_SITUACAO_ALUNO] " & strAnoLetivo & "," & strCodAluno
	'response.write sql
	cnn.execute sql
	
	'atualiza vagas
	sql = "EXEC SP_MAT_AtualizaTurmaVagaMatricula " & strAnoLetivo & ", 1"
	cnn.execute sql

	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_troca_situacao_aluno_individual.asp';
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