<%	

	if strExcessaoPeriodoModulacao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodCurso = "" then intCodCurso ="0"
	sql = "select distinct cast(ano as varchar) + '/' + cast(mes as varchar) + '/' + cast(dia_mes as varchar) as Data_Lancamento, ano, mes, dia_mes"
	sql = sql & " from SCA_CALENDARIO_UE c"
	sql = sql & " inner join SCA_CALENDARIO_DIA_UE d on d.cod_calendario_ue = c.cod_calendario_ue"
	sql = sql & " inner join SCA_CALENDARIO_EVENTO e on e.cod_calendario_evento = d.cod_calendario_evento"
	sql = sql & " where c.cod_empresa = " & session("codEmpresa")	
	sql = sql & " and c.ano_letivo = " & session("strAnoLetivo")	
	sql = sql & " and d.dia_semana = 7" 'sabado
	sql = sql & " and e.letivo = 'S'"
	if intCodCurso<>"0" then
		sql = sql & " and c.cod_curso = " & intCodCurso
	end if
	sql = sql & " order by ano, mes, dia_mes"
	rs.open sql, cnn
	strDataLancamentoBuscaHorario = ""
%>
<select name="txtDataLancamento" id="txtDataLancamento" class="form-control" <%=strFuncao%>>
<option value="">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strDataLancamento) = trim(formatadataAP(rs("Data_Lancamento")))then
				strSelecionado = " selected"
				strDataLancamentoBuscaHorario = formatadataBD(rs("Data_Lancamento"))
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & trim(formatadataAP(rs("Data_Lancamento")))& " " & strSelecionado &">" & trim(formatadataAP(rs("Data_Lancamento"))) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>