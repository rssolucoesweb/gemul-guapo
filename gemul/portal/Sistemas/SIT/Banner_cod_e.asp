<!--#include file="../../../includes/inc_cnn.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodigo 		= Trim(request.QueryString("txtCodigo"))
	strNomeBanner 	= Trim(request.QueryString("txtNomeBanner"))
	
	strMensagem = "Banner Excluido com sucesso..."
	
	'Exclui PDF
	Banner = Server.MapPath("../../../Banners") & "\" & session("codEmpresa") & "\" & strNomeBanner
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	' Apaga o Arquivo do servidor
	IF objFSO.FileExists(Banner) = True THEN objFSO.DeleteFile Banner, True
	
	sql = " Delete from SIT_Banner "
	sql = sql & " Where Codigo = " & intCodigo
	sql = sql & " And CodEmpresa = " & session("codEmpresa")
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Banner_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>