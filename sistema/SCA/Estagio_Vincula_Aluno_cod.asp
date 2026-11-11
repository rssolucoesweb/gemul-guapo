<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 25/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Vincula aluno ao estagio
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCod_Empresa 			= Session("CodEmpresa")
	intSemestre			 	= Trim(Request.Form("cmbSemestre"))
	intAnoLetivo			= session("strAnoLetivo")	
	intCodEstagio		 	= Trim(Request.Form("cmbEstagio"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strDataVinculo			= formatadataBD(date) 
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	if acao="I" then
		
		sql = " Delete from SCA_ESTAGIO_VINCULO"
		sql = sql & " Where CodEstagio = " & intCodEstagio
		sql = sql & " and ano_letivo = " & intAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and cod_empresa = " & intCod_Empresa
		cnn.execute sql
		GravarLog sql

		strMensagem = "Alunos Vinculados com sucesso..."
	
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
		
			strCodAluno			= trim(vetCodAluno(intContador))
			
			sql = " SELECT TOP 1 T.COD_TURMA FROM SCA_ALUNO A "
			sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
			sql = sql & " WHERE A.CODIGO = " & strCodAluno 
			sql = sql & " Order BY AT.CODIGO DESC "
			RS.OPEN SQL, CNN
			IF not RS.EOF THEN
				intCodTurma = rs("COD_TURMA")
			else
				strMensagem =  " Seleção de aluno(s) ainda não alocado. Verique! " 
				%>
				<script>
					alert("<%=strMensagem%>");
					window.location='Estagio_Vincula_Aluno_cad.asp';
				</script>
				<%
				rs.close
				response.end
			END IF
			rs.close

			
			sql = " Insert into SCA_ESTAGIO_VINCULO (Cod_empresa, cod_aluno, codTurma, ano_letivo, semestre, CodEstagio, DataVinculo)"
			sql = sql & " VALUES ("
			sql = sql & " " & intCod_Empresa & ","
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & " " & intAnoLetivo & ","
			sql = sql & " " & intSemestre & ","
			sql = sql & " " & intCodEstagio & ","
			sql = sql & " '" & strDataVinculo & "')"
			cnn.execute sql
			GravarLog sql

		next
	
	elseif acao="A" then
		
		sql = " Delete from SCA_ESTAGIO_VINCULO"
		sql = sql & " Where CodEstagio = " & intCodEstagio
		sql = sql & " and ano_letivo = " & intAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and cod_empresa = " & intCod_Empresa
		cnn.execute sql
		GravarLog sql

		strMensagem = "Vinculo Alterado com sucesso..."
	
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
		
			strCodAluno	= trim(vetCodAluno(intContador))
			
			sql = " SELECT TOP 1 T.COD_TURMA FROM SCA_ALUNO A "
			sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
			sql = sql & " WHERE A.CODIGO = " & strCodAluno 
			sql = sql & " Order BY AT.CODIGO DESC "
			RS.OPEN SQL, CNN
			IF not RS.EOF THEN
				intCodTurma = rs("COD_TURMA")
			else
				strMensagem =  " Seleção de aluno(s) ainda não alocado. Verique! " 
				%>
				<script>
					alert("<%=strMensagem%>");
					window.location='Estagio_Vincula_Aluno_cad.asp';
				</script>
				<%
				rs.close
				response.end
			END IF
			rs.close

			
			sql = " Insert into SCA_ESTAGIO_VINCULO (cod_empresa, cod_aluno, codTurma, ano_letivo, semestre, CodEstagio, DataVinculo)"
			sql = sql & " VALUES ("
			sql = sql & " " & intCod_Empresa & ","
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & " " & intAnoLetivo & ","
			sql = sql & " " & intSemestre & ","
			sql = sql & " " & intCodEstagio & ","
			sql = sql & " '" & strDataVinculo & "')"
			
			cnn.execute sql
			GravarLog sql

		next
			
	elseif acao="E" then
		
		strMensagem = "Alunos Desvinculado com sucesso..."
		
		sql = " Delete from SCA_ESTAGIO_VINCULO"
		sql = sql & " Where CodEstagio = " & intCodEstagio
		sql = sql & " and ano_letivo = " & intAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and cod_empresa = " & intCod_Empresa
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Estagio_Vincula_Aluno_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>