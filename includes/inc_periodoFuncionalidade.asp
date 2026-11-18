<%
	'---------------------------------------------------------------------
	' Período de funcionamento das funcionalidades (MAT_CONFIGURACAO_PERIODO)
	' Configurado na tela app/mat_configuracao.asp (módulo Matrícula).
	'
	' periodoMensagem("RENOVACAO", Session("CodGrupo"))
	'	""        -> liberado (dentro do período, sem datas cadastradas ou tabela inexistente)
	'	"texto"   -> fora do período (mensagem para o usuário)
	'
	' Códigos: SITE_MATRICULA, EFETIVACAO, RENOVACAO, TIP, REMANEJAMENTO, AJUSTE_ALOCACAO, TRANSFERENCIA
	'---------------------------------------------------------------------
	'Funcionalidades controladas: código | descrição padrão | texto explicativo (tela de configurações)
	function periodoFuncionalidades()
		periodoFuncionalidades = array( _
			array("SITE_MATRICULA",	"Site da matrícula (inscrições)",	"Inscrições de alunos novatos pelo site (Educação Infantil e Ensino Fundamental)."), _
			array("EFETIVACAO",		"Efetivação",						"Confirmação da matrícula dos inscritos pela unidade escolar."), _
			array("RENOVACAO",		"Renovação",						"Renovação da matrícula dos alunos da rede para o próximo ano letivo."), _
			array("TIP",			"TIP - Transferência por interesse próprio",	"Transferência do aluno, a pedido da família, para outra unidade no próximo ano letivo."), _
			array("REMANEJAMENTO",	"Remanejamento",					"Troca de turma do aluno dentro da mesma unidade."), _
			array("AJUSTE_ALOCACAO","Ajuste de alocação",				"Ajuste da alocação dos alunos nas turmas."), _
			array("TRANSFERENCIA",	"Transferência",					"Recebimento de alunos transferidos de outras unidades.") )
	end function

	function periodoDataHora(ByVal valor)
		periodoDataHora = ""
		if isdate(valor) then
			periodoDataHora = right("0" & day(valor), 2) & "/" & right("0" & month(valor), 2) & "/" & year(valor)
			if hour(valor) <> 0 or minute(valor) <> 0 then periodoDataHora = periodoDataHora & " às " & right("0" & hour(valor), 2) & ":" & right("0" & minute(valor), 2)
		end if
	end function

	'Lista de perfis só com números e vírgulas ("42, 62" -> "42,62")
	function periodoListaPerfis(ByVal v)
		dim i, c, r
		r = ""
		v = replace(v & "", " ", "")
		for i = 1 to len(v)
			c = mid(v, i, 1)
			if (c >= "0" and c <= "9") or c = "," then r = r & c
		next
		do while instr(r, ",,") > 0 : r = replace(r, ",,", ",") : loop
		if left(r, 1) = "," then r = mid(r, 2)
		if right(r, 1) = "," then r = left(r, len(r) - 1)
		periodoListaPerfis = r
	end function

	'O usuário logado tem algum dos perfis (SEG_ACESSOS_USUARIO)?
	function periodoUsuarioTemPerfil(ByVal listaPerfis)
		dim rsPf
		periodoUsuarioTemPerfil = false
		listaPerfis = periodoListaPerfis(listaPerfis)
		if listaPerfis = "" or trim(Session("UsuarioWeb") & "") = "" then exit function
		on error resume next
		set rsPf = Server.CreateObject("adodb.recordset")
		rsPf.open "SELECT TOP 1 1 FROM SEG_ACESSOS_USUARIO WHERE Aces_Usua_Codg = '" & replace(Session("UsuarioWeb") & "", "'", "''") & "' AND Aces_Perf_Codg IN (" & listaPerfis & ")", cnn
		if err.number = 0 then periodoUsuarioTemPerfil = not rsPf.eof
		err.clear
		if rsPf.state <> 0 then rsPf.close
		set rsPf = nothing
		on error goto 0
	end function

	function periodoMensagem(ByVal funcionalidade, ByVal codGrupo)
		dim rsPer, s, dtIni, dtFim, desc, agora, perfis, blnPerfis
		periodoMensagem = ""
		funcionalidade = replace(trim(funcionalidade & ""), "'", "")
		if funcionalidade = "" then exit function
		'Modo de teste do site (matricula/teste.asp com a chave): libera o site só para esta sessão
		if ucase(funcionalidade) = "SITE_MATRICULA" and Session("MATRICULA_TESTE") = "S" then exit function
		if not isnumeric(codGrupo & "") or trim(codGrupo & "") = "" then codGrupo = 0
		'PERFIS_LIBERADOS: perfis que usam a funcionalidade mesmo fora do período
		'(banco/scripts/2026-11-04_periodo_perfis_liberados.sql; sem a coluna, segue sem essa liberação)
		blnPerfis = true
		s = "SELECT TOP 1 DESCRICAO, DATA_INICIO, DATA_FIM, PERFIS_LIBERADOS FROM MAT_CONFIGURACAO_PERIODO"
		s = s & " WHERE FUNCIONALIDADE = '" & funcionalidade & "'"
		if clng(codGrupo) > 0 then s = s & " ORDER BY CASE WHEN COD_GRUPO = " & clng(codGrupo) & " THEN 0 ELSE 1 END, CODIGO" else s = s & " ORDER BY CODIGO"

		on error resume next
		set rsPer = Server.CreateObject("adodb.recordset")
		rsPer.open s, cnn
		if err.number <> 0 then
			'coluna PERFIS_LIBERADOS ainda não criada: consulta sem ela
			err.clear
			blnPerfis = false
			rsPer.open replace(s, ", PERFIS_LIBERADOS", ""), cnn
		end if
		if err.number <> 0 then
			err.clear
			on error goto 0
			exit function		'tabela ainda não criada: não bloqueia
		end if
		on error goto 0

		if not rsPer.eof then
			desc = trim(rsPer("DESCRICAO") & "")
			dtIni = rsPer("DATA_INICIO")
			dtFim = rsPer("DATA_FIM")
			agora = now()
			if isdate(dtIni) then
				if agora < cdate(dtIni) then periodoMensagem = desc & ": disponível a partir de " & periodoDataHora(dtIni) & "."
			end if
			if periodoMensagem = "" and isdate(dtFim) then
				if agora > cdate(dtFim) then periodoMensagem = desc & ": período encerrado em " & periodoDataHora(dtFim) & "."
			end if
			if periodoMensagem <> "" and isdate(dtIni) and isdate(dtFim) then
				periodoMensagem = periodoMensagem & " Período: " & periodoDataHora(dtIni) & " a " & periodoDataHora(dtFim) & "."
			end if
			'fora do período, mas o usuário tem um perfil liberado: não bloqueia
			if periodoMensagem <> "" and blnPerfis then
				perfis = trim(rsPer("PERFIS_LIBERADOS") & "")
				if perfis <> "" then
					if periodoUsuarioTemPerfil(perfis) then periodoMensagem = ""
				end if
			end if
		end if
		rsPer.close
		set rsPer = nothing
	end function

	'Para as páginas de gravação (_cod): fora do período, avisa e volta
	sub periodoBloqueiaGravacao(ByVal funcionalidade)
		dim msg
		msg = periodoMensagem(funcionalidade, Session("CodGrupo"))
		if msg <> "" then
			response.write "<script>alert(""ATENÇÃO: nada foi gravado.\n\n" & replace(replace(msg, "\", "\\"), """", "\""") & """); window.history.back();</script>"
			response.end
		end if
	end sub
%>
