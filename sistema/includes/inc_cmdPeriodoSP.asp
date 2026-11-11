<%	
	if strExecutarSubmitPeriodo = "" then
		strPeriodo = ""
	else
		strPeriodo = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"
	
	sql = "EXEC SP_MostraDisponibilidadePeriodo " & intCodEmpresaGrupo & "," & strAnoLetivo & "," & intSemestre & ",'" & strTipoModulacao & "','" &strTipoLancamento& "'," &intCodTurnoColaborador&"," &intCodCursoCombo&"," &intCodFuncao
'response.Write(sql)
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" style="width:250pt" class="combo"  <%=strDisabilitaCombo%> <%=strPeriodo%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		intCodCurso = ""
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
				strSelecionado = " selected"
				strSerie = rs("periodo")
				intCodCurso = rs("Cod_curso")
				funcao = rs("aulasLiberadasDiretriz")
				modulacao = rs("aulasModuladas")
				saldo = rs("saldo")
				if saldo <= 0 then 
					strDesbilitaAulas = "disabled"
					saldo = 0
				end if
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("periodo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>