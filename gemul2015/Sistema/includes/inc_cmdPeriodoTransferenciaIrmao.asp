<%	
	if strExecutarSubmitPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT distinct p.Descricao, p.sequencia"
	sql = sql & " FROM SCA_PERIODO p"
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
	sql = sql & " where c.descricao = '" & replace(trim(strCursoAlunoIrmao),"_"," ") & "'" 
	sql = sql & " AND P.DESCRICAO IN ('AGRUPAMENTO I','AGRUPAMENTO II','AGRUPAMENTO III','AGRUPAMENTO IV','AGRUPAMENTO V','1º ANO','2º ANO','3º ANO','4º ANO','5º ANO','6º ANO','7º ANO','8º ANO','9º ANO')"
	sql = sql & " Order by p.sequencia, p.Descricao"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodoIrmao<%=i%>" id="cmbPeriodoIrmao<%=i%>" style="width:250pt" class="combo"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if replace(trim(strPeriodoAlunoIrmao)," ","_") = replace(trim(rs("descricao"))," ","_") then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & replace(rs("descricao")," ","_") & " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>