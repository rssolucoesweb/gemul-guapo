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
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmp		= Session("CodEmpresa")
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strSigla		= Trim(Request.Form("txtSigla"))
	
	intCodCriterio		= Trim(Request("cmbCriterio"))
	intCodTipoCalculo		= Trim(Request("cmbTipoCalculo"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strPosicao	 	= Trim(Request.Form("cmbPosicao"))
	strSigla		= Trim(Request.Form("txtSigla"))
	intCodTipoLancamento		= Trim(Request.Form("cmbTipoLancamento"))
	
	strFormula		= Trim(Request.Form("txtFormula"))
	strDigitar		= Trim(Request.Form("txtDigitar"))
	usuario_incl	= session("usuarioWeb")
 	
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_CALCULO(cod_tipo_calculo, descricao, sigla, cod_tipo_lancamento, posicao, formula, digitar, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & intCodTipoCalculo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSigla & "',"
		sql = sql & "" & intCodTipoLancamento & ","
		sql = sql & "" & strPosicao & ","
		sql = sql & "'" & strFormula & "',"
		sql = sql & "'" & strDigitar & "',"
		sql = sql & "'" & usuario_incl & "',"
		sql = sql & "getdate(),"
		sql = sql & "'" & usuario_incl & "',"
		sql = sql & "getdate())"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_CALCULO Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " sigla = '" & strSigla & "',"
		sql = sql & " posicao = " & strPosicao & ","
		sql = sql & " digitar = '" & strDigitar & "',"
		sql = sql & " formula = '" & strFormula & "',"
		sql = sql & " cod_tipo_lancamento = " & intCodTipoLancamento & ","
		sql = sql & " usuario_altr = '" & usuario_incl & "',"
		sql = sql & " data_hora_altr = getdate() "
		sql = sql & " where codigo = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_CALCULO "
		sql = sql & " where codigo = " & intCodigo
		
	end if
	cnn.execute sql
	
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_calculo.asp?cmbTipoCalculo=<%=intCodTipoCalculo%>&cmbCriterio=<%=intCodCriterio%>';
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