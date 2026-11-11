<!--#include file="../../includes/inc_cnn.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodColaborador		= Trim(Request("CodColaborador"))
	strNomeArquivo 			= Trim(request.QueryString("NomeArquivo"))
	
	strMensagem = "Foto Excluida com sucesso..."
	
	'Exclui Foto
	PastaFotos = Server.MapPath("../../FotoColaborador") & "/" & Session("CodEmpresa") & "\" & strNomeArquivo
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	' Apaga o Arquivo do servidor
	IF objFSO.FileExists(PastaFotos) = True THEN objFSO.DeleteFile PastaFotos, True
	
	sql = " Delete from SRH_COLABORADOR_FOTO"      
	sql = sql & " where codColaborador = " & intCodColaborador
	sql = sql & " and   cod_empresa=" & Session("CodEmpresa")
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