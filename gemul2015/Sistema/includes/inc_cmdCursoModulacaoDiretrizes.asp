<%	
	if trim(intCodCursoCombo) = "" then intCodCursoCombo = "0"
	
	sql = "select distinct Cod_curso, Descricao as curso"
	sql = sql & " from SCA_CURSO "
	sql = sql & " where replace(Descricao,' ','_') in	("
	sql = sql & " 					select Curso from SRH_DIRETRIZES_PADRAO"
	sql = sql & " 					where vagas > 0 "
	sql = sql & " 						)"
	sql = sql & " order by 2"
	RS.OPEN SQL, CNN
%>
<select name="cmbCursoCombo" id="cmbCursoCombo" style="width:250pt" class="combo"  <%=strSubmitFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodCursoCombo) = trim(rs("Cod_Curso")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Curso")& " " & strSelecionado &">" & rs("curso") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>