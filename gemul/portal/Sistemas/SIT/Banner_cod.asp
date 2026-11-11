<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Banners
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
	PastaFotos = Server.MapPath("../../../Banners") & "\" & session("codEmpresa")
		
	IF Not objFSO.FolderExists(PastaFotos) THEN
		objFSO.CreateFolder(PastaFotos)
	END IF
	
	oUpload.SetData Request, PastaFotos, 1	

	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")
	intCodigo 			= Trim(oUpload.Form("txtCodigo"))
	strAnuncio	 		= replace(Trim(oUpload.Form("txtAnuncio")),"'","")
	strBannerPosicao	= Trim(oUpload.Form("cboBanner"))
	strTipoBanner 		= Trim(oUpload.Form("cmbTipoBanner"))
	strDiasAnuncio 		= Trim(oUpload.Form("txtDiasAnuncio"))
	strDataInicio 		= formataDataBD(Trim(oUpload.Form("txtDataInicio")))
	strDataFinal 		= formataDataBD(Trim(oUpload.Form("txtDataFinal")))
	strSite		 		= Trim(oUpload.Form("txtSite"))
	strTamanho			= Trim(oUpload.Form("txtTamanho"))
	strAltura			= Trim(oUpload.Form("txtAltura"))
	strStatus	 		= "A"
	strBanner 			= oUpload.file("Arq1")
			
	' Dados do Usuario
	strUsuario_incl    	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	=formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Banner Salvo com sucesso..."
		
		sql = "Insert Into SIT_Banner(CodEmpresa, Anuncio, TipoBanner, BannerPossicao, DataInicio, DiasAnuncio, "
		sql = sql & " DataFinal, Site, Banner, status, Tamanho, Altura, "
		sql = sql & " UsuarioIncl, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strAnuncio & "',"
		sql = sql & "'" & strTipoBanner & "',"
		sql = sql & "" & strBannerPosicao & ","
		sql = sql & "'" & strDataInicio & "',"
		sql = sql & "" & strDiasAnuncio & ","
		sql = sql & "'" & strDataFinal & "',"
		
		if strSite <> "" then
			sql = sql & "'" & strSite & "',"
		else
			sql = sql & " null, "
		end if
		
		sql = sql & "'" & strBanner & "',"
		sql = sql & "'" & strStatus & "',"
		sql = sql & "" & strTamanho & ","
		sql = sql & "" & strAltura & ","
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
			window.location='Banner_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>