<!--#include file="config.asp"-->
<body>
    <!--#include file="topoMenu.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Esqueceu sua senha?</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="default.asp">Home</a></li>
                <li class="active">Senha</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <!--=== Content Part ===-->
    <div class="container content">
      <strong>Dados do Usuário para reenvio de senha somente do sistema Acadêmico </strong><br>
      A sua senha será enviada para o seu endereço de e-mail. Caso você não visualize o e-mail na sua caixa de entrada, verifique a sua caixa de <strong>SPAM</strong>, e não se esqueça de adicionar o nosso e-mail na a lista de e-mails seguros do seu provedor de e-mail. <br>
      Digite o endereço de e-mail que usou quando se cadastrou no Recursos Humanos. Em seguida, enviaremos sua senha para seu e-mail para que você possa realizar uma alteração.<br>
      <form  id="frm" name="frm" method="post">
        <br>
        <label>CPF <span class="color-red">*</span></label>
        <div class="row margin-bottom-20">
            <div class="col-md-7">
                <input name="txtcpf" id="txtcpf" type="text" class="form-control">
            </div>
        </div>
        <label>Matricula <span class="color-red">*</span></label>
        <div class="row margin-bottom-20">
            <div class="col-md-7 col-md-offset-0">
                <input name="txtCodigoFuncional" id="txtCodigoFuncional" type="text" class="form-control">
            </div>
        </div>
        <label>Data Nascimento <span class="color-red">*</span></label>
        <div class="row margin-bottom-20">
            <div class="col-md-7 col-md-offset-0">
                <input name="txtDataNascimento" id="txtDataNascimento" type="text" class="form-control">
            </div>
        </div>
        <label>Email <span class="color-red">*</span></label>
        <div class="row margin-bottom-20">
            <div class="col-md-7 col-md-offset-0">
                <input name="txtemail" id="txtemail" type="text" class="form-control">
            </div>
        </div>
        <p><button type="button" onClick="Enviar()" class="btn-u">Enviar</button></p>
    </form>
</div><!--/container-->
<!--=== End Content Part ===-->
<!--#include file="rodape.asp"-->
<!--#include file="js.asp"-->
<script>
	function Enviar() {
		
		if (document.getElementById("txtcpf").value == "") {
			alert("O CPF deve ser informado!");
			document.getElementById("txtcpf").focus();
			return false;
		}
		
		if (document.getElementById("txtCodigoFuncional").value == "") {
			alert("O Codigo Funcional deve ser informado!");
			document.getElementById("txtCodigoFuncional").focus();
			return false;
		}
		
		if (document.getElementById("txtDataNascimento").value == "") {
			alert("A Data Nascimento deve ser informada!");
			document.getElementById("txtDataNascimento").focus();
			return false;
		}
		
		if (document.getElementById("txtemail").value == "") {
			alert("O Seu E-mail deve ser informado!");
			document.getElementById("txtemail").focus();
			return false;
		}
	
		document.getElementById("frm").action="EsqueciSenha_cod.asp";
		document.getElementById("frm").submit();
	
	} 
</script>
</body>
</html>
