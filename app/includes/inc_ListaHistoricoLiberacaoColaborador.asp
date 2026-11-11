<%
IF intCodEmp <> "" THEN
	sql = "select l.cod_planejamento_periodo_extra, c.nome, c.codFuncional, l.quinzena, l.motivo, l.data_expira, "
	sql = sql & " case when l.data_hora_altr is null or l.usuario_altr = 'sistema' then "
	sql = sql & " 			l.data_hora_incl "
	sql = sql & " else l.data_hora_altr "
	sql = sql & " end as data_hora, "
	sql = sql & " case when l.usuario_altr is null or l.usuario_altr = 'sistema' then "
	sql = sql & " 			u1.USUA_NOME_COMPLETO "
	sql = sql & " else u2.USUA_NOME_COMPLETO "
	sql = sql & " end as usuario, "
	sql = sql & " case when l.situacao = 'A' then 'Ativa' else 'Inativa' end as situacao, p.ano_letivo, p.mes "
	sql = sql & " from SCA_PLANEJAMENTO_PERIODO_EXTRA l"
	sql = sql & " inner join SRH_COLABORADOR c on c.codigo = l.cod_colaborador"
	sql = sql & " left join SEG_USUARIOS_SISTEMA u1 on u1.USUA_CODG = l.usuario_incl"
	sql = sql & " left join SEG_USUARIOS_SISTEMA u2 on u2.USUA_CODG = l.usuario_altr"	
	sql = sql & " left join SCA_PLANEJAMENTO_PERIODO p on p.cod_planejamento_periodo = l.cod_planejamento_periodo"
	sql = sql & " where l.cod_empresa = " & intCodEmp
	sql = sql & " order by l.data_hora_incl desc"
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
		<div class="accordion accordion-outline" id="js_demo_accordion-3">
			<div class="card">
				<div class="card-header">
					<a href="javascript:void(0);" class="card-title" data-toggle="collapse" data-target="#js_demo_accordion-3a" aria-expanded="false">
						<i class="fal fa-file-medical-alt width-2 fs-xl"></i>
						Histórico de liberações
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
								  <th>Colaborador</th>
								  <th>Quinzena</th>
								  <th>Motivo</th>
								  <th>Usu&aacute;rio</th>
								  <th>Data inclusão</th>
								  <th>Data expira</th>
								  <th>Situação</th>
								  <th>Ação</th>
							   </tr>
							</thead>
                            <tbody>
							<%
							WHILE NOT RS.EOF
								periodo = ucase(MonthName(rs("mes"))) & "/" & rs("ano_letivo")
								%>
								<tr> 
								  <td><%=RS("nome")%>&nbsp;(<%=RS("codFuncional")%>)</td>
								  <td><%=RS("quinzena")%>ª&nbsp;<%=periodo%></td>
								  <td><%=RS("motivo")%>&nbsp;</td>
								  <td><%=RS("USUARIO")%>&nbsp;</td>
								  <td><%=RS("data_hora")%>&nbsp;</td>
								  <td><%=formatadataap(RS("data_expira"))%>&nbsp;</td>
								  <td><%=RS("situacao")%>&nbsp;</td>
								  <td>
									<%IF RS("SITUACAO") = "Ativa" THEN %>
									<button onClick="inativar('<%=rs("cod_planejamento_periodo_extra")%>')"  type="button" class="form-control btn btn-outline-info">Inativar</button>
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