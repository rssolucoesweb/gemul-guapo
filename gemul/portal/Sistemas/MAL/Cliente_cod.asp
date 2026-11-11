<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 21/09/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Cliente.
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
    ::	Observação        : Um dia depois do meus 34 anos, essa idade ralando igual um doido.
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodigo 			= Trim(Request.Form("txtCodigo"))
	intCodTipoContato	= Trim(Request.Form("cmbTipoContato"))
	strNome	 			= Trim(Request.Form("txtNome"))
	strEmail			= Trim(Request.Form("txtEmail"))
	strDatanascimento	= formataDataBD(Trim(Request.Form("txtDatanascimento")))

	' Dados Endereco 1
	strCep1				= Trim(Request.Form("txtCep1"))
	strEndereco1		= Trim(Request.Form("txtEndereco1"))
	strCidade1			= Trim(Request.Form("txtCidade1"))
	strBairro1			= Trim(Request.Form("txtBairro1"))

	' Dados Endereco 2
	strCep2				= Trim(Request.Form("txtCep2"))
	strEndereco2		= Trim(Request.Form("txtEndereco2"))
	strCidade2			= Trim(Request.Form("txtCidade2"))
	strBairro2			= Trim(Request.Form("txtBairro2"))
	
	' Dados Contato 
	strFoneResidencial	= Trim(Request.Form("txtFoneResidencial"))
	strFoneComercial	= Trim(Request.Form("txtFoneComercial"))
	strFoneCelular		= Trim(Request.Form("txtFoneCelular"))
	
	if acao="I" then
		
		strMensagem = "Cliente Salvo com sucesso..."
		
		sql = "Insert Into MAL_Cliente( CodTipoContato, Nome, Email, Datanascimento, "
		sql = sql & " Cep1, Endereco1, Cidade1, Bairro1," 
		sql = sql & " Cep2, Endereco2, Cidade2, Bairro2, "
		sql = sql & " FoneResidencial, FoneComercial, FoneCelular )"
		sql = sql & " Values ("
		
		sql = sql & "" & intCodTipoContato & ","
		sql = sql & "'" & strNome & "',"
		
		if strDatanascimento = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strDatanascimento & "',"
		end if
		
		
		if strEmail = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strEmail & "',"
		end if
		
		' Dados Endereco 1
		sql = sql & "'" & strCep1 & "',"
		sql = sql & "'" & strEndereco1 & "',"
		sql = sql & "'" & strCidade1 & "',"
		sql = sql & "'" & strBairro1 & "',"
		
		' Dados Endereco 2
		if strCep2 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strCep2 & "',"
		end if
		
		if strEndereco2 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strEndereco2 & "',"
		end if
		
		if strCidade2 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strCidade2 & "',"
		end if
		
		if strBairro2 = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strBairro2 & "',"
		end if
		
		' Dados Endereco 2
		if strFoneResidencial = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strFoneResidencial & "',"
		end if
		
		if strFoneComercial = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & strFoneComercial & "',"
		end if
		
		if strFoneCelular = "" then
			sql = sql & "null )"
		else
			sql = sql & "'" & strFoneCelular & "')"
		end if
		
	elseif acao="A" then
		
		strMensagem = "Cliente Alterado com sucesso..."
		
		sql = "Update MAL_Cliente Set"
		
		sql = sql & " CodTipoContato = " & intCodTipoContato & ","
		sql = sql & " Nome = '" & strNome & "',"
		
		if strDatanascimento = "" then
			sql = sql & "Datanascimento = null,"
		else
			sql = sql & "Datanascimento = '" & strDatanascimento & "',"
		end if
		
		if strEmail = "" then
			sql = sql & "Email = null,"
		else
			sql = sql & "Email = '" & strEmail & "',"
		end if
		
		' Dados Endereco 1
		sql = sql & " Cep1 = '" & strCep1 & "',"
		sql = sql & " Endereco1 = '" & strEndereco1 & "',"
		sql = sql & " Cidade1 = '" & strCidade1 & "',"
		sql = sql & " Bairro1 = '" & strBairro1 & "',"
		
		' Dados Endereco 2
		if strCep2 = "" then
			sql = sql & "Cep2 = null,"
		else
			sql = sql & "Cep2 = '" & strCep2 & "',"
		end if
		
		if strEndereco2 = "" then
			sql = sql & "Endereco2 = null,"
		else
			sql = sql & "Endereco2 = '" & strEndereco2 & "',"
		end if
		
		if strCidade2 = "" then
			sql = sql & "Cidade2 = null,"
		else
			sql = sql & "Cidade2 = '" & strCidade2 & "',"
		end if
		
		if strBairro2 = "" then
			sql = sql & "Bairro2 = null,"
		else
			sql = sql & "Bairro2 = '" & strBairro2 & "',"
		end if
		
		' Dados Contato
		if strFoneResidencial = "" then
			sql = sql & "FoneResidencial = null,"
		else
			sql = sql & "FoneResidencial = '" & strFoneResidencial & "',"
		end if
		
		if strFoneComercial = "" then
			sql = sql & "FoneComercial = null,"
		else
			sql = sql & "FoneComercial = '" & strFoneComercial & "',"
		end if
		
		if strFoneCelular = "" then
			sql = sql & "FoneCelular = null"
		else
			sql = sql & "FoneCelular = '" & strFoneCelular & "'"
		end if

		sql = sql & " Where Codigo = " & intCodigo 
		
	else
	
		strMensagem = "Cliente Excluido com sucesso..."
		
		sql = "Delete from MAL_Cliente "
		sql = sql & " Where Codigo = " & intCodigo
	
	end if
	
	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Cliente_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>