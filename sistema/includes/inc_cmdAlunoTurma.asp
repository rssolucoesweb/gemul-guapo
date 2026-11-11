<%
	if  strExecutarSubmitAlunoTurma <> "" then
		strExecutarSubmitAlunoTurma = "onchange='submit()'"
	end if
	
	sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA, SCA_ALUNO.CODIGO, SCA_ALUNO.NOMEALUNO "
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO"
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & cod_turma	
	sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
	sql = sql & " And   SCA_SITUACAOALUNO.Desc_SituacaoAluno = 'ATIVO'"
	sql = sql & " order by SCA_ALUNO.NOMEALUNO"
	RS.OPEN SQL, CNN
%>
<select name="cmbAlunoTurma" id="cmbAlunoTurma" class="form-control" <%=strExecutarSubmitAlunoTurma%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_aluno) = trim(rs("codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">"  & Trim(ucase(rs("NOMEALUNO"))) & "</option>"
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
