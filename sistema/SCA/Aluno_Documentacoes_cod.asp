<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Aluno documentações
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula		= Trim(Request("txtMatricula"))	

	if acao="I" then
		
		' Excluir todos registro do aluno
		sql = " Delete from SCA_ALUNO_DOCUMENTACOES"
		sql = sql & " Where cod_aluno = " & strCodAluno
		cnn.execute sql

		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Cod_Empresa, Codigo, Descricao"
		sql = sql & " FROM SCA_DOCUMENTACOES"
		sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")			
		sql = sql & " Order by Codigo"
		rs.open sql, cnn,3,3		
		while not rs.eof
			strDataProrrogacao 	= formatadataBD(request.Form("txtDataProrrogacao" & rs("codigo")))
			strChekDocumento	= request.Form("chkDocumentacoes" & rs("codigo"))
			strCodDocumento		= request.Form("txtCodDocumento" & rs("codigo"))
			if strChekDocumento = "S" then
				strSituacao = "R"
			else
				strSituacao = "I"
			end if
			sql = "Insert Into SCA_ALUNO_DOCUMENTACOES (cod_aluno, cod_documentacoes, data_prorrogacao, situacao)"
			sql = sql & " Values ("
			sql = sql & "" & strCodAluno & ","
			sql = sql & "" & strCodDocumento & ","
			if trim(strDataProrrogacao) = "" then
				sql = sql & "null,"			
			else
				sql = sql & "'" & strDataProrrogacao & " " & time & "',"			
			end if
			sql = sql & "'" & strSituacao & "')"
			
			cnn.execute sql
			GravarLog sql

			rs.movenext
		wend
		rs.close
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
	else
		
		strMensagem = "Registro Excluido com sucesso"
		
		For intContador = 0 to ubound(vetCodigoItem)	 
		
			sql = " Delete from SCA_ALUNO_DOCUMENTACOES"
			sql = sql & " Where cod_aluno = " & strCodAluno
			sql = sql & " and cod_documentacoes = " & vetCodCodumentacoes(intContador)
			cnn.execute sql
			GravarLog sql

		next	 	
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Aluno_Documentacoes_cad.asp?txtMatricula=<%=strMatricula%>';
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