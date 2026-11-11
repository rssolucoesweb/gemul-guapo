<!--#include file="../../includes/inc_cnn.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodNoticia		= Trim(Request("CodNoticia"))
	strNomeArquivo 		= Trim(request.QueryString("NomeArquivo"))
	
	strMensagem = "Foto Excluida com sucesso..."
	
	'Exclui Foto
	PastaFotos = Server.MapPath("../../FotoNoticia") & "/" & intCodNoticia & "\" & strNomeArquivo
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	' Apaga o Arquivo do servidor
	IF objFSO.FileExists(PastaFotos) = True THEN objFSO.DeleteFile PastaFotos, True
	
	sql = " Delete from SIT_NoticiaFoto"      
	sql = sql & " Where CodNoticia = " & intCodNoticia
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			 alert("<%=strMensagem%>");
			window.opener.frm.submit();
			window.close();			 
		</script>
		<%
		response.end
	else
		response.Write(err.description)
		cnn.rollbacktrans
	end if
%>