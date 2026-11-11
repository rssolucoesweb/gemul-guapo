<%
	if submitFuncaoAvaliacao = "S" then
		strFuncaoAvaliacao = "onChange='submit()'"
	end if

	sql="select c.cod_tipo_lancamento as codigo, c.posicao, c.descricao, b.cod_criterio, b.data_inicio, b.data_fim"
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " inner join SCA_BIMESTRE b on b.cod_criterio = tc.cod_criterio and ca.ano_letivo = b.Ano_letivo and b.Descricao = c.descricao"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " and c.digitar = 'S'"
	sql=sql & " and c.cod_tipo_lancamento not in (6,7)"
	if strMes<>"" then
		sql=sql & " and " & strMes & " between month(b.data_inicio) and month(b.data_fim)"
	end if
	sql=sql & " order by c.posicao"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbAvaliacao" id="cmbAvaliacao" class="form-control" <%=strFuncaoAvaliacao%>>
	<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		
		while not rs.eof
			if trim(intCodAvaliacao) = trim(rs("codigo")) then
				strSelecionado = "selected"
				intCodCriterio = rs("cod_criterio")
				strPosicao = rs("posicao")
				strDataInicio = rs("data_inicio")
				strDataFim = rs("data_fim")
				strBimestre = rs("descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("descricao") & "</option>" & vbcrlf
			rs.movenext
		wend
	END IF
	
	rs.close
	%>
	</select>