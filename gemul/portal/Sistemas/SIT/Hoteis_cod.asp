<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Hoteis
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	strNome				= Replace(Trim(Request.Form("txtNome")),"'","") 
	strEndereco 		= Replace(Trim(Request.Form("txtEndereco")),"'","")  
	strCidade  			= Replace(Trim(Request.Form("txtCidade")),"'","")   
	strUF 		 		= Replace(Trim(Request.Form("txtUF")),"'","")  
	strFone				= Trim(Request.Form("txtFone"))
	strVlrDiaria 		= replace(replace(Trim(Request.Form("txtVlrDiaria")),".",""),",",".")  
	strVlrDesc			= replace(replace(Trim(Request.Form("txtVlrDesc")),".",""),",",".")  
	strEmail 			= Replace(Trim(Request.Form("txtEmail")),"'","")  
	strSite 			= Replace(Trim(Request.Form("txtSite")),"'","") 
	
	if strVlrDiaria = "" then strVlrDiaria = 0
	if strVlrDesc = "" then strVlrDesc = 0
	
	' Dados do Usuario
	strUsuario_incl    	= session("strNomeUsuario")
	strData_hora_incl 	= formatadataBD(date) & " " & time 
	strUsuario_altr   	= session("strNomeUsuario")
	strData_hora_altr 	=formatadataBD(date) & " " & time 
		
	if acao="I" then
		
		strMensagem = "Hotel salva com sucesso..."
	
		sql = "Insert Into SIT_Hoteis (CodEmpresa, Nome, Endereco, Cidade, UF, Fone, "
		sql = sql & " VlrDiaria, VlrDesconto, Email, Site, "
		sql = sql & " Usuario, DataIncl,UsuarioAlt,DataAlt)" 
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "'" & strNome & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strCidade & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & strFone & "',"
		sql = sql & "" & strVlrDiaria & ","
		sql = sql & "" & strVlrDesc & ","
		
		if strEmail <> "" then
			sql = sql & "'" & strEmail  & "',"
		else
			sql = sql & "null,"
		end if
		
		if strSite <> "" then
			sql = sql & "'" & strSite  & "',"
		else
			sql = sql & "null,"
		end if
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
			
	elseif acao="A" then
		
		strMensagem = "Hotel Alterado com sucesso..."
		
		sql = "Update SIT_Hoteis Set"
		sql = sql & " Nome = '" & strNome & "',"
		sql = sql & " Endereco = '" & strEndereco & "',"
		sql = sql & " Cidade = '" & strCidade & "',"
		sql = sql & " UF = '" & strUF & "',"
		sql = sql & " Fone = '" & strFone & "',"
		sql = sql & " VlrDiaria = " & strVlrDiaria & ","
		sql = sql & " VlrDesconto = " & strVlrDesc & ","
		
		if strEmail <> "" then
			sql = sql & " Email = '" & strEmail & "',"
		else
			sql = sql & " Email = null,"
		end if
		
		if strSite <> "" then
			sql = sql & " Site = '" & strSite & "',"
		else
			sql = sql & " Site = null,"
		end if
		
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
	  sql = sql & " Where codigo = " & intCodigo
	  sql = sql & " And CodEmpresa = " & intCodEmpresa
	
	else
		strMensagem = "Hotel Excluido com sucesso..."
		
		sql = "Delete from SIT_Hoteis "
		sql = sql & " Where codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa

	end if 

	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Hoteis_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>