	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 09/02/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Area do Conhecimento
	-->
    
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	
	<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intQtdeDiasAluno 		= Trim(Request.Form("txtQtdeDiasAluno"))
	intQtdeDiasColaborador	= Trim(Request.Form("txtQtdeDiasColaborador"))
	intQtdeDiasComunidade	= Trim(Request.Form("txtQtdeDiasComunidade"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Cod_TipoPublicacao) as MaiorCodigo" 
		sql = sql & " FROM SCB_TIPOPUBLICACAO"
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
		
		sql = "Insert Into SCB_TIPOPUBLICACAO(Cod_Empresa, Cod_TipoPublicacao, Nome_TipoPublicacao,"
		sql = sql & " QtdeDiasAluno, QtdeDiasColaborador, QtdeDiasComunidade)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intQtdeDiasAluno & ","
		sql = sql & "" & intQtdeDiasColaborador & ","
		sql = sql & "" & intQtdeDiasComunidade & ")"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCB_TIPOPUBLICACAO Set"
		sql = sql & " Nome_TipoPublicacao = '" & strDescricao & "',"
		sql = sql & " QtdeDiasAluno = " & intQtdeDiasAluno & ","
		sql = sql & " QtdeDiasColaborador = " & intQtdeDiasColaborador & ","
		sql = sql & " QtdeDiasComunidade = " & intQtdeDiasComunidade & ""
		sql = sql & " where Cod_TipoPublicacao = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCB_TIPOPUBLICACAO "
		sql = sql & " where Cod_TipoPublicacao = " & intCodigo
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TipoPublicacao_cad.asp';
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