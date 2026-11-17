<%
'----------------------------------------------------------------------------
'	Funções compartilhadas do Remanejamento de turma
'	Tabela de controle: SCA_CONTROLE_REMANEJAMENTO
'	situacao_id_aluno_turma: R = Remanejado da turma | S = Reclassificação
'----------------------------------------------------------------------------

'Converte para número inteiro; retorna 0 se o valor não for numérico
function remNumero(ByVal valor)
	remNumero = 0
	if isnull(valor) then exit function
	valor = trim(cstr(valor))
	if valor <> "" and isnumeric(valor) then
		remNumero = clng(valor)
	end if
end function

'Nome curto da turma (ex.: 1B), usado nas marcações (rem. p/ 1B)
function remNomeTurma(ByVal turmaAluno, ByVal nomeTurma)
	dim strNome
	strNome = ""
	if not isnull(turmaAluno) then strNome = trim(turmaAluno)
	if not isnull(nomeTurma) then strNome = trim(strNome & " " & trim(nomeTurma))
	remNomeTurma = strNome
end function

'Converte a data do campo (aaaa-mm-dd ou dd/mm/aaaa) em Date
'Retorna Null se a data for inválida
function remData(ByVal valor)
	dim partes, ano, mes, dia
	remData = null
	valor = trim(valor & "")
	if valor = "" then exit function

	if instr(valor, "-") > 0 then
		partes = split(valor, "-")
		if ubound(partes) <> 2 then exit function
		ano = partes(0) : mes = partes(1) : dia = partes(2)
	elseif instr(valor, "/") > 0 then
		partes = split(valor, "/")
		if ubound(partes) <> 2 then exit function
		dia = partes(0) : mes = partes(1) : ano = partes(2)
	else
		exit function
	end if

	if not (isnumeric(ano) and isnumeric(mes) and isnumeric(dia)) then exit function
	ano = clng(ano) : mes = clng(mes) : dia = clng(dia)
	if ano < 1900 or mes < 1 or mes > 12 or dia < 1 or dia > 31 then exit function
	'DateSerial "corrige" datas inválidas (31/02 vira 03/03); por isso conferimos o resultado
	if day(dateserial(ano, mes, dia)) <> dia then exit function
	remData = dateserial(ano, mes, dia)
end function

'Formata a data para gravar no SQL Server (aaaammdd: funciona com qualquer idioma do servidor)
function remDataBD(ByVal data)
	dim dia, mes
	remDataBD = ""
	if isnull(data) or trim(data & "") = "" then exit function
	dia = day(data)
	mes = month(data)
	if len(dia) < 2 then dia = "0" & dia
	if len(mes) < 2 then mes = "0" & mes
	remDataBD = year(data) & mes & dia
end function

'Formata a data para o campo <input type="date"> (aaaa-mm-dd)
function remDataCampo(ByVal data)
	dim dia, mes
	remDataCampo = ""
	if isnull(data) or trim(data & "") = "" then exit function
	dia = day(data)
	mes = month(data)
	if len(dia) < 2 then dia = "0" & dia
	if len(mes) < 2 then mes = "0" & mes
	remDataCampo = year(data) & "-" & mes & "-" & dia
end function

'Formata a data para exibição (dd/mm/aaaa)
function remDataTela(ByVal data)
	dim dia, mes
	remDataTela = ""
	if isnull(data) or trim(data & "") = "" then exit function
	dia = day(data)
	mes = month(data)
	if len(dia) < 2 then dia = "0" & dia
	if len(mes) < 2 then mes = "0" & mes
	remDataTela = dia & "/" & mes & "/" & year(data)
end function

'SQL dos alunos de uma turma com a situação na turma e os remanejamentos
'	- rem_para_*: remanejamento EM QUE O ALUNO SAIU desta turma
'	- rem_de_*  : remanejamento EM QUE O ALUNO ENTROU nesta turma
function sqlAlunosRemanejamento(ByVal codTurma, ByVal anoLetivo, ByVal semestre)
	dim s
	s = ";WITH ALUNO_TURMA AS ("
	s = s & " SELECT AT.CODIGO, AT.COD_EMPRESA, AT.COD_ALUNO, AT.COD_TURMA, AT.ANO_LETIVO, AT.SEMESTRE, AT.SITUACAO,"
	s = s & " ROW_NUMBER() OVER (PARTITION BY AT.COD_ALUNO ORDER BY AT.CODIGO DESC) AS RN"
	s = s & " FROM SCA_ALUNO_TURMA AT"
	s = s & " WHERE AT.COD_EMPRESA = " & remNumero(session("CodEmpresa"))
	s = s & " AND AT.COD_TURMA = " & remNumero(codTurma)
	s = s & " AND AT.ANO_LETIVO = " & remNumero(anoLetivo)
	s = s & " AND AT.SEMESTRE = " & remNumero(semestre)
	s = s & " )"
	s = s & " SELECT X.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, X.SITUACAO AS SITUACAO_TURMA,"
	s = s & " ISNULL(ST.Desc_SituacaoAluno, 'ATIVO') AS Desc_SituacaoAluno,"
	s = s & " ISNULL(ST.Cod_SituacaoAluno, 1) AS Cod_SituacaoAluno,"
	s = s & " RP.codigo AS rem_para_codigo, RP.data_remanejamento AS rem_para_data,"
	s = s & " TP.TurmaAluno AS rem_para_turma_aluno, TP.NomeTurma AS rem_para_nome_turma,"
	s = s & " RD.codigo AS rem_de_codigo, RD.data_remanejamento AS rem_de_data,"
	s = s & " TD.TurmaAluno AS rem_de_turma_aluno, TD.NomeTurma AS rem_de_nome_turma"
	s = s & " FROM ALUNO_TURMA X"
	s = s & " INNER JOIN SCA_ALUNO A ON A.CODIGO = X.COD_ALUNO"
	s = s & " OUTER APPLY ("
	s = s & "   SELECT TOP 1 SS.Desc_SituacaoAluno, SS.Cod_SituacaoAluno"
	s = s & "   FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
	s = s & "   INNER JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
	s = s & "   WHERE CS.COD_EMPRESA = X.COD_EMPRESA AND CS.COD_ALUNO = X.COD_ALUNO AND CS.ANO_LETIVO = X.ANO_LETIVO"
	s = s & "   ORDER BY CS.CODIGO DESC"
	s = s & " ) ST"
	s = s & " OUTER APPLY ("
	s = s & "   SELECT TOP 1 R.codigo, R.data_remanejamento, R.cod_turma_atual"
	s = s & "   FROM SCA_CONTROLE_REMANEJAMENTO R"
	s = s & "   WHERE R.cod_aluno = X.COD_ALUNO AND R.cod_empresa = X.COD_EMPRESA AND R.ano_letivo = X.ANO_LETIVO"
	s = s & "   AND R.cod_turma_origem = X.COD_TURMA AND R.situacao_id_aluno_turma = 'R'"
	s = s & "   ORDER BY R.codigo DESC"
	s = s & " ) RP"
	s = s & " LEFT JOIN SCA_TURMA TP ON TP.Cod_Turma = RP.cod_turma_atual"
	s = s & " OUTER APPLY ("
	s = s & "   SELECT TOP 1 R.codigo, R.data_remanejamento, R.cod_turma_origem"
	s = s & "   FROM SCA_CONTROLE_REMANEJAMENTO R"
	s = s & "   WHERE R.cod_aluno = X.COD_ALUNO AND R.cod_empresa = X.COD_EMPRESA AND R.ano_letivo = X.ANO_LETIVO"
	s = s & "   AND R.cod_turma_atual = X.COD_TURMA AND R.situacao_id_aluno_turma = 'R'"
	s = s & "   ORDER BY R.codigo DESC"
	s = s & " ) RD"
	s = s & " LEFT JOIN SCA_TURMA TD ON TD.Cod_Turma = RD.cod_turma_origem"
	s = s & " WHERE X.RN = 1 AND X.SITUACAO IN ('A','R','T','D','C')"
	s = s & " ORDER BY A.NOMEALUNO"
	sqlAlunosRemanejamento = s
end function

'Texto da marcação para um aluno que saiu da turma (ex.: " (rem. p/ 1B)")
'Pode ser usada em outras telas (diário, notas, faltas, relatórios).
'Usa um recordset próprio para não interferir nos recordsets da página.
function textoRemanejamento(ByVal codAluno, ByVal codTurma, ByVal anoLetivo)
	dim rsRem, s
	textoRemanejamento = ""
	if remNumero(codAluno) = 0 or remNumero(codTurma) = 0 then exit function

	s = "SELECT TOP 1 T.TurmaAluno, T.NomeTurma"
	s = s & " FROM SCA_CONTROLE_REMANEJAMENTO R"
	s = s & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = R.cod_turma_atual"
	s = s & " WHERE R.cod_aluno = " & remNumero(codAluno)
	s = s & " AND R.cod_turma_origem = " & remNumero(codTurma)
	if remNumero(anoLetivo) > 0 then
		s = s & " AND R.ano_letivo = " & remNumero(anoLetivo)
	end if
	s = s & " AND R.situacao_id_aluno_turma = 'R'"
	s = s & " ORDER BY R.codigo DESC"

	set rsRem = Server.CreateObject("adodb.recordset")
	rsRem.open s, cnn
	if not rsRem.eof then
		textoRemanejamento = " (rem. p/ " & remNomeTurma(rsRem("TurmaAluno"), rsRem("NomeTurma")) & ")"
	end if
	rsRem.close
	set rsRem = nothing
end function

'============================================================================
'	MARCAÇÃO DO REMANEJAMENTO NAS OUTRAS TELAS (diário, notas, faltas, relatórios)
'	Só considera remanejamentos registrados em SCA_CONTROLE_REMANEJAMENTO.
'	Na turma de ORIGEM o aluno continua listado: "(rem. p/ 1B em dd/mm/aaaa)",
'	somente leitura e sem os dias a partir da data do remanejamento.
'	Na turma de DESTINO: "(rem. de 1A em dd/mm/aaaa)", sem os dias anteriores.
'============================================================================

'Condição SQL para as consultas que listam alunos por SCA_ALUNO_DISCIPLINA.
'Substitui  AD.COD_TURMA_REMANEJAMENTO = <turma>  e inclui, na turma de origem,
'os alunos remanejados (cujas disciplinas já estão na turma de destino).
'	aliasAD: alias da SCA_ALUNO_DISCIPLINA na consulta (ex.: "AD")
function remFiltroTurmaAD(ByVal aliasAD, ByVal codTurma)
	dim t
	t = remNumero(codTurma)
	remFiltroTurmaAD = "(" & aliasAD & ".COD_TURMA_REMANEJAMENTO = " & t & _
		" OR " & aliasAD & ".COD_TURMA_REMANEJAMENTO IN (" & _
		"SELECT RMF.cod_turma_atual FROM SCA_CONTROLE_REMANEJAMENTO RMF" & _
		" WHERE RMF.cod_aluno = " & aliasAD & ".COD_ALUNO" & _
		" AND RMF.cod_turma_origem = " & t & _
		" AND RMF.situacao_id_aluno_turma = 'R'))"
end function

'Lista de alunos da turma: a mesma de sqlAlunoTurma (SP_ListarAlunosTurma), mas com
'@incluir_remanejados = 1, que inclui os alunos remanejados DESTA turma
'(vínculo 'R' com registro em SCA_CONTROLE_REMANEJAMENTO).
'Ano anterior (histórico/fechamento): usa sqlAlunoTurma sem alteração.
'Usa as variáveis da página: strAnoLetivo, intSemestre, intCodSituacaoAluno.
'Requer o script banco/scripts/2026-10-24_SP_ListarAlunosTurma_remanejados.sql
function remSqlAlunoTurma(ByVal turma, ByVal alunos)
	dim intSem
	if TRIM(strAnoLetivo) <> TRIM(session("strAnoLetivo")) and Session("strBloqueiaFechamento") = "S" then
		remSqlAlunoTurma = sqlAlunoTurma(turma, alunos)
		exit function
	end if

	intSem = remNumero(intSemestre)
	if intSem = 0 then intSem = 3

	remSqlAlunoTurma = " exec SP_ListarAlunosTurma " & remNumero(Session("CodEmpresa")) & "," & remNumero(turma) & "," & remNumero(strAnoLetivo) & "," & intSem & "," & remNumero(intCodSituacaoAluno) & ",1"
end function

'Carrega os remanejamentos que envolvem a turma (como origem ou destino) no ano.
'Retorna um Scripting.Dictionary: chave = código do aluno (texto),
'valor = Array(tipo, data, nomeOutraTurma, eventos)
'	tipo/data/nome: do remanejamento MAIS RECENTE (define a situação atual na turma)
'	tipo "P" = saiu desta turma PARA outra | "D" = entrou nesta turma vindo DE outra
'	eventos: todos os remanejamentos do aluno nesta turma, em ordem de data,
'	         cada um Array(tipo, data, nome) - ex.: A -> B -> A gera P e depois D
function remCarregaTurma(ByVal codTurma, ByVal anoLetivo)
	dim dic, rsRm, s, t, chave, tipo, nome, dataRem, v, evs
	set dic = Server.CreateObject("Scripting.Dictionary")
	t = remNumero(codTurma)
	if t > 0 then
		s = "SELECT R.cod_aluno, R.cod_turma_origem, R.cod_turma_atual, R.data_remanejamento,"
		s = s & " TOR.TurmaAluno AS ori_turma_aluno, TOR.NomeTurma AS ori_nome_turma,"
		s = s & " TAT.TurmaAluno AS atu_turma_aluno, TAT.NomeTurma AS atu_nome_turma"
		s = s & " FROM SCA_CONTROLE_REMANEJAMENTO R"
		s = s & " LEFT JOIN SCA_TURMA TOR ON TOR.Cod_Turma = R.cod_turma_origem"
		s = s & " LEFT JOIN SCA_TURMA TAT ON TAT.Cod_Turma = R.cod_turma_atual"
		s = s & " WHERE R.situacao_id_aluno_turma = 'R'"
		s = s & " AND (R.cod_turma_origem = " & t & " OR R.cod_turma_atual = " & t & ")"
		if remNumero(anoLetivo) > 0 then s = s & " AND R.ano_letivo = " & remNumero(anoLetivo)
		s = s & " ORDER BY R.data_remanejamento, R.codigo"

		set rsRm = Server.CreateObject("adodb.recordset")
		rsRm.open s, cnn
		while not rsRm.eof
			chave = cstr(remNumero(rsRm.fields("cod_aluno").value))
			if remNumero(rsRm.fields("cod_turma_origem").value) = t then
				tipo = "P"
				nome = remNomeTurma(rsRm.fields("atu_turma_aluno").value, rsRm.fields("atu_nome_turma").value)
			else
				tipo = "D"
				nome = remNomeTurma(rsRm.fields("ori_turma_aluno").value, rsRm.fields("ori_nome_turma").value)
			end if
			dataRem = rsRm.fields("data_remanejamento").value
			if dic.Exists(chave) then
				v = dic(chave)
				evs = v(3)
				redim preserve evs(ubound(evs) + 1)
				evs(ubound(evs)) = Array(tipo, dataRem, nome)
			else
				evs = Array(Array(tipo, dataRem, nome))
			end if
			dic(chave) = Array(tipo, dataRem, nome, evs)
			rsRm.movenext
		wend
		rsRm.close
		set rsRm = nothing
	end if
	set remCarregaTurma = dic
end function

'Mesmo que remCarregaTurma, mas guarda o resultado por turma durante a página
'(útil quando a listagem tem alunos de várias turmas)
dim remCacheTurmas
function remDicTurma(ByVal codTurma, ByVal anoLetivo)
	dim chave
	if not isObject(remCacheTurmas) then set remCacheTurmas = Server.CreateObject("Scripting.Dictionary")
	chave = cstr(remNumero(codTurma)) & "|" & cstr(remNumero(anoLetivo))
	if not remCacheTurmas.Exists(chave) then
		remCacheTurmas.Add chave, remCarregaTurma(codTurma, anoLetivo)
	end if
	set remDicTurma = remCacheTurmas(chave)
end function

'Tipo do remanejamento do aluno na turma carregada: "P", "D" ou ""
function remTipoAluno(dic, ByVal codAluno)
	dim chave, v
	remTipoAluno = ""
	if not isObject(dic) then exit function
	chave = cstr(remNumero(codAluno))
	if dic.Exists(chave) then
		v = dic(chave)
		remTipoAluno = v(0)
	end if
end function

'Data do remanejamento do aluno (ou Null)
function remDataAluno(dic, ByVal codAluno)
	dim chave, v
	remDataAluno = null
	if not isObject(dic) then exit function
	chave = cstr(remNumero(codAluno))
	if dic.Exists(chave) then
		v = dic(chave)
		remDataAluno = v(1)
	end if
end function

'Texto da marcação, sem HTML: "(rem. p/ 1B em 24/10/2026)" ou "(rem. de 1A em 24/10/2026)"
'Mais de um remanejamento na turma: "(rem. p/ 1B em 10/03/2026; rem. de 1B em 05/05/2026)"
function remMarcacaoTexto(dic, ByVal codAluno)
	dim chave, v, evs, ev, i, txt
	remMarcacaoTexto = ""
	if not isObject(dic) then exit function
	chave = cstr(remNumero(codAluno))
	if not dic.Exists(chave) then exit function
	v = dic(chave)
	evs = v(3)
	txt = ""
	for i = 0 to ubound(evs)
		ev = evs(i)
		if txt <> "" then txt = txt & "; "
		if ev(0) = "P" then
			txt = txt & "rem. p/ " & ev(2) & " em " & remDataTela(ev(1))
		else
			txt = txt & "rem. de " & ev(2) & " em " & remDataTela(ev(1))
		end if
	next
	remMarcacaoTexto = "(" & txt & ")"
end function

'Marcação em HTML para colocar ao lado do nome do aluno
function remMarcacaoHtml(dic, ByVal codAluno)
	dim txt
	remMarcacaoHtml = ""
	txt = remMarcacaoTexto(dic, codAluno)
	if txt <> "" then remMarcacaoHtml = "&nbsp;<span class=""rem-marcacao"" style=""font-size: 9px; color: red;"">" & txt & "</span>"
end function

'True quando o aluno saiu desta turma (origem): só leitura nas telas de lançamento
function remSomenteLeitura(dic, ByVal codAluno)
	remSomenteLeitura = (remTipoAluno(dic, codAluno) = "P")
end function

'Converte Date ou texto (aaaa-mm-dd, aaaa/mm/dd, dd/mm/aaaa) em Date sem hora; Null se inválido
function remParaData(ByVal valor)
	dim partes
	remParaData = null
	if isnull(valor) then exit function
	if vartype(valor) = vbDate then
		remParaData = dateserial(year(valor), month(valor), day(valor))
		exit function
	end if
	valor = trim(valor & "")
	if instr(valor, " ") > 0 then valor = left(valor, instr(valor, " ") - 1)
	if instr(valor, "/") > 0 then
		partes = split(valor, "/")
		if ubound(partes) = 2 then
			if len(partes(0)) = 4 then valor = partes(0) & "-" & partes(1) & "-" & partes(2)
		end if
	end if
	remParaData = remData(valor)
end function

'True quando o dia NÃO pertence ao aluno nesta turma, considerando todos os remanejamentos:
'	saída (P): a partir da data o aluno está fora | entrada (D): a partir da data está dentro
'	ex.: A -> B em 10/03 e B -> A em 05/05: na turma A ficam fora os dias de 10/03 a 04/05
function remDiaForaDaTurma(dic, ByVal codAluno, ByVal data)
	dim chave, v, evs, ev, i, dt, dtEv, dentro
	remDiaForaDaTurma = false
	if not isObject(dic) then exit function
	chave = cstr(remNumero(codAluno))
	if not dic.Exists(chave) then exit function
	dt = remParaData(data)
	if isnull(dt) then exit function

	v = dic(chave)
	evs = v(3)
	'Antes do primeiro remanejamento: estava na turma se o primeiro foi uma SAÍDA (P)
	ev = evs(0)
	dentro = (ev(0) = "P")
	'A partir de cada data, a situação passa a ser a do remanejamento (D = entrou, P = saiu)
	for i = 0 to ubound(evs)
		ev = evs(i)
		dtEv = remParaData(ev(1))
		if not isnull(dtEv) then
			if dt >= dtEv then dentro = (ev(0) = "D")
		end if
	next
	remDiaForaDaTurma = not dentro
end function
%>
