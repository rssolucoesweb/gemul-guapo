<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
		
	strNome				= Replace(Trim(Request.Form("txtNome")),"'","")
	strEmail			= Replace(Trim(Request.Form("txtEmail")),"'","")
	strFone				= Replace(Trim(Request.Form("txtFone")),"'","")
	strAssuntoSite		= Trim(Request.Form("txtAssunto"))	
	strMsg				= Replace(Trim(Request.Form("txtMensagem")),"'","")
	strStatus		    = "N" ' Não Lido

	strEmailDestino	 	= "contato@rssolucoesweb.com.br"
	
	strSiteRevenda  	= "rssolucoesweb.com.br"
	strContatoRevenda  	= "Sérgio"
	
	strDataBD 		 = formataDataBD(date) 
	strAssunto		 = "Contato - " & strSiteRevenda

	strData 	  =  formataDataAP(date)  & " " & time 
	strDadosEmail = "<html>"
	strDadosEmail = strDadosEmail & "<head>"
	strDadosEmail = strDadosEmail & "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />"
	strDadosEmail = strDadosEmail & "<title>Email pelo site RS Soluções Web</title>"
	strDadosEmail = strDadosEmail & "</head>"
	strDadosEmail = strDadosEmail & "<body>"
	strDadosEmail = strDadosEmail & "<strong>***Contato pelo site www.rssolucoesweb.com.br***</strong><br>"
	strDadosEmail = strDadosEmail & "Assunto: " & strAssuntoSite & "<br>"
	strDadosEmail = strDadosEmail & "Data do Contato: "& strData & "<br>"
	strDadosEmail = strDadosEmail & "Nome: "& strNome & "<br>"
	strDadosEmail = strDadosEmail & "E-mail: "& strEmail & "<br>"
	strDadosEmail = strDadosEmail & "Telefone: "& strFone & "<br>"
	strDadosEmail = strDadosEmail & "Mensagem: "& strMsg & "<br>"
	strDadosEmail = strDadosEmail & "</body>"
	strDadosEmail = strDadosEmail & "</html>"

	if not instr(strEmail,"@") > 0 then
		%>
		<script>
			alert('Email Inválido!');
			history.back();
		</script>
		<%
		Response.End 
	end if
	
	Set cMail = Server.CreateObject("Persits.MailSender") 
	
	'Servidor de SMTP 
	cMail.Host = "localhost" 
	'cMail.Host = "smtp2.locaweb.com.br" 
	
	'email de que enviou a msn.
	cMail.From = strEmail
	
	'Remetente 
	cMail.FromName = strNome
	
	'Destinatario 
	cMail.AddAddress strEmailDestino
	
	cMail.AddCC ""
	cMail.AddBcc ""
	
	'Assunto da mensagem 
	cMail.Subject = strAssuntoSite
	
	'Corpo da mensagem 
	cMail.Body = strDadosEmail
	
	cMail.IsHTML = true
	
	'On Error Resume Next 
	cMail.Send 
	
	if strReceberNews = "" then strReceberNews = "N"

	sql = "SELECT Max(ConCodigo) as MaiorCodigo" 
	sql = sql & " FROM Contatos"
	rs.open sql, cnn
	
	if not RS.EOF then
	
		if rs("MaiorCodigo") <> "" then
			intCodNovo = cstr(rs("MaiorCodigo")) + 1
			intCodContato = intCodNovo
		else
			intCodContato = 1	
		end if
	
	end if
	rs.close
	
	sql = "Insert Into Contatos(ConCodigo, ConNome, ConEmail, ConTelefone, ConData, ConAssunto, ConMensagem, ConStatus)" 
	sql = sql & " Values ("
	sql = sql & "" & intCodContato & ","
	sql = sql & "'" & strNome & "',"
	sql = sql & "'" & strEmail & "',"
	sql = sql & "'" & strFone & "',"
	sql = sql & "'" & strData & "',"
	sql = sql & "'" & strAssuntoSite & "',"
	sql = sql & "'" & strMsg & "',"
	sql = sql & "'" & strStatus & "')"
	
	cnn.execute sql

	if err.number = 0 then
		%>
		<script language="JavaScript">
			alert('Mensagem enviada com sucesso, em breve entraremos em contato.\nA RS agradece o seu contato.');
			window.location='Contato.asp';
		</script>
		<%
		response.end
	else
		%>
		<script language="JavaScript">
			alert('ATENÇÂO: Contato não foi enviado, favor entrar em contato pelo telefone.');
			window.history.back();
		</script>
		<%
		response.end
	end if
%>