<%	
	if strExecutarSubmitPeriodo = "" then
		strPeriodo = ""
	else
		strPeriodo = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"
	
	sql = "select distinct p.Cod_Periodo, c.Cod_curso, p.Descricao as periodo"
	sql = sql & " from SCA_PERIODO p"
	sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_Curso and c.cod_empresa = p.cod_empresa"
	sql = sql & " where p.Cod_Empresa = " & intCodEmpresaGrupo 
	if intCodCursoFuncao <> "" then
	sql = sql & " and c.cod_curso = " & intCodCursoFuncao
	end if
	sql = sql & " and replace(c.Descricao,' ','_') in	("
	sql = sql & " 					select Curso from SRH_DIRETRIZES_PADRAO"
	sql = sql & " 					where vagas > 0 and Cod_funcao = " & intCodFuncao
	sql = sql & " 						)"
	sql = sql & " order by 2"
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