<%	
	if strExecutarSubmitCurso = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if strAnoLetivo = "" then strAnoLetivo = year(date)
	
	sql = "select distinct c.Cod_curso, c.Descricao, c.Sigla"
	sql = sql & " from SCA_CURSO c"
	sql = sql & " inner join SCA_periodo pe on pe.Cod_Curso = c.Cod_curso"
	sql = sql & " inner join SCA_TURMA tu on tu.Cod_periodo = pe.Cod_Periodo"
	sql = sql & " inner join SCA_HORARIO_AULA ha on ha.AnoLetivo = tu.AnoLetivo and ha.Cod_Empresa = tu.Cod_Empresa and ha.Cod_turma = tu.Cod_Turma"
	sql = sql & " where tu.AnoLetivo = " & strAnoLetivo
	sql = sql & " and tu.Situacao = 'A'"
	sql = sql & " and tu.Cod_Empresa = " & session("codEmpresa")
	sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor
	sql = sql & " Order by c.Descricao"
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
			response.write "<option value=" & rs("Cod_curso")& " " & strSelecionado &">" & rs("Sigla") & "-" &  rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>