	<!--#include file="../includes/inc_cnn.asp"-->
	<!--#include file="../includes/inc_formatadata.asp"-->

	<%
	strLoginEmail		= Trim(Request.Form("txtlogin"))
	strDataAtual		= formataDataBD(date) & " " & time

	dim sEmail
	dim strAssunto
	dim sMsg
	dim cMail

	usuarioCadastrado 	= "N"

	strEmailDestino				= request.Form("txtemail")
	strEmailDestinoPagina		= request.Form("txtemail")
	
	if strLoginEmail <> "" then

		sql = "select USUA_CODG, USUA_NOME_COMPLETO, USUA_EMAIL "
		sql = sql & " from SEG_USUARIOS_SISTEMA "
		sql = sql & " where USUA_CODG = '" & strLoginEmail & "'"
		sql = sql & " and Usua_Stat = 'A'"
		rs.open sql, cnn
		if not rs.eof then
			usuarioCadastrado = "S"
			strEmailDestino = rs("usua_email")
			USUA_CODG = rs("USUA_CODG")
			strNome = rs("USUA_NOME_COMPLETO") 
		end if
		rs.close
		
		if 	usuarioCadastrado = "N" then
			sql = "select USUA_CODG, USUA_NOME_COMPLETO, USUA_EMAIL"
			sql = sql & " from SEG_USUARIOS_SISTEMA"
			sql = sql & " where USUA_EMAIL = '" & strLoginEmail & "'"
			sql = sql & " and Usua_Stat = 'A'"
			rs.open sql, cnn
			if not rs.eof then
				usuarioCadastrado = "S"
				strEmailDestino = rs("usua_email")
				USUA_CODG = rs("USUA_CODG")
				strNome = rs("USUA_NOME_COMPLETO") 
			end if
			rs.close
		end if
		
		if usuarioCadastrado = "N" or strEmailDestino="" then
			%>
			<script>
                alert('Recuperação de Senha Não Processada!\nAs informações fornecidas (como usuário ou e-mail) não foram localizadas em nosso sistema.\nRecomendamos que você verifique os dados inseridos e tente novamente.');
				window.location='esqueci-senha.asp';
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
				alert('Email cadastrado para recuperar a senha é inválido!');
				window.location='esqueci-senha.asp';
			</script>
			<%
			Response.End 
		end if
		
		'GERAR KEY_RECUPERAR_SENHA
		sql = "SELECT NEWID() AS CodigoUnico"
		rs.open sql, cnn
		strkey = rs("codigoUnico")
		rs.close
		
		sql = "update SEG_USUARIOS_SISTEMA set KEY_RECUPERAR_SENHA = '" & strkey & "' where USUA_CODG='" & USUA_CODG & "'"
		CNN.EXECUTE sql
		
		strLink = "https://gemul-guapo.com.br/login/recuperar-senha.asp?key=" & strkey
		strMsg = "Ola " & strNome & "!<br>"
		strMsg = strMsg & " Suporte GEMUL recebeu sua solicitacao para recuperar a senha. <br>" & vbcrlf & vbcrlf
		strMsg = strMsg & " Se voce nao fez essa solicitacao, por favor desconsidere este email. <br>"  & vbcrlf & vbcrlf
		strMsg = strMsg & " <br>Clique no link abaixo para fazer a alteracao da sua senha: <br>" & strLink & vbcrlf & vbcrlf
		strMsg = strMsg & " <br><br>Equipe GEMUL!    "
	  
		'****** CONFIGURAÇÃO DE EMAIL sendinblue *****************
		'servidorSMTP = "smtp-relay.sendinblue.com"
		'usuarioSMTP  =  "suporte@gemul.com.br" 
		'senhaSMTP    = "IOW5qh9Pdn3zvBFp" 
		'NomeSMTP     = "GEMUL"
		'usuarioEmailEnvioSMTP = "suporte@gemul.com.br"
		'***********************
		'****** CONFIGURAÇÃO DE EMAIL LOCAWEB *****************
		servidorSMTP = "smtplw.com.br"
		usuarioSMTP  = "suportegemul" 
		senhaSMTP    = "BwIpkcmI2999" 
		NomeSMTP     = "GEMUL"
		usuarioEmailEnvioSMTP = "suporte@gemul.com.br"
		'********************************************************'
		
		nomeDestinatario=strNome
		emailDestinatario=strEMAIL
		nomeRemetente="Secretaria Municipal da Educação de Guapó "
		emailRemetente="suporte@gemul.com.br" 'O endereço de e-mail deve ser preenchido com uma conta existente em seu próprio domínio.
		emailRetorno="suporte@gemul.com.br"
		'responderPara="recursoshumanos.sme@gmail.com"
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
				window.location='esqueci-senha.asp';
			</script>
			<%
			Response.End 
		else
			%>
            </body>
            </html>
			<script language="JavaScript">
				alert('Instrução para recuperar a senha foi enviada com sucesso para seu email: <%=strEmailDestino%>!');
				window.location='index.asp';
			</script>
			<%	
			Response.End 
		End If 
	
		Set mail = nothing
	else
	
	%>
		<script>
			alert('Email nao encontrado, verifique!');
			window.location='esqueci-senha.asp';
		</script>
		<%
		Response.End 
	end if
%>

