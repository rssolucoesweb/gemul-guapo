<br>
<div class="modules">
       <div class="module-card" onclick="window.location.href='<%=session("urlSistema")%>tutorial.asp'">
			<i class="fa-solid fa-circle-play icon-tutorial" style="font-size: 40px;"></i>
			<br>
			<span>Tutoriais</span>
		</div>
		<%
		strTabelaAcesso = "SEG_ACESSOS_USUARIO"
		if Session("Aluno") <> "S" then 	
			sql = "SELECT DISTINCT  SEG_PERFIS_SISTEMA.PERF_SIST_SIGL, SEG_SISTEMAS_INFORMATICA.SIST_DESC, SEG_MODULOS_SISTEMA.MODU_URL "
			sql = sql & " FROM (SEG_SISTEMAS_INFORMATICA INNER JOIN (SEG_PERFIS_SISTEMA INNER JOIN "&strTabelaAcesso&" ON SEG_PERFIS_SISTEMA.PERF_CODG = "&strTabelaAcesso&".ACES_PERF_CODG) ON SEG_SISTEMAS_INFORMATICA.SIST_SIGL = SEG_PERFIS_SISTEMA.PERF_SIST_SIGL) INNER JOIN SEG_MODULOS_SISTEMA ON SEG_SISTEMAS_INFORMATICA.SIST_SIGL = SEG_MODULOS_SISTEMA.MODU_SIST_SIGL "
			sql = sql & " WHERE ((("&strTabelaAcesso&".ACES_USUA_CODG)='" & session("UsuarioWeb") & "') AND ((SEG_SISTEMAS_INFORMATICA.SIST_STAT)='A') AND ((SEG_MODULOS_SISTEMA.MODU_STAT)='A')) "
			IF intCodigoColaboradorContrato <> "" AND intCodigoColaboradorContrato<>"0" THEN
				SQL = SQL & " AND SEG_ACESSOS_USUARIO.COD_COLABORADOR = " & LEFT(intCodigoColaboradorContrato,LEN(intCodigoColaboradorContrato)-1)
			END IF			
			sql = sql & " ORDER BY SEG_SISTEMAS_INFORMATICA.SIST_DESC"
		else
			sql = "SELECT DISTINCT SEG_PERFIS_SISTEMA.PERF_SIST_SIGL, SEG_SISTEMAS_INFORMATICA.SIST_DESC, SEG_MODULOS_SISTEMA.MODU_URL  "
			sql = sql & " FROM (SEG_SISTEMAS_INFORMATICA "
			sql = sql & " INNER JOIN (SEG_PERFIS_SISTEMA "
			sql = sql & " INNER JOIN "&strTabelaAcesso&" ON SEG_PERFIS_SISTEMA.PERF_CODG = "&strTabelaAcesso&".ACES_PERF_CODG) ON SEG_SISTEMAS_INFORMATICA.SIST_SIGL = SEG_PERFIS_SISTEMA.PERF_SIST_SIGL) "
			sql = sql & " INNER JOIN SEG_MODULOS_SISTEMA ON SEG_SISTEMAS_INFORMATICA.SIST_SIGL = SEG_MODULOS_SISTEMA.MODU_SIST_SIGL "
			sql = sql & " WHERE (((SEG_PERFIS_SISTEMA.PERF_SIST_SIGL)='SCA') "
			sql = sql & " AND ((SEG_SISTEMAS_INFORMATICA.SIST_STAT)='A') "
			sql = sql & " AND ((SEG_MODULOS_SISTEMA.MODU_STAT)='A')) "
			sql = sql & " ORDER BY SEG_SISTEMAS_INFORMATICA.SIST_DESC "
		end if	
		URL = ucase(Request.ServerVariables("SERVER_NAME"))
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
				sigla = trim(rs("PERF_SIST_SIGL"))
				if sigla = "SCA" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-graduation-cap icon-academico" style="font-size: 40px;"></i>
					<br>
					<span>Acadêmico</span>
				</div>
				<%
				elseif sigla = "DAS" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-chart-line icon-dashboard" style="font-size: 40px;"></i>  
					<br>
					<span>Dashboard</span>
				</div>
				<%
				elseif sigla = "PLA" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-calendar-alt icon-planejamento" style="font-size: 40px;"></i>  
					<br>
					<span>Planejamento</span>
				</div>
				<%
				elseif sigla = "SME" then
					%>
					<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
						<i class="fa-solid fa-utensils icon-merenda" style="font-size: 40px;"></i>
						<br>
						<span>Merenda Escolar</span>
					</div>
					<%
				elseif sigla = "EDUCACENSO" then
				%>
				<div class="module-card" onclick="#">
					<i class="fa-solid fa-file-circle-check icon-censo" style="font-size: 40px;"></i>  
					<br>
					<span>Censo Escolar</span>
				</div>
				<%
				elseif sigla = "PAT" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					 <i class="fa-solid fa-warehouse icon-patrimonio" style="font-size: 40px;"></i>
					<br>
					<span>Patrimônio</span>
				</div>
				<%
				elseif sigla = "MAT" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/gemul2015/Sistema/MAT/DEFAULT.ASP'">
					<i class="fa-solid fa-clipboard-list icon-matricula" style="font-size: 40px;"></i>  
					<br>
					<span>Matrícula</span>
				</div>
				<%
				elseif sigla = "STE" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-bus icon-transporte" style="font-size: 40px;"></i>  
					<br>
					<span>Transporte Escolar</span>
				</div>
				<%
				elseif sigla = "AEE" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					 <i class="fa-solid fa-hands-holding-child icon-atendimento" style="font-size: 40px;"></i>
					<br>
					<span>Atendimento Educacional</span>
				</div>
				<%
				elseif sigla = "EST" then
				%>
				<div class="module-card" onclick="#">
					<i class="fa-solid fa-boxes-packing icon-almoxarifado" style="font-size: 40px;"></i>  
					<br>
					<span>Almoxarifado</span>
				</div>
				<%
				elseif sigla = "SRH" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/sistema/<%=ucase(trim(rs("PERF_SIST_SIGL")))%>/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-users icon-rh" style="font-size: 40px;"></i>  
					<br>
					<span>Recursos Humanos</span>
				</div>
				<%
				elseif sigla = "SEC" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/sistema/<%=ucase(trim(rs("PERF_SIST_SIGL")))%>/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-file-alt icon-secretario" style="font-size: 40px;"></i>  
					<br>
					<span>Secretário</span>
				</div>
				<%
				elseif sigla = "ESP" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-futbol icon-esporte" style="font-size: 40px;"></i>  
					<br>
					<span>Esporte</span>
				</div>
				<%
				elseif sigla = "SGE" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/sistema/<%=ucase(trim(rs("PERF_SIST_SIGL")))%>/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-chart-bar icon-gerencial" style="font-size: 40px;"></i>  
					<br>
					<span>Gerencial</span>
				</div>
				<%
				elseif sigla = "SEG" then
				%>
				<div class="module-card" onclick="window.location.href='https://<%=URL%>/sistema/<%=ucase(trim(rs("PERF_SIST_SIGL")))%>/<%=trim(rs("MODU_URL"))%>'">
					<i class="fa-solid fa-shield-alt icon-seguranca" style="font-size: 40px;"></i>  
					<br>
					<span>Segurança</span>
				</div>
				<%
				end if
				rs.movenext
			wend
		end if
		rs.close	
		%>
</div>