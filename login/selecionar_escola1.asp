<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel de Seleção de Escola e Módulos</title>
    <link rel="stylesheet" href="css/selecionar_escola.css"> <!-- Se tiver CSS global -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-…" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>

    <!-- Top-bar -->
    <div class="top-bar">
        <div class="logos">
			<img src="/matricula/img/logomarca-topo-guapo.png" alt="Prefeitura de Guapó">
        </div>
        <div class="actions">
			<img class="logo-cabecario" src="img/logo-login.png" alt="GEMUL">
			<a class="whatsapp-float" href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=556235872362" rel="noopener" title="Falar no WhatsApp do Suporte GEMUL" target="_blank">
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
			 41.9877 39.1208C42.4139 37.9262 42.4139 36.9036 42.285 36.6905Z" fill="white"></path></svg><span class="topo-suporte">Suporte</span></a>
			
            <a href="index.asp">Sair</a>
        </div>
    </div>

    <!-- Corpo -->
    <div class="main-content">
        <div class="school-select">
			<label for="school">Selecione sua escola:</label>
            <select id="school">
                <option value="">Digite ou selecione a escola...</option>
                <option value="escola1">Escola 1</option>
                <option value="escola2">Escola 2</option>
                <option value="escola3">Escola 3</option>
                <!-- Adicione mais escolas -->
            </select>
        </div>

        <div class="modules">
			<div class="module-card" onclick="#">
				<i class="fa-solid fa-graduation-cap icon-academico" style="font-size: 40px;"></i>
				<br>
				<span>Acadêmico</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-clipboard-list icon-matricula" style="font-size: 40px;"></i>  
				<br>
				<span>Matrícula</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-bus icon-transporte" style="font-size: 40px;"></i>  
				<br>
				<span>Transporte Escolar</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-boxes-packing icon-almoxarifado" style="font-size: 40px;"></i>  
				<br>
				<span>Almoxarifado</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-chart-bar icon-dashboard" style="font-size: 40px;"></i>  
				<br>
				<span>Dashboard</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-calendar-alt icon-planejamento" style="font-size: 40px;"></i>  
				<br>
				<span>Planejamento</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-file-circle-check icon-censo" style="font-size: 40px;"></i>  
				<br>
				<span>Censo Escolar</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-users icon-rh" style="font-size: 40px;"></i>  
				<br>
				<span>Recursos Humanos</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-futbol icon-esporte" style="font-size: 40px;"></i>  
				<br>
				<span>Esporte</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-file-alt icon-secretario" style="font-size: 40px;"></i>  
				<br>
				<span>Secretário</span>
			</div>

			<div class="module-card" onclick="#">
				<i class="fa-solid fa-shield-alt icon-seguranca" style="font-size: 40px;"></i>  
				<br>
				<span>Segurança</span>
			</div>
		</div>

    </div>
	<!-- Rodapé fixo -->
	<footer class="footer-fixed" role="contentinfo">
		<div class="footer-left">
			<span>© App GEMUL | Ano Letivo: 2026 | Usuário: SERGIO | Id: 9</span>
		</div>

		<div class="footer-right">
			<ul>
				<li class="rodape-ajuda"><a href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=556235872362" target="_blank">Ajuda</a></li>
				<li><a href="https://api.whatsapp.com/send?1=pt_BR&amp;phone=556235872362" target="_blank"><i class="fa-regular fa-circle-question"></i></a></li>
			</ul>
		</div>
	</footer>


    <!-- Script para combobox pesquisável -->
    <script>
        const select = document.getElementById('school');
        select.addEventListener('input', function() {
            const filter = this.value.toLowerCase();
            Array.from(this.options).forEach(option => {
                option.style.display = option.text.toLowerCase().includes(filter) ? '' : 'none';
            });
        });
    </script>

</body>
</html>
