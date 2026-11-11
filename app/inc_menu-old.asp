<!-- BEGIN PRIMARY NAVIGATION -->
<nav id="js-primary-nav" class="primary-nav" role="navigation">
	<!--div class="nav-filter">
		<div class="position-relative">
			<input type="text" id="nav_filter_input" placeholder="Filter menu" class="form-control" tabindex="0">
			<a href="#" onclick="return false;" class="btn-primary btn-search-close js-waves-off" data-action="toggle" data-class="list-filter-active" data-target=".page-sidebar">
				<i class="fal fa-chevron-up"></i>
			</a>
		</div>
	</div-->
	<div class="info-card">
		<img src="img/demo/avatars/<%=session("avatar")%>" class="profile-image rounded-circle" alt="<%=session("strUsuarioRodapeGemul")%>">
		<div class="info-card-text">
			<a href="#" class="d-flex align-items-center text-white">
				<span class="text-truncate text-truncate-sm d-inline-block">
					<%=session("strUsuarioRodapeGemul")%>
				</span>
			</a>
			<!--span class="d-inline-block text-truncate text-truncate-sm">Toronto, Canada</span-->
		</div>
		<img src="img/card-backgrounds/cover-2-lg.png" class="cover" alt="cover">
		<a href="#" onclick="return false;" class="pull-trigger-btn" data-action="toggle" data-class="list-filter-active" data-target=".page-sidebar" data-focus="nav_filter_input">
			<i class="fal fa-angle-down"></i>
		</a>
	</div>
	<ul id="js-nav-menu" class="nav-menu">
	
	
	
		<!--#include file="includes/inc_validaPermissao.asp"-->
		<%
		
		'strNomeSistema 	= Session("strNomeSistema") 	
		'Sistema 			= Session("strSistema") 
		'Modulo 			= Session("strModulo")  
		
		'select para contar a quantidade de menus que ir� existir
		strPerfil =  validaPermissao(session("usuarioweb"), sistema_sigla)
		
		if  session("CodCategoriaExcessoes") = "1" then 
			strPerfil =  "11"
		end if
		if  Session("Seg_Perfil") <> "" and Session("Seg_Perfil") <> "0" then 
			strPerfil =  Session("Seg_Perfil")
		end if
		
		contMenu = 0 
		
		'carrega menu do sistema
		sql = "SELECT DISTINCT SEG_MENUS_SISTEMA.MENU_DESC,  SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_CODG, SEG_MENUS_SISTEMA.ICONE "
		sql = sql & " FROM SEG_MENUS_SISTEMA INNER JOIN (SEG_ITENS_SISTEMA INNER JOIN SEG_PERFIS_ITENS_SISTEMA ON SEG_ITENS_SISTEMA.ITEM_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_ITEM_CODG) ON (SEG_MENUS_SISTEMA.MENU_SIST_SIGL = SEG_ITENS_SISTEMA.ITEM_SIST_SIGL) AND (SEG_MENUS_SISTEMA.MENU_MODU_SIGL = SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL) AND (SEG_MENUS_SISTEMA.MENU_CODG = SEG_ITENS_SISTEMA.ITEM_MENU_CODG) "
		sql = sql & " WHERE     (SEG_PERFIS_ITENS_SISTEMA.PITE_PERF_CODG in (" & strPerfil &")) "
		sql = sql & " AND (SEG_MENUS_SISTEMA.MENU_SIST_SIGL = '" & sistema_sigla & "')"
		sql = sql & " AND SEG_MENUS_SISTEMA.MENU_MODU_SIGL = '"& Modulo & "'"
		sql = sql & " AND SEG_MENUS_SISTEMA.SITUACAO = 'A'"
		sql = sql & " AND SEG_ITENS_SISTEMA.ITEM_STAT='A' "
		sql = sql & " AND SEG_MENUS_SISTEMA.MENU_DESC <> 'Sair'"
		sql = sql & " ORDER BY SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO"
		
		rs.open sql, cnn
		if rs.eof then
			rs.close
			%>
			<script>
				//alert("Usuario sem permissoes no sistema!"); 
				//window.history.back();
			</script>
			 <%
		 ' response.End()
		else
			
			while not rs.eof
				
				contMenu = contMenu + 1
				strAtivaMenu = ""
				ico = RS("ICONE")
				if ucase(menu_principal) = ucase(rs("MENU_DESC")) then 
					strAtivaMenu = "class='active open'"
				end if
				
				
				%>
				
				<li <%=strAtivaMenu%>>
					<a href="#" title="Application Intel" data-filter-tags="application intel">
						<i class="<%=ico%>"></i>
						<span class="nav-link-text" data-i18n="nav.application_intel"><%=trim(rs("MENU_DESC"))%></span>
					</a>
					<ul>
					<%
					'carrega sub menu do sistema
					cont = 0 
					
					sql = "SELECT SEG_ITENS_SISTEMA.ITEM_DESC, SEG_ITENS_SISTEMA.ITEM_INFO_URL, isnull(SEG_ITENS_SISTEMA.ITEM_INFO_URL_NOVO,'') as ITEM_INFO_URL_NOVO, isnull(SEG_ITENS_SISTEMA.ITEM_INFO_URL_TESTE,'') as ITEM_INFO_URL_TESTE, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_DESC "
					sql = sql & " FROM SEG_MENUS_SISTEMA INNER JOIN (SEG_PERFIS_SISTEMA INNER JOIN (SEG_ITENS_SISTEMA INNER JOIN SEG_PERFIS_ITENS_SISTEMA ON SEG_ITENS_SISTEMA.ITEM_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_ITEM_CODG) ON SEG_PERFIS_SISTEMA.PERF_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_PERF_CODG) ON SEG_MENUS_SISTEMA.MENU_CODG = SEG_ITENS_SISTEMA.ITEM_MENU_CODG "
					sql = sql & " WHERE (((SEG_PERFIS_SISTEMA.PERF_CODG) In (" & strPerfil &")) "
					sql = sql & " AND SEG_ITENS_SISTEMA.ITEM_STAT='A' "
					sql = sql & " AND ((SEG_ITENS_SISTEMA.ITEM_SIST_SIGL)='"& sistema_sigla & "') "
					sql = sql & " AND ((SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL)='" & Modulo & "')) "
					sql = sql & " AND ((SEG_MENUS_SISTEMA.MENU_DESC) ='" & trim(rs("MENU_DESC")) & "')"
					sql = sql & " GROUP BY SEG_ITENS_SISTEMA.ITEM_DESC, SEG_ITENS_SISTEMA.ITEM_INFO_URL, SEG_ITENS_SISTEMA.ITEM_INFO_URL_NOVO, SEG_ITENS_SISTEMA.ITEM_INFO_URL_TESTE, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_DESC "
					sql = sql & " ORDER BY SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_ITENS_SISTEMA.ITEM_DESC"
					
					strMenuDesc = ""
					rsAux.open sql, cnn
					if not rsAux.eof then
						while not rsAux.eof
							caminho = "/gemul2015/Sistema/SCA/" & rsAux("ITEM_INFO_URL")
							pagina_menu = ""
							novo = ""
							IF UCASE(SESSION("USUARIOWEB"))="SERGIO" OR UCASE(SESSION("USUARIOWEB")) = "FERNANDO.DOMINGOS" THEN
								IF trim(rsAux("ITEM_INFO_URL_TESTE"))<>"" THEN
									caminho = rsAux("ITEM_INFO_URL_TESTE")
									pagina_menu = rsAux("ITEM_INFO_URL_TESTE")
								END IF
							END IF
							
							IF trim(rsAux("ITEM_INFO_URL_NOVO"))<>"" THEN
								caminho = rsAux("ITEM_INFO_URL_NOVO")
								pagina_menu = rsAux("ITEM_INFO_URL_NOVO")
								'novo = " <u><i>(novo)</i></u>"
							END IF
							
							
							icone = "fal fa-edit"
							if trim(rs("MENU_DESC"))="Relatórios" then
								icone = "fal fa-print"
							end if
							
							mn_atual = ""
							if ucase(trim(pagina_atual)) = ucase(trim(pagina_menu)) then
								mn_atual = "class='active'"
							end if
							
							'response.write "atual:" & ucase(trim(pagina_atual)) & "<br>"
							'response.write "<br>menu:" & ucase(trim(rsAux("ITEM_INFO_URL_TESTE"))) & "<br>"
							'response.write mn_atual
							%>
								<li <%=mn_atual%>>
									<a href="<%=trim(caminho)%>" title="<%=trim(rsAux("ITEM_DESC"))%>" data-filter-tags="<%=trim(rsAux("ITEM_DESC"))%>">
										<i class="<%=icone%>"></i><span class="nav-link-text" data-i18n="nav.application_intel_introduction"><%=trim(rsAux("ITEM_DESC"))%><%=novo%></span>
									</a>
								</li>
							
							<%
							rsAux.movenext
						wend
					end if
					rsAux.close
					%>
					</ul>
				</li>			
			
				<%
				rs.movenext
			wend
			rs.close
		end if
		%>
		<li>
				<a href="/login/selecionar_escola.asp" title="Application Intel" data-filter-tags="application intel">
					<i class="fal fal fa-cube"></i>
					<span class="nav-link-text" data-i18n="nav.application_intel">Módulos</span>
				</a>
		</li>
		<li>
				<!--a href="#" title="Application Intel" data-filter-tags="application intel">
					<STRONG><FONT COLOR=RED>DESENVOVIMENTO</FONT></STRONG>
				</a-->
		</li>
		<!--li class="nav-title">Configurações</li-->
	</ul>
	<div class="filter-message js-filter-message bg-success-600"></div>
</nav>
<!-- END PRIMARY NAVIGATION -->