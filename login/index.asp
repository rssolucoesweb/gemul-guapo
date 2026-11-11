<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – GEMUL - Sistema de Gestão Educacional</title>
    <link rel="stylesheet" href="css/styles.css">
	<style>
		.password-wrapper {
		position: relative;
		display: flex;
		align-items: center;
	}

	.password-wrapper input {
		width: 100%;
		padding-right: 35px;
	}

	.password-wrapper .eye {
		position: absolute;
		right: 10px;
		cursor: pointer;
		user-select: none;
	}
	</style>
</head>
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
		
		frm.action = "validaUsuario.asp";
		
		frm.submit();
		
	}

	</script>
		
	<script>
	window.onload = function () {
		const input = document.getElementById("txtSenha");
		const eye = document.getElementById("toggleEye");

		eye.addEventListener("click", () => {
			const isPassword = input.type === "password";
			input.type = isPassword ? "text" : "password";

			// troca o ícone
			eye.textContent = isPassword ? "👀" : "👁";
		});
	};
	</script>


<body>


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
		session("Titulo") = "GEMUL - Sistema de Gestão Educacional."
		
		if request("a")<> "novo" then
			%>
			<!--script>
				//alert("Sistema temporariamente indisponível.\nEstamos trabalhando para normalizar.\nPedimos desculpas pelo transtorno.");
				//window.location='default.asp'
			</script-->
			<%
		end if
		
		%>

<div class="container">

    <!-- LADO ESQUERDO -------------------------------------------------------->
    <div class="left">
        <div class="left-content">
            <h2>Secretaria Municipal de<br><strong>Educação</strong></h2>

            <div class="logo">
                <img src="/matricula/img/logomarca-topo-guapo.png" alt="Prefeitura de Guapó">
            </div>
        </div>
    </div>

    <!-- LADO DIREITO --------------------------------------------------------->
    <div class="right">
		
        <div class="login-box">
			
            <h1>Bem-Vindo!</h1>
            <p class="subtitle">GEMUL - Sistema de Gestão Educacional.</p>
            <form method="post" name="frm" id="frm">
                <div class="step">
                    <span class="active">1</span> Informe usuário e senha
                </div>

                <label>Usuário *</label>
                <input name="txtLogin" id="txtLogin" type="text" value="<%=request.cookies("usuarioLoginGEMUL")%>" placeholder="Digite seu usuário">

                <label>Senha *</label>
				<div class="password-wrapper">
					<input name="txtSenha" id="txtSenha" type="password" placeholder="Digite sua senha">
					<span class="eye" id="toggleEye">👁</span>
				</div>


                <a href="esqueci-senha.asp" class="forgot">Esqueci minha senha</a>

                <button onclick="return validaCampo()"  class="btn">Acessar →</button>
            </form>

            <p class="login-rodape">
				<img class="logo-rodape" src="img/logo-login.png" alt="GEMUL">
				<a href="pdf/passo_a_passo_cache_GEMUL.pdf" target="_blank" 
				   style="text-decoration: none; color: inherit; display: inline-flex; align-items: center; gap: 6px;">
					
					<!-- Ícone PDF -->
					<svg width="30" height="30" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
						<rect x="4" y="4" width="56" height="56" rx="6" ry="6" fill="#E53E3E"/>
						<text x="32" y="38" font-family="Arial, sans-serif" font-size="18" font-weight="bold" text-anchor="middle" fill="white">
							PDF
						</text>
					</svg>
					
					<!-- Texto -->
					<span style="line-height: 12px; display: inline-block;">
						<strong style="font-size: 10px;">Passo a passo<br>limpar cache</strong>
					</span>
				</a>
				
				<a class="whatsapp-float" href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=5562996692821" rel="noopener" title="Falar no WhatsApp da Secretaria de Educação e Cultura" target="_blank">
				<svg width="30" height="30" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
				<circle cx="32" cy="32" r="32" fill="#25D366"></circle>
				<path d="M11.375 52.625L14.2745 42.0323C12.4853 38.9317 11.5452 35.4169 11.5469
				31.8127C11.552 20.5445 20.7216 11.375 31.988 11.375C37.4553 11.3767 42.5875 13.5062 46.4478 17.37C50.3064
				21.2337 52.4308 26.3694 52.4291 31.8316C52.4239 43.1014 43.2544 52.2709 31.988 52.2709C28.5677 52.2692 25.1972
				51.4116 22.2117 49.7822L11.375 52.625ZM22.7136 46.0817C25.5942 47.7919 28.3442 48.8162 31.9811 48.818C41.3448 48.818
				48.9727 41.197 48.9778 31.8281C48.9813 22.4403 41.3895 14.8297 31.9948 14.8262C22.6242 14.8262 15.0016 22.4472 14.9981
				31.8144C14.9964 35.6386 16.117 38.502 17.9991 41.4978L16.282 47.7678L22.7136 46.0817ZM42.285 36.6905C42.1578 36.4773
				 41.8175 36.3502 41.3053 36.0941C40.7948 35.838 38.2837 34.6022 37.8145 34.432C37.347 34.2619 37.0067 34.1759 36.6647
				 34.6881C36.3244 35.1986 35.3447 36.3502 35.0473 36.6905C34.75 37.0308 34.4509 37.0738 33.9405 36.8177C33.43 36.5616 31.7834
				 36.0236 29.8327 34.2825C28.315 32.9281 27.2889 31.2558 26.9916 30.7436C26.6942 30.2331 26.9606 29.9564 27.215
				 29.702C27.4453 29.4734 27.7255 29.1056 27.9816 28.8066C28.2411 28.5109 28.3253 28.2978 28.4972 27.9558C28.6673
				 27.6155 28.5831 27.3164 28.4542 27.0603C28.3253 26.8059 27.3044 24.2914 26.8798 23.2688C26.4639 22.2736 26.0428
				 22.4077 25.73 22.3922L24.7503 22.375C24.41 22.375 23.8566 22.5022 23.3891 23.0144C22.9216 23.5266 21.6016 24.7606
				 21.6016 27.2752C21.6016 29.7897 23.432 32.2183 23.6864 32.5586C23.9425 32.8989 27.2872 38.0586 32.4108 40.2706C33.6294
				 40.7966 34.5816 41.1111 35.3223 41.3466C36.5461 41.735 37.6598 41.68 38.5398 41.5494C39.5212 41.4033 41.5614 40.3136
				 41.9877 39.1208C42.4139 37.9262 42.4139 36.9036 42.285 36.6905Z" fill="white"></path></svg>SEMED</a>
            </p>
        </div>

    </div>

</div>

</body>
</html>
