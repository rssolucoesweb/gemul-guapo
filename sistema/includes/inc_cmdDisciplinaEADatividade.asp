<%	
	if cod_atividade_pai = "" then cod_atividade_pai = 0
	sql = "select d.Cod_Disciplina, d.Desc_Disciplina as disciplina" 
	sql = sql & " from EAD_Atividade_pai a"
	sql = sql & " inner join EAD_Atividade at on at.cod_atividade_pai = a.cod_atividade_pai"
	sql = sql & " inner join SCA_DISCIPLINA d on d.Cod_Disciplina = at.cod_disciplina"
	sql = sql & " where a.cod_atividade_pai = " & cod_atividade_pai
	sql = sql & " order by d.Desc_Disciplina"
	RS.OPEN SQL, CNN
%>
<select name="cmbDisciplina" id="cmbDisciplina" class="form-control" style="width: 100%" onChange="submit()">
	<option value="0">Todas...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodDisciplina) = trim(rs("Cod_Disciplina")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Disciplina")& " " & strSelecionado &">"  & Trim(rs("disciplina")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>