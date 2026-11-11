<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Equipamento 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strResponsavel 			= Trim(Request.Form("txtResponsavel"))
	strStatus				= Trim(Request.Form("cmbStatus"))
				
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(COD_EQUIPAMENTO) as MaiorCodigo" 
		sql = sql & " FROM SCA_EQUIPAMENTO"
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

		sql = "Insert Into SCA_EQUIPAMENTO(COD_EMPRESA, COD_EQUIPAMENTO, DESC_EQUIPAMENTO, RESPONSAVEL, SITUACAO)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strResponsavel & "',"
		sql = sql & "'" & strStatus & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_EQUIPAMENTO Set"
		sql = sql & " DESC_EQUIPAMENTO = '" & strDescricao & "',"
		sql = sql & " RESPONSAVEL = '" & strResponsavel & "',"
		sql = sql & " SITUACAO = '" & strStatus & "'"
		sql = sql & " where COD_EQUIPAMENTO = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_EQUIPAMENTO "
		sql = sql & " where COD_EQUIPAMENTO = " & intCodigo
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Equipamento_cad.asp';
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