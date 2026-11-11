<%	
	
	if strExecutarSubmitAluno = "S" then
		strExecutarSubmitAluno = "onchange='submit()'"
	else
		strExecutarSubmitAluno = ""
	end if
	
	sql = "SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.NOMEALUNO "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " inner join SCA_ALUNO_ANO_LETIVO on SCA_ALUNO_ANO_LETIVO.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO and SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO_ANO_LETIVO.COD_EMPRESA"
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO_ANO_LETIVO.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.cod_empresa = SCA_ALUNO_ANO_LETIVO.cod_empresa and SCA_TURMA.AnoLetivo = SCA_ALUNO_ANO_LETIVO.ANO_LETIVO"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
 	sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
	sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
	if intCodSituacaoAluno <> "0" then
		sql = sql & " And   SCA_SITUACAOALUNO.DESC_SITUACAOALUNO = 'ATIVO'"
	end if
	sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	'response.write sql
	
	RS.OPEN SQL, CNN
%>
<select name="cmbAluno" id="cmbAluno" class="form-control" <%=strExecutarSubmitAluno%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodAluno) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & rs("NOMEALUNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>