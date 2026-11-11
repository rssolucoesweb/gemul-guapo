<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br" 
	::	Data de Criação...: 12/04/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Documentos Internos 
-->

<!--#include file="PatUpload.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	dim oUpload, i
	dim caminho
	set oUpload  		= new PatUpload
	
	'Cria a pasta de acordo com codigo da Empresa
	PastaArquivo = Server.MapPath("../../DocumentosInternos") & "/" & Session("CodEmpresa")
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
		
	IF Not objFSO.FolderExists(PastaArquivo) THEN
		objFSO.CreateFolder(PastaArquivo)
	END IF
	
	oUpload.SetData Request, PastaArquivo, 1	
	
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 							= Trim(Request.QueryString("acao"))
	intCodEmp						= Session("CodEmpresa")
	
	intCodEmpMarcada 				= Trim(oUpload.Form("chkEmp"))
	strData 						= formataDataBD(Trim(oUpload.Form("txtData")))
	strDescricao 					= Trim(oUpload.Form("txtDescricao"))
	strNomeArquivo					= oUpload.file("Arq1")
			
	if acao="I" then
		
		strMensagem = "Documento enviado com sucesso"	
		
		sql = "SET NoCount ON"
		sql = sql & " Insert Into SCA_DocumentosInternos (Cod_empresa, Data, Descricao, NomeArquivo)"          
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strNomeArquivo & "')"
		
		Set rs = cnn.Execute(sql)
		intCodDocumentosInterno = rs(0)
		GravarLog sql
		rs.close
			
		for i = 0 to ubound(vetEmp)
			
			intCont = intCont + 1	
			intCodEmpresa 		= TRIM(vetEmp(i))
							
			sql = " Insert into SCA_DocumentosInternos_Empresa (CodDocumentosInternos, Cod_Empresa)"
			sql = sql & " VALUES ("
			sql = sql & "" & intCodDocumentosInterno & ","
			sql = sql & "" & intCodEmpresa & ")"
			cnn.execute sql

			GravarLog sql
			intCont = intCont + 1
			
		next
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DocumentosInternos_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>