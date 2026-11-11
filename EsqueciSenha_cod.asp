<!--#include file="includes/inc_smtp_config.asp"-->
<HTML>
<HEAD>
<TITLE>...</TITLE>
<META HTTP-EQUIV="Content-Type"
CONTENT="text/html; charset=ISO-8859-1">
</HEAD>
<body>
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/cripto.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<%	
	dim sEmail
	dim strAssunto
	dim sMsg
	dim cMail
	usuarioCadastrado 	= "N"
	strCPF				= replace(replace(request.Form("txtcpf"),".",""),"-","")
	intCodFuncional 	= request.Form("txtCodigoFuncional")
	strDataNascimentoTela = replace(replace(Trim(Request.Form("txtDataNascimento")),"/",""),"-","")
	strDiaNascimentoTela = left(strDataNascimentoTela,2)
	strMesNascimentoTela = "/" & mid(strDataNascimentoTela,3,2)
	strAnoNascimentoTela = "/" & right(strDataNascimentoTela,4)
	strDataNascimentoTela = strDiaNascimentoTela & strMesNascimentoTela & strAnoNascimentoTela
	strDataNascimento	= formataDataBD(strDataNascimentoTela)
	strEmailDestino		= request.Form("txtemail")
	strEmailDestinoPagina		= request.Form("txtemail")
	
	if strCPF <> "" or strDataNascimento <> "" or strEmailDestino <> "" then
		
		'verifica se é colaborador
		sql = "SELECT Cod_Empresa , Nome, CPF, CodFuncional, Data_Nascimento, email "
		sql = sql & " FROM SRH_COLABORADOR "
		sql = sql & " Where replace(replace(CPF,'.',''),'-','') = '" & strCPF & "'"
		if intCodFuncional<>"" then
			sql = sql & " And CodFuncional = " & intCodFuncional 
		end if
		sql = sql & " And Data_Nascimento = '" & strDataNascimento & "'"
		sql = sql & " And email = '" & strEmailDestinoPagina & "'"
		
		rs.open sql, cnn
		if not rs.eof then
			
			intCodEmpresa		= rs("Cod_Empresa")
			strNome				= rs("Nome")
			strCPF				= rs("CPF")
			intCodFuncional 	= rs("CodFuncional")
			strDataNascimento	= rs("Data_Nascimento")
			rs.close
			
			sql = " SELECT USUA_CODG, Usua_Info_senha, Usua_Stat, usua_email "
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " WHERE USUA_CPF = '" &  strCPF & "'"
			sql = sql & " and Usua_Stat = 'A'"
			rsAux.open sql, cnn
			if not rsAux.eof then
				strEmailDestino = rsAux("usua_email")
				strSenha 		= rsAux("Usua_Info_senha")
				usuarioCadastrado = "S"				
			end if
			rsAux.close
		end if
		
		if 	usuarioCadastrado = "N" then
			'usuario não é colaborador
			sql = " SELECT USUA_CODG, Usua_Info_senha, Usua_Stat, USUA_EMAIL "
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " WHERE Usua_Stat = 'A'"
			sql = sql & " And USUA_EMAIL = '" & strEmailDestinoPagina & "'"
			rsAux.open sql, cnn
			if not rsAux.eof then
				strEmailDestino = rsAux("usua_email")
				strSenha 		= rsAux("Usua_Info_senha")

				' Criptografa Senha
				'if strSenha <> "" then 
				'	strSenha = FormatCripto(strSenha,false)
				'end if 
				usuarioCadastrado = "S"
			end if
			rsAux.close		
		end if

		if usuarioCadastrado = "N" then
			rs.close
			%>
			<script>
                alert('Usuário não cadastrado no Sistema, Verifique!');
				window.location='EsqueciSenha.asp';
            </script>
            <%
            Response.End 
		end if 
	end if
	
	strEMAIL = strEmailDestino
	
	'aqui iremos verificar se algum campo ficou em brancoti
	if strEmailDestino <> "" then 
		
		if not instr(strEmailDestino,"@") > 0 then
			%>
			<script>
				alert('Email Inválido!');
				window.location='EsqueciSenha.asp';
			</script>
			<%
			Response.End 
		end if
		
		strMsg = "Ola " & strNome & "!<br>"
		strMsg = strMsg & " Solicitacao de senha foi recebida pelo suporte GEMUL. <br>" & vbcrlf & vbcrlf
		strMsg = strMsg & " Se voce nao fez essa solicitacao, por favor desconsidere este email. <br>"  & vbcrlf & vbcrlf
		strMsg = strMsg & " <br>E-mail: " & strEmailDestino & vbcrlf & vbcrlf
		strMsg = strMsg & " <br>Senha: " & strSenha & vbcrlf & vbcrlf
		strMsg = strMsg & " <br><br>Equipe GEMUL!    "
	  
		'****** CONFIGURAÇÃO DE EMAIL sendinblue *****************
		'servidorSMTP = "smtp-relay.sendinblue.com"
		'usuarioSMTP  =  "suporte@gemul.com.br" 
		'senhaSMTP    = "" 
		'NomeSMTP     = "GEMUL"
		'usuarioEmailEnvioSMTP = "suporte@gemul.com.br"
		'***********************
		'****** CONFIGURAÇÃO DE EMAIL LOCAWEB *****************
		servidorSMTP = "smtplw.com.br"
		usuarioSMTP  = "suportegemul" 
		senhaSMTP    = SMTP_LW_SENHA 
		NomeSMTP     = "GEMUL"
		usuarioEmailEnvioSMTP = "suporte@gemul.com.br"
		'********************************************************'
		
		nomeDestinatario=strNome
		emailDestinatario=strEMAIL
		nomeRemetente="Secretaria Municipal da Educação Recursos Humanos "
		emailRemetente="suporte@gemul.com.br" 'O endereço de e-mail deve ser preenchido com uma conta existente em seu próprio domínio.
		emailRetorno="suporte@gemul.com.br"
		responderPara="recursoshumanos.sme@gmail.com"
		strAssunto="GEMUL - Esquece minha senha"
		mensagem=mensagemEmail
	
	
		strEmailInvalido = "N"
		if not instr(strEmail,"@") > 0 then
			strEmailInvalido = "S"
		end if
		
		if strEmailInvalido = "N" then
			
			strDadosEmail = strMsg
					
			Set Mail = CreateObject("CDO.Message")

			'This section provides the configuration information for the remote SMTP server.

			'Send the message using the network (SMTP over the network).
			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") =servidorSMTP
			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 587

			'Use SSL for the connection (True or False)
			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False

			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60

			'If your server requires outgoing authentication, uncomment the lines below and use a valid email address and password.
			'Basic (clear-text) authentication
			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
			'Your UserID on the SMTP server
			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") =usuarioSMTP
			Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") =senhaSMTP

			Mail.Configuration.Fields.Update

			'End of remote SMTP server configuration section

			Mail.Subject=strAssunto
			Mail.From=NomeSMTP & " <" & usuarioEmailEnvioSMTP & ">" 
			Mail.To=strNome & " <" & strEmail & ">"
			'Mail.TextBody="teste"
			Mail.HtmlBody = "<html> <head><meta http-equiv=""Content-Type"" content=""text/html;charset=utf-8""></head><body>" & strDadosEmail & "</body></html>" 

			Mail.Send
			Set Mail = Nothing
	
		end if
		
		If Err <> 0 Then 
			%>
			<script language="JavaScript">
				alert('Ocorreu um erro ao enviar o e-mail: \n'+ '<%=err.description%>');
				window.location='EsqueciSenha.asp';
			</script>
			<%
			Response.End 
		else
			%>
            </body>
            </html>
			<script language="JavaScript">
				alert('Senha foi enviada com sucesso para seu email: <%=strEmailDestino%>!');
				window.location='default.asp';
			</script>
			<%	
			Response.End 
		End If 
	
		Set mail = nothing
	else
	
	%>
		<script>
			alert('Email nao encontrado, verifique!');
			window.location='EsqueciSenha.asp';
		</script>
		<%
		Response.End 
	end if
%>