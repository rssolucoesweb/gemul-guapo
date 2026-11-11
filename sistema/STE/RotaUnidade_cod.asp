	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodRota			 	= Trim(Request.Form("txtCodRota"))
	intCodEmpresa 			= Trim(Request.Form("cmdEmpresaUsuario"))
	strHoraSaida			= Trim(Request.form("txtHoraSaida"))
	strHoraChegada 			= Trim(Request.Form("txtHoraChegada"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "Insert Into SCA_ROTA_VICULA_EMPRESA(CodRota, CodEmpresa, HoraSaida, HoraChegada)"
		sql = sql & " Values ("
		sql = sql & "" & intCodRota & ","
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strHoraSaida & "',"
		sql = sql & "'" & strHoraChegada & "')"

		cnn.execute sql
		GravarLog sql

	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_ROTA_VICULA_EMPRESA Set"
		sql = sql & " HoraSaida = '" & strHoraSaida & "',"
		sql = sql & " HoraChegada = '" & strHoraChegada & "'"
		sql = sql & " where CodRota = " & intCodRota
		sql = sql & " And CodEmpresa = " & intCodEmpresa


		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_ROTA_VICULA_EMPRESA "
		sql = sql & " where CodRota = " & intCodRota
		sql = sql & " And CodEmpresa = " & intCodEmpresa

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='RotaUnidade_cad.asp?CodRota=<%=intCodRota%>';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>