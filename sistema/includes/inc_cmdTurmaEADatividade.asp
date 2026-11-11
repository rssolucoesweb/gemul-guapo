<%	
	if cod_atividade_pai = "" then cod_atividade_pai = 0
	sql = "select distinct tu.Cod_Turma, tu.TurmaAluno as turma, tu.NomeTurma" 
	sql = sql & " from EAD_Atividade_pai a"
	sql = sql & " inner join EAD_Atividade at on at.cod_atividade_pai = a.cod_atividade_pai"
	sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turma = at.cod_turma"
	sql = sql & " where a.cod_atividade_pai = " & cod_atividade_pai
	sql = sql & " order by tu.TurmaAluno"
	RS.OPEN SQL, CNN
%>
<select name="cmbTurma" id="cmbTurma" class="form-control"  style="width: 100%" onChange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurma) = trim(rs("cod_turma")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">"  & Trim(rs("turma")& " " & rs("NomeTurma")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>