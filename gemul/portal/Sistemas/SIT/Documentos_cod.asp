<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Documentos
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="PatUpload.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	dim oUpload, i
	dim caminho
	set oUpload  	= new PatUpload
	Set objFSO 		= CreateObject("Scripting.FileSystemObject")
	
	'Cria a pasta de acordo com codigo do Imovel
	PastaFotos = Server.MapPath("../../../Documentos") & "\" & session("codEmpresa")
		
	IF Not objFSO.FolderExists(PastaFotos) THEN
		objFSO.CreateFolder(PastaFotos)
	END IF
	
	oUpload.SetData Request, PastaFotos, 1	
	
	'on error resume next
	'----------Inicia uma tranzação--------------
	
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= trim(session("codEmpresa"))
	intCodigo 			= Trim(oUpload.Form("txtCodigo"))
	strData 			= formataDataBD(Trim(oUpload.Form("txtData")))
	intCodTipoDocumento	= Trim(oUpload.Form("cmbTipoDocumento"))
	strDescricao 		= Trim(oUpload.Form("txtDescricao"))
	strDocumento		= oUpload.file("Arq1")
	strPublicado 		= Trim(oUpload.Form("cmbPublicado"))
			
	' Dados do Usuario
	strUsuario_incl    	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	=formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Documento salvo com sucesso..."
		
		sql = "Insert Into SIT_Documentos(CodEmpresa, CodTipoDocumento, Descricao, Data, Documento, Publicado, "
		sql = sql & " UsuarioIncl, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intCodTipoDocumento & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strDocumento & "',"
		sql = sql & "'" & strPublicado & "',"
	
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Documentos_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>