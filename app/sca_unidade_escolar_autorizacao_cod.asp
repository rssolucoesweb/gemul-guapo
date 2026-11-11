<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo				= Session("CodEmpresa")
	
	'carregamento de variaveis
	strAutorizacao 				= Trim(Request("txtAutorizacao"))
	strDiretor					= Trim(request("txtDiretor"))
	strSecretaria				= Trim(request("txtSecretaria"))
	strContato					= Trim(request("txtContato"))  
	strContato1					= Trim(request("txtContato1"))  
	strContato2					= Trim(request("txtContato2"))  
	strEndereco					= Trim(request("txtEndereco")) 
	strBairro					= Trim(request("txtBairro"))  
	strMunicipio				= Trim(request("txtMunicipio"))  
	strUF						= Trim(request("txtUF")) 
	strCep						= Trim(request("txtCep")) 
	strTelefone					= Trim(request("txtTelefone"))  
	strCodigoCenso				= Trim(Request("txtCodigoCenso"))
	strCodigoSetransp			= Trim(Request("txtCodigoSetransp"))
	strNomeCaixa				= Trim(Request.Form("txtNomeCaixa"))
	strPresidente				= Trim(Request.Form("txtPresidente"))
	strDataInicio				= FORMATADATABD(Trim(Request.Form("txtDataInicio")))
	strDataFim					= FORMATADATABD(Trim(Request.Form("txtDataFim")))
	if acao="I" then

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
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
		if strContato1 = "" then
			sql = sql & "CONTATO1=NULL,"
		else
			sql = sql & "CONTATO1='" & strContato1 & "',"
		end if
		if strContato2 = "" then
			sql = sql & "CONTATO2=NULL,"
		else
			sql = sql & "CONTATO2='" & strContato2 & "',"
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
			sql = sql & "CODIGO_SETRANSP = NULL,"
		else
			sql = sql & "CODIGO_SETRANSP = " & strCodigoSetransp & ","
		end if	

		if strNomeCaixa = "" then
			sql = sql & "NomeCaixa = NULL,"
		else
			sql = sql & "NomeCaixa = '" & strNomeCaixa & "',"
		end if	

		if strPresidente = "" then
			sql = sql & "Presidente = NULL,"
		else
			sql = sql & "Presidente = '" & strPresidente & "',"
		end if	

		if strDataInicio = "" then
			sql = sql & "DataInicio = NULL,"
		else
			sql = sql & "DataInicio = '" & strDataInicio & "',"
		end if	

		if strDataFim = "" then
			sql = sql & "DataFim = NULL"
		else
			sql = sql & "DataFim = '" & strDataFim & "'"
		end if	
		
		sql = sql & " where CODIGO = " & intCodigo
		
		'response.write sql
		
		
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_unidade_escolar_autorizacao.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>