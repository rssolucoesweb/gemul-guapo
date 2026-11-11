<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 31/03/2016
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina do horario de aula
-->
<%
if ucase(trim(session("usuarioweb"))) = "SERGIO" then 
	'response.write "intCodTurno:" & intCodTurno
end if

if intCodTurmaProfessor="0" or intCodTurmaProfessor="" then
	%>
	<select name="cmbTurnoRH" id="cmbTurnoRH" class="combo"  style="width:250pt">
		<option value="0">Selecione...</option>
	</select>
	<%
else	
		
	strFuncao = "onchange='submit()'"
	
	strDataHorarioAulaExtra = strDataInicial

	if intCodSequenciaAula = "" then intCodSequenciaAula = 0
	if intCodTempoAula = "" then intCodTempoAula = 0
	if intCodCurso = "" then intCodCurso = 0
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodTurma = "" then intCodTurma = "0"
    if strOpcaoDesvinculaConteudo = "" then strOpcaoDesvinculaConteudo = "0"

	strCpfTurmaProfessor = ""
    sql = " Select ISNULL(CPF,'') AS CPF"
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo = " & intCodColaboradorProfessor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs1.open sql, cnn
	if rs1.eof = false then
		strCpfTurmaProfessor = TRIM(rs1("CPF"))
	end if
	rs1.close

	strTurnoSelecionado = ""
    sql = " Select DESC_TURNO "
	sql = sql & " from SRH_TURNO "
	sql = sql & " where Cod_Turno = " & intCodTurno
	rs1.open sql, cnn
	if rs1.eof = false then
		strTurnoSelecionado = TRIM(rs1("DESC_TURNO"))
	end if
	rs1.close
	
    if strOpcaoDesvinculaConteudo = "0" then
		if strTurnoDaTurma = "INTEGRAL" then
			sql = " select distinct trh.Cod_Turno, trh.Desc_Turno" 
			sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO m" 
			sql = sql & " inner join SCA_TURMA t on t.cod_turma = m.cod_turma" 
			sql = sql & " inner join SRH_TURNO trh on trh.Cod_Turno = m.cod_TurnoFuncao and trh.Cod_Grupo = " & Session("CodGrupo") 
			sql = sql & " where m.cod_turma = " & intCodTurmaProfessor 
			sql = sql & " union"
			sql = sql & " select distinct trh.Cod_Turno, trh.Desc_Turno" 
			sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO m" 
			sql = sql & " inner join SCA_TURMA t on t.cod_turma = m.cod_turma" 
			sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = t.Cod_GradeCurricular"
			sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA gd on gd.Cod_GradeCurricular = g.Cod_GradeCurricular"
			sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA_TURNO gdt on gdt.Cod_GradeCurricularDisciplina = gd.Cod_GradeCurricularDisciplina"
			sql = sql & " inner join SRH_TURNO trh on trh.Cod_Turno = gdt.cod_TurnoFuncao and trh.Cod_Grupo = " & Session("CodGrupo")
			sql = sql & " where m.cod_turma = " & intCodTurmaProfessor 
			sql = sql & " order by trh.Desc_Turno"
		else		
			IF strCursoSigla = "F2" THEN
				if intCodDisciplina = "" then intCodDisciplina = "0"
				IF intCodTurno = "" THEN intCodTurno = "0"
				sql = "select distinct trh.Cod_Turno, trh.Desc_Turno"
				sql = sql & " from SCA_GRADECURRICULARDISCIPLINA_TURNO gt"
				sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA gd on gd.Cod_GradeCurricularDisciplina = gt.Cod_GradeCurricularDisciplina"
				sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = gd.Cod_GradeCurricular"
				sql = sql & " inner join SCA_TURMA t on t.Cod_GradeCurricular = g.Cod_GradeCurricular"
				sql = sql & " inner join SRH_TURNO trh on trh.Cod_Turno = gt.Cod_TurnoFuncao and trh.Cod_Grupo = " & Session("CodGrupo")
				sql = sql & " where t.Cod_Turma = " & intCodTurmaProfessor
				sql = sql & " and gd.Cod_Disciplina = " & intCodDisciplina
				'if strTurnoSelecionado<>"INTEGRAL" then
				'	sql = sql & " and trh.Cod_Turno = " & intCodTurno
				'end if
			ELSE
				sql = "select distinct trh.Cod_Turno, trh.Desc_Turno"
				sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO m"
				sql = sql & " inner join SCA_TURMA t on t.cod_turma = m.cod_turma"
				sql = sql & " inner join SRH_TURNO trh on trh.Cod_Turno = m.cod_TurnoFuncao and trh.Cod_Grupo = " & Session("CodGrupo")
				'sql = sql & " inner join SCA_TURNO tu on tu.Desc_Turno = trh.Desc_Turno and tu.Cod_Empresa = t.Cod_Empresa"
				sql = sql & " where m.cod_turma = " & intCodTurmaProfessor
				sql = sql & " order by trh.Desc_Turno"
			END IF
		end if
		'strTemDificitNaTurma = "N"
		'sql = "select count(*) as temDeficit"
		'sql = sql & " from SCA_HORARIO_AULA" 
		'sql = sql & " where cod_turma = " & intCodTurmaProfessor
		'sql = sql & " and cod_colaborador = 0"
		'rs1.open sql, cnn
		'if rs1.eof = false then
		'	if rs1("temDeficit")>0 then
		'		strTemDificitNaTurma = "S"
		'	end if
		'end if
		'rs1.close
		'strTemDificitNaTurma = "N"
		'if strTemDificitNaTurma = "S" then
		'	sql = "select distinct H.codturno as COD_TURNO, turSCA.DESC_TURNO"
		'	sql = sql & " from SCA_HORARIO_AULA HA"
		'	sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
		'	sql = sql & " INNER JOIN SCA_turno turSCA ON turSCA.COD_EMPRESA=HA.COD_EMPRESA AND turSCA.COD_turno=H.codturno"
		'	sql = sql & " where HA.cod_turma = " & intCodTurmaProfessor
		'	sql = sql & " and HA.cod_colaborador = 0"
		'else
		'	sql = "SELECT Distinct M.COD_TURNO, T.DESC_TURNO"
		'	sql = sql & " FROM SCA_HORARIO_AULA HA"
		'	sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = HA.cod_colaborador AND M.Ano_Letivo = HA.AnoLetivo AND M.Semestre = HA.Semestre"
		'	sql = sql & " INNER JOIN SRH_TURNO T ON T.COD_TURNO = M.COD_TURNO"
		'	sql = sql & " WHERE HA.ANOLETIVO = " & strAnoLetivo
		'	sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
		'	if 	strVerificaTurmaProfessor	= "Professor" then
		'		sql = sql & " AND HA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
		'		sql = sql & " and m.cod_empresa = " & Session("CodEmpresa")
		'	end if		
		'	sql = sql & " AND HA.cod_turma = " & intCodTurmaProfessor
		'	if strDataHorarioAulaExtra <> "" then
		'		sql = sql & " UNION "
		'		sql = sql & " SELECT Distinct M.COD_TURNO, T.DESC_TURNO"
		'		sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA"
		'		sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = HA.cod_colaborador AND M.Ano_Letivo = HA.AnoLetivo AND M.Semestre = HA.Semestre"
		'		sql = sql & " INNER JOIN SRH_TURNO T ON T.COD_TURNO = M.COD_TURNO"
		'		sql = sql & " WHERE HA.ANOLETIVO = " & strAnoLetivo
		'		sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
		'		if 	strVerificaTurmaProfessor	= "Professor" then
		'			sql = sql & " AND HA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
		'			sql = sql & " and m.cod_empresa = " & Session("CodEmpresa")
		'		end if		
		'		sql = sql & " AND HA.DataLancamento = '" & formatadataBD(strDataHorarioAulaExtra) & "' " 
		'		sql = sql & " AND HA.cod_turma = " & intCodTurmaProfessor
		'		sql = sql & " Order by T.DESC_TURNO"
		'	else	
		'		sql = sql & " Order by T.DESC_TURNO"
		'	end if
		'end if
	else
		
		sql = "select cod_turno, desc_turno from sca_turno"
		sql = sql & " where cod_empresa =" & Session("CodEmpresa")	
		sql = sql & " Order by 2 " 
	end if

	if ucase(trim(session("usuarioweb"))) = "SERGIO" then 
		'response.write sql
	end if

	
	RS.OPEN SQL, CNN,3,1
	if strOpcaoDesvinculaConteudo="1" and strTurnoSelecionado="INTEGRAL" then
		intCodTurno = intCodTurnoCombo
	end if
	%>
	<select name="cmbTurnoRH" id="cmbTurnoRH" style="width:250pt" class="combo" <%=strFuncao%>>
		<option value="0">Selecione...</option>
		<%
        IF RS.EOF = FALSE THEN
            qtdeRegistro = RS.recordCount		
        
            while not rs.eof
                if trim(intCodTurno) = trim(rs("cod_turno")) then
                    strSelecionado = "selected"
                else
                    strSelecionado = ""
                end if
                if qtdeRegistro = "1" then
                    intCodTurno = rs("cod_turno")
                    strSelecionado = " selected"
                    strEncontrou = "S"
                end if			
                
                response.write "<option value=" & rs("cod_turno")& " " & strSelecionado &">" & rs("desc_turno") & "</option> "  & vbcrlf
                rs.movenext
            wend
        END IF
        rs.close
        %>
	</select>
<%
end if
%>
