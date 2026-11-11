<!-- INICIO menu rápido -->

<%
caminhoSelecionar = session("urlRaizLocalSistema") & "/login/selecionar_escola.asp"
%>

<nav class="shortcut-menu hidden-sm-down">
	<input type="checkbox" class="menu-open" name="menu-open" id="menu_open" />
	<label for="menu_open" class="menu-open-button ">
		<span class="app-shortcut-icon d-block"></span>
	</label>
	<a href="#" class="menu-item btn" data-toggle="tooltip" data-placement="left" title="Ir para o topo da página">
		<i class="fal fa-arrow-up"></i>
	</a>
	<a href="<%=caminhoSelecionar%>" class="menu-item btn" data-toggle="tooltip" data-placement="left" title="Sair do módulo">
		<i class="fal fa-sign-out"></i>
	</a>
	<a href="<%=pagina_atual%>" class="menu-item btn" data-toggle="tooltip" data-placement="left" title="Voltar tela">
		<i class="fal fa-arrow-from-right"></i>
	</a>
	<a href="#" class="menu-item btn" data-action="app-fullscreen" data-toggle="tooltip" data-placement="left" title="Tela cheia">
		<i class="fal fa-expand"></i>
	</a>
	<a href="#" class="menu-item btn" data-action="app-print" data-toggle="tooltip" data-placement="left" title="Imprimir página">
		<i class="fal fa-print"></i>
	</a>
</nav>
<!-- FIM menu rápido -->