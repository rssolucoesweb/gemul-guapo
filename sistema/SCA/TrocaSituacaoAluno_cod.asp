<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: troca situacao aluno
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
		
	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")
		
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula		= Trim(Request("txtMatricula"))	
	strDatafastamento	= formatadataBD(Trim(Request("txtDatafastamento")))
	strDataMatricula	= formatadataBD(Trim(Request("txtDatamatricula")))
	
	strSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))	
	strDescSituacaoAnterior = ""
	strDescSituacao 		= ""
	
	'BUSCA SITUACAO ATUAL DO ALUNO
	sql = "select s.Desc_SituacaoAluno"
	sql = sql & " from sca_aluno a"
	sql = sql & " inner join sca_situacaoaluno s on s.Cod_SituacaoAluno = a.Cod_SituacaoAluno and s.cod_empresa = a.cod_empresa"
	sql = sql & " where	a.codigo = " & strCodAluno
	sql = sql & " and	a.cod_empresa = " & intCodEmp
	rs.open sql, cnn
	if not RS.EOF then
		strDescSituacaoAnterior = ucase(rs("Desc_SituacaoAluno"))
	end if
	rs.close
	

	'REGRA PARA SITUACAO ATUAL DO ALUNO
	sql = "select REPLACE(REPLACE(Desc_SituacaoAluno,'É','E'),'Í','I') AS Desc_SituacaoAluno "
	sql = sql & " FROM SCA_SITUACAOALUNO"
	sql = sql & " where Cod_SituacaoAluno = " & strSituacaoAluno
	sql = sql & " AND COD_EMPRESA = " & intCodEmp
	rs.open sql, cnn
	if not RS.EOF then
		strDescSituacao = trim(ucase(rs("Desc_SituacaoAluno")))
	end if
	rs.close
	if isnull(strDescSituacao) then strDescSituacao = ""

	if trim(ucase(strDescSituacao)) = "PRE-MATRICULA" then
		%>
		<script>
			alert("ATENÇÃO: Esse aluno não poderá trocar a situação para PRÉ-MATRÍCULA.\nAlteração para PRÉ-MATRÍCULA só é permitida na renovação/matrícula.");
			window.location='TrocaSituacaoAluno_cad.asp?txtMatricula=<%=strMatricula%>';
		</script>
		<%
		response.End()
	end if
	if TRIM(UCASE(strDescSituacaoAnterior)) = "ATIVO" and strDescSituacao = "ATIVO" then
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
		sql = sql & " and d.cod_empresa = " & intCodEmp
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
	sql = "select TOP 1 AT.COD_TURMA, T.Cod_GradeCurricular, T.Cod_Semestre"
	sql = sql & " from SCA_ALUNO_TURMA AT"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
	sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
	sql = sql & " where AT.COD_EMPRESA = " &  intCodEmp
	sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
	sql = sql & " and AT.SITUACAO = 'A'"'ATIVA
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

	if trim(strDescSituacao) <> "ATIVO" then    '' Atualizar vagas matrícula informatizada
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & intCodEmp
		sql = sql & " And 	A.codigo = " & strCodAluno
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
		end if
		rsAux.close	
		
		if trim(strDescSituacao) <> trim(strAntigaDescSituacaoAluno) then
			'atualiza vagas
			sql = "update SCA_TURMA "
			sql = sql & " SET VagasMatriculasUtilizadas = isnull(VagasMatriculasUtilizadas,0)-0"
			sql = sql & " where COD_EMPRESA = " & intCodEmp
			sql = sql & " and 	Cod_Turma = " & strCodTurma
			cnn.execute sql
			GravarLog sql	
		end if
	end if	

	if trim(strDescSituacao) = "ATIVO" then    '' Atualizar vagas matrícula informatizada
		sql = "SELECT S.Desc_SituacaoAluno "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & intCodEmp
		sql = sql & " And 	A.codigo = " & strCodAluno
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strAntigaDescSituacaoAluno = TRIM(rsAux("Desc_SituacaoAluno"))
		end if
		rsAux.close	
		
		if trim(strDescSituacao) <> trim(strAntigaDescSituacaoAluno) then
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
	IF TRIM(strDescSituacao) <> "ATIVO" AND strDatafastamento = "" THEN 
		strDatafastamento 	= FORMATADATABD(DATE)
		strDataMatricula 	= ""
	END IF

	IF TRIM(strDescSituacao) = "ATIVO" THEN 
		strDatafastamento 	= ""
	END IF
	
	IF TRIM(strDescSituacao) = "ATIVO" AND strDataMatricula = "" THEN 
		%>
		<script>
			alert("A data da matrícula não será alterada.");
		</script>
		<%
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
	sql = sql & " and	cod_empresa = " & intCodEmp
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
		GravarLog sql
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
		GravarLog sql
	end if	

	'GRAVA NO CONTROLE SITUACAO ALUNO
	sql = "insert into SCA_CONTROLE_SITUACAO_ALUNO (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, COD_SITUACAOALUNO, DATA_SITUACAO) VALUES ("
	sql = sql & "" & intCodEmp & "," 
	sql = sql & "" & strCodAluno & "," 
	sql = sql & "" & strAnoLetivo & "," 
	sql = sql & "" & strSemestre & "," 
	sql = sql & "" & strSituacaoAluno & "," 
	sql = sql & "'"&formataDataBD(date)& " " &time& "')" 			
	cnn.execute sql
	GravarLog sql		

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
	strOcorrencia		= "Alteração da Situação do Aluno de " & strDescSituacaoAnterior & " para " & strDescSituacao & "."
	%>
	<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
	<%						

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TrocaSituacaoAluno_cad.asp?txtMatricula=<%=strMatricula%>';
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