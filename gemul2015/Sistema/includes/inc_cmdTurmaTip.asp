<%
	if strTurma_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodCursoTip="" then intCodCursoTip="0"
	if intCodPeriodoTip="" then intCodPeriodoTip="0"
	if intCodTurnoTip="" then intCodTurnoTip="0"
	if intCodEmpresaTip="" then intCodEmpresaTip="0"
	if isnull(intCodEmpresaTip) then intCodEmpresaTip="0"

	SQL = " select distinct t.cod_turma, p.descricao as periodo, t.NomeTurma, t.TurmaAluno"
	SQL = SQL & " from sca_turma t"
	SQL = SQL & " inner join sca_periodo p on p.cod_periodo = t.cod_periodo"
	SQL = SQL & " inner join SEG_EMPRESA e on e.codigo = t.cod_empresa and e.BLOQUEIO = 'N'"
	SQL = SQL & " where t.anoLetivo = " & strAnoLetivoDestino
	SQL = SQL & " and p.cod_curso = " & intCodCursoTip
	SQL = SQL & " and p.cod_periodo = " & intCodPeriodoTip
	SQL = SQL & " and t.cod_turno = " & intCodTurnoTip
	SQL = SQL & " and t.cod_empresa = " & intCodEmpresaTip
	SQL = SQL & " and t.Situacao = 'A'"
	'verifica vaga
	SQL = SQL & " and (t.capacidade - t.VagasReservadas - ("
	
	SQL = SQL & " select count(*) as qtde"	
	SQL = SQL & " from sca_aluno_turma at inner join sca_turma tu on tu.cod_turma = at.cod_turma"
	SQL = SQL & " where at.ano_letivo = " & strAnoLetivoDestino
	SQL = SQL & " and at.cod_turma = t.cod_turma"
	SQL = SQL & " and at.situacao = 'A'"
	
	SQL = SQL & " )) > 0"
	SQL = SQL & " order by 2,4,3"

	RS.OPEN SQL, CNN,1,3
	%>
	<select name="cmbTurmaTip" id="cmbTurmaTip" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
	<%
    IF RS.EOF = FALSE THEN
        while not rs.eof

            if trim(intCodTurmaTip) = trim(rs("cod_turma")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & rs("periodo") & "&nbsp" & rs("TurmaAluno") & "&nbsp&nbsp" & rs("NomeTurma") & "</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>