<!-- Recent Works -->
    <%if Session("mobile")<>"S" then%>
<div class="headline"><h2>Modulos do Sistema</h2></div>
    <%end if%>
<div class="row margin-bottom-20">
       <%
		'sql = "SELECT Aces_Usua_Codg, Cod_Categoria, Aces_Perf_Codg "
		'sql = sql & " FROM Seg_Acessos_Usuario_Excessoes "
		'sql = sql & " WHERE Aces_Usua_Codg = '" & session("UsuarioWeb") & "'"
		'sql = sql & " AND Cod_Empresa = " & session("CodEmpresa")
		'rs.open sql, cnn
		'if not rs.eof then
		'	session("CodCategoriaExcessoes") = trim(rs("Cod_Categoria")) 
		'	strTabelaAcesso = "SEG_ACESSOS_USUARIO_EXCESSOES"
		'else		
		'	strTabelaAcesso = "SEG_ACESSOS_USUARIO"
		'end if
		'rs.close
		
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
		'response.write sql
		rs.open sql, cnn
		if not rs.eof then
			while not rs.eof
			%>
				<div class="col-md-3 col-sm-6">
					<div class="thumbnails thumbnail-style thumbnail-kenburn">
						<div class="thumbnail-img">
							<div class="overflow-hidden">
                            <%
							sigla = trim(rs("PERF_SIST_SIGL"))
							if sigla = "SCA" or sigla = "DAS" or sigla = "PLA" or sigla = "ESP" then
							%>
								<a href="http://<%=URL%>/app/<%=trim(rs("MODU_URL"))%>"><img class="img-responsive" src="../assets/img/icones/<%=rs("PERF_SIST_SIGL")%>.png" alt=""></a>	</div>
							<%
							elseif sigla = "MAT" then
							%>
								<a href="http://<%=URL%>/gemul2015/Sistema/MAT/DEFAULT.ASP"><img class="img-responsive" src="../assets/img/icones/<%=rs("PERF_SIST_SIGL")%>.png" alt=""></a>	</div>
							<%
							else
								if Session("mobile")="S" then
								%>	
									<a href="<%=ucase(trim(rs("PERF_SIST_SIGL")))%>/<%=trim(rs("MODU_URL"))%>"><img class="img-responsive" src="../assets/img/icones/<%=rs("PERF_SIST_SIGL")%>mobile.png" alt=""></a>	</div>
								<%
								else
								%>	
									<a href="<%=ucase(trim(rs("PERF_SIST_SIGL")))%>/<%=trim(rs("MODU_URL"))%>"><img class="img-responsive" src="../assets/img/icones/<%=rs("PERF_SIST_SIGL")%>.png" alt=""></a>	</div>
								<%
								end if
							end if
							%>
						</div>
					</div>
				</div>
			 <%
				rs.movenext
			wend
		end if
		rs.close	
		%>
            <%if Session("mobile")<>"S" then%>

    	<div class="col-md-3 col-sm-6"></div>
            <%end if%>

</div>
<!-- End Recent Works -->
