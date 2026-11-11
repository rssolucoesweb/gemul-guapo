<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 23/09/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Turno 
-->

<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodTurno	 		= Trim(Request.Form("txtCodigo"))
	intCodGrupo			= Session("CodGrupo")		
	strDescricao 		= Trim(Request.Form("txtDescricao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_TURNO(Cod_Grupo, DESC_TURNO)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strDescricao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SRH_TURNO Set"
		sql = sql & " DESC_TURNO = '" & strDescricao & "'"
		sql = sql & " where COD_TURNO = " & intCodTurno
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_TURNO "
		sql = sql & " where COD_TURNO = " & intCodTurno
		
	end if
	cnn.execute sql
	GravarLog sql
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TurnoColaborador_cad.asp';
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