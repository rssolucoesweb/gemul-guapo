<%
	if intCodCurso="" then intCodCurso="0"
	sql="select c.codigo, c.posicao, c.descricao "
	sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
	sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
	sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
	sql=sql & " where c.digitar='S' and ca.ano_letivo = " & strAnoLetivo
	sql=sql & " and ca.cod_curso = " & intCodCurso
	sql=sql & " order by c.posicao"
	RS.OPEN SQL, CNN
	%>
	<select name="cmbAvaliacao" id="cmbAvaliacao" class="form-control" >
	<%
	strCodGradeCurricularDisciplina = ""
	IF RS.EOF = FALSE THEN
		while not rs.eof
			strBim = rs("descricao")
			
			if cstr(intCodAvaliacao) = cstr(rs("codigo")) then
				strSelecionado = "selected"
				
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("descricao") & "</option>" & vbcrlf
			trocaBim = trim(rs("posicao"))
			rs.movenext
		wend
	END IF
	
	rs.close
	%>
	</select>