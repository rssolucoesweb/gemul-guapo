<%
	'Período de DESTINO da TIP: só o do de/para (definido em inc_cmbCursoTip.asp)
	if trim(intCodPeriodoTip & "") = "" then intCodPeriodoTip = "0"
	sql = "SELECT Cod_Periodo, Descricao FROM SCA_PERIODO"
	sql = sql & " WHERE Cod_Periodo = " & clng(intCodPeriodoTip) & " AND Cod_Curso = " & clng("0" & intCodCursoTip)
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" class="form-control">
<%
	IF RS.EOF = FALSE THEN
		strSerie = rs("Descricao")
		response.write "<option value=" & rs("Cod_Periodo") & " selected>" & rs("Descricao") & "</option>" & vbcrlf
	ELSE
		response.write "<option value=""0"">Selecione...</option>" & vbcrlf
	END IF
	rs.close
%>
</select>
