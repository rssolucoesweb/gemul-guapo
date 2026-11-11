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
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmp		= Session("CodEmpresa")
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	intCodAtosLegais		= Trim(Request.Form("cmbAtosLegais"))
	
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDataRenovacao 		= formataDataBD(Trim(Request.Form("txtDataRenovacao")))
	strDataVencimento 		= formataDataBD(Trim(Request.Form("txtDataVencimento")))
	strDataInicioVingencia 	= formataDataBD(Trim(Request.Form("txtDataInicioVingencia")))

	usuario_incl	= session("usuarioWeb")
 	
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_ATOS_LEGALIZACAO_renovacao(cod_atos_legalizacao,descricao,data_renovacao,data_vencimento,data_inicio_vingencia,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & intCodAtosLegais & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDataRenovacao & "',"
		sql = sql & "'" & strDataVencimento & "',"
		sql = sql & "'" & strDataInicioVingencia & "',"
		sql = sql & "'" & usuario_incl & "',"
		sql = sql & "getdate(),"
		sql = sql & "'" & usuario_incl & "',"
		sql = sql & "getdate())"
		cnn.execute sql
		
	elseif acao="A" then
		
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_ATOS_LEGALIZACAO_renovacao Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " data_renovacao = '" & strDataRenovacao & "',"
		sql = sql & " data_vencimento = '" & strDataVencimento & "',"
		sql = sql & " data_inicio_vingencia = '" & strDataInicioVingencia & "',"
		sql = sql & " usuario_altr = '" & usuario_incl & "',"
		sql = sql & " data_hora_altr = getdate() "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_ATOS_LEGALIZACAO_renovacao "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		
	end if
	
	
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_atos_legais_renovacao.asp?cmbAtosLegais=<%=intCodAtosLegais%>';
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