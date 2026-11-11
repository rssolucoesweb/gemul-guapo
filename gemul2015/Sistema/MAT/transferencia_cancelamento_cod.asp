<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Objetivo Pagina...: Cadastro de Motivo 
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
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	intCodTransferencia	= Trim(Request.Form("cod_transferencia"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
			
	if acao="I" then
	
		strMensagem = "Cancelamento executado com sucesso..."

		sql = "Insert Into mat_transferencia_cancelamento(cod_empresa, cod_transferencia, descricao, usuario_incl, data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodTransferencia & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',getdate())"
		cnn.execute sql
		GravarLog sql
		
		sql = "update mat_transferencia set situacao = 'C',"
		sql = sql & " usuario_situacao = '" & Session("UsuarioWeb") & "',"
		sql = sql & " data_situacao = getdate()"
		sql = sql & " where codigo = " & intCodTransferencia
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='transferencia_gerenciamento_con.asp';
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