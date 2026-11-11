<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formataData.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strSigla	 			= Trim(Request.Form("txtSigla"))
	intCodFichaDescritiva	= Trim(Request.form("cmbFichaDescritiva"))
	intCodPergunta			= Trim(Request.form("cmbFichaDescritivaPergunta"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strValorInicial 		= replace(replace(trim(request.form("txtValorInicial")),".",""),",",".")
	strValorFinal 			= replace(replace(trim(request.form("txtValorFinal")),".",""),",",".") 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA(Cod_empresa, Cod_Grupo, Sigla, Cod_Ficha_Descritiva, Cod_Pergunta, Descricao, ValorInicial, ValorFinal)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strSigla & "',"
		sql = sql & "" & intCodFichaDescritiva & ","
		sql = sql & "" & intCodPergunta & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strValorInicial & ","
		sql = sql & "" & strValorFinal & ")"

		cnn.execute sql
		GravarLog sql

	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA Set"
		sql = sql & " Sigla = '" & strSigla & "',"
		sql = sql & " Cod_Ficha_Descritiva = " & intCodFichaDescritiva & ","
		sql = sql & " Cod_Pergunta = " & intCodPergunta & ","
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " ValorInicial = " & strValorInicial & ","
		sql = sql & " ValorFinal = " & strValorFinal & ""
		sql = sql & " where Codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
		sql = sql & " where Codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_ficha_descritiva_conceito_pergunta.asp';
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