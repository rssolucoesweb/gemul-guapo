<%
	if strTurma_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodCursoTip="" then intCodCursoTip="0"
	if intCodPeriodoTip="" then intCodPeriodoTip="0"
	if intCodTurno="" then intCodTurno="0"
	if intCodEmpresa="" then intCodEmpresa="0"
	if isnull(intCodEmpresa) then intCodEmpresa="0"

	'Vagas = capacidade - reservadas - alunos ativos na turma (ano de destino)
	'        - TIP pendentes para a turma (a vaga fica reservada desde a inclusão da TIP)
	'        - novatos alocados aguardando efetivação (mat_reserva)
	SQL = " select t.cod_turma, p.descricao as periodo, t.NomeTurma, t.TurmaAluno, v.vagas"
	SQL = SQL & " from sca_turma t"
	SQL = SQL & " inner join sca_periodo p on p.cod_periodo = t.cod_periodo"
	SQL = SQL & " inner join SEG_EMPRESA e on e.codigo = t.cod_empresa and e.BLOQUEIO = 'N'"
	SQL = SQL & " cross apply (select isnull(t.capacidade,0) - isnull(t.VagasReservadas,0)"
	SQL = SQL & "   - (select count(*) from sca_aluno_turma at where at.ano_letivo = " & clng(strAnoLetivoDestino) & " and at.cod_turma = t.cod_turma and at.situacao = 'A')"
	SQL = SQL & "   - (select count(*) from SCA_TRANSFERENCIA_INTERESSE_PROPRIO tip where tip.COD_TURMA_DESTINO = t.cod_turma and tip.SITUACAO = 'P')"
	SQL = SQL & "   - (select count(*) from MAT_reserva r where r.data_exc_cadastro is null and r.ano = t.AnoLetivo and r.cod_empresa_efetivado is not null"
	SQL = SQL & "      and r.cod_aluno is null and r.Cod_turma_efetivado = t.cod_turma)"
	SQL = SQL & "   as vagas) v"
	SQL = SQL & " where t.anoLetivo = " & clng(strAnoLetivoDestino)
	SQL = SQL & " and p.cod_curso = " & clng(intCodCursoTip)
	SQL = SQL & " and p.cod_periodo = " & clng(intCodPeriodoTip)
	if intCodTurno <> "0" then
		SQL = SQL & " and t.cod_turno = " & clng(intCodTurno)
	end if
	SQL = SQL & " and t.cod_empresa = " & clng(intCodEmpresa)
	SQL = SQL & " and t.Situacao = 'A'"
	SQL = SQL & " and v.vagas > 0"	'só turmas com vaga
	SQL = SQL & " order by 2,4,3"

	RS.OPEN SQL, CNN,1,3
	%>
	<select name="cmbTurma" id="cmbTurma" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
	<%
    IF RS.EOF = FALSE THEN
        while not rs.eof

            if trim(intCodTurma) = trim(rs("cod_turma")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("cod_turma")& " " & strSelecionado &">" & rs("periodo") & "&nbsp" & rs("TurmaAluno") & "&nbsp&nbsp" & rs("NomeTurma") & "&nbsp&nbsp" & rs("vagas") & "&nbspvaga(s)</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>