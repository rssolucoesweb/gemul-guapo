<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 29/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Documentações
--
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	 'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCodFunc			= Trim(Request("txtCodFuncionario"))

	if acao="I" then
		
		' Excluir todos registro do aluno
		sql = " Delete from SRH_COLABORADOR_DOCUMENTACOES"
		sql = sql & " Where cod_colaborador = " & strCodFunc
		cnn.execute sql

		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Cod_Empresa, Codigo, Descricao"
		sql = sql & " FROM SRH_DOCUMENTACOES"
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
			sql = "Insert Into SRH_COLABORADOR_DOCUMENTACOES (cod_colaborador, cod_documentacoes, data_prorrogacao, situacao)"
			sql = sql & " Values ("
			sql = sql & "" & strCodFunc & ","
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
		
			sql = " Delete from SRH_COLABORADOR_DOCUMENTACOES"
			sql = sql & " Where cod_colaborador = " & strCodFunc
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
			window.location='Funcionario_Documentacoes_cad.asp?txtCodFuncionario=<%=strCodFunc%>';
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