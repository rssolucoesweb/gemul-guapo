<%
	sql="select c.cod_tipo_lancamento as codigo, c.descricao"
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " and c.digitar = 'S'"
	sql=sql & " and c.cod_tipo_lancamento not in (6,7)"
	sql=sql & " order by c.posicao"
									 
	RS.OPEN SQL, CNN
	%>
	<select name="cmbAvaliacao" id="cmbAvaliacao" class="form-control" >
	<%
	strCodGradeCurricularDisciplina = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if cstr(intCodAvaliacao) = cstr(rs("codigo")) then
				strSelecionado = "selected"
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