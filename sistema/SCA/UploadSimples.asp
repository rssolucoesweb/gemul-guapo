<!--#include file="PatUpload.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<HTML>
<HEAD>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
<%
	On error resume next
	
	dim oUpload, i
	dim caminho
	set oUpload  		= new PatUpload
	intCodAluno			= Trim(Request("codAluno"))
	caminho 			= Server.MapPath("../../fotoAluno/" & Session("CodEmpresa"))
	oUpload.SetData Request, caminho, 1	
	
	intCodAluno		= oUpload.Form("txtCodAluno")
	strArquivo 		= oUpload.file("Arq")
		
	sql = "delete from SCA_ALUNO_FOTO"      
	sql = sql & " where codAluno=" & intCodAluno
	sql = sql & " and   cod_empresa=" & Session("CodEmpresa")
	cnn.execute sql

	sql = "Insert Into SCA_ALUNO_FOTO (cod_empresa, codAluno, caminho, arquivo)"          
	sql = sql & " Values ("
	sql = sql & "" & Session("CodEmpresa") & ","
	sql = sql & "" & intCodAluno & ","
	sql = sql & "'" & caminho & "',"
	sql = sql & "'" & strArquivo & "')"
	cnn.execute sql
		
	if err.number =0 then
		%>
		<script>
			alert("Foto enviada com sucesso.")
			window.opener.frm.submit();
			window.close();		
		</script>
		<%
	else
		%>
		<script>
			alert("ATENÇÃO: Foto não foi enviada, tente novamente ou verifique o tamanho do arquivo, deve ser menor que 100KB.")
			window.close();		
		</script>
		<%
	end if
	%>
</BODY>
</HTML>