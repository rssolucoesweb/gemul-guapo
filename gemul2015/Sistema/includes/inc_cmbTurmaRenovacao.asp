<%	
	if strExecutarSubmitTurma = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if trim(intCodPeriodo) = "" then intCodPeriodo = "0"
	
	sql = "SELECT Cod_turma as codigo, NomeTurma + ' - ' + TurmaAluno as nome"
	sql = sql & " FROM SCA_TURMA"
	sql = sql & " where cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and cod_periodo = " & intCodPeriodo
	if intCodTurnoRenovacao<>"" then
		sql = sql & " and cod_turno = " & intCodTurnoRenovacao
	end if
	
	sql = sql & " and anoLetivo = " & strAnoLetivoRenovacao
	sql = sql & " and situacao = 'A'"
	sql = sql & " Order by 2"

	RS.OPEN SQL, CNN
%>
<select name="cmbTurma<%=strCodigoAluno%>" id="cmbTurma<%=strCodigoAluno%>" style="width:130pt" class="combo" onchange="mostraVagas(this.value,<%=strCodigoAluno%>)">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurma) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("nome") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>