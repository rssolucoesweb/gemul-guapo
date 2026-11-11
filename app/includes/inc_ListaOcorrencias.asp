<%
IF intCodAluno <> "" THEN
	sql = "SELECT O.DATAOCORRENCIA, O.OCORRENCIA, U.USUA_NOME_COMPLETO AS USUARIO_INCL"
	sql = sql & " FROM SCA_OCORRENCIA O"
	sql = sql & " LEFT JOIN seg_usuarios_sistema U ON U.USUA_CODG = O.USUARIO_INCL"
	sql = sql & " WHERE O.Cod_Aluno=" & intCodAluno
	sql = sql & " and o.cod_empresa = " & session("codEmpresa")
	sql = sql & " order by O.DATAOCORRENCIA desc "			
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
		<div class="accordion accordion-outline" id="js_demo_accordion-3">
			<div class="card">
				<div class="card-header">
					<a href="javascript:void(0);" class="card-title" data-toggle="collapse" data-target="#js_demo_accordion-3a" aria-expanded="false">
						<i class="fal fa-file-medical-alt width-2 fs-xl"></i>
						Histórico de ocorrências
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
				<div id="js_demo_accordion-3a" class="collapse" data-parent="#js_demo_accordion-3">
					<div class="card-body">
						
						<table class="table m-0">
							<thead class="thead-themed">
								<tr>
								  <th>Ocorrência</th>
								  <th>Usu&aacute;rio</th>
								  <th>Data</th>
							   </tr>
							</thead>
                            <tbody>
							<%
							WHILE NOT RS.EOF
								%>
								<tr> 
								  <td><%=RS("OCORRENCIA")%>&nbsp;</td>
								  <td><%=RS("USUARIO_INCL")%>&nbsp;</td>
								  <td>
										<%if RS("OCORRENCIA") = "Incluído pela ficha do aluno / decisão judicial" then%>
											<%if  (UCASE(session("usuarioWeb")) = "SERGIO" OR UCASE(session("usuarioWeb")) = "FERNANDO.DOMINGOS") then%>
												<%=RS("DATAOCORRENCIA")%>
											<%else%>
												&nbsp;
											<%end if%>
										<%else%>
											<%=RS("DATAOCORRENCIA")%>
										<%end if%>
								  </td>
								</tr>
								<%
								RS.MOVENEXT
							WEND
						%></tbody>
						</table>
						
						
					</div>
				</div>
			</div>
		</div>
<%
	END IF
	rs.close
END IF
%>