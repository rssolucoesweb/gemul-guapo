<head>
<title><%=session("Titulo")%></title>
<link href="estilo/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script src="js/js_funcoes_gerais.js"></script>
</head>
<%
strTituloPagina = "Contato..."
%>
<!--#include file="topo.asp"-->
<!--#include file="Config.asp"-->
<!--include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<script>
function salvar(acao){
		
		if (frm1.txtNome.value == "") {
			alert("O Nome deve deve ser informado !");
			frm1.txtNome.focus();
			return false;
		}
		
		if (frm1.txtEmail.value == "") {
			alert("O E-Mail deve ser informado!");
			frm1.txtEmail.focus();
			return false;
		}
		
		if (frm1.txtFone.value == "") {
			alert("O Telefone deve ser informado!");
			frm1.txtFone.focus();
			return false;
		}
		
		
		if (frm1.txtAssunto.value == "") {
			alert("O Assunto deve ser informado!");
			frm1.txtAssunto.focus();
			return false;
		}
	
		if (frm1.txtMensagem.value == "") {
			alert("A Mensagem deve ser informada!");
			frm1.txtMensagem.focus();
			return false;
		}
		frm1.submit();
 	}
</script>	
<%	
	dim sEmail
	dim strAssunto
	dim sMsg
	dim cMail
	
	strData 		 	= formataDataAP(date) 
	strNome				= Replace(Trim(Request.Form("txtNome")),"'","")
	strEmail			= Replace(Trim(Request.Form("txtEmail")),"'","")
	strFone				= Replace(Trim(Request.Form("txtFone")),"'","")
	strAssuntoSite		= Trim(Request.Form("txtAssunto"))	
	strMsg				= Replace(Trim(Request.Form("txtMensagem")),"'","")
	strStatus		    = "N" ' Não Lido

	if strEmail <> "" then
	
		strEmailDestino	 	= "gemul@mdoimoveis.com.br"
		strSiteRevenda  	= "GEMIL"
		strContatoRevenda  	= "Contato"
		strDataBD 		 	= formataDataBD(date) 
		strAssunto		 	= "Contato - " & strSiteRevenda
	
		strData 	  =  formataDataAP(date)  & " " & time 
		strDadosEmail = "<html>"
		strDadosEmail = strDadosEmail & "<head>"
		strDadosEmail = strDadosEmail & "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />"
		strDadosEmail = strDadosEmail & "<title>Email pelo site </title>"
		strDadosEmail = strDadosEmail & "</head>"
		strDadosEmail = strDadosEmail & "<body>"
		strDadosEmail = strDadosEmail & "<strong>***Contato pelo site ***</strong><br>"
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
				
		if Err <> 0 Then 
			strEnvioEmail = ""	
			%>
			<script language="JavaScript">
				alert('Ocorreu um erro ao enviar o e-mail: \n'+ '<%=err.description%>');
				window.close();
			</script>
			<%
		else
			strEnvioEmail = "OK"	
		End If 
		
		Set cMail = nothing
		
		' Grava o Contato
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
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
		
		sql = "Insert Into Contatos(Codigo, Nome, Email, "
		sql = sql & " Telefone, Data, Assunto, Mensagem, Status)" 
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

		if trim(strEnvioEmail) = "OK" then
			%>
			<script language="JavaScript">
				alert('Mensagem enviada com sucesso, em breve entraremos em contato.\nO GEMUL agradece o seu contato.');
				window.navigate('Contato.asp');		
			</script>
			<%	
		else
			%>
			<script language="JavaScript">
				alert('ATENÇÂO: Contato não foi enviado, favor entrar em contato pelo telefone.');
				window.history.back();
			</script>
			<%
			response.end
		end if
	end if
%>
<table width="900"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td width="209" height="558" align="center" bgcolor="#003366"><!--#include file="Menu.asp"--></td>
    <td width="691" align="center" bgcolor="#FFFFFF">
    <form method="post" id="frm1">
    <table width="86%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr >
        <td height="32" colspan="4" class="texto"> Perguntas, D&uacute;vidas e Sugest&otilde;es, por favor preencha o formul&aacute;rio abaixo que em breve entraremos em contato para maiores informa&ccedil;&otilde;es.
          SIND. NET , agradece desde j&aacute; a sua visita! </td>
      </tr>
      <tr >
        <td colspan="4" class="texto">&nbsp;</td>
      </tr>
      <tr >
        <td colspan="2" class="texto"><strong>Nome Completo:</strong></td>
        <td width="193" colspan="2" rowspan="10" align="center" class="texto">&nbsp;</td>
      </tr>
      <tr >
        <td height="29" colspan="2"><input name='txtNome'  class="text" type='text' id="txtNome" value='<%=strNome%>' size='50' maxlength='50'></td>
      </tr>
      <tr >
        <td colspan="2" class="texto"><strong>E-Mail:</strong></td>
      </tr>
      <tr >
        <td height="28" colspan="2"><span class="TextoForm">
          <input name='txtEmail'  class="text" type='text' id="txtEmail" value='<%=strEmail%>' size='50' maxlength='50'>
        </span></td>
      </tr>
      <tr >
        <td class="texto"><strong>Telefone:</strong></td>
        <td class="texto"><strong>Data:</strong></td>
      </tr>
      <tr >
        <td width="206" height="28"><input name="txtFone" type="text" class="text" id="txtFone" size="15" value="<%=strFone%>"  onKeyPress="mascara(this,telefone)"  maxlength="15"></td>
        <td width="323"><span class="texto">
          <input readonly name="txtData" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="14" maxlength="11">
        </span></td>
      </tr>
      <tr>
        <td colspan="2"  class="texto"><strong>Assunto :</strong></td>
      </tr>
      <tr >
        <td height="28" colspan="2"><input name='txtAssunto' class="text" type='text' id="txtAssunto" value='<%=strAssunto%>' size='50' maxlength='30'></td>
      </tr>
      <tr >
        <td height="21" colspan="2"  class="texto"><strong>Sua mensagem:</strong></td>
      </tr>
      <tr >
        <td height="75" colspan="2"><textarea name="txtMensagem" class="textMensagem" cols="50" rows="5"id="txtMensagem"></textarea></td>
      </tr>
      <tr >
        <td colspan="4"><input name="cmdSalvar" type='button' class='botao' id="cmdSalvar" value='Enviar' onClick="return salvar('I')">
          <input name="cmdLimpar" type='reset' class='botao' id="cmdLimpar" value='Limpar' onClick="window.location='Contato.asp'"></td>
      </tr>
      <tr >
        <td colspan="4">&nbsp;</td>
      </tr>
    </table>
    </form>
    
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>