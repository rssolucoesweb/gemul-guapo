<!-- BEGIN Page Header -->
<header class="page-header" role="banner">
	<!-- we need this logo when user switches to nav-function-top -->
	<div class="page-logo">
		<a href="#" class="page-logo-link press-scale-down d-flex align-items-center" data-toggle="modal" data-target="#modal-shortcut">
			<img src="img/logo.png" alt="SmartAdmin WebApp" aria-roledescription="logo">
			<span class="page-logo-text mr-1">GEMUL - Portal do Aluno</span>
			<i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>
		</a>
	</div>
	<!-- DOC: nav menu layout change shortcut -->
	<div class="hidden-md-down dropdown-icon-menu position-relative">
		<a href="#" class="header-btn btn js-waves-off" data-action="toggle" data-class="nav-function-hidden" title="Hide Navigation">
			<i class="ni ni-menu"></i>
		</a>
		<ul>
			<li>
				<a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-minify" title="Minify Navigation">
					<i class="ni ni-minify-nav"></i>
				</a>
			</li>
			<li>
				<a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-fixed" title="Lock Navigation">
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
		<form class="app-forms hidden-xs-down" role="search" action="#" autocomplete="off">
			
			<a href="#" onclick="return false;" class="btn-danger btn-search-close js-waves-off d-none" data-action="toggle" data-class="mobile-search-on">
				<i class="fal fa-times"></i>
				
			</a>
			<div class="m-0 fw-500 d-flex">
				<div class="flex-1 fs-xxl text-contrast"><%=Session("EmpresaAluno_GemulEad")%></div>
			</div>
		</form>
	</div>
	<div class="ml-auto d-flex">
		
		<%
		novas=0
		sql = "select count(*) as quant "
		sql = sql & " from EAD_MENSAGEM "
		sql = sql & " where cod_aluno = " & Session("CodAluno_GemulEad")
		SQL = SQL & " and situacao = 'E' and usuario_incl_aluno is null"
		rs.open sql, cnn
		if not rs.eof then
			novas = rs("quant")
		end if
		rs.close
		
		%>
		
		<!-- app notification -->
		<div>
			<a href="#" class="header-icon" data-toggle="dropdown" title="0 Notificações">
				<i class="fal fa-bell"></i>
				<span class="badge badge-icon"><%=novas%></span>
			</a>
			<div class="dropdown-menu dropdown-menu-animated dropdown-xl">
				<div class="dropdown-header bg-trans-gradient d-flex justify-content-center align-items-center rounded-top mb-2">
					<h4 class="m-0 text-center color-white">
						<%=novas%> Novas
						<small class="mb-0 opacity-80">Mensagens</small>
					</h4>
				</div>
				<ul class="nav nav-tabs nav-tabs-clean" role="tablist">
					<li class="nav-item ative">
						<a class="nav-link px-4 fs-md js-waves-on fw-500" data-toggle="tab" href="#tab-messages" data-i18n="drpdwn.messages">Mensagens</a>
					</li>
				</ul>
				<div class="tab-content tab-notification">
					<div class="tab-pane" id="tab-messages" role="tabpanel">
						<div class="custom-scroll h-100">
							<ul class="notification">
								<%
								SQL = "select m.ASSUNTO, m.DESCRICAO, c.nome, m.cod_mensagem, m.usuario_incl_colaborador, c.sexo, "
								SQL = SQL & " case when c.nome is null then a.nomealuno else SUBSTRING(C.NOME, 0, CHARINDEX(' ', C.NOME)) + ' ' +  REVERSE(SUBSTRING(REVERSE(C.NOME), 0, CHARINDEX(' ', REVERSE(C.NOME)))) end as enviado, m.data_hora_incl"
								SQL = SQL & " from EAD_MENSAGEM m "
								SQL = SQL & " left join srh_colaborador c on c.codigo = m.usuario_incl_colaborador"
								SQL = SQL & " left join sca_aluno a on a.codigo = m.usuario_incl_aluno"
								SQL = SQL & " WHERE m.cod_aluno=" & Session("CodAluno_GemulEad")
								SQL = SQL & " and m.situacao = 'E' and m.usuario_incl_aluno is null"
								SQL = SQL & " ORDER BY DESCRICAO"
								RS.OPEN SQL, CNN
								IF RS.EOF = FALSE THEN
									while not rs.eof
										cont = cont + 1
										if trim(rs("sexo")) = "F" then 
											imagem = "professora.png"
										else
											imagem = "professor.png"
										end if
										
										%>
										<li>
											<a href="mensagem_ler.asp?id=<%=rs("cod_mensagem")%>&c=<%=rs("usuario_incl_colaborador")%>" class="d-flex align-items-center">
												<span class="status mr-2">
													<span class="profile-image rounded-circle d-inline-block" style="background-image:url('img/<%=imagem%>')"></span>
												</span>
												<span class="d-flex flex-column flex-1 ml-1">
													<span class="name"><%=rs("enviado")%> </span>
													<span class="msg-a fs-sm"><%=rs("assunto")%></span>
													<span class="msg-b fs-xs"><%=left(rs("descricao"),30)%>...</span>
													<span class="fs-nano text-muted mt-1"><%=rs("data_hora_incl")%></span>
												</span>
											</a>
										</li>
										
										<%
								
										rs.movenext
									wend
								END IF
								rs.close
								%>
								
							</ul>
						</div>
					</div>
				</div>
				<div class="py-2 px-3 bg-faded d-block rounded-bottom text-right border-faded border-bottom-0 border-right-0 border-left-0">
					<a href="mensagem.asp" class="fs-xs fw-500 ml-auto">ver todas mensagens</a>
				</div>
			</div>
		</div>
		<!-- app user menu -->
		<div>
			<a href="#" data-toggle="dropdown" title="drlantern@gotbootstrap.com" class="header-icon d-flex align-items-center justify-content-center ml-2">
				<img src="img/aluno.png" class="profile-image rounded-circle" alt="<%=Session("NomeAluno_GemulEad")%>">
			</a>
			<div class="dropdown-menu dropdown-menu-animated dropdown-lg">
				<div class="dropdown-header bg-trans-gradient d-flex flex-row py-4 rounded-top">
					<div class="d-flex flex-row align-items-center mt-1 mb-1 color-white">
						<span class="mr-2">
							<img src="img/aluno.png" class="rounded-circle profile-image" alt="Sérgio">
						</span>
						<div class="info-card-text">
							<div class="fs-lg text-truncate text-truncate-lg"><%=Session("NomeAluno_GemulEad")%></div>
							<span class="text-truncate text-truncate-md opacity-80"><%=Session("Turma_GemulEad")%></span>
						</div>
					</div>
				</div>
				<div class="dropdown-divider m-0"></div>
				<a href="unidade.asp" class="dropdown-item">
					<i class="fal fa-credit-card-front"></i>
					<span >Dados da Unidade</span>
				</a>
				<div class="dropdown-divider m-0"></div>
				<a class="dropdown-item fw-500 pt-3 pb-3" href="login.asp">
					<i class="fal fa-exit"></i>
					<span data-i18n="drpdwn.page-logout">Sair</span>
				</a>
			</div>
		</div>
	</div>
</header>
<!-- END Page Header -->