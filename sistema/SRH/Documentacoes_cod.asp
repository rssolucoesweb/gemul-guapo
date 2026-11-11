<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Documentações
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
	intCodGrupo			= Session("CodGrupo")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= ReplaceRequest(Trim(Request.Form("txtDescricao")))
	intCodGrauInstrucao	= Trim(Request.Form("cmbGrauInstrucao"))

	if intCodGrauInstrucao = "" then intCodGrauInstrucao = "0"
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SRH_DOCUMENTACOES"
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

		sql = "Insert Into SRH_DOCUMENTACOES(COD_EMPRESA, CODIGO, COD_GRUPO, DESCRICAO, cod_grauinstrucao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
	    sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodGrauInstrucao & ")"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_DOCUMENTACOES Set " 
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " cod_grauinstrucao = " & intCodGrauInstrucao & ""
		sql = sql & " where CODIGO = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SRH_DOCUMENTACOES "
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
			window.location='Documentacoes_cad.asp';
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