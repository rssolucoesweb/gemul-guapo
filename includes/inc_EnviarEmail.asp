<%
function EnviarEmail(Origem, Email, Assunto, Msg)
		
	strOrigem 		= Origem
	sEmail		 	= Email
	strAssunto		= Assunto
	strMsg			= Msg
	strData			= formatadataAP(date) 
	
	' Enviar e-mail
	if strOrigem <> "" and sEmail <> "" and strAssunto <> "" and strMsg <> "" then 
		
		if not instr(sEmail,"@") > 0 then
			%>
			<script>
				alert('Email Inválido!');
				history.back(1);
			</script>
			<%
			Response.End 
		end if
		
		
		strDadosEmail = "<html>"
		strDadosEmail = strDadosEmail & "<head>"
		strDadosEmail = strDadosEmail & "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />"
		strDadosEmail = strDadosEmail & "<title>" & session("EmpresaWeb") & "</title>"
		strDadosEmail = strDadosEmail & "</head>"
		strDadosEmail = strDadosEmail & "<body>"
		strDadosEmail = strDadosEmail & "<strong>*** NOTIFICAÇÃO ***</strong><br>"
		strDadosEmail = strDadosEmail & "Data: "& strData & "<br>"
		strDadosEmail = strDadosEmail & "" & strMsg & "<br>"
		strDadosEmail = strDadosEmail & "<br><strong> Est&aacute; é uma Mensagem autom&aacute;tica do sistema, n&atilde;o necess&aacute;rio respond&ecirc;-la.</strong><br>"
		strDadosEmail = strDadosEmail & "</body>"
		strDadosEmail = strDadosEmail & "</html>"
		
		Set cMail = Server.CreateObject("Persits.MailSender") 
		
		'Servidor de SMTP 
		cMail.Host = "localhost" 
		
		'O endereço deve ser um e-mail existente no domínio de sua revenda.
		cMail.From = strOrigem 
		
		'Remetente 
		cMail.FromName = session("EmpresaWeb")
		
		'Destinatario 
		cMail.AddAddress sEmail
		
		cMail.AddCC ""
		cMail.AddBcc ""
		
		'Assunto da mensagem 
		cMail.Subject = strAssunto
		
		'Corpo da mensagem 
		cMail.Body = strDadosEmail
		
		cMail.IsHTML = true
				
		'On Error Resume Next 
		
		cMail.Send 
		
		if err.number <> 0 then
			%>
			<script language="JavaScript">
				alert('ATENÇÂO: Contato não foi enviado, favor entrar em contato pelo telefone.');
			</script>
			<%
		end if
	
	end if
	
end function
%>