<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Responde o e-mail
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<title><%=session("Titulo")%></title>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
<script>

	function salvar(){		
		
		var frm = document.getElementById("frm");
		
		if (frm.txtOrigem.value == "") {
			alert("O E-mail de Origem deve ser informado!");
			frm.txtOrigem.focus();
			return false;
		}
	
		if (frm.txtDestino.value == "") {
			alert("O E-mail de Destino deve ser informado!");
			frm.txtDestino.focus();
			return false;
		}
		
		if (frm.txtAssunto.value == "") {
			alert("O Assunto do e-mail deve ser informado!");
			frm.txtAssunto.focus();
			return false;
		}
		
		if (frm.txtMensagem.value == "") {
			alert("A Mensagem deve ser informada!");
			frm.txtMensagem.focus();
			return false;
		}
		
		frm.submit();
		
	}
</script>

<%	
	dim sEmailFiliado
	dim strAssunto
	dim sMsg
	dim cMail

	intCodContato 	 = Trim(Request.QueryString("intCodContato"))
	strMsg		 	 = Trim(Request.Form("txtMensagem"))
	
	if intCodContato <> "" then 
	
		sql = "Select Email, Assunto"
		sql = sql & " FROM SIT_Contatos"
		sql = sql & " Where Codigo = " &  intCodContato 
		rs.open sql, cnn
							
		if rs.eof = false then
			strOrigem  	 	= "imprensa@stiueg.org.br"
			sEmailFiliado 	= rs("Email")
			strAssunto		=  "Re: " & rs("Assunto")
		end if 
		rs.close
	end if

	' Enviar e-mail
	if strOrigem <> "" and sEmailFiliado <> "" and strAssunto <> "" and strMsg <> "" then 
		
		if not instr(sEmailFiliado,"@") > 0 then
			%>
			<script>
				alert('Email Inválido!');
				history.back(1);
			</script>
			<%
			Response.End 
		end if
		
		Set cMail = Server.CreateObject("Persits.MailSender") 
		
		'Servidor de SMTP 
		cMail.Host = "localhost" 
		
		'O endereço deve ser um e-mail existente no domínio de sua revenda.
		cMail.From = strOrigem 
		
		'Remetente 
		cMail.FromName = "Contato Site Stiueg"
		
		'Destinatario 
		cMail.AddAddress sEmailFiliado
		
		cMail.AddCC ""
		cMail.AddBcc ""
		
		'Assunto da mensagem 
		cMail.Subject = strAssunto
		
		'Corpo da mensagem 
		cMail.Body = strMsg
		cMail.IsHTML = true
				
		On Error Resume Next 
		cMail.Send 
		If Err <> 0 Then 
			Response.Write "Error encountered: " & Err.Description 
		End If 
	
		if not cMail.Send then
		%>
			<script language="JavaScript">
				alert('Ocorreu um erro ao enviar o e-mail: \n'+ '<%=err.description%>');
				window.close();
			</script>
		<%
		else
			' Altera o Status do Filiado
			sql = "Update SIT_Contatos Set"
			sql = sql & " Status = 'L'" ' L - Lido - N - Não Lido
			sql = sql & " Where Codigo = " & intCodContato
			cnn.execute sql
			
			if err.number <> 0 then
				response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
				cnn.rollbacktrans
			end if
			%>
			<script language="JavaScript">
				alert('Mensagem envaida com sucesso!!');
				window.close();
            </script>
			<%
		end if
		Set cMail = nothing
	end if
%>
        <table width="100%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="100%" class="CelulaDoCadastro" align="center" valign="top">

 <form method="post" id="frm">
<table class="TextoForm">
 
    <tr>
      <td colspan="2" align="center" class="tituloPrincipal">Responde E-mail</td>
    </tr>
    <tr> 
      <td colspan="2" class="titulo2">&nbsp;</td>
    </tr>
    <tr> 
      <td width="62"><font color="#000066">De </font></td>
      <td width="340"> <input name='txtOrigem' type='text' class="text" id="txtDe" value='<%=strOrigem%>' size='50' maxlength='50'></td>
    </tr>
    <tr> 
      <td><font color="#000066">Para</font></td>
      <td> <input name='txtDestino' type='text' id="txtPara4" class="text"  value='<%=sEmailFiliado%>' size='50' maxlen????y?©??????gth='50'></td>
    </tr>
    <tr> 
      <td><font color="#000066">Assunto :</font> </td>
      <td> <input name='txtAssunto' type='text' id="txtAssunto" class="text" value='<%=strAssunto%>' size='50' maxlength='50'></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2"><font color="#000066">Por favor, digite aqui a sua respota 
        ao filiado:</font></td>
    </tr>
    <tr> 
      <td colspan="2" align="center"><textarea name="txtMensagem" class="text" cols="60" rows="7"id="textarea2"></textarea></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2"><div align="center"> 
          <input name="cmEnviar" type='button' class='botao' id="cmEnviar2" value='Enviar' <%=strDesabilitaIncluir%> onClick="return salvar()">
          &nbsp; 
          <input name="cmdFechar" type='button' class='botao' id="cmdFechar3" onClick="window.close()" value='Fechar '>
        </div></td>
    </tr>
</table>
  </form>

                </td>
            </tr>
        </table>
