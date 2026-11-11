<%
funcao_professor = ""
if funcao_professor_submit = "" then
	funcao_professor = " onchange='submit()' "
end if
sql = "Select distinct c.nome as professor, ha.cod_colaborador"
sql = sql & " From sca_aluno_disciplina ad" 
sql = sql & " left join sca_disciplina d on d.cod_disciplina = ad.cod_disciplina" 
sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO" 
sql = sql & " left join sca_gradecurricular gc on gc.Cod_GradeCurricular = gcd.Cod_GradeCurricular" 
sql = sql & " left join sca_disciplina dr on dr.cod_disciplina = gcd.Cod_Disciplina" 
sql = sql & " left join sca_turma t on t.cod_turma = ad.cod_turma" 
sql = sql & " left join sca_turma tr on tr.cod_turma = ad.COD_TURMA_REMANEJAMENTO" 
sql = sql & " left join SCA_PERIODO p ON p.Cod_Periodo = gc.Cod_Periodo" 
sql = sql & " left join SCA_SITUACAO_PROMOCAO sp ON sp.CODIGO = ad.COD_SITUACAO_ACADEMICA" 
sql = sql & " inner join SCA_HORARIO_AULA ha on ha.Cod_Disciplina = d.Cod_Disciplina and ha.Cod_Empresa = ad.COD_EMPRESA and ha.Cod_turma = t.cod_turma" 
sql = sql & " inner join SRH_COLABORADOR c on c.codigo = ha.cod_colaborador"
sql = sql & " where	ad.cod_aluno = " & Session("CodAluno_GemulEad") 
sql = sql & " and t.cod_turma = " & Session("CodTurma_GemulEad")
sql = sql & " order by c.nome"
rs.open sql, cnn
%>
<select class="form-control" name="cmbProfessor" id="cmbProfessor" <%=funcao_professor%>>
	<option>Selecione...</option>
<% 	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(cod_colaborador) = trim(rs("cod_colaborador")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_colaborador") & " " & strSelecionado &">" & rs("professor") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>			
</select>