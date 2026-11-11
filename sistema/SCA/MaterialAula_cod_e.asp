<!--#include file="../../includes/inc_cnn.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodigo 			= Trim(request.QueryString("txtCodigo"))
	strNomeArquivo		= Trim(request.QueryString("txtNomeArquivo"))

	strMensagem = "Imagem Excluida com sucesso..."
	
	'Exclui PDF
	PastaImagemComum = Server.MapPath("../../MaterialAluno") & "/" & Session("CodEmpresa") & "\" & strNomeArquivo
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	' Apaga o Arquivo do servidor
	IF objFSO.FileExists(PastaImagemComum) = True THEN objFSO.DeleteFile PastaImagemComum, True
	
	sql = "Delete from SCA_MaterialAluno "
	sql = sql & " Where Codigo = " & intCodigo
	sql = sql & " And Cod_empresa = " & Session("CodEmpresa")	
	cnn.execute sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='MaterialAula_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>