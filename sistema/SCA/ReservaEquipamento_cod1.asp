<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strSala		 			= Trim(Request.Form("txtSala"))
	strDataReserva 			= formatadataBD(Trim(Request.Form("txtDataReserva")))
	intCodHorarioAula 		= Trim(Request.Form("txtCodHorarioAula"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodHorario			= Trim(Request.Form("cmbHorario"))
	intCodEquipamento		= Trim(Request.Form("cmbEquipamento"))
	strDataSolicitacao		= formatadataBD(date)
	
			
	if acao="I" then
		strMensagem = "Registro Salvo com sucesso..."
		sql = "Insert Into SCA_EQUIPAMENTO_RESERVA(COD_EMPRESA, cod_equipamento, cod_colaborador, num_sala, data_solicitacao, data_utilizacao, cod_horario_aula, cod_horario)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodEquipamento & ","
		sql = sql & "" & intCodProfessor & ","
		sql = sql & "'" & strSala & "',"
		sql = sql & "'" & strDataSolicitacao & "',"
		sql = sql & "'" & strDataReserva & "',"
		sql = sql & "" & intCodHorarioAula & ","
		sql = sql & "" & intCodHorario & ")"

	elseif acao="A" then
		
	elseif acao="E" then
		
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_EQUIPAMENTO_RESERVA "
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and	COD_EMPRESA	= " & intCodEmp
		
	end if
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('ReservaEquipamento_cad.asp');
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