<%	
	if strExecutarSubmitColaboradorFrequencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	
	
		sql = "	SELECT DISTINCT C.codigo, C.nome + ' (sub)' as nome, C.codFuncional "
		sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CS"
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = CS.CodColaboradorSubstituto"
		sql = sql & " where CS.CodEmpresaSubstituido = " & Session("CodEmpresa")
		'sql = sql & " and C.situacao = 'A' "
		'sql = sql & " and (C.CodCategoria = 1 or C.CodCategoria = 8) "
		'sql = sql & " and CS.Situacao = 'A'"
		'Filtra somente pelo periodo
		sql = sql & " and convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) >= convert(datetime, '" & strDataInicialModulacao & "',103) "
		sql = sql & " and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) <= convert(datetime, '" & strDataFinalModulacao & "',103) "
		sql = sql & " and convert(datetime, '" & strDataLancamento & "',103) between convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) AND convert(datetime,convert(varchar, CS.DATAFINAL, 103),103)"
		sql = sql & " and convert(datetime, '" & strDataLancamentoFinal & "',103) between convert(datetime,convert(varchar, CS.DATAFINAL , 103),103) AND convert(datetime,convert(varchar, CS.DATAFINAL, 103),103)"
	
		sql = sql & " union"
		sql = sql & " select DISTINCT C.codigo, C.nome, C.codFuncional"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR"
		sql = sql & " where M.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and M.Status = 'A'"
		sql = sql & " and C.situacao = 'A'"
		'sql = sql & " and (C.CodCategoria = 1 or C.CodCategoria = 8) "
		'sql = sql & " and C.codigo not in ("
		'sql = sql & "		SELECT DISTINCT C.codigo"
		'sql = sql & " 		FROM SRH_COLABORADOR_SUBSTITUTO CS"
		'sql = sql & " 		inner join SRH_COLABORADOR C ON C.CODIGO = CS.CodColaboradorSubstituto"
		'sql = sql & " 		where CS.CodEmpresaSubstituido = " & Session("CodEmpresa")
		'sql = sql & " 		and C.situacao = 'A' "
		'sql = sql & " 		and (C.CodCategoria = 1 or C.CodCategoria = 8) "
		'sql = sql & " 		and CS.Situacao = 'A')"
		sql = sql & " ORDER BY 2"
		
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write sql	
	end if
		
		RS.OPEN SQL, CNN
		%>
		<select name="cmbColaboradorFrequencia" id="cmbColaboradorFrequencia" style="width:250pt" class="form-control" <%=strFuncao%> >
			<option value="0">Selecione...</option>
		<%
			if strDataLancamento <> "" then 
				IF RS.EOF = FALSE THEN
					while not rs.eof
						if trim(intCodProfessor) = trim(rs("Codigo")) then
							strSelecionado = " selected"
						else
							strSelecionado = ""
						end if
						response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " - " & ucase(rs("codFuncional")) & "</option> "  & vbcrlf
						rs.movenext
					wend
				END IF
			
			end if
			rs.close
		%>
</select>