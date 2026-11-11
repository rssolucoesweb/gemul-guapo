<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Eventos 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	    		= Trim(Request.Form("txtCodigo")) 
	strDescricao			= Trim(Request.Form("txtDescricao"))
	intColuna				= Trim(Request.Form("txtColuna"))
	intTamanhoHorizontal	= Trim(Request.Form("txtTamanhoHorizontal"))
	intTamanhoVertical		= Trim(Request.Form("txtTamanhoVertical"))
	intLinha 				= Trim(Request.Form("txtLinha"))
	intEspaco				= Trim(Request.Form("txtEspaco"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_MODELO_ETIQUETA(Cod_Empresa, Descricao, coluna, linha, tamanhoHorizontal, tamanhoVertical, espaco, situacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intColuna & ","
		sql = sql & "" & intLinha & ","
		sql = sql & "" & intTamanhoHorizontal & ","
		sql = sql & "" & intTamanhoVertical & ","
		sql = sql & "" & intEspaco & ","
		sql = sql & "'" & strSituacao & "')"
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_MODELO_ETIQUETA Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " Coluna = " & intColuna & ","
		sql = sql & " Linha = " & intLinha & ","
		sql = sql & " TamanhoHorizontal = " & intTamanhoHorizontal & ","
		sql = sql & " TamanhoVertical = " & intTamanhoVertical & ","
		sql = sql & " Espaco = " & intEspaco & ","
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_MODELO_ETIQUETA "
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
	
	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ModeloEtiquetas_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>