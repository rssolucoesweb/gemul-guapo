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

if intCodTurma="0" or intCodTurma="" then
	%>
	<select name="cmbTurnoDoProfessor" id="cmbTurnoDoProfessor" class="form-control" >
		<option value="0">Selecione...</option>
	</select>
	<%
else	
		
	strFuncao = "onchange='submit()'"
	
	strDataHorarioAulaExtra = strDataInicial

	if intCodSequenciaAula = "" then intCodSequenciaAula = 0
	if intCodTempoAula = "" then intCodTempoAula = 0
	if intCodCurso = "" then intCodCurso = 0
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
		
		IF strCursoSigla = "F2" THEN
			if intCodDisciplina = "" then intCodDisciplina = "0"
			IF intCodTurno = "" THEN intCodTurno = "0"
			sql = "select distinct trh.Cod_Turno, trh.Desc_Turno"
			sql = sql & " from SCA_GRADECURRICULARDISCIPLINA_TURNO gt"
			sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA gd on gd.Cod_GradeCurricularDisciplina = gt.Cod_GradeCurricularDisciplina"
			sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = gd.Cod_GradeCurricular"
			sql = sql & " inner join SCA_TURMA t on t.Cod_GradeCurricular = g.Cod_GradeCurricular"
			sql = sql & " inner join SRH_TURNO trh on trh.Cod_Turno = gt.Cod_TurnoFuncao and trh.Cod_Grupo = " & Session("CodGrupo")
			sql = sql & " where t.Cod_Turma = " & intCodTurma
			sql = sql & " and gd.Cod_Disciplina = " & intCodDisciplina
			
		ELSE

			sql = "select distinct trh.Cod_Turno, trh.Desc_Turno "
			sql = sql & " from SRH_DIRETRIZES m "
			sql = sql & " inner join SRH_TURNO trh on trh.Cod_Turno = m.cod_Turno"
			sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turno = m.Cod_turno_turma"
			sql = sql & " where tu.cod_turma = " & intCodTurma
			sql = sql & " union "
			sql = sql & " SELECT distinct tu.Cod_Turno, TU.DESC_TURNO AS DESC_TURNO "
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
			sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = GCDT.cod_TurnoFuncao "  
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
			sql = sql & " inner join SCA_TURMA t on t.Cod_GradeCurricular = GCD.Cod_GradeCurricular"
			sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao "
			sql = sql & " WHERE t.cod_turma = " & intCodTurma
			sql = sql & " and ISNULL(GCDT.Cod_Funcao,'0')<> '0' "
			sql = sql & " and FC.TIPO_FUNCAO = 'PROFESSOR' "
			sql = sql & " order by 2" 
			
			
		END IF
	else
		
		sql = "select cod_turno, desc_turno from sca_turno"
		sql = sql & " Order by 2 " 
	end if

	RS.OPEN SQL, CNN,3,1
	if strOpcaoDesvinculaConteudo="1" and strTurnoSelecionado="INTEGRAL" then
		intCodTurno = intCodTurnoCombo
	end if
	%>
	<select name="cmbTurnoDoProfessor" id="cmbTurnoDoProfessor"  class="form-control" <%=strFuncao%>>
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
