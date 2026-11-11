<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 31/03/2016
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Disciplina do horario de aula
-->
<%
if ucase(trim(session("usuarioweb"))) = "SERGIO" then 
				'response.write "intCodTurma:" & intCodTurma
			end if

if intCodTurma="0" or intCodTurma="" then
		%>
		<select name="cmbTurnoDoProfessor" id="cmbTurnoDoProfessor" class="combo"  style="width:250pt">
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
		sql = "SELECT Distinct M.COD_TURNO, T.DESC_TURNO"
		sql = sql & " FROM SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = HA.cod_colaborador AND M.Ano_Letivo = HA.AnoLetivo AND M.Semestre = HA.Semestre"
		sql = sql & " INNER JOIN SRH_TURNO T ON T.COD_TURNO = M.COD_TURNO"
		sql = sql & " WHERE HA.ANOLETIVO = " & strAnoLetivo
		sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
		if 	strVerificaTurmaProfessor	= "Professor" then
			sql = sql & " AND HA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
		end if		
		sql = sql & " AND HA.cod_turma = " & intCodTurma
			
		if strDataHorarioAulaExtra <> "" then
			'
			sql = sql & " UNION "
			sql = sql & " SELECT Distinct M.COD_TURNO, T.DESC_TURNO"
			sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA"
			sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = HA.cod_colaborador AND M.Ano_Letivo = HA.AnoLetivo AND M.Semestre = HA.Semestre"
			sql = sql & " INNER JOIN SRH_TURNO T ON T.COD_TURNO = M.COD_TURNO"
			sql = sql & " WHERE HA.ANOLETIVO = " & strAnoLetivo
			sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
			if 	strVerificaTurmaProfessor	= "Professor" then
				sql = sql & " AND HA.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
			end if		
			sql = sql & " AND HA.DataLancamento = '" & formatadataBD(strDataHorarioAulaExtra) & "' " 
			sql = sql & " AND HA.cod_turma = " & intCodTurma
			sql = sql & " Order by T.DESC_TURNO"
		else	
			sql = sql & " Order by T.DESC_TURNO"
		end if

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
	<select name="cmbTurnoDoProfessor" id="cmbTurnoDoProfessor" style="width:250pt" class="combo" <%=strFuncao%>>
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
