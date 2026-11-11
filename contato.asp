<!--#include file="config.asp"-->
<body>
    <!--#include file="topoMenu.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Contato</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="default.asp">Home</a></li>
                <li class="active">Contato</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <!--=== Content Part ===-->
    <!--#include file="includes/inc_formataData.asp"-->
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
	
		strData 	  =  formataDataAP(date)  & " " & time 
		strDadosEmail = "<html>"
		strDadosEmail = strDadosEmail & "<head>"
		strDadosEmail = strDadosEmail & "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />"
		strDadosEmail = strDadosEmail & "<title>Email pelo Site</title>"
		strDadosEmail = strDadosEmail & "</head>"
		strDadosEmail = strDadosEmail & "<body>"
		strDadosEmail = strDadosEmail & "<strong>***Contato pelo Site</strong><br>"
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
		
		set mail = server.createobject("persits.mailsender")
		
		mail.host = "smtp-web.uni5.net"

		mail.fromname = "Gemul - Site"

		mail.from = "contato@gemulcanedo.com.br " 'Este email deve ser válido e existir como conta de email para o domínio

		mail.addaddress "contato@gemulcanedo.com.br" , "Contato do site"
		
		mail.AddReplyTo strEmail ' Email de Resposta

		mail.subject = strAssuntoSite

		mail.body = strDadosEmail
	
		mail.IsHTML = true
		
		'Enviando o email
		mail.send
				
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
		
		Set mail = nothing
		
		if trim(strEnvioEmail) = "OK" then
			%>
			<script language="JavaScript">
				alert('Mensagem enviada com sucesso, em breve entraremos em contato.\nA Asced agradece o seu contato.');
				window.location = 'Contato.asp';		
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
    <div class="container content">
    	<div class="row margin-bottom-30">
    		<div class="col-md-9 mb-margin-bottom-30">
                <div class="headline"><h2>Contato</h2></div>
                <p>
                Perguntas, Dúvidas e Sugestões, por favor preencha o formulário abaixo que em breve entraremos em contato para maiores informações.
                </p><br />
    			<form method="post" id="frm1">
                    <label>Name</label>
                    <div class="row margin-bottom-20">
                        <div class="col-md-7 col-md-offset-0">
                            <input name='txtNome'  class="form-control" type='text' id="txtNome" value='<%=strNome%>' size='50' maxlength='50' />
                        </div>
                    </div>
                    <label>Email <span class="color-red">*</span></label>
                    <div class="row margin-bottom-20">
                        <div class="col-md-7 col-md-offset-0">
                            <input name='txtEmail'  class="form-control" type='text' id="txtEmail" value='<%=strEmail%>' size='50' maxlength='50' />
                        </div>
                    </div>
                    <label>Telefone <span class="color-red">*</span></label>
                    <div class="row margin-bottom-20">
                        <div class="col-md-7 col-md-offset-0">
                            <input name="txtFone" type="text" class="form-control" id="txtFone" size="15" value="<%=strFone%>" onkeypress="mascara(this,telefone)"  maxlength="15" />
                        </div>
                    </div>
                   
                    <label>Assunto <span class="color-red">*</span></label>
                    <div class="row margin-bottom-20">
                        <div class="col-md-7 col-md-offset-0">
                            <input name='txtAssunto' class="form-control" type='text' id="txtAssunto" value='<%=strAssunto%>' size='50' maxlength='30' />
                        </div>
                    </div>
                    
                    <label>Message</label>
                    <div class="row margin-bottom-20">
                        <div class="col-md-11 col-md-offset-0">
                            <textarea name="txtMensagem" class="form-control" cols="50" rows="8"id="txtMensagem"></textarea>
                        </div>
                    </div>
                    <p><button type="submit" class="btn-u" onclick="return salvar('I')" >Enviar</button></p>

                </form>
            </div><!--/col-md-9-->
    		<div class="col-md-3">
            	<!-- Contacts -->
                <div class="headline"><h2>Contato</h2></div>
                <ul class="list-unstyled who margin-bottom-30">
                    <!--/<li><a href="#"><i class="fa fa-home"></i>Av. Rio Verde, nº 123, Cidade Empresarial, Goiânia -GO</a></li>-->
                    <li><a href="#"><i class="fa fa-envelope"></i>suporte@gemul.com.br</a></li>
                    <li><a href="#"><i class="fa fa-phone"></i>(62) 3587-2362</a></li>
                    <li><a href="#"><i class="fa fa-globe"></i>http://www.gemul.com.br/</a></li>
                </ul>
            	<!-- Business Hours -->
                <div class="headline"><h2>Horário</h2></div>
                <ul class="list-unstyled margin-bottom-30">
                	<li><strong>Segunda a Sexta Feira</strong>  </li>
                	<li>Das 08:00 às 17:00 horas</li>
                </ul>
            </div><!--/col-md-3-->
        </div><!--/row-->
    </div><!--/container-->
    <!--=== End Content Part ===-->
    <!--=== End Content Part ===-->
   	<!--#include file="rodape.asp"-->
	<!--#include file="js.asp"-->
</body>
</html>
