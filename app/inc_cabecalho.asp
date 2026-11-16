<!-- BEGIN cabeçalho -->
<header class="page-header" role="banner">
	<!-- we need this logo when user switches to nav-function-top -->
	<div class="page-logo">
		<a href="#" class="page-logo-link press-scale-down d-flex align-items-center" data-toggle="modal" data-target="#modal-shortcut">
			<img src="img/logo.png" alt="GEMUL" aria-roledescription="logo">
			<span class="page-logo-text mr-1">GEMUL</span>
			<i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>
		</a>
	</div>
	<!-- DOC: nav menu layout change shortcut -->
	<div class="hidden-md-down dropdown-icon-menu position-relative">
		<a href="#" class="header-btn btn js-waves-off" data-action="toggle" data-class="nav-function-hidden" title="Esconder Navegação">
			<i class="ni ni-menu"></i>
		</a>
		<ul>
			<li>
				<a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-minify" title="Recolher Navegação">
					<i class="ni ni-minify-nav"></i>
				</a>
			</li>
			<li>
				<a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-fixed" title="Bloquear Navegação">
					<i class="ni ni-lock-nav"></i>
				</a>
			</li>
		</ul>
	</div>
	<!-- DOC: mobile button appears during mobile width -->
	<div class="hidden-lg-up">
		<a href="#" class="header-btn btn press-scale-down" data-action="toggle" data-class="mobile-nav-on">
			<i class="ni ni-menu"></i>
		</a>
	</div>
	<div class="search">
		<form class="app-forms hidden-xs-down" role="consultar" action="#" autocomplete="off">
			<%IF sistema_sigla = "DAS" then%>
			<h2><font color="#fff"><strong><%=session("MantenedoraWeb")%></strong></font></h2>
			<%else%>
			<h2><font color="#fff"><strong><%=session("EmpresaWeb")%></strong></font></h2>
			<font color="#fff"><%=session("EnderecoEmpresaWeb")%>, <%=session("BairroEmpresaWeb")%> - <%=session("CepEmpresaWeb")%>. <%=session("TelefoneEmpresaWeb")%></font>
			<%end if%>
			<a href="#" onclick="return false;" class="btn-danger btn-search-close js-waves-off d-none" data-action="toggle" data-class="mobile-search-on">
				<i class="fal fa-times"></i>
			</a>
		</form>
	</div>
	<style>
		/* botões do cabeçalho: ano letivo, módulos e suporte */
		.hdr-pill {
			display: inline-flex; align-items: center; gap: .45rem;
			height: 2.25rem; padding: 0 .9rem; margin-left: .5rem;
			border: 1px solid rgba(255,255,255,.45); border-radius: 1.2rem;
			color: #ffffff !important; font-size: .85rem; white-space: nowrap;
			text-decoration: none !important; background: rgba(255,255,255,.08);
			transition: background .15s, border-color .15s;
		}
		.hdr-pill:hover, .hdr-pill[aria-expanded="true"] { background: rgba(255,255,255,.2); border-color: #ffffff; }
		.page-header .hdr-pill, .page-header .hdr-pill:hover, .page-header .hdr-pill:focus, .page-header .hdr-pill:visited,
		.page-header .hdr-pill *, .page-header .hdr-pill:hover * {
			text-decoration: none !important; border-bottom: 0 !important; background-image: none !important; box-shadow: none !important;
		}
		.hdr-pill i { font-size: 1.05rem; }
		.hdr-pill svg { width: 1.15rem; height: 1.15rem; }
		.hdr-pill.hdr-whats:hover { background: #25D366; border-color: #25D366; }
		/* suporte: "Suporte" pequeno em cima e o nome embaixo */
		.hdr-sup { display: inline-flex; flex-direction: column; line-height: 1; }
		.hdr-sup small { font-size: .62rem; opacity: .85; letter-spacing: .02em; }
		.hdr-sup b { font-size: .85rem; font-weight: 600; letter-spacing: .03em; }
		.hdr-ano-menu { min-width: 13rem; }
		.hdr-ano-menu .dropdown-item { display: flex; align-items: center; }
		.hdr-ano-atual { font-weight: 600; cursor: default; background: #eef4fb; }
		.hdr-ano-espaco { display: inline-block; width: 1.4rem; }
		/* smartphones: só ícones (o ano continua visível) */
		/* abaixo de 992px o tema deixa o cabeçalho branco: botões coloridos e só ícones;
		   o nome/endereço da unidade (texto branco) some para não sobrepor o conteúdo */
		@media (max-width: 991.98px) {
			.page-header .search { display: none !important; }
			.page-header .hdr-pill { background: #1a5ea8; border-color: #1a5ea8; }
			.page-header .hdr-pill.hdr-whats { background: #25D366; border-color: #25D366; }
			.hdr-pill .hdr-txt { display: none; }
		}
		@media (max-width: 767px) {
			.hdr-pill { height: 2.1rem; min-width: 2.1rem; padding: 0 .55rem; margin-left: .3rem; gap: .3rem; justify-content: center; }
			.hdr-pill svg { width: 1.2rem; height: 1.2rem; }
			.hdr-ano-menu { min-width: 11rem; }
		}
		@media (max-width: 400px) {
			.hdr-pill { margin-left: .2rem; padding: 0 .45rem; }
			.hdr-pill .fa-angle-down { display: none; }
		}
	</style>
	<div class="ml-auto d-flex align-items-center">
		<%
		'--- Trocar ano letivo sem sair do módulo (login/trocar-ano-letivo.asp?ano=&volta=)
		vetAnosCabecalho = ""
		if trim(Session("CodGrupo") & "") <> "" and isnumeric(Session("CodGrupo") & "") then
			set rsAnoCab = Server.CreateObject("adodb.recordset")
			rsAnoCab.open "SELECT ANO_LETIVO, PADRAO FROM SEG_ANO_LETIVO WHERE COD_GRUPO = " & clng(Session("CodGrupo")) & " AND SITUACAO = 'A' ORDER BY ANO_LETIVO DESC", cnn
			if not rsAnoCab.eof then vetAnosCabecalho = rsAnoCab.getRows
			rsAnoCab.close
			set rsAnoCab = nothing
		end if
		strVoltaAnoCab = Request.ServerVariables("URL")
		if Request.ServerVariables("QUERY_STRING") <> "" then strVoltaAnoCab = strVoltaAnoCab & "?" & Request.ServerVariables("QUERY_STRING")
		if isArray(vetAnosCabecalho) then
		%>
		<div class="d-flex align-items-center">
			<a href="#" data-toggle="dropdown" title="Trocar ano letivo" style="text-decoration:none !important; text-decoration-line:none !important;" class="hdr-pill">
				<i class="fal fa-calendar-alt"></i>
				<span class="hdr-txt">Ano letivo</span><strong><%=Session("strAnoLetivo")%></strong>
				<i class="fal fa-angle-down"></i>
			</a>
			<div class="dropdown-menu dropdown-menu-animated dropdown-menu-right hdr-ano-menu">
				<div class="dropdown-header fw-500">Trocar ano letivo</div>
				<div class="dropdown-divider m-0"></div>
				<%for iAnoCab = 0 to ubound(vetAnosCabecalho, 2)
					intAnoCab = trim(vetAnosCabecalho(0, iAnoCab) & "")
					strPadraoCab = ""
					if trim(vetAnosCabecalho(1, iAnoCab) & "") = "S" then strPadraoCab = "<span class=""badge badge-success ml-2"">padrão</span>"
					if intAnoCab = trim(Session("strAnoLetivo") & "") then%>
				<span class="dropdown-item hdr-ano-atual"><i class="fal fa-check mr-2"></i><%=intAnoCab%><%=strPadraoCab%><span class="badge badge-primary ml-2">atual</span></span>
					<%else%>
				<a class="dropdown-item" href="<%=session("urlRaizLocalSistema")%>/login/trocar-ano-letivo.asp?ano=<%=intAnoCab%>&volta=<%=Server.URLEncode(strVoltaAnoCab)%>">
					<span class="hdr-ano-espaco"></span><%=intAnoCab%><%=strPadraoCab%>
				</a>
					<%end if
				next%>
			</div>
		</div>
		<%end if%>
		
		<!--#include file=inc_meus_modulos.asp-->
		
		<!--#include file=inc_mensagens.asp-->
		
		
		<!-- app user menu -->
		<div>
			<a href="#" data-toggle="dropdown" title="<%=session("strUsuarioRodapeGemul")%>" class="header-icon d-flex align-items-center justify-content-center ml-2">
				<img src="img/demo/avatars/<%=session("avatar")%>" class="profile-image rounded-circle" alt="<%=session("strUsuarioRodapeGemul")%>">
				<!-- you can also add username next to the avatar with the codes below:
				<span class="ml-1 mr-1 text-truncate text-truncate-header hidden-xs-down">Me</span>
				<i class="ni ni-chevron-down hidden-xs-down"></i> -->
			</a>
			<div class="dropdown-menu dropdown-menu-animated dropdown-lg">
				<div class="dropdown-header bg-trans-gradient d-flex flex-row py-4 rounded-top">
					<div class="d-flex flex-row align-items-center mt-1 mb-1 color-white">
						<span class="mr-2">
							<img src="img/demo/avatars/<%=session("avatar")%>" class="rounded-circle profile-image" alt="<%=session("strUsuarioRodapeGemul")%>">
						</span>
						<div class="info-card-text">
							<div class="fs-lg text-truncate text-truncate-lg"><%=session("strUsuarioRodapeGemul")%></div>
							<!--span class="text-truncate text-truncate-md opacity-80">drlantern@gotbootstrap.com</span-->
						</div>
					</div>
				</div>
				<div class="dropdown-divider m-0"></div>
				
				<a href="alterar_senha.asp" class="dropdown-item">
					<span data-i18n="drpdwn.settings">Alterar senha</span>
				</a>
				<a href="seg_cor_layout.asp" class="dropdown-item">
					<span data-i18n="drpdwn.settings">Cor do layout</span>
				</a>
				<div class="dropdown-divider m-0"></div>
				<a href="#" class="dropdown-item" data-action="app-fullscreen">
					<span data-i18n="drpdwn.fullscreen">Tela Cheia</span>
					<i class="float-right text-muted fw-n">F11</i>
				</a>
				<a href="#" class="dropdown-item" data-action="app-print">
					<span data-i18n="drpdwn.print">Imprimir</span>
					<i class="float-right text-muted fw-n">Ctrl + P</i>
				</a>
				<div class="dropdown-divider m-0"></div>
				<a class="dropdown-item fw-500 pt-3 pb-3" href="/sistema/default.asp">
					<span data-i18n="drpdwn.page-logout">Sair do módulo</span>
				</a>
			</div>
		</div>
	</div>
</header>
<!-- END cabeçalho -->