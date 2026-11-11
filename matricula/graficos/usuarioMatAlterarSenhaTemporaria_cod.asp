<!--#include file="../includes/inc_cnn.asp"-->

<%
	strAcao						= Trim(Request.QueryString("acao"))
	strUsuarioCallcenter		= Trim(Request.Form("txtLogin"))
	strSenhaCallcenter			= Trim(Request.Form("txtSenha"))
	
	sql = "update MAT_usuario_matricula set senha_temporaria = 'N', senha = '" & strSenhaCallcenter & "'"
	sql = sql & "where usuario = '" & strUsuarioCallcenter & "'"
	cnn.execute sql	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		strMensagem = "Senha alterada com sucesso!!!"
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='index.html';
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if	
%>