<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/04/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Altera Modelo de Carteirinhas 
	
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 			= Trim(Request.QueryString("acao"))
	intCodigo		= Trim(Request.QueryString("Codigo"))
	intCodEmp  		= Session("CodEmpresa")
			
	if acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_ModeloCarteirinhas Set"
		sql = sql & " Destaque = 'N'"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		cnn.execute sql
		
		sql = "Update SCA_ModeloCarteirinhas Set"
		sql = sql & " Destaque = 'S'"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmp
		cnn.execute sql

	else
		
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_ModeloCarteirinhas "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp
		cnn.execute sql
		
		'Exclui foto da pasta
		PastaFotos = Server.MapPath("../../ModeloCarteirinhas") & "\" & intCodEmp
		Set objFSO = CreateObject("Scripting.FileSystemObject")
		
		IF objFSO.FileExists(PastaFotos & "\" & intCodigo & "_.jpg") = True THEN objFSO.DeleteFile PastaFotos & "\" & intCodigo & "_.jpg", True
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ModeloCarteirinhas_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>