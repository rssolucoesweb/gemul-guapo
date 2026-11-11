<%
	'Configuração regional do Brasil
	session.LCID = 1046

	'Armazena o caminho da raiz do banco
	session("Titulo") = "GEMUL - Gestor de Município"
%>
<!--#include file="config.asp"-->
<body>
    <!--#include file="topoMenu.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Login</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="default.asp">Home</a></li>
                <li class="active">Login</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <!--=== Content Part ===-->
	<%
		'Apaga todas as sessions
		session.Contents.removeAll()
		'limpa sessions
		Session("caminhoLogomarcaEmpresa")  = ""
		session("EmpresaWeb")				= ""
		session("MantenedoraWeb")			= ""
		session("EmpresaWebCNPJ")			= ""
		session("EnderecoEmpresaWeb")		= ""
		session("CidadeEmpresaWeb")			= ""
		session("BairroEmpresaWeb")			= ""
		session("UFEmpresaWeb")				= ""
		session("CepEmpresaWeb")			= ""
		session("TelefoneEmpresaWeb")		= ""
		session("NomeDiretorEmpresaWeb")	= ""
		session("NomeSecretariaEmpresaWeb")	= ""
		Session("UsuarioSenha")				= ""
		Session("CodDeptoUsuario")			= ""
		Session("DescDeptoUsuario")			= ""
		Session("strAnoLetivo")				= ""
		Session("strSemestre")				= ""
		Session("strTodosSemestre") 		= ""
		Session("strDescSemestre") 			= ""
		Session("strMesEncerramentoPrimeiroSemestre")	= ""
		Session("strMesEncerramentoSegundoSemestre")	= ""
		Session("strChecarFinanceiro")					= ""
		Session("strNomeGrupo") = ""
		Session("CodTodasEmpresaGrupo") = ""
		Session("UsuarioWeb") 		= ""
		Session("PerfilUsuario")  	= ""
		Session("Aluno")  			= ""
		Session("CodSeguranca")     = ""
		
		if request("a")<> "novo" then
%>
<!--script>
	//alert("Sistema temporariamente indisponível.\nEstamos trabalhando para normalizar.\nPedimos desculpas pelo transtorno.");
	//window.location='default.asp'
</script-->
<%
	end if
	%>
    <div class="container content">
    	<div class="row">
            <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3">
                <form method="post" name="frm" id="frm" class="reg-page">
                    <div class="reg-header">
                        <h2>Acesso ao Portal</h2>
                   
                    <%      
                    if trim(request.ServerVariables("SERVER_NAME")) = "www.smeduc.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "smeduc.com.br" then%>
                       <p><strong><font color="#FF0000">Aviso importante:</font></strong> Novo endereço do <strong>GEMUL de Abadia</strong> já está disponível <strong><a href="http://www.gemul-abadia.com.br/login.asp">http://www.gemul-abadia.com.br</a></strong> e a partir do dia <strong>25/08</strong> o <strong>www.smeduc.com.br</strong> será desativado!</p>     
                    <%
                    end if
                    if trim(request.ServerVariables("SERVER_NAME")) = "www.gemul.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul.com.br" then%>
                       <p><strong><font color="#FF0000">Aviso importante:</font></strong><br> Novo endereço do <strong>GEMUL de Aparecida</strong> já está disponível <strong><a href="http://www.gemul-aparecida.com.br/login.asp">http://www.gemul-aparecida.com.br</a></strong></p>     
                    <%
                    end if
					%>
                     </div>
                    <div class="input-group margin-bottom-20">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <input name="txtLogin" type="text" placeholder="Username" class="form-control" id="txtLogin" value="<%=request.cookies("usuarioLoginSisge")%>" size="20" maxlength="40" />
                    </div>
                    <div class="input-group margin-bottom-20">
                        <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                        <input name="txtSenha" placeholder="Password" type="password" class="form-control" id="txtSenha" size="10" maxlength="30" />
                    </div>
                    <div class="row">
                        <div class="col-md-6 checkbox">
                        </div>
                        <div class="col-md-6">
                            <a  href="#" onclick="return validaCampo()"  class="btn-u pull-right">Login</a>  
                        </div>
                    </div>
                    <hr>
                    <h4> Esqueceu sua senha?</h4>
                    <p>N&atilde;o se preocupe, <a class="color-green" href="esqueciSenha.asp">clique aqui</a> para redefinir sua senha.</p>
                    <hr>
					<%      
                    if trim(request.ServerVariables("SERVER_NAME")) = "www.smeduc.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "smeduc.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul-abadia.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "www.gemul-abadia.com.br" then%>
                            <h4> Deseja limpar o  cache do seu navegador?</h4>
                            <p><a class="color-green" href="http://www.gemul.com.br/limparcachesmeduc.pdf" target="_blank">Clique aqui</a> para acessa o passo a passo em pdf.</p>
                        </form>
                    <%
                    end if
                    if trim(request.ServerVariables("SERVER_NAME")) = "www.gemul-aparecida.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul-aparecida.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "www.gemul.com.br" or trim(request.ServerVariables("SERVER_NAME")) = "gemul.com.br" then%>
                            <h4> Deseja limpar o  cache do seu navegador?</h4>
                            <p><a class="color-green" href="http://www.gemul.com.br/limparcachegemul.pdf" target="_blank">Clique aqui</a> para acessa o passo a passo em pdf.</p>
                        </form>
                    <%
                    end if                    
                    %>                    
            </div>
        </div><!--/row-->
    </div><!--/container-->
    <!--=== End Content Part ===-->
    <script language="JavaScript">
	
	function verificaTecla(){
		if (window.event.keyCode==13)
			return validaCampo()
	}
	
	function isNumeric(valor)
	{
		validChar = '0123456789.,-';
		for(var i=0;i<valor.length;i++)
			if(validChar.indexOf(valor.substr(i,1))<0)
				return false;
		return true;
	}
	
	function validaCampo(){
		
		var frm = document.getElementById("frm");
		var login = frm.txtLogin.value.replace(/\./g,"");
		var senha = frm.txtSenha.value.replace(/\./g,"");
		
		login = login.replace(/\-/g,"");
		senha = senha.replace(/\-/g,""); 
		
		if (login == ""){
			alert("O usuário deve ser informado");
			frm.txtLogin.focus();
			return false;
		}
		
		if (senha == ""){
			alert("O Senha deve ser informada");
			frm.txtSenha.focus();
			return false;
		}
		
		//if (isNumeric(login))
		//	frm.action = "gemul/portal/validaPermissao.asp";
		//else
		
		frm.action = "validaUsuario.asp";
		
		frm.submit();
		
	}
	</script>
   	<!--#include file="rodape.asp"-->
	<!--#include file="js.asp"-->
</body>
</html>
