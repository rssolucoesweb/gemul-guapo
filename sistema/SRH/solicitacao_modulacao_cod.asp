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
	intCodLotacao 				= Trim(Request.Form("cmbLotacao"))
	intCodFuncao 				= Trim(Request.Form("cmbFuncao"))
	intCodCargo 				= Trim(Request.Form("cod_cargo"))
	intCodFormaNomeacao 		= Trim(Request.Form("cod_FormaNomeacao"))
	intCodTurno 				= Trim(Request.Form("cmbTurnoRH"))
	observacao	 				= Trim(Request.Form("txtObs"))
	carga_horaria 				= Trim(Request.Form("carga_horaria"))
	strAno 						= Trim(Request.Form("txtAno"))

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_SOLICITACAO_MODULACAO(ano_letivo, cod_empresa, cod_colaborador,cod_lotacao,cod_funcao,cod_cargo,cod_FormaNomeacao,cod_turno,carga_horaria,observacao,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & strAno & ","
		sql = sql & "" & session("codEmpresa") & ","
		if intCodFuncionario = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodFuncionario & ","
		end if
		sql = sql & "" & intCodLotacao & ","
		sql = sql & "" & intCodFuncao & ","
		if intCodCargo = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodCargo & ","
		end if
		if intCodFormaNomeacao = "" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodFormaNomeacao & ","
		end if
		sql = sql & "" & intCodTurno & ","
		sql = sql & "'" & carga_horaria & "',"
		sql = sql & "'" & observacao & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',getdate(),'" & Session("UsuarioWeb") & "',getdate())"
		cnn.execute sql
		GravarLog sql
			
	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_SOLICITACAO_MODULACAO Set"
		sql = sql & " cod_lotacao = " & intCodLotacao & ","
		sql = sql & " cod_funcao=" & intCodFuncao & ","
		sql = sql & " cod_turno=" & intCodTurno & ","
		sql = sql & " carga_horaria='" & carga_horaria & "',"
		sql = sql & " observacao='" & observacao & "',"
		sql = sql & " usuario_altr='" & Session("UsuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
	elseif acao="F" then

		strMensagem = "Registro enviado com sucesso..."

		sql = "Update SRH_SOLICITACAO_MODULACAO Set"
		sql = sql & " situacao='F',"
		sql = sql & " usuario_altr='" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate()"
		sql = sql & " where ano_letivo = " & strAno
		sql = sql & " and cod_empresa = " & session("codEmpresa")
		sql = sql & " and situacao = 'A'"
		cnn.execute sql
		GravarLog sql
		
	elseif acao="D" then

		strMensagem = "Registro devolvido com sucesso..."

		sql = "Update SRH_SOLICITACAO_MODULACAO Set"
		sql = sql & " situacao='A',"
		sql = sql & " usuario_altr='" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate()"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_SOLICITACAO_MODULACAO "
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
			window.location='solicitacao_modulacao_cad.asp';
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