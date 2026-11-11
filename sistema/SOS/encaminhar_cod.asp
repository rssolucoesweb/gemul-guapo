	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<%

	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	intCodigo	 					= Trim(Request.Form("txtCodChamado"))
	intCodEmpresa					= session("codEmpresa")
	
	intCodExecutor				= Trim(Request.Form("cmbExecutor"))
	
	strParecer						= Trim(Request.Form("txtParecer"))
	intCodTipoAndamento				= Trim(Request.Form("cmbTipoAndamento"))

	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	strMensagem = "Registro alterado com sucesso!"
	
	sql = "Update SOS_REQUISICAO Set "
	sql = sql & " Cod_funcionario_externo = '" & intCodExecutor & "',"
	sql = sql & " cod_tipo_andamento = '" & intCodTipoAndamento & "',"
	sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
	sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"

	sql = sql & " Where Codigo = " & intCodigo
	cnn.execute sql
	GravarLog sql
	
	sql = "insert into SOS_REQUISICAO_ANDAMENTO (cod_requisicao, cod_tipo_andamento, Cod_funcionario_externo, parecer, usuario_incl, data_hora_incl) values ("
	sql = sql & "'" & intCodigo & "',"
	sql = sql & "'" & intCodTipoAndamento & "',"
	sql = sql & "'" & intCodExecutor & "',"
	sql = sql & "'" & strParecer & "',"
	sql = sql & "'" & strUsuario_incl & "',"
	sql = sql & "'" & strData_hora_altr & "')"
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="encaminhar_cad.asp?id=<%=intCodigo%>";
			//window.close();	
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