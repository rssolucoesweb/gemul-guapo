<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 01/06/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Situação Promoção do Aluno - grava
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strCriterio			= Trim(Request.Form("cmbCriterio"))
	
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "SELECT Max(codigo) as MaiorCodigo" 
		sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
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

		sql = "Insert Into SCA_SITUACAO_PROMOCAO(Cod_Empresa, codigo, descricao, Desc_Abreviada, Criterio)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDescAbreviada & "',"
		sql = sql & "'" & strCriterio & "')"
		cnn.execute sql
		GravarLog sql


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_SITUACAO_PROMOCAO Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " criterio = '" & strCriterio & "',"
		sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "'"
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_SITUACAO_PROMOCAO "
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and Cod_Empresa = " & intCodEmp
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='SituacaoPromocao_cad.asp';
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