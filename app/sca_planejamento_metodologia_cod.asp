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
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSituacao				= Trim(Request.Form("cmbSituacaoAcademica"))
	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT descricao" 
		sql = sql & " FROM SCA_PLANEJAMENTO_METODOLOGIA"
		sql = sql & " where descricao = '" & strDescricao & "'"
		sql = sql & " AND COD_EMPRESA = " & intCodEmp
		rs.open sql, cnn
		if not RS.EOF then
			rs.close
			%>
			<script>
				alert("Existe um registro com a mesma descrição informada.");
				window.history.back();
			</script>
			<%
			response.end
		else
			rs.close
		end if
		
		sql = "Insert Into SCA_PLANEJAMENTO_METODOLOGIA(COD_EMPRESA, ano_letivo, descricao, situacao, usuario_incl, data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strAnoLetivo &"',"
		sql = sql & "'" & strDescricao &"',"
		sql = sql & "'" & strSituacao &"',"
		sql = sql & "'" & session("usuarioWeb") &"',getdate())"
		cnn.execute sql
		GravarLog sql			

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_PLANEJAMENTO_METODOLOGIA Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " situacao = '" & strSituacao & "'"
		sql = sql & " where Cod_PLANEJAMENTO_METODOLOGIA = " & intCodigo
		sql = sql & " AND COD_EMPRESA = " & intCodEmp
		cnn.execute sql
		GravarLog sql
		
	else
		
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_PLANEJAMENTO_METODOLOGIA "
		sql = sql & " where Cod_PLANEJAMENTO_METODOLOGIA = " & intCodigo
		sql = sql & " AND COD_EMPRESA = " & intCodEmp

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_planejamento_metodologia.asp';
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