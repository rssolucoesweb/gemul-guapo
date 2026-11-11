<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	intCodCurso			= Trim(Request("cmbCurso"))
	strDescricao 		= ReplaceRequest(Trim(Request.Form("txtDescricao")))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SCA_DOCUMENTACOES_ESTAGIO"
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

		sql = "Insert Into SCA_DOCUMENTACOES_ESTAGIO(COD_EMPRESA, COD_CURSO, CODIGO, DESCRICAO)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_DOCUMENTACOES_ESTAGIO Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "'"
		sql = sql & " where CODIGO = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_DOCUMENTACOES_ESTAGIO "
		sql = sql & " where CODIGO = " & intCodigo
		
	end if
	
	cnn.execute sql
	
	GravarLog sql

if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DocumentacoesEstagio_cad.asp';
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