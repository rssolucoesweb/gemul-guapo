<%
'parametros:
	'-> intCodAluno
	'-> intAnoLetivoAtual
	'-> intCodPeriodo
	'-> strCod_empresa
	'-> intCodCurso
	'-> intCodCalendarioEventoLetivo = 30 (letivo)

intCodCalendarioEventoLetivo = 30

if strTipoPeriodo="I" then
	sql = "select count(distinct data) as total_faltas "
	sql = sql & " from SCA_FALTAS_DIARIA"
	sql = sql & " where cod_aluno = " & intCodAluno
	sql = sql & " and ano_letivo =" & intAnoLetivoAtual
	sql = sql & " and cod_periodo = " & intCodPeriodo
	sql = sql & " and cod_empresa =" & strCod_empresa
	rsAux.open sql, cnn
	if rsAux.eof = false then
		total_faltas  = rsAux("total_faltas")
	end if
	rsAux.close
		
	falta_justificada = "-"
	falta_justificada_calculo = 0
	sql = "select sum(DATEDIFF(DAY, DataInicial, DataFinal)+1) AS QuantidadeDias"
	sql = sql & " from [dbo].[SCA_ALUNO_JUSTIFICATIVA_FALTAS]"
	sql = sql & " where cod_aluno = " & intCodAluno
	rsAux.open sql, cnn
	if rsAux.eof = false then
		if rsAux("QuantidadeDias")>0 then
			falta_justificada  = rsAux("QuantidadeDias")
			falta_justificada_calculo = rsAux("QuantidadeDias")
		end if
	end if
	rsAux.close
	
	ch_ministrada=0
	sql = "SELECT"
	sql = sql & "       isnull(count(DATEFROMPARTS(d.ano, d.mes, d.dia_mes)),0) AS dia_letivos"
	sql = sql & " FROM SCA_CALENDARIO_DIA_UE d"
	sql = sql & "     INNER JOIN SCA_CALENDARIO_UE c"
	sql = sql & "         ON c.cod_calendario_ue = d.cod_calendario_ue"
	sql = sql & "     INNER JOIN SCA_CALENDARIO_EVENTO e"
	sql = sql & "         ON e.cod_calendario_evento = d.cod_calendario_evento"
	sql = sql & " WHERE c.cod_empresa = " & strCod_empresa
	sql = sql & "     AND d.ano = " & intAnoLetivoAtual
	sql = sql & "     AND DATEFROMPARTS(d.ano, d.mes, d.dia_mes) < getdate()"
	sql = sql & "     and e.cod_calendario_evento = " & intCodCalendarioEventoLetivo
	sql = sql & "     and c.cod_curso = " & intCodCurso
	rsAux.open sql, cnn
	if rsAux.eof = false then
		if rsAux("dia_letivos")>0 then
			ch_ministrada  = rsAux("dia_letivos")
		end if
	end if
	rsAux.close
	
	ch_total = 800
	frequencia=ch_total'ch_ministrada
	sql = "select sum(isnull(d.Ch_Anual,0)) as ch"
	sql = sql & " from SCA_GRADECURRICULAR g"
	sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA d on d.Cod_GradeCurricular = g.Cod_GradeCurricular"
	sql = sql & " inner join SCA_DISCIPLINA di on di.Cod_disciplina = d.Cod_disciplina"
	sql = sql & " inner join SCA_ALUNO_DISCIPLINA ad on ad.COD_DISCIPLINA = di.Cod_Disciplina and ad.COD_GRADECURRICULARDISCIPLINA = d.Cod_GradeCurricularDisciplina"
	sql = sql & " where g.cod_Periodo = " & intCodPeriodo
	sql = sql & " and g.AnoReferencia = " & intAnoLetivoAtual
	sql = sql & " and di.documento_oficial = 'S'"
	sql = sql & " and ad.COD_ALUNO = " & intCodAluno
	sql = sql & " and ad.cod_empresa =" & strCod_empresa
	rsAux.open sql, cnn
	if rsAux.eof = false then
		ch_total  = rsAux("ch")
	end if
	rsAux.close
	perc_frequencia = "100 %"
	if total_faltas>0 then
	
		frequencia_atual = ch_ministrada-(total_faltas-falta_justificada_calculo)
		
		frequencia = ch_total-(total_faltas-falta_justificada_calculo)
		
		perc_frequencia = (frequencia/ch_total)*100
		
		perc_frequencia = formatNumber(perc_frequencia,1)
	end if
	if mostraTabelaChFaltas = "" then
	%>
	<table width="60%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
		<td width="20%" align="center" class="celula">Carga Horária</td>
		<td width="20%" align="center" class="celula">Frequência</td>
		<td width="20%" align="center" class="celula">% Frequências</td>
		<td width="20%" align="center" class="celula">Total de Faltas (dias)</td>
		<td width="20%" align="center" class="celula">Faltas Justificadas</td>
	  </tr>
	  <tr>
		<td width="20%" align="center" class="celula"><%=ch_total%></td>
		<td width="20%" align="center" class="celula"><%=frequencia_atual%></td>
		<td width="20%" align="center" class="celula"><%=perc_frequencia%> %</td>
		<td width="20%" align="center" class="celula"><%=total_faltas%></td>
		<td width="20%" align="center" class="celula"><%=falta_justificada%></td>
	  </tr>
	</table>  
	<%end if%>
<%end if%>