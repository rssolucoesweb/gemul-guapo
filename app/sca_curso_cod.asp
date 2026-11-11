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
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Replace(Trim(Request("txtDescricao")),"'","")
	strDescAbreviada	= Replace(Trim(Request("txtDescAbreviada")),"'","") 
	strDescHistorico	= Replace(Trim(Request("txtDescHistorico")),"'","") 
	strSigla			= Replace(Trim(Request("txtSigla")),"'","")
	intCodGrau			= Trim(Request.Form("cmbGrau"))

	strhabilitacao		= Request.Form("txthabilitacao")
	strreconhecimento	= Request.Form("txtreconhecimento")
	strautorizacao		= Request.Form("txtautorizacao")

	strDataReconhecimento= formatadataBD(Request.Form("txtDataReconhecimento"))
	strDataAutorizacao	 = formatadataBD(Request.Form("txtDataAutorizacao"))

	strGrauAcademico	= Trim(Request.Form("txtGrauAcademico"))
	strModalidade		= Trim(Request.Form("cmbModalidade"))
	strCodigoInep		= Trim(Request.Form("txtCodigoInep"))
	strDataInicioCurso	= Request.Form("txtDataInicioCurso")
	strSituacao        	= Request.Form("cmbSituacao")


	strCHExigida		= Request.Form("txtCHExigida")
	strsimounao         = Request.Form("cmbSimouNao")

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "SELECT Max(Cod_curso) as MaiorCodigo" 
		sql = sql & " FROM SCA_CURSO"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
	
		sql = "Insert Into SCA_CURSO(Descricao, Desc_Abreviada, Desc_Historico, Sigla, Cod_Grau, habilitacao, reconhecimento, autorizacao, dataReconhecimento, DataAutorizacao, CH_Exigida, processo_seletivo, Cod_Inep, Grau_Academico, Modalidade, Inicio_Funcionamento, Situacao)"
		sql = sql & " Values ("
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDescAbreviada & "',"
		sql = sql & "'" & strDescHistorico & "',"
		sql = sql & "'" & strSigla & "',"
		sql = sql & "" & intCodGrau & ","
		sql = sql & "'" & strhabilitacao & "',"
		sql = sql & "'" & strreconhecimento & "',"
		sql = sql & "'" & strautorizacao & "',"
		sql = sql & "'" & strDataReconhecimento & "',"
		sql = sql & "'" & strDataAutorizacao & "',"
		
		if strCHExigida = "" then
			sql = sql & "null ,"
		else
			sql = sql & "'" & strCHExigida & "',"
		end if

		sql = sql & "'" & strsimounao & "'," ' Processo Seletivo
		if strCodigoInep = "" then
			sql = sql & "null ,"
		else
			sql = sql & "" & strCodigoInep & ","
		end if
		if strGrauAcademico = "" then
			sql = sql & "null ,"
		else
			sql = sql & "'" & strGrauAcademico & "',"
		end if
		if strModalidade = "" then
			sql = sql & "null ,"
		else
			sql = sql & "'" & strModalidade & "',"
		end if
		if strDataInicioCurso = "" then
			sql = sql & "null ,"
		else
			sql = sql & "'" & strDataInicioCurso & "',"
		end if
		if strSituacao = "" then
			sql = sql & "null')"
		else
			sql = sql & "'" & strSituacao & "')"
		end if


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_CURSO Set"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "',"
		sql = sql & " Desc_Historico = '" & strDescHistorico & "',"
		sql = sql & " Sigla = '" & strSigla & "',"
		sql = sql & " habilitacao = '" & strhabilitacao & "',"
		sql = sql & " reconhecimento = '" & strreconhecimento & "',"
		sql = sql & " autorizacao = '" & strautorizacao & "',"
		if strDataReconhecimento = "" then
			sql = sql & " datareconhecimento = null,"
		else
			sql = sql & " datareconhecimento = '" & strDataReconhecimento & "',"
		end if
		if strDataAutorizacao = "" then
			sql = sql & " dataautorizacao = null,"
		else
			sql = sql & " dataautorizacao = '" & strDataAutorizacao & "',"
		end if
		if strCHExigida = "" then
			sql = sql & " CH_Exigida = null,"
		else
			sql = sql & " CH_Exigida = '" & strCHExigida & "',"
		end if
		sql = sql & " Cod_Grau = " & intCodGrau & ","
		sql = sql & " Processo_Seletivo = '" & strsimounao & "',"

		if strCodigoInep = "" then
			sql = sql & " Cod_Inep = null,"
		else
			sql = sql & " Cod_Inep = '" & strCodigoInep & "',"
		end if

		if strGrauAcademico = "" then
			sql = sql & " Grau_Academico = null,"
		else
			sql = sql & " Grau_Academico = '" & strGrauAcademico & "',"
		end if
		if strModalidade = "" then
			sql = sql & " Modalidade = null,"
		else
			sql = sql & " Modalidade = '" & strModalidade & "',"
		end if
		if strDataInicioCurso = "" then
			sql = sql & " Inicio_Funcionamento = null,"
		else
			sql = sql & " Inicio_Funcionamento = '" & strDataInicioCurso & "',"
		end if
		if strSituacao = "" then
			sql = sql & " Situacao = null"
		else
			sql = sql & " Situacao = '" & strSituacao & "'"
		end if
		sql = sql & " where Cod_curso = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_CURSO "
		sql = sql & " where Cod_curso = " & intCodigo
	
	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_curso.asp';
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