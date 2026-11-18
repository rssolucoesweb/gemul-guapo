<%
	'Curso de DESTINO da TIP: só o do de/para (includes/inc_tipDePara.asp) a partir do período atual do aluno
	'(intCodPeriodo vem de includes/inc_sqlDadosAluno.asp)
	strTipSemDestino = ""
	vetTipDePara = ""
	if trim(intCodAluno & "") <> "" and trim(intCodAluno & "") <> "0" then
		vetTipDePara = tipDePara(intCodPeriodo)
		if not isArray(vetTipDePara) then
			strTipSemDestino = "S"
			retira_incluir = "S"
		else
			'um único destino possível: já vem selecionado (filtra unidade e turma)
			intCodCursoTip = cstr(vetTipDePara(0))
			intCodPeriodoTip = cstr(vetTipDePara(1))
		end if
	end if
	if strTipSemDestino = "S" or not isArray(vetTipDePara) then
		intCodCursoTip = "0"
		intCodPeriodoTip = "0"
	end if
	sql = "SELECT Cod_curso, Descricao, Sigla FROM SCA_CURSO"
	sql = sql & " WHERE Situacao = 'A' AND Cod_curso = " & clng(intCodCursoTip)
	RS.OPEN SQL, CNN
%>
<select name="cmbCurso" id="cmbCurso" class="form-control">
<%
	IF RS.EOF = FALSE THEN
		strCurso = rs("Descricao")
		response.write "<option value=" & rs("Cod_curso") & " selected>" & rs("Sigla") & "-" & rs("Descricao") & "</option>" & vbcrlf
	ELSE
		response.write "<option value=""0"">Selecione...</option>" & vbcrlf
	END IF
	rs.close
%>
</select>
<%if strTipSemDestino = "S" then%>
<div class="text-danger mt-1"><small><i class="fal fa-ban"></i> Não há TIP para o período atual do aluno (<%=tipDescPeriodo(intCodPeriodo)%>).</small></div>
<%end if%>
