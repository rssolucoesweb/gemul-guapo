<!--#include file="../../includes/inc_cnn.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmpresa			= Trim(Request("CodEmpresa"))
	intCodGrupo				= Trim(Request("CodGrupo"))
	strNomeArquivo 			= Trim(request.QueryString("NomeArquivo"))
	
	strMensagem = "Foto Excluida com sucesso..."
	
	'Exclui Foto
	PastaFotos = Server.MapPath("../../LogoMarcas") & "/" & intCodEmpresa & "\" & strNomeArquivo
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	' Apaga o Arquivo do servidor
	IF objFSO.FileExists(PastaFotos) = True THEN objFSO.DeleteFile PastaFotos, True

	sql = " Update SEG_EMPRESA set "
	sql = sql & " LOGOMARCA = Null"
	sql = sql & " Where CODIGO = " & intCodEmpresa
	sql = sql & " And COD_GRUPO = " & intCodGrupo
	cnn.execute sql
	
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