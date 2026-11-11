<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	codEmpresa				= Trim(Request.Form("cmbEmpresaGrupo"))
	ip						= Trim(Request.Form("txtIP"))

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		sql = "Insert Into APO_FAIXA_IP ( cod_empresa, numero_ip, data_incl, usuario_incl ) "
		sql = sql & " Values ("
		sql = sql & "" & codEmpresa & ","
		sql = sql & "'" & ip & "',"
		sql = sql & "getdate(),"
		sql = sql & "'" & trim(session("usuarioWeb")) & "')"
		cnn.execute sql	
		GravarLog sql
			
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update APO_FAIXA_IP Set"
		sql = sql & " numero_ip = '" & ip & "',"
		sql = sql & " data_altr = getdate(),"
		sql = sql & " usuario_altr = '" & trim(session("usuarioWeb")) & "'"		
		sql = sql & " Where id = " & intCodigo
		cnn.execute sql	
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		' Deleta a Tabela de Colaborador Folha
		sql = "Delete from APO_FAIXA_IP "
		sql = sql & " Where id = " & intCodigo
		cnn.execute sql

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='IP_cad.asp';
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