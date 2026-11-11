<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo		 		= Trim(Request.Form("txtCodigo"))
	intCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strDataOcorrencia 		= FORMATADATABD(Trim(Request.Form("txtDataOcorrencia"))) & " " & time
	strDataValidade 		= FORMATADATABD(Trim(Request.Form("txtDataValidade")))
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
	strTipoOcorrencia		= Trim(Request.Form("cmbTipoOcorrencia"))
    
	strAnoLetivo = session("strAnoLetivo")
	intSemestre  = session("strSemestre")
	
	'busca turma do aluno
	sql = "select AT.COD_TURMA, T.Cod_GradeCurricular"
	sql = sql & " from SCA_ALUNO_TURMA AT"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
	sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
	sql = sql & " where AT.COD_EMPRESA = " &  intCodEmp
	sql = sql & " and AT.COD_ALUNO = " &  intCodAluno
	sql = sql & " and AT.ANO_LETIVO = " &  session("strAnoLetivo")
	sql = sql & " and AT.SEMESTRE IN (" &  session("strSemestre") & ")"
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
			intSemestre = RS("COD_SEMESTRE")
		end if
		rs.close	

	end if	
				
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_OCORRENCIA(COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, DATAVALIDADE, OCORRENCIA, USUARIO_INCL,  INCLUSAO, TIPO_OCORRENCIA)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "GETDATE(),"
		IF strDataValidade = "" THEN
			sql = sql & "NULL,"
		ELSE
			sql = sql & "'" & strDataValidade & "',"
		END IF
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',"
		sql = sql & "'USUARIO',"
		sql = sql & "'" & strTipoOcorrencia & "')"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_OCORRENCIA Set"
		sql = sql & " COD_ALUNO = " & intCodAluno & ","
		sql = sql & " DATAOCORRENCIA = '" & strDataOcorrencia & "',"
		IF strDataValidade = "" THEN
			sql = sql & " DATAVALIDADE = NULL,"
		ELSE
			sql = sql & " DATAVALIDADE = '" & strDataValidade & "',"
		END IF
		sql = sql & " OCORRENCIA = '" & strOcorrencia & "',"
		sql = sql & " TIPO_OCORRENCIA = '" & strTipoOcorrencia & "'"
		sql = sql & " where COD_OCORRENCIA = " & intCodigo
		sql = sql & " and COD_empresa = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SCA_OCORRENCIA "
		sql = sql & " where COD_OCORRENCIA = " & intCodigo
		sql = sql & " and COD_empresa = " & intCodEmp
		
	end if
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_ocorrencia_academica.asp';
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