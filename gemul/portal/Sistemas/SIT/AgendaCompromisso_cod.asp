<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de agendamento
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")
	intCodigo 	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strLocal	 		= Trim(Request.Form("txtLocal"))
	intcodTipoEvento	= Trim(Request.Form("cmbTipoEvento"))
	strData		 		= formatadataBD(Trim(Request.Form("txtData")))
	strHora		 		= Trim(Request.Form("txtHora"))
	strDataFim	 		= formatadataBD(Trim(Request.Form("txtDataFim")))  & " " & time 
	strHoraFim	 		= formatadataBD(Trim(Request.Form("txtHoraFim")))  & " " & time 
	strObs 				= Trim(Request.Form("txtObs"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
	
	' Dados do Usuario
	strUsuario_incl   = session("strNomeUsuario")
	strData_hora_incl = formatadataBD(date) & " " & time 
	strUsuario_altr   =	session("strNomeUsuario")
	strData_hora_altr = formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SIT_AgendaCompromisso(CodEmpresa, Descricao, LocalCompromisso, codTipoEvento, "
		sql = sql & " dataInicio, dataFim, obs, situacao, "
		sql = sql & " Usuario_incl, Data_Incl, Usuario_Alt, Data_Alt) "
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strDescricao & "',"		
		sql = sql & "'" & strLocal & "',"		
		sql = sql & "" & intcodTipoEvento & ","		
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strDataFim & "',"

		if strObs = "" then
			sql = sql & "null,"		
		else
			sql = sql & "'" & strObs & "',"		
		end if
		
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"		
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SIT_AgendaCompromisso Set"
		sql = sql & " Descricao='" & strDescricao & "',"		
		sql = sql & " LocalCompromisso='" & strLocal & "',"		
		sql = sql & " codTipoEvento=" & intcodTipoEvento & ","		
		sql = sql & " dataInicio = '" & strData & "',"
		sql = sql & " dataFim = '" & strDataFim & "',"

		if strObs = "" then
			sql = sql & " obs=null,"		
		else
			sql = sql & " obs='" & strObs & "',"		
		end if
		
		sql = sql & " situacao='" & strSituacao & "',"
		sql = sql & " Usuario_Alt = '" & strUsuario_incl  & "',"
		sql = sql & " Data_Alt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa

	else
		strMensagem = "Registro Excluida com sucesso..."
		
		sql = "Delete from SIT_AgendaCompromisso "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		
	end if
	cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('AgendaCompromisso_cad.asp');
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>