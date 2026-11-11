<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 16/09/2007
	::	Desenvolvedores...: Sérgio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastro de Empresa
-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnnDocumento.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<!--#include file="../../includes/inc_formataCnpj.asp"-->
	<%
	
	strAcao 			= Request.QueryString("acao")
	intCodigo 			= Request("txtCodEmpresa")
	
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	'carregamento de variaveis
	strAutorizacao 				= Trim(Request("txtAutorizacao"))
	strDiretor					= Trim(request("txtDiretor"))
	strSecretaria				= Trim(request("txtSecretaria"))
	strContato					= Trim(request("txtContato"))  
	strEndereco					= Trim(request("txtEndereco")) 
	strBairro					= Trim(request("txtBairro"))  
	strMunicipio				= Trim(request("txtMunicipio"))  
	strUF						= Trim(request("txtUF")) 
	strCep						= Trim(request("txtCep")) 
	strTelefone					= Trim(request("txtTelefone"))  
	strCodigoCenso				= Trim(Request("txtCodigoCenso"))
	strCodigoSetransp			= Trim(Request("txtCodigoSetransp"))
	if strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso!"
			
		sql = "update SEG_EMPRESA set "
		if strAutorizacao = "" then
			sql = sql & "AUTORIZACAO=NULL,"
		else
			sql = sql & "AUTORIZACAO='" & strAutorizacao & "',"
		end if
		if strDiretor = "" then
			sql = sql & "DIRETOR=NULL,"
		else
			sql = sql & "DIRETOR='" & strDiretor & "',"
		end if
		if strSecretaria = "" then
			sql = sql & "SECRETARIA=NULL,"
		else
			sql = sql & "SECRETARIA='" & strSecretaria & "',"
		end if
		if strContato = "" then
			sql = sql & "CONTATO=NULL,"
		else
			sql = sql & "CONTATO='" & strContato & "',"
		end if
		if strEndereco = "" then
			sql = sql & "ENDERECO=NULL,"
		else
			sql = sql & "ENDERECO='" & strEndereco & "',"
		end if
		if strBairro = "" then
			sql = sql & "BAIRRO=NULL,"
		else
			sql = sql & "BAIRRO='" & strBairro & "',"
		end if
		if strMunicipio = "" then
			sql = sql & "MUNICIPIO=NULL,"
		else
			sql = sql & "MUNICIPIO='" & strMunicipio & "',"
		end if
		if strUF = "" then
			sql = sql & "UF=NULL,"
		else
			sql = sql & "UF='" & strUF & "',"
		end if
		if strCEP = "" then
			sql = sql & "CEP=NULL,"
		else
			sql = sql & "CEP='" & strCEP & "',"
		end if
		if strTelefone = "" then
			sql = sql & "TELEFONE=NULL,"
		else
			sql = sql & "TELEFONE='" & strTelefone & "',"
		end if
		if strCodigoCenso = "" then
			sql = sql & "CODIGO_CENSO = NULL,"
		else
			sql = sql & "CODIGO_CENSO = " & strCodigoCenso & ","
		end if	
		if strCodigoSetransp = "" then
			sql = sql & "CODIGO_SETRANSP = NULL"
		else
			sql = sql & "CODIGO_SETRANSP = " & strCodigoSetransp & ""
		end if	
		
		sql = sql & " where CODIGO = " & intCodigo
				
	elseif strAcao = "E"then 
	
	end if
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate("EmpresaAutorizacao_cad.asp");
		</script>
		<%
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>