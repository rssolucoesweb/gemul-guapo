<%
	if strEmpresa_submit = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodTurnoTip = "" then intCodTurnoTip = "0"
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
	if intCodTurnoTip <> "0" then
		SQL = SQL & " and t.cod_turno = " & intCodTurnoTip
	end if
	SQL = SQL & " and t.Situacao = 'A'"
	'verifica vaga
	SQL = SQL & " and (t.capacidade - t.VagasReservadas - ("
	
	SQL = SQL & " select count(*) as qtde"	
	SQL = SQL & " from sca_aluno_turma at inner join sca_turma tu on tu.cod_turma = at.cod_turma"
	SQL = SQL & " where at.ano_letivo = " & strAnoLetivoDestino
	SQL = SQL & " and at.cod_turma = t.cod_turma"
	SQL = SQL & " and at.situacao = 'A'"
	
	SQL = SQL & " )) > 0"
	SQL = SQL & " order by 2"
	%>
	<select name="cmbEmpresaTip" id="cmbEmpresaTip" class="combo" <%=strFuncao%>>
    <option value="0">Selecione...</option>
    <%	
	
	RS.OPEN SQL, CNN
	IF RS.EOF = FALSE THEN
	    while not rs.eof
            if trim(intCodEmpresaTip) = trim(rs("COD_EMPRESA")) then
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