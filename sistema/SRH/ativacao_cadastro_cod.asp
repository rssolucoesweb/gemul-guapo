<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 15/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Cargo
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodigo	 				= Trim(Request("txtCodigo"))
	intCodFuncionario 			= Trim(Request.Form("txtCodFuncionario"))
	intCodLotacao 				= Trim(Request.Form("cod_lotacao"))
	observacao	 				= Trim(Request.Form("txtObs"))
	carga_horaria 				= Trim(Request.Form("carga_horaria"))
	strAno 						= Trim(Request.Form("txtAno"))

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_ATIVACAO_CADASTRO(ano_letivo,cod_grupo,cod_empresa,cod_colaborador,observacao,usuario_incl,data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & strAno & ","
		sql = sql & "" & session("codgrupo") & ","
		sql = sql & "" & intCodLotacao & ","
		sql = sql & "" & intCodFuncionario & ","
		sql = sql & "'" & observacao & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',getdate())"
		cnn.execute sql
		GravarLog sql
			
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_ATIVACAO_CADASTRO "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ativacao_cadastro_cad.asp';
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