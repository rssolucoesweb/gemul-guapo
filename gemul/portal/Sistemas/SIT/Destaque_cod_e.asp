<!--#include file="../../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodigo 		= Trim(request.QueryString("id"))
	strFoto			= intCodigo & "_g.jpg"

	strMensagem = "Documento Excluido com sucesso..."
	
	'Exclui PDF
	PastaPDF = Server.MapPath("../../../Destaque") & "\" & session("codEmpresa") & "\" & intCodigo & "\" & strFoto
	

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	' Apaga o Arquivo do servidor
	IF objFSO.FileExists(PastaPDF) = True THEN objFSO.DeleteFile PastaPDF, True
	
	sql = "Delete From SIT_Destaque "
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
			window.location='Destaque_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>