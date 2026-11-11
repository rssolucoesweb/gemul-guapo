<%

'response.write "<br>f:" & Session("strBloqueiaFechamento")
'response.write "<br>aa:" & session("strAnoLetivo")
'response.write "<br>ap:" & strAnoLetivo
'response.write "<br>strAnoLetivoLocacao:" & strAnoLetivoLocacao
if Session("strBloqueiaFechamento") = "S" then
	if trim(strAnoLetivo) > trim(session("strAnoLetivo")) then
		
		bloqueia_troca_ano = ""
		sql = "select TOP 1 t.cod_turma, t.NomeTurma, t.TurmaAluno, f.SITUACAO"
		sql = sql & " from sca_turma t"
		sql = sql & " left join SCA_FECHAMENTO_AGENDAMENTO f on f.COD_TURMA = t.cod_turma and t.AnoLetivo = f.ANO_LETIVO"
		sql = sql & " where t.Cod_Empresa = " & session("codEmpresa")
		sql = sql & " and t.AnoLetivo = " & strAnoLetivo
		rs.open sql, cnn
		if rs.eof then
			bloqueia_troca_ano = "S"
		end if
		rs.close
		
		sql = "select distinct  t.cod_turma, t.NomeTurma, t.TurmaAluno, f.SITUACAO"
		sql = sql & " from sca_turma t"
		sql = sql & " left join SCA_FECHAMENTO_AGENDAMENTO f on f.COD_TURMA = t.cod_turma and t.AnoLetivo = f.ANO_LETIVO"
		sql = sql & " where t.Cod_Empresa = " & session("codEmpresa")
		sql = sql & " and t.Situacao = 'A'"
		sql = sql & " and t.AnoLetivo = " & strAnoLetivo
		sql = sql & " and (f.SITUACAO is null or f.SITUACAO = 'A')"
		rs.open sql, cnn
		if not rs.eof then
			bloqueia_troca_ano = "S"
		end if
		rs.close

		if bloqueia_troca_ano = "S" then
			%>
			<script>
				alert("Fechamento anual de <%=strAnoLetivo%> não foi finalizado para todas as turmas!");
				window.location='academico.asp';
			</script>
			<%
			response.end
		end if
	end if


	if strAnoLetivoLocacao<>"" then
		if trim(strAnoLetivoLocacao) > trim(strAnoLetivo) then
			bloqueia_troca_ano = ""
			sql = "select TOP 1 t.cod_turma, t.NomeTurma, t.TurmaAluno, f.SITUACAO"
			sql = sql & " from sca_turma t"
			sql = sql & " left join SCA_FECHAMENTO_AGENDAMENTO f on f.COD_TURMA = t.cod_turma and t.AnoLetivo = f.ANO_LETIVO"
			sql = sql & " where t.Cod_Empresa = " & session("codEmpresa")
			sql = sql & " and t.AnoLetivo = " & strAnoLetivo
			rs.open sql, cnn
			if rs.eof then
				bloqueia_troca_ano = "S"
			end if
			rs.close
			
			sql = "select distinct  t.cod_turma, t.NomeTurma, t.TurmaAluno, f.SITUACAO"
			sql = sql & " from sca_turma t"
			sql = sql & " left join SCA_FECHAMENTO_AGENDAMENTO f on f.COD_TURMA = t.cod_turma and t.AnoLetivo = f.ANO_LETIVO"
			sql = sql & " where t.Cod_Empresa = " & session("codEmpresa")
			sql = sql & " and t.Situacao = 'A'"
			sql = sql & " and t.AnoLetivo = " & strAnoLetivo
			sql = sql & " and (f.SITUACAO is null or f.SITUACAO = 'A')"
			rs.open sql, cnn
			if not rs.eof then
				bloqueia_troca_ano = "S"
			end if
			rs.close

			if bloqueia_troca_ano = "S" then
				%>
				<script>
					alert("Fechamento anual de <%=strAnoLetivo%> não foi finalizado para todas as turmas!");
					window.location='academico.asp';
				</script>
				<%
				response.end
			end if
		end if
	end if
end if
%>