<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 26/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
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
	
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans

	'carregamento de variaveis
	strCNPJ  					= Trim(request("txtCNPJ"))  		
	strRazaoSocial 				= Trim(request("txtRazaoSocial")) 
	strMantenedora 				= Trim(Request("txtMantenedora"))
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
	intCodGrupo 				= Trim(request("cmdGrupo"))
	stremail					= Trim(Request("txtemail"))
	stremailDiretoria			= Trim(Request("txtemailDiretoria"))
	stremailFinanceiro  		= Trim(Request("txtemailFinanceiro"))
	stremailModulacao			= Trim(Request("txtemailModulacao"))
	stremailLogins  			= Trim(Request("txtemailLogins"))
	strNotificacao 				= Trim(Request("txtNotificacao"))
	strSimouNao 				= Trim(request("cmbSimouNao"))
	strSimouNaoDadosCadastrais	= Trim(Request("cmbSimouNaoDadosCadastrais"))
	strCodigoCenso				= Trim(Request("txtCodigoCenso"))
	strCodigoSetransp				= Trim(Request("txtCodigoSetransp"))
	strNumeroSalaAula				= Trim(Request("txtNumeroSalaAula"))
	strSimouNaoPersonalizarSistema	= Trim(Request("cmbSimouNaoPersonalizarSistema"))
	intCodTipoEmpresa				= Trim(Request("cmbTipoEmpresa"))
	if intCodTipoEmpresa = "1" then strTipoEmpresa = "CMEIS"
	if intCodTipoEmpresa = "2" then strTipoEmpresa = "UNIDADE_ESCOLA"
	if intCodTipoEmpresa = "3" then strTipoEmpresa = "UNIDADE_ESCOLA"
	if intCodTipoEmpresa = "4" then strTipoEmpresa = "EMEI"
	
	if strAcao = "A"then
	
		strMensagem = "Registro Alterado com sucesso!"
			
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
	
		if intCodTipoEmpresa = "" then
			sql = sql & "CodTipoEmpresa = NULL"
		else
			sql = sql & "CodTipoEmpresa = " & intCodTipoEmpresa & ""
		end if	
			
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		if session("CodGrupo") = "7" then
			if strSimouNao = "S" THEN SIT = "I"
			if strSimouNao = "N" THEN SIT = "A"			
			SQL = "SELECT CODIGO FROM gemul_estoque.dbo.EST_DEPARTAMENTO WHERE cod_empresa = 9 and COD_EMPRESA_ACADEMICO=" & intCodigo
			RS.OPEN SQL, CNN
			IF RS.EOF THEN
	
				'INTEGRAÇÃO COM O ESTOQUE
				sql = "insert into gemul_estoque.dbo.EST_DEPARTAMENTO (COD_EMPRESA, DESCRICAO, TIPO, COD_EMPRESA_ACADEMICO, SITUACAO, usuario_incl, data_hora_incl) values ("
				sql = sql & "9,'" & strRazaoSocial & "',"
				sql = sql & "'" & strTipoEmpresa & "',"
				sql = sql & "" & intCodigo & ","
				sql = sql & "'"&SIT&"',"
				sql = sql & "'" & trim(session("usuarioWeb")) & "',GETDATE())"
				cnn.execute sql
				GravarLog sql

			ELSE
				'INTEGRAÇÃO COM O ESTOQUE
				sql = "UPDATE gemul_estoque.dbo.EST_DEPARTAMENTO SET SITUACAO = '"&SIT&"', TIPO = '" & strTipoEmpresa & "', DESCRICAO = '" & replace(strRazaoSocial,"ESCOLA MUNICIPAL","EM") & "', usuario_altr='"&trim(session("usuarioWeb"))&"', data_hora_altr=getdate() WHERE cod_empresa = 9 and  COD_EMPRESA_ACADEMICO=" & intCodigo
				cnn.execute sql
				GravarLog sql
			END IF
			RS.CLOSE
		end if				
	elseif strAcao = "E"then 
			
		strMensagem = "Registro Excluido com sucesso"
		
		sql = " Delete From SEG_EMPRESA"
		sql = sql & " where CODIGO = " & intCodigo
	
		cnn.execute sql
		GravarLog sql
	
	end if
	
	
	if err.number = 0 then
		'registro será atualizado/incluido com sucesso
		'cnn.committrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Empresa_cad.asp';
		</script>
		<%
	else
		'registro teve problema e não será atualizado
		'cnn.rollbacktrans
		if err.number = -2147217900 then
			%>
			<script>
				alert("Atenção : Esta Informação não pode ser excluida pois existem registros vinculados a ela");
				window.location='Empresa_cad.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.location='Empresa_cad.asp';
			</script>
			<%
		end  if 	
	end if
%>