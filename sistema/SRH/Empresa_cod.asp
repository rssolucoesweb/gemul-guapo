	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Empresa
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<!--#include file="../../includes/inc_formataCnpj.asp"-->
	<%
	paginaRetorno					= "Empresa_cad.asp"
	strAcao 						= Trim(Request.QueryString("acao"))
	
	intCodigo 						= ReplaceRequest(Trim(Request.Form("txtCodEmpresa")))
	strCNPJ  						= ReplaceRequest(Trim(Request.Form("txtCNPJ")))  		
	strRazaoSocial 					= ReplaceRequest(Trim(Request.Form("txtRazaoSocial")))
	strMantenedora 					= ReplaceRequest(Trim(Request.Form("txtMantenedora")))
	strAutorizacao 					= ReplaceRequest(Trim(Request.Form("txtAutorizacao")))

	strRazaoSocialConselhoEscolar	= ReplaceRequest(Trim(Request.Form("txtConselhoEscolar")))
	strLeiDenominacao				= ReplaceRequest(Trim(Request.Form("txtLeiDenominacao")))
	strResolucaoAutorizacao			= ReplaceRequest(Trim(Request.Form("txtResolucaoAutorizacao")))

	strDiretor						= ReplaceRequest(Trim(Request.Form("txtDiretor")))
	strDecretoDiretor				= ReplaceRequest(Trim(Request.Form("txtDecretoDiretor")))
	strSecretaria					= ReplaceRequest(Trim(Request.Form("txtSecretaria")))
	strDecretoSecretaria			= ReplaceRequest(Trim(Request.Form("txtDecretoSecretaria")))
	strContato						= ReplaceRequest(Trim(Request.Form("txtContato")))  
	strContato1						= ReplaceRequest(Trim(Request.Form("txtContato1")))  
	strContato2						= ReplaceRequest(Trim(Request.Form("txtContato2")))  
	strEndereco						= ReplaceRequest(Trim(Request.Form("txtEndereco"))) 
	strBairro						= ReplaceRequest(Trim(Request.Form("txtBairro")))  
	strMunicipio					= ReplaceRequest(Trim(Request.Form("txtMunicipio")))  
	strUF							= ReplaceRequest(Trim(Request.Form("txtUF"))) 
	strCep							= ReplaceRequest(Trim(Request.Form("txtCep"))) 
	strTelefone						= ReplaceRequest(Trim(Request.Form("txtTelefone")))  
	intCodGrupo 					= ReplaceRequest(Trim(Request.Form("cmdGrupo")))
	stremail						= ReplaceRequest(Trim(Request.Form("txtemail")))
	stremailDiretoria				= ReplaceRequest(Trim(Request.Form("txtemailDiretoria")))
	stremailFinanceiro				= ReplaceRequest(Trim(Request.Form("txtemailFinanceiro")))
	stremailModulacao				= ReplaceRequest(Trim(Request.Form("txtemailModulacao")))
	stremailLogins					= ReplaceRequest(Trim(Request.Form("txtemailLogins")))
	strSimouNao						= ReplaceRequest(Trim(Request.Form("cmbSimouNao")))
	strSimouNaoDadosCadastrais		= ReplaceRequest(Trim(Request.Form("cmbSimouNaoDadosCadastrais")))
	strCodigoCenso					= ReplaceRequest(Trim(Request.Form("txtCodigoCenso")))
	strCodigoSetransp				= ReplaceRequest(Trim(Request.Form("txtCodigoSetransp")))
	strNumeroSalaAula				= ReplaceRequest(Trim(Request.Form("txtNumeroSalaAula")))
	strSimouNaoPersonalizarSistema	= ReplaceRequest(Trim(Request.Form("cmbSimouNaoPersonalizarSistema")))

	strLeiDenominacao				= Trim(Request.Form("txtLeiDenominacao"))
	strResolucaoAutorizacao			= Trim(Request.Form("txtResolucaoAutorizacao"))
	strRazaoSocialConselhoEscolar	= Trim(Request.Form("txtRazaoSocialConselhoEscolar"))
	strEmailGestor					= Trim(Request.Form("txtEmailGestor"))
	strCelularGestor				= Trim(Request.Form("txtCelularGestor"))
	strDecretoGestor				= Trim(Request.Form("txtDecretoGestor"))
	strEmailSecretario				= Trim(Request.Form("txtEmailSecretario"))
	strCelularSecretario			= Trim(Request.Form("txtCelularSecretario"))
	strDecretoSecretario			= Trim(Request.Form("txtDecretoSecretario"))
	strNomeViceGestor				= Trim(Request.Form("txtNomeViceGestor"))
	strEmailViceGestor				= Trim(Request.Form("txtEmailViceGestor"))
	strCelularViceGestor			= Trim(Request.Form("txtCelularViceGestor"))
	strDecretoViceGestor			= Trim(Request.Form("txtDecretoViceGestor"))
	strLatitude						= Trim(Request.Form("txtLatitude"))
	strLongitude					= Trim(Request.Form("txtLongitude"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Empresa Incluída com sucesso"
		
		strMensagem = "Registro Cadastrado com sucesso!"

		sql = "SELECT Max(CODIGO) as MaiorCodigo" 
		sql = sql & " FROM SEG_EMPRESA"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close
		
		sql = " insert into SEG_EMPRESA (CODIGO, CNPJ, RAZAOSOCIAL, MANTENEDORA, AUTORIZACAO, DIRETOR, SECRETARIA, CONTATO, CONTATO1, CONTATO2, ENDERECO, BAIRRO, "
		sql = sql & " MUNICIPIO, UF, CEP, TELEFONE, COD_GRUPO, EMAIL, EMAIL_DIRETORIA, EMAIL_FINANCEIRO, EMAIL_MODULACAO, EMAIL_LOGINS, "
		sql = sql & " BLOQUEIO, COMPARTILHAR_DADOS, NOTIFICACAO, CODIGO_CENSO, CODIGO_SETRANSP, TOTAL_SALAS_AULAS, PERSONALIZAR_SISTEMA, "
		sql = sql & " Lei_Denominacao, Resolucao_Autorizacao , Razao_Social_Conselho_Escolar, Email_Gestor, Celular_Gestor, Decreto_Gestor, Email_Secretario, "
		sql = sql & " Celular_Secretario, Decreto_Secretario, Nome_ViceGestor, Email_ViceGestor, Celular_ViceGestor, Decreto_ViceGestor, Latitude, Longitude )" 
		sql = sql & " VALUES ("

		sql = sql & "" & intCodigo & ","
		
		if strCNPJ = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & formataCnpjBD(strCNPJ) & "',"
		end if
		if strRazaoSocial = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strRazaoSocial & "',"
		end if
		if strMantenedora = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMantenedora & "',"
		end if
		if strAutorizacao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strAutorizacao & "',"
		end if
		if strDiretor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDiretor & "',"
		end if
		if strSecretaria = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSecretaria & "',"
		end if

		if strContato = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strContato & "',"
		end if
		if strContato1 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strContato1 & "',"
		end if
		if strContato2 = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strContato2 & "',"
		end if
		if strEndereco = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEndereco & "',"
		end if
		if strBairro = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strBairro & "',"
		end if
		if strMunicipio = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strMunicipio & "',"
		end if
		if strUF = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strUF & "',"
		end if
		if strCEP = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCEP & "',"
		end if
		if strTelefone = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strTelefone & "',"
		end if
	
		if intCodGrupo = "0" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & intCodGrupo & ","
		end if	
		
		if stremail = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & stremail & "',"
		end if	
		if stremailDiretoria = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & stremailDiretoria & "',"
		end if	
		if stremailFinanceiro = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & stremailFinanceiro & "',"
		end if	
		if stremailModulacao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & stremailModulacao & "',"
		end if	
		if stremailLogins = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & stremailLogins & "',"
		end if	
		if strSimouNao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSimouNao & "',"
		end if	
		if strSimouNaoDadosCadastrais = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSimouNaoDadosCadastrais & "',"
		end if	
		if strNotificacao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNotificacao & "',"
		end if	
		if strCodigoCenso = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCodigoCenso & ","
		end if	
		if strCodigoSetransp = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strCodigoSetransp & ","
		end if	
		if strNumeroSalaAula = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "" & strNumeroSalaAula & ","
		end if	
		if strSimouNaoPersonalizarSistema = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strSimouNaoPersonalizarSistema & "',"
		end if	

		if strLeiDenominacao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLeiDenominacao & "',"
		end if

		if strResolucaoAutorizacao = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strResolucaoAutorizacao & "',"
		end if

		if strRazaoSocialConselhoEscolar = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strRazaoSocialConselhoEscolar & "',"
		end if

		if strEmailGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEmailGestor & "',"
		end if

		if strCelularGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCelularGestor & "',"
		end if

		if strDecretoGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDecretoGestor & "',"
		end if

		if strEmailSecretario = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEmailSecretario & "',"
		end if

		if strCelularSecretario = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCelularSecretario & "',"
		end if

		if strDecretoSecretario = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDecretoSecretario & "',"
		end if

		if strNomeViceGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strNomeViceGestor & "',"
		end if

		if strEmailViceGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strEmailViceGestor & "',"
		end if

		if strCelularViceGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strCelularViceGestor & "',"
		end if

		if strDecretoViceGestor = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strDecretoViceGestor & "',"
		end if

		if strLatitude = "" then
			sql = sql & "NULL,"
		else
			sql = sql & "'" & strLatitude & "',"
		end if

		if strLongitude = "" then
			sql = sql & "NULL)"
		else
			sql = sql & "'" & strLongitude & "')"
		end if
		
	elseif strAcao = "A"then
	
		strMensagem = "Empresa Alterada com sucesso!"
		
		sql = "update SEG_EMPRESA set "
		
		if strCNPJ = "" then
			sql = sql & "CNPJ=NULL,"
		else
			sql = sql & "CNPJ='" & formataCnpjBD(strCNPJ) & "',"
		end if		
		if strRazaoSocial = "" then
			sql = sql & "RAZAOSOCIAL=NULL,"
		else
			sql = sql & "RAZAOSOCIAL='" & strRazaoSocial & "',"
		end if
		if strMantenedora = "" then
			sql = sql & "MANTENEDORA=NULL,"
		else
			sql = sql & "MANTENEDORA='" & strMantenedora & "',"
		end if
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
		if intCodGrupo = "0" then
			sql = sql & "COD_GRUPO = NULL,"
		else
			sql = sql & "COD_GRUPO = " & intCodGrupo & ","
		end if		
		if stremail = "" then
			sql = sql & "EMAIL = NULL,"
		else
			sql = sql & "EMAIL = '" & stremail & "',"
		end if	
		if stremailDiretoria = "" then
			sql = sql & "EMAIL_DIRETORIA = NULL,"
		else
			sql = sql & "EMAIL_DIRETORIA = '" & stremailDiretoria & "',"
		end if	
		if stremailFinanceiro = "" then
			sql = sql & "EMAIL_FINANCEIRO = NULL,"
		else
			sql = sql & "EMAIL_FINANCEIRO = '" & stremailFinanceiro & "',"
		end if	
		if stremailModulacao = "" then
			sql = sql & "EMAIL_MODULACAO = NULL,"
		else
			sql = sql & "EMAIL_MODULACAO = '" & stremailModulacao & "',"
		end if	
		if stremailLogins = "" then
			sql = sql & "EMAIL_LOGINS = NULL,"
		else
			sql = sql & "EMAIL_LOGINS = '" & stremailLogins & "',"
		end if	
		if strSimouNao = "" then
			sql = sql & "BLOQUEIO = NULL,"
		else
			sql = sql & "BLOQUEIO = '" & strSimouNao & "',"
		end if	
		if strSimouNaoDadosCadastrais = "" then
			sql = sql & "COMPARTILHAR_DADOS = NULL,"
		else
			sql = sql & "COMPARTILHAR_DADOS = '" & strSimouNaoDadosCadastrais & "',"
		end if	
		if strNotificacao = "" then
			sql = sql & "NOTIFICACAO = NULL,"
		else
			sql = sql & "NOTIFICACAO = '" & strNotificacao & "',"
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
		if strNumeroSalaAula = "" then
			sql = sql & "TOTAL_SALAS_AULAS = NULL,"
		else
			sql = sql & "TOTAL_SALAS_AULAS = " & strNumeroSalaAula & ","
		end if	
		if strSimouNaoPersonalizarSistema = "" then
			sql = sql & "PERSONALIZAR_SISTEMA = NULL,"
		else
			sql = sql & "PERSONALIZAR_SISTEMA = '" & strSimouNaoPersonalizarSistema & "',"
		end if	

		if strLeiDenominacao = "" then
			sql = sql & "Lei_Denominacao = NULL,"
		else
			sql = sql & "Lei_Denominacao = '" & strLeiDenominacao & "',"
		end if	

		if strResolucaoAutorizacao = "" then
			sql = sql & "Resolucao_Autorizacao = NULL,"
		else
			sql = sql & "Resolucao_Autorizacao = '" & strResolucaoAutorizacao & "',"
		end if	

		if strRazaoSocialConselhoEscolar = "" then
			sql = sql & "Razao_Social_Conselho_Escolar = NULL,"
		else
			sql = sql & "Razao_Social_Conselho_Escolar = '" & strRazaoSocialConselhoEscolar & "',"
		end if	

		if strEmailGestor = "" then
			sql = sql & "Email_Gestor = NULL,"
		else
			sql = sql & "Email_Gestor = '" & strEmailGestor & "',"
		end if	

		if strCelularGestor = "" then
			sql = sql & "Celular_Gestor = NULL,"
		else
			sql = sql & "Celular_Gestor = '" & strCelularGestor & "',"
		end if	

		if strDecretoGestor = "" then
			sql = sql & "Decreto_Gestor = NULL,"
		else
			sql = sql & "Decreto_Gestor = '" & strDecretoGestor & "',"
		end if	

		if strEmailSecretario = "" then
			sql = sql & "Email_Secretario = NULL,"
		else
			sql = sql & "Email_Secretario = '" & strEmailSecretario & "',"
		end if	

		if strCelularSecretario = "" then
			sql = sql & "Celular_Secretario = NULL,"
		else
			sql = sql & "Celular_Secretario = '" & strCelularSecretario & "',"
		end if	

		if strDecretoSecretario = "" then
			sql = sql & "Decreto_Secretario = NULL,"
		else
			sql = sql & "Decreto_Secretario = '" & strDecretoSecretario & "',"
		end if	

		if strNomeViceGestor = "" then
			sql = sql & "Nome_ViceGestor = NULL,"
		else
			sql = sql & "Nome_ViceGestor = '" & strNomeViceGestor & "',"
		end if	

		if strEmailViceGestor = "" then
			sql = sql & "Email_ViceGestor = NULL,"
		else
			sql = sql & "Email_ViceGestor = '" & strEmailViceGestor & "',"
		end if	

		if strCelularViceGestor = "" then
			sql = sql & "Celular_ViceGestor = NULL,"
		else
			sql = sql & "Celular_ViceGestor = '" & strCelularViceGestor & "',"
		end if	

		if strDecretoViceGestor = "" then
			sql = sql & "Decreto_ViceGestor = NULL,"
		else
			sql = sql & "Decreto_ViceGestor = '" & strDecretoViceGestor & "',"
		end if	

		if strLatitude = "" then
			sql = sql & "Latitude = NULL,"
		else
			sql = sql & "Latitude = '" & strLatitude & "',"
		end if	

		if strLongitude = "" then
			sql = sql & "Longitude = NULL "
		else
			sql = sql & "Longitude = '" & strLongitude & "'"
		end if	
		sql = sql & " where CODIGO = " & intCodigo
			
	elseif strAcao = "E"then 
			
		strMensagem = "Empresa Excluida com sucesso"
		
		sql = "Delete From SEG_EMPRESA"
		sql = sql & " where CODIGO = " & intCodigo
		sql = sql & " And COD_GRUPO = " & intCodGrupo
	
	end if
	
	response.write sql
	response.End()
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=paginaRetorno%>';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.history.back();
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
			</script>
			<%
		end  if 	
	end if
%>