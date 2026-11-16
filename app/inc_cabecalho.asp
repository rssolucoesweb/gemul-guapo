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
	<div class="ml-auto d-flex">
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
		<div>
			<a href="#" data-toggle="dropdown" title="Trocar ano letivo" class="header-icon d-flex align-items-center justify-content-center" style="width:auto; padding:0 .6rem; text-decoration:none;">
				<i class="fal fa-calendar-alt mr-1"></i><strong><%=Session("strAnoLetivo")%></strong><i class="fal fa-angle-down ml-1"></i>
			</a>
			<div class="dropdown-menu dropdown-menu-animated dropdown-menu-right" style="min-width:11rem;">
				<div class="dropdown-header fw-500">Trocar ano letivo</div>
				<div class="dropdown-divider m-0"></div>
				<%for iAnoCab = 0 to ubound(vetAnosCabecalho, 2)
					intAnoCab = trim(vetAnosCabecalho(0, iAnoCab) & "")
					strPadraoCab = ""
					if trim(vetAnosCabecalho(1, iAnoCab) & "") = "S" then strPadraoCab = "<span class=""badge badge-success ml-2"">padrão</span>"
					if intAnoCab = trim(Session("strAnoLetivo") & "") then%>
				<span class="dropdown-item"><i class="fal fa-check mr-2"></i><%=intAnoCab%><%=strPadraoCab%><span class="badge badge-primary ml-2">atual</span></span>
					<%else%>
				<a class="dropdown-item" href="<%=session("urlRaizLocalSistema")%>/login/trocar-ano-letivo.asp?ano=<%=intAnoCab%>&volta=<%=Server.URLEncode(strVoltaAnoCab)%>">
					<span class="mr-4"></span><%=intAnoCab%><%=strPadraoCab%>
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