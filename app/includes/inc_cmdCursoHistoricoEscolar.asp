<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT Cod_curso, Descricao"
	sql = sql & " FROM SCA_CURSO"
	SQL = SQL & " WHERE Situacao = 'A' "
	if intCodEmpresaGrupo<>"0" AND intCodEmpresaGrupo<>"" then
		SQL = SQL & " AND COD_CURSO IN (SELECT distinct p.Cod_Curso FROM MAT_escola_periodo_turno e inner join SCA_PERIODO p on p.Cod_Periodo = e.cod_periodo WHERE e.cod_empresa = " &intCodEmpresaGrupo& ")"
	end if
	sql = sql & " Order by Cod_curso"

	RS.OPEN SQL, CNN
%>

<select name="cmbCurso" id="cmbCurso" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCurso) = trim(rs("Cod_curso")) then
				strSelecionado = " selected"
				strCurso = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_curso")& " " & strSelecionado &">" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
	<option <%if intCodCurso="999999" or isnull(intCodCurso) then %> selected <%end if%> value="999999">OUTROS CURSOS</option>
</select>