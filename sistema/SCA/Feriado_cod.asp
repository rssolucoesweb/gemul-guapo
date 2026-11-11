<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Feriado
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strData				= formatadataBD(Trim(Request.Form("txtData")))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
			
	if acao="I" then
		sql = "SELECT codigo, data, descricao"
		sql = sql & " FROM SCA_Feriado"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and ano_letivo = " & strAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and data = '" & strData & "'"
		rs.open sql, cnn
		if not rs.eof then
			rs.close
			%>
			<script>
				alert("ATENÇÃO: Já existe um feriado cadastrado com essa mesma data/ano/semestre.");
				window.history.back();
			</script>
			<%
			response.end			
		end if 
		rs.close
	
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_FERIADO(COD_EMPRESA, ANO_LETIVO, SEMESTRE, DESCRICAO, DATA)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strData & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_FERIADO Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " DATA = '" & strData & "'"
		sql = sql & " where CODIGO = " & intCodigo
		sql = sql & " and COD_EMPRESA = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_FERIADO "
		sql = sql & " where CODIGO = " & intCodigo
		sql = sql & " and COD_EMPRESA = " & intCodEmp
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Feriado_cad.asp';
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