<%
	if strEmpresa_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodTurno = "" then intCodTurno = "0"
	if intCodCursoTip = "" then intCodCursoTip = "0"
	if intCodPeriodoTip = "" then intCodPeriodoTip = "0"
	SQL = " select distinct e.codigo as cod_empresa , replace(e.RAZAOSOCIAL,'CENTRO MUNICIPAL DE EDUCAÇÃO INFANTIL','CMEI') as empresa, e.bairro"
	SQL = SQL & " from sca_turma t"
	SQL = SQL & " inner join sca_periodo p on p.cod_periodo = t.cod_periodo"
	SQL = SQL & " inner join SEG_EMPRESA e on e.codigo = t.cod_empresa and e.BLOQUEIO = 'N'"
	SQL = SQL & " where t.anoLetivo = " & strAnoLetivoDestino
	SQL = SQL & " and t.cod_empresa <> " & Session("CodEmpresa")	'a unidade atual não é destino de TIP
	if intCodCursoTip <> "0" then
		SQL = SQL & " and p.cod_curso = " & intCodCursoTip
	end if
	if intCodPeriodoTip <> "0" then
		SQL = SQL & " and p.cod_periodo = " & intCodPeriodoTip
	end if
	if intCodTurno <> "0" then
		SQL = SQL & " and t.cod_turno = " & intCodTurno
	end if
	SQL = SQL & " and t.Situacao = 'A'"
	'verifica vaga: mesma conta da combo de turma (includes/inc_cmbTurmaTip.asp),
	'descontando também TIP pendentes e novatos alocados aguardando efetivação
	SQL = SQL & " and (isnull(t.capacidade,0) - isnull(t.VagasReservadas,0)"
	SQL = SQL & "   - (select count(*) from sca_aluno_turma at where at.ano_letivo = " & clng(strAnoLetivoDestino) & " and at.cod_turma = t.cod_turma and at.situacao = 'A')"
	SQL = SQL & "   - (select count(*) from SCA_TRANSFERENCIA_INTERESSE_PROPRIO tip where tip.COD_TURMA_DESTINO = t.cod_turma and tip.SITUACAO = 'P')"
	SQL = SQL & "   - (select count(*) from MAT_reserva r where r.data_exc_cadastro is null and r.ano = t.AnoLetivo and r.cod_empresa_efetivado is not null"
	SQL = SQL & "      and r.cod_aluno is null and r.Cod_turma_efetivado = t.cod_turma)) > 0"
	SQL = SQL & " order by 2"
	RS.OPEN SQL, CNN
	blnSemUnidadeTip = RS.EOF
%>
	<select name="cmbEmpresa" id="cmbEmpresa" class="form-control" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
	IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodEmpresa) = trim(rs("COD_EMPRESA")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("COD_EMPRESA")& " " & strSelecionado &">" & rs("empresa") & "&nbsp(" & rs("bairro")& ")</option> "  & vbcrlf
            rs.movenext
        wend
	end if
    rs.close
%>
</select>
<%if blnSemUnidadeTip and intCodPeriodoTip <> "0" then%>
<div class="text-danger mt-1" style="font-size:0.875rem"><i class="fal fa-ban"></i> Não há unidade disponível com vaga em <%=strAnoLetivoDestino%> para o período<%if intCodTurno <> "0" then%> e turno<%end if%> escolhido<%if intCodTurno <> "0" then%>s<%end if%>.</div>
<%end if%>