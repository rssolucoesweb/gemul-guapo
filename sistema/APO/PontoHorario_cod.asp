<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Convênios - Modulação Folha de Pagamento
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodGrupo			= Session("CodGrupo")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strTipo	 			= Trim(Request.Form("cmbTipo"))
	intHora	 			= Trim(Request.Form("cmbHora"))
	intMinuto 			= Trim(Request.Form("cmbMinuto"))
	intSegundo			= 0
    intCodTurno			= Trim(Request.Form("cmbTurno"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into APO_PONTOHORARIO(Cod_Grupo, Tipo, Hora, Minuto, Segundo, Cod_turno, Situacao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strTipo & "',"
		sql = sql & "" & intHora & ","
		sql = sql & "" & intMinuto & ","
		sql = sql & "" & intSegundo & ","
		sql = sql & "" & intCodTurno & ","
		sql = sql & "'" & strSituacao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update APO_PONTOHORARIO Set"
		sql = sql & " Tipo = '" & strTipo & "',"
		sql = sql & " Hora = " & intHora & ","
		sql = sql & " Minuto = " & intMinuto & ","
		sql = sql & " Segundo = " & intSegundo & ","
		sql = sql & " Cod_turno = " & intCodTurno & ","
		sql = sql & " Situacao = '" & strSituacao & "'"
		sql = sql & " Where Codigo = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from APO_PONTOHORARIO "
		sql = sql & " Where Codigo = " & intCodigo

	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PontoHorario_cad.asp';
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