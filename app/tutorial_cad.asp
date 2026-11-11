<%
	strTemAcessoRH = "N"
	SQL = "select p.PERF_CODG "
	SQL = SQL & " from SEG_PERFIS_SISTEMA p"
	SQL = SQL & " inner join SEG_ACESSOS_USUARIO a on a.ACES_PERF_CODG = p.PERF_CODG"
	SQL = SQL & " where p.PERF_SIST_SIGL='SRH'"
	SQL = SQL & " and a.ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	rs.open sql, cnn
	if not rs.EOF then	
		strTemAcessoRH = "S"
	end if
	rs.close
%>

<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>

	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-play-circle'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>

	<style type="text/css">
		.tutorial-accordion {
			margin-bottom: 20px;
		}

		.tutorial-accordion .card {
			margin-bottom: 12px;
		}

		.tutorial-accordion .card-title {
			display: flex;
			align-items: center;
			width: 100%;
			font-size: 16px;
			font-weight: 600;
			text-decoration: none !important;
		}

		.tutorial-accordion .card-title:hover {
			text-decoration: none !important;
		}

		.tutorial-accordion .badge {
			font-size: 11px;
			font-weight: 400;
		}

		.tutorial-card {
			height: 100%;
			margin-bottom: 20px;
		}

		.tutorial-card .panel-hdr h2 {
			display: flex;
			align-items: center;
			gap: 8px;
			font-size: 14px;
			font-weight: 600;
			line-height: 1.35;
		}

		.tutorial-card .panel-content {
			padding: 14px;
		}

		.tutorial-descricao {
			min-height: 32px;
			margin-bottom: 12px;
			font-size: 12px;
			line-height: 1.45;
			color: #6c757d;
		}

		.tutorial-video {
			display: block;
			width: 100%;
			height: auto;
			max-height: 440px;
			background: #000;
			border: 1px solid #d9d9d9;
			border-radius: 2px;
		}

		@media (max-width: 767.98px) {
			.tutorial-descricao {
				min-height: 0;
			}
		}
	</style>

	
	<div class="accordion accordion-outline tutorial-accordion" id="accordion-tutoriais">

		<!-- ACADÊMICO - SCA -->
		<div class="card">
			<div class="card-header">
				<a href="javascript:void(0);" class="card-title collapsed"
				   data-toggle="collapse"
				   data-target="#tutorial-sca"
				   aria-expanded="false"
				   aria-controls="tutorial-sca">
					<i class="fal fa-graduation-cap width-2 fs-xl"></i>
					<strong>Acadêmico - SCA</strong>

					<span class="badge badge-primary ml-2">7 tutoriais</span>

					<span class="ml-auto">
						<span class="collapsed-reveal">
							<i class="fal fa-minus fs-xl"></i>
						</span>
						<span class="collapsed-hidden">
							<i class="fal fa-plus fs-xl"></i>
						</span>
					</span>
				</a>
			</div>

			<div id="tutorial-sca" class="collapse" data-parent="#accordion-tutoriais">
				<div class="card-body">
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-user-graduate"></i> Atualiza Matriz dos alunos</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para atualização da matriz curricular dos alunos.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_atualiza_matriz_alunoCon.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>

			
						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-file-certificate"></i> Cadastro do histórico escolar do aluno</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para cadastro e manutenção do histórico escolar do aluno.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_historico_escolar_novoCon.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>

			
						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-clock"></i> Horário de aula</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para cadastro e manutenção dos horários de aula.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_horario_aula.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>

						

						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-comment-alt-check"></i> Justificativa Faltas</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para registrar justificativas de faltas dos alunos.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_justificativa_faltas.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>

						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-th-list"></i> Matriz de Disciplinas</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para cadastro e manutenção da matriz de disciplinas.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_matriz_disciplina.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-th-list"></i> Incluir Atendimento Educacional Especializado (AEE)</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para cadastro Atendimento Educacional Especializado.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_atendimentoAEE.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>

						<div class="col-xl-6 col-lg-6 col-md-12">
							<div class="panel tutorial-card">
								<div class="panel-hdr">
									<h2><i class="fal fa-hands-helping"></i> Projetos Sociais</h2>
								</div>
								<div class="panel-container show">
									<div class="panel-content">
										<p class="tutorial-descricao">Passo a passo para vinculação e manutenção dos projetos sociais do aluno.</p>
										<video class="tutorial-video" controls preload="metadata">
											<source src="tutorial/sca/sca_projetos_sociais_aluno.mp4" type="video/mp4">
											Seu navegador não suporta a reprodução de vídeos.
										</video>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	<!-- PLANEJAMENTO - PLA -->
		<div class="card">
			<div class="card-header">
				<a href="javascript:void(0);" class="card-title collapsed"
				   data-toggle="collapse"
				   data-target="#tutorial-pla"
				   aria-expanded="false"
				   aria-controls="tutorial-pla">
					<i class="fal fa-tasks width-2 fs-xl"></i>
					Planejamento - PLA

					<span class="badge badge-primary ml-2">1 tutorial</span>

					<span class="ml-auto">
						<span class="collapsed-reveal">
							<i class="fal fa-minus fs-xl"></i>
						</span>
						<span class="collapsed-hidden">
							<i class="fal fa-plus fs-xl"></i>
						</span>
					</span>
				</a>
			</div>

			<div id="tutorial-pla" class="collapse" data-parent="#accordion-tutoriais">
				<div class="card-body">
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12">
				<div class="panel tutorial-card">
					<div class="panel-hdr">
						<h2><i class="fal fa-chalkboard-teacher"></i> Acompanhamento do planejamento professor</h2>
					</div>
					<div class="panel-container show">
						<div class="panel-content">
							<p class="tutorial-descricao">Passo a passo para acompanhamento do planejamento realizado pelo professor.</p>
							<video class="tutorial-video" controls preload="metadata">
								<source src="tutorial/pla/sca_planejamento_acompanhamento_professorCon.mp4" type="video/mp4">
								Seu navegador não suporta a reprodução de vídeos.
							</video>
						</div>
					</div>
				</div>
			</div>
					</div>
				</div>
			</div>
		</div>
		
<%
if strTemAcessoRH = "S" then
%>
		<!-- RECURSOS HUMANOS - RH -->
		<div class="card">
			<div class="card-header">
				<a href="javascript:void(0);" class="card-title collapsed"
				   data-toggle="collapse"
				   data-target="#tutorial-rh"
				   aria-expanded="false"
				   aria-controls="tutorial-rh">
					<i class="fal fa-users width-2 fs-xl"></i>
					Recursos Humanos - RH

					<span class="badge badge-primary ml-2">4 tutoriais</span>

					<span class="ml-auto">
						<span class="collapsed-reveal">
							<i class="fal fa-minus fs-xl"></i>
						</span>
						<span class="collapsed-hidden">
							<i class="fal fa-plus fs-xl"></i>
						</span>
					</span>
				</a>
			</div>





			<div id="tutorial-rh" class="collapse" data-parent="#accordion-tutoriais">
				<div class="card-body">
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12">
				<div class="panel tutorial-card">
					<div class="panel-hdr">
						<h2><i class="fal fa-user-plus"></i> Cadastro de Colaborador</h2>
					</div>
					<div class="panel-container show">
						<div class="panel-content">
							<p class="tutorial-descricao">Passo a passo para cadastro e manutenção dos colaboradores.</p>
							<video class="tutorial-video" controls preload="metadata">
								<source src="tutorial/RH/Cadastro%20de%20colaborador.mp4" type="video/mp4">
								Seu navegador não suporta a reprodução de vídeos.
							</video>
						</div>
					</div>
				</div>
			</div>

			<div class="col-xl-6 col-lg-6 col-md-12">
				<div class="panel tutorial-card">
					<div class="panel-hdr">
						<h2><i class="fal fa-users-cog"></i> Modulação</h2>
					</div>
					<div class="panel-container show">
						<div class="panel-content">
							<p class="tutorial-descricao">Passo a passo para realizar a modulação dos professores.</p>
							<video class="tutorial-video" controls preload="metadata">
								<source src="tutorial/RH/Modulacao-professores.mp4" type="video/mp4">
								Seu navegador não suporta a reprodução de vídeos.
							</video>
						</div>
					</div>
				</div>
			</div>

			<div class="col-xl-6 col-lg-6 col-md-12">
				<div class="panel tutorial-card">
					<div class="panel-hdr">
						<h2><i class="fal fa-briefcase"></i> Cadastro de Função</h2>
					</div>
					<div class="panel-container show">
						<div class="panel-content">
							<p class="tutorial-descricao">Passo a passo para cadastro e manutenção das funções dos colaboradores.</p>
							<video class="tutorial-video" controls preload="metadata">
								<source src="tutorial/RH/Cadastro-de-funcao.mp4" type="video/mp4">
								Seu navegador não suporta a reprodução de vídeos.
							</video>
						</div>
					</div>
				</div>
			</div>
			<div class="col-xl-6 col-lg-6 col-md-12">
				<div class="panel tutorial-card">
					<div class="panel-hdr">
						<h2><i class="fal fa-file-alt"></i> Diretrizes - Gerais</h2>
					</div>
					<div class="panel-container show">
						<div class="panel-content">
							<p class="tutorial-descricao">Passo a passo com as diretrizes gerais do módulo de Recursos Humanos.</p>
							<video class="tutorial-video" controls preload="metadata">
								<source src="tutorial/RH/Diretrizes-Gerais.mp4" type="video/mp4">
								Seu navegador não suporta a reprodução de vídeos.
							</video>
						</div>
					</div>
				</div>
			</div>
			
					</div>
				</div>
			</div>
		</div>

	<%
	end if
	%>
	</div>



	<script type="text/javascript">
		$(document).ready(function () {
			// Ao recolher um módulo, pausa qualquer vídeo que esteja tocando nele.
			$("#accordion-tutoriais .collapse").on("hide.bs.collapse", function () {
				$(this).find("video").each(function () {
					this.pause();
				});
			});
		});
	</script>


</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>
