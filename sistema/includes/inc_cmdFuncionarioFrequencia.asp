<%	
	if strExecutarSubmitColaboradorFrequencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodModulacaoReferencia = "0" then 
		%>
		<select name="cmbColaborador" id="cmbColaborador" style="width:250pt"  class="form-control">
			<option value="0">Selecione...</option>
		</select>	
		<%
	else
	
		sql = " select DISTINCT  C.codigo, C.nome, C.codFuncional, F.modular, C.codFuncao, C.codTurno"
		sql = sql & " from SRH_COLABORADOR C "
		sql = sql & " inner JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.codFuncao "
		sql = sql & " where 1=1"
		if filtroDiretor = "" then
			sql = sql & " and C.codlotacao = " & Session("CodEmpresa")
			sql = sql & " and (C.CodCategoria = 2 or C.CodCategoria = 8)"
		else
			sql = sql & " and C.codFuncao = 1"
		end if
		sql = sql & " and C.situacao = 'A' "

		sql = sql & " union"
		sql = sql & " select DISTINCT C.codigo, C.nome + ' (sub)' as nome, C.codFuncional, '' as modular, C.codFuncao, C.codTurno"
		sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CS"
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = CS.CodColaboradorSubstituto"
		sql = sql & " where CS.CodEmpresaSubstituido = " & Session("CodEmpresa")
		'sql = sql & " and C.situacao = 'A' "
		sql = sql & " and CS.Situacao = 'A'"
		sql = sql & " and "
		sql = sql & " 	("
		sql = sql & " 		( convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) <= convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) >= convert(datetime, '" & strDataFinalModulacao & "',103) )"
		sql = sql & " 		or "  
		sql = sql & " 		( convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) <= convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime,convert(varchar, CS.DATAFINAL , 103),103) between convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime, '" & strDataFinalModulacao & "',103)  )"
		sql = sql & " 		or " 
		sql = sql & " 		( convert(datetime,convert(varchar, CS.DATAFINAL , 103),103) >= convert(datetime, '" & strDataFinalModulacao & "',103) and convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) between convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime, '" & strDataFinalModulacao & "',103)  )"
		sql = sql & " 		or "
		sql = sql & " 		( convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) >= convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) <= convert(datetime, '" & strDataFinalModulacao & "',103) )"
		sql = sql & " 	)"
		sql = sql & " union"
		sql = sql & " select DISTINCT  C.codigo, C.nome, C.codFuncional, F.modular, C.codFuncao, C.codTurno"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M "
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR "
		sql = sql & " inner JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = M.Cod_Funcao "
		sql = sql & " where 1=1"
		if filtroDiretor = "" then
			sql = sql & " and M.cod_empresa = " & Session("CodEmpresa")
		else
			sql = sql & " and M.Cod_Funcao = 1671"
		end if
		'sql = sql & " and M.Status = 'A' "
		sql = sql & " and C.situacao = 'A' "
		
		sql = sql & " and "
		sql = sql & " 	("
		sql = sql & " 		( convert(datetime,convert(varchar, M.DATAINICIAL , 103),103) <= convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime,convert(varchar, M.DATAFINAL, 103),103) >= convert(datetime, '" & strDataFinalModulacao & "',103) )"
		sql = sql & " 		or "  
		sql = sql & " 		( convert(datetime,convert(varchar, M.DATAINICIAL , 103),103) <= convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime,convert(varchar, M.DATAFINAL , 103),103) between convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime, '" & strDataFinalModulacao & "',103)  )"
		sql = sql & " 		or " 
		sql = sql & " 		( convert(datetime,convert(varchar, M.DATAFINAL , 103),103) >= convert(datetime, '" & strDataFinalModulacao & "',103) and convert(datetime,convert(varchar, M.DATAINICIAL , 103),103) between convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime, '" & strDataFinalModulacao & "',103)  )"
		sql = sql & " 		or "
		sql = sql & " 		( convert(datetime,convert(varchar, M.DATAINICIAL , 103),103) >= convert(datetime, '" & strDataInicialModulacao & "',103) and convert(datetime,convert(varchar, M.DATAFINAL, 103),103) <= convert(datetime, '" & strDataFinalModulacao & "',103) )"
		sql = sql & " 	)"
		sql = sql & " ORDER BY 2"
		'response.write sql
		RS.OPEN SQL, CNN
		strCodFuncaoFuncionario = ""
		%>
		<select name="cmbColaborador" id="cmbColaborador" style="width:250pt"  class="form-control" <%=strFuncao%> >
			<option value="0">Selecione...</option>
			<%
			IF RS.EOF = FALSE THEN
				while not rs.eof
					if trim(intCodColaborador) = trim(rs("Codigo")) then
						strSelecionado = " selected"
						strCodFuncaoFuncionario = rs("codFuncao")
						intCodTurnoFaltas		= rs("codTurno")
					else
						strSelecionado = ""
					end if
					response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " - " & ucase(rs("codFuncional")) & "</option> "  & vbcrlf
					rs.movenext
				wend
			END IF
			rs.close
			%>
		</select>
		<%
	end if
%>