<%	
	strFuncao = "onchange='submit()'"
	
	strDataAP = formataDataAP(date)
	marcouSubstituicao = ""
	
	if Session("CodGrupo") = "" then Session("CodGrupo") = 0
		
	sql = " Select distinct C.codigo, C.nome, C.codigo_SEG_USUARIOS_SISTEMA, C.codFuncional, M.Cod_empresa"
	sql = sql & " From SRH_COLABORADOR C "
	sql = sql & " inner join SRH_MODULACAO_DISCIPLINAR_DOCENTE M on M.Cod_Colaborador = C.CODIGO"
	sql = sql & " Where C.cpf  = '" & Session("cpfColaborador") & "'"
	sql = sql & " AND M.Status = 'A' "
	sql = sql & " and C.SITUACAO='A' "
	
	sql = sql & " UNION"
	
	sql = sql & " Select distinct C.codigo, C.nome, C.codigo_SEG_USUARIOS_SISTEMA, C.codFuncional, C.CODLOTACAO AS Cod_empresa"
	sql = sql & " From SRH_COLABORADOR C "
	sql = sql & " Where C.cpf  = '" & Session("cpfColaborador") & "'"
	sql = sql & " and C.SITUACAO='A' "
	
	sql = sql & " ORDER BY 2"

	'response.write sql
	RS.OPEN SQL, CNN
	%>
<div class="school-select">
	<h3><i class="fa-solid fa-magnifying-glass"></i> Selecione o contrato </h3><br>	
	<select name="cmbContratoAcesso" id="cmbContratoAcesso" style="width:100%" <%=strFuncao%> >
		<%
		IF RS.EOF = FALSE THEN
			while not rs.eof
	
				if trim(intContratoAcesso) = trim(rs("codigo")) then
					strSelecionado = " selected"
					Session("Seg_CodColaborador") = rs("codigo")
				else
					strSelecionado = ""
				end if
				response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " (" & ucase(rs("codFuncional")) & ")</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
		rs.close
	%>
</select>
</div>