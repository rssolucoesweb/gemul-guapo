<%
IF intCodTurma <> "0" and intCodDisciplinaTurma <> "0" and intCodCalculo <> "0" THEN
	sql = "select u.USUA_NOME_COMPLETO, e.data_hora_envio "
	sql = sql & " from SCA_MEDIA_ENVIADA e"
	sql = sql & " left join SEG_USUARIOS_SISTEMA u on u.USUA_CODG = e.usuario_envio"
	sql = sql & " where cod_turma = " & intCodTurma
	sql = sql & " and cod_calculo = " & intCodCalculo
	sql = sql & " and cod_disciplina = " & intCodDisciplinaTurma
	sql = sql & " order by data_hora_envio desc"
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
	%>
		<div class="accordion accordion-outline" id="js_demo_accordion-3">
			<div class="card">
				<div class="card-header">
					<a href="javascript:void(0);" class="card-title" data-toggle="collapse" data-target="#js_demo_accordion-3a" aria-expanded="false">
						<i class="fal fa-file-medical-alt width-2 fs-xl"></i>
						Histórico de envio de média
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
								  <td>Média enviada&nbsp;</td>
								  <td><%=RS("USUA_NOME_COMPLETO")%>&nbsp;</td>
								  <td><%=RS("data_hora_envio")%></td>
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