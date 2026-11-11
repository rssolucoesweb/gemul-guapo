<!-- BEGIN Left Aside -->
<aside class="page-sidebar">
	<div class="page-logo">
		<a href="#" class="page-logo-link press-scale-down d-flex align-items-center" data-toggle="modal" data-target="#modal-shortcut">
			<img src="img/logo.png" alt="SmartAdmin WebApp" aria-roledescription="logo">
			<span class="page-logo-text mr-1">GEMUL - Portal do Aluno</span>
			<i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>
		</a>
	</div>
	<!-- BEGIN PRIMARY NAVIGATION -->
	<nav id="js-primary-nav" class="primary-nav" role="navigation">
		<div class="nav-filter">
			<div class="position-relative">
				<input type="text" id="nav_filter_input" placeholder="Filter menu" class="form-control" tabindex="0">
				<a href="#" onclick="return false;" class="btn-primary btn-search-close js-waves-off" data-action="toggle" data-class="list-filter-active" data-target=".page-sidebar">
					<i class="fal fa-chevron-up"></i>
				</a>
			</div>
		</div>
		<div class="info-card">
			<img src="<%=session("strFotoAluno")%>" class="profile-image rounded-circle" alt="<%=Session("NomeAluno_GemulEad")%>">
			<div class="info-card-text">
				<a href="#" class="d-flex align-items-center text-white">
					<span class="text-truncate text-truncate-sm d-inline-block">
						<%=Session("NomeAluno_GemulEad")%>
					</span>
				</a>
				<span class="d-inline-block text-truncate text-truncate-sm"><%=Session("Turma_GemulEad")%></span>
			</div>
			<img src="img/card-backgrounds/fundo_menu.png" class="cover" alt="cover">
		</div>
		<ul id="js-nav-menu" class="nav-menu">
			<li <%=item_ativo_painel%>>
				<a href="painel.asp" title="Painel" data-filter-tags="Painel">
					<i class="fal fa-home"></i>
					<span class="nav-link-text" data-i18n="nav.application_intel">Painel</span>
				</a>
			</li>
			
			<li <%=item_ativo_unidade%>>
				<a href="unidade.asp" title="Unidade" data-filter-tags="Unidade">
					<i class="fal fa-credit-card-front"></i>
					<span class="nav-link-text" data-i18n="nav.package_info">Dados da Unidade</span>
				</a>
			</li>
			<li <%=item_ativo_ficha%>>
				<a href="ficha_aluno_rel.asp" title="Ficha" data-filter-tags="Ficha">
					<i class="fal fa-address-card"></i>
					<span class="nav-link-text" data-i18n="nav.package_info">Ficha do Aluno</span>
				</a>
			</li>
			<li <%=item_ativo_calendario%>>
				<a href="calendario_ue.asp" title="Calendário" data-filter-tags="Calendário">
					<i class="fal fa-calendar-alt"></i>
					<span class="nav-link-text" data-i18n="nav.application_intel">Calendário</span>
				</a>
			</li>
			<%'if Session("Curso_GemulEad") = "EDUCAÇÃO INFANTIL" then%>
			<li <%=item_ativo_ficha_descritiva%>>
				<a href="fichas.asp" title="Fichas" data-filter-tags="Fichas">
					<i class="fal fa-address-card"></i>
					<span class="nav-link-text" data-i18n="nav.package_info">Ficha descritiva</span>
				</a>
			</li>
			<%'end if%>
			<li <%=item_ativo_nota%>>
				<a href="notas.asp" title="Notas" data-filter-tags="Notas">
					<i class="ni ni-bag"></i>
					<span class="nav-link-text" data-i18n="nav.package_info">Notas e faltas</span>
				</a>
			</li>
			
			<li class="nav-title">Ferramentas</li>
			<!--
			<li <%=item_ativo_mensagem%>>
				<a href="mensagem.asp" title="Utilities" data-filter-tags="utilities">
					<i class="fal fa-comments"></i>
					<span class="nav-link-text" data-i18n="nav.utilities">Mensagens</span>
				</a>
			</li>
			-->
			<li <%=item_ativo_lembrete%>>
				<a href="lembrete.asp" title="Utilities" data-filter-tags="utilities">
					<i class="fal fa-tag"></i>
					<span class="nav-link-text" data-i18n="nav.utilities">Lembretes</span>
				</a>
			</li>
		</ul>
		<div class="filter-message js-filter-message bg-success-600"></div>
	</nav>
	<!-- END PRIMARY NAVIGATION -->
</aside>
<!-- END Left Aside -->