<%	
	if strExecutarSubmitColaboradorFrequencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodModulacaoReferencia = "0" or intCodJustificativaFaltas = "0" or strDataLancamento = "" then 
		%>
		<select name="cmbColaborador" id="cmbColaborador" style="width:250pt"  class="form-control">
			<option value="0">Selecione...</option>
		</select>	
		<%
	else
	
		sql = " select DISTINCT  C.codigo, C.nome, C.codFuncional, F.modular, C.codFuncao, C.codTurno"
		sql = sql & " from SRH_COLABORADOR C "
		sql = sql & " inner JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.codFuncao "
		sql = sql & " where C.codlotacao = " & Session("CodEmpresa") & " and C.situacao = 'A' "
		sql = sql & " and (C.CodCategoria = 2 or C.CodCategoria = 8)"
		sql = sql & " and F.modular = 'N'"
		sql = sql & " union"
		sql = sql & " select DISTINCT  C.codigo, C.nome, C.codFuncional, F.modular, C.codFuncao, C.codTurno"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M "
		sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR "
		sql = sql & " inner JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.codFuncao "
		sql = sql & " where M.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and M.Status = 'A' "
		sql = sql & " and C.situacao = 'A' "
		sql = sql & " and F.modular = 'S'"
		sql = sql & " and m.tipoModulacao = 'FUNCIONARIO'"
		sql = sql & " ORDER BY 2"
		RS.OPEN SQL, CNN
		strCodFuncaoFuncionario = ""
		%>
		<select name="cmbColaborador" id="cmbColaborador" style="width:250pt"  class="form-control" <%=strFuncao%> >
			<option value="0">Selecione...</option>
			<%
			if strDataLancamento <> "" then 
				IF RS.EOF = FALSE THEN
					while not rs.eof
						if trim(intCodColaborador) = trim(rs("Codigo")) then
							strSelecionado = " selected"
							strCodFuncaoFuncionario = rs("codFuncao")
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
		<%
	end if
%>